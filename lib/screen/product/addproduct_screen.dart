import 'dart:io';

import 'package:admin/models/category_model.dart';
import 'package:admin/screen/product/category_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Các TextEditingController cho thông tin sản phẩm
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await _imagePicker.pickMultiImage(
      requestFullMetadata: true, // Đảm bảo metadata đầy đủ để so sánh ảnh
    );

    if (selectedImages.isNotEmpty) {
      setState(() {
        for (var img in selectedImages) {
          // Kiểm tra xem ảnh đã tồn tại trong danh sách hay chưa
          bool alreadyExists =
              imageFileList.any((file) => file.path == img.path);

          // Chỉ thêm ảnh nếu nó chưa tồn tại
          if (!alreadyExists) {
            imageFileList.add(img);
          }
        }
      });
    }
  }

  // Xóa ảnh khỏi danh sách
  void removeImage(int index) {
    setState(() {
      imageFileList.removeAt(index);
    });
  }

  // Chỉ chọn một danh mục
  Category? _selectedCategory;

  // Mở màn hình chọn danh mục
  void _openCategorySelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(
          initiallySelected: _selectedCategory != null 
              ? [_selectedCategory!] 
              : [],
        ),
      ),
    );
    
    // Kiểm tra xem có chọn danh mục mới không
    if (result != null) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Thêm sản phẩm"),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 24,
            icon: const Icon(Icons.camera_enhance),
            onPressed: selectImages,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh sản phẩm
            Container(
              height: imageFileList.isEmpty ? 100 : 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 213, 226, 214),
                borderRadius: BorderRadius.circular(8),
              ),
              child: imageFileList.isEmpty
                  ? const Center(
                      child: Text(
                        "Chưa có ảnh nào",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 120.w,
                      ),
                      itemCount: imageFileList.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            // Hiển thị ảnh với bo tròn góc
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.w),
                                  child: Image.file(
                                    File(imageFileList[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            // Nút xóa được căn giữa trong container
                            Positioned(
                              top: 0.w,
                              right: 0.w,
                              child: GestureDetector(
                                onTap: () {
                                  removeImage(index);
                                },
                                child: Container(
                                  width: 24.w,
                                  height: 24.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 195, 195, 192),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),

            SizedBox(height: 16.h),

            // Tên sản phẩm
            _buildTextField(
              label: "Tên sản phẩm", 
              controller: _productNameController
            ),
            
            SizedBox(height: 8.h),

            // Hàng Giá bán - Giá vốn
            Row(
              children: [
                Expanded(
                  child: _buildPriceField("Giá bán", _priceController),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriceField("Giá vốn", _costPriceController),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _buildPriceField("Giá khuyến mãi", _salePriceController),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    label: "Số lượng",
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            
            // Mã sản phẩm - Mã vạch
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: "Mã sản phẩm",
                    controller: _productCodeController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    label: "Mã vạch",
                    controller: _barcodeController,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () {
                        // Quét mã vạch
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Phần chọn danh mục
            _buildCategorySelection(),

            const SizedBox(height: 16),

            // Mô tả sản phẩm
            _buildTextField(
              label: "Mô tả",
              controller: _descriptionController,
              maxLines: 3,
            ),
            
            const SizedBox(height: 16),

            // Các nút lưu và hủy
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Hủy",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 61, 194, 103),
                    ),
                    onPressed: _saveProduct,
                    child: const Text(
                      "Lưu và thêm mới",
                      style: TextStyle(color: Colors.white),
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

  // Widget hiển thị phần chọn danh mục
  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Danh mục"),
        const SizedBox(height: 8),
        Row(
          children: [
            // Hiển thị danh mục đã chọn hoặc thông báo chưa chọn
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
                      label: Text(_selectedCategory?.name ?? 'Unknown'),
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
            const SizedBox(width: 8),
            // Nút chọn danh mục
            OutlinedButton.icon(
              onPressed: _openCategorySelection,
              icon: const Icon(Icons.category),
              label: Text(_selectedCategory == null ? "Chọn danh mục" : "Đổi danh mục"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Lưu sản phẩm
  void _saveProduct() {
    // Kiểm tra dữ liệu
    if (_productNameController.text.isEmpty) {
      _showError("Vui lòng nhập tên sản phẩm");
      return;
    }

    if (_selectedCategory == null) {
      _showError("Vui lòng chọn danh mục");
      return;
    }

    // TODO: Thực hiện lưu sản phẩm
    
    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Lưu sản phẩm thành công"),
        backgroundColor: Colors.green,
      ),
    );
    
    // Xóa dữ liệu đã nhập để thêm sản phẩm mới
    _clearForm();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Xóa form để thêm sản phẩm mới
  void _clearForm() {
    setState(() {
      _productNameController.clear();
      _priceController.clear();
      _costPriceController.clear();
      _salePriceController.clear();
      _productCodeController.clear();
      _quantityController.clear();
      _descriptionController.clear();
      _barcodeController.clear();
      imageFileList.clear();
      _selectedCategory = null;
    });
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  // Tạo TextField cho giá (giá bán, giá vốn, giá khuyến mãi)
  Widget _buildPriceField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "0.000",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  // Tạo TextField
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    Widget? suffixIcon, 
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}