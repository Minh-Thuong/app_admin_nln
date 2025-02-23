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
    on<UpdateCategoryRequested>(
        _onUpdateCategoryRequested); // Xử lý sự kiện cập nhật

    on<DeleteCategoryRequested>(_onDeleteCategoryRequested);
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

  // Xử lý sự kiện cập nhật danh mục
  Future<void> _onUpdateCategoryRequested(
      UpdateCategoryRequested event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final result = await _categoriesRepository.updateCategory(
          event.id, event.name, event.image);
      _categories.removeWhere(
          (category) => category.id == event.id); // Xóa danh mục cũ
      _categories.add(result); // Thêm danh mục đã được cập nhật
      emit(CategoryUpdated(result)); // Cập nhật thành công
      emit(CategoryLoaded(_categories)); // Cập nhật danh sách danh mục
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDeleteCategoryRequested(
      DeleteCategoryRequested event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      // Gọi phương thức xóa danh mục trong Repository
      await _categoriesRepository.deleteCategory(event.id);

      // Cập nhật danh sách danh mục sau khi xóa thành công
      _categories.removeWhere((category) => category.id == event.id);

      // Sau khi xóa, tải lại danh sách danh mục mới nhất từ repository (gọi lại API)
      final updatedCategories = await _categoriesRepository.getCategories();
      emit(
          CategoryLoaded(updatedCategories)); // Cập nhật lại danh sách danh mục
      emit(CategoryDeleted()); // Thông báo xóa thành công
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
