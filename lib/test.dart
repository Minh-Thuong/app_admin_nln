import 'package:flutter/material.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // 4 Tab: Sản phẩm, Tồn kho, Bán kèm, Danh mục
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          // Thanh tìm kiếm nằm trong AppBar
          title: SizedBox(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Tìm tên, mã SKU, ...",
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
          // TabBar
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Sản phẩm"),
              Tab(text: "Tồn kho"),
              Tab(text: "Bán kèm"),
              Tab(text: "Danh mục"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Tab "Sản phẩm"
            ProductGridView(),
            // Tab "Tồn kho"
            Center(child: Text("Tồn kho")),
            // Tab "Bán kèm"
            Center(child: Text("Bán kèm")),
            // Tab "Danh mục"
            Center(child: Text("Danh mục")),
          ],
        ),
        // Nút thêm mới
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            // Xử lý khi bấm thêm sản phẩm
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: Colors.grey.shade200, // Nền xám nhạt
      ),
    );
  }
}

// Widget hiển thị danh sách sản phẩm dạng lưới (2 cột)
class ProductGridView extends StatelessWidget {
  const ProductGridView({Key? key}) : super(key: key);

  // Demo dữ liệu sản phẩm
  final List<Map<String, dynamic>> demoProducts = const [
    {
      "name": "Aaffff",
      "price": 118.0,
      "stockInfo": "Có thể bán: 50 | 1 tô",
      "imageIcon": Icons.restaurant, // icon demo
    },
    {
      "name": "Phở bò",
      "price": 30000.0,
      "stockInfo": "Có thể bán: 98 | 1 tô",
      "imageIcon": Icons.restaurant_menu,
    },
    {
      "name": "Sản phẩm 3",
      "price": 45000.0,
      "stockInfo": "Có thể bán: 10 | 1 tô",
      "imageIcon": Icons.coffee,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: demoProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,         // Hiển thị 2 cột
          mainAxisSpacing: 8.0,      // Khoảng cách dọc
          crossAxisSpacing: 8.0,     // Khoảng cách ngang
          childAspectRatio: 0.8,     // Tỉ lệ khung hình của mỗi item
        ),
        itemBuilder: (context, index) {
          final product = demoProducts[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}

// Widget hiển thị 1 thẻ sản phẩm (Card)
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = product["name"];
    final price = product["price"];
    final stockInfo = product["stockInfo"];
    final iconData = product["imageIcon"] as IconData?;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          // Xử lý khi bấm vào sản phẩm (mở trang chi tiết / sửa)
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Khu vực icon sản phẩm
              Expanded(
                child: iconData != null
                    ? Icon(iconData, size: 40, color: Colors.grey)
                    : const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              // Tên sản phẩm
              Text(
                name.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Giá sản phẩm
              Text(
                "${price.toString()} đ",
                style: const TextStyle(color: Colors.orange, fontSize: 13),
              ),
              const SizedBox(height: 2),
              // Thông tin tồn kho / bán kèm
              Text(
                stockInfo.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              // Nút chia sẻ / tùy chọn (demo)
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.share, size: 18, color: Colors.blue),
                  onPressed: () {
                    // Xử lý chia sẻ sản phẩm
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
