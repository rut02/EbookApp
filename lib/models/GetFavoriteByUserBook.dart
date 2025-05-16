import 'dart:convert';

List<GetFavoriteByUserBook> getFavoriteListFromJson(String str) {
  List<dynamic> jsonData = json.decode(str);
  return jsonData.map((data) => GetFavoriteByUserBook.fromJson(data)).toList();
}


String getFavoriteByUserBookToJson(GetFavoriteByUserBook data) => json.encode(data.toJson());

class GetFavoriteByUserBook {
    int id;
    User user;
    Book book;

    GetFavoriteByUserBook({
        required this.id,
        required this.user,
        required this.book,
    });

    factory GetFavoriteByUserBook.fromJson(Map<String, dynamic> json) => GetFavoriteByUserBook(
        id: json["id"],
        user: User.fromJson(json["user"]),
        book: Book.fromJson(json["book"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "book": book.toJson(),
    };
}

class Book {
    int id;
    String title;
    String description;
    DateTime publicationDate;
    Author author;
    Genre genre;
    String coverImageUrl;
    dynamic story;

    Book({
        required this.id,
        required this.title,
        required this.description,
        required this.publicationDate,
        required this.author,
        required this.genre,
        required this.coverImageUrl,
        required this.story,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        publicationDate: DateTime.parse(json["publicationDate"]),
        author: Author.fromJson(json["author"]),
        genre: Genre.fromJson(json["genre"]),
        coverImageUrl: json["coverImageUrl"],
        story: json["story"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "publicationDate": publicationDate.toIso8601String(),
        "author": author.toJson(),
        "genre": genre.toJson(),
        "coverImageUrl": coverImageUrl,
        "story": story,
    };
}

class Author {
    int id;
    String authorName;
    String biography;
    int authorId;

    Author({
        required this.id,
        required this.authorName,
        required this.biography,
        required this.authorId,
    });

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        authorName: json["authorName"],
        biography: json["biography"],
        authorId: json["authorID"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "authorName": authorName,
        "biography": biography,
        "authorID": authorId,
    };
}

class Genre {
    int id;
    String genreName;

    Genre({
        required this.id,
        required this.genreName,
    });

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        genreName: json["genreName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "genreName": genreName,
    };
}

class User {
    int id;
    String username;
    String email;
    String password;
    dynamic profile;

    User({
        required this.id,
        required this.username,
        required this.email,
        required this.password,
        required this.profile,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        profile: json["profile"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "profile": profile,
    };
}