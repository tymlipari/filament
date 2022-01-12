import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'native.dart' as native;

enum WrapMode { clampToEdge, repeat, mirroredRepeat }

enum MinFilter {
  nearest,
  linear,
  nearestMipMapNearest,
  linearMipMapNearest,
  nearestMipMapLinear,
  linearMipMapLinear
}

enum MagFilter { nearest, linear }

enum CompareMode { none, compareToTexture }

enum CompareFunction {
  lessOrEqual,
  greaterOrEqual,
  less,
  greater,
  equal,
  notEqual,
  always,
  never
}

class TextureSampler extends Disposable {
  native.TextureSamplerRef _mNativeHandle;

  ///
  /// Constructors
  ///

  factory TextureSampler._(native.TextureSamplerRef handle) {
    var sampler = native.NativeObjectFactory.tryGet<TextureSampler>(handle);
    if (sampler == null) {
      sampler = TextureSampler._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, sampler);
    }
    return sampler;
  }

  TextureSampler._fromHandle(this._mNativeHandle);

  static TextureSampler create(MinFilter min, MagFilter mag, WrapMode wrapS,
      WrapMode wrapT, WrapMode wrapR) {
    var nativeHandle = native.instance.filament_create_texture_sampler(
        min.index, mag.index, wrapS.index, wrapT.index, wrapR.index);
    return TextureSampler._(nativeHandle);
  }

  static TextureSampler createCompareSampler(
      CompareMode mode, CompareFunction function) {
    var nativeHandle = native.instance
        .filament_create_compare_texture_sampler(mode.index, function.index);
    return TextureSampler._(nativeHandle);
  }

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_texture_sampler(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Properties
  ///

  MinFilter get minFilter {
    var nativeFilter =
        native.instance.filament_texture_sampler_get_min_filter(_mNativeHandle);
    return MinFilter.values[nativeFilter];
  }

  set minFilter(MinFilter filter) {
    native.instance
        .filament_texture_sampler_set_min_filter(_mNativeHandle, filter.index);
  }

  MagFilter get magFilter {
    var nativeFilter =
        native.instance.filament_texture_sampler_get_mag_filter(_mNativeHandle);
    return MagFilter.values[nativeFilter];
  }

  set magFilter(MagFilter filter) {
    native.instance
        .filament_texture_sampler_set_mag_filter(_mNativeHandle, filter.index);
  }

  WrapMode get wrapS {
    var wrapMode = native.instance
        .filament_texture_sampler_get_wrap_mode_s(_mNativeHandle);
    return WrapMode.values[wrapMode];
  }

  set wrapS(WrapMode mode) {
    native.instance
        .filament_texture_sampler_set_wrap_mode_s(_mNativeHandle, mode.index);
  }

  WrapMode get wrapT {
    var wrapMode = native.instance
        .filament_texture_sampler_get_wrap_mode_t(_mNativeHandle);
    return WrapMode.values[wrapMode];
  }

  set wrapT(WrapMode mode) {
    native.instance
        .filament_texture_sampler_set_wrap_mode_t(_mNativeHandle, mode.index);
  }

  WrapMode get wrapR {
    var wrapMode = native.instance
        .filament_texture_sampler_get_wrap_mode_r(_mNativeHandle);
    return WrapMode.values[wrapMode];
  }

  set wrapR(WrapMode mode) {
    native.instance
        .filament_texture_sampler_set_wrap_mode_r(_mNativeHandle, mode.index);
  }

  double get ansiotropy {
    return native.instance
        .filament_texture_sampler_get_ansiotropy(_mNativeHandle);
  }

  set ansiotropy(double value) {
    native.instance
        .filament_texture_sampler_set_ansiotropy(_mNativeHandle, ansiotropy);
  }

  CompareMode get compareMode {
    var mode = native.instance
        .filament_texture_sampler_get_compare_mode(_mNativeHandle);
    return CompareMode.values[mode];
  }

  set compareMode(CompareMode mode) {
    native.instance
        .filament_texture_sampler_set_compare_mode(_mNativeHandle, mode.index);
  }

  CompareFunction get compareFunction {
    var func = native.instance
        .filament_texture_sampler_get_compare_function(_mNativeHandle);
    return CompareFunction.values[func];
  }

  set compareFunction(CompareFunction func) {
    native.instance.filament_texture_sampler_set_compare_function(
        _mNativeHandle, func.index);
  }
}

native.TextureSamplerRef getNativeHandleForTextureSampler(
        TextureSampler? sampler) =>
    sampler?._mNativeHandle ?? nullptr;
