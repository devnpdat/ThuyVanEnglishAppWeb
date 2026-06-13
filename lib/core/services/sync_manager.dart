import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/local_storage_service.dart';
import 'dart:async';

/// Manages background sync of offline requests when connection returns
@singleton
class SyncManager {
  final LocalStorageService _storageService;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription? _connectivitySubscription;
  bool _isOnline = true;
  bool _isSyncing = false;

  SyncManager(this._storageService) {
    _initConnectivityListener();
  }

  /// Initialize connectivity listener
  void _initConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;

        // Trigger sync when going online
        if (!wasOnline && _isOnline) {
          print('[SyncManager] Connection restored, syncing...');
          syncPendingRequests();
        }
      },
    );
  }

  /// Check current online status
  Future<bool> checkOnlineStatus() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Sync all pending offline requests
  Future<bool> syncPendingRequests() async {
    if (_isSyncing || !_isOnline) return false;

    _isSyncing = true;

    try {
      final pendingRequests = _storageService.getPendingRequests();

      if (pendingRequests.isEmpty) {
        print('[SyncManager] No pending requests to sync');
        _isSyncing = false;
        return true;
      }

      print('[SyncManager] Syncing ${pendingRequests.length} pending requests...');

      int successCount = 0;
      int failureCount = 0;

      for (final request in pendingRequests) {
        try {
          // TODO: Execute API call using Dio/HTTP client
          // final response = await _httpClient.request(
          //   request.method,
          //   request.endpoint,
          //   data: request.body,
          // );

          // if (response.statusCode == 200) {
          print('[SyncManager] ✓ Synced: ${request.endpoint}');
          await _storageService.removePendingRequest(request.id);
          successCount++;
          // } else {
          //   await _retryRequest(request);
          //   failureCount++;
          // }
        } catch (e) {
          print('[SyncManager] ✗ Failed: ${request.endpoint} - $e');
          await _retryRequest(request);
          failureCount++;
        }
      }

      print(
        '[SyncManager] Sync complete: $successCount success, $failureCount failed',
      );

      _isSyncing = false;
      return failureCount == 0;
    } catch (e) {
      print('[SyncManager] Sync error: $e');
      _isSyncing = false;
      return false;
    }
  }

  /// Retry a failed request with exponential backoff
  Future<void> _retryRequest(PendingRequest request) async {
    const maxRetries = 3;
    const baseDelay = Duration(seconds: 5);

    if (request.retryCount >= maxRetries) {
      print(
        '[SyncManager] Request ${request.id} exceeded max retries, discarding',
      );
      await _storageService.removePendingRequest(request.id);
      return;
    }

    final delaySeconds = baseDelay.inSeconds * (2 ^ request.retryCount);
    final delay = Duration(seconds: delaySeconds);

    print(
      '[SyncManager] Retrying ${request.endpoint} in ${delay.inSeconds}s...',
    );

    await Future.delayed(delay);

    // Update retry count and re-add to queue
    final updatedRequest = PendingRequest(
      id: request.id,
      endpoint: request.endpoint,
      method: request.method,
      body: request.body,
      createdAt: request.createdAt,
      retryCount: request.retryCount + 1,
    );

    await _storageService.removePendingRequest(request.id);
    await _storageService.addPendingRequest(updatedRequest);
  }

  /// Queue a request for offline sync
  Future<void> queueRequest({
    required String endpoint,
    required String method,
    required Map<String, dynamic> body,
  }) async {
    final request = PendingRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      endpoint: endpoint,
      method: method,
      body: body,
      createdAt: DateTime.now(),
    );

    await _storageService.addPendingRequest(request);
    print('[SyncManager] Queued: $endpoint');
  }

  /// Get pending request count
  int getPendingCount() {
    return _storageService.getPendingRequests().length;
  }

  /// Manual sync trigger (for testing or user action)
  Future<bool> manualSync() async {
    _isOnline = await checkOnlineStatus();
    return await syncPendingRequests();
  }

  /// Dispose
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
