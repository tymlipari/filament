import 'dart:ffi';

import 'camera.dart';
import 'color_grading.dart';
import 'disposable.dart';
import 'math.dart';
import 'native.dart' as native;
import 'render_target.dart';
import 'scene.dart';
import 'texture.dart';
import 'viewport.dart';

enum QualityLevel {
  low,
  medium,
  high,
  ultra
}

enum BlendMode {
  opaque,
  transluscent
}

enum AmbientOcclusion {
  none,
  ssao
}

enum AntiAliasing { 
  none,
  fxaa
}

enum ToneMapping {
  linear,
  aces
}

enum ShadowType {
  pcf,
  vsm,
  dpcf,
  pcss
}

enum Dithering {
  none,
  temporal
}

class TargetBufferFlags { 
  static const int none = 0x0;
  static const int color0 = 0x1;
  static const int color1 = 0x2;
  static const int color2 = 0x4;
  static const int color3 = 0x8;
  static const int depth = 0x10;
  static const int stencil = 0x20;

  static const int allColor = color0 | color1 | color2 | color3;
  static const int depthStencil = depth | stencil;

  static const int all = color0 | color1 | color2 | color3 | depth | stencil;
}

class DynamicResolutionOptions {
  final bool enabled;
  final bool homogenousScaling;
  final double minScale;
  final double maxScale;
  final double sharpness;
  final QualityLevel quality;

  const DynamicResolutionOptions({
    this.enabled = false, 
    this.homogenousScaling = false, 
    this.minScale = 0.5, 
    this.maxScale = 1.0, 
    this.sharpness = 0.9, 
    this.quality = QualityLevel.low
  });
}

class AmbientOcclusionOptions {
  final double radius;
  final double bias;
  final double power;
  final double resolution;
  final double intensity;
  final double bilateralThreshold;
  final QualityLevel quality;
  final QualityLevel lowPassFilter;
  final QualityLevel upsampling;
  final bool enabled;
  final bool bentNormals;
  final double minHorizonAngleRad;

  final double ssctLightConeRad;
  final double ssctStartTraceDistance;
  final double ssctContactDistanceMax;
  final double ssctIntensity;
  final Vector3 ssctLightDirection;
  final double ssctDepthBias;
  final double ssctDepthSlopeBias;
  final double ssctSampleCount;
  final int ssctRayCount;
  final bool ssctEnabled;

  const AmbientOcclusionOptions({
    this.radius = 0.3,
    this.bias = 0.0005,
    this.power = 1.0,
    this.resolution = 0.5,
    this.intensity = 1.0,
    this.bilateralThreshold = 0.05,
    this.quality = QualityLevel.low,
    this.lowPassFilter = QualityLevel.medium,
    this.upsampling = QualityLevel.low,
    this.enabled = false,
    this.bentNormals = false,
    this.minHorizonAngleRad = 0.0,
    
    this.ssctLightConeRad = 1.0,
    this.ssctStartTraceDistance = 0.01,
    this.ssctContactDistanceMax = 1.0,
    this.ssctIntensity = 0.8,
    this.ssctLightDirection = const Vector3(0.0, -1.0, 0.0),
    this.ssctDepthBias = 0.01,
    this.ssctDepthSlopeBias = 0.01,
    this.ssctSampleCount = 4,
    this.ssctRayCount = 1,
    this.ssctEnabled = false
  });
}

class MultiSampleAntiAliasingOptions {
  final bool enabled;
  final int sampleCount;
  final bool customResolve;

  const MultiSampleAntiAliasingOptions({
    this.enabled = false, 
    this.sampleCount = 4, 
    this.customResolve = false});
}

class TemporalAntiAliasingOptions {
  final double filterWidth;
  final double feedback;
  final bool enabled;

  const TemporalAntiAliasingOptions({
    this.filterWidth = 1.0,
    this.feedback = 0.04,
    this.enabled = false
  });
}

enum BloomBlendingMode {
  add,
  interpolate
}

class BloomOptions {
  final Texture? dirt;
  final double dirtStrength;
  final double strength;
  final int resolution;
  final double anamorphism;
  final int levels;
  final BloomBlendingMode blendingMode;
  final bool threshold;
  final bool enabled;
  final double highlight;
  final bool lensFlare;
  final bool starburst;
  final double chromaticAberration;
  final int ghostCount;
  final double ghostSpacing;
  final double ghostThreshold;
  final double haloThickness;
  final double haloRadius;
  final double haloThreshold;

  BloomOptions({
    this.dirt,
    this.dirtStrength = 0.2,
    this.strength = 0.10,
    this.resolution = 360,
    this.anamorphism = 1.0,
    this.levels = 6,
    this.blendingMode = BloomBlendingMode.add,
    this.threshold = true,
    this.enabled = false,
    this.highlight = 1000.0,
    this.lensFlare = false,
    this.starburst = true,
    this.chromaticAberration = 0.005,
    this.ghostCount = 4,
    this.ghostSpacing = 0.6,
    this.ghostThreshold = 10.0,
    this.haloThickness = 0.1,
    this.haloRadius = 0.4,
    this.haloThreshold = 10.0
  });
}

class FogOptions {
  final double distance;
  final double maximumOpacity;
  final double height;
  final double heightFalloff;
  final Color color;
  final double density;
  final double inScatteringStart;
  final double inScatteringSize;
  final bool fogColorFromIbl;
  final bool enabled;

  const FogOptions({
    this.distance = 0.0,
    this.maximumOpacity = 1.0,
    this.height = 0.0,
    this.heightFalloff = 1.0,
    this.color = const Color.rgb(0.5, 0.5, 0.5),
    this.density = 0.1,
    this.inScatteringStart = 0.0,
    this.inScatteringSize = -1.0,
    this.fogColorFromIbl = false,
    this.enabled = false
  });
}

enum DepthOfFieldFilter {
  none,
  median
}

class DepthOfFieldOptions {
  final double cocScale;
  final double maxApertureDiameter;
  final bool enabled;
  final DepthOfFieldFilter filter;
  final bool nativeResolution;
  final int foregroundRingCount;
  final int backgroundRingCount;
  final int fastGatherRingCount;
  final int maxForegroundCOC;
  final int maxBackgroundCOC;

  const DepthOfFieldOptions({
    this.cocScale = 1.0,
    this.maxApertureDiameter = 0.01,
    this.enabled = false,
    this.filter = DepthOfFieldFilter.median,
    this.nativeResolution = false,
    this.foregroundRingCount = 0,
    this.backgroundRingCount = 0,
    this.fastGatherRingCount = 0,
    this.maxForegroundCOC = 0,
    this.maxBackgroundCOC = 0
  });
}

class VignetteOptions {
  final double midPoint;
  final double roundness;
  final double feather;
  final Color color;
  final bool enabled;

  const VignetteOptions({
    this.midPoint = 0.5,
    this.roundness = 0.5,
    this.feather = 0.5,
    this.color = const Color.rgba(0, 0, 0, 1.0),
    this.enabled = false
  });
}

class RenderQuality {
  final QualityLevel hdrColorBuffer;

  const RenderQuality({ 
    this.hdrColorBuffer = QualityLevel.high
  });
}

class VsmShadowOptions {
  final int ansiotropy;
  final bool mipmapping;
  final double minVarianceScale;
  final double lightBleedingReduction;

  const VsmShadowOptions({
    this.ansiotropy = 0,
    this.mipmapping = false,
    this.minVarianceScale = 1.0,
    this.lightBleedingReduction = 0.2
  });
}

class SoftShadowOptions {
  final double penumbraScale;
  final double penumbraRatioScale;

  const SoftShadowOptions({
    this.penumbraScale = 1.0,
    this.penumbraRatioScale = 1.0
  });
}


class View implements Disposable {
  native.ViewRef _mNativeHandle;
  Scene? _mScene;
  Camera? _mCamera;
  Viewport _mViewport = Viewport(0, 0, 0, 0);
  BlendMode _mBlendMode;
  RenderTarget? _mRenderTarget;
  ColorGrading? _mColorGrading;
  AmbientOcclusionOptions _mAmbientOcclusionOptions = AmbientOcclusionOptions();
  DynamicResolutionOptions _mDynamicResolutionOptions = DynamicResolutionOptions();
  MultiSampleAntiAliasingOptions _mMSAAOptions = MultiSampleAntiAliasingOptions();
  TemporalAntiAliasingOptions _mTAAOptions = TemporalAntiAliasingOptions();
  BloomOptions _mBloomOptions = BloomOptions();
  FogOptions _mFogOptions = FogOptions();
  DepthOfFieldOptions _mDepthOfFieldOptions = DepthOfFieldOptions();
  VignetteOptions _mVignetteOptions = VignetteOptions();
  RenderQuality _mRenderQuality = RenderQuality();
  VsmShadowOptions _mVsmShadowOptions = VsmShadowOptions();
  SoftShadowOptions _mSoftShadowOptions = SoftShadowOptions();

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

  ///
  /// Properties
  /// 

  String get name {
    return native.instance.filament_view_get_name(_mNativeHandle);
  }

  set name(String name) {
    native.instance.filament_view_set_name(_mNativeHandle, name);
  }

  Scene? get scene => _mScene;
  
  set scene(Scene? scene) {
    native.instance.filament_view_set_scene(_mNativeHandle, getNativeHandleForScene(scene));
  }

  Camera? get camera => _mCamera;

  set camera(Camera? camera) {
    native.instance.filament_view_set_camera(_mNativeHandle, getNativeHandleForCamera(camera));
  }

  Viewport get viewport => _mViewport;

  set viewport(Viewport viewport) {
    _mViewport = viewport;
    native.instance.filament_view_set_viewport(_mNativeHandle, viewport.left, viewport.bottom, viewport.width, viewport.height);
  }

  BlendMode get blendMode => _mBlendMode;

  set blendMode(BlendMode blendMode) {
    _mBlendMode = blendMode;
    native.instance.filament_view_set_blendmode(_mNativeHandle, blendMode.index);
  }

  bool get shadowingEnabled {
    return native.instance.filament_view_get_shadowing_enabled(_mNativeHandle).asBool;
  }

  set shadowingEnabled(bool enabled) {
    native.instance.filament_view_set_shadowing_enabled(_mNativeHandle, enabled.nativeValue);
  }

  bool get screenSpaceRefractionEnabled {
    return native.instance.filament_view_get_screenspace_refraction_enabled(_mNativeHandle).asBool;
  }
  
  set screenSpaceRefractionEnabled(bool enabled) {
    native.instance.filament_view_set_screenspace_refraction_enabled(_mNativeHandle, enabled.nativeValue);
  }

  RenderTarget? get renderTarget => _mRenderTarget;

  set renderTarget(RenderTarget? target) {
    _mRenderTarget = target;
    native.instance.filament_view_set_render_target(_mNativeHandle, getNativeHandleForRenderTarget(renderTarget));
  }

  AntiAliasing get antiAliasing {
    return AntiAliasing.values[native.instance.filament_view_get_antialiasing(_mNativeHandle)];
  }

  set antiAliasing(AntiAliasing type) {
    native.instance.filament_view_set_antialiasing(_mNativeHandle, type.index);
  }

  MultiSampleAntiAliasingOptions get msaaOptions => _mMSAAOptions;

  set msaaOptions(MultiSampleAntiAliasingOptions options) {
    _mMSAAOptions = options;
    native.instance.filament_view_set_msaa_options(_mNativeHandle, options.enabled.nativeValue, options.sampleCount, options.customResolve.nativeValue);
  }

  TemporalAntiAliasingOptions get taaOptions => _mTAAOptions;

  set taaOptions(TemporalAntiAliasingOptions options) {
    _mTAAOptions = options;
    native.instance.filament_view_set_taa_options(_mNativeHandle, options.feedback, options.filterWidth, options.enabled.nativeValue);
  }

  ColorGrading? get colorGrading => _mColorGrading;

  set colorGrading(ColorGrading? grading) {
    _mColorGrading = grading;
    native.instance.filament_view_set_color_grading(_mNativeHandle, getNativeHandleForColorGrading(colorGrading));
  }

  Dithering get dithering {
    return Dithering.values[native.instance.filament_view_get_dithering(_mNativeHandle)];
  }

  set dithering(Dithering dithering) {
    native.instance.filament_view_set_dithering(_mNativeHandle, dithering.index);
  }

  DynamicResolutionOptions get dynamicResolutionOptions => _mDynamicResolutionOptions;

  set dynamicResolutionOptions(DynamicResolutionOptions options) {
    _mDynamicResolutionOptions = options;
    native.instance.filament_view_set_dynamic_resolution_options(_mNativeHandle, options.enabled.nativeValue, options.homogenousScaling.nativeValue, options.minScale, options.maxScale, options.sharpness, options.quality.index);
  }

  RenderQuality get renderQuality => _mRenderQuality;

  set renderQuality(RenderQuality renderQuality) {
    _mRenderQuality = renderQuality;
    native.instance.filament_view_set_render_quality(_mNativeHandle, renderQuality.hdrColorBuffer.index);
  }

  bool get postProcessingEnabled {
    return native.instance.filament_view_get_post_processing_enabled(_mNativeHandle).asBool;
  }

  set postProcessingEnabled(bool enabled) {
    native.instance.filament_view_set_post_processing_enabled(_mNativeHandle, enabled.nativeValue);
  }

  bool get frontFaceWindingInverted {
    return native.instance.filament_view_get_front_face_winding_inverted(_mNativeHandle).asBool;
  }

  set frontFaceWindingInverted(bool inverted) {
    native.instance.filament_view_set_front_face_winding_inverted(_mNativeHandle, inverted.nativeValue);
  }

  VsmShadowOptions get vsmShadowOptions => _mVsmShadowOptions;

  set vsmShadowOptions(VsmShadowOptions options) {
    _mVsmShadowOptions = options;
    native.instance.filament_view_set_vsm_shadow_options(_mNativeHandle, options.ansiotropy, options.mipmapping.nativeValue, options.minVarianceScale, options.lightBleedingReduction);
  }

  SoftShadowOptions get softShadowOptions => _mSoftShadowOptions;

  set softShadowOptions(SoftShadowOptions options) {
    _mSoftShadowOptions = options;
    native.instance.filament_view_set_soft_shadow_options(_mNativeHandle, options.penumbraScale, options.penumbraRatioScale);
  }

  AmbientOcclusionOptions get ambientOcclusionOptions => _mAmbientOcclusionOptions;

  set ambientOcclusionOptions(AmbientOcclusionOptions options) {
    _mAmbientOcclusionOptions = options;
    native.instance.filament_view_set_ambient_occlusion_options(_mNativeHandle, options.radius, options.bias, options.power, options.resolution, options.intensity, options.bilateralThreshold, options.quality.index, options.lowPassFilter.index, options.upsampling.index, options.enabled.nativeValue, options.bentNormals.nativeValue, options.minHorizonAngleRad);
    native.instance.filament_view_set_ssct_options(_mNativeHandle, options.ssctLightConeRad, options.ssctStartTraceDistance, options.ssctContactDistanceMax, options.ssctIntensity, options.ssctLightDirection.x, options.ssctLightDirection.y, options.ssctLightDirection.z, options.ssctDepthBias, options.ssctDepthSlopeBias, options.ssctSampleCount, options.ssctRayCount, options.ssctEnabled.nativeValue);
  }

  BloomOptions get bloomOptions => _mBloomOptions;

  set bloomOptions(BloomOptions options) {
    _mBloomOptions = options;
    native.instance.filament_view_set_bloom_options(_mNativeHandle, getNativeHandleForTexture(options.dirt), options.dirtStrength, options.strength, options.resolution, options.anamorphism, options.levels, options.blendingMode.index, options.threshold.nativeValue, options.enabled.nativeValue, options.highlight, options.lensFlare.nativeValue, options.starburst.nativeValue, options.chromaticAberration, options.ghostCount, options.ghostSpacing, options.ghostThreshold, options.haloThickness, options.haloRadius, options.haloThreshold);
  }

  VignetteOptions get vignetteOptions => _mVignetteOptions;

  set vignetteOptions(VignetteOptions options) {
    _mVignetteOptions = options;
    native.instance.filament_view_set_vignette_options(_mNativeHandle, options.midPoint, options.roundness, options.feather, options.color.r, options.color.g, options.color.b, options.color.a, options.enabled.nativeValue);
  }

  FogOptions get fogOptions => _mFogOptions;

  set fogOptions(FogOptions options) {
    _mFogOptions = options;
    native.instance.filament_view_set_fog_options(_mNativeHandle, options.distance, options.maximumOpacity, options.height, options.heightFalloff, options.color.r, options.color.g, options.color.b, options.density, options.inScatteringStart, options.inScatteringSize, options.fogColorFromIbl.nativeValue, options.enabled.nativeValue);
  }

  DepthOfFieldOptions get depthOfFieldOptions => _mDepthOfFieldOptions;

  set depthOfFieldOptions(DepthOfFieldOptions options) {
    _mDepthOfFieldOptions = options;
    native.instance.filament_view_set_depth_of_field_options(_mNativeHandle, options.cocScale, options.maxApertureDiameter, options.enabled.nativeValue, options.filter.index, options.nativeResolution.nativeValue, options.foregroundRingCount, options.backgroundRingCount, options.fastGatherRingCount, options.maxForegroundCOC, options.maxBackgroundCOC);
  }

  ///
  /// Methods
  /// 

  void setVisibleLayers(int select, int values) {
    native.instance.filament_view_set_visible_layers(_mNativeHandle, select, values);
  }

  void setDynamicLightingOptions(double zLightNear, double zLightFar) {
    native.instance.filament_view_set_dynamic_lighting_options(_mNativeHandle, zLightNear, zLightFar);
  }

  void setShadowType(ShadowType type) {
    native.instance.filament_view_set_shadow_type(_mNativeHandle, type.index);
  }

}

View createView(native.ViewRef instance) => View._(instance);

native.ViewRef getNativeHandleFromView(View view) => view._mNativeHandle;
