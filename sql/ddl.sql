USE website;

DROP TABLE IF EXISTS logs;

DROP TABLE IF EXISTS equipment_student;

DROP TABLE IF EXISTS students;

DROP TABLE IF EXISTS admins;

DROP TABLE IF EXISTS equipment;

CREATE TABLE students (
    id INT AUTO_INCREMENT NOT NULL,
    username VARCHAR(30),
    passwordUser VARCHAR(30),
    email VARCHAR(50),
    PRIMARY KEY(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

CREATE TABLE admins (
    id INT AUTO_INCREMENT NOT NULL,
    username VARCHAR(30),
    passwordUser VARCHAR(30),
    email VARCHAR(50),
    PRIMARY KEY(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

CREATE TABLE equipment (
    id INT AUTO_INCREMENT NOT NULL,
    e_name VARCHAR(20) NOT NULL,
    e_description VARCHAR(200),
    e_status VARCHAR(10),
    deleted TIMESTAMP DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

CREATE TABLE equipment_student (
    e_id INT NOT NULL,
    s_id INT NOT NULL,
    booked TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    picked_up TIMESTAMP DEFAULT 0,
    returned TIMESTAMP DEFAULT 0,
    PRIMARY KEY (e_id, s_id),
    FOREIGN KEY (e_id) REFERENCES equipment(id),
    FOREIGN KEY (s_id) REFERENCES students(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

CREATE TABLE logs (
    id INT AUTO_INCREMENT NOT NULL,
    s_id INT,
    e_id INT,
    descriptions VARCHAR(100),
    PRIMARY KEY(id),
    FOREIGN KEY (s_id) REFERENCES students(id),
    FOREIGN KEY (e_id) REFERENCES equipment(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

-- TRIGGERED
DROP TRIGGER IF EXISTS equipment_booked;

DROP TRIGGER IF EXISTS equipment_student_update;

DELIMITER ;;

CREATE TRIGGER equipment_booked
AFTER
INSERT
    ON equipment_student FOR EACH ROW BEGIN
INSERT INTO
    logs (s_id, e_id, descriptions)
VALUES
    (NEW.e_id, NEW.s_id, "Booked equipment ");

END
;;

DELIMITER ;

DELIMITER ;;

CREATE TRIGGER equipment_student_update
AFTER
UPDATE
    ON equipment_student FOR EACH ROW 
BEGIN
IF NEW.returned != 0 THEN

INSERT INTO
    logs (s_id, e_id, descriptions)
VALUES
    (
        NEW.s_id,
        NEW.e_id,
        CONCAT(NEW.s_id, " returned ", NEW.e_id)
    );

END IF;

IF NEW.returned = 0 AND NEW.picked_up != 0 THEN

INSERT INTO
    logs (s_id, e_id, descriptions)
VALUES
    (
        NEW.s_id,
        NEW.e_id,
        CONCAT(NEW.s_id, " picked up ", NEW.e_id)
    );

END IF;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE TRIGGER equipment_picked_up
AFTER
UPDATE
    ON equipment FOR EACH ROW BEGIN
INSERT INTO
    logs (s_id, e_id, description)
VALUES
    (
        NEW.id,
        CONCAT(
            "Equipment status changed, Status: ",
            NEW.e_status
        )
    );

END
;;

DELIMITER ;

-- PRODECURES BABIEEE!!!!!!
DROP PROCEDURE IF EXISTS register_students;

DROP PROCEDURE IF EXISTS login_check_students;

DROP PROCEDURE IF EXISTS registerCheck_students;

DROP PROCEDURE IF EXISTS get_ID_students;

DROP PROCEDURE IF EXISTS register_admins;

DELIMITER ;;

CREATE PROCEDURE register_admins(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30),
    p_email VARCHAR(50)
) BEGIN
INSERT INTO
    admins (username, passwordUser, email)
VALUES
    (p_username, p_passwordUser, p_email);

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE register_students(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30),
    p_email VARCHAR(50)
) BEGIN
INSERT INTO
    students (username, passwordUser, email)
VALUES
    (p_username, p_passwordUser, p_email);

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE registerCheck_students(p_username VARCHAR(30)) BEGIN
SELECT
    *
FROM
    students
WHERE
    username = p_username;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE login_check_students(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30)
) BEGIN
SELECT
    *
FROM
    students
WHERE
    username = p_username
    AND passwordUser = p_passwordUser;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE get_ID_students(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30)
) BEGIN
SELECT
    id
FROM
    users
WHERE
    username = p_username
    AND passwordUser = p_passwordUser;

END
;;

DELIMITER ;