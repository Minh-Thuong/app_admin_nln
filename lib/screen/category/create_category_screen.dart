import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/util/image_handler.dart';
import 'package:admin/widgets/product_form_widgets.dart';
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

  void createCategory() {
    if (_categoryNameController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập tên và chọn ảnh")),
      );
      return;
    }

    print("$_selectedImage");
    context.read<CategoryBloc>().add(CreateCategoryRequested(
        name: _categoryNameController.text, image: _selectedImage!));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
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
            onPressed: () => selectImages(context, _imagePicker, (image) {
              setState(() {
                _selectedImage = image;
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
            _selectedImage == null
                ? Container(
                    alignment: Alignment.center,
                    color: Colors.greenAccent,
                    height: 40.h,
                    child: Text(
                      "Chưa có ảnh nào",
                      textAlign: TextAlign.center,
                    ),
                  )
                : buildImagePreview(
                    _selectedImage!,
                    () => setState(() {
                          _selectedImage = null;
                        })),
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
}
