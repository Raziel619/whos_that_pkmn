
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{
  static late SharedPreferences _storage;

  //region Private properties
  static final _isFirstLoad = "IsFirstLoad";
  //endregion

  // run this in main.dart to initialize the FlutterSecureStorage property
  static Future<LocalStorage> initialize() async {
    _storage = await SharedPreferences.getInstance();
    return LocalStorage();
  }

  //region Retrieve Functions
  static String? retrieveLSKey(LSKey key) {
    return _storage.getString(key.toString());
  }

  static bool retrieveBool(LSKey key){
    return _storage.getBool(key.toString()) ?? false;
  }

  static String? retrieveString(String key) {
    return _storage.getString(key.toString());
  }

  static Future<T> retrieveType<T>(LSKey key, T Function(dynamic) fromJson) async {
    final jsonString = LocalStorage.retrieveLSKey(key);
    return fromJson(jsonString);
  }

  //endregion

  //region Save Functions
  static Future<void> saveLSKey(LSKey key, String data) async {
    await _storage.setString(key.toString(), data);
  }

  static Future<void> saveString(String key, String data) async {
    await _storage.setString(key.toString(), data);
  }

  static Future<void> saveBool(String key, bool value) async{
    await _storage.setBool(key.toString(), value);
  }

  //endregion

  //region First Load Functions
  static bool isFirstLoad(){
    return _storage.getBool(_isFirstLoad) ?? true;
  }

  static Future<void> turnFirstLoadOff() async {
    await _storage.setBool(_isFirstLoad, false);
  }

  //endregion


//region Delete Functions
  static Future<bool?> deleteAll() async {
    await _storage.clear();
  }

  static Future<void> deleteLSKey(LSKey key) async {
    await _storage.remove(key.toString());
  }

  static Future<void> deleteString(String key) async{
    await _storage.remove(key);
  }
//endregion

}

enum LSKey{
  playHistory,
  remainingPokemon,
  todayQuizzes,
}

