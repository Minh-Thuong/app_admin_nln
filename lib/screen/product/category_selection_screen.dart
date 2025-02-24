import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Màn hình chọn danh mục
class CategorySelectionScreen extends StatefulWidget {
  final List<Category> initiallySelected;
  
  // Chuyển initiallySelected thành danh sách và cho phép truyền danh sách rỗng
  const CategorySelectionScreen({
    super.key, 
    required this.initiallySelected,
  });

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  // Trạng thái của danh mục được chọn
  Category? _selected;

  @override
  void initState() {
    super.initState();
    // Nếu có danh mục đã chọn trước đó, sử dụng danh mục đầu tiên
    if (widget.initiallySelected.isNotEmpty) {
      _selected = widget.initiallySelected.first;
    }
  }

  // Kiểm tra danh mục có được chọn hay không
  bool _isSelected(Category cat) {
    return _selected?.id == cat.id;
  }

  // Toggle chọn hoặc bỏ chọn danh mục
  void _toggleCategory(Category cat) {
    setState(() {
      // Chỉ cho phép chọn 1 danh mục duy nhất
      _selected = (_isSelected(cat)) ? null : cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Chỉ load danh mục 1 lần khi màn hình mở
    if (BlocProvider.of<CategoryBloc>(context).state is CategoryInitial) {
      context.read<CategoryBloc>().add(LoadCategories());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh mục"),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (BuildContext context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CategoryLoaded) {
            final categories = state.categories;
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final selected = _isSelected(cat);
                      
                      return InkWell(
                        onTap: () {
                          _toggleCategory(cat); // Toggle chọn/bỏ chọn
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: selected 
                                        ? Border.all(color: Colors.green, width: 2) 
                                        : null,
                                      image: cat.profileImage != null
                                          ? DecorationImage(
                                              image: NetworkImage(cat.profileImage!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: cat.profileImage == null
                                        ? const Center(child: Icon(Icons.image_not_supported))
                                        : null,
                                  ),
                                  if (selected)
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                cat.name ?? 'Tên không có',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          // Trường hợp state không phải Loading hoặc Loaded
          return const Center(child: Text("Không thể tải danh mục"));
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Quay lại không trả kết quả
                },
                child: const Text("Hủy"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print(_selected);
                  // Trả danh mục _selected về màn hình trước
                  Navigator.pop<Category>(context, _selected);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Xác nhận"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}