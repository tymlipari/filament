import 'package:filament/src/native.dart' as native;

class Vector2 {
  double x;
  double y;

  Vector2(this.x, this.y);
}

class Vector3 {
  double x;
  double y;
  double z;

  Vector3(this.x, this.y, this.z);
}

class Vector4 {
  double x;
  double y;
  double z;
  double w;

  Vector4(this.x, this.y, this.z, this.w);
}

///
/// Native converters
/// 

extension Vector3NativeExtensions on native.Vector3 {
  Vector3 toDart() => Vector3(this.x, this.y, this.z);
}

extension Vector4NativeExtensions on native.Vector4 {
  Vector4 toDart() => Vector4(this.x, this.y, this.z, this.w);
}
