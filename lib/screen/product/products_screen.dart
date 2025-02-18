import 'package:admin/screen/product/addproduct_screen.dart';
import 'package:admin/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // actions: [
            //   IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back))
            // ],
            backgroundColor: Colors.green,
            elevation: 0,
            // thanh tim kiem nam trong appbar
            title: SizedBox(
              height: 40.h,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tim ten, ma SKU, ...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Sản phẩm"),
                  Tab(text: "Bán kèm"),
                  Tab(text: "Tồn kho"),
                ]),
          ),
          body: Stack(children: [
            TabBarView(
              children: [
                ProductGridView(),
                const Center(child: Text("Tồn kho")),
                // Tab "Bán kèm"
                const Center(child: Text("Bán kèm")),
              ],
            ),
            Positioned(
              bottom: 50.h,
              right: 25.w,
              child: FloatingActionButton(
                shape: CircleBorder(side: BorderSide(color: Colors.white)),
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductScreen(),
                    ),
                  );
                },
              ),
            ),
          ]),
        ));
  }
}


