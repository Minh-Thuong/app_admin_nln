import 'package:admin/bloc/order/bloc/order_bloc.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/models/order_status.dart';
import 'package:admin/screen/order/order_detail_deliver_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ListOrderDeliveredScreen extends StatefulWidget {
  const ListOrderDeliveredScreen({super.key});

  @override
  State<ListOrderDeliveredScreen> createState() =>
      _ListOrderDeliveredScreenState();
}

class _ListOrderDeliveredScreenState extends State<ListOrderDeliveredScreen> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OrderBloc>().add(OrderGetList(status: OrderStatus.DELIVERED));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.shade100,
      appBar: AppBar(
        title: const Text('Danh sách đơn hàng đã giao'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderError) {
            print("Tải đơn hàng delivered thất bại${state.message}");
            return Center(
              child: Text(
                'Tải đơn hàng thất bại',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is OrderLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(
                child: Text('Không có đơn hàng nào'),
              );
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OrderDetailDeliverScreen(order: orders[index]);
                      }));
                    },
                    child: _buildOrderCard(orders[index]));
              },
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final orderDetails = order.orderDetails;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Mã đơn: ${order.id.toString().substring(0, 8)}...',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    OrderStatus.DELIVERED.description,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Ngày đặt:  ${order.orderDate}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Divider(height: 1),

          ...orderDetails!.map((orderDetail) {
            final product = orderDetail.product;
            final String optimizedUrl =
                "${product?.profileImage}?w=150&h=150&c=fill";

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      child: product?.profileImage != null
                          ? CachedNetworkImage(
                              imageUrl: optimizedUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Icon(Icons.image,
                                    size: 70, color: Colors.grey);
                              },
                            )
                          : Icon(Icons.image, size: 70, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? "Sản phẩm không tên",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product?.description ?? "Sản phẩm không mô tả",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currencyFormatter.format(product?.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Số lượng: ${orderDetail.quantity}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          // Order total
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Tổng tiền: ${currencyFormatter.format(order.totalAmount)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),

          // User information
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Người đặt: ${order.user?.name} ",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Email: ${order.user?.email}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Địa chỉ: ${order.user?.address}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Handle contact action
                  },
                  icon: const Icon(Icons.call_outlined, size: 16),
                  label: const Text("Liên hệ"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return OrderDetailDeliverScreen(order: order);
                        }));
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green.shade700,
                        side: BorderSide(color: Colors.green.shade300),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text("Xem chi tiết"),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
