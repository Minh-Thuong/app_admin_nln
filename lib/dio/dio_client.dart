import 'package:dio/dio.dart';

class DioClient {
  // Tạo instance duy nhất của Dio
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.2.1.66:8080', // Thay thế với URL của bạn
    // connectTimeout: Duration(milliseconds: 5000),  // Thời gian kết nối tối đa
    // receiveTimeout: Duration(milliseconds: 3000),  // Thời gian nhận dữ liệu tối đa
  ));

  // Trả về instance Dio đã tạo
  static Dio get instance => _dio;
}
