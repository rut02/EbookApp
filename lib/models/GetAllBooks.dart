import 'dart:convert';

GetAllBooks getAllBooksFromJson(String str) => GetAllBooks.fromJson(json.decode(str));

String getAllBooksToJson(GetAllBooks data) => json.encode(data.toJson());

class GetAllBooks {
  int bookid;
  DateTime publicationDate;
  String coverImageUrl;
  String description;
  String title;
  AuthorId authorId;
  GenreId genreId;
  String story;

  GetAllBooks({
    required this.bookid,
    required this.publicationDate,
    required this.coverImageUrl,
    required this.description,
    required this.title,
    required this.authorId,
    required this.genreId,
    required this.story,
  });

  factory GetAllBooks.fromJson(Map<String, dynamic> json) => GetAllBooks(
        bookid: json["bookid"],
        publicationDate: DateTime.parse(json["publication_date"]),
        coverImageUrl: json["cover_image_url"],
        description: json["description"],
        title: json["title"],
        authorId: AuthorId.fromJson(json["author_id"]),
        genreId: GenreId.fromJson(json["genre_id"]),
        story: json["story"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "bookid": bookid,
        "publication_date": publicationDate.toIso8601String(),
        "cover_image_url": coverImageUrl,
        "description": description,
        "title": title,
        "author_id": authorId.toJson(),
        "genre_id": genreId.toJson(),
        "story": story,
      };
}

class AuthorId {
  int id;
  String authorName;
  String biography;
  int authorId;

  AuthorId({
    required this.id,
    required this.authorName,
    required this.biography,
    required this.authorId,
  });

  factory AuthorId.fromJson(Map<String, dynamic> json) => AuthorId(
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

class GenreId {
  int id;
  String genreName;

  GenreId({
    required this.id,
    required this.genreName,
  });

  factory GenreId.fromJson(Map<String, dynamic> json) => GenreId(
        id: json["id"],
        genreName: json["genreName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "genreName": genreName,
      };
}
