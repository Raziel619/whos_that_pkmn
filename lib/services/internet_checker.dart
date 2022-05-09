import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker{
  static late bool _isConnected;
  static bool get isConnected => _isConnected;

  static Future<void> initialize() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    _isConnected = connectivityResult != ConnectivityResult.none;
  }

}