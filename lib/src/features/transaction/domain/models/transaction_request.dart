import 'package:json_annotation/json_annotation.dart';

part 'transaction_request.g.dart';

@JsonSerializable()
class TransactionRequest {
  final String userId;
  final String accountId;
  final String transactionType;
  final String transactionCategory;
  final double transactionAmount;
  @JsonKey(toJson: _dateToJson)
  final DateTime transactionDate;
  final String description;
  final String to;

  const TransactionRequest({
    required this.userId,
    required this.accountId,
    required this.transactionType,
    required this.transactionCategory,
    required this.transactionAmount,
    required this.transactionDate,
    required this.description,
    required this.to,
  });

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRequestToJson(this);

  // Convert DateTime to ISO 8601 string with timezone
  static String _dateToJson(DateTime date) {
    return date.toIso8601String();
  }
}
