import 'package:admin/models/order_status.dart';
import 'package:admin/models/salesdata.dart';
import 'package:admin/util/token_manager.dart';
import 'package:dio/dio.dart';

abstract class IReportDataSource {
  Future<Salesdata> getReport(DateTime start, DateTime end, OrderStatus status);
}

class ReportRemote extends IReportDataSource {
  final Dio _dio;

  ReportRemote({required Dio dio}) : _dio = dio;

  @override
  Future<Salesdata> getReport(
      DateTime startDate, DateTime endDate, OrderStatus status) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception("Token không hợp lệ");
    }
    print(status.name.toString().split('.').last);
    print(startDate.toIso8601String());
    print(endDate.toIso8601String());

    try {
      final response = await _dio.get('/api/reports/sales-statistics',
          queryParameters: {
            'start': startDate.toIso8601String(),
            'end': endDate.toIso8601String(),
            'status': status.name.toString().split('.').last,
          },
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = response.data;
        print(result);
        return Salesdata.fromJson(result);
      } else {
        throw Exception('Tải báo cáo thất bại');
      }
    } catch (e) {
      print(e);
      throw Exception('Tải báo cáo thất bại');
    }
  }
}
