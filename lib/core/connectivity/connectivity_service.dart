import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:discipline_os/core/utils/logger.dart';

/// Connectivity Service - monitors internet connection
class ConnectivityService {
  static ConnectivityService? _instance;
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isConnected = true;

  ConnectivityService._();

  static ConnectivityService get instance {
    _instance ??= ConnectivityService._();
    return _instance!;
  }

  /// Stream of connection status changes
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Current connection status
  bool get isConnected => _isConnected;

  /// Initialize connectivity monitoring
  Future<void> init() async {
    // Check initial status
    final result = await _connectivity.checkConnectivity();
    _isConnected = _isConnectedResult(result);
    _connectionController.add(_isConnected);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final connected = _isConnectedResult(result);
      if (connected != _isConnected) {
        _isConnected = connected;
        _connectionController.add(_isConnected);
        Logger.info(
          'Connectivity changed: ${connected ? "connected" : "disconnected"}',
        );
      }
    });
  }

  /// Check if result indicates connection
  bool _isConnectedResult(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Manually check connection status
  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected = _isConnectedResult(result);
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
    _connectionController.close();
  }
}
