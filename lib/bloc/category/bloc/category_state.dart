part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

class CategoryCreated extends CategoryState {
  final Category category;

  const CategoryCreated(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryUpdated extends CategoryState {
  final Category category;

  const CategoryUpdated(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryDeleted extends CategoryState {}
