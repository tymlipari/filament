import 'dart:ffi';

import 'package:filament/src/engine.dart';
import 'package:filament/src/native.dart' as native;

class BufferObjectBuilder {
  native.BufferObjectBuilderRef _mNativeHandle;

  BufferObjectBuilder._() : _mNativeHandle = nullptr {
    _mNativeHandle = native.instance.filament_create_buffer_builder();
    if (_mNativeHandle == nullptr)
      throw Exception('Failed to create buffer object builder');
  }

  BufferObject build(native.EngineRef engineHandle, int byteSize,
      BufferBindingType bindingType) {}
}

enum BufferBindingType { vertex }

///
/// A generic GPU buffer containing data.
///
/// Usage of this BufferObject is optional. For simple use cases it is not necessary. It is useful
/// only when you need to share data between multiple VertexBuffer instances. It also allows you to
/// efficiently swap-out the buffers in [VertexBuffer].
///
/// NOTE: For now this is only used for vertex data, but in the future we may use it for other things
/// (e.g. compute).
///
class BufferObject {
  static final BufferObjectBuilder _builder = BufferObjectBuilder._();

  BufferObject(
      {required Engine engine,
      required int byteCount,
      BufferBindingType binding = BufferBindingType.vertex}) {}
}
