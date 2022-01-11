import 'dart:ffi';

import 'package:filament/src/disposable.dart';

import 'native.dart' as native;

class SwapChain implements Disposable {
  ///
  /// Constants
  ///

  static const int configDefault = 0x0;
  static const int configTransparent = 0x1;
  static const int configReadable = 0x2;
  static const int configEnableXCB = 0x4;

  ///
  /// Fields
  ///
  native.SwapChainRef _mNativeHandle;
  final Object? _mNativeSurface;

  ///
  /// Constructors
  ///

  factory SwapChain._(native.SwapChainRef handle, Object? nativeSurface) {
    var swapChain = native.NativeObjectFactory.tryGet<SwapChain>(handle);
    if (swapChain == null) {
      swapChain = SwapChain._fromHandle(handle, nativeSurface);
      native.NativeObjectFactory.insert(handle, swapChain);
    }
    return swapChain;
  }

  SwapChain._fromHandle(this._mNativeHandle, this._mNativeSurface);

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_swapchain(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Properties
  ///

  Object? get nativeSurface => _mNativeSurface;
}

SwapChain createSwapChain(native.SwapChainRef handle,
        [Object? nativeSurface]) =>
    SwapChain._(handle, nativeSurface);

native.SwapChainRef getNativeHandleFromSwapChain(SwapChain swapChain) =>
    swapChain._mNativeHandle;
