CREATE TABLE IF NOT EXISTS theater_hall
(
    hall_id         INTEGER PRIMARY KEY,
    name            TEXT    NOT NULL,
    number_of_seats INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS theater_play
(
    theater_play_id INTEGER PRIMARY KEY,
    hall_id         INTEGER NOT NULL,
    name            TEXT    NOT NULL,
    FOREIGN KEY (hall_id) REFERENCES theater_hall (hall_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chair
(
    chair_number INTEGER NOT NULL,
    chair_row    INTEGER NOT NULL,
    area         TEXT    NOT NULL,
    hall_id      INTEGER NOT NULL,
    is_available INTEGER NOT NULL,
    FOREIGN KEY (hall_id) REFERENCES theater_hall (hall_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (chair_number, chair_row, area, hall_id)
);

CREATE TABLE IF NOT EXISTS role
(
    role_id INTEGER PRIMARY KEY,
    name    TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ticket_group
(
    ticket_group_name INTEGER NOT NULL,
    theater_play_id   INTEGER NOT NULL,
    FOREIGN KEY (theater_play_id) REFERENCES theater_play (theater_play_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (ticket_group_name, theater_play_id)
);

CREATE TABLE IF NOT EXISTS act
(
    act_number      INTEGER NOT NULL,
    theater_play_id INTEGER NOT NULL,
    name            TEXT    NOT NULL,
    FOREIGN KEY (theater_play_id) REFERENCES theater_play (theater_play_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (act_number, theater_play_id)
);

CREATE TABLE IF NOT EXISTS plays_act
(
    act_number INTEGER NOT NULL,
    role_id    INTEGER NOT NULL,
    FOREIGN KEY (act_number) REFERENCES act (act_number)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES role (role_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (act_number, role_id)
);

CREATE TABLE IF NOT EXISTS played_by
(
    role_id      INTEGER NOT NULL,
    performer_id INTEGER NOT NULL,
    FOREIGN KEY (role_id) REFERENCES role (role_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (performer_id) REFERENCES performer (performer_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS performer
(
    performer_id    INTEGER PRIMARY KEY,
    name            TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    employee_status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS contributor
(
    contributor_id  INTEGER PRIMARY KEY,
    name            TEXT NOT NULL,
    phone_number    TEXT NOT NULL UNIQUE,
    email           TEXT NOT NULL UNIQUE,
    employee_status TEXT NOT NULL,
    task            TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS customer
(
    customer_id  INTEGER PRIMARY KEY,
    phone_number TEXT NOT NULL UNIQUE,
    name         TEXT NOT NULL,
    address      TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS show
(
    show_date       TEXT PRIMARY KEY,
    theater_play_id INTEGER NOT NULL,
    FOREIGN KEY (theater_play_id) REFERENCES theater_play (theater_play_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (show_date, theater_play_id)
);

CREATE TABLE IF NOT EXISTS ticket_transaction
(
    transaction_id   INTEGER PRIMARY KEY,
    theater_play_id  INTEGER NOT NULL,
    customer_id      INTEGER NOT NULL,
    show_date        TEXT    NOT NULL,
    transaction_date TEXT    NOT NULL,
    transaction_time TEXT    NOT NULL,
    FOREIGN KEY (show_date, theater_play_id) REFERENCES show (show_date, theater_play_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ticket
(
    ticket_id         INTEGER PRIMARY KEY,
    show_date         TEXT    NOT NULL,
    theater_play_id   INTEGER NOT NULL,
    transaction_id    INTEGER NOT NULL,
    ticket_group_name TEXT    NOT NULL,
    chair_number      INTEGER NOT NULL,
    chair_row         INTEGER NOT NULL,
    area              TEXT    NOT NULL,
    FOREIGN KEY (show_date, theater_play_id) REFERENCES show (show_date, theater_play_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (transaction_id) REFERENCES ticket_transaction (transaction_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (ticket_group_name, theater_play_id) REFERENCES ticket_group (ticket_group_name, theater_play_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS working_with
(
    theater_play_id INTEGER NOT NULL,
    contributor_id  INTEGER NOT NULL,
    FOREIGN KEY (theater_play_id) REFERENCES theater_play (theater_play_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (contributor_id) REFERENCES contributor (contributor_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (theater_play_id, contributor_id)
);

