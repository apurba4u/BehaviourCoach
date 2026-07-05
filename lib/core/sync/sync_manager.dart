import 'dart:async';

import 'package:discipline_os/core/connectivity/connectivity_service.dart';
import 'package:discipline_os/core/local/hive_service.dart';
import 'package:discipline_os/core/local/adapters/pending_operation_adapter.dart';
import 'package:discipline_os/core/utils/logger.dart';
import 'package:uuid/uuid.dart';

/// Sync Manager - handles offline to online synchronization
class SyncManager {
  static SyncManager? _instance;
  final ConnectivityService _connectivityService;
  final HiveService _hiveService;
  Timer? _syncTimer;
  bool _isSyncing = false;
  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  SyncManager._({
    required ConnectivityService connectivityService,
    required HiveService hiveService,
  })  : _connectivityService = connectivityService,
        _hiveService = hiveService;

  static SyncManager get instance {
    _instance ??= SyncManager._(
      connectivityService: ConnectivityService.instance,
      hiveService: HiveService.instance,
    );
    return _instance!;
  }

  /// Stream of sync status changes
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  /// Current sync status
  SyncStatus get currentStatus => _currentStatus;
  SyncStatus _currentStatus = SyncStatus.idle;

  /// Initialize sync manager
  void init() {
    // Listen for connectivity changes
    _connectivityService.connectionStream.listen((isConnected) {
      if (isConnected) {
        _startSync();
      } else {
        _stopSync();
      }
    });

    // Start periodic sync if connected
    if (_connectivityService.isConnected) {
      _startPeriodicSync();
    }
  }

  /// Add a pending operation to the queue
  Future<void> addPendingOperation({
    required String entityType,
    required String entityId,
    required String operation,
    Map<String, dynamic>? data,
  }) async {
    final box = _hiveService.getBox<PendingOperation>(
      HiveService.pendingOperationBox,
    );

    final pendingOp = PendingOperation(
      id: const Uuid().v4(),
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      data: data,
      createdAt: DateTime.now(),
    );

    await box.put(pendingOp.id, pendingOp);
    Logger.info(
        'Added pending operation: $operation for $entityType/$entityId');

    // Try to sync if connected
    if (_connectivityService.isConnected) {
      unawaited(_startSync());
    }
  }

  /// Start synchronization
  Future<void> _startSync() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _updateStatus(SyncStatus.syncing);

    try {
      final box = _hiveService.getBox<PendingOperation>(
        HiveService.pendingOperationBox,
      );

      final pendingOps = box.values.toList();
      Logger.info('Starting sync with ${pendingOps.length} pending operations');

      for (final op in pendingOps) {
        try {
          await _processOperation(op);
          await box.delete(op.id);
          Logger.info('Synced operation: ${op.operation} for ${op.entityType}');
        } catch (e) {
          Logger.error('Failed to sync operation: ${op.id}', error: e);

          // Update retry count
          final updatedOp = op.copyWith(
            retryCount: op.retryCount + 1,
            lastError: e.toString(),
          );

          if (updatedOp.retryCount >= 5) {
            // Max retries reached, remove from queue
            await box.delete(op.id);
            Logger.warning(
              'Max retries reached for operation: ${op.id}, removing from queue',
            );
          } else {
            await box.put(op.id, updatedOp);
          }
        }
      }

      _updateStatus(SyncStatus.completed);
    } catch (e) {
      Logger.error('Sync failed', error: e);
      _updateStatus(SyncStatus.failed);
    } finally {
      _isSyncing = false;
    }
  }

  /// Process a single pending operation
  Future<void> _processOperation(PendingOperation op) async {
    // This will be implemented by specific repositories
    // For now, we'll just log the operation
    Logger.info(
      'Processing operation: ${op.operation} for ${op.entityType}/${op.entityId}',
    );
  }

  /// Start periodic sync
  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (_connectivityService.isConnected && !_isSyncing) {
        _startSync();
      }
    });
  }

  /// Stop periodic sync
  void _stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Update sync status
  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    _syncStatusController.add(status);
  }

  /// Get pending operations count
  int getPendingOperationsCount() {
    final box = _hiveService.getBox<PendingOperation>(
      HiveService.pendingOperationBox,
    );
    return box.length;
  }

  /// Clear all pending operations
  Future<void> clearPendingOperations() async {
    final box = _hiveService.getBox<PendingOperation>(
      HiveService.pendingOperationBox,
    );
    await box.clear();
  }

  /// Dispose resources
  void dispose() {
    _stopSync();
    _syncStatusController.close();
  }
}

/// Sync Status enum
enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
}
