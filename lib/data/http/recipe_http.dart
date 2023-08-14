import 'package:http/http.dart' as http;

class RecipeHttp {
  static const String _baseUrl = 'drive.google.com';
  static const String _path = 'uc';

  Future<http.Response> getRecipeList() {
    Map<String, dynamic> queryParameters = {
      "export": "view",
      "id": "1YbwUtLryvgOj3WecfqSVYif18kgdwGp8",
    };

    return http.get(Uri.https(_baseUrl, _path, queryParameters));
  }
}
