import 'package:admin/models/user.dart';
import 'package:admin/util/token_manager.dart';
import 'package:dio/dio.dart';

abstract class IAuthenticationDatasource {
  Future<String> login(String email, String password);
  Future<void> logout();
  Future<bool> signup(
      String name, String email, String phone, String address, String password);
  Future<List<User>> getALLcustomer();
  Future<User> getCustomerById(String id);
}

class AuthenticationRemote extends IAuthenticationDatasource {
  final Dio _dio;

  AuthenticationRemote({required Dio dio}) : _dio = dio;
  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/users/auth/login',
        data: {'email': email, 'password': password, "role": "ADMIN"},
      );

      print(response.data);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final result = response.data['result'];

        // Check if result is a map and contains 'token'
        if (result != null && result is Map<String, dynamic>) {
          // Check if token exists and is of type String
          if (result.containsKey('token') && result['token'] is String) {
            print("Token: ${result['token']}");
            return result['token']; // Return the token
          } else {
            throw Exception("API không trả về token hợp lệ");
          }
        } else {
          throw Exception("API trả về dữ liệu không đúng định dạng");
        }
      } else {
        throw Exception("API trả về lỗi: ${response.statusCode}");
      }
    } on DioException catch (e) {
      // Handle Dio exceptions (network issues, etc.)
      print(e);
      throw Exception(e.response?.data['message'] ?? 'Lỗi mạng');
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> signup(String name, String email, String phone, String address,
      String password) async {
    final response = await _dio.post(
      '/api/users',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'password': password,
      },
    );
    if ((response.statusCode == 200 || response.statusCode == 201)) {
      // Giả sử khi đăng ký thành công, API trả về status 200 hoặc 201
      return true;
    } else {
      throw Exception("API trả về lỗi: ${response.statusCode}");
    }
  }

  @override
  Future<List<User>> getALLcustomer() async {
    final token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ");
    }

    try {
      final response = await _dio.get(
        '/api/users/role-user',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print(response.data);

      if (response.statusCode == 200) {
        final List<dynamic> result = response.data['result'];
        print("Results API: $result");
        return result.map((e) => User.fromJson(e)).toList();
      } else {
        throw Exception('Tải dữ liệu khách hàng thất bại');
      }
    } catch (e) {
      throw Exception('Tải dữ liệu khách hàng thất bại: $e');
    }
  }

  @override
  Future<User> getCustomerById(String id) async {
    final token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ");
    }

    try {
      final response = await _dio.get(
        '/api/users/userId/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print(response.data);

      if (response.statusCode == 200) {
        final result = response.data['result'];
        print("Results API: $result");
        return User.fromJson(result);
      } else {
        throw Exception('Tải dữ liệu khách hàng thất bại');
      }
    } catch (e) {
      throw Exception('Tải dữ liệu khách hàng thất bại: $e');
    }
  }
}
