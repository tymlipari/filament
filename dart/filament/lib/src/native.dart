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
  List<double> toList() => List.unmodifiable([this.x, this.y, this.z, this.w]);
}

class FilamentAllocator implements Allocator {
  static final FilamentAllocator _instance = FilamentAllocator._();

  FilamentAllocator._();

  static FilamentAllocator get global => _instance;

  @override
  Pointer<T> allocate<T extends NativeType>(int byteCount, {int? alignment}) {
    return instance.filament_allocate(byteCount).cast<T>();
  }

  Pointer<T> allocateArray<T extends NativeType>(int byteCount, int n) {
    return instance.filament_allocate(byteCount * n).cast<T>();
  }

  @override
  void free(Pointer ptr) {
    instance.filament_free(ptr.cast());
  }
}

void usingMemory<T extends NativeType>(
    void Function<T extends NativeType>(Pointer<T> ptr) callback) {
  var pointer = FilamentAllocator.global.call<T>();
  try {
    callback(pointer);
  } finally {
    FilamentAllocator.global.free(pointer);
  }
}

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

class NativeStructPool {
  static final Map<Type, List> _sPool = {};

  static Pointer<T> borrow<T extends Struct>(int sizeOfT) {
    var pool = _sPool[T.runtimeType];

    Pointer<T> result = nullptr;
    if (pool == null || pool.isEmpty) {
      result = FilamentAllocator.global.allocate(sizeOfT);
    } else {
      result = pool.last as Pointer<T>;
      pool.removeLast();
    }
    return result;
  }

  static void returnBorrow<T extends Struct>(Pointer<T> value) {
    var pool = _sPool[T.runtimeType];
    if (pool == null) {
      _sPool[T.runtimeType] = [value];
    } else {
      pool.add(value);
    }
  }

  static void clearAll() {
    for (var pool in _sPool.values) {
      // Return each object to the allocator
      for (var item in pool) {
        FilamentAllocator.global.free(item);
      }
    }
    _sPool.clear();
  }
}
