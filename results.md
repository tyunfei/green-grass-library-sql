# Historical coursework results and validation

The values below were transcribed from the submitted report and its screenshots, **not freshly executed against the synthetic demo**.

| Area | Result in the submitted report | Evidence |
|---|---|---|
| Original imported rows | MembershipTier: 3; Member: 10; Staff: 10; Book: 20; BookCopy: 70; Loan: 1,000 | Report's row-count table |
| Q1: repeat borrowers of `Lonely Dance` | 10 distinct members | `assets/q1_repeat_borrowers.png` |
| Q2: `M1005` upgrade eligibility | Eligible | `assets/q2_upgrade_eligibility.png` |
| Q3: `M1001` current loans | 1 of 10; Can Borrow | `assets/q3_borrow_limit.png` |
| Q3: `M1001` vs `B1002` tier requirement | Basic / Basic; Eligible | `assets/q3_tier_check.png` |
| Q3: available copy of `B1002` | Copy 4, Available | `assets/q3_available_copy.png` |

The original Q2 explanation stated that the member was 23 years old with five late returns and zero recorded lost-copy matches. Its lost-copy query has a historical-status ambiguity described in [`decisions_and_limitations.md`](decisions_and_limitations.md).

## Demo data expected behavior

- Q1 returns **1** distinct repeat borrower, not the historical 10.
- Q2 returns **Eligible** for the synthetic `M1005` record.
- Q3 borrowing-limit query returns **1 active loan / limit 10**, the tier check is **Eligible**, and `B1002` copy **4** is available.

The sample identities are fictional and their email addresses use the reserved `.test` domain.
