import 'package:admin/datasource/report_datasource.dart';
import 'package:admin/dio/dio_client.dart';
import 'package:admin/models/order_status.dart';
import 'package:admin/models/salesdata.dart';
import 'package:admin/screen/reports/saleschart.dart';
import 'package:admin/service/forrmat.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Future<Salesdata> futureReport;
  DateTime? startDate;
  DateTime? endDate;
  String selectedWeek = "Chưa chọn tuần";
  late IReportDataSource reportRemote;

  @override
  void initState() {
    super.initState();
    reportRemote = ReportRemote(dio: DioClient.instance);
    _setDefaultWeek();
    _fetchReport();
  }

  void _setDefaultWeek() {
    DateTime now = DateTime.now();
    startDate = now.subtract(Duration(days: now.weekday - 1)); // Thứ 2
    endDate = startDate!.add(Duration(days: 6)); // Chủ Nhật
    selectedWeek = _getWeekRange(startDate!);
  }

  void _fetchReport() {
    futureReport = reportRemote.getReport(
      startDate!,
      endDate!,
      OrderStatus.DELIVERED,
    );
  }

  void _pickWeek(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.subtract(Duration(days: picked.weekday - 1));
        endDate = startDate!.add(Duration(days: 6));
        selectedWeek = _getWeekRange(startDate!);
        _fetchReport();
      });
    }
  }

  String _getWeekRange(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    String formattedStart = DateFormat('dd/MM/yyyy').format(startOfWeek);
    String formattedEnd = DateFormat('dd/MM/yyyy').format(endOfWeek);
    return "Tuần từ $formattedStart đến $formattedEnd";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Báo cáo"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.blueGrey),
                  )),
                  onPressed: () => _pickWeek(context),
                  child: const Text(
                    "Chọn tuần",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  )),
            ),
            const SizedBox(height: 10),
            Center(
                child:
                    Text(selectedWeek, style: const TextStyle(fontSize: 16))),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<Salesdata>(
                future: futureReport,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    Salesdata report = snapshot.data!;
                    return _buildReportUI(report);
                  } else {
                    return const Center(child: Text('Không có dữ liệu'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportUI(Salesdata report) {
    double totalSales =
        report.dailySales.values.fold(0, (sum, item) => sum + item);
    int orderCount = report.totalOrders;
    double averagePerOrder = orderCount > 0 ? totalSales / orderCount : 0;

    List<FlSpot> salesSpots = report.dailySales.entries.map((entry) {
      int dayIndex = entry.key.weekday - 1; // 0 = Thứ 2, 6 = Chủ Nhật
      return FlSpot(dayIndex.toDouble(), entry.value);
    }).toList();
    salesSpots.sort((a, b) => a.x.compareTo(b.x));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.green),
            ),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                const Text("Doanh thu"),
                Text(
                  formatCurrency(totalSales),
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn("Tổng số đơn hàng", orderCount.toString()),
                    _buildStatColumn(
                        "Trung bình/đơn", formatCurrency(averagePerOrder)),
                  ],
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text("Biểu đồ xu hướng doanh thu",
              style: TextStyle(fontSize: 16)),
          Divider(thickness: 1),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(height: 300.h, child: buildSalesChart(salesSpots)),
          ),
          const SizedBox(height: 16),
          const Text(
            "Dòng tiền theo phương thức thanh toán",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          _buildPaymentMethodRow("Tiền mặt", formatCurrency(totalSales)),
          // const Divider(),
          // _buildPaymentMethodRow("Đã ghi nợ", "N/A"),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodRow(String method, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(method, style: const TextStyle(fontSize: 16)),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: method == "Đã ghi nợ" ? Colors.orange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
