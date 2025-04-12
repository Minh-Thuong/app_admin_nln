import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void handleProductState(
    BuildContext context,
    ProductState state,
    VoidCallback clearForm,
    VoidCallback onUpdate,
) {
  if (state is ProductError) {
    Navigator.pop(context); // Đóng dialog
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Sản phẩm đã tồn tại")));
  }
  if (state is ProductCreated) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Lưu thành công")));
    clearForm();
    Navigator.pop(context); // Đóng dialog
    Navigator.of(context).pop(true);
  }
  if (state is ProductUpdated) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Cập nhật thành công")));
    clearForm();
    Navigator.pop(context); // Đóng dialog
    Navigator.of(context).pop(true);
    onUpdate(); // Gọi callback để cập nhật danh sách
  }
  if (state is ProductDeleted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Xóa sản phẩm thành công")));
    clearForm();
    Navigator.of(context).pop(true);
    onUpdate(); // Gọi callback để cập nhật danh sách
  }
}