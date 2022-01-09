import 'package:filament/src/native.dart' as native;

enum RgbType {
  srgb,
  linear
}

enum RgbaType {
  srgb,
  linear,
  premultipliedSrgb,
  premultipliedLinear
}

enum ColorConversion {
  accurate,
  fast
}

class Colors
{
  static native.Vector3 toLinear(RgbType type, double r, double g, double b) {

  }

  /// Converts a correlated color temperature to a linear RGB color in sRGB space. The temperature
  /// must be expressed in Kelvin and must be in the range 1,000K to 15,000K.
  /// 
  /// Returns an RGB float array of size 3 with the result of the conversion
  static List<double> cct(double temperature) => native.instance.filament_color_cct(temperature).toList();

  /// Converts a CIE standard illuminant series D to a linear RGB color in sRGB space. The
  /// temperature must be expressed in Kelvin and must be in the range 4,000K to 25,000K.
  /// 
  /// Returns an RGB float array of size 3 with the results of the conversion.
  static List<double> illuminantD(double temperature) => native.instance.filament_color_illuminantD(temperature).toList();
}