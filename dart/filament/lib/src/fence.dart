import 'dart:ffi';

import 'package:filament/src/native.dart' as native;

enum FenceWaitMode {
  flush,
  dontFlush
}

enum FenceStatus {
  error,
  conditionSatisfied,
  timeoutExpired
}

class Fence
{
  native.FenceRef _mNativeHandle;

  Fence._(this._mNativeHandle);

  void dispose() {
    native.instance.filament_destroy_fence(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  FenceStatus wait(FenceWaitMode mode, int timeoutNanoSeconds) {
    int nativeResult = native.instance.filament_fence_wait(_mNativeHandle, mode.index, timeoutNanoSeconds);
    switch (nativeResult) {
      case -1: return FenceStatus.error;
      case 0: return FenceStatus.conditionSatisfied;
      case 1: return FenceStatus.timeoutExpired;
      default: throw Exception('Invalid result');
    }
  }
}

Fence createFenceFromNative(native.FenceRef handle) => Fence._(handle);