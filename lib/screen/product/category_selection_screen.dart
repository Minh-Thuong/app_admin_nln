import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/models/category_model.dart';
import 'package:admin/widgets/category_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySelectionScreen extends StatefulWidget {
  final List<Category> initiallySelected;

  const CategorySelectionScreen({
    super.key,
    required this.initiallySelected,
  });

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  Category? _selected;

  @override
  void initState() {
    super.initState();
    if (widget.initiallySelected.isNotEmpty) {
      _selected = widget.initiallySelected.first;
    }
  }

  void _toggleCategory(Category cat) {
    setState(() {
      // Nếu cat đang được chọn, cập nhật _selected = null
      if (_selected?.id == cat.id) {
        _selected = null;
      } else {
        _selected = cat;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<CategoryBloc>(context).state is CategoryInitial) {
      context.read<CategoryBloc>().add(LoadCategories());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Danh mục")),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryLoaded) {
            return buildCategoryGrid(
                state.categories, _selected, _toggleCategory);
          }
          return const Center(child: Text("Không thể tải danh mục"));
        },
      ),
      bottomNavigationBar: buildBottomButtons(context, _selected),
    );
  }
}
