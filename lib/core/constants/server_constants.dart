import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:safe_device/safe_device.dart';

class ServerConstants {
  static String serverURL = 'http://192.168.29.213:8000/';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  ServerConstants() {
    _initializeServerURL();
  }

  void _initializeServerURL() async {
    if (Platform.isAndroid) {
      // var androidInfo = await deviceInfo.androidInfo;
      bool isRealDevice = await SafeDevice.isRealDevice;
      if (isRealDevice) {
        serverURL = 'http://192.168.0.244:8000/';
      } else {
        serverURL = 'http://10.0.2.2:8000/';
      }
    }
  }
}
