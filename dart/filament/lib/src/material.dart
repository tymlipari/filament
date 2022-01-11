import 'dart:ffi';

import 'package:filament/src/colors.dart';
import 'package:filament/src/disposable.dart';
import 'package:filament/src/engine.dart';
import 'package:filament/src/material_instance.dart';
import 'package:filament/src/native.dart' as native;
import 'package:filament/src/vertex_buffer.dart';

enum MaterialShading { unlit, lit, subsurface, cloth, specularGlossiness }

enum Interpolation {
  smooth,
  flat,
}

enum BlendingMode { opaque, transparent, add, masked, fade, multiply, screen }

enum RefractionMode { none, cubemap, screenSpace }

enum RefractionType { solid, thin }

enum VertexDomain { object, world, view, device }

enum CullingMode { none, front, back, frontAndBack }

enum ParameterType {
  bool,
  bool2,
  bool3,
  bool4,
  float,
  float2,
  float3,
  float4,
  int,
  int2,
  int3,
  int4,
  uint,
  uint2,
  uint3,
  uint4,
  mat3,
  mat4,
  sampler2d,
  sampler2dArray,
  samplerCubeMap,
  samplerExternal,
  sampler3d,
  subpassInput
}

enum Precision { low, medium, high, def }

class ShaderParameter {
  static const int _samplerOffset = ParameterType.mat4.index + 1;
  static const int _subpassOffset = ParameterType.sampler3d.index + 1;

  final String name;
  final ParameterType type;
  final Precision precision;
  final int count;

  ShaderParameter._(this.name, this.type, this.precision, this.count);
}

class Material implements Disposable {
  native.MaterialRef _mNativeHandle;
  late final MaterialInstance _mDefaultInstance;

  Set<VertexAttribute>? _mRequiredAttributes;

  ///
  /// Constructors
  ///

  factory Material._(native.MaterialRef handle) {
    var material = native.NativeObjectFactory.tryGet<Material>(handle);
    if (material == null) {
      material = Material._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, material);
    }
    return material;
  }

  Material._fromHandle(this._mNativeHandle) {
    // Load this material's default instance object
    var materialInstanceHandle =
        native.instance.filament_material_get_default_instance(_mNativeHandle);
    _mDefaultInstance =
        createMaterialInstanceFromNative(materialInstanceHandle);
  }

  static Material fromPayload(
      {required Buffer buffer, required Engine engine}) {
    var handle = native.instance.filament_engine_create_material_from_payload(
        getEngineNativeHandle(engine), buffer, buffer.length);
    if (handle == nullptr) throw Exception("Couldn't create Material");
    return Material._(handle);
  }

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    throw Exception('Not implemented');
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Properties
  ///

  String get name => native.instance.filament_material_get_name(_mNativeHandle);
  MaterialInstance get defaultInstance => _mDefaultInstance;

  MaterialShading get shading {
    var shading = native.instance.filament_material_get_shading(_mNativeHandle);
    return MaterialShading.values[shading];
  }

  Interpolation get interpolation {
    var interp =
        native.instance.filament_material_get_interpolation(_mNativeHandle);
    return Interpolation.values[interp];
  }

  BlendingMode get blendingMode {
    var blendMode =
        native.instance.filament_material_get_blending_mode(_mNativeHandle);
    return BlendingMode.values[blendMode];
  }

  RefractionMode get refractionMode {
    var refrac =
        native.instance.filament_material_get_refraction_mode(_mNativeHandle);
    return RefractionMode.values[refrac];
  }

  RefractionType get refractionType {
    var refrac =
        native.instance.filament_material_get_refraction_type(_mNativeHandle);
    return RefractionType.values[refrac];
  }

  VertexDomain get vertexDomain {
    var domain =
        native.instance.filament_material_get_vertex_domain(_mNativeHandle);
    return VertexDomain.values[domain];
  }

  CullingMode get cullingMode {
    var mode =
        native.instance.filament_material_get_culling_mode(_mNativeHandle);
    return CullingMode.values[mode];
  }

  bool get isColorWriteEnabled {
    return native.instance
            .filament_material_get_is_color_write_enabled(_mNativeHandle) !=
        0;
  }

  bool get isDepthWriteEnabled {
    return native.instance
            .filament_material_get_is_depth_write_enabled(_mNativeHandle) !=
        0;
  }

  bool get isDepthCullingEnabled {
    return native.instance
            .filament_material_get_is_depth_culling_enabled(_mNativeHandle) !=
        0;
  }

  bool get isDoubleSided {
    return native.instance
            .filament_material_get_is_double_sided(_mNativeHandle) !=
        0;
  }

  double get maskThreshold {
    return native.instance.filament_material_get_mask_threshold(_mNativeHandle);
  }

  double get specularAntiAliasingVariance {
    return native.instance
        .filament_material_get_specular_aa_variance(_mNativeHandle);
  }

  double get specularAntiAliasingThreshold {
    return native.instance
        .filament_material_get_specular_aa_threshold(_mNativeHandle);
  }

  Set<VertexAttribute> get requiredAttributes {
    if (_mRequiredAttributes == null) {
      final int bitSet = requiredAttributesAsInt;
      List<VertexAttribute> required = [];
      for (int i = 0; i < VertexAttribute.values.length; i++) {
        if ((bitSet & (1 << i) != 0)) {
          required.add(VertexAttribute.values[i]);
        }
      }
      _mRequiredAttributes = Set.unmodifiable(required);
    }
    return _mRequiredAttributes!;
  }

  int get requiredAttributesAsInt =>
      native.instance.filament_material_get_required_attributes(_mNativeHandle);

  int get parameterCount =>
      native.instance.filament_material_get_parameter_count(_mNativeHandle);

  List<ShaderParameter> get parameters {
    final int count = parameterCount;
    if (count > 0) {
      Pointer<native.ParameterRef> parameterList = native
          .FilamentAllocator.global
          .allocate(sizeOf<native.ParameterRef>() * count);

      try {
        var returnedCount = native.instance.filament_material_get_parameters(
            _mNativeHandle, parameterList, count);

        List<ShaderParameter> results = [];
        for (int index = 0; index < returnedCount; index++) {
          results.add(ShaderParameter._(parameterList.elementAt(index)));
        }
        return List.unmodifiable(results);
      } finally {
        native.FilamentAllocator.global.free(parameterList);
      }
    }
    return List.empty();
  }

  ///
  /// Methods
  ///

  MaterialInstance createInstance() {
    var handle =
        native.instance.filament_material_create_instance(_mNativeHandle);
    return createMaterialInstanceFromNative(handle);
  }

  MaterialInstance createInstanceWithName(String name) {
    var handle = native.instance
        .filament_material_create_instance_with_name(_mNativeHandle, name);
    return createMaterialInstanceFromNative(handle);
  }

  bool hasParameter(String name) {
    return native.instance
            .filament_material_get_has_parameter(_mNativeHandle, name) !=
        0;
  }

  void setDefaultParameterBool(String name, bool x) {
    _mDefaultInstance.setParameter(name, x);
  }

  void setDefaultParameterFloat(String name, double x) {
    _mDefaultInstance.setParameterFloat(name, x);
  }

  void setDefaultParamterInt(String name, int x) {
    _mDefaultInstance.setParameterInt(name, x);
  }

  void setDefaultParameterBool2(String name, bool x, bool y) {
    _mDefaultInstance.setParameterBool2(name, x, y);
  }

  void setDefaultParameterFloat2(String name, double x, double y) {
    _mDefaultInstance.setParameterFloat2(name, x, y);
  }

  void setDefaultParameterInt2(String name, int x, int y) {
    _mDefaultInstance.setParameterInt2(name, x, y);
  }

  void setDefaultParameterBool3(String name, bool x, bool y, bool z) {
    _mDefaultInstance.setParameterBool3(name, x, y, z);
  }

  void setDefaultParameterFloat3(String name, double x, double y, double z) {
    _mDefaultInstance.setParameterFloat3(name, x, y, z);
  }

  void setDefaultParameterInt3(String name, int x, int y, int z) {
    _mDefaultInstance.setParameterInt3(name, x, y, z);
  }

  void setDefaultParameterBool4(String name, bool x, bool y, bool z, bool w) {
    _mDefaultInstance.setParameterBool4(name, x, y, z, w);
  }

  void setDefaultParameterFloat4(
      String name, double x, double y, double z, double w) {
    _mDefaultInstance.setParameterFloat4(name, x, y, z, w);
  }

  void setDefaultParameterInt4(String name, int x, int y, int z, int w) {
    _mDefaultInstance.setParameterInt4(name, x, y, z, w);
  }

  void setDefaultParameterBoolArray(String name, BooleanElement type,
      Iterable<bool> v, int offset, int count) {
    _mDefaultInstance.setParameterBoolArray(name, type, v, offset, count);
  }

  void setDefaultParameterFloatArray(String name, FloatElement type,
      Iterable<double> v, int offset, int count) {
    _mDefaultInstance.setParameterFloatArray(name, type, v, offset, count);
  }

  void setDefaultParameterIntArray(
      String name, IntElement type, Iterable<int> v, int offset, int count) {
    _mDefaultInstance.setParameterIntArray(name, type, v, offset, count);
  }

  void setDefaultParameterRgb(
      String name, RgbType type, double r, double g, double b) {
    _mDefaultInstance.setParameterRgb(name, type, r, g, b);
  }

  void setDefaultParameterRgba(
      String name, RgbaType type, double r, double g, double b, double a) {
    _mDefaultInstance.setParameterRgba(name, type, r, g, b, a);
  }

  void setDefaultParameterTexture(
      String name, Texture texture, TextureSampler sampler) {
    _mDefaultInstance.setParameterTexture(name, texture, sampler);
  }
}

Material createMaterialFromNative(native.MaterialRef handle) =>
    Material._(handle);
