import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/data/models/recipe.dart';
import 'package:recipe/data/repositories/recipe_repository.dart';

part 'recipe_list_state.dart';

class RecipeListCubit extends Cubit<RecipeListState> {
  final RecipeRepository _recipeRepository;

  RecipeListCubit({required RecipeRepository recipeRepository})
      : _recipeRepository = recipeRepository,
        super(RecipeListInitial());

  Future<void> onRecipeLoaded() async {
    try {
      emit(RecipeListLoadInProgress());
      final recipes = await _recipeRepository.getRecipeList() ?? [];
      emit(RecipeListLoadSuccess(recipes: recipes));
    } catch (e) {
      emit(RecipeListLoadFailure(error: e));
    }
  }
}
