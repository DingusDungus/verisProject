USE website;

DROP TABLE IF EXISTS logs_students;

DROP TABLE IF EXISTS logs_admins;

DROP TABLE IF EXISTS equipment_admin;

DROP TABLE IF EXISTS equipment_student;

DROP TABLE IF EXISTS admins;

DROP TABLE IF EXISTS students;

DROP TABLE IF EXISTS equipment;

DROP TABLE IF EXISTS super_user;

CREATE TABLE super_user (
    username VARCHAR(30) DEFAULT "superUser",
    passwordUser VARCHAR(64) DEFAULT SHA2("password", "256")
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

INSERT INTO
    super_user(username)
VALUES
    ("superUser")
    ;

CREATE TABLE students (
    id INT AUTO_INCREMENT NOT NULL,
    username VARCHAR(30),
    passwordUser VARCHAR(64),
    email VARCHAR(50),
    deleted TIMESTAMP DEFAULT 0,
    PRIMARY KEY(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

CREATE TABLE admins (
    id INT AUTO_INCREMENT NOT NULL,
    username VARCHAR(30),
    passwordUser VARCHAR(64),
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
    id INT AUTO_INCREMENT NOT NULL,
    e_id INT NOT NULL,
    s_id INT NOT NULL,
    booked TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    picked_up TIMESTAMP DEFAULT 0,
    returned TIMESTAMP DEFAULT 0,
    PRIMARY KEY (id),
    FOREIGN KEY (e_id) REFERENCES equipment(id),
    FOREIGN KEY (s_id) REFERENCES students(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

CREATE TABLE equipment_admin (
    id INT AUTO_INCREMENT NOT NULL,
    e_id INT NOT NULL,
    a_id INT NOT NULL,
    reserved TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (e_id) REFERENCES equipment(id),
    FOREIGN KEY (a_id) REFERENCES admins(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

CREATE TABLE logs_students (
    id INT AUTO_INCREMENT NOT NULL,
    s_id INT,
    e_id INT,
    descriptions VARCHAR(100),
    PRIMARY KEY(id),
    FOREIGN KEY (s_id) REFERENCES students(id),
    FOREIGN KEY (e_id) REFERENCES equipment(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

CREATE TABLE logs_admins (
    id INT AUTO_INCREMENT NOT NULL,
    a_id INT,
    e_id INT,
    descriptions VARCHAR(100),
    PRIMARY KEY(id),
    FOREIGN KEY (a_id) REFERENCES admins(id),
    FOREIGN KEY (e_id) REFERENCES equipment(id)
) ENGINE INNODB CHARSET utf8 COLLATE utf8_swedish_ci;

-- TRIGGERED
DROP TRIGGER IF EXISTS update_status_student;
DROP TRIGGER IF EXISTS insert_status_student;
DROP TRIGGER IF EXISTS update_status_admin;
DROP TRIGGER IF EXISTS insert_status_admin;

DELIMITER ;;

CREATE TRIGGER update_status_student
AFTER UPDATE
ON equipment_student 
FOR EACH ROW
BEGIN
    INSERT INTO logs_students(s_id, e_id, descriptions) 
        VALUES(NEW.s_id, NEW.e_id, CONCAT("Student action; Status changed for item, status is: ", (SELECT e_status FROM equipment WHERE id = OLD.e_id)))
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE TRIGGER insert_status_student
AFTER INSERT
ON equipment_student 
FOR EACH ROW
BEGIN
    INSERT INTO logs_students(s_id, e_id, descriptions) 
        VALUES(NEW.s_id, NEW.e_id, "Item has been booked by student")
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE TRIGGER update_status_admin
AFTER UPDATE
ON equipment_admin
FOR EACH ROW
BEGIN
    INSERT INTO logs_admins(a_id, e_id, descriptions) 
        VALUES(NEW.a_id, NEW.e_id, CONCAT("Admin action; Status changed for item, status is: ", (SELECT e_status FROM equipment WHERE id = OLD.e_id)))
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE TRIGGER insert_status_admin
AFTER INSERT
ON equipment_admin
FOR EACH ROW
BEGIN
    INSERT INTO logs_admins(a_id, e_id, descriptions) 
        VALUES(NEW.a_id, NEW.e_id, "Item has been reserved by admin")
    ;
END
;;

DELIMITER ;


-- PRODECURES BABIEEE!!!!!!
DROP PROCEDURE IF EXISTS pick_up;

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

DROP PROCEDURE IF EXISTS show_booked;

DROP PROCEDURE IF EXISTS equipment_book;

DROP PROCEDURE IF EXISTS show_booked_dates;

DROP PROCEDURE IF EXISTS get_account_info;

DROP PROCEDURE IF EXISTS registerCheck_admins;

DROP PROCEDURE IF EXISTS checkForAvailability;

DROP PROCEDURE IF EXISTS decreaseAvailable;

DROP PROCEDURE IF EXISTS showBookedForStudent;

DROP PROCEDURE IF EXISTS showPickupReady;

DROP PROCEDURE IF EXISTS e_return;

DROP PROCEDURE IF EXISTS showReturnableAndOverdue;

DROP PROCEDURE IF EXISTS equipment_reserve;

DROP PROCEDURE IF EXISTS e_return_admin;

DROP PROCEDURE IF EXISTS show_logs;

DROP PROCEDURE IF EXISTS show_logs_search;

DROP PROCEDURE IF EXISTS show_accounts;

DROP PROCEDURE IF EXISTS delete_student;

DROP PROCEDURE IF EXISTS show_accounts_search;

DROP PROCEDURE IF EXISTS usernameTaken_check;

DROP PROCEDURE IF EXISTS show_items_admin;

DROP PROCEDURE IF EXISTS super_user_login_check;

DROP PROCEDURE IF EXISTS super_user_change_password;

DROP PROCEDURE IF EXISTS super_user_change_username;

DROP PROCEDURE IF EXISTS show_booking;

DELIMITER ;;

CREATE PROCEDURE super_user_change_username(
    p_username VARCHAR(64)
) BEGIN

UPDATE super_user SET 
        username = p_username
    WHERE id = p_id
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE super_user_change_password(
    p_password VARCHAR(64)
) BEGIN

UPDATE super_user SET 
        passwordUser = SHA2(p_password, "256")
    WHERE id = p_id
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE super_user_login_check(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30)
) BEGIN
SELECT
    *
FROM
    super_user
WHERE
    username = p_username
    AND passwordUser = SHA2(p_passwordUser, "256");

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE register_admins(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(32),
    p_email VARCHAR(50)
) BEGIN
INSERT INTO
    admins (username, passwordUser, email)
VALUES
    (p_username, SHA2(p_passwordUser, "256"), p_email);

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
    (p_username, SHA2(p_passwordUser, "256"), p_email);

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE usernameTaken_check(
    p_username VARCHAR(30)
) BEGIN
SELECT
    id
FROM
    students
WHERE
    username = p_username
;

SELECT
    id
FROM
    admins
WHERE
    username = p_username
;
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
    AND passwordUser = SHA2(p_passwordUser, "256")
    AND deleted = 0;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE get_ID_students(
    p_username VARCHAR(30)
    ) BEGIN
SELECT
    id
FROM
    users
WHERE
    username = p_username
    ;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE login_check_admins(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(32)
) BEGIN
SELECT
    *
FROM
    admins
WHERE
    username = p_username
    AND passwordUser = SHA2(p_passwordUser, "256");

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
    WHERE id = p_id
    ;
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
    (e_name LIKE CONCAT("%", search, "%") OR id LIKE CONCAT("%", search, "%") OR e_description LIKE CONCAT("%", search, "%")) AND deleted = 0
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
    id = p_id AND deleted = 0;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE show_booked(
    ps_id INT
) BEGIN
SELECT
    *
FROM
    equipment_student
WHERE
 s_id = p_id;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_book(
    ps_id INT,
    pe_id INT,
    p_date TIMESTAMP
) BEGIN
INSERT INTO
    equipment_student(s_id, e_id, booked)
VALUES
    (ps_id, pe_id, p_date)
    ;

UPDATE equipment SET 
        e_status = "Booked"
    WHERE id = pe_id
    ;

END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE equipment_reserve(
    pa_id INT,
    pe_id INT,
    p_date TIMESTAMP
) BEGIN
UPDATE equipment SET 
        e_status = "Booked"
    WHERE id = pe_id
    ;

INSERT INTO
    equipment_admin(a_id, e_id, reserved)
VALUES
    (pa_id, pe_id, p_date)
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE show_booked_dates(
    p_id INT
) 
BEGIN
    SELECT booked FROM equipment_student
        WHERE booked != 0 AND picked_up = 0 AND e_id = p_id
        ;
    SELECT reserved FROM equipment_admin
        WHERE reserved != 0 AND e_id = p_id
        ;
END 
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE get_account_info(
    p_username VARCHAR(30)
) 
BEGIN
    SELECT * FROM students
        WHERE username = p_username
        ;

    SELECT * FROM admins
        WHERE username = p_username
        ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE checkForAvailability(
    p_id INT,
    p_quantity INT
) 
BEGIN
SELECT id FROM equipment
    WHERE available >= quantity
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE showBookedForStudent(
    p_id INT,
    p_quantity INT
) 
BEGIN
SELECT id FROM equipment
    WHERE available >= p_quantity
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE showPickupReady(
    p_id INT
) 
BEGIN
SELECT es.id AS es_id,equipment.id, equipment.e_name, es.booked FROM equipment JOIN equipment_student AS es ON es.e_id = equipment.id
    WHERE es.s_id = p_id AND es.picked_up = 0 AND es.booked = CURDATE() AND es.booked NOT IN (SELECT reserved FROM equipment_admin WHERE e_id = es.e_id);
    
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE pick_up(
    p_id INT
)
BEGIN
UPDATE equipment SET
        e_status = "picked up"
    WHERE id = (SELECT e_id FROM equipment_student WHERE id = p_id)
    ;

UPDATE equipment_student SET 
        picked_up = NOW()
    WHERE id = p_id;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE e_return(
    pb_id INT,
    pe_id INT
)
BEGIN
UPDATE equipment SET 
        e_status = "Free"
    WHERE id = pe_id
    ;

UPDATE equipment_student SET 
        returned = NOW()
    WHERE id = pb_id
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE e_return_admin(
    pb_id INT,
    pe_id INT
)
BEGIN
UPDATE equipment SET 
        e_status = "Free"
    WHERE id = pe_id
    ;
UPDATE equipment_admin SET 
        returned = NOW()
    WHERE id = pb_id
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE showReturnableAndOverdue(
    p_id INT
)
BEGIN
SELECT es.id AS es_id,equipment.id, equipment.e_name, es.booked FROM equipment JOIN equipment_student AS es ON es.e_id = equipment.id
    WHERE es.s_id = p_id AND es.picked_up != 0 AND es.returned = 0
    ;
SELECT IF(CURRENT_TIMESTAMP >= DATE_ADD(booked, INTERVAL 1 DAY), "Yes", "No") AS overdue FROM equipment_student
    WHERE s_id = p_id AND picked_up != 0 AND returned = 0
;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE show_logs()
BEGIN
SELECT s.id AS student_id,s.username, sl.id, sl.e_id, e.e_name, sl.descriptions 
    FROM logs_students AS sl
    JOIN students AS s ON sl.s_id = s.id
    JOIN equipment AS e ON sl.e_id = e.id
    ;
SELECT a.id AS admin_id ,a.username, al.id, al.e_id, e.e_name, al.descriptions 
    FROM logs_admins AS al
    JOIN admins AS a ON al.a_id = a.id
    JOIN equipment AS e ON al.e_id = e.id
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE show_logs_search(
    search VARCHAR(30)
)
BEGIN
SELECT s.id AS student_id,s.username, sl.id, sl.e_id, e.e_name, sl.descriptions 
    FROM logs_students AS sl
    JOIN students AS s ON sl.s_id = s.id
    JOIN equipment AS e ON sl.e_id = e.id
    WHERE
    (s.username LIKE CONCAT("%", search, "%") OR s.id LIKE CONCAT("%", search, "%") OR sl.id LIKE CONCAT("%", search, "%") OR sl.e_id LIKE CONCAT("%", search, "%") OR e.e_name LIKE CONCAT("%", search, "%"))
    ;
SELECT a.id AS admin_id ,a.username, al.id, al.e_id, e.e_name, al.descriptions 
    FROM logs_admins AS al
    JOIN admins AS a ON al.a_id = a.id
    JOIN equipment AS e ON al.e_id = e.id
    WHERE
    (a.username LIKE CONCAT("%", search, "%") OR a.id LIKE CONCAT("%", search, "%") OR al.id LIKE CONCAT("%", search, "%") OR al.e_id LIKE CONCAT("%", search, "%") OR e.e_name LIKE CONCAT("%", search, "%"))
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE show_accounts()
BEGIN
    SELECT id, username, email FROM students
    WHERE deleted = 0
    ;
    
    SELECT id, username, email FROM admins;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE show_accounts_search(
    search VARCHAR(30)
)
BEGIN
    SELECT id, username, email FROM students
        WHERE deleted = 0 AND (id LIKE CONCAT("%", search, "%") OR username LIKE CONCAT("%", search, "%") OR email LIKE CONCAT("%", search, "%"))
    ;
    
    SELECT id, username, email FROM admins
        WHERE id LIKE CONCAT("%", search, "%") OR username LIKE CONCAT("%", search, "%") OR email LIKE CONCAT("%", search, "%");
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE delete_student(
    p_id INT
)
BEGIN
    UPDATE students SET
        deleted = NOW()
    WHERE id = p_id;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE show_items_admin()
BEGIN
SELECT
    e_name,
    e_description,
    COUNT(*) as quantity
FROM
    equipment
WHERE
    deleted = 0
GROUP BY
    e_name, e_description
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE show_booking(
    pe_id INT,
    p_id INT
)
BEGIN
    SELECT ea.id AS booking_id, a.username, ea.reserved FROM equipment_admin AS ea
        JOIN admins AS a ON ea.a_id = a.id
        WHERE ea.e_id = pe_id AND ea.a_id = p_id AND ea.reserved = CURRENT_DATE
    ;

    SELECT es.id AS booking_id, s.username, s.email, es.booked FROM equipment_student AS es
        JOIN students AS s ON es.s_id = s.id
        WHERE es.e_id = pe_id AND es.s_id = p_id AND es.booked = CURRENT_DATE AND picked_up != 0
    ;
END
;;

DELIMITER ;
