import 'package:ebookapp/homepage/base64imageCon.dart';
import 'package:ebookapp/models/GetAllBooks.dart';
import 'package:flutter/material.dart';
import 'package:ebookapp/detailBook/DetailBookPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSearchResults extends StatelessWidget {
  final List<GetAllBooks> bookData;

  ShowSearchResults({required this.bookData});



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
          padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: bookData.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: ()  {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBookPage(
                    title: bookData[index].title ?? 'No Title',
                    index: index,
                    authorID: bookData[index].authorId.authorName,
                    bookID: bookData[index].bookid ?? -1,
                    genreID: bookData[index].genreId.genreName,
                    date: bookData[index].publicationDate.toString(),
                    des: bookData[index].description ?? 'Nodes',
                   // des: bookData[index]['description']?? -1,
                    //date: bookData[index]['Publication_date']?? '',

                  ),
                ),
              );
            },
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                 ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0),
                    bottom: Radius.circular(10.0),
                  ),
                  child: Base64ImageConverter(
                    base64Image: bookData[index].coverImageUrl??'' , // เพิ่ม base64 ของรูปภาพที่ต้องการแปลงที่นี่
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
                        bookData[index].title?? 'No Title',
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
    ));
  }
}
