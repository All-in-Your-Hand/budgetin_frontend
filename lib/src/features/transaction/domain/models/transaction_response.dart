import 'package:json_annotation/json_annotation.dart';
import 'transaction_model.dart';

part 'transaction_response.g.dart';

/// Response model for transaction-related API calls.
///
/// This class encapsulates the response data containing a list of transactions
/// returned from the server.
@JsonSerializable()
class TransactionResponse {
  /// List of transaction models returned in the response
  @JsonKey(name: 'transactions')
  final List<TransactionModel> transactions;

  /// Creates a new [TransactionResponse] instance
  const TransactionResponse({
    required this.transactions,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
