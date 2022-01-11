import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/native.dart' as native;

class Texture implements Disposable {
  native.TextureRef _mNativeHandle;

  ///
  /// Constructors
  ///

  factory Texture._(native.TextureRef handle) {
    var texture = native.NativeObjectFactory.tryGet<Texture>(handle);
    if (texture == null) {
      texture = Texture._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, texture);
    }
    return texture;
  }

  Texture._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    throw Exception(('Not implemented'));
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

Texture createTextureFromNative(native.TextureRef handle) => Texture._(handle);

native.TextureRef getNativeHandleForTexture(Texture tex) => tex._mNativeHandle;
