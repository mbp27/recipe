import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:recipe/data/http/recipe_http.dart';
import 'package:recipe/helpers/utils.dart';

class RecipeProvider {
  final _recipeHttp = RecipeHttp();

  /// Get recipe list
  Future<List?> getRecipeList() async {
    try {
      final response = await _recipeHttp.getRecipeList();
      if (response.statusCode == 200) {
        final file = await Utils.saveFile(
          bodyBytes: response.bodyBytes,
          filenameWithExt: 'recipe.json',
        );
        final data = await file.readAsString();
        return json.decode(data);
      } else {
        throw '${response.statusCode} : ${response.reasonPhrase}';
      }
    } catch (e) {
      if (e is SocketException || e is ClientException) {
        throw 'Check internet connection';
      } else {
        rethrow;
      }
    }
  }
}
