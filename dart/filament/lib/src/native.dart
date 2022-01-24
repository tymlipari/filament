import 'dart:ffi';
import 'dart:io';

import 'generated/native_gen.dart' as filament_native;

// Re-export generated types since consumers will only import 'native.dart'
export 'generated/native_gen.dart';

late final DynamicLibrary _filamentLib = Platform.isWindows
    ? DynamicLibrary.open('filament-dart.dll')
    : Platform.isMacOS
        ? DynamicLibrary.open('filament-dart.dylib')
        : (Platform.isAndroid || Platform.isLinux)
            ? DynamicLibrary.open('filament-dart.so')
            : DynamicLibrary.executable();

late final filament_native.NativeLibrary instance =
    filament_native.NativeLibrary(_filamentLib);

/// Native type extensions

extension Vector3Conversion on filament_native.Vector3 {
  List<double> toList() => List.unmodifiable([this.x, this.y, this.z]);
}

extension Vector4Conversion on filament_native.Vector4 {
  List<double> toList() =>
      List.unmodifiable([this.x, this.y, this.z, this.w]);
}

class _FilamentAllocator implements Allocator {
  static final _FilamentAllocator global = _FilamentAllocator();

  @override
  Pointer<T> allocate<T extends NativeType>(int byteCount, {int? alignment}) {
    return instance.filament_allocate(byteCount).cast<T>();
  }

  @override
  void free(Pointer ptr) {
    instance.filament_free(ptr.cast());
  }
}

Pointer<T> nativeAlloc<T extends NativeType>([int count = 1]) => _FilamentAllocator.global.call(count);

void nativeFree(Pointer pointer) => _FilamentAllocator.global.free(pointer);

class NativeObjectFactory {
  static final Map<Pointer, Object> _mObjectCache = {};

  static T? tryGet<T>(Pointer handle) {
    var obj = _mObjectCache[handle];
    if (obj != null && obj is T) {
      return obj as T;
    }
    return null;
  }

  static void insert<T extends Object>(Pointer handle, T obj,
      [bool overwrite = false]) {
    assert(handle != nullptr);
    if (_mObjectCache.containsKey(handle) && !overwrite) {
      throw Exception(
          'Failed to insert into collection as an object already exists');
    }

    _mObjectCache[handle] = obj;
  }

  static void clear(Pointer handle) {
    _mObjectCache.remove(handle);
  }
}

extension BoolNativeConversion on bool {
  int get nativeValue => this == true ? 1 : 0;
}

extension IntNativeConversion on int {
  bool get asBool => (this != 0);
}