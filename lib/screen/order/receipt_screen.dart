import 'package:admin/models/order_model.dart';
import 'package:admin/service/forrmat.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

// Hàm load font từ assets
Future<pw.Font> loadFont(String path) async {
  final data = await rootBundle.load(path);
  return pw.Font.ttf(data);
}

Future<void> printInVoice(Order order) async {
  final pdf = pw.Document();
  // Load các file font từ assets
  final tinosRegular = await loadFont('fonts/Tinos-Regular.ttf');
  final tinosBold = await loadFont('fonts/Tinos-Bold.ttf');

  // Lấy thông tin từ đối tượng Order
  final orderId = order.id;
  final customerName = order.user!.name;
  final orderdate = formatDate(order.orderDate!);
  final deliveryDate = formatDate(order.deliveryDate!);
  final totalAmount = formatCurrency(order.totalAmount!);
  final orderDetails = order.orderDetails;

  // Tạo danh sách cho bảng chi tiết đơn hàng
  List<List<String>> invoiceData = [];
  for (var detail in orderDetails!) {
    final productName = detail.product?.name ?? 'Sản phẩm không xác định';
    final quantity = detail.quantity?.toString() ?? '0';
    final price = formatCurrency(detail.product?.price ?? 0.0);
    final total =
        formatCurrency((detail.quantity ?? 0) * (detail.product?.price ?? 0.0));
    invoiceData.add([productName, quantity, price, total]);
  }
  // Sử dụng URL của hình ảnh
  final logo = await networkImage(
      'https://res.cloudinary.com/dnwp3ccn7/image/upload/v1739813369/b3r0xolfjdjilchpnvme.png');

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Image(
                  logo,
                  height: 100.h,
                  width: 100.w,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text('HÓA ĐƠN BÁN HÀNG',
                    style: pw.TextStyle(
                      font: tinosBold,
                      fontSize: 24,
                    )),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text('Mã hóa đơn - $orderId',
                    style: pw.TextStyle(
                        font: tinosRegular,
                        fontSize: 18,
                        fontBold: pw.Font.courierBold())),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Khách hàng: $customerName',
                style: pw.TextStyle(
                  font: tinosRegular,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Địa chỉ: ${order.user!.address}',
                style: pw.TextStyle(
                  font: tinosRegular,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Email: ${order.user!.email}',
                style: pw.TextStyle(
                  font: tinosRegular,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Số điện thoại: ${order.user!.phone}',
                style: pw.TextStyle(
                  font: tinosRegular,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Row(children: [
                pw.Text(
                  'Ngày đặt: $orderdate',
                  style: pw.TextStyle(
                    font: tinosRegular,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                pw.Spacer(),
                pw.Text(
                  'Ngày giao: $deliveryDate',
                  style: pw.TextStyle(
                    font: tinosRegular,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ]),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(
                  font: tinosBold,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellStyle: pw.TextStyle(
                  font: tinosRegular,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 15,
                ),
                headers: ['Sản phẩm', 'Số lượng', 'Đơn giá', 'Thành tiền'],
                data: invoiceData,
              ),
              pw.SizedBox(height: 20),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text(
                  'Tổng cộng: $totalAmount',
                  style: pw.TextStyle(
                    font: tinosBold,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ])
            ],
          ),
        ];
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

// Hàm tải ảnh từ URL và trả về MemoryImage
Future<pw.MemoryImage> networkImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return pw.MemoryImage(response.bodyBytes);
  } else {
    throw Exception('Lỗi khi tải hình ảnh từ URL');
  }
}
