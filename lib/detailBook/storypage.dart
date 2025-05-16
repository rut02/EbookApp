import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ebookapp/main.dart';
import 'package:flutter/material.dart';
import 'package:ebookapp/homepage/homepage.dart';

class StoryPage extends StatefulWidget {
  final int bookId;

  StoryPage({required this.bookId});

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  Map<String, dynamic> book = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<Map<String, dynamic>> fetchDataBook(int bookId) async {
  String url = 'http://'+ip+':8080/api/books/$bookId'; // ปรับ URL API ให้รับ bookId
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load data');
  }
}

  Future<void> fetchData() async {
    Map<String, dynamic> data = await fetchDataBook(widget.bookId);
    setState(() {
      book = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ชื่อเรื่อง: ${book['title'] ?? 'ไม่พบข้อมูล'}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'เนื้อเรื่อง: ${book['story'] ?? 'ไม่พบข้อมูล'}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
