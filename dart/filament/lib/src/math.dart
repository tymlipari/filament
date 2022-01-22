import 'dart:ffi';
import 'package:filament/src/native.dart' as native;

class Vector2 {
  final double x;
  final double y;

  const Vector2(this.x, this.y);
}

class Vector3 {
  final double x;
  final double y;
  final double z;

  const Vector3(this.x, this.y, this.z);

  const Vector3.zero() : this(0, 0, 0);
}

class Vector4 {
  final double x;
  final double y;
  final double z;
  final double w;

  const Vector4(this.x, this.y, this.z, this.w);

  const Vector4.zero() : this(0, 0, 0, 0);
}

class Color {
  final double r;
  final double g;
  final double b;
  final double a;

  const Color.rgb(this.r, this.g, this.b) : a = 1.0;
  const Color.rgba(this.r, this.g, this.b, this.a);
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

extension PopulateNativeMatrices on List<double> {
  void populateNativeMatrix4x4(native.Matrix4x4 nativeMatrix) {
    assert(this.length >= 16);
    for (int x = 0; x < 4; x++) {
      var row = nativeMatrix.rows[x];
      row.x = this[0 + (x * 4)];
      row.y = this[1 + (x * 4)];
      row.z = this[2 + (x * 4)];
      row.w = this[3 + (x * 4)];
    }
  }
}
