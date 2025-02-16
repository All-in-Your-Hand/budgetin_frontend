Fix sorting "To" column in transaction list. It sorts the column based on the ASCII value of the characters. For example "a" comes
after "Z" which is not correct. Save user's input with toUpperCase() for simplicity.
