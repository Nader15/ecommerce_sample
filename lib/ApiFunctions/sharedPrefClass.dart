import 'package:ecommerce_sample/utils/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String UserAuthAttend="UserAuthAttend";

Future<String> getUserAttend(BuildContext context,) async {
  // save the chosen locale
  var prefs = await SharedPreferences.getInstance();
  GlobalVars.Userattend="${prefs.getString(UserAuthAttend)}";
  return prefs.getString(UserAuthAttend);

}

Future setUserAttend({String auth_token}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(UserAuthAttend ,auth_token );

}
Future clearAllData({String auth_token}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();

}