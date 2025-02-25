import 'dart:io';
import 'package:admin/bloc/product/bloc/product_bloc.dart';
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

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  Category? _selectedCategory;

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
            onPressed: () => selectImages(context, _imagePicker, (image) {
              setState(() => _selectedImage = image);
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
                    height: 40.h,
                    color: Colors.greenAccent,
                    alignment: Alignment.center,
                    child: const Text('Chưa có ảnh nào'))
                : buildImagePreview(_selectedImage!,
                    () => setState(() => _selectedImage = null)),
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
            buildCategorySelection(_selectedCategory, _openCategorySelection),
            SizedBox(height: 16.h),
            buildTextField(
                label: "Mô tả",
                controller: _descriptionController,
                maxLines: 3),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red)),
                    onPressed: () => Navigator.pop(context),
                    child:
                        const Text("Hủy", style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 16),
                BlocConsumer<ProductBloc, ProductState>(
                  listener: (context, state) =>
                      handleProductState(context, state, _clearForm),
                  builder: (context, state) {
                    return Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 61, 194, 103)),
                        onPressed: () => _saveProduct(),
                        child: const Text("Lưu và thêm mới",
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
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

  void _saveProduct() {
    if (_productNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _salePriceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")));
      return;
    }

    final product = Product(
      name: _productNameController.text,
      price: double.parse(_priceController.text),
      sale: double.parse(_salePriceController.text),
      stock: int.parse(_quantityController.text),
      description: _descriptionController.text,
      categoryId: _selectedCategory!.id,
      profileImage: _selectedImage?.path,
      category: '',
    );

    context.read<ProductBloc>().add(CreateProductRequest(product));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
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
