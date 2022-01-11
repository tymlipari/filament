import 'dart:ffi';

import 'package:filament/src/disposable.dart';

import 'native.dart' as native;

class SwapChain implements Disposable {
  native.SwapChainRef _mNativeHandle;

  factory SwapChain._(native.SwapChainRef handle) {
    var swapChain = native.NativeObjectFactory.tryGet<SwapChain>(handle);
    if (swapChain == null) {
      swapChain = SwapChain._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, swapChain);
    }
    return swapChain;
  }

  SwapChain._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_swapchain(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

SwapChain createSwapChain(native.SwapChainRef handle) => SwapChain._(handle);

native.SwapChainRef getNativeHandleFromSwapChain(SwapChain swapChain) =>
    swapChain._mNativeHandle;
