import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/indirect_light.dart';
import 'package:filament/src/native.dart' as native;
import 'skybox.dart';

class Scene implements Disposable {
  native.SceneRef _mNativeHandle;
  Skybox? _mSkybox;
  IndirectLight? _mIndirectLight;

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

  ///
  /// Properties
  /// 

  Skybox? get skybox => _mSkybox;

  set skybox(Skybox? box) {
    _mSkybox = box;
    native.instance.filament_scene_set_skybox(_mNativeHandle,
      getNativeHandleForSkybox(box));
  }

  IndirectLight? get indirectLight => _mIndirectLight;

  set indirectLight(IndirectLight? light) {
    _mIndirectLight = light;
    native.instance.filament_scene_set_indirect_light(_mNativeHandle, getNativeHandleFromIndirectLight(light));
  }

  int get renderableCount {
    return native.instance.filament_scene_get_renderable_count(_mNativeHandle);
  }

  int get lightCount {
    return native.instance.filament_scene_get_light_count(_mNativeHandle);
  }

  ///
  /// Methods
  /// 

  void addEntity(int entity) {
    native.instance.filament_scene_add_entity(_mNativeHandle, entity);
  }

  void addEntities(Iterable<int> entities) { 
    // Dart FFI can only pass arrays that are heap allocated
    // so it's cheaper to just iteratively add them
    for (var entity in entities) {
      addEntity(entity);
    }
  }

  void removeEntity(int entity) {
    native.instance.filament_scene_remove_entity(_mNativeHandle, entity);
  }

  void removeEntities(Iterable<int> entities) {
    for (var entity in entities) {
      removeEntity(entity);
    }
  }


}

Scene createSceneFromNative(native.SceneRef handle) => Scene._(handle);
native.SceneRef getNativeHandleForScene(Scene? scene) => scene?._mNativeHandle ?? nullptr;