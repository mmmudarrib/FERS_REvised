import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/appuser.dart';

class UserLocalData {
  static late SharedPreferences? _preferences;
  static Future<void> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static void signout() => _preferences!.clear();

  static const String _uidKey = 'UIDKEY';
  static const String _displayNameKey = 'DISPLAYNAMEKEY';
  static const String _emailKey = 'EMAILKEY';
  static const String _isDriverKey = 'ISDRIVERKEY';
  static const String _phoneKey = 'PHONEKEY';
  static const String _cityKey = 'CITYKEY';
  static const String _followsKey = 'FOLLOWSKEY';
  static const String _locationKey = 'LOCATIONKEY';

  //s
  // Setters
  //
  static Future<void> setUID(String uid) async =>
      _preferences!.setString(_uidKey, uid);
  static Future<void> setLocation(LocationUser loc) async =>
      _preferences!.setString(_locationKey, jsonEncode(loc));
  static Future<void> setDisplayName(String name) async =>
      _preferences!.setString(_displayNameKey, name);

  static Future<void> setEmail(String email) async =>
      _preferences!.setString(_emailKey, email);

  static Future<void> setIsDriver(bool isVerified) async =>
      _preferences!.setBool(_isDriverKey, isVerified);

  static Future<void> setCity(String city) async =>
      _preferences!.setString(_cityKey, city);

  static Future<void> setPhone(String phone) async =>
      _preferences!.setString(_phoneKey, phone);

  static Future<void> setFollowings(List<String> followings) async =>
      _preferences!.setStringList(_followsKey, followings);

  //
  // Getters
  //
  static String get getUID => _preferences!.getString(_uidKey) ?? '';
  static String get getName => _preferences!.getString(_displayNameKey) ?? '';
  static String get getEmail => _preferences!.getString(_emailKey) ?? '';
  static LocationUser get getLocation {
    return LocationUser.fromJson(
        jsonDecode(_preferences!.getString(_locationKey) ?? ''));
  }

  static bool get getIsDriver => _preferences!.getBool(_isDriverKey) ?? false;
  static String get getCity => _preferences!.getString(_cityKey) ?? '';
  static String get getPhone => _preferences!.getString(_phoneKey) ?? '';

  static List<String> get getFollowings =>
      _preferences!.getStringList(_followsKey) ?? <String>[];

  void storeAppUserData({required AppUser appUser}) {
    setUID(appUser.uid);
    setDisplayName(appUser.firstName + " " + appUser.lastName);
    setEmail(appUser.email);
    setIsDriver(appUser.isDriver ?? false);
    setLocation(appUser.location);
    setCity(appUser.city ?? '');
    setPhone(appUser.phone ?? '');
  }
}
