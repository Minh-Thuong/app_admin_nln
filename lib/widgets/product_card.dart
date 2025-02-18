
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    final name = product["name"];
    final price = product["price"];
    final stockInfo = product["stockInfo"];
    final iconData = product["imageIcon"] as IconData ?? Icons.image;

    return Card(
        color: const Color.fromARGB(255, 233, 241, 234),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
            onTap: () {
              // Xử lý khi bấm vào sản phẩm (mở trang chi tiết / sửa)
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  // Khu vực icon sản phẩm
                  const Expanded(
                    child: Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Tên sản phẩm
                  Text(
                    name.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Giá sản phẩm
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
                  IconButton(
                    icon: const Icon(Icons.share, size: 18, color: Colors.blue),
                    onPressed: () {
                      // Xử lý chia sẻ sản phẩm
                    },
                  ),
                ]))));
  }
}
