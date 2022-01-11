import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'native.dart' as native;

class Skybox implements Disposable {
  native.SkyboxRef _mNativeHandle;

  ///
  /// Constructors
  /// 

  factory Skybox._(native.SkyboxRef handle) {
    var skybox = native.NativeObjectFactory.tryGet<Skybox>(handle);
    if (skybox == null) {
      skybox = Skybox._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, skybox);
    }
    return skybox;
  }

  Skybox._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  /// 

  @override
  void dispose() {
    native.instance.filament_destroy_skybox(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

Skybox createSkyboxFromNativeHandle(native.SkyboxRef handle) => Skybox._(handle);

native.SkyboxRef getNativeHandleForSkybox(Skybox? box) => box?._mNativeHandle ?? nullptr;