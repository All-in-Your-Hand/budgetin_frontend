// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      transactionId: json['transactionId'] as String,
      accountId: json['accountId'] as String,
      transactionType: json['transactionType'] as String,
      transactionCategory: json['transactionCategory'] as String,
      transactionAmount: (json['transactionAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      description: json['description'] as String,
      to: json['to'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'accountId': instance.accountId,
      'transactionType': instance.transactionType,
      'transactionCategory': instance.transactionCategory,
      'transactionAmount': instance.transactionAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'transactionDate': instance.transactionDate.toIso8601String(),
      'description': instance.description,
      'to': instance.to,
    };
