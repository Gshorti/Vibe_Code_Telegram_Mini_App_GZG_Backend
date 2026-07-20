package handler

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"net/http"
	"net/url"
	"sort"
	"strconv"
	"strings"
	"time"
)

var (
	errMissingAuth = errors.New("missing telegram initData")
	errInvalidHash = errors.New("invalid telegram initData signature")
	errStaleAuth   = errors.New("telegram initData expired")
	errMissingUser = errors.New("telegram initData missing user")
	maxInitDataAge = 24 * time.Hour
)

type ctxKey int

const userIDCtxKey ctxKey = 1

// validateInitData verifies a Telegram Mini App initData string against the
// bot token, following the algorithm described at
// https://core.telegram.org/bots/webapps#validating-data-received-via-the-mini-app
// and returns the Telegram user id encoded in it.
func validateInitData(botToken, initData string) (int64, error) {
	values, err := url.ParseQuery(initData)
	if err != nil {
		return 0, errInvalidHash
	}

	receivedHash := values.Get("hash")
	if receivedHash == "" {
		return 0, errInvalidHash
	}
	values.Del("hash")

	keys := make([]string, 0, len(values))
	for k := range values {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	pairs := make([]string, 0, len(keys))
	for _, k := range keys {
		pairs = append(pairs, k+"="+values.Get(k))
	}
	dataCheckString := strings.Join(pairs, "\n")

	secretKey := hmac.New(sha256.New, []byte("WebAppData"))
	secretKey.Write([]byte(botToken))

	mac := hmac.New(sha256.New, secretKey.Sum(nil))
	mac.Write([]byte(dataCheckString))
	computedHash := hex.EncodeToString(mac.Sum(nil))

	if !hmac.Equal([]byte(computedHash), []byte(receivedHash)) {
		return 0, errInvalidHash
	}

	if authDateStr := values.Get("auth_date"); authDateStr != "" {
		authDateUnix, err := strconv.ParseInt(authDateStr, 10, 64)
		if err != nil {
			return 0, errInvalidHash
		}
		if time.Since(time.Unix(authDateUnix, 0)) > maxInitDataAge {
			return 0, errStaleAuth
		}
	}

	userJSON := values.Get("user")
	if userJSON == "" {
		return 0, errMissingUser
	}
	var user struct {
		ID int64 `json:"id"`
	}
	if err := json.Unmarshal([]byte(userJSON), &user); err != nil || user.ID == 0 {
		return 0, errMissingUser
	}

	return user.ID, nil
}

// requireAuth validates the Telegram initData from the Authorization header
// ("tma <initData>"), resolves/creates the corresponding user, and stores
// the internal user id in the request context.
func (h *Handler) requireAuth(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		auth := r.Header.Get("Authorization")
		const prefix = "tma "
		if !strings.HasPrefix(auth, prefix) {
			writeError(w, http.StatusUnauthorized, errMissingAuth)
			return
		}
		initData := strings.TrimPrefix(auth, prefix)

		telegramID, err := validateInitData(h.botToken, initData)
		if err != nil {
			writeError(w, http.StatusUnauthorized, err)
			return
		}

		userID, err := h.service.ResolveUser(r.Context(), telegramID)
		if err != nil {
			writeError(w, http.StatusInternalServerError, err)
			return
		}

		ctx := context.WithValue(r.Context(), userIDCtxKey, userID)
		next(w, r.WithContext(ctx))
	}
}

func userIDFromContext(ctx context.Context) (int64, bool) {
	id, ok := ctx.Value(userIDCtxKey).(int64)
	return id, ok
}
