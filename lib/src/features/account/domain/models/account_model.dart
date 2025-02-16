import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

/// Model class representing an account in the system
@JsonSerializable()
class AccountModel {
  /// The unique identifier of the account
  @JsonKey(name: 'id')
  final String id;

  /// The ID of the user who owns this account
  @JsonKey(name: 'userId')
  final String userId;

  /// The name of the account
  @JsonKey(name: 'accountName')
  final String accountName;

  /// The current balance of the account
  @JsonKey(name: 'balance')
  final double balance;

  /// Creates a new [AccountModel] instance
  const AccountModel({
    required this.id,
    required this.userId,
    required this.accountName,
    required this.balance,
  });

  /// Creates an [AccountModel] from JSON map
  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);

  /// Converts this [AccountModel] to a JSON map
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
