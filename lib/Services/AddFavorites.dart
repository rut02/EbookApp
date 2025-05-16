import 'dart:convert';
import 'package:ebookapp/main.dart';
import 'package:ebookapp/models/GetFavoriteByUserBook.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ebookapp/Services/DeleteFavorites.dart';

class AddFavorites {
  
  static Future<GetFavoriteByUserBook?> addFavorite(
    
    int? userIdUser, int bookID) async {
    String checkUrl = 'http://'+ip+':8080/api/favorites/user/$userIdUser/book/$bookID';
    final checkResponse = await http.get(Uri.parse(checkUrl));
    String status = checkResponse.body;
    
    if (checkResponse.statusCode == 200 && status == '[]') {
      
      String addUrl = 'http://'+ip+':8080/api/favorites';

      final Map<String, dynamic> requestData = {
        'user': {
          'id': userIdUser,
        },
        'book': {
          'id': bookID,
        },
      };

      final jsonBody = jsonEncode(requestData);
      final response = await http.post(
        Uri.parse(addUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('');
      } else {
        print('adding book to favorites');
      }
    }
    else{
      DeleteFavorites.deleteFavorite(userIdUser, bookID);
    }
  }
}
