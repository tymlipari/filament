import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/native.dart' as native;

class NativeSurface implements Disposable {
  late native.NativeSurfaceRef _mNativeHandle;

  final int width;
  final int height;

  factory NativeSurface._(
      native.NativeSurfaceRef handle, int width, int height) {
    var surface = native.NativeObjectFactory.tryGet<NativeSurface>(handle);
    if (surface == null) {
      surface = NativeSurface._fromHandle(handle, width, height);
      native.NativeObjectFactory.insert(handle, surface);
    }
    return surface;
  }

  NativeSurface._fromHandle(this._mNativeHandle, this.width, this.height);

  static NativeSurface create(int width, int height) {
    var nativeHandle =
        native.instance.filament_create_native_surface(width, height);
    return NativeSurface._(nativeHandle, width, height);
  }

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_native_surface(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}
