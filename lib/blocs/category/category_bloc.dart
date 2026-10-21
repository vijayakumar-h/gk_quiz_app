import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/quiz_data.dart';
import 'category_event.dart';
import 'category_state.dart';

export 'category_event.dart';
export 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryInitialState()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoadingState());
    try {
      final categories = await QuizData.loadCategories();
      emit(CategoryLoadedState(categories));
    } catch (e) {
      emit(CategoryErrorState('Failed to load categories: $e'));
    }
  }
}
