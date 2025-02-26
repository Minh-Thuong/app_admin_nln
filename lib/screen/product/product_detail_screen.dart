import 'dart:io';
import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/bloc/category/bloc/category_bloc.dart'; // Thêm import
import 'package:admin/models/category_model.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/screen/product/category_selection_screen.dart';
import 'package:admin/service/product_form_logic.dart';
import 'package:admin/util/image_handler.dart';
import 'package:admin/widgets/product_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<ProductDetailScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isNetworkImage = false;
  String? _networkImageUrl;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.product.name ?? '';
    _priceController.text = widget.product.price.toString();
    _salePriceController.text = widget.product.sale.toString();
    _quantityController.text = widget.product.stock.toString();
    _descriptionController.text = widget.product.description ?? '';
    if (widget.product.profileImage != null) {
      _networkImageUrl = widget.product.profileImage;
      _isNetworkImage = true;
    }
    // Tải danh sách danh mục
    if (BlocProvider.of<CategoryBloc>(context).state is CategoryInitial) {
      context.read<CategoryBloc>().add(LoadCategories());
    }
  }

  void _showDeleteDialog() {
    // hiển thị hộp thoại xác nhận
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
          actions: [
            // nut hủy
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                context.read<ProductBloc>().add(
                      DeleteProductRequest(id: widget.product.id!),
                    );
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Widget _buildImageWidget() {
    if (_selectedImage != null) {
      return Image.file(
        File(_selectedImage!.path),
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
      );
    } else if (_isNetworkImage && _networkImageUrl != null) {
      return Image.network(
        _networkImageUrl!,
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 200.h,
        color: Colors.greenAccent,
        alignment: Alignment.center,
        child: const Text('Chưa có ảnh nào'),
      );
    }
  }

  Widget _buildCategorySelection() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          print(state.categories.toString());
          print("Selected category: ${_selectedCategory?.name}");
          if (_selectedCategory == null && widget.product.categoryId != null) {
            _selectedCategory = state.categories.firstWhere(
              (cat) => cat.id == widget.product.categoryId,
              orElse: () => Category(id: '', name: 'Không xác định'),
            );
          }
          print("Selected category: ${_selectedCategory?.name}");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Danh mục",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _selectedCategory == null
                      ? const Text(
                          "Chưa chọn danh mục",
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : Chip(
                          label: Text(_selectedCategory!.name),
                          avatar: const Icon(
                            Icons.category_sharp,
                            size: 16,
                            color: Colors.lightBlueAccent,
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedCategory = null;
                            });
                          },
                        ),
                ),
                SizedBox(width: 8.w),
                OutlinedButton.icon(
                  onPressed: _openCategorySelection,
                  icon: const Icon(Icons.category),
                  label: Text(_selectedCategory == null
                      ? "Chọn danh mục"
                      : "Đổi danh mục"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Chi tiết sản phẩm"), // Đổi tiêu đề phù hợp
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 24,
            icon: const Icon(Icons.camera_enhance),
            onPressed: () => selectImages(context, _imagePicker, (image) {
              setState(() {
                _selectedImage = image;
                print("Selected new image : ${_selectedImage?.path}");
              });
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWidget(),
            SizedBox(height: 16.h),
            buildTextField(
                label: "Tên sản phẩm", controller: _productNameController),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(child: buildPriceField("Giá bán", _priceController)),
                const SizedBox(width: 8),
                Expanded(
                    child: buildPriceField("Giá vốn", _salePriceController)),
              ],
            ),
            const SizedBox(height: 8),
            buildTextField(
                label: "Số lượng",
                controller: _quantityController,
                keyboardType: TextInputType.number),
            SizedBox(height: 16.h),
            _buildCategorySelection(), // Thay thế buildCategorySelection cũ
            SizedBox(height: 16.h),
            buildTextField(
                label: "Mô tả",
                controller: _descriptionController,
                maxLines: 3),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.red,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red)),
                    onPressed: () {
                      _showDeleteDialog();
                    },
                    label:
                        const Text("Xóa", style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 16),
                BlocListener<ProductBloc, ProductState>(
                  listener: (context, state) =>
                      handleProductState(context, state, _clearForm),
                  child: Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 61, 194, 103)),
                      onPressed: () => _updateproduct(),
                      child: const Text("Lưu",
                          style: TextStyle(
                              color: Colors.white)), // Đổi nút thành "Lưu"
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openCategorySelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(
            initiallySelected:
                _selectedCategory != null ? [_selectedCategory!] : []),
      ),
    );
    if (result != null) {
      setState(() => _selectedCategory = result);
    }
  }

  void _updateproduct() {
    if (_productNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _salePriceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }
// In đường dẫn của hình ảnh mới để kiểm tra
    print("Đường dẫn hình ảnh đã chọn: ${_selectedImage?.path}");

    Product updatedProduct = Product(
      id: widget.product.id,
      name: _productNameController.text,
      price: double.tryParse(_priceController.text) ?? widget.product.price,
      sale: double.tryParse(_salePriceController.text) ?? widget.product.sale,
      stock: int.tryParse(_quantityController.text) ?? widget.product.stock,
      description: _descriptionController.text,
      categoryId: _selectedCategory!.id, // Đảm bảo categoryId không null
      profileImage: _selectedImage?.path ??
          widget.product.profileImage, // Giữ URL hình ảnh cũ
      // Thêm các trường khác nếu cần (ví dụ: cloudinaryImageId)
      category: '',
    );

    context
        .read<ProductBloc>()
        .add(UpdateProductRequest(updatedProduct, _selectedImage));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _clearForm() {
    setState(() {
      _productNameController.clear();
      _priceController.clear();
      _salePriceController.clear();
      _quantityController.clear();
      _descriptionController.clear();
      _selectedImage = null;
      _selectedCategory = null;
    });
  }
}
