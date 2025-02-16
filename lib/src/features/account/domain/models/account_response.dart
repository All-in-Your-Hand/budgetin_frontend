import 'package:json_annotation/json_annotation.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';

part 'account_response.g.dart';

@JsonSerializable()
class AccountResponse {
  @JsonKey(name: 'accounts')
  final List<AccountModel> accounts;

  const AccountResponse({
    required this.accounts,
  });

  factory AccountResponse.fromJson(Map<String, dynamic> json) => _$AccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountResponseToJson(this);
}
