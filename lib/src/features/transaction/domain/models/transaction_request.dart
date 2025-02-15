import 'package:json_annotation/json_annotation.dart';
import 'transaction_model.dart';

part 'transaction_request.g.dart';

@JsonSerializable()
class TransactionRequest {
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'accountId')
  final String accountId;
  @JsonKey(name: 'transactionType')
  final String transactionType;
  @JsonKey(name: 'transactionCategory')
  final String transactionCategory;
  @JsonKey(name: 'transactionAmount')
  final double transactionAmount;
  @JsonKey(toJson: _dateToJson)
  final DateTime transactionDate;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'to')
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

@JsonSerializable()
class TransactionUpdateRequest {
  @JsonKey(name: 'transaction')
  final TransactionModel transaction;

  const TransactionUpdateRequest({
    required this.transaction,
  });

  factory TransactionUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionUpdateRequestToJson(this);
}

@JsonSerializable()
class DeleteTransactionRequest {
  @JsonKey(name: 'transactionId')
  final String transactionId;
  @JsonKey(name: 'userId')
  final String userId;

  const DeleteTransactionRequest({
    required this.transactionId,
    required this.userId,
  });

  factory DeleteTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteTransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteTransactionRequestToJson(this);
}
