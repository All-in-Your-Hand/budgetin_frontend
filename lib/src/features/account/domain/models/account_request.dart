import 'package:json_annotation/json_annotation.dart';
import 'account_model.dart';

part 'account_request.g.dart';

/// Request model for getting accounts
@JsonSerializable()
class AccountRequest {
  /// The ID of the user who owns the account
  @JsonKey(name: 'userId')
  final String userId;

  /// Creates a new [AccountRequest] instance
  const AccountRequest({
    required this.userId,
  });

  /// Creates an [AccountRequest] from JSON map
  factory AccountRequest.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestFromJson(json);

  /// Converts this [AccountRequest] to a JSON map
  Map<String, dynamic> toJson() => _$AccountRequestToJson(this);
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

  /// Creates a new [AddAccountRequest] instance
  const AddAccountRequest({
    required this.userId,
    required this.accountName,
    required this.balance,
  });

  /// Creates an [AddAccountRequest] from JSON map
  factory AddAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$AddAccountRequestFromJson(json);

  /// Converts this [AddAccountRequest] to a JSON map
  Map<String, dynamic> toJson() => _$AddAccountRequestToJson(this);
}

/// Request model for updating an account
@JsonSerializable()
class AccountUpdateRequest {
  /// The account model containing updated information
  @JsonKey(name: 'account')
  final AccountModel account;

  /// Creates a new [AccountUpdateRequest] instance
  const AccountUpdateRequest({
    required this.account,
  });

  /// Creates an [AccountUpdateRequest] from JSON map
  factory AccountUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AccountUpdateRequestFromJson(json);

  /// Converts this [AccountUpdateRequest] to a JSON map
  Map<String, dynamic> toJson() => _$AccountUpdateRequestToJson(this);
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
  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountRequestFromJson(json);

  /// Converts this [DeleteAccountRequest] to a JSON map
  Map<String, dynamic> toJson() => _$DeleteAccountRequestToJson(this);
}
