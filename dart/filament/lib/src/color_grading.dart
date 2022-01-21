import 'dart:ffi';

import 'disposable.dart';
import 'engine.dart';
import 'math.dart';
import 'native.dart' as native;

enum ColorGradingQualityLevel {
  low,
  medium,
  high,
  ultra
}

class ColorGradingBuilder implements Disposable {

  native.ColorGradingBuilderRef _mNativeHandle;

  ///
  /// Constructors
  /// 

  factory ColorGradingBuilder() {
    var handle = native.instance.filament_create_ColorGradingBuilder();
    return ColorGradingBuilder._(handle);
  }
  
  factory ColorGradingBuilder._(native.ColorGradingBuilderRef handle) {
    var builder = native.NativeObjectFactory.tryGet<ColorGradingBuilder>(handle);
    if (builder == null) {
      builder = ColorGradingBuilder._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, builder);
    }
    return builder;
  }

  ColorGradingBuilder._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_ColorGradingBuilder(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ColorGradingBuilder quality(ColorGradingQualityLevel qualityLevel) {
    native.instance.filament_ColorGradingBuilder_set_quality(_mNativeHandle, qualityLevel.index);
    return this;
  }

  ColorGradingBuilder toneMapper(ToneMapper toneMapper) {
    native.instance.filament_ColorGradingBuilder_set_toneMapper(_mNativeHandle, toneMapper);
    return this;
  }

  ColorGradingBuilder luminanceScaling(bool luminanceScaling) {
    native.instance.filament_ColorGradingBuilder_set_luminanceScaling(_mNativeHandle, luminanceScaling.nativeValue);
    return this;
  }

  ColorGradingBuilder gamutMapping(bool gamutMapping) {
    native.instance.filament_ColorGradingBuilder_set_gamutMapping(_mNativeHandle, gamutMapping.nativeValue);
    return this;
  }

  ColorGradingBuilder exposure(double exposure) {
    native.instance.filament_ColorGradingBuilder_set_exposure(_mNativeHandle, exposure);
    return this;
  }

  ColorGradingBuilder nightAdaptation(double adaptation) {
    native.instance.filament_ColorGradingBuilder_set_nightAdaptation(_mNativeHandle, adaptation);
    return this;
  }

  ColorGradingBuilder whiteBalance(double temperature, double tint) {
    native.instance.filament_ColorGradingBuilder_set_whiteBalance(_mNativeHandle, temperature, tint);
    return this;
  }

  ColorGradingBuilder channelMixer(Vector3 outRed, Vector3 outGreen, Vector3 outBlue) {
    native.instance.filament_ColorGradingBuilder_set_channelMixer(_mNativeHandle, outRed, outGreen, outBlue);
    return this;
  }

  ColorGradingBuilder shadowsMidtonesHighlights(Vector4 shadows, Vector4 midtones, Vector4 highlights, Vector4 ranges) {
    native.instance.filament_ColorGradingBuilder_set_shadowsMidtonesHighlights(_mNativeHandle, shadows, midtones, highlights, ranges);
    return this;
  }

  ColorGradingBuilder slopeOffsetPower(Vector3 slope, Vector3 offset, Vector3 power) {
    native.instance.filament_ColorGradingBuilder_set_slopeOffsetPower(_mNativeHandle, slope, offset, power);
    return this;
  }

  ColorGradingBuilder contrast(double contrast) {
    native.instance.filament_ColorGradingBuilder_set_contrast(_mNativeHandle, contrast);
    return this;
  }

  ColorGradingBuilder vibrance(double vibrance) {
    native.instance.filament_ColorGradingBuilder_set_vibrance(_mNativeHandle, vibrance);
    return this;
  }

  ColorGradingBuilder saturation(double saturation) {
    native.instance.filament_ColorGradingBuilder_set_saturation(_mNativeHandle, saturation);
    return this;
  }

  ColorGradingBuilder curves(Vector3 shadowGamma, Vector3 midPoint, Vector3 highlightScale) {
    native.instance.filament_ColorGradingBuilder_set_curves(_mNativeHandle, shadowGamma, midPoint, highlightScale);
    return this;
  }

  ColorGrading build(Engine engine) {
    var handle = native.instance.filament_ColorGradingBuilder_build(_mNativeHandle, getNativeHandleForEngine(engine));
    return ColorGrading._(handle);
  }

}

class ColorGrading implements Disposable {
  native.ColorGradingRef _mNativeHandle;

  ///
  /// Constructors
  /// 
  
  factory ColorGrading._(native.ColorGradingRef handle) {
    var obj = native.NativeObjectFactory.tryGet<ColorGrading>(handle);
    if (obj == null) {
      obj = ColorGrading._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, obj);
    }
    return obj;
  }

  ColorGrading._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  /// 

  @override
  void dispose() {
    native.instance.filament_destroy_color_grading(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

native.ColorGradingRef getNativeHandleForColorGrading(ColorGrading? grading) => grading?._mNativeHandle ?? nullptr;
