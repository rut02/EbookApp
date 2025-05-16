import 'dart:typed_data';

import 'package:ebookapp/login/login.dart';
import 'package:ebookapp/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ebookapp/user/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebookapp/user/user.dart';

class DrawSide extends StatefulWidget {
  @override
  _DrawSideState createState() => _DrawSideState();
}

class _DrawSideState extends State<DrawSide> {
  late Future<Map<String, dynamic>> currentUserData;

  @override
  void initState() {
    super.initState();
    currentUserData = fetchCurrentUser();
  }

  Future<int?> fetchUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userID');
  }

  Future<Map<String, dynamic>> fetchCurrentUser() async {
    try {
      final userID = await fetchUserID();

      if (userID != null) {
        String url = 'http://' + ip + ':8080/api/users/$userID';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          return json.decode(response.body);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    // ถ้าเกิดข้อผิดพลาดหรือไม่มีข้อมูลผู้ใช้
    return <String, dynamic>{};
  }

  Future<void> logout(BuildContext context) async {
    await user.setsigin(false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => login()));
  }

  ImageProvider<Object>? _getUserProfileImage(String base64Image) {
    if (base64Image.isNotEmpty) {
      Uint8List bytes = Base64Decoder().convert(base64Image);
      return MemoryImage(bytes);
    }
    return null;
  }

  Future<void> uploadImage(String base64Image) async {
     final userID = await fetchUserID();

    String url = 'http://'+ ip + ':8080/api/users/$userID';
    final Map<String, dynamic> requestData = {'profile': base64Image};
    final jsonBody = jsonEncode(requestData);
    final response = await http.put(
      Uri.parse(url), // ตัวอย่าง URL ของ API ที่จะใช้
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      // สำเร็จ! ตอบกลับจาก API จะอยู่ใน response.body
      print('Image uploaded successfully: ${response.body}');
    } else {
      // ไม่สำเร็จ
      print('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: fetchCurrentUser(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            var userData = snapshot.data!;
            var drawerItems = <Widget>[];

            if (userData != null &&
                userData['username'] != null &&
                userData['email'] != null) {
              drawerItems.add(
                UserAccountsDrawerHeader(
                  accountName: Text(userData['username']),
                  accountEmail: Text(userData['email']),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        _getUserProfileImage(userData['profile'] ?? ''),
                  ),
                ),
              );
            }

            // เพิ่มปุ่มแก้ไขภาพโปรไฟล์
            drawerItems.add(
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Profile Picture'),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    List<int> imageBytes = await pickedFile.readAsBytes();
                    String base64Image = base64Encode(imageBytes);

                    // ส่ง base64 ไปยัง API
                    await uploadImage(base64Image);
                    // ใช้ pickedFile.path เพื่อให้ได้เส้นทางไฟล์ของรูปภาพที่เลือก
                    // ใช้เส้นทางนี้สำหรับการประมวลผลต่อไปตามต้องการ
                  }
                },
              ),
            );

            // เพิ่ม ListTiles สำหรับ Logout
            drawerItems.add(
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  logout(context);
                },
              ),
            );

            // สร้าง ListView จาก drawerItems
            return ListView(padding: EdgeInsets.zero, children: drawerItems);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
