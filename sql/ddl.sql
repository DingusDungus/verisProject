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
    e_status VARCHAR(10) DEFAULT "Free",
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
    ON equipment_student FOR EACH ROW BEGIN
INSERT INTO
    logs (s_id, e_id)
VALUES
    (
        NEW.s_id, NEW.e_id
    );

END
;;

DELIMITER ;

-- PRODECURES BABIEEE!!!!!!
DROP PROCEDURE IF EXISTS register_students;

DROP PROCEDURE IF EXISTS login_check_students;

DROP PROCEDURE IF EXISTS login_check_admins;

DROP PROCEDURE IF EXISTS registerCheck_students;

DROP PROCEDURE IF EXISTS get_ID_students;

DROP PROCEDURE IF EXISTS register_admins;

DROP PROCEDURE IF EXISTS equipment_add_test;

DROP PROCEDURE IF EXISTS equipment_add;

DROP PROCEDURE IF EXISTS equipment_remove;

DROP PROCEDURE IF EXISTS equipment_show;

DROP PROCEDURE IF EXISTS equipment_modify;

DROP PROCEDURE IF EXISTS equipment_search;

DROP PROCEDURE IF EXISTS equipment_info_get;


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

DELIMITER ;;

CREATE PROCEDURE login_check_admins(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30)
) BEGIN
SELECT
    *
FROM
    admins
WHERE
    username = p_username
    AND passwordUser = p_passwordUser;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_add(
    p_name VARCHAR(30),
    p_description VARCHAR(200)
    ) BEGIN
INSERT INTO
    equipment (e_name, e_description)
VALUES
    (p_name, p_description);

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_add_test() BEGIN
SELECT
    *
FROM
    equipment
WHERE
    e_name = "Scalpel" 
    AND 
    e_description = "Sharp blade made for cutting things";

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_remove(
    p_id INT
) BEGIN

UPDATE equipment SET 
        deleted = NOW()
    WHERE id = p_id;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_show() BEGIN
SELECT
    *
FROM
    equipment
WHERE
    deleted = 0
    ;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_modify(
    p_id INT,
    p_name VARCHAR(20),
    p_description VARCHAR(200)
) BEGIN

UPDATE equipment SET 
        e_name = p_name, e_description = p_description
    WHERE id = p_id;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_search(
    search VARCHAR(200)
) BEGIN
SELECT
    *
FROM
    equipment
WHERE
    e_name LIKE CONCAT("%", search, "%") OR id LIKE CONCAT("%", search, "%") OR e_description LIKE CONCAT("%", search, "%")
    ;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_info_get(
    p_id INT
) BEGIN
SELECT
    *
FROM
    equipment
WHERE
    id = p_id;

END
;;

DELIMITER ;
