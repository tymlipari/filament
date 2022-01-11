import 'dart:ffi';

import 'package:filament/src/colors.dart';
import 'package:filament/src/native.dart' as native;
import 'package:filament/src/material.dart';

enum BooleanElement { bool, bool2, bool3, bool4 }

enum IntElement { int, int2, int3, int4 }

enum FloatElement { float, float2, float3, float4 }

class MaterialInstance {
  native.MaterialInstanceRef _mNativeHandle;
  Material? _mMaterial;
  String? _mName;

  ///
  /// Constructors
  ///
  factory MaterialInstance._(native.MaterialInstanceRef handle) {
    var materialInstance =
        native.NativeObjectFactory.tryGet<MaterialInstance>(handle);
    if (materialInstance == null) {
      materialInstance = MaterialInstance._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, materialInstance);
    }
    return materialInstance;
  }

  MaterialInstance._fromHandle(this._mNativeHandle);

  static MaterialInstance duplicate(MaterialInstance other, String name) {
    var handle = native.instance
        .filament_duplicate_material_instance(other._mNativeHandle, name);
    if (handle == nullptr) {
      throw Exception('Failed to duplicate MaterialInstance');
    }
    return MaterialInstance._(handle);
  }

  ///
  /// Destructors
  ///
  void dispose() {
    throw Exception(('Not implemented');
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Properties
  ///

  Material get material {
    if (_mMaterial == null) {
      var handle = native.instance
          .filament_material_instance_get_material(_mNativeHandle);
      _mMaterial = createMaterialFromNative(handle);
    }
    return _mMaterial!;
  }

  String get name {
    _mName ??=
        native.instance.filament_material_instance_get_name(_mNativeHandle);
    return _mName!;
  }

  ///
  /// Methods
  ///

  void setParameterBool(String name, bool x) {
    native.instance
        .filament_material_instance_set_param_bool(_mNativeHandle, name, x);
  }

  void setParameterBool2(String name, bool x, bool y) {
    native.instance
        .filament_material_instance_set_param_bool2(_mNativeHandle, name, x, y);
  }

  void setParameterBool3(String name, bool x, bool y, bool z) {
    native.instance.filament_material_instance_set_param_bool3(
        _mNativeHandle, name, x, y, z);
  }

  void setParameterBool4(String name, bool x, bool y, bool z, bool w) {
    native.instance.filament_material_instance_set_param_bool4(
        _mNativeHandle, name, x, y, z, w);
  }

  void setParameterInt(String name, int x) {
    native.instance
        .filament_material_instance_set_param_int(_mNativeHandle, name, x);
  }

  void setParameterInt2(String name, int x, int y) {
    native.instance
        .filament_material_instance_set_param_int2(_mNativeHandle, name, x, y);
  }

  void setParameterInt3(String name, int x, int y, int z) {
    native.instance.filament_material_instance_set_param_int3(
        _mNativeHandle, name, x, y, z);
  }

  void setParameterInt4(String name, int x, int y, int z, int w) {
    native.instance.filament_material_instance_set_param_int4(
        _mNativeHandle, name, x, y, z, w);
  }

  void setParameterFloat(String name, double x) {
    native.instance
        .filament_material_instance_set_param_float(_mNativeHandle, name, x);
  }

  void setParameterFloat2(String name, double x, double y) {
    native.instance.filament_material_instance_set_param_float2(
        _mNativeHandle, name, x, y);
  }

  void setParameterFloat3(String name, double x, double y, double z) {
    native.instance.filament_material_instance_set_param_float3(
        _mNativeHandle, name, x, y, z);
  }

  void setParameterFloat4(String name, double x, double y, double z, double w) {
    native.instance.filament_material_instance_set_param_float4(
        _mNativeHandle, name, x, y, z, w);
  }

  void setParameterRgb(
      String name, RgbType type, double r, double g, double b) {
    native.instance.filament_material_instance_set_param_rgb(
        _mNativeHandle, name, r, g, b);
  }

  void setParameterRgba(
      String name, RgbaType type, double r, double g, double b, double a) {
    native.instance.filament_material_instance_set_param_rgba(
        _mNativeHandle, name, r, g, b, a);
  }

  void setParameterTexture(
      String name, Texture texture, TextureSampler sampler) {
    native.instance.filament_material_instance_set_param_texture(
        _mNativeHandle, name, texture, sampler);
  }

  void setParameterBoolArray(
      String name, BooleanElement type, Iterable<bool> v, int offset, int count) {
    Pointer<native.bool>? nArray;
    try {
      // Convert input to native array
      throw Exception('Not implemented');

      // Native array will be zero-indexed
      native.instance.filament_material_instance_set_param_bool_array(
          _mNativeHandle, name, type.index, nArray!, 0, count);
    } finally {
      if (nArray != null) {
        native.FilamentAllocator.global.free(nArray);
      }
    }
  }

  void setParameterIntArray(
      String name, IntElement type, Iterable<int> v, int offset, int count) {
    Pointer<Int32>? nArray;
    try {
      // Convert input to native array
      throw Exception('Not implemented');

      // Native array will be zero-indexed
      native.instance.filament_material_instance_set_param_bool_array(
          _mNativeHandle, name, type.index, nArray!, 0, count);
    } finally {
      if (nArray != null) {
        native.FilamentAllocator.global.free(nArray);
      }
    }
  }

  void setParameterFloatArray(
      String name, FloatElement type, Iterable<double> v, int offset, int count) {
    Pointer<Float>? nArray;
    try {
      // Convert input to native array
      throw Exception('Not implemented');

      // Native array will be zero-indexed
      native.instance.filament_material_instance_set_param_bool_array(
          _mNativeHandle, name, type.index, nArray!, 0, count);
    } finally {
      if (nArray != null) {
        native.FilamentAllocator.global.free(nArray);
      }
    }
  }

  void setScissor(int left, int bottom, int width, int height) {
    assert(left > 0 && bottom > 0 && width > 0 && height > 0);
    native.instance.filament_material_instance_set_scissor(
        _mNativeHandle, left, bottom, width, height);
  }

  void unsetScissor() {
    native.instance.filament_material_instance_unset_scissor(_mNativeHandle);
  }

  void setPolygonOffset(double scale, double constant) {
    native.instance.filament_material_instance_set_polygon_offset(
        _mNativeHandle, scale, constant);
  }

  void setMaskThreshold(double threshold) {
    native.instance.filament_material_instance_set_mask_threshold(
        _mNativeHandle, threshold);
  }

  void setSpecularAntiAliasingVariance(double variance) {
    native.instance.filament_material_instance_set_specular_aa_variance(
        _mNativeHandle, variance);
  }

  void setSpecularAntiAliasingThreshold(double threshold) {
    native.instance.filament_material_instance_set_specular_aa_threshold(
        _mNativeHandle, threshold);
  }

  void setDoubleSided(bool doubleSided) {
    native.instance.filament_material_instance_set_double_sided(
        _mNativeHandle, doubleSided);
  }

  void setCullingMode(CullingMode mode) {
    native.instance.filament_material_instance_set_culling_mode(
        _mNativeHandle, mode.index);
  }

  void setColorWrite(bool enable) {
    native.instance
        .filament_material_instance_set_color_write(_mNativeHandle, enable);
  }

  void setDepthWrite(bool enable) {
    native.instance
        .filament_material_instance_set_depth_write(_mNativeHandle, enable);
  }

  void setDepthCulling(bool enable) {
    native.instance
        .filament_material_instance_set_depth_culling(_mNativeHandle, enable);
  }
}

MaterialInstance createMaterialInstanceFromNative(
        native.MaterialInstanceRef handle) =>
    MaterialInstance._(handle);
