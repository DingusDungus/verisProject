USE website;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT NOT NULL,
    username VARCHAR(30),
    passwordUser VARCHAR(30),
    email VARCHAR(50),
    PRIMARY KEY(id)
)
ENGINE INNODB
CHARSET utf8
COLLATE utf8_swedish_ci
;

-- PRODECURES BABIEEE!!!!!!

DROP PROCEDURE IF EXISTS register;
DROP PROCEDURE IF EXISTS login_check;
DROP PROCEDURE IF EXISTS registerCheck;
DROP PROCEDURE IF EXISTS get_ID;

DELIMITER ;;

CREATE PROCEDURE register(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30),
    p_email VARCHAR(50)
)
BEGIN
    INSERT INTO users
        (username, passwordUser, email)
    VALUES
        (p_username, p_passwordUser, p_email)
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE registerCheck(
    p_username VARCHAR(30)
)
BEGIN
    SELECT * FROM users
        WHERE username = p_username
    ;
END
;;

DELIMITER ;

DELIMITER ;;

CREATE PROCEDURE login_check(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30)
)
BEGIN
    SELECT * FROM users
        WHERE username = p_username AND passwordUser = p_passwordUser
    ;
END
;;

DELIMITER ;



DELIMITER ;;

CREATE PROCEDURE get_ID(
    p_username VARCHAR(30),
    p_passwordUser VARCHAR(30)
)
BEGIN
    SELECT id FROM users
        WHERE username = p_username AND passwordUser = p_passwordUser
    ;
END
;;

DELIMITER ;
