import 'dart:io';

import 'package:admin/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreen();
}

class _CreateCategoryScreen extends State<CreateCategoryScreen> {
  // Các TextEditingController cho thông tin sản phẩm
  final TextEditingController _categoryNameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

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
  final List<Category> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(child: const Text("Thêm danh mục")),
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
              _buildTextField(
                  label: "Tên danh mục", controller: _categoryNameController),
              SizedBox(
                height: 8.h,
              ),
              const SizedBox(height: 8),
              // nhập mô tả danh mục
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
