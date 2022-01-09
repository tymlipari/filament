import 'dart:ffi';

import 'native.dart' as native;

class Renderer
{
  native.RendererRef _mNativeHandle;

  Renderer._(this._mNativeHandle);

  destroy() {
    native.instance.filament_destroy_renderer(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

Renderer createRenderer(native.RendererRef handle) => Renderer._(handle);