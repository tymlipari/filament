import 'dart:ffi';

import 'package:filament/src/engine.dart';
import 'package:filament/src/native.dart' as native;
import 'package:filament/src/texture.dart';

class IndirectLight {
  native.IndirectLightRef _mNativeHandle;
  final Engine _mEngine;

  IndirectLight._(this._mNativeHandle, this._mEngine);

  static IndirectLight create({
    required Engine engine,
    Texture? cubeMap,
    required int irradianceBands, required List<double> irradianceHarmonicsBands,
    required int radianceBands, required List<double> radianceHarmonicsBands,
    required double envIntensity,
    required native.Matrix3x3 rotationMatrix
  }) {

    var handle = native.instance.filament_engine_create_indirect_light(
      getEngineNativeHandle(engine), 
      cubeMap != null ? getTextureNativeHandle(cubeMap) : nullptr, 
      irradianceBands, irradianceSh, irradianceShCount, 
      radianceBands, radianceSh, radianceShCount, 
      envIntensity, 
      rotation);

    if (handle == nullptr) throw Exception('Failed to create indirect light');

    return IndirectLight._(handle, engine);
  }

  double get intensity => native.instance.filament_indirect_light_get_intensity(_mNativeHandle);
  set intensity(double intensity) => native.instance.filament_indirect_light_set_intensity(_mNativeHandle, intensity);

  native.Matrix3x3 get rotation() {
    Pointer<native.Matrix3x3> result = nullptr;
    native.instance.filament_indirect_light_get_rotation(_mNativeHandle, result);
    return result;
  }

  set rotation(native.Matrix3x3 rotation) {
    native.instance.filament_indirect_light_set_rotation(_mNativeHandle, rotation);
  }

  static List<double> getDirectionEstimate(List<double> sh, Vector3 direction) {
    return native.instance.filament_indirect_light_get_direction_estimate(sh, shCount, direction);
  }

  static Vector4 getColorEstimate(Vector4 colorIntensity, List<double> sh, double x, double y, double z) {
    return native.instance.filament_indirect_light_get_color_estimate(colorIntensity, sh, shCount, x, y, z);
  }
}