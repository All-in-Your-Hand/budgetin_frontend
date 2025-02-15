// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRequest _$TransactionRequestFromJson(Map<String, dynamic> json) =>
    TransactionRequest(
      userId: json['userId'] as String,
      accountId: json['accountId'] as String,
      transactionType: json['transactionType'] as String,
      transactionCategory: json['transactionCategory'] as String,
      transactionAmount: (json['transactionAmount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      description: json['description'] as String,
      to: json['to'] as String,
    );

Map<String, dynamic> _$TransactionRequestToJson(TransactionRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accountId': instance.accountId,
      'transactionType': instance.transactionType,
      'transactionCategory': instance.transactionCategory,
      'transactionAmount': instance.transactionAmount,
      'transactionDate':
          TransactionRequest._dateToJson(instance.transactionDate),
      'description': instance.description,
      'to': instance.to,
    };

TransactionUpdateRequest _$TransactionUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    TransactionUpdateRequest(
      transaction: TransactionModel.fromJson(
          json['transaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionUpdateRequestToJson(
        TransactionUpdateRequest instance) =>
    <String, dynamic>{
      'transaction': instance.transaction,
    };
