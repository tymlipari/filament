import 'dart:ffi';

import 'package:filament/src/disposable.dart';

import 'native.dart' as native;

class View implements Disposable {
  native.ViewRef _mNativeHandle;

  ///
  /// Constructors
  ///

  factory View._(native.ViewRef handle) {
    var view = native.NativeObjectFactory.tryGet<View>(handle);
    if (view == null) {
      view = View._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, view);
    }
    return view;
  }

  View._fromHandle(this._mNativeHandle);

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_view(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

View createView(native.ViewRef instance) => View._(instance);

native.ViewRef getNativeHandleFromView(View view) => view._mNativeHandle;
