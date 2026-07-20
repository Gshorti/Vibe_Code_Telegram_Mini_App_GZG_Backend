INSERT INTO topics (name) VALUES
    ('Строки'),
    ('Списки'),
    ('Циклы');

-- Строки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $$s = "hello"
print(s.upper())$$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('HELLO', true),
    ('hello', false),
    ('Hello', false),
    ('Error', false)
) AS opts(text, is_correct);

-- Строки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $$s = "abcdef"
print(s[1:4])$$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('bcd', true),
    ('abc', false),
    ('bcde', false),
    ('abcd', false)
) AS opts(text, is_correct);

-- Строки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $$s = "banana"
print(s.replace("a", "o", 2))$$
    FROM topics WHERE name = 'Строки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('bonona', true),
    ('bonono', false),
    ('banana', false),
    ('bonana', false)
) AS opts(text, is_correct);

-- Списки, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $$nums = [1, 2, 3]
nums.append(4)
print(nums)$$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('[1, 2, 3, 4]', true),
    ('[4, 1, 2, 3]', false),
    ('[1, 2, 3]', false),
    ('Error', false)
) AS opts(text, is_correct);

-- Списки, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $$a = [1, 2, 3]
b = a
b.append(4)
print(a)$$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('[1, 2, 3, 4]', true),
    ('[1, 2, 3]', false),
    ('Error', false),
    ('[4, 1, 2, 3]', false)
) AS opts(text, is_correct);

-- Списки, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $$nums = [3, 1, 4, 1, 5, 9]
print(sorted(set(nums)))$$
    FROM topics WHERE name = 'Списки'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('[1, 3, 4, 5, 9]', true),
    ('[3, 1, 4, 1, 5, 9]', false),
    ('[9, 5, 4, 3, 1]', false),
    ('Error', false)
) AS opts(text, is_correct);

-- Циклы, difficulty 1
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 1, $$total = 0
for i in range(5):
    total += i
print(total)$$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('10', true),
    ('15', false),
    ('5', false),
    ('Error', false)
) AS opts(text, is_correct);

-- Циклы, difficulty 2
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 2, $$result = []
for i in range(3):
    for j in range(2):
        result.append(i * j)
print(result)$$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('[0, 0, 0, 1, 0, 2]', true),
    ('[0, 1, 2, 0, 1, 2]', false),
    ('[0, 0, 0, 0, 0, 0]', false),
    ('Error', false)
) AS opts(text, is_correct);

-- Циклы, difficulty 3
WITH q AS (
    INSERT INTO questions (topic_id, difficulty, code_snippet)
    SELECT id, 3, $$n = 5
while n > 0:
    if n == 3:
        n -= 2
        continue
    print(n, end=" ")
    n -= 1$$
    FROM topics WHERE name = 'Циклы'
    RETURNING id
)
INSERT INTO answer_options (question_id, text, is_correct)
SELECT id, text, is_correct FROM q, (VALUES
    ('5 4 1 ', true),
    ('5 4 3 2 1 ', false),
    ('5 4 2 1 ', false),
    ('5 4 ', false)
) AS opts(text, is_correct);
