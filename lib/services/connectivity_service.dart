import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.isNotEmpty && !result.contains(ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}
