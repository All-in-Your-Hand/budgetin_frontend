import 'package:json_annotation/json_annotation.dart';
import 'transaction_model.dart';

part 'transaction_request.g.dart';

/// Request model for adding a new transaction
@JsonSerializable()
class AddTransactionRequest {
  /// The ID of the user creating the transaction
  @JsonKey(name: 'userId')
  final String userId;

  /// The ID of the account associated with the transaction
  @JsonKey(name: 'accountId')
  final String accountId;

  /// The type of transaction (e.g., 'income', 'expense')
  @JsonKey(name: 'transactionType')
  final String transactionType;

  /// The category of the transaction (e.g., 'food', 'salary')
  @JsonKey(name: 'transactionCategory')
  final String transactionCategory;

  /// The monetary amount of the transaction
  @JsonKey(name: 'transactionAmount')
  final double transactionAmount;

  /// The date when the transaction occurred
  @JsonKey(toJson: _dateToJson)
  final DateTime transactionDate;

  /// A description or note about the transaction
  @JsonKey(name: 'description')
  final String description;

  /// The recipient or source of the transaction
  @JsonKey(name: 'to')
  final String to;

  /// Creates a new [AddTransactionRequest] instance
  const AddTransactionRequest({
    required this.userId,
    required this.accountId,
    required this.transactionType,
    required this.transactionCategory,
    required this.transactionAmount,
    required this.transactionDate,
    required this.description,
    required this.to,
  });

  factory AddTransactionRequest.fromJson(Map<String, dynamic> json) => _$AddTransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddTransactionRequestToJson(this);

  // Convert DateTime to ISO 8601 string with timezone
  static String _dateToJson(DateTime date) {
    return date.toIso8601String();
  }
}

/// Request model for getting transactions for a specific user
@JsonSerializable()
class GetTransactionRequest {
  /// The ID of the user whose transactions are being retrieved
  @JsonKey(name: 'userId')
  final String userId;

  /// Creates a new [GetTransactionRequest] instance
  const GetTransactionRequest({
    required this.userId,
  });

  factory GetTransactionRequest.fromJson(Map<String, dynamic> json) => _$GetTransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetTransactionRequestToJson(this);
}

/// Request model for updating an existing transaction
@JsonSerializable()
class UpdateTransactionRequest {
  @JsonKey(name: 'transaction')
  final TransactionModel transaction;

  /// Creates a new [UpdateTransactionRequest] instance
  const UpdateTransactionRequest({
    required this.transaction,
  });

  factory UpdateTransactionRequest.fromJson(Map<String, dynamic> json) => _$UpdateTransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTransactionRequestToJson(this);
}

/// Request model for deleting a transaction
@JsonSerializable()
class DeleteTransactionRequest {
  @JsonKey(name: 'transactionId')
  final String transactionId;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'revertBalance')
  final bool revertBalance;

  /// Creates a new [DeleteTransactionRequest] instance
  const DeleteTransactionRequest({
    required this.transactionId,
    required this.userId,
    required this.revertBalance,
  });

  factory DeleteTransactionRequest.fromJson(Map<String, dynamic> json) => _$DeleteTransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteTransactionRequestToJson(this);
}
