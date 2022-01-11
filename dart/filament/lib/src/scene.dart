import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/native.dart' as native;

class Scene implements Disposable {
  native.SceneRef _mNativeHandle;

  ///
  /// Constructors
  ///

  factory Scene._(native.SceneRef handle) {
    var scene = native.NativeObjectFactory.tryGet<Scene>(handle);
    if (scene == null) {
      scene = Scene._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, scene);
    }
    return scene;
  }

  Scene._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_scene(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

Scene createSceneFromNative(native.SceneRef handle) => Scene._(handle);
