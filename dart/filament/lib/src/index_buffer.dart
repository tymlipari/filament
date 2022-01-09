
import 'dart:ffi';

import 'package:filament/src/engine.dart';
import 'package:filament/src/native.dart' as native;

enum IndexType {
  ushort,   // 16-bit indices
  uint,     // 32-bit indices
}

class IndexBuffer {

  native.IndexBufferRef _mNativeHandle;
  final Engine _mEngine;

  IndexBuffer._(this._mNativeHandle, this._mEngine);

  int get indexCount => native.instance.filament_index_buffer_get_index_count(_mNativeHandle);

  static IndexBuffer create({
    required Engine engine,
    required int indexCount,
    required IndexType indexType,
  }) {
    var handle = native.instance.filament_engine_create_index_buffer(getEngineNativeHandle(engine), indexCount, indexType.index);
    if (handle == nullptr) throw Exception('Failed to create index buffer');
    return IndexBuffer._(handle, engine);
  }

  void setBuffer({
    required Buffer buffer,
    int destOffsetInBytes = 0,
    int count = 0,
    Object? handler,
    Object? callback
  }) {
    native.instance.filament_index_buffer_set_buffer(
      getEngineNativeHandle(_mEngine), 
      buffer, 
      destOffsetInBytes, 
      count);
  }
}