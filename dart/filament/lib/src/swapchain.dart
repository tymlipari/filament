
import 'dart:ffi';

import 'native.dart' as native;


class SwapChain
{
  native.SwapChainRef _mNativeHandle;

  SwapChain._(this._mNativeHandle);

  destroy() {
    native.instance.filament_destroy_swapchain(_mNativeHandle);
    _mNativeHandle = nullptr;
  }
}

SwapChain createSwapChain(native.SwapChainRef handle) => SwapChain._(handle);