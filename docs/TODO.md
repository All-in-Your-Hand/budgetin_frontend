Fix the sorting for "Date" column in transaction list. It sorts the transaction based on the "transactionDate" field.
But the transaction date saves only the year, month and day and hour. So if two transactions are on the same day and hour,
it assumes that they are created at the same time.
