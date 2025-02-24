// Widget hiển thị 1 thẻ sản phẩm (Card)
import 'package:admin/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color.fromARGB(255, 152, 187, 134))),
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
                flex: 2,
                child: product.profileImage != null
                    ? Image.network(product.profileImage!)
                    : const Icon(Icons.image, size: 70, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Tên sản phẩm
              Text(
                product.name.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Giá sản phẩm
              Text(
                "${product.price.toString()} đ",
                style: const TextStyle(color: Colors.orange, fontSize: 13),
              ),
              const SizedBox(height: 2),
              // Thông tin tồn kho / bán kèm
              Text(
                product.stock.toString(),
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
