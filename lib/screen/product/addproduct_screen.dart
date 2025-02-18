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
  final TextEditingController _productNameController =
      TextEditingController(text: "Aaffff");
  final TextEditingController _priceController =
      TextEditingController(text: "118");
  final TextEditingController _costPriceController =
      TextEditingController(text: "55");
  final TextEditingController _salePriceController =
      TextEditingController(text: "0.000");
  final TextEditingController _productCodeController =
      TextEditingController(text: "SP0001");
  final TextEditingController _quantityController =
      TextEditingController(text: "0");
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

  // Danh sách danh mục đã chọn
  List<Category> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(child: const Text("Thêm sản phẩm")),
        actions: [
          IconButton(
            iconSize: 40,
            icon: const Icon(Icons.camera_enhance),
            onPressed: () {
              selectImages();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(255, 213, 226, 214),
                child: Row(
                  children: [
                    Expanded(
                      child: imageFileList.isEmpty
                          ? const Center(
                              child: Text(
                                "Chưa có ảnh nào",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
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
                                          borderRadius:
                                              BorderRadius.circular(8.w),
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
                                          width: 30.w,
                                          height: 30.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color.fromARGB(
                                                255, 195, 195, 192),
                                          ),
                                          child: Center(
                                            // Đảm bảo icon nằm chính giữa container
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                              size: 18
                                                  .w, // Giảm kích thước icon để phù hợp hơn
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              // _buildLabel("Tên sản phẩm"),
              _buildTextField(
                  label: "Tên sản phẩm", controller: _productNameController),
              SizedBox(
                height: 8.h,
              ),
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
                    child: _buildPriceField(
                        "Giá khuyến mãi", _salePriceController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      label: "Số lượng",
                      controller: _quantityController,
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
              SizedBox(
                height: 8.h,
              ),
              // Danh mục (Chip) + Nút bấm
              Row(
                children: [
                  Text("Danh mục"),
                  SizedBox(width: 8),
                  // Nút bấm Mở màn hình chọn danh mục
                  OutlinedButton(
                    onPressed: () async {
                      // Mở màn hình chọn danh mục, chờ kết quả
                      final List<Category>? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorySelectionScreen(
                            initiallySelected: _selectedCategories,
                          ),
                        ),
                      );

                      if (result != null) {
                        // Kiểm tra nếu có danh mục được chọn
                        setState(() {
                          _selectedCategories = result;
                        });
                      }
                    },
                    child: const Text("Chọn danh mục"),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // hiển thị chip danh mục đã chọn
              Wrap(
                spacing: 8,
                children: _selectedCategories
                    .map((category) => Chip(
                          label: Text(category.name),
                          avatar: Icon(
                            category.icon,
                            size: 16,
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedCategories
                                  .remove(category); // Xóa danh mục khi bấm "X"
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              // nhập mô tả sản phẩm
              _buildTextField(
                label: "Mô tả",
                controller: _descriptionController,
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        side: const BorderSide(color: Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Hủy",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 0, 0))),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 61, 194, 103)),
                    onPressed: () {},
                    child: Text("Lưu và thêm mới",
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ])
            ],
          )),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Tạo TextField cho giá (giá bán, giá vốn, giá khuyến mãi)
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
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
