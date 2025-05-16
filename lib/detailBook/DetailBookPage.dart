import 'package:ebookapp/Services/AddFavorites.dart';
import 'package:ebookapp/detailBook/storypage.dart';
import 'package:ebookapp/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebookapp/homepage/base64imageCon.dart';

class DetailBookPage extends StatefulWidget {
  final int index;
  final String title;
  final int bookID;
  final String authorID;
  final String genreID;
  final String date;
  final String des;
  int? user_ID_user;
  bool isFavorite = false;

  Future<int?> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userID = pref.getInt('userID');
    return userID;
  }

  DetailBookPage({
    required this.index,
    required this.title,
    required this.bookID,
    required this.authorID,
    required this.genreID,
    required this.date,
    required this.des,
  });

  @override
  _DetailBookPageState createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  @override
  void initState() {
    super.initState();
    widget.getUserID().then((userID) {
      setState(() {
        widget.user_ID_user = userID;
      });

      if (widget.user_ID_user != null) {
        checkIcon(widget.user_ID_user, widget.bookID);
      }
    });
  }

  Future<void> checkIcon(int? userIdUser, int bookID) async {
    String checkUrl =
        'http://'+ip+':8080/api/favorites/user/$userIdUser/book/$bookID';
    final checkResponse = await http.get(Uri.parse(checkUrl));
    String keepdata = checkResponse.body;

    if (checkResponse.statusCode == 200) {
      if (keepdata != '[]') {
        setState(() {
          widget.isFavorite = true;
        });
      } else {
        setState(() {
          widget.isFavorite = false;
        });
      }
    }
  }
    Future<void> addBookRating(String bookId, String userId, int rating) async {
  final Url = 'http://'+ip+':8080/api/ratings';
        final Map<String, dynamic> requestData = {

            "book":{
                "id":bookId,
            },
            "user":{
                "id":userId,
            },
            "rating":rating

      };

      final jsonBody = jsonEncode(requestData);
  final response = await http.post(
    Uri.parse(Url),
    headers: {'Content-Type': 'application/json'},
        body: jsonBody,
  );

  if (response.statusCode == 201) {
    // การส่งข้อมูลสำเร็จ
    print('Rating added successfully');
  } else {
    // การส่งข้อมูลไม่สำเร็จ
    print('Failed to add rating');
  }
}

  void _toggleFavorite() async {
    setState(() {
      widget.isFavorite = true;
      AddFavorites.addFavorite(widget.user_ID_user, widget.bookID);
    });
  }
  Future<double> fetchAverageRating(int index) async {
  final response = await http.get(Uri.parse('http://'+ip+':8080/api/ratings/avg/$index'));
  if (response.statusCode == 200) {
    return double.parse(response.body);
  } else {
    throw Exception('Failed to load average rating');
  }
}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   width: double.infinity,
            //   height: 200,
            //   child: Image.network(
            //     "https://example.com/book-cover.jpg",
            //     fit: BoxFit.cover,
            //   ),
            // ),
           
            SizedBox(height: 20),
            Text(
              widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Author: ${widget.authorID}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Date: ${widget.date}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Genre: ${widget.genreID}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Description:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              widget.des,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the story page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryPage(bookId: widget.bookID),
                        ),
                      );
                    },
                    child: Text('อ่าน'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.star, size: 15, color: Colors.yellow),
                      onPressed: () {
                        addBookRating(widget.bookID.toString(), widget.user_ID_user.toString(), 1);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.star, size: 15, color: Colors.yellow),
                      onPressed: () {
                        addBookRating(widget.bookID.toString(), widget.user_ID_user.toString(), 2);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.star, size: 15, color: Colors.yellow),
                      onPressed: () {
                        addBookRating(widget.bookID.toString(), widget.user_ID_user.toString(), 3);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.star, size: 15, color: Colors.yellow),
                      onPressed: () {
                        addBookRating(widget.bookID.toString(), widget.user_ID_user.toString(), 4);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.star, size: 15, color: Colors.yellow),
                      onPressed: () {
                        addBookRating(widget.bookID.toString(), widget.user_ID_user.toString(), 5);
                      },
                    ),
                  ],
                )

                             
              ],

            ),           FutureBuilder<double>(
            future: fetchAverageRating(widget.bookID), // Call your fetchAverageRating function here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the Future is still running, show a loading indicator
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If the Future throws an error, display the error message
                return Text('Error: ${snapshot.error}');
              } else {
                // If the Future is completed, display the fetched average rating
                double averageRating = snapshot.data ?? 0.0; // Use a default value if the data is null
                return Text(
                  'Average Rating: $averageRating',
                  style: TextStyle(fontSize: 10),
                );
              }
            },
          ),
          ],
        ),
      ),
    );
  }

}
