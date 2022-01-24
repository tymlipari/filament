import 'dart:ffi';

import 'disposable.dart';
import 'engine.dart';
import 'native.dart' as native;
import 'texture.dart';

enum AttachmentPoint {
  color,
  color1,
  color2,
  color3,
  color4,
  color5,
  color6,
  color7,
  depth
}

class AttachmentConfig {
  final Texture? texture;
  final int? mipLevel;
  final CubemapFace? cubemapFace;
  final int? layer;

  AttachmentConfig({ this.texture, this.mipLevel, this.cubemapFace, this.layer});
}

class RenderTarget implements Disposable {
  ///
  /// Fields
  /// 
  native.RenderTargetRef _mNativeHandle;
  final Map<AttachmentPoint, AttachmentConfig> _mAttachments;

  /// 
  /// Constructors
  /// 
  
  factory RenderTarget._(native.RenderTargetRef handle, Map<AttachmentPoint, AttachmentConfig> attachments) {
    var renderTarget = native.NativeObjectFactory.tryGet<RenderTarget>(handle);
    if (renderTarget == null) {
      renderTarget = RenderTarget._fromHandle(handle, attachments);
      native.NativeObjectFactory.insert(handle, renderTarget);
    }
    return renderTarget;
  }

  RenderTarget._fromHandle(this._mNativeHandle, this._mAttachments);

  static RenderTarget create(Engine engine, Map<AttachmentPoint, AttachmentConfig> attachmentConfig) {

    var configArrayPtr =
      native.nativeAlloc<native.filament_render_target_attachment_config_t>(attachmentConfig.length);
    try {

      // Fill the native config array
      int index = 0;
      attachmentConfig.forEach((key, value) {
        var ptr = configArrayPtr.elementAt(index);

        ptr.ref.attachment = key.index;
        ptr.ref.texture = value.texture != null ? 
          getNativeHandleForTexture(value.texture!) : nullptr;
        ptr.ref.mipLevel = value.mipLevel ?? -1;
        ptr.ref.cubemapFace = value.cubemapFace?.index ?? -1;
        ptr.ref.layer = value.layer ?? -1;

        index++;
      });

      var renderTargetHandle = native.instance.filament_engine_create_render_target(
        getNativeHandleForEngine(engine) , configArrayPtr, attachmentConfig.length);
      
      if (renderTargetHandle == nullptr) {
        throw Exception('Failed to create render target');
      }
      
      return RenderTarget._(renderTargetHandle, attachmentConfig);
    } finally {
      native.nativeFree(configArrayPtr);
    }
  }

  ///
  /// Destructors
  /// 

  @override
  void dispose() {
    native.instance.filament_destroy_render_target(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Methods
  /// 
  AttachmentConfig? getAttachmentConfig(AttachmentPoint attachmentPoint) => 
    _mAttachments[attachmentPoint];
}

native.RenderTargetRef getNativeHandleForRenderTarget(RenderTarget? target) => target?._mNativeHandle ?? nullptr;