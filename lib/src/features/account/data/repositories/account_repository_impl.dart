import 'package:dartz/dartz.dart';
import 'package:budgetin_frontend/src/core/exceptions/network_exception.dart';
import 'package:budgetin_frontend/src/features/account/data/data_sources/remote/account_remote_data_source.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';
import 'package:budgetin_frontend/src/features/account/domain/repositories/account_repository.dart';

/// Implementation of [AccountRepository] that handles the coordination between
/// remote data sources and implements the business logic for account operations.
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remoteDataSource;

  /// Creates a new [AccountRepositoryImpl] instance.
  ///
  /// Requires an [AccountRemoteDataSource] for handling network operations.
  AccountRepositoryImpl({required AccountRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<NetworkException, List<AccountModel>>> getAccounts(GetAccountRequest request) async {
    final response = await _remoteDataSource.getAccounts(request);

    return response.fold(
      (failure) => Left(failure),
      (accountResponse) => Right(accountResponse.accounts),
    );
  }

  @override
  Future<Either<NetworkException, String>> addAccount(AddAccountRequest request) async {
    final response = await _remoteDataSource.addAccount(request);

    return response.fold(
      (failure) => Left(failure),
      (successMessage) => Right(successMessage),
    );
  }

  @override
  Future<Either<NetworkException, String>> updateAccount(UpdateAccountRequest request) async {
    final response = await _remoteDataSource.updateAccount(request);

    return response.fold(
      (failure) => Left(failure),
      (successMessage) => Right(successMessage),
    );
  }

  @override
  Future<Either<NetworkException, String>> deleteAccount(DeleteAccountRequest request) async {
    final response = await _remoteDataSource.deleteAccount(request);

    return response.fold(
      (failure) => Left(failure),
      (successMessage) => Right(successMessage),
    );
  }
}
