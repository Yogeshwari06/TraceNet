import 'dart:async';

import 'package:flutter/foundation.dart';
import '../services/battery_service.dart';
import '../services/connectivity_service.dart';
import '../services/location_service.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider({
    ConnectivityService? connectivityService,
    BatteryService? batteryService,
    LocationService? locationService,
  })  : _connectivityService = connectivityService ?? ConnectivityService(),
        _batteryService = batteryService ?? BatteryService(),
        _locationService = locationService ?? LocationService();

  final ConnectivityService _connectivityService;
  final BatteryService _batteryService;
  final LocationService _locationService;
  StreamSubscription<List<dynamic>>? _connectivitySubscription;

  bool _isInternetConnected = false;
  bool _isLoading = true;
  bool _isBatteryLoading = true;
  bool _locationPermissionAvailable = false;
  bool _locationServiceAvailable = false;
  int _batteryLevel = 0;
  String _batteryStatus = 'Unknown';
  String? _locationMessage;
  String? _errorMessage;

  bool get isInternetConnected => _isInternetConnected;
  bool get isLoading => _isLoading;
  bool get isBatteryLoading => _isBatteryLoading;
  bool get locationPermissionAvailable => _locationPermissionAvailable;
  bool get locationServiceAvailable => _locationServiceAvailable;
  int get batteryLevel => _batteryLevel;
  String get batteryStatus => _batteryStatus;
  String? get locationMessage => _locationMessage;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _connectivitySubscription ??= _connectivityService.connectivityStream.listen((results) {
      _isInternetConnected = results.isNotEmpty &&
          !results.any((result) => result.toString().contains('none'));
      notifyListeners();
    });

    await Future.wait([
      _refreshConnectivity(),
      _refreshBattery(),
      _loadLocationStatus(),
    ]);
  }

  Future<void> _refreshConnectivity() async {
    try {
      _isInternetConnected = await _connectivityService.isConnected;
      _errorMessage = null;
    } catch (_) {
      _isInternetConnected = false;
      _errorMessage = 'Unable to determine network status.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshBattery() async {
    try {
      _batteryLevel = await _batteryService.batteryLevel;
      final state = await _batteryService.batteryState;
      _batteryStatus = _mapBatteryState(state);
    } catch (_) {
      _batteryLevel = 0;
      _batteryStatus = 'Unavailable';
    } finally {
      _isBatteryLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocationStatus() async {
    try {
      _locationServiceAvailable = await _locationService.isLocationServiceEnabled();
      _locationPermissionAvailable = await _locationService.hasLocationPermission();
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        if (!_locationPermissionAvailable) {
          _locationMessage = 'Location permission required';
        } else if (!_locationServiceAvailable) {
          _locationMessage = 'Location service disabled';
        } else {
          _locationMessage = 'Location unavailable';
        }
      } else {
        _locationMessage = 'Lat: ${position.latitude.toStringAsFixed(4)}, Long: ${position.longitude.toStringAsFixed(4)}';
      }
    } catch (_) {
      _locationMessage = 'Location unavailable';
    }
    notifyListeners();
  }

  String _mapBatteryState(dynamic state) {
    if (state == null) {
      return 'Unknown';
    }

    final value = state.toString();
    if (value.contains('charging')) {
      return 'Charging';
    }
    if (value.contains('full')) {
      return 'Full';
    }
    if (value.contains('discharging')) {
      return 'Discharging';
    }
    return 'Unknown';
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
