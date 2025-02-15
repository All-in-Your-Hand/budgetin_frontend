import 'package:json_annotation/json_annotation.dart';

part 'account_request.g.dart';

/// Request model for getting account information
@JsonSerializable()
class AccountRequest {
  /// The ID of the user who owns the account
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
