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
    act_number      INTEGER NOT NULL,
    theater_play_id INTEGER NOT NULL,
    role_id         INTEGER NOT NULL,
    FOREIGN KEY (act_number, theater_play_id) REFERENCES act (act_number, theater_play_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES role (role_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (act_number, theater_play_id, role_id)
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
    show_time       TEXT    NOT NULL,
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

INSERT INTO theater_hall(hall_id, name, number_of_seats)
VALUES (1, 'Hovedscenen', 516),
       (2, 'Gamle Scene', 332);

INSERT INTO theater_play(theater_play_id, hall_id, name)
VALUES (1, 1, 'Kongsemnene'),
       (2, 2, 'Størst av alt er kjærligheten');

INSERT INTO show(show_date, show_time, theater_play_id)
VALUES ('2024-02-01', '19:00', 1),
       ('2024-02-02', '19:00', 1),
       ('2024-02-03', '19:00', 1),
       ('2024-02-05', '19:00', 1),
       ('2024-02-06', '19:00', 1),
       ('2024-02-03', '18:30', 2),
       ('2024-02-06', '18:30', 2),
       ('2024-02-07', '18:30', 2),
       ('2024-02-12', '18:30', 2),
       ('2024-02-13', '18:30', 2),
       ('2024-02-14', '18:30', 2);

INSERT INTO act(act_number, theater_play_id, name)
VALUES (1, 1, 'Akt 1'),
       (2, 1, 'Akt 2'),
       (3, 1, 'Akt 3'),
       (4, 1, 'Akt 4'),
       (5, 1, 'Akt 5'),
       (1, 2, 'Hovedakt');

INSERT INTO role(role_id, name)
VALUES (1, 'Haakon Haakonssønn'),
       (2, 'Inga fra Vartejg'),
       (3, 'Skule Jarl'),
       (4, 'Fru Ragnhild'),
       (5, 'Margrete'),
       (6, 'Sigrid'),
       (7, 'Ingebjørg'),
       (8, 'Biskop Nikolas'),
       (9, 'Gregorius Jonssønn'),
       (10, 'Paal Flida'),
       (11, 'Baard Bratte'),
       (12, 'Jargeir Skald'),
       (13, 'Dagfinn Bonde'),
       (14, 'Peter'),
       (15, 'Sunniva Du Mond Nordal'),
       (16, 'Jo Saberniak'),
       (17, 'Marte M. Steinholt'),
       (18, 'Tor Ivar Hagen'),
       (19, 'Trond-Ove Skrødal'),
       (20, 'Natalie Grøndahl Tangen'),
       (21, 'Åsmund Flaten');

INSERT INTO performer(performer_id, name, email, employee_status)
VALUES (1, 'Arturo Scotti', 'arturo.scotti@trondelag-teater.no', 'Full-time'),
       (2, 'Ingunn Beate Strige Øyen', 'ingunn.beate.strige.øyen@trondelag-teater.no', 'Part-time'),
       (3, 'Hans Petter Nilsen', 'hans.petter.nilsen@trondelag-teater.no', 'Hired'),
       (4, 'Madeleine Brandtzæg Nilsen', 'madeleine.brandtzæg.nilsen@trondelag-teater.no', 'Part-time'),
       (5, 'Synnøve Fossum Eriksen', 'synnove.fossum.eriksen@trondelag-teater.no', 'Full-time'),
       (6, 'Emma Caroline Deichmann', 'emma.caroline.deichmann@trondelag-teater.no', 'Part-time'),
       (7, 'Thomas Jensen Takyi', 'thomas.jensen.takyi@trondelag-teater.no', 'Part-time'),
       (8, 'Per Bogstad Gulliksen', 'per.bogstad.gulliksen@trondelag-teater.no', 'Full-time'),
       (9, 'Isak Holmen Sørensen', 'isak.holmen.sorensen@trondelag-teater.no', 'Full-time'),
       (10, 'Fabian Heidelberg Lunde', 'fabian.heidelberg.lunde@trondelag-teater.no', 'Part-time'),
       (11, 'Emil Olafsson', 'emil.olafsson@trondelag-teater.no', 'Voluntary'),
       (12, 'Snorre Ryen Tøndel', 'snorre.ryen.tondel@trondelag-teater.no', 'Full-time'),
       (13, 'Sunniva Du Mond Nordal', 'sunniva.du.mond.nordal@trondelag-teater.no', 'Hired'),
       (14, 'Jo Saberniak', 'jo.saberniak@trondelag-teater.no', 'Full-time'),
       (15, 'Marte M. Steinholt', 'marte.m.steinholt@trondelag-teater.no', 'Full-time'),
       (16, 'Tor Ivar Hagen', 'tor.ivar.hagen@trondelag-teater.no', 'Full-time'),
       (17, 'Trond-Ove Skrødal', 'trond.ove.skrodal@trondelag-teater.no', 'Voluntary'),
       (18, 'Natalie Grøndahl Tangen', 'natalie.grondahl.tangen@trondelag-teater.no', 'Full-time'),
       (19, 'Åsmund Flaten', 'asmund.flaten@trondelag-teater.no', 'Part-time');

INSERT INTO contributor(contributor_id, name, phone_number, email, employee_status, task)
VALUES (1, 'Yury Butusov', '+4774764929', 'yury.butusov@trondelag-teater.no', 'Full-time',
        'Direction & Music Selection'),
       (2, 'Aleksandr Shishkin-Hokusai', '+4748646327', 'aleksandr.shishkin-hokusai@trondelag-teater.no', 'Part-time',
        'Scenography & Costumes'),
       (3, 'Eivind Myren', '+4752706108', 'eivind.myren@trondelag-teater.no', 'Part-time', 'Lighting Design'),
       (4, 'Mina Rype Stokke', '+4774764921', 'mina.rype.stokke@trondelag-teater.no', 'Full-time', 'Dramaturgy'),
       (5, 'Jonas Corell Petersen', '+4771769439', 'jonas.corell.petersen@trondelag-teater.no', 'Hired', 'Direction'),
       (6, 'David Ghert', '+4757089131', 'david.ghert@trondelag-teater-no', 'Part-time', 'Scenography & Costumes'),
       (7, 'Gaute Trønder', '+4775239148', 'gaute.tronder@trondelag-teater.no', 'Voluntary', 'Music Director'),
       (8, 'Magnus Mikaelsen', '+4741198148', 'magnus.mikaelsen@trondelag_teater.no', 'Part-time', 'Lighting Design'),
       (9, 'Kristoffer Spender', '+4774764921', 'kristoffer.spender@trondelag-teater.no', 'Hired', 'Dramaturgy');

INSERT INTO working_with(theater_play_id, contributor_id)
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (1, 4),
       (2, 5),
       (2, 6),
       (2, 7),
       (2, 8),
       (2, 9);

INSERT INTO plays_act(theater_play_id, act_number, role_id)
VALUES (1, 1, 1),
       (1, 2, 1),
       (1, 3, 1),
       (1, 4, 1),
       (1, 5, 1),
       (1, 1, 13),
       (1, 2, 13),
       (1, 3, 13),
       (1, 4, 13),
       (1, 5, 13),
       (1, 4, 12),
       (1, 1, 6),
       (1, 2, 6),
       (1, 5, 6),
       (1, 4, 7),
       (1, 1, 3),
       (1, 2, 3),
       (1, 3, 3),
       (1, 4, 3),
       (1, 5, 3),
       (1, 1, 2),
       (1, 3, 2),
       (1, 1, 10),
       (1, 2, 10),
       (1, 3, 10),
       (1, 4, 10),
       (1, 5, 10),
       (1, 1, 4),
       (1, 5, 4),
       (1, 1, 9),
       (1, 2, 9),
       (1, 3, 9),
       (1, 4, 9),
       (1, 5, 9),
       (1, 1, 5),
       (1, 2, 5),
       (1, 3, 5),
       (1, 4, 5),
       (1, 5, 5),
       (1, 1, 8),
       (1, 2, 8),
       (1, 3, 8),
       (1, 3, 14),
       (1, 4, 14),
       (1, 5, 14),
       (2, 1, 15),
       (2, 1, 16),
       (2, 1, 17),
       (2, 1, 18),
       (2, 1, 19),
       (2, 1, 20),
       (2, 1, 21);


INSERT INTO played_by(role_id, performer_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (6, 6),
       (7, 6),
       (8, 7),
       (9, 8),
       (10, 9),
       (11, 10),
       (12, 11),
       (13, 11),
       (14, 12),
       (15, 13),
       (16, 14),
       (17, 15),
       (18, 16),
       (19, 17),
       (20, 18),
       (21, 19);