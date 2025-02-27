// Widget hiển thị 1 thẻ sản phẩm (Card)
import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/screen/product/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRefresh; // Callback để tải lại dữ liệu
  const ProductCard({super.key, required this.product, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    // Tối ưu hóa URL ảnh với kích thước nhỏ hơn
    String optimizedUrl = "${product.profileImage}?w=150&h=150&c=fill";
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color.fromARGB(255, 152, 187, 134))),
      child: InkWell(
        onTap: () {
         // Chuyển sang ProductDetailScreen và chờ kết quả
          final result = Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      product: product,
                    )),
          );
          if (result == true) {
            onRefresh();
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Khu vực hình ảnh sản phẩm
              Expanded(
                flex: 2,
                child: product.profileImage != null
                    ? CachedNetworkImage(
                        imageUrl: optimizedUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Image.asset(
                          'assets/placeholder.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          size: 70,
                          color: const Color.fromARGB(255, 207, 204, 204),
                        ),
                        fadeInDuration: const Duration(
                            milliseconds: 200), // Tăng tốc hiệu ứng
                        fadeOutDuration: const Duration(milliseconds: 200),
                      )
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
