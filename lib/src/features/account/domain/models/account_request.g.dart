// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAccountRequest _$GetAccountRequestFromJson(Map<String, dynamic> json) =>
    GetAccountRequest(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$GetAccountRequestToJson(GetAccountRequest instance) =>
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

UpdateAccountRequest _$UpdateAccountRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateAccountRequest(
      account: AccountModel.fromJson(json['account'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateAccountRequestToJson(
        UpdateAccountRequest instance) =>
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
