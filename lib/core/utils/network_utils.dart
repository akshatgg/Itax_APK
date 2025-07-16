import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  /// Checks if the device is connected to the internet (mobile or wifi).
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}