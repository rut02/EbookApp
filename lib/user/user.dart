import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebookapp/user/user_model.dart';

//check true false when exits app 
class user {

  static Future<bool?> getsigin() async{

    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("Sing-in");
  }
  static Future setsigin(bool signin) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("Sing-in", signin);
  }

  static Future<int?> getUserID() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("userID");
  }

  static Future<void> setUserID(int userID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("userID", userID);
  }
}