import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/datasource/category_datasource.dart';
import 'package:admin/dio/dio_client.dart';
import 'package:admin/repository/category_repository.dart';
import 'package:admin/screen/category/category_screen.dart';
import 'package:admin/screen/employee/employee_screen.dart';
import 'package:admin/screen/login/login_screen.dart';
import 'package:admin/screen/receipt/import_screen.dart';
import 'package:admin/screen/order/order_screen.dart';
import 'package:admin/screen/product/products_screen.dart';
import 'package:admin/screen/supplier/supplier_screen.dart';
import 'package:admin/screen/user/user_screen.dart';
import 'package:admin/util/auth_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các chức năng
    final List<Map<String, dynamic>> features = [
      {
        "icon": Icons.store,
        "label": "Quản lý sản phẩm",
        "color": const Color.fromARGB(255, 249, 12, 0),
        "page": const ProductsScreen()
      },
      {
        "icon": Icons.category,
        "label": "Quản lý danh mục",
        "color": const Color.fromARGB(255, 255, 191, 0),
        // "page":  BlocProvider(
        //   create: (context) => CategoryBloc(CategoriesRepository(CategoryRemote(dio: DioClient.instance))),
        //   child: const CategoryScreen(),
        // )
        "page": const CategoryScreen() // Bỏ BlocProvider ở đây
      },
      {
        "icon": Icons.shopping_cart,
        "label": "Quản lý đơn hàng",
        "color": const Color.fromARGB(255, 5, 36, 242),
        "page": const OrderScreen()
      },
      {
        "icon": Icons.person,
        "label": "Quản lý khách hàng",
        "color": const Color.fromARGB(255, 4, 164, 146),
        "page": const UserScreen()
      },
      {
        "icon": Icons.people,
        "label": "Quản lý nhân viên",
        "color": const Color.fromARGB(255, 174, 16, 137),
        "page": const EmployeeScreen()
      },
      {
        "icon": Icons.assignment,
        "label": "Quản lý phiếu nhập",
        "color": const Color.fromARGB(255, 95, 104, 96),
        "page": const ImportScreen()
      },
      {
        "icon": Icons.business,
        "label": "Quản lý nhà cung cấp",
        "color": const Color.fromARGB(255, 77, 232, 82),
        "page": const SupplierScreen()
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                "https://res.cloudinary.com/dnwp3ccn7/image/upload/v1739813369/b3r0xolfjdjilchpnvme.png",
                height: 40,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Quản lý cửa hàng',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthLogout(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          )
        ],
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return GestureDetector(
                  onTap: () {
                    final nextpage = feature['page'] as Widget;
                    debugPrint("Tapped product! $nextpage");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => nextpage),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          feature['icon'],
                          size: 40,
                          color: feature['color'],
                        ),
                        Text(
                          feature['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ));
            }),
      ),
    );
  }
}
