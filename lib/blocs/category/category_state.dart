import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitialState extends CategoryState {
  const CategoryInitialState();
}

class CategoryLoadingState extends CategoryState {
  const CategoryLoadingState();
}

class CategoryLoadedState extends CategoryState {
  final List<Map<String, dynamic>> categories;

  const CategoryLoadedState(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryErrorState extends CategoryState {
  final String message;

  const CategoryErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
