import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/native.dart' as native;

enum FenceWaitMode { flush, dontFlush }

enum FenceStatus { error, conditionSatisfied, timeoutExpired }

class Fence implements Disposable {
  native.FenceRef _mNativeHandle;

  ///
  /// Constructors
  ///

  factory Fence._(native.FenceRef handle) {
    var fence = native.NativeObjectFactory.tryGet<Fence>(handle);
    if (fence == null) {
      fence = Fence._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, fence);
    }
    return fence;
  }

  Fence._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_fence(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Methods
  ///

  FenceStatus wait(FenceWaitMode mode, int timeoutNanoSeconds) {
    int nativeResult = native.instance
        .filament_fence_wait(_mNativeHandle, mode.index, timeoutNanoSeconds);
    switch (nativeResult) {
      case -1:
        return FenceStatus.error;
      case 0:
        return FenceStatus.conditionSatisfied;
      case 1:
        return FenceStatus.timeoutExpired;
      default:
        throw Exception('Invalid result');
    }
  }
}

Fence createFenceFromNative(native.FenceRef handle) => Fence._(handle);
