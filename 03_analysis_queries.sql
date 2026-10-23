-- Reproduced from the student's submitted Q1–Q3 coursework queries.
-- To run: mysql -u root -p green_grass_library < sql/03_analysis_queries.sql
-- Original screenshots were generated from a separate supplied dataset.
-- Demo results WILL differ: e.g., Q1 count is 1, rather than the historical 10.
USE green_grass_library;

-- Q1. Distinct members who borrowed 'Lonely Dance' more than once.
SELECT COUNT(*) AS DistinctMembers
FROM (
    SELECT l.member_id
    FROM Loan AS l
    JOIN Book AS b ON l.book_id = b.book_id
    WHERE b.title = 'Lonely Dance'
    GROUP BY l.member_id
    HAVING COUNT(*) > 1
) AS Borrowers;

-- Q2. Upgrade criteria for M1005, assessed as of 1 May 2026.
-- LIMITATION: A copy's CURRENT 'Lost' status is not a sound substitute for a
-- per-loan historical lost-book event. See docs/decisions_and_limitations.md.
SELECT CASE
    WHEN TIMESTAMPDIFF(YEAR, m.date_of_birth, '2026-05-01 00:00:00') >= 16
    AND (
        SELECT COUNT(*) FROM Loan AS l
        WHERE l.member_id = 'M1005'
          AND DATE(l.return_datetime) > l.due_date
          AND l.borrow_datetime >= '2023-05-01 00:00:00'
          AND l.borrow_datetime <= '2026-05-01 00:00:00'
    ) <= 5
    AND (
        SELECT COUNT(*) FROM Loan AS l
        JOIN BookCopy AS bc
          ON l.book_id = bc.book_id AND l.copy_no = bc.copy_no
        WHERE l.member_id = 'M1005'
          AND bc.status = 'Lost'
          AND l.borrow_datetime >= '2023-05-01 00:00:00'
          AND l.borrow_datetime <= '2026-05-01 00:00:00'
    ) <= 1
    THEN 'Eligible'
    ELSE 'Ineligible'
END AS Eligibility
FROM Member AS m
WHERE m.member_id = 'M1005';

-- Q3(i)(A). Existing active loan count vs membership borrowing limit.
SELECT m.member_id, mt.tier_name, mt.borrow_limit,
       COUNT(l.book_id) AS CurrentLoans,
       CASE WHEN COUNT(l.book_id) < mt.borrow_limit
           THEN 'Can Borrow' ELSE 'Limit Reached'
       END AS BorrowingStatus
FROM Member AS m
JOIN MembershipTier AS mt ON m.tier_name = mt.tier_name
LEFT JOIN Loan AS l ON m.member_id = l.member_id AND l.return_datetime IS NULL
WHERE m.member_id = 'M1001'
GROUP BY m.member_id, mt.tier_name, mt.borrow_limit;

-- Q3(i)(B). Membership tier vs minimum book tier.
SELECT m.member_id,
       mt_member.tier_name AS MemberTier,
       mt_book.tier_name AS RequiredTier,
       CASE WHEN mt_member.tier_level >= mt_book.tier_level
           THEN 'Eligible' ELSE 'Not Eligible'
       END AS TierEligibility
FROM Member AS m
JOIN MembershipTier AS mt_member ON m.tier_name = mt_member.tier_name
JOIN Book AS b ON b.book_id = 'B1002'
JOIN MembershipTier AS mt_book ON b.min_tier_req = mt_book.tier_name
WHERE m.member_id = 'M1001';

-- Q3(ii). Available copies of requested book.
SELECT book_id, copy_no, status
FROM BookCopy
WHERE book_id = 'B1002' AND status = 'Available';

-- Q3(iii) UPDATE + INSERT were proposed in the coursework but NOT executed.
-- The safe handling of a borrowing operation is discussed in the documentation.
