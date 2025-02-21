part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

// class GetCategories extends CategoryEvent {}

class CreateCategoryRequested extends CategoryEvent {
  final String name;
  final XFile image;
  // final BuildContext context; // Để hiển thị SnackBar

  const CreateCategoryRequested(
      {required this.name, required this.image});

  @override
  List<Object> get props => [name, image];
}
