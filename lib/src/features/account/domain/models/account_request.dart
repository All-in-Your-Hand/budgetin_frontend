import 'package:json_annotation/json_annotation.dart';
import 'account_model.dart';

part 'account_request.g.dart';

/// Request model for getting accounts
@JsonSerializable()
class GetAccountRequest {
  /// The ID of the user who owns the account
  @JsonKey(name: 'userId')
  final String userId;

  /// Creates a new [GetAccountRequest] instance
  const GetAccountRequest({
    required this.userId,
  });

  /// Creates an [GetAccountRequest] from JSON map
  factory GetAccountRequest.fromJson(Map<String, dynamic> json) => _$GetAccountRequestFromJson(json);

  /// Converts this [GetAccountRequest] to a JSON map
  Map<String, dynamic> toJson() => _$GetAccountRequestToJson(this);
}

/// Request model for adding a new account
@JsonSerializable()
class AddAccountRequest {
  /// The ID of the user who owns the account
  @JsonKey(name: 'userId')
  final String userId;

  /// The name of the account
  @JsonKey(name: 'accountName')
  final String accountName;

  /// The initial balance of the account
  @JsonKey(name: 'balance')
  final double balance;

  /// Creates a new [AddAccountRequest] instance with the specified user ID, account name, and balance
  const AddAccountRequest({
    required this.userId,
    required this.accountName,
    required this.balance,
  });

  /// Creates an [AddAccountRequest] from JSON map
  factory AddAccountRequest.fromJson(Map<String, dynamic> json) => _$AddAccountRequestFromJson(json);

  /// Converts this [AddAccountRequest] to a JSON map
  Map<String, dynamic> toJson() => _$AddAccountRequestToJson(this);
}

/// Request model for updating an account
@JsonSerializable()
class UpdateAccountRequest {
  /// The account model containing updated information
  @JsonKey(name: 'account')
  final AccountModel account;

  /// Creates a new [UpdateAccountRequest] instance
  const UpdateAccountRequest({
    required this.account,
  });

  /// Creates an [UpdateAccountRequest] from JSON map
  factory UpdateAccountRequest.fromJson(Map<String, dynamic> json) => _$UpdateAccountRequestFromJson(json);

  /// Converts this [UpdateAccountRequest] to a JSON map
  Map<String, dynamic> toJson() => _$UpdateAccountRequestToJson(this);
}

/// Request model for deleting an account
@JsonSerializable()
class DeleteAccountRequest {
  /// The ID of the account to delete
  @JsonKey(name: 'accountId')
  final String accountId;

  /// Creates a new [DeleteAccountRequest] instance
  const DeleteAccountRequest({
    required this.accountId,
  });

  /// Creates a [DeleteAccountRequest] from JSON map
  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) => _$DeleteAccountRequestFromJson(json);

  /// Converts this [DeleteAccountRequest] to a JSON map
  Map<String, dynamic> toJson() => _$DeleteAccountRequestToJson(this);
}
