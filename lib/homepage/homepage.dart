import 'dart:convert';
import 'package:ebookapp/homepage/drawside.dart';
import 'package:ebookapp/homepage/genreBookpage.dart';
import 'package:ebookapp/homepage/showsearch.dart';
import 'package:ebookapp/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ebookapp/models/GetAllBooks.dart';
import 'package:ebookapp/homepage/allBookpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  TextEditingController searchController = TextEditingController();
  List<GetAllBooks> bookData = [];
  final List<GetAllBooks> booksList = [];
  List<String> genresNames = ['All'];

  Future<int?> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userID = pref.getInt('userID');
    return userID;
  }

  @override
  void initState() {
    super.initState();
    fetchDataBooks();
    fetchDatagenres();
  }

  Future refreshData() async {
    await fetchDataBooks();
  }

  Future<List<Map<String, dynamic>>> searDataBooks(String query) async {
    String url = 'http://'+ip+':8080/api/books/search/other/$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future fetchDatagenres() async {
    String url = 'http://'+ip+':8080/api/genres';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> genresData =
          json.decode(response.body).cast<Map<String, dynamic>>();
      setState(() {
        genresNames = [
          'All',
          ...genresData.map((genre) => genre['genre_name'].toString()).toList()
        ];
      });
    }
  }

  List<Widget> createGenrePages(List<String> genresNames) {
    return genresNames.map((genre) {
      if (genre == 'All') {
        return AllBooksPage(bookData: booksList);
      } else {
        return GenreBooksPage(genre: genre, bookData: booksList);
      }
    }).toList();
  }

  Future<List<GetAllBooks>> fetchDataBooks() async {
    String url = 'http://'+ip+':8080/api/books';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      List<GetAllBooks> booksListJson =
          jsonResponse.map((json) => GetAllBooks.fromJson(json)).toList();

      setState(() {
        this.booksList.addAll(booksListJson);
      });

      return booksList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: genresNames.length,
      child: Scaffold(
        drawer: DrawSide(),
        appBar: AppBar(
          title: Text(''),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                    searDataBooks: searDataBooks,
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.pushNamed(context, 'favoritepage');
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(255, 118, 118, 118),
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 14.0),
            tabs: genresNames.map((genre) => Tab(text: genre)).toList(),
          ),
        ),
        body: TabBarView(
          children: createGenrePages(genresNames),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<GetAllBooks> bookData = [];
  final Future<List<Map<String, dynamic>>> Function(String) searDataBooks;

  CustomSearchDelegate({required this.searDataBooks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
  }

  @override
Widget buildResults(BuildContext context) {
  return FutureBuilder(
    future: searDataBooks(query),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.hasData) {
        var data = snapshot.data as List<Map<String, dynamic>>;
        List<GetAllBooks> bookData = data
            .map((item) => GetAllBooks.fromJson(item))
            .toList();
        return ShowSearchResults(bookData: bookData);
      } else {
        return Container();
      }
    },
  );
}







  @override
  Widget buildSuggestions(BuildContext context) {
    return ShowSearchResults(bookData: [],);
  }
}
