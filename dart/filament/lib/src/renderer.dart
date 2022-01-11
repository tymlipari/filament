import 'dart:ffi';

import 'package:filament/src/disposable.dart';
import 'package:filament/src/viewport.dart';

import 'engine.dart';
import 'math.dart';
import 'native.dart' as native;
import 'swapchain.dart';
import 'view.dart';

class DisplayInfo {
  final double refreshRate;
  final int presentationDeadlineNanos;
  final int vsyncOffsetNanos;

  DisplayInfo(
      this.refreshRate, this.presentationDeadlineNanos, this.vsyncOffsetNanos);
}

class FrameRateOptions {
  final double interval;
  final double headRoomRatio;
  final double scaleRate;
  final int history;

  FrameRateOptions(
      this.interval, this.headRoomRatio, this.scaleRate, this.history);
}

class ClearOptions {
  final Color clearColor;
  final bool clear;
  final bool discard;

  ClearOptions(this.clearColor, this.clear, this.discard);
}

class Renderer implements Disposable {
  ///
  /// Constants
  ///
  static const int mirrorFrameFlagCommit = 0x1;
  static const int mirrorFrameFlagSetPresentationTime = 0x2;
  static const int mirrorFrameFlagClear = 0x4;

  ///
  /// Fields
  ///
  native.RendererRef _mNativeHandle;
  final Engine _mEngine;
  DisplayInfo? _mDisplayInfo;
  FrameRateOptions? _mFrameRateOptions;
  ClearOptions? _mClearOptions;

  ///
  /// Constructors
  ///

  factory Renderer._(Engine engine, native.RendererRef handle) {
    var renderer = native.NativeObjectFactory.tryGet<Renderer>(handle);
    if (renderer == null) {
      renderer = Renderer._fromHandle(engine, handle);
      native.NativeObjectFactory.insert(handle, renderer);
    }
    return renderer;
  }

  Renderer._fromHandle(this._mEngine, this._mNativeHandle);

  ///
  /// Destructors
  ///

  @override
  dispose() {
    native.instance.filament_destroy_renderer(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Properties
  ///

  Engine get engine => _mEngine;

  DisplayInfo get displayInfo {
    if (_mDisplayInfo == null) {
      var nativeInfo =
          native.instance.filament_renderer_get_display_info(_mNativeHandle);
      _mDisplayInfo = DisplayInfo(nativeInfo.refreshRate,
          nativeInfo.presentationDeadlineNanos, nativeInfo.vsyncOffsetNanos);
    }
    return _mDisplayInfo!;
  }

  set displayInfo(DisplayInfo info) {
    _mDisplayInfo = info;
    native.instance.filament_renderer_set_display_info(_mNativeHandle, info);
  }

  FrameRateOptions get frameRateOptions {
    if (_mFrameRateOptions == null) {
      var nativeOpts = native.instance
          .filament_renderer_get_framerate_options(_mNativeHandle);
      _mFrameRateOptions = FrameRateOptions(nativeOpts.interval,
          nativeOpts.headRoomRatio, nativeOpts.scaleRate, nativeOpts.history);
    }
    return _mFrameRateOptions!;
  }

  set frameRateOptions(FrameRateOptions opts) {
    _mFrameRateOptions = opts;
    native.instance
        .filament_renderer_set_framerate_options(_mNativeHandle, options);
  }

  ClearOptions get clearOptions {
    if (_mClearOptions == null) {
      var nativeOpts =
          native.instance.filament_renderer_get_clear_options(_mNativeHandle);
      _mClearOptions = ClearOptions(nativeOpts.clearColor.toDartColor(),
          nativeOpts.clear != 0, nativeOpts.discard != 0);
    }
    return _mClearOptions!;
  }

  set clearOptions(ClearOptions opts) {
    _mClearOptions = opts;
    native.instance
        .filament_renderer_set_clear_options(_mNativeHandle, options);
  }

  ///
  /// Methods
  ///

  bool beginFrame(SwapChain swapChain, int frameTimeNanos) {
    return native.instance.filament_renderer_begin_frame(_mNativeHandle,
            getNativeHandleFromSwapChain(swapChain), frameTimeNanos) !=
        0;
  }

  void endFrame() {
    native.instance.filament_renderer_end_frame(_mNativeHandle);
  }

  void render(View view) {
    native.instance.filament_renderer_render(
        _mNativeHandle, getNativeHandleFromView(view));
  }

  void renderStandalone(View view) {
    native.instance.filament_renderer_render_standalone_view(
        _mNativeHandle, getNativeHandleFromView(view));
  }

  void copyFrame(
      SwapChain dest, Viewport dstViewport, Viewport srcViewport, int flags) {
    native.instance.filament_renderer_copy_frame(_mNativeHandle,
        getNativeHandleFromSwapChain(dest), destViewport, srcViewport, flags);
  }

  void resetUserTime() {
    native.instance.filament_renderer_reset_user_time(_mNativeHandle);
  }
}

Renderer createRenderer(Engine engine, native.RendererRef handle) =>
    Renderer._(engine, handle);
