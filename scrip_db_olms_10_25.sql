DROP DATABASE IF EXISTS db_olms;

CREATE DATABASE db_olms;

USE db_olms;

CREATE TABLE tb_publisher (
    id_publisher INT AUTO_INCREMENT PRIMARY KEY,
    name_publisher VARCHAR(50) NOT NULL,
    CONSTRAINT uq_publisher
		UNIQUE KEY (name_publisher)
);

CREATE TABLE tb_category (
    id_category INT AUTO_INCREMENT PRIMARY KEY,
    name_category VARCHAR(50) NOT NULL,
    CONSTRAINT uq_category
		UNIQUE KEY (name_category)
);
    
CREATE TABLE tb_author (
    id_author INT AUTO_INCREMENT PRIMARY KEY,
    name_author VARCHAR(100) NOT NULL,
	CONSTRAINT uq_author
		UNIQUE KEY (name_author)
);
    
CREATE TABLE tb_book (
    id_book INT AUTO_INCREMENT PRIMARY KEY,
    isbn_book CHAR(13) NOT NULL,
    title_book VARCHAR(100) NOT NULL,
    limit_days_loan INT(2) NOT NULL,
    year_book YEAR NOT NULL,
    syphosis_book TEXT,
    id_publisher INT NOT NULL,
    CONSTRAINT fk_publisher_book 
		FOREIGN KEY (id_publisher)
			REFERENCES tb_publisher (id_publisher),
    CONSTRAINT uq_isbn 
		UNIQUE KEY (isbn_book)
);

CREATE TABLE tb_book_author (
    id_book_author INT AUTO_INCREMENT PRIMARY KEY,
    id_book INT NOT NULL,
    id_author INT NOT NULL,
    CONSTRAINT fk_book_author_book 
		FOREIGN KEY (id_book)
			REFERENCES tb_book (id_book),
    CONSTRAINT fk_book_author_author 
		FOREIGN KEY (id_author)
			REFERENCES tb_author (id_author),
    CONSTRAINT uq_book_author
		UNIQUE KEY (id_book , id_author)
);
    
CREATE TABLE tb_book_category (
    id_book_category INT AUTO_INCREMENT PRIMARY KEY,
    id_book INT NOT NULL,
    id_category INT NOT NULL,
    CONSTRAINT fk_book_category_category 
		FOREIGN KEY (id_category)
			REFERENCES tb_category (id_category),
    CONSTRAINT fk_book_category_book 
		FOREIGN KEY (id_book)
			REFERENCES tb_book (id_book),
    CONSTRAINT uq_book_category
		UNIQUE KEY (id_book , id_category)
);

CREATE TABLE tb_copy (
    id_copy INT AUTO_INCREMENT PRIMARY KEY,
    code_copy VARCHAR(20) NOT NULL,
    avaible_copy BIT NOT NULL DEFAULT 1,
    id_book INT NOT NULL,
    CONSTRAINT fk_copy_book 
		FOREIGN KEY (id_book)
			REFERENCES tb_book (id_book),
    CONSTRAINT uq_copy 
		UNIQUE KEY (code_copy)
);

CREATE TABLE tb_physical_structure (
	id_physical_structure INT AUTO_INCREMENT PRIMARY KEY,
	name_physical_level VARCHAR(50) NOT NULL,
    num_physical_level INT NOT NULL,
    id_parent_physical_level INT,
    id_copy INT NOT NULL,
    CONSTRAINT fk_physical_structure_self 
		FOREIGN KEY (id_parent_physical_level)
			REFERENCES tb_physical_structure (id_physical_structure),
	CONSTRAINT fk_physical_structure_copy
		FOREIGN KEY (id_copy)
			REFERENCES tb_copy(id_copy),
	CONSTRAINT uq_physical_structure
		UNIQUE KEY (name_physical_level, id_copy)
);

CREATE TABLE tb_library (
    id_library INT AUTO_INCREMENT PRIMARY KEY,
	name_library VARCHAR(50) NOT NULL,
    id_physical_structure INT NOT NULL,
    CONSTRAINT fk_library
		FOREIGN KEY (id_physical_structure)
			REFERENCES tb_physical_structure(id_physical_structure),
    CONSTRAINT uq_library
		UNIQUE KEY (name_library)
);

CREATE TABLE tb_user_type (
    id_user_type INT AUTO_INCREMENT PRIMARY KEY,
    name_user_type VARCHAR(20) NOT NULL,
    CONSTRAINT uq_user_type 
		UNIQUE KEY (name_user_type)
);
    
CREATE TABLE tb_user (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    name_user VARCHAR(50) NOT NULL,
    email_user VARCHAR(50) NOT NULL,
    password_user VARCHAR(255) NOT NULL,
    phone_number_user CHAR(13) NOT NULL,
    address_user TEXT NOT NULL,
    id_user_type INT NOT NULL,
    CONSTRAINT fk_user_user_type 
		FOREIGN KEY (id_user_type)
			REFERENCES tb_user_type (id_user_type),
	CONSTRAINT uq_user 
		UNIQUE KEY (email_user));

CREATE TABLE tb_loan(
	id_loan INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_copy INT NOT NULL,
    dt_expected_collect DATE NOT NULL DEFAULT(CURRENT_DATE),
    dt_loan DATE NOT NULL DEFAULT(CURRENT_DATE),
    dt_expected_devolution_loan DATE NOT NULL,
    dt_real_devolution_loan DATE,
    CONSTRAINT fk_loan_user 
		FOREIGN KEY (id_user) 
			REFERENCES tb_user(id_user),
	CONSTRAINT fk_loan_copy
		FOREIGN KEY (id_copy) 
			REFERENCES tb_copy(id_copy),
	CONSTRAINT uq_loan 
		UNIQUE KEY (id_user, id_copy, dt_loan)
);