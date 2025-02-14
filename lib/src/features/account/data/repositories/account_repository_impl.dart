import 'package:dartz/dartz.dart';
import 'package:budgetin_frontend/src/core/network/error/network_exception.dart';
import 'package:budgetin_frontend/src/features/account/data/data_sources/remote/account_remote_data_source.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';
import 'package:budgetin_frontend/src/features/account/domain/repositories/account_repository.dart';

/// Implementation of [AccountRepository]
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remoteDataSource;

  /// Creates a new [AccountRepositoryImpl] instance
  AccountRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, AccountModel>> getAccount(
      AccountRequest request) async {
    try {
      final result = await _remoteDataSource.getAccount(request);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkException, List<AccountModel>>> getAccounts(
      AccountRequest request) async {
    try {
      final result = await _remoteDataSource.getAccounts(request);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }
}
