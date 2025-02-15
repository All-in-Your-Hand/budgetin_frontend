import 'package:dartz/dartz.dart';
import 'package:budgetin_frontend/src/core/network/exception/network_exception.dart';
import 'package:budgetin_frontend/src/features/account/data/data_sources/remote/account_remote_data_source.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';
import 'package:budgetin_frontend/src/features/account/domain/repositories/account_repository.dart';

/// Implementation of [AccountRepository]
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remoteDataSource;

  /// Creates a new [AccountRepositoryImpl] instance
  AccountRepositoryImpl({required AccountRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<NetworkException, List<AccountModel>>> getAccounts(
      AccountRequest request) async {
    try {
      final result = await _remoteDataSource.getAccounts(request);
      return Right(result.accounts);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }
}
