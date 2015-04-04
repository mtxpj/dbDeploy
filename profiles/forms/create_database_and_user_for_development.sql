DROP DATABASE IF EXISTS forms;

CREATE DATABASE forms DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_polish_ci;

USE forms;

GRANT ALL ON forms TO `forms` IDENTIFIED BY 'forms';
GRANT ALL PRIVILEGES ON *.* TO 'forms'@'%' IDENTIFIED BY 'forms' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'forms'@'localhost' IDENTIFIED BY 'forms' WITH GRANT OPTION;
FLUSH PRIVILEGES;
