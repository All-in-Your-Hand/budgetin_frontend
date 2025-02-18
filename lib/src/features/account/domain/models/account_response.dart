import 'package:json_annotation/json_annotation.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';

part 'account_response.g.dart';

/// Response model for account-related API calls
@JsonSerializable()
class AccountResponse {
  /// List of accounts returned by the API
  @JsonKey(name: 'accounts')
  final List<AccountModel> accounts;

  /// Creates a new [AccountResponse] instance
  const AccountResponse({
    required this.accounts,
  });

  /// Creates an [AccountResponse] from JSON map
  factory AccountResponse.fromJson(Map<String, dynamic> json) => _$AccountResponseFromJson(json);

  /// Converts this [AccountResponse] to a JSON map
  Map<String, dynamic> toJson() => _$AccountResponseToJson(this);
}
