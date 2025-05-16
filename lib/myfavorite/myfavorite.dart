import 'dart:convert';
import 'dart:typed_data';
import 'package:ebookapp/Services/DeleteFavorites.dart';
// import 'package:ebookapp/Services/FavoriteByUserBook.dart';
import 'package:ebookapp/Services/ShowFavorite.dart';
import 'package:ebookapp/detailBook/DetailBookPage.dart';
import 'package:ebookapp/homepage/base64imageCon.dart';
import 'package:ebookapp/models/GetFavoriteByUserBook.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class myfavorite extends StatefulWidget {
  @override
  _myfavoriteState createState() => _myfavoriteState();
}

class _myfavoriteState extends State<myfavorite> {
  final fromKey = GlobalKey<FormState>();
  int? user_ID;
  int? keepid;
  User? keepuser;
  Book? keepbook;
  List<GetFavoriteByUserBook> keepfavorites = [];

  Future<int?> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userID = pref.getInt('userID');
    return userID;
  }

  Future<void> fetchFavorites() async {
    if (user_ID != null) {
      try {
        List<GetFavoriteByUserBook> fetchedFavorites =
            await FavoriteByUserBook.GetFavoriteByUserId(user_ID!);
        setState(() {
          keepfavorites = fetchedFavorites;
        });
      } catch (e) {
        print('Error fetching favorites: $e');
      }
    }
  }

void removeFavorite(int userId, int bookId) {
  if (user_ID != null) {
    DeleteFavorites.deleteFavorite(user_ID!, bookId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ลบสำเร็จ"),
          content: Text("รายการถูกลบแล้ว"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ปิด"),
            ),
          ],
        );
      },
    );
    fetchFavorites();
  }
}



  @override
  void initState() {
    super.initState();
    getUserID().then((userID) {
      setState(() {
        user_ID = userID;
      });
      if (user_ID != null) {
        fetchFavorites();
      }
    });
  }

//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('My favorite books'),
//     ),
//     body: GridView.builder(
//       padding: EdgeInsets.all(8.0),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemCount: keepfavorites.length,
//       itemBuilder: (BuildContext context, int index) {
//         var favorite = keepfavorites[index];
//         return Card(
//           elevation: 3,
//           child: Column(
//             children: <Widget>[
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     // TODO: Navigate to book details page
//                   },
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(10.0),
//                         ),
//                         child: Base64ImageConverter(
//                           base64Image: favorite.book.coverImageUrl ?? '', 
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(10.0),
//                               bottomRight: Radius.circular(10.0),
//                             ),
//                             color: Colors.black.withOpacity(0.5),
//                           ),
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             favorite.book.title ?? 'No Title',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'By ${favorite.book.author.authorName}',
//                   style: TextStyle(fontSize: 14),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: () {
//                   removeFavorite(user_ID!, favorite.book.id);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('My favorite books'),
    ),
    body: Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          for (var favorite in keepfavorites)
           Card(
  elevation: 3,
  margin: EdgeInsets.symmetric(vertical: 10),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8.0), // ปรับค่าตรงนี้ตามต้องการ
    child: ListTile(
      contentPadding: EdgeInsets.all(16),
      leading: AspectRatio(
        aspectRatio: 1, // ให้รูปภาพเป็นสี่เหลี่ยม
        child: Image.memory(
          Uint8List.fromList(base64.decode(favorite.book.coverImageUrl)),
          fit: BoxFit.cover, // แก้ไขตามความต้องการ
        ),
      ),
      title: Text(
        favorite.book.title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'By ${favorite.book.author.authorName}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBookPage(
                  title: favorite.book.title,
                  index: favorite.book.id,
                  authorID:favorite.book.author.authorName,
                  bookID: favorite.book.id,
                  genreID: favorite.book.genre.genreName,
                  date: favorite.book.publicationDate.toString(),
                  des: favorite.book.description,
                ),
          ),
        );
      },
      trailing: IconButton(
        icon: Icon(Icons.delete), // ไอคอน "ลบ"
        onPressed: () {
          removeFavorite(user_ID!, favorite.book.id);
        },
      ),
    ),
  ),
),

        ],
      ),
    ),
  );
}



}
