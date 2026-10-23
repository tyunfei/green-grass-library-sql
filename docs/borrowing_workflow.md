# Borrowing workflow: concept and concurrency review

The original coursework considered borrowing a specific book copy (`B1002`, copy `4`) for a member (`M1001`) through staff (`S2014`). The checks included:

1. Is the member below the permitted borrowing limit?
2. Does the member's tier meet the book's minimum tier?
3. Is a physical copy marked `Available`?
4. If all checks pass, change the selected copy to `On Loan` and add the corresponding `Loan` record.

In the report, the proposed UPDATE and INSERT were documented as **not executed**. They are not run by this portfolio's demonstration query script.

## Original introductory-level suggestion

The class discussion recommended changing the status using an additional predicate:

```sql
UPDATE BookCopy
SET status = 'On Loan'
WHERE book_id = 'B1002'
  AND copy_no = 4
  AND status = 'Available';
```

Checking that exactly one row changed can prevent both staff members from successfully claiming the *same available status* in a race. However, **a status update alone does not guarantee a matching loan row will be inserted**.

## More robust production concept (not implemented or tested here)

Use a **single database transaction** that verifies eligibility and availability, claims the available copy, writes the loan, and commits only if all steps succeed. Check the affected-row count and rollback on any failure. Ensure application error handling, concurrent request tests and appropriate indexes/constraints. Simply executing an `UPDATE` followed by an `INSERT` without transactional rollback still risks inconsistent records.

This is an analysis of potential design improvements, not a claim that an operational borrowing service was built.
