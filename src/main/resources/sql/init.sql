CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance NUMERIC(15, 2) DEFAULT 0
) IF NOT EXISTS;

INSERT INTO users (name, balance) VALUES
('Иван Иванов', 1500.50),
('Анна Петрова', 23500.00);

BEGIN;
`
`
SELECT * FROM users;

UPDATE users
SET balance = balance - 100
WHERE id = 1;

SELECT * FROM users;

COMMIT;

