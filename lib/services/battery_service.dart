import 'package:flutter/services.dart';

class BatteryService {
  BatteryService({MethodChannel? batteryChannel})
      : _batteryChannel = batteryChannel ?? const MethodChannel('tracenet/battery');

  final MethodChannel _batteryChannel;

  Future<int> get batteryLevel async {
    try {
      final result = await _batteryChannel.invokeMethod<int>('getBatteryLevel');
      return result ?? 0;
    } on PlatformException {
      return 0;
    }
  }

  Future<String> get batteryState async {
    try {
      final result = await _batteryChannel.invokeMethod<String>('getBatteryState');
      return result ?? 'unknown';
    } on PlatformException {
      return 'unknown';
    }
  }
}
