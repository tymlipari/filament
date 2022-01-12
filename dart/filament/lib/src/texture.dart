// ignore_for_file: constant_identifier_names

import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/native.dart' as native;

enum Sampler {
  sampler2d,
  sampler2dArray,
  samplerCubemap,
  samplerExternal,
  sampler3d
}

enum InternalFormat {
  // 8-bits per element

  r8,
  r8_snorm,
  r8_uint,
  r8_int,
  stencil8,

  // 16-bits per element

  r16_float,
  r16_uint,
  r16_int,
  rg8,
  rg8_snorm,
  rg8_uint,
  rg8_int,
  rgb565,
  rgb9_e5,
  rgb5_a1,
  rgba4,
  depth16,

  // 24-bits per element

  rgb8,
  srgb8,
  rgb8_snorm,
  rgb8_uint,
  rgb8_int,
  depth24,

  // 32-bits per element

  r32_float,
  r32_uint,
  r32_int,
  rg16_float,
  rg16_uint,
  rg16_int,
  r11_g11_b10_float,
  rgba8,
  srgb8_a8,
  rgba8_snorm,
  unused,
  rgb10_a2,
  rgba8_uint,
  rgba8_int,
  depth32_float,
  depth24_stencil8,
  depth32_float_stencil8,

  // 48-bits per element

  rgb16_float,
  rgb16_uint,
  rgb16_int,

  // 64-bits per element
  rg32_float,
  rg32_uint,
  rg32_int,
  rgba16_float,
  rgba16_uint,
  rgba16_int,

  // 96-bits per element
  rgb32_float,
  rgb32_uint,
  rgb32_int,

  // 128-bits per element

  rgba32_float,
  rgba32_uint,
  rgba32_int,

  // Compressed formats

  // Mandatory in GLES 3.0 and GL 4.3
  eac_r11,
  eac_r11_signed,
  eac_rg11,
  eac_rg11_signed,
  etc2_rgb8,
  etc2_srgb8,
  etc2_rgb8_a1,
  etc2_srgb8_a1,
  etc2_eac_rgba8,
  etc2_eac_srgb8,

  // Available everywhere except Android/iOS

  dxt1_rgb,
  dxt1_rgba,
  dxt3_rgb8,
  dxt5_rgba,
  dxt1_srgb,
  dxt1_srgba,
  dxt3_srgba,
  dxt5_srgba,

  // ASTC formats are available with a GLES extension
  rgba_astc_4x4,
  rgba_astc_5x4,
  rgba_astc_5x5,
  rgba_astc_6x5,
  rgba_astc_6x6,
  rgba_astc_8x5,
  rgba_astc_8x6,
  rgba_astc_8x8,
  rgba_astc_10x5,
  rgba_astc_10x6,
  rgba_astc_10x8,
  rgba_astc_10x10,
  rgba_astc_12x10,
  rgba_astc_12x12,
  srgb8_alpha8_astc_4x4,
  srgb8_alpha8_astc_5x4,
  srgb8_alpha8_astc_5x5,
  srgb8_alpha8_astc_6x5,
  srgb8_alpha8_astc_6x6,
  srgb8_alpha8_astc_8x5,
  srgb8_alpha8_astc_8x6,
  srgb8_alpha8_astc_8x8,
  srgb8_alpha8_astc_10x5,
  srgb8_alpha8_astc_10x6,
  srgb8_alpha8_astc_10x8,
  srgb8_alpha8_astc_10x10,
  srgb8_alpha8_astc_12x10,
  srgb8_alpha8_astc_12x12,
}

enum CompressedFormat {
  // Mandatory in GLES 3.0 and GL 4.3
  eac_r11,
  eac_r11_signed,
  eac_rg11,
  eac_rg11_signed,
  etc2_rgb8,
  etc2_srgb8,
  etc2_rgb8_a1,
  etc2_srgb8_a1,
  etc2_eac_rgba8,
  etc2_eac_srgb8,

  // Available everywhere except Android/iOS

  dxt1_rgb,
  dxt1_rgba,
  dxt3_rgb8,
  dxt5_rgba,
  dxt1_srgb,
  dxt1_srgba,
  dxt3_srgba,
  dxt5_srgba,

  // ASTC formats are available with a GLES extension
  rgba_astc_4x4,
  rgba_astc_5x4,
  rgba_astc_5x5,
  rgba_astc_6x5,
  rgba_astc_6x6,
  rgba_astc_8x5,
  rgba_astc_8x6,
  rgba_astc_8x8,
  rgba_astc_10x5,
  rgba_astc_10x6,
  rgba_astc_10x8,
  rgba_astc_10x10,
  rgba_astc_12x10,
  rgba_astc_12x12,
  srgb8_alpha8_astc_4x4,
  srgb8_alpha8_astc_5x4,
  srgb8_alpha8_astc_5x5,
  srgb8_alpha8_astc_6x5,
  srgb8_alpha8_astc_6x6,
  srgb8_alpha8_astc_8x5,
  srgb8_alpha8_astc_8x6,
  srgb8_alpha8_astc_8x8,
  srgb8_alpha8_astc_10x5,
  srgb8_alpha8_astc_10x6,
  srgb8_alpha8_astc_10x8,
  srgb8_alpha8_astc_10x10,
  srgb8_alpha8_astc_12x10,
  srgb8_alpha8_astc_12x12,
}

enum CubemapFace {
  positiveX,
  negativeX,
  positiveY,
  negativeY,
  positiveZ,
  negativeZ
}

enum TextureFormat {
  r,
  rInt,
  rg,
  rgInt,
  rgb,
  rgbInt,
  rgba,
  rgbaInt,
  unused,
  depthComponent,
  depthStencil,
  stencilIndex,
  alpha
}

enum PixelType {
  ubyte,
  byte,
  ushort,
  short,
  uint,
  int,
  half,
  float,
  compressed,
  uint_10F_11F_11F_rev,
  ushort565
}

enum Swizzle {
  substituteZero,
  substituteOne,
  channel0,
  channel1,
  channel2,
  channel3
}

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
