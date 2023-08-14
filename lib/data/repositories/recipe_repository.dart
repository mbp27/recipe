import 'package:recipe/data/models/recipe.dart';
import 'package:recipe/data/providers/recipe_provider.dart';

class RecipeRepository {
  final _recipeProvider = RecipeProvider();

  /// Get recipe list
  Future<List<Recipe>?> getRecipeList() async {
    try {
      final data = await _recipeProvider.getRecipeList();
      final list = data?.map((e) => Recipe.fromMap(e)).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }
}
