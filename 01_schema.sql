-- Green Grass Library: MySQL 8 schema
-- Portfolio transcription/adaptation of the submitted ST1501 database design.
-- The original database identifier contained the student's ID; it is renamed here.
-- Schema reflects the submitted implementation, including the four-column Loan PK.
CREATE DATABASE IF NOT EXISTS green_grass_library
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE green_grass_library;

CREATE TABLE IF NOT EXISTS MembershipTier (
    tier_name VARCHAR(20) PRIMARY KEY,
    tier_level INT NOT NULL,
    borrow_limit INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Member (
    member_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    occupation VARCHAR(50) NULL,
    registered_datetime DATETIME NOT NULL,
    tier_name VARCHAR(20) NOT NULL,
    CONSTRAINT fk_member_tier FOREIGN KEY (tier_name)
        REFERENCES MembershipTier(tier_name)
);

CREATE TABLE IF NOT EXISTS Staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    employment_type VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    department VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Book (
    book_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    min_tier_req VARCHAR(20) NOT NULL,
    CONSTRAINT fk_book_tier FOREIGN KEY (min_tier_req)
        REFERENCES MembershipTier(tier_name)
);

CREATE TABLE IF NOT EXISTS BookCopy (
    book_id VARCHAR(10) NOT NULL,
    copy_no INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY (book_id, copy_no),
    CONSTRAINT fk_bookcopy_book FOREIGN KEY (book_id)
        REFERENCES Book(book_id)
);

CREATE TABLE IF NOT EXISTS Loan (
    member_id VARCHAR(10) NOT NULL,
    staff_id VARCHAR(10) NOT NULL,
    book_id VARCHAR(10) NOT NULL,
    copy_no INT NOT NULL,
    borrow_datetime DATETIME NOT NULL,
    due_date DATE NOT NULL,
    return_datetime DATETIME NULL,
    PRIMARY KEY (member_id, book_id, copy_no, borrow_datetime),
    CONSTRAINT fk_loan_member FOREIGN KEY (member_id)
        REFERENCES Member(member_id),
    CONSTRAINT fk_loan_staff FOREIGN KEY (staff_id)
        REFERENCES Staff(staff_id),
    CONSTRAINT fk_loan_bookcopy FOREIGN KEY (book_id, copy_no)
        REFERENCES BookCopy(book_id, copy_no)
);
