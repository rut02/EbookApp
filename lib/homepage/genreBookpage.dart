import 'dart:convert';
import 'package:ebookapp/detailBook/DetailBookPage.dart';
import 'package:ebookapp/homepage/base64imageCon.dart';
import 'package:ebookapp/main.dart';
import 'package:flutter/material.dart';
import 'package:ebookapp/models/GetAllBooks.dart';
import 'package:http/http.dart' as http;

class GenreBooksPage extends StatelessWidget {
  final String genre;
  final List<GetAllBooks> bookData;

  const GenreBooksPage({Key? key, required this.genre, required this.bookData})
      : super(key: key);

  Future<List<GetAllBooks>> searDataBooksbygenre(String query) async {
    String url = 'http://'+ip+':8080/api/books/search/genre/$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<GetAllBooks> booksList =
          data.map((json) => GetAllBooks.fromJson(json)).toList();
      return booksList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GetAllBooks>>(
      future: searDataBooksbygenre(genre),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var fetchedData = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: fetchedData.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBookPage(
                         title: fetchedData[index].title ?? 'No Title',
                          index: index,
                          authorID: fetchedData[index].authorId.authorName,
                          bookID: fetchedData[index].bookid ?? -1,
                          genreID: fetchedData[index].genreId.genreName,
                          date: fetchedData[index].publicationDate.toString(),
                          des: fetchedData[index].description ?? 'Nodes',
                      ),
                    ),
                  );
                },
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                          bottom: Radius.circular(10.0),
                        ),
                        child: Base64ImageConverter(
                          base64Image:
                              fetchedData[index].coverImageUrl ?? '', 
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            fetchedData[index].title ?? 'No Title',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
