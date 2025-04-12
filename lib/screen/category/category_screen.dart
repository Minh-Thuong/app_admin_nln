import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/screen/category/category_detail_screen.dart';
import 'package:admin/screen/category/create_category_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khi màn hình CategoryScreen được mở, gọi sự kiện LoadCategories
    context.read<CategoryBloc>().add(LoadCategories());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh mục"),
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          if (state is CategoryLoaded) {
            final categories = state.categories;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailScreen(
                            category: category,
                          ),
                        ),
                      );

                      // // Refresh the category list when returning
                      // if (result == true && context.mounted) {
                      //   context.read<CategoryBloc>().add(LoadCategories());
                      // }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: category.profileImage != null
                                ? DecorationImage(
                                    image: NetworkImage(category.profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: category.profileImage == null
                              ? const Center(
                                  child: Icon(Icons.image_not_supported))
                              : null,
                        ),
                        Text(
                          category.name ?? 'Tên không có',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: Text("Không có danh mục"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateCategoryScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
