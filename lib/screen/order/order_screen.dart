import 'package:admin/screen/order/list_order_cancel_screen.dart';
import 'package:admin/screen/order/list_order_confirm_screen.dart';
import 'package:admin/screen/order/list_order_delivered_screen.dart';
import 'package:admin/screen/order/list_order_peding_screen.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý đơn hàng'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: ListView(children: [
          _builtListOrder(
              context,
              "Danh sách đơn hàng chờ duyệt",
              ListOrderPedingScreen(),
              Icon(
                Icons.pending_actions,
                color: Colors.redAccent,
                size: 35,
              )),
          _builtListOrder(
              context,
              "Danh sách đơn hàng đã duyệt",
              ListOrderConfirmScreen(),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 35,
              )),
          _builtListOrder(
              context,
              "Danh sách đơn hàng đã giao thành công",
              ListOrderDeliveredScreen(),
              Icon(
                Icons.shopping_cart,
                color: Colors.blue,
                size: 35,
              )),
          _builtListOrder(
              context,
              "Danh sách đơn hàng đã hủy",
              ListOrderCancelScreen(),
              Icon(
                Icons.cancel,
                color: Colors.grey,
                size: 35,
              )),
        ]));
  }

  Widget _builtListOrder(
      BuildContext context, String title, Widget page, Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: ListTile(
          title: Text(title),
          trailing: icon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }
}
