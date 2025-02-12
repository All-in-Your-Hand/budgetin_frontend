class Transaction {
  final String? transactionId;
  final String userId;
  final String accountId;
  final String transactionType;
  final String transactionCategory;
  final double transactionAmount;
  final DateTime createdAt;
  final DateTime transactionDate;
  final String description;
  final String to;

  Transaction({
    this.transactionId,
    required this.userId,
    required this.accountId,
    required this.transactionType,
    required this.transactionCategory,
    required this.transactionAmount,
    required this.createdAt,
    required this.transactionDate,
    required this.description,
    required this.to,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      userId: json['userId'],
      accountId: json['accountId'],
      transactionType: json['transactionType'],
      transactionCategory: json['transactionCategory'],
      transactionAmount: json['transactionAmount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      transactionDate: DateTime.parse(json['transactionDate']),
      description: json['description'],
      to: json['to'],
    );
  }
}
