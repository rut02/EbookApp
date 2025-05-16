import 'package:ebookapp/detailBook/DetailBookPage.dart';
import 'package:ebookapp/homepage/base64imageCon.dart';
import 'package:ebookapp/models/GetAllBooks.dart';
import 'package:ebookapp/models/GetFavoriteByUserBook.dart';
import 'package:flutter/material.dart';

class AllBooksPage extends StatelessWidget {
  final List<GetAllBooks> bookData;

  const AllBooksPage({Key? key, required this.bookData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("AllBooksPage - bookData: $bookData");

    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: bookData.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailBookPage(
                  title: bookData[index].title ?? 'No Title',
                  index: index,
                  authorID: bookData[index].authorId.authorName,
                  bookID: bookData[index].bookid  ?? -1,
                  genreID: bookData[index].genreId.genreName,
                  date: bookData[index].publicationDate.toString(),
                  des: bookData[index].description ?? 'Nodes',
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
                      bookData[index].title ?? 'No Title',
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
  }
}
