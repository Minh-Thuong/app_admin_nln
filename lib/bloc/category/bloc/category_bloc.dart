import 'package:admin/models/category_model.dart';
import 'package:admin/repository/category_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ICategoriesRepository _categoriesRepository;
  final List<Category> _categories = [];

  CategoryBloc(this._categoriesRepository) : super(CategoryInitial()) {
    on<CreateCategoryRequested>(_onCreateProductRequested);
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onCreateProductRequested(
      CreateCategoryRequested event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final result =
          await _categoriesRepository.createCategory(event.name, event.image);
      _categories.add(result);

      emit(CategoryCreated(result));
      emit(CategoryLoaded(_categories)); // Cập nhật UI bằng danh sách mới
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
  // Future<void> _onCreateProductRequested(
  //     CreateCategoryRequested event, Emitter<CategoryState> emit) async {
  //   try {
  //     final newCategory =
  //         await _categoriesRepository.createCategory(event.name, event.image);

  //     if (state is CategoryLoaded) {
  //       final updatedCategories =
  //           List<Category>.from((state as CategoryLoaded).categories)
  //             ..add(newCategory); // Thêm danh mục mới vào danh sách cũ

  //       emit(CategoryLoaded(updatedCategories));
  //     } else {
  //       emit(
  //           CategoryLoaded([newCategory])); // Nếu trước đó chưa có danh mục nào
  //     }
  //   } catch (e) {
  //     emit(CategoryError(e.toString()));
  //   }
  // }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final result = await _categoriesRepository.getCategories();
      emit(CategoryLoaded(result));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
