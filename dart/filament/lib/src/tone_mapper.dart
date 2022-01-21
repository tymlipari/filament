import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/native.dart' as native;

class ToneMapper extends Disposable {
  native.ToneMapperRef _mNativeHandle;

  factory ToneMapper._(native.ToneMapperRef handle) {
    var toneMapper = native.NativeObjectFactory.tryGet<ToneMapper>(handle);
    if (toneMapper == null) {
      toneMapper = ToneMapper._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, toneMapper);
    }
    return toneMapper;
  }

  ToneMapper._fromHandle(this._mNativeHandle);

  @override
  void dispose() {
    native.instance.filament_destroy_ToneMapper(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

class LinearToneMapper extends ToneMapper {

  factory LinearToneMapper() {
    var handle = native.instance.filament_create_LinearToneMapper();

    var toneMapper = native.NativeObjectFactory.tryGet<LinearToneMapper>(handle);
    if (toneMapper == null) {
      toneMapper = LinearToneMapper._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, toneMapper);
    }
    return toneMapper;
  }

  LinearToneMapper._fromHandle(native.ToneMapperRef handle) : super._fromHandle(handle);
}

class ACESToneMapper extends ToneMapper {

  factory ACESToneMapper() {
    var handle = native.instance.filament_create_ACESToneMapper();

    var toneMapper = native.NativeObjectFactory.tryGet<ACESToneMapper>(handle);
    if (toneMapper == null) {
      toneMapper = ACESToneMapper._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, toneMapper);
    }
    return toneMapper;
  }

  ACESToneMapper._fromHandle(native.ToneMapperRef handle) : super._fromHandle(handle);
}

class ACESLegacyToneMapper extends ToneMapper {

  factory ACESLegacyToneMapper() {
    var handle = native.instance.filament_create_ACESLegacyToneMapper();

    var toneMapper = native.NativeObjectFactory.tryGet<ACESLegacyToneMapper>(handle);
    if (toneMapper == null) {
      toneMapper = ACESLegacyToneMapper._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, toneMapper);
    }
    return toneMapper;
  }

  ACESLegacyToneMapper._fromHandle(native.ToneMapperRef handle) : super._fromHandle(handle);
}

class FilmicToneMapper extends ToneMapper {

  factory FilmicToneMapper() {
    var handle = native.instance.filament_create_FilmicToneMapper();

    var toneMapper = native.NativeObjectFactory.tryGet<FilmicToneMapper>(handle);
    if (toneMapper == null) {
      toneMapper = FilmicToneMapper._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, toneMapper);
    }
    return toneMapper;
  }

  FilmicToneMapper._fromHandle(native.ToneMapperRef handle) : super._fromHandle(handle);
}

class GenericToneMapper extends ToneMapper {

  factory GenericToneMapper({double contrast = 1.585, double shoulder = 0.5, double midGrayIn = 0.18, double midGrayOut = 0.268, double hdrMax = 10.0}) {
    var handle = native.instance.filament_create_GenericToneMapper(contrast, shoulder, midGrayIn, midGrayOut, hdrMax);

    var toneMapper = native.NativeObjectFactory.tryGet<GenericToneMapper>(handle);
    if (toneMapper == null) {
      toneMapper = GenericToneMapper._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, toneMapper);
    }
    return toneMapper;
  }

  GenericToneMapper._fromHandle(native.ToneMapperRef handle) : super._fromHandle(handle);

  ///
  /// Properties
  /// 

  double get contrast {
    return native.instance.filament_GenericToneMapper_get_contrast(_mNativeHandle);
  }

  set contrast(double contrast) {
    native.instance.filament_GenericToneMapper_set_contrast(_mNativeHandle, contrast);
  }

  double get shoulder {
    return native.instance.filament_GenericToneMapper_get_shoulder(_mNativeHandle);
  }

  set shoulder(double shoulder) {
    native.instance.filament_GenericToneMapper_set_shoulder(_mNativeHandle, shoulder);
  }

  double get midGrayIn {
    return native.instance.filament_GenericToneMapper_get_midGrayIn(_mNativeHandle);
  }

  set midGrayIn(double midGrayIn) {
    native.instance.filament_GenericToneMapper_set_midGrayIn(_mNativeHandle, midGrayIn);
  }

  double get midGrayOut {
    return native.instance.filament_GenericToneMapper_get_midGrayOut(_mNativeHandle);
  }

  set midGrayOut(double midGrayOut) {
    native.instance.filament_GenericToneMapper_set_midGrayOut(_mNativeHandle, midGrayOut);
  }

  double get hdrMax {
    return native.instance.filament_GenericToneMapper_get_hdrMax(_mNativeHandle);
  }

  set hdrMax(double hdrMax) {
    native.instance.filament_GenericToneMapper_set_hdrMax(_mNativeHandle, hdrMax);
  }



  
}