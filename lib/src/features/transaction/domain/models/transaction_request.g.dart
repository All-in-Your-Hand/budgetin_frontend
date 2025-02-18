// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTransactionRequest _$AddTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    AddTransactionRequest(
      userId: json['userId'] as String,
      accountId: json['accountId'] as String,
      transactionType: json['transactionType'] as String,
      transactionCategory: json['transactionCategory'] as String,
      transactionAmount: (json['transactionAmount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      description: json['description'] as String,
      to: json['to'] as String,
    );

Map<String, dynamic> _$AddTransactionRequestToJson(
        AddTransactionRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accountId': instance.accountId,
      'transactionType': instance.transactionType,
      'transactionCategory': instance.transactionCategory,
      'transactionAmount': instance.transactionAmount,
      'transactionDate':
          AddTransactionRequest._dateToJson(instance.transactionDate),
      'description': instance.description,
      'to': instance.to,
    };

GetTransactionRequest _$GetTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    GetTransactionRequest(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$GetTransactionRequestToJson(
        GetTransactionRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

UpdateTransactionRequest _$UpdateTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateTransactionRequest(
      transaction: TransactionModel.fromJson(
          json['transaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateTransactionRequestToJson(
        UpdateTransactionRequest instance) =>
    <String, dynamic>{
      'transaction': instance.transaction,
    };

DeleteTransactionRequest _$DeleteTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteTransactionRequest(
      transactionId: json['transactionId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$DeleteTransactionRequestToJson(
        DeleteTransactionRequest instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'userId': instance.userId,
    };
