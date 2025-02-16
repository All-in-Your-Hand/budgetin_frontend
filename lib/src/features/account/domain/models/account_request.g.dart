// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountRequest _$AccountRequestFromJson(Map<String, dynamic> json) =>
    AccountRequest(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$AccountRequestToJson(AccountRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

AddAccountRequest _$AddAccountRequestFromJson(Map<String, dynamic> json) =>
    AddAccountRequest(
      userId: json['userId'] as String,
      accountName: json['accountName'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$AddAccountRequestToJson(AddAccountRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accountName': instance.accountName,
      'balance': instance.balance,
    };

AccountUpdateRequest _$AccountUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    AccountUpdateRequest(
      account: AccountModel.fromJson(json['account'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountUpdateRequestToJson(
        AccountUpdateRequest instance) =>
    <String, dynamic>{
      'account': instance.account,
    };

DeleteAccountRequest _$DeleteAccountRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteAccountRequest(
      accountId: json['accountId'] as String,
    );

Map<String, dynamic> _$DeleteAccountRequestToJson(
        DeleteAccountRequest instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
    };
