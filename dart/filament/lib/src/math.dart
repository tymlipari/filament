import 'package:filament/src/native.dart' as native;

class Vector2 {
  final double x;
  final double y;

  Vector2(this.x, this.y);
}

class Vector3 {
  final double x;
  final double y;
  final double z;

  Vector3(this.x, this.y, this.z);
}

class Vector4 {
  final double x;
  final double y;
  final double z;
  final double w;

  Vector4(this.x, this.y, this.z, this.w);
}

class Color {
  final double r;
  final double g;
  final double b;
  final double a;

  Color.rgb(this.r, this.g, this.b) : a = 1.0;
  Color.rgba(this.r, this.g, this.b, this.a);
}

///
/// Native type converters
///

extension Vector3NativeExtensions on native.Vector3 {
  Vector3 toDart() => Vector3(this.x, this.y, this.z);
  Color toDartColor() => Color.rgb(this.x, this.y, this.z);
}

extension Vector4NativeExtensions on native.Vector4 {
  Vector4 toDart() => Vector4(this.x, this.y, this.z, this.w);
  Color toDartColor() => Color.rgba(this.x, this.y, this.z, this.w);
}
