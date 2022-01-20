import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'native.dart' as native;

class TransformManager extends Disposable {
  native.TransformManagerRef _mNativeHandle;

  ///
  /// Constructors
  /// 

  factory TransformManager._(native.TransformManagerRef handle) {
    var manager = native.NativeObjectFactory.tryGet<TransformManager>(handle);
    if (manager == null) {
      manager = TransformManager._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, manager);
    }
    return manager;
  }

  TransformManager._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  /// 
  
  @override
  void dispose() {
    native.instance.filament_destroy_tranform_manager(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Properties
  /// 

  bool get accurateTranslationsEnabled {
    return native.instance.filament_transform_manager_get_accurage_translations_enabled(_mNativeHandle) != 0;
  }

  set accurateTranslationsEnabled(bool enabled) {
    native.instance.filament_transform_manager_set_accurate_translations_enabled(_mNativeHandle, enabled);
  }

  ///
  /// Methods
  /// 

  bool hasComponent(int entity) {
    return native.instance.filament_transform_manager_has_component(_mNativeHandle, entity) != 0;
  }

  int getInstance(int entity) {
    return native.instance.filament_transform_manager_get_instance(_mNativeHandle, entity);
  }

  int create(int entity) {
    return native.instance.filament_transform_manager_create(_mNativeHandle, entity);
  }

  int createArray(int entity, int parent, List<double> localTransform) {
    return native.instance.filament_transform_manager_create_array_fp64(_mNativeHandle, entity, parent, localTransform);
  }

  void destroy(int entity) {
    native.instance.filament_transform_manager_destroy(_mNativeHandle, entity);
  }

  int getParent(int i) {
    return native.instance.filament_transform_manager_get_parent(_mNativeHandle, i);
  }

  void setParent(int i, int newParent) {
    native.instance.filament_transform_manager_set_parent(_mNativeHandle, i, newParent);
  }

  void setTransform(int i, List<double> localTransform) {
    Asserts.assertMat4fIn(localTransform);
    native.instance.filament_transform_manager_set_transform_fp64(_mNativeHandle, i, localTransform);
  }

  List<double> getTransform(int i) {
    return native.instance.filament_transform_manager_get_transform_fp64(_mNativeHandle, i, outLocalTransform);
  }

  List<double> getWorldTransform(int i) {
    return native.instance.filament_transform_manager_get_world_transform_fp64(_mNativeHandle, i, outWorldTransform);
  }

  void openLocalTransformTransaction() {
    native.instance.filament_transform_manager_open_local_tranform_transaction(_mNativeHandle);
  }

  void closeLocalTransformTransaction() {
    native.instance.filament_transform_manager_commit_local_transform_transaction(_mNativeHandle);
  }

}