import 'package:filament/src/native.dart' as native;

class MaterialInstance {
  native.MaterialInstanceRef _mNativeHandle;

  MaterialInstance._(this._mNativeHandle);
}

MaterialInstance createMaterialInstanceFromNative(native.MaterialInstanceRef handle) => MaterialInstance._(handle);