FRONTEND TODO:

Talk about account deletion effects. We will use a flag to check if the account is deleted. If it is, we will not show it in the UI. and the transactions related to that account will not be editable.

When a request is made, or a response is received, all the data sent and received can be seen (kabak gibi) in developer tools console. If there is a solution to this, it should be implemented.

Consider extracting validation logic to a separate class. From transaction provider and account dialog.

Add a did edit check before updating the transaction. If it is not edited, then don't update it.

Try take make the filter and transaction table sections as a whole so that they can be scrolled as a whole. "Couldn't do it"

Fix the right sidebar animation. On page transitions, the right sidebar does the expansion animation.

Hold account card color info in the account model. Store it in the database.

BACKEND TODO:

- deleteCascading boolean field -> add to account
- DeleteAccountRequest

- Account model -> isDeleted boolean field

- TransactionService -> addTransaction(addTransactionRequest) -> handle account balance

- TransactionService -> updateTransaction(updateTransactionRequest) -> handle account balance

- TransactionService -> deleteTransaction(deleteTransactionRequest) -> handle account balance, but ask if it is ok to refund for transactions older than 30 days, refund will be asked.
