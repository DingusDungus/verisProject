DROP DATABASE IF EXISTS website;

CREATE DATABASE website;

-- MariaDB
DROP USER IF EXISTS 'user'@'localhost';

CREATE USER IF NOT EXISTS 'user'@'localhost'
	IDENTIFIED BY 'pass'
;

-- Ge användaren alla rättigheter på alla eshop.
GRANT ALL PRIVILEGES
    ON website.*
    TO 'user'@'localhost'
    WITH GRANT OPTION
;
