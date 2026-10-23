-- SYNTHETIC portfolio demo. NOT the original coursework's Excel dataset.
-- Requires a fresh schema from 01_schema.sql; existing data may conflict on PKs.
USE green_grass_library;

INSERT INTO MembershipTier (tier_name, tier_level, borrow_limit) VALUES
('Basic', 1, 10), ('Advanced', 2, 20), ('Premium', 3, 30);

INSERT INTO Member (member_id, full_name, contact_email, date_of_birth, gender, occupation, registered_datetime, tier_name) VALUES
('M1001', 'Sample Member One', 'member1@example.test', '2002-03-18', 'Female', 'Student', '2024-01-10 10:00:00', 'Basic'),
('M1002', 'Sample Member Two', 'member2@example.test', '2001-06-20', 'Male', 'Student', '2024-02-15 11:00:00', 'Advanced'),
('M1005', 'Sample Member Five', 'member5@example.test', '2003-02-11', 'Female', 'Employee', '2024-03-20 09:00:00', 'Basic');

INSERT INTO Staff (staff_id, full_name, contact_email, date_of_birth, gender, employment_type, start_date, department) VALUES
('S2014', 'Sample Staff One', 'staff1@example.test', '1987-01-03', 'Female', 'Full-Time', '2020-07-01', 'Circulation'),
('S2015', 'Sample Staff Two', 'staff2@example.test', '1990-12-22', 'Male', 'Part-Time', '2023-02-01', 'Circulation');

INSERT INTO Book (book_id, title, author, genre, min_tier_req) VALUES
('B1002', 'Modern Systems', 'Sample Author', 'Technology', 'Basic'),
('B1003', 'Lonely Dance', 'Sample Writer', 'Fiction', 'Advanced');

INSERT INTO BookCopy (book_id, copy_no, status) VALUES
('B1002', 1, 'On Loan'), ('B1002', 4, 'Available'),
('B1003', 1, 'Available'), ('B1003', 2, 'Available');

INSERT INTO Loan (member_id, staff_id, book_id, copy_no, borrow_datetime, due_date, return_datetime) VALUES
('M1001', 'S2014', 'B1002', 1, '2026-04-25 10:00:00', '2026-05-09', NULL),
('M1002', 'S2014', 'B1003', 1, '2025-01-01 13:00:00', '2025-01-15', '2025-01-13 09:00:00'),
('M1002', 'S2015', 'B1003', 1, '2025-05-01 14:00:00', '2025-05-15', '2025-05-14 11:00:00'),
('M1001', 'S2014', 'B1003', 2, '2025-09-01 08:00:00', '2025-09-15', '2025-09-14 08:00:00');
