import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:safe_device/safe_device.dart';

/// The `ServerConstants` class in Dart contains a static server URL and a method to initialize the
/// server URL based on the platform and device type.
class ServerConstants {
  /// The line `static String serverURL = 'http://192.168.29.213:8000/';` in the `ServerConstants` class
  /// is declaring a static variable `serverURL` of type `String` with an initial value of
  /// `'http://192.168.29.213:8000/'`. This is made using the IP of the device I am hosting in which hosts the API on the the http of http://0.0.0.0:8000/
  static String serverURL = 'http://192.168.29.213:8000/';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  ServerConstants() {
    _initializeServerURL();
  }

  /// The function `_initializeServerURL` sets the server URL based on the platform being Android and
  /// whether the device is real or an emulator.
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
