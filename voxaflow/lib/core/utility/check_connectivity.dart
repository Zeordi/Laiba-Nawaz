
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl({
    required this.connectionChecker
  });

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      return true;
    }
    try {
      final result = await InternetAddress.lookup('1.1.1.1'); // Cloudflare DNS
      bool connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      return connected;
    } catch (e) {
   
      return false;
    }
  }

}