import 'dart:ffi';

import 'package:filament/src/native.dart' as native;

class Scene
{
  native.SceneRef _mNativeHandle;

  Scene._(this._mNativeHandle);

  void dispose() {
    native.instance.filament_destroy_scene(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

Scene createSceneFromNative(native.SceneRef handle) => Scene._(handle);