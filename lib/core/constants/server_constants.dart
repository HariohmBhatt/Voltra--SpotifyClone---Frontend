import 'dart:io';

class ServerConstants {
  static String serverURL =
      Platform.isAndroid ? 'http://10.0.2.2:8000/' : 'http://localhost:8000/';
}
