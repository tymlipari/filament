import 'dart:ffi';
import 'dart:html';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/engine.dart';
import 'package:filament/src/native.dart' as native;

enum BufferBindingType { vertex }

class BufferObjectBuilder extends Disposable {
  native.BufferObjectBuilderRef _mNativeHandle;

  factory BufferObjectBuilder._(native.BufferObjectBuilderRef handle) {
    var builder =
        native.NativeObjectFactory.tryGet<BufferObjectBuilder>(handle);
    if (builder == null) {
      builder = BufferObjectBuilder._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, builder);
    }
    return builder;
  }

  factory BufferObjectBuilder() {
    var handle = native.instance.filament_create_BufferObjectBuilder();
    return BufferObjectBuilder._(handle);
  }

  BufferObjectBuilder._fromHandle(this._mNativeHandle);

  ///
  /// Destructor
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_BufferObjectBuilder(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Members
  ///

  BufferObjectBuilder size(int byteCount) {
    native.instance
        .filament_BufferObjectBuilder_set_size(_mNativeHandle, byteCount);
    return this;
  }

  BufferObjectBuilder bindingType(BufferBindingType bindingType) {
    native.instance.filament_BufferObjectBuilder_set_bindingType(
        _mNativeHandle, bindingType.index);
    return this;
  }

  BufferObject build(Engine engine) {
    var handle = native.instance.filament_BufferObjectBuilder_build(
        _mNativeHandle, getNativeHandleForEngine(engine));
    return BufferObject._(handle);
  }
}

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
class BufferObject implements Disposable {
  native.BufferObjectRef _mNativeHandle;

  factory BufferObject._(native.BufferObjectRef handle) {
    var buffer = native.NativeObjectFactory.tryGet<BufferObject>(handle);
    if (buffer == null) {
      buffer = BufferObject._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, buffer);
    }
    return buffer;
  }

  BufferObject._fromHandle(this._mNativeHandle);

  @override
  void dispose() {
    native.instance.filament_destroy_BufferObject(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Properties
  ///

  int get byteCount =>
      native.instance.filament_BufferObject_get_byteCount(_mNativeHandle);

  ///
  /// Methods
  ///

  void setBuffer(Engine engine, Buffer buffer,
      [int destOffsetInBytes = 0, int count = 0]) {
    native.instance.filament_BufferObject_set_buffer(
        _mNativeHandle,
        getNativeHandleForEngine(engine),
        buffer,
        buffer.remaining,
        destOffsetInBytes,
        count);
  }
}
