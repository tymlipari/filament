import 'dart:ffi';

import 'native.dart' as native;

class View
{
  native.ViewRef _mNativeHandle;

  View._(this._mNativeHandle);

  destroy() {
    native.instance.filament_destroy_view(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

View createView(native.ViewRef instance) => View._(instance);