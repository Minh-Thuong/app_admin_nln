import 'package:admin/models/order_model.dart';

List<List<String>> parseInvoiceData(Order json) {
  List<List<String>> invoiceData = [];

  for (var item in json.orderDetails!) {
    invoiceData.add([
      item.product?.name ?? 'Unknown', // Tên sản phẩm
      item.quantity.toString(), // Số lượng
      item.product?.price.toString() ?? '0', // Đơn giá
      (item.quantity! * (item.product?.price ?? 0)).toString(), // Thành tiền
    ]);
  }

  return invoiceData;
}
