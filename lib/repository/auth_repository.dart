import 'package:admin/datasource/auth_datasource.dart';
import 'package:either_dart/either.dart';

abstract class IAuthRepository {
  Future<Either<String, String>> login(String email, String password);
  Future<void> logout();
  Future<Either<String, bool>> signup(
      String name, String email, String phone, String address, String password);
}

class AuthenticationRepository extends IAuthRepository {
  final IAuthenticationDatasource _authenticationDatasource;

  AuthenticationRepository(this._authenticationDatasource);

  @override
  Future<Either<String, String>> login(String email, String password) async {
    final token = await _authenticationDatasource.login(email, password);
    try {
      if (token.isNotEmpty) {
        return Right(token);
      } else {
        return Left("Login failed");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<String, bool>> signup(String name, String email, String phone,
      String address, String password) async {
    try {
      final result = await _authenticationDatasource.signup(
          name, email, phone, address, password);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
