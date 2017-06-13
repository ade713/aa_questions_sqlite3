-- users
DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id INTEGER PRIMARY ,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL
);

INSERT INTO
  USERS (first_name, last_name)
VALUES
  ('Ade', 'Farquhar'), ('Nicholas', 'Bacon'), ('George', 'Clinton'), ('Janet', 'Lee');

-- questions
DROP TABLE IF EXISTS questions;
CREATE TABLE questions(
  id INTEGER PRIMARY KEY
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id) --users.id?
);

INSERT INTO
  questions (title, body, author_id)
SELECT
  'How many pineapples are there?' , 'There are so many more pineapples than I expected.', users.id
FROM
  users
WHERE
  users.first_name = 'Ade' AND
  users.last_name = 'Farquhar';

INSERT INTO
  questions (title, body, author_id)
SELECT
  'What is the third cosmological constant' , 'From how far can redshift be observed.', users.id
FROM
  users
WHERE
  users.first_name = 'Nicholas' AND
  users.last_name = 'Bacon';

INSERT INTO
  questions (title, body, author_id)
SELECT
  'How' , 'Magic', users.id
FROM
  users
WHERE
  users.first_name = 'George' AND
  users.last_name = 'Clinton';

INSERT INTO
  questions (title, body, author_id)
SELECT
  'Why' , 'Because', users.id
FROM
  users
WHERE
  users.first_name = 'Janet' AND
  users.last_name = 'Lee';

--question_follows
DROP TABLE IF EXISTS question_follows;
CREATE TABLE questions_follows(
  id PRIMARY KEY,
  user_id INTEGER NOT NULL ,
  questions_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE first_name = "Ade" AND last_name = "Farquhar"),
  (SELECT id FROM questions WHERE title = "How")),

  ((SELECT id FROM users WHERE first_name = "Nicholas" AND last_name = "Bacon"),
  (SELECT id FROM questions WHERE title = "How"),

  ((SELECT id FROM users WHERE first_name = "George" AND last_name = "Clinton"),
  (SELECT id FROM questions WHERE title = "How"),

  ((SELECT id FROM users WHERE first_name = "Janet" AND last_name = "Lee"),
  (SELECT id FROM questions WHERE title = "How")
);

--replies
DROP TABLE IF EXISTS replies;
CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER, -- not integer not null ?
  author_id INTEGER NOT NULL, --why author_id not user_id
  body TEXT NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "How"),
  (SELECT id FROM replies WHERE body = "How many pineapples are there?"), -- what is going on here?
  (SELECT id FROM users WHERE first_name = "Ade" AND last_name = "Farquhar"),
  "Dunno?"
);


INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "How"),
  (SELECT id FROM replies WHERE body = "What is the third cosmological constant?"),
  (SELECT id FROM users WHERE first_name = "Nicholas" AND last_name = "Bacon"),
  "Umm?"
);

INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "How"),
  Null,
  (SELECT id FROM users WHERE first_name = "George" AND last_name = "Clinton"),
  "...?"
);

INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "How"),
  (SELECT id FROM replies WHERE body = "Why"),
  (SELECT id FROM users WHERE first_name = "Janet" AND last_name = "Lee"),
  "Why how?"
);

--question_likes
DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE first_name = "Ade" AND last_name = 'Farquhar'),
    (SELECT id FROM questions WHERE title = "How")
  );

INSERT INTO question_likes (user_id, question_id) VALUES (1, 1);
INSERT INTO question_likes (user_id, question_id) VALUES (1, 2);
