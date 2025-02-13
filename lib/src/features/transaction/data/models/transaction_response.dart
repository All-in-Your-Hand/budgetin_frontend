import 'package:json_annotation/json_annotation.dart';
import '../../domain/models/transaction_model.dart';

part 'transaction_response.g.dart';

@JsonSerializable()
class TransactionResponse {
  @JsonKey(name: 'transactions')
  final List<TransactionModel> transactions;

  const TransactionResponse({
    required this.transactions,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
