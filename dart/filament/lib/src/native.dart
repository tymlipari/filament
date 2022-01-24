import 'dart:ffi';
import 'dart:io';

import 'generated/native_gen.dart' as filament_native;

// Re-export generated types since consumers will only import 'native.dart'
export 'generated/native_gen.dart';

DynamicLibrary _openLibrary(String baseName) {
  if (Platform.isLinux || Platform.isAndroid) {
    return DynamicLibrary.open('lib$baseName.so');
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('lib$baseName.dylib');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('$baseName.dll');
  }
  return DynamicLibrary.executable();
}

late final filament_native.NativeLibrary instance = 
  filament_native.NativeLibrary(_openLibrary('filament-dart')); 

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