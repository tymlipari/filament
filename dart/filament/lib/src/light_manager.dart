import 'dart:ffi';

import 'package:filament/src/native.dart' as native;
import 'package:filament/src/math.dart';

enum LightType {
  sun,
  directional,
  point,
  focusedSpot,
  spot
}

class LightManager {

  ///
  /// Members
  /// 
  native.LightManagerRef _mNativeHandle;

  ///
  /// Constants
  /// 

  /// Typical efficiency of an incandescent light bulb (2.2%)
  static const double efficiencyIncandescent = 0.0220;

  /// Typical efficiency of an halogen light bulb (7.0%)
  static const double efficiencyHalogen = 0.0707;

  /// Typical efficiency of a fluorescent light bulb (8.7%)
  static const double efficiencyFluorescent = 0.0878;

  /// Typical efficiency of a LED light bulb (11.7%)
  static const double efficiencyLed = 0.1171;

  ///
  /// Constructors
  /// 
  
  LightManager._(this._mNativeHandle);

  static LightManager create(
    LightType type, {
    required LightChannelConfig lightChannels,
    bool castShadows = false,
    bool castLight = true,
    ShadowOptions? shadowOptions,
    Vector3? position,
    Vector3? direction = Vector3(0, -1, 0),
    Vector3? color = Vector3(1, 1, 1),
    double? intensity,
    double? falloff,
    double? spotLightConeInner, double? spotLightConeOuter,
    double? sunAngularRadius,
    double? sunHaloSize,
    double? sunHaloFalloff
  }) {

  }

  ///
  /// Properties
  /// 
  
  int get componentCount => native.instance.filament_light_manager_get_component_count(_mNativeHandle);


  ///
  /// Methods
  /// 
  
  bool hasComponent(int entity) => native.instance.filament_light_manager_has_component(_mNativeHandle, entity) != 0;

  int getInstance(int entity) => native.instance.filament_light_manager_get_instance(_mNativeHandle, entity);

  void destroy(int entity) => native.instance.filament_light_manager_destroy(_mNativeHandle, entity);

  LightType getType(int entityInstance) {
    return LightType.values[native.instance.filament_light_manager_get_type(_mNativeHandle, entityInstance)];
  }
  
  bool isDirectional(int entityInstance) { 
    var type = getType(entityInstance);
    return type == LightType.directional || type == LightType.sun;
  }

  bool isPointLight(int entityInstance) => getType(entityInstance) == LightType.point;

  bool isSpotLight(int entityInstance) {
    var type = getType(entityInstance);
    return type == LightType.spot || type == LightType.focusedSpot;
  }

  void setLightChannelConfig(int entityInstance, LightChannelConfig config) {
    throw Exception('Not implemented');
  }

  LightChannelConfig getLightChannelConfig(int entityInstance) {
    throw Exception('Not implemented');
  }

  void setPosition(int entityInstance, Vector3 pos) {
    native.instance.filament_light_manager_set_position(_mNativeHandle, entityInstance, pos.x, pos.y, pos.z);
  }

  Vector3 getPosition(int entityInstance) {
    var nativeResult = native.FilamentAllocator.global.call<native.Vector3>();
    try {
      native.instance.filament_light_manager_get_position(_mNativeHandle, entityInstance, nativeResult);
      return nativeResult.ref.toDart();
    } finally {
      native.FilamentAllocator.global.free(nativeResult);
    }
  }

  void setDirection(int entityInstance, Vector3 dir) {
    native.instance.filament_light_manager_set_direction(_mNativeHandle, entityInstance, dir.x, dir.y, dir.z);
  }

  Vector3 getDirection(int entityInstance) {
    var nativeResult = native.FilamentAllocator.global.call<native.Vector3>();
    try {
      native.instance.filament_light_manager_get_direction(_mNativeHandle, entityInstance, nativeResult);
      return nativeResult.ref.toDart();
    } finally {
      native.FilamentAllocator.global.free(nativeResult);
    }
  }

  void setColor(int entityInstance, double r, double g, double b) {
    native.instance.filament_light_manager_set_color(_mNativeHandle, r, g, b);
  }

  Vector3 getColor(int entityInstance) {
    var nativeResult = native.FilamentAllocator.global.call<native.Vector3>();
    try {
      native.instance.filament_light_manager_get_color(_mNativeHandle, nativeResult);
      return nativeResult.ref.toDart();
    } finally {
      native.FilamentAllocator.global.free(nativeResult);
    }
  }

  void setIntensity(int entityInstance, double intensity) {
    native.instance.filament_light_manager_set_intensity(_mNativeHandle, entityInstance, intensity);
  }

  double getIntensity(int entityInstance) {
    return native.instance.filament_light_manager_get_intensity(_mNativeHandle, entityInstance);
  }

  void setFalloff(int entityInstance, double falloff) {
    native.instance.filament_light_manager_set_falloff(_mNativeHandle, entityInstance, falloff);
  }

  double getFalloff(int entityInstance) {
    return native.instance.filament_light_manager_get_falloff(_mNativeHandle, entityInstance);
  }

  void setSpotLightCone(int entityInstance, double inner, double outer) {
    native.instance.filament_light_manager_set_spotlight_cone(_mNativeHandle, entityInstance, inner, outer);
  }

  void setSunAngularRadius(int entityInstance, double angularRadius) {
    native.instance.filament_light_manager_set_sun_angular_radius(_mNativeHandle, entityInstance, angularRadius);
  }

  double getSunAngularRadius(int entityInstance) {
    return native.instance.filament_light_manager_get_sun_angular_radius(_mNativeHandle, entityInstance);
  }

  void setSunHaloSize(int entityInstance, double haloSize) {
    native.instance.filament_light_manager_set_sun_halo_size(_mNativeHandle, entityInstance, haloSize);
  }

  double getSunHaloSize(int entityInstance) {
    return native.instance.filament_light_manager_get_sun_halo_size(_mNativeHandle, entityInstance);
  }

  void setSunHaloFalloff(int entityInstance, double haloFalloff) {
    native.instance.filament_light_manager_set_sun_halo_falloff(_mNativeHandle, entityInstance, haloFalloff);
  }

  double getSunHaloFalloff(int entityInstance) {
    return native.instance.filament_light_manager_get_sun_halo_falloff(_mNativeHandle, entityInstance);
  }

  void setShadowCaster(int entityInstance, bool shadowCaster) {
    native.instance.filament_light_manager_set_shadow_caster(_mNativeHandle, entityInstance, shadowCaster ? 1 : 0);
  }

  bool isShadowCaster(int entityInstance) {
    return native.instance.filament_light_manager_get_shadow_caster(_mNativeHandle, entityInstance) != 0;
  }

  double getOuterConeAngle(int entityInstance) {
    return native.instance.filament_light_manager_get_outer_cone_angle(_mNativeHandle, entityInstance);
  }

  double getInnerConeAngle(int entityInstance) {
    return native.instance.filament_light_manager_get_inner_cone_angle(_mNativeHandle, entityInstance);
  }
}