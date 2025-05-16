import 'dart:convert';
import 'package:ebookapp/main.dart';
import 'package:ebookapp/models/GetFavoriteByUserBook.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteFavorites {
  static Future<void> deleteFavorite(int? userIdUser, int bookID) async {
    String checkUrl =
        'http://'+ip+':8080/api/favorites/user/$userIdUser/book/$bookID';
    final checkResponse = await http.get(Uri.parse(checkUrl));

    if (checkResponse.statusCode == 200) {
      List<GetFavoriteByUserBook> favorites = getFavoriteListFromJson(checkResponse.body);
      
      for (var favorite in favorites) {
        int id = favorite.id;
        User user = favorite.user;
        Book book = favorite.book;
        print("$user and $book");

        String deleteUrl = 'http://'+ip+':8080/api/favorites/$id';
        final checkResponseDelete = await http.delete(Uri.parse(deleteUrl));
        
        if (checkResponseDelete.statusCode == 200) {
          print('Remove Favorite finish!!!');
        }
      }
    }
  }
}
