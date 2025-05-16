import 'dart:convert';
import 'package:http/http.dart' as http;

class Service{

//   static Future<KeepBooks> getBooks() async{

//     String url = 'http://192.168.1.114:8080/api/books';
    
//     try {
//       final response = await http.get(Uri.parse(url));
//       if(response.statusCode == 200){
//         return parseBooks(response.body);
        
//       }else{
//         return KeepBooks();
//       }
       
//     } catch (e) {
//       return KeepBooks();
//     }
// }

// static KeepBooks parseBooks(String responseBody){

//   final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
//   List<KeepBooks> books = parsed.map<KeepBooks>((json) => KeepBooks.fromJson(json)).toList();

//   KeepBooks kb = KeepBooks();
//   kb.books = books.cast<Books>();

//   return kb;
// }








}