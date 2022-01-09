import 'package:filament/src/native.dart' as native;

class Texture {
  native.TextureRef _mNativeHandle;

  Texture._(this._mNativeHandle);
}

Texture createTextureFromNative(native.TextureRef handle) => Texture._(handle);

native.TextureRef getTextureNativeHandle(Texture tex) => tex._mNativeHandle;