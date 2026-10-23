# Database design, decisions and limitations

## What was actually built

This portfolio documents the submitted Green Grass Library relational database work. The source was a Word-based coursework template containing an EERD, MySQL DDL, SQL query answers, MySQL result screenshots and an exploratory discussion of race conditions. The original Excel dataset, standalone executable SQL source files and a runnable application were **not** present in the uploaded ZIP. The `.sql` scripts in this repo have therefore been transcribed from the report; the demo records were newly created for portfolio reproducibility.

## Relationships and modelling

- `MembershipTier` stores tier name, level and borrowing limit (Basic=10, Advanced=20, Premium=30 in the course's requirements).
- `Member` references the member's `MembershipTier`.
- `Book` references the minimum `MembershipTier` required to borrow the title.
- `BookCopy` stores physical copies, identified by (`book_id`, `copy_no`), with statuses such as Available, On Loan and Lost.
- `Loan` relates a member, a staff member and a physical copy, recording borrowing, due and return dates. Its submitted **four-column primary key** is (`member_id`, `book_id`, `copy_no`, `borrow_datetime`); `staff_id` is a foreign key, not part of that key.
- `Staff.department` is a text attribute in the submitted schema; there is **no separate Department table** in the uploaded final implementation.

## Important limitations

1. **Historical results cannot be regenerated without the source workbook.** The original report lists row counts of 3 tiers, 10 members, 10 staff, 20 books, 70 copies and 1,000 loans. This repo deliberately does not claim the synthetic demo reproduces those results.
2. **Lost-book history:** Q2 tests historical loan records by joining each loan to the copy's *current* `Lost` status. This may count unrelated historical loans as losses. A production database would record loss events or loan outcome history explicitly.
3. **Transaction safety:** The original Q3 proposal updated copy status and then inserted a loan in separate statements, while Q4 discussed a conditional update to reduce double-issue risks. This mitigates some races but does not make both statements atomic. In production, use a transaction with error handling, row locking/conditional updates and rollback on failure; the original assignment deliberately stayed with introductory SQL concepts.
4. **Integrity of status fields:** This schema stores statuses as VARCHAR without a `CHECK` constraint or controlled lookup. The demo uses the expected values but does not enforce the domain at database level.
5. **Schema portability:** This is MySQL-flavoured SQL (e.g., `TIMESTAMPDIFF` and `DATE_ADD`), not generic ANSI SQL. The script uses MySQL 8's UTF-8 collation.
6. **Auth and security:** The coursework does not constitute a full library application, authentication service or production-ready circulation system.

## Attribution and publication

Individual work completed for ST1501 Data Engineering at Singapore Polytechnic. The submitted Word document was not included because it contains student-identifying details, assessment formatting and an extended discussion transcript. Original institution-supplied data is not republished. This repository is for portfolio demonstration; it is not an official Singapore Polytechnic project release.
