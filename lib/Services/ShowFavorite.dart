import 'package:ebookapp/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ebookapp/models/GetFavoriteByUserBook.dart';

class FavoriteByUserBook {
  
  static Future<List<GetFavoriteByUserBook>> GetFavoriteByUserId(int userIdUser) async {
    print(userIdUser);
    String checkUrl = 'http://'+ip+':8080/api/favorites/user/$userIdUser';
    final checkResponse = await http.get(Uri.parse(checkUrl));
    String check = checkResponse.body;
    if (checkResponse.statusCode == 200 && check != '[]') {
      List<GetFavoriteByUserBook> favorites = getFavoriteListFromJson(checkResponse.body);
      return favorites;
    } else {
      throw Exception('Response error');
    }
  }
}