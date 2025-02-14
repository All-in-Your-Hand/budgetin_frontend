// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      accountId: json['id'] as String,
      userId: json['userId'] as String,
      accountName: json['accountName'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.accountId,
      'userId': instance.userId,
      'accountName': instance.accountName,
      'balance': instance.balance,
    };
