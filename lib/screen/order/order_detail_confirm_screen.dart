import 'package:admin/bloc/order/bloc/order_bloc.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/models/order_status.dart';
import 'package:admin/models/user.dart';
import 'package:admin/service/forrmat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderDetailConfirmScreen extends StatefulWidget {
  final Order order;
  const OrderDetailConfirmScreen({super.key, required this.order});

  @override
  State<OrderDetailConfirmScreen> createState() =>
      _OrderDetailConfirmScreenState();
}

class _OrderDetailConfirmScreenState extends State<OrderDetailConfirmScreen> {
  Order? _order;
  @override
  void initState() {
    super.initState();
    context
        .read<OrderBloc>()
        .add(OrderGetDetail(orderId: widget.order.id!)); // Load order details
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Cho phép pop màn hình
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context
              .read<OrderBloc>()
              .add(OrderGetList(status: OrderStatus.CONFIRMED));
        }
      },
      child: BlocConsumer<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading && _order == null) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }

          if (state is OrderError && _order == null) {
            print("Error: ${state.message}");
            return Scaffold(
                body: Center(child: Text("Lỗi không thể tải dữ liệu")));
          }

          if (state is OrderDetailLoaded) {
            _order = state.order;
          }

          if (_order != null) {
            final order = _order!;
            final products = order.orderDetails;

            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 221, 235, 222),
              appBar: AppBar(
                title: const Text("Chi tiết đơn hàng"),
                backgroundColor: Colors.green,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        _buildOrderInfoSection(order.orderDate.toString()),
                        const SizedBox(height: 8),
                        _buildAddressSection(order.user!),
                        const SizedBox(height: 8),
                        _buildPaymentMethodSection(),
                        const SizedBox(height: 8),
                        _buildParcelInfoSection(
                            order.totalAmount ?? 0.0, OrderStatus.CONFIRMED),
                        const SizedBox(height: 8),
                        ...products!.map(
                          (e) {
                            return _buildProductItem(
                              title: e.product!.name ?? 'Unknown Product',
                              subtitle: e.product!.description ??
                                  'Unknown Description',
                              price: e.product!.price ?? 0.0,
                              quantity: e.quantity ?? 0,
                              image: e.product!.profileImage ?? '',
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  _buildBottomBar(order),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
        listener: (BuildContext context, OrderState state) {
          if (state is OrderStatusUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Đã cập nhật đơn hàng thành công",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            Navigator.pop(context);
          } else if (state is OrderStatusUpdateError) {
            print("Lỗi xác nhận đơn hàng: ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Sản phẩm không đủ để cung cấp",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderInfoSection(String dbDateString) {
    String isoDateString = dbDateString.replaceFirst(" ", "T");
    DateTime orderDate = DateTime.parse(isoDateString).toLocal();
    String formattedDate = DateFormat("dd/MM/yyyy, HH:mm").format(orderDate);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Đơn hàng #${widget.order.id}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Đặt ngày: $formattedDate",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(User user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Địa chỉ nhận hàng",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${user.name} - ${user.phone}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${user.email}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "${user.address}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: const Text(
          "Hình thức thanh toán",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            "Thanh toán khi nhận hàng (COD)",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildParcelInfoSection(double totalamount, OrderStatus status) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kiện hàng",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    // OrderStatus.PENDING.description.toString(),
                    status.description.toString(),
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng tiền",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formatCurrency(totalamount),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem({
    required String title,
    required String subtitle,
    required double price,
    required String image,
    required int quantity,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: image != null
                  ? CachedNetworkImage(imageUrl: image, fit: BoxFit.cover)
                  : Icon(
                      Icons.image_not_supported,
                      size: 60,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "Số luong: $quantity",
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Text(
                    "$price đ",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Order order) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 16), 
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: Size(150.w, 0),
            alignment: Alignment.center,
          ),
          onPressed: () {
            _showDeleteConfirmationDialog(
                context,
                order,
                "Bạn có chắc chắn muốn đổi trạng thái đơn hàng không?",
                Colors.green,
                "Đã cập nhật đơn hàng thành công", () {
              context.read<OrderBloc>().add(OrderUpdateStatus(
                  orderId: order.id!, status: OrderStatus.DELIVERED));
            });
          },
          child: const Text(
            "Đã giao hàng",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Order order,
      String description, Color color, String annouce, VoidCallback onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận"),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                onTap();
                Navigator.pop(context);
              },
              child: Text("Đồng ý", style: TextStyle(color: color)),
            ),
          ],
        );
      },
    );
  }
}
