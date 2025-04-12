import 'package:admin/datasource/auth_datasource.dart';
import 'package:admin/models/user.dart';
import 'package:either_dart/either.dart';

abstract class IAuthRepository {
  Future<Either<String, String>> login(String email, String password);

  Future<void> logout();
  Future<Either<String, bool>> signup(
      String name, String email, String phone, String address, String password);

  Future<List<User>> getALLcustomer();
  Future<User> getCustomerById(String id);
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

  @override
  Future<List<User>> getALLcustomer() async {
    try {
      final result = await _authenticationDatasource.getALLcustomer();
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<User> getCustomerById(String id) async {
   try {
      final result = await _authenticationDatasource.getCustomerById(id);
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
