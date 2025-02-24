import 'dart:io';

import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/datasource/category_datasource.dart';
import 'package:admin/dio/dio_client.dart';
import 'package:admin/models/category_model.dart';
import 'package:admin/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  // Khởi tạo CategoryRemote với Dio instance
  final dio = DioClient.instance;

  // late CategoryBloc _categoryBloc;

  // @override
  // void initState() {
  //   super.initState();
  //   _categoryBloc =
  //       CategoryBloc(CategoriesRepository(CategoryRemote(dio: dio)));
  // }

  Future<XFile?> compressImage(XFile image) async {
    final filePath = image.path;
    final lastIndex = filePath.lastIndexOf('.');
    final outPath = "${filePath.substring(0, lastIndex)}_compressed.jpg";
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 75, // Giảm chất lượng ảnh xuống 75% để giảm dung lượng
    );

    return compressedFile;
  }

  void selectImages() async {
    final XFile? selectedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (selectedImage != null) {
      final compressedImage = await compressImage(selectedImage);

      if (compressedImage != null) {
        final file = File(compressedImage.path);
        final fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          // 2MB
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ảnh vẫn quá lớn! Hãy thử ảnh khác.")),
          );
          return;
        }

        setState(() {
          _selectedImage = compressedImage;
        });
      }
    }
  }

  void createCategory() {
    if (_categoryNameController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập tên và chọn ảnh")),
      );
      return;
    }

    // Tạo sự kiện gửi dữ liệu ảnh và tên danh mục lên server
    // _categoryBloc.add(CreateCategoryRequested(
    //   name: _categoryNameController.text,
    //   image: _selectedImage!,
    // ));
    context.read<CategoryBloc>().add(CreateCategoryRequested(
        name: _categoryNameController.text, image: _selectedImage!));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  // Hàm xóa ảnh khi người dùng nhấn vào nút "X"
  void removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

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
            onPressed: selectImages,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImage != null) closeImage(),
            SizedBox(
              height: 16.h,
            ),
            buildTextField(
                label: "Tên danh mục", controller: _categoryNameController),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  flex: 1,
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
                BlocConsumer<CategoryBloc, CategoryState>(
                  listener: (context, state) {
                    if (state is CategoryError) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Danh mục đã tồn tại")),
                      );
                    }
    
                    if (state is CategoryCreated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Tạo danh mục thành công")),
                      );
                      _categoryNameController.clear();
                      setState(() {
                        _selectedImage = null;
                      });
                      Navigator.of(context).pop(); // Close loading dialog
                      // Trở lại màn hình CategoryScreen và phát sự kiện LoadCategories
                      Navigator.pop(context,
                          true); // Quay lại màn hình trước đó (CategoryScreen)
                      // context.read<CategoryBloc>().add(
                      //     LoadCategories()); // Yêu cầu tải lại danh mục mới
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 61, 194, 103),
                        ),
                        onPressed: createCategory,
                        child: Text(
                          "Lưu và thêm mới",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget closeImage() {
    return Stack(
      children: [
        // hiển thị ảnh
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(_selectedImage!.path),
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
          ),
        ),
        // Dấu "X" ở góc trên bên phải ảnh
        Positioned(
          top: 0.h,
          right: 0.w,
          child: GestureDetector(
            onTap: removeImage,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Center(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildTextField(
      {required String label,
      required TextEditingController controller,
      Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(label),
        TextField(
          textInputAction: TextInputAction.done,
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: suffixIcon, border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
