import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

/// A model class representing a financial transaction in the system.
///
/// This model contains all the necessary information about a transaction including
/// its ID, associated user and account, type, category, amount, dates, and other details.
@JsonSerializable()
class TransactionModel {
  @JsonKey(name: 'id')
  final String transactionId;

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

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'transactionDate')
  final DateTime transactionDate;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'to')
  final String to;

  const TransactionModel({
    required this.transactionId,
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

  /// Creates a [TransactionModel] from a JSON map
  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  /// Converts this [TransactionModel] to a JSON map
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
