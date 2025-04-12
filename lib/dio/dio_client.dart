import 'package:dio/dio.dart';

class DioClient {
  // Tạo instance duy nhất của Dio
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.11.5.190:8080',
  ));

  // Trả về instance Dio đã tạo
  static Dio get instance => _dio;
}
