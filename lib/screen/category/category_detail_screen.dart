import 'dart:io';
import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/models/category_model.dart';
import 'package:admin/util/image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Category category;

  const CategoryDetailScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late TextEditingController _categoryNameController;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isNetworkImage = false;
  String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController(text: widget.category.name);
    if (widget.category.profileImage != null) {
      _networkImageUrl = widget.category.profileImage;
      _isNetworkImage = true;
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  void _showDeleteDialog() {
    // hiển thị hộp thoại xác nhận
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa danh mục này?'),
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
                context.read<CategoryBloc>().add(
                      DeleteCategoryRequested(id: widget.category.id),
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

  void updateCategory() {
    if (_categoryNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tên danh mục")),
      );
      return;
    }
// Chỉ cần gửi tên mới nếu có thay đổi
    context.read<CategoryBloc>().add(
          UpdateCategoryRequested(
            id: widget.category.id,
            name: _categoryNameController.text,
            image: _selectedImage,
          ),
        );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
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
        width: double.infinity,
        height: 200.h,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, size: 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Chi tiết danh mục"),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.camera_enhance),
            onPressed: () {
              selectImages(context, _imagePicker, (image) {
                setState(() {
                  _selectedImage = image;
                });
              });
            },
          ),
        ],
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cập nhật danh mục thành công")),
            );
            Navigator.of(context).pop(); // Close loading dialog
            Navigator.of(context).pop(true); // Return to previous screen

            // Sau khi cập nhật thành công, tải lại danh sách
            context.read<CategoryBloc>().add(LoadCategories());
          } else if (state is CategoryError) {
            Navigator.of(context).pop(); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CategoryDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Xóa danh mục thành công")),
            );

            // Chờ một khoảng thời gian rồi quay lại màn hình danh mục
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop(true); // Quay lại màn hình danh mục
              context.read<CategoryBloc>().add(LoadCategories());
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageWidget(),
              SizedBox(height: 16.h),
              TextField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên danh mục',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showDeleteDialog,
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.red,
                        // backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text("Xóa"),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: updateCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 61, 194, 103),
                      ),
                      child: const Text("Cập nhật"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
