part of 'recipe_list_cubit.dart';

sealed class RecipeListState extends Equatable {
  const RecipeListState();

  @override
  List<Object?> get props => [];
}

class RecipeListInitial extends RecipeListState {}

class RecipeListLoadInProgress extends RecipeListState {}

class RecipeListLoadSuccess extends RecipeListState {
  final List<Recipe> recipes;

  const RecipeListLoadSuccess({
    required this.recipes,
  });

  @override
  List<Object?> get props => [recipes];
}

class RecipeListLoadFailure extends RecipeListState {
  final Object error;

  const RecipeListLoadFailure({
    required this.error,
  });
  @override
  List<Object?> get props => [error];
}
