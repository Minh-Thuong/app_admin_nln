/// Model Salesdata
class Salesdata {
  final Map<DateTime, double> dailySales;
  final int totalOrders;

  Salesdata({required this.dailySales, required this.totalOrders});

  factory Salesdata.fromJson(Map<String, dynamic> json) {
    Map<DateTime, double> salesMap = {};
    (json['dailySales'] as Map<String, dynamic>).forEach((key, value) {
      salesMap[DateTime.parse(key)] = (value as num).toDouble();
    });
    return Salesdata(
      dailySales: salesMap,
      totalOrders: json['totalOrders'] as int,
    );
  }
}