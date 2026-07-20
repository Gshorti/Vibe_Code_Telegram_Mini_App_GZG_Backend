-- Extra topics and questions. Generated and verified by executing each
-- snippet in Python 3: the option marked correct equals the real stdout.

INSERT INTO topics (name) VALUES
    ('Словари'),
    ('Функции'),
    ('Условия');

-- Строки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print("abc" + "def")$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$abcdef$opt$, true),
    ($opt$abc def$opt$, false),
    ($opt$abcdef $opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print(len("hello"))$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$5$opt$, true),
    ($opt$4$opt$, false),
    ($opt$6$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print("ha" * 3)$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$hahaha$opt$, true),
    ($opt$ha3$opt$, false),
    ($opt$ha ha ha$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print("HeLLo".lower())$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$hello$opt$, true),
    ($opt$HELLO$opt$, false),
    ($opt$heLLo$opt$, false),
    ($opt$Hello$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$print("hello"[::-1])$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$olleh$opt$, true),
    ($opt$hello$opt$, false),
    ($opt$holle$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$print("a,b,c".split(","))$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$['a', 'b', 'c']$opt$, true),
    ($opt$a b c$opt$, false),
    ($opt$['a,b,c']$opt$, false),
    ($opt$(a, b, c)$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$print("  hi  ".strip() + "!")$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$hi!$opt$, true),
    ($opt$  hi  !$opt$, false),
    ($opt$hi !$opt$, false),
    ($opt$  hi!$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$print("abcdef"[::2])$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$ace$opt$, true),
    ($opt$bdf$opt$, false),
    ($opt$abc$opt$, false),
    ($opt$abcdef$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$print("-".join(["a", "b", "c"]))$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$a-b-c$opt$, true),
    ($opt$abc-$opt$, false),
    ($opt$-abc$opt$, false),
    ($opt$a - b - c$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$print("abc".find("d"))$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$-1$opt$, true),
    ($opt$0$opt$, false),
    ($opt$None$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$x = 3.14159
print(f"{x:.2f}")$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$3.14$opt$, true),
    ($opt$3.1415$opt$, false),
    ($opt$3.142$opt$, false),
    ($opt$3.14159$opt$, false)
) AS opts(text, is_correct);

-- Строки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$print("aAbB".swapcase())$snip$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$AaBb$opt$, true),
    ($opt$aabb$opt$, false),
    ($opt$AABB$opt$, false),
    ($opt$aAbB$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$nums = [1, 2, 3]
print(nums[-1])$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$3$opt$, true),
    ($opt$1$opt$, false),
    ($opt$2$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print(len([1, [2, 3], 4]))$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$3$opt$, true),
    ($opt$4$opt$, false),
    ($opt$2$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print([1, 2] + [3])$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[1, 2, 3]$opt$, true),
    ($opt$[1, 2, [3]]$opt$, false),
    ($opt$[3, 1, 2]$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print(list("abc"))$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$['a', 'b', 'c']$opt$, true),
    ($opt$['abc']$opt$, false),
    ($opt$[abc]$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$nums = [1, 2, 3, 4]
print(nums[1:3])$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[2, 3]$opt$, true),
    ($opt$[2, 3, 4]$opt$, false),
    ($opt$[1, 2, 3]$opt$, false),
    ($opt$[3, 4]$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$print([x * 2 for x in range(4)])$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[0, 2, 4, 6]$opt$, true),
    ($opt$[2, 4, 6, 8]$opt$, false),
    ($opt$[0, 2, 4, 6, 8]$opt$, false),
    ($opt$[1, 2, 3, 4]$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$nums = [5, 3, 8]
nums.sort()
print(nums)$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[3, 5, 8]$opt$, true),
    ($opt$[8, 5, 3]$opt$, false),
    ($opt$[5, 3, 8]$opt$, false),
    ($opt$None$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$a = [1, 2, 3]
a.insert(1, 10)
print(a)$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[1, 10, 2, 3]$opt$, true),
    ($opt$[10, 1, 2, 3]$opt$, false),
    ($opt$[1, 2, 10, 3]$opt$, false),
    ($opt$[1, 2, 3, 10]$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$a = [1, 2, 3]
b = a[:]
b.append(4)
print(a)$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[1, 2, 3]$opt$, true),
    ($opt$[1, 2, 3, 4]$opt$, false),
    ($opt$[4]$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$m = [[0] * 2] * 2
m[0][0] = 1
print(m)$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[[1, 0], [1, 0]]$opt$, true),
    ($opt$[[1, 0], [0, 0]]$opt$, false),
    ($opt$[[1, 1], [0, 0]]$opt$, false),
    ($opt$[[0, 0], [0, 0]]$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$print([x for x in range(10) if x % 3 == 0])$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[0, 3, 6, 9]$opt$, true),
    ($opt$[3, 6, 9]$opt$, false),
    ($opt$[0, 3, 6]$opt$, false),
    ($opt$[1, 4, 7]$opt$, false)
) AS opts(text, is_correct);

-- Списки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$a = [3, 1, 2]
print(sorted(a, reverse=True))$snip$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[3, 2, 1]$opt$, true),
    ($opt$[1, 2, 3]$opt$, false),
    ($opt$[2, 1, 3]$opt$, false),
    ($opt$[3, 1, 2]$opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$for i in range(3):
    print(i, end="")$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$012$opt$, true),
    ($opt$123$opt$, false),
    ($opt$0 1 2$opt$, false),
    ($opt$0123$opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$n = 0
while n < 3:
    n += 1
print(n)$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$3$opt$, true),
    ($opt$2$opt$, false),
    ($opt$4$opt$, false),
    ($opt$0$opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$for c in "ab":
    print(c, end="-")$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$a-b-$opt$, true),
    ($opt$a-b$opt$, false),
    ($opt$-a-b$opt$, false),
    ($opt$ab-$opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$total = 1
for i in [2, 3]:
    total *= i
print(total)$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$6$opt$, true),
    ($opt$5$opt$, false),
    ($opt$1$opt$, false),
    ($opt$8$opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$for i in range(10):
    if i == 3:
        break
    print(i, end=" ")$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$0 1 2 $opt$, true),
    ($opt$0 1 2 3 $opt$, false),
    ($opt$1 2 3 $opt$, false),
    ($opt$0 1 2 3 4 $opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$total = 0
for i in range(5):
    if i == 2:
        continue
    total += i
print(total)$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$8$opt$, true),
    ($opt$10$opt$, false),
    ($opt$6$opt$, false),
    ($opt$7$opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$for i, c in enumerate("ab"):
    print(i, c, sep="", end=" ")$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$0a 1b $opt$, true),
    ($opt$1a 2b $opt$, false),
    ($opt$a0 b1 $opt$, false),
    ($opt$0 a 1 b $opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$for i in range(1, 10, 3):
    print(i, end=" ")$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$1 4 7 $opt$, true),
    ($opt$1 3 5 7 9 $opt$, false),
    ($opt$1 4 7 10 $opt$, false),
    ($opt$3 6 9 $opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$for i in range(3):
    pass
else:
    print("done")$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$done$opt$, true),
    ($opt$Ничего не выведет$opt$, false),
    ($opt$Error$opt$, false),
    ($opt$donedonedone$opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$for i in range(3):
    for j in range(3):
        if j == 1:
            break
        print(i, j, end=" ")$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$0 0 1 0 2 0 $opt$, true),
    ($opt$0 0 $opt$, false),
    ($opt$0 0 0 1 0 2 $opt$, false),
    ($opt$0 1 2 $opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$a, b = 0, 1
while a < 5:
    print(a, end=" ")
    a, b = b, a + b$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$0 1 1 2 3 $opt$, true),
    ($opt$0 1 2 3 4 $opt$, false),
    ($opt$1 1 2 3 5 $opt$, false),
    ($opt$0 1 1 2 3 5 $opt$, false)
) AS opts(text, is_correct);

-- Циклы, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$n = 234
s = 0
while n:
    s += n % 10
    n //= 10
print(s)$snip$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$9$opt$, true),
    ($opt$234$opt$, false),
    ($opt$24$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$d = {"a": 1}
print(d["a"])$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$1$opt$, true),
    ($opt$a$opt$, false),
    ($opt${'a': 1}$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$d = {"a": 1, "b": 2}
print(len(d))$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$2$opt$, true),
    ($opt$4$opt$, false),
    ($opt$1$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$d = {}
d["x"] = 5
print(d)$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt${'x': 5}$opt$, true),
    ($opt${x: 5}$opt$, false),
    ($opt${}$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print({"a": 1}.get("b", 0))$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$0$opt$, true),
    ($opt$None$opt$, false),
    ($opt$1$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$d = {"a": 1, "b": 2}
print(list(d.keys()))$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$['a', 'b']$opt$, true),
    ($opt$[1, 2]$opt$, false),
    ($opt$('a', 'b')$opt$, false),
    ($opt${'a', 'b'}$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$d = {"a": 1}
d.update({"b": 2})
print(d["b"])$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$2$opt$, true),
    ($opt$None$opt$, false),
    ($opt$Error$opt$, false),
    ($opt${'b': 2}$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$d = {"a": 1, "a": 2}
print(d)$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt${'a': 2}$opt$, true),
    ($opt${'a': 1}$opt$, false),
    ($opt${'a': 1, 'a': 2}$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$print(sum({"a": 1, "b": 2}.values()))$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$3$opt$, true),
    ($opt$ab$opt$, false),
    ($opt$Error$opt$, false),
    ($opt$12$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$print({x: x * x for x in range(3)})$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt${0: 0, 1: 1, 2: 4}$opt$, true),
    ($opt${1: 1, 2: 4, 3: 9}$opt$, false),
    ($opt${0: 0, 1: 1, 2: 4, 3: 9}$opt$, false),
    ($opt$[0, 1, 4]$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$s = "aba"
d = {}
for c in s:
    d[c] = d.get(c, 0) + 1
print(d)$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt${'a': 2, 'b': 1}$opt$, true),
    ($opt${'a': 1, 'b': 1}$opt$, false),
    ($opt${'b': 1, 'a': 2}$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$d = {"a": 1, "b": 2}
print(max(d, key=d.get))$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$b$opt$, true),
    ($opt$a$opt$, false),
    ($opt$2$opt$, false),
    ($opt$('b', 2)$opt$, false)
) AS opts(text, is_correct);

-- Словари, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$a = {"x": 1}
b = {"x": 2, "y": 3}
print({**a, **b})$snip$
    FROM topics WHERE name = 'Словари'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt${'x': 2, 'y': 3}$opt$, true),
    ($opt${'x': 1, 'y': 3}$opt$, false),
    ($opt${'x': 1, 'x': 2, 'y': 3}$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$def f(x):
    return x * 2

print(f(3))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$6$opt$, true),
    ($opt$3$opt$, false),
    ($opt$x * 2$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$def greet(name):
    return "Hi " + name

print(greet("Bob"))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$Hi Bob$opt$, true),
    ($opt$Hi name$opt$, false),
    ($opt$greet(Bob)$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$def f(x, y=10):
    return x + y

print(f(5))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$15$opt$, true),
    ($opt$5$opt$, false),
    ($opt$Error$opt$, false),
    ($opt$510$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$def bigger(a, b):
    return a if a > b else b

print(bigger(2, 7))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$7$opt$, true),
    ($opt$2$opt$, false),
    ($opt$True$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$def f(x):
    x * 2

print(f(3))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$None$opt$, true),
    ($opt$6$opt$, false),
    ($opt$3$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$def f(*args):
    return len(args)

print(f(1, 2, 3))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$3$opt$, true),
    ($opt$1$opt$, false),
    ($opt$(1, 2, 3)$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$def f(a, b):
    return a - b

print(f(b=1, a=5))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$4$opt$, true),
    ($opt$-4$opt$, false),
    ($opt$Error$opt$, false),
    ($opt$6$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$sq = lambda x: x ** 2
print(sq(4))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$16$opt$, true),
    ($opt$8$opt$, false),
    ($opt$4$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$def f(x, lst=[]):
    lst.append(x)
    return lst

f(1)
print(f(2))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$[1, 2]$opt$, true),
    ($opt$[2]$opt$, false),
    ($opt$[1]$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$def make_adder(n):
    def add(x):
        return x + n
    return add

add5 = make_adder(5)
print(add5(3))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$8$opt$, true),
    ($opt$3$opt$, false),
    ($opt$5$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$x = 1

def f():
    x = 2

f()
print(x)$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$1$opt$, true),
    ($opt$2$opt$, false),
    ($opt$None$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Функции, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$def f(n):
    return 1 if n <= 1 else n * f(n - 1)

print(f(4))$snip$
    FROM topics WHERE name = 'Функции'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$24$opt$, true),
    ($opt$4$opt$, false),
    ($opt$10$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$x = 5
if x > 3:
    print("big")
else:
    print("small")$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$big$opt$, true),
    ($opt$small$opt$, false),
    ($opt$Ничего не выведет$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print(10 > 9)$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$True$opt$, true),
    ($opt$False$opt$, false),
    ($opt$1$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$x = 7
print("even" if x % 2 == 0 else "odd")$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$odd$opt$, true),
    ($opt$even$opt$, false),
    ($opt$7$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $snip$print(bool(""))$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$False$opt$, true),
    ($opt$True$opt$, false),
    ($opt$Error$opt$, false),
    ($opt$None$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$x = 5
print(1 < x < 10)$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$True$opt$, true),
    ($opt$False$opt$, false),
    ($opt$Error$opt$, false),
    ($opt$5$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$print(0 or "default")$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$default$opt$, true),
    ($opt$0$opt$, false),
    ($opt$True$opt$, false),
    ($opt$False$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$x = None
print(x is None)$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$True$opt$, true),
    ($opt$False$opt$, false),
    ($opt$None$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $snip$x = 0
if x > 0:
    print("pos")
elif x < 0:
    print("neg")
else:
    print("zero")$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$zero$opt$, true),
    ($opt$pos$opt$, false),
    ($opt$neg$opt$, false),
    ($opt$Ничего не выведет$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$print(True + True)$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$2$opt$, true),
    ($opt$True$opt$, false),
    ($opt$TrueTrue$opt$, false),
    ($opt$Error$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$print(2 and 3)$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$3$opt$, true),
    ($opt$2$opt$, false),
    ($opt$True$opt$, false),
    ($opt$False$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$a = [1]
b = [1]
print(a == b, a is b)$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$True False$opt$, true),
    ($opt$True True$opt$, false),
    ($opt$False False$opt$, false),
    ($opt$False True$opt$, false)
) AS opts(text, is_correct);

-- Условия, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $snip$print(bool("False"))$snip$
    FROM topics WHERE name = 'Условия'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ($opt$True$opt$, true),
    ($opt$False$opt$, false),
    ($opt$Error$opt$, false),
    ($opt$None$opt$, false)
) AS opts(text, is_correct);
