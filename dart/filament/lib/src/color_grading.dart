import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/engine.dart';
import 'package:filament/src/native.dart' as native;

enum QualityLevel { low, medium, high, ultra }

class WhiteBalance {
  double temperature;
  double tint;

  WhiteBalance(this.temperature, this.tint);
}

class ColorGrading implements Disposable {
  native.ColorGradingRef _mNativeHandle;

  ///
  /// Constructors
  ///
  factory ColorGrading._(native.ColorGradingRef handle) {
    var colorGrading = native.NativeObjectFactory.tryGet<ColorGrading>(handle);
    if (colorGrading != null) {
      colorGrading = ColorGrading._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, colorGrading);
    }
    return colorGrading!;
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

  static ColorGrading create({
    required Engine engine,
    required QualityLevel qualityLevel,
    // ToneMapper toneMapper,
    required bool luminanceScaling,
    required bool gamutMapping,
    required double exposure,
    required double nightAdaption,
    required WhiteBalance whiteBalance,
  }) {
    var handle = native.instance
        .filament_engine_create_color_grading(getEngineNativeHandle(engine));

    if (handle == nullptr) throw Exception('Failed to create ColorGrading');
    return ColorGrading._(handle);
  }
}
