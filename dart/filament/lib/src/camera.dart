import 'dart:ffi';
import 'package:filament/src/disposable.dart';
import 'package:filament/src/native.dart' as native;

enum CameraProjection { perspective, orthographic }

enum Fov { vertical, horizontal }

class Camera implements Disposable {
  native.CameraRef _mNativeHandle;
  final int _mEntity;

  factory Camera._(native.CameraRef handle, int entityId) {
    var camera = native.NativeObjectFactory.tryGet<Camera>(handle);
    if (camera == null) {
      camera = Camera._fromHandle(handle, entityId);
      native.NativeObjectFactory.insert(handle, camera);
    }
    return camera;
  }

  Camera._fromHandle(this._mNativeHandle, this._mEntity);

  @override
  void dispose() {
    native.instance.filament_destroy_camera_component(_mEntity);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  int get entity => _mEntity;

  double get near => native.instance.filament_camera_get_near(_mNativeHandle);

  double get cullingFar =>
      native.instance.filament_camera_get_culling_far(_mNativeHandle);

  double get aperture =>
      native.instance.filament_camera_get_aperture(_mNativeHandle);

  double get shutterSpeed =>
      native.instance.filament_camera_get_shutter_speed(_mNativeHandle);

  double get sensitivity =>
      native.instance.filament_camera_get_sensitivity(_mNativeHandle);

  double get focalLength =>
      native.instance.filament_camera_get_focal_length(_mNativeHandle);

  double get focusDistance =>
      native.instance.filament_camera_get_focus_distance(_mNativeHandle);

  List<double> get scaling {
    var vector = native.instance.filament_camera_get_scaling(_mNativeHandle);
    return List.of([vector.x, vector.y, vector.z, vector.w], growable: false);
  }

  List<double> get modelMatrix {
    throw Exception('Not implemented');
  }

  List<double> get viewMatrix {
    throw Exception('Not implemented');
  }

  List<double> get position =>
      native.instance.filament_camera_get_position(_mNativeHandle).toList();

  List<double> get leftVector =>
      native.instance.filament_camera_get_left_vector(_mNativeHandle).toList();

  List<double> get upVector =>
      native.instance.filament_camera_get_up_vector(_mNativeHandle).toList();

  List<double> get forwardVector => native.instance
      .filament_camera_get_forward_vector(_mNativeHandle)
      .toList();

  void setProjection(CameraProjection projectionKind, double left, double right,
      double bottom, double top, double near, double far) {
    native.instance.filament_camera_set_projection(_mNativeHandle,
        projectionKind.index, left, right, bottom, top, near, far);
  }

  void setProjectionFromFov(double fovInDegrees, double aspect, double near,
      double far, Fov direction) {
    native.instance.filament_camera_set_projection_fov(
        _mNativeHandle, fovInDegrees, aspect, near, far, direction.index);
  }

  void setLensProjection(
      double focalLength, double aspect, double near, double far) {
    native.instance.filament_camera_set_projection_lens(
        _mNativeHandle, focalLength, aspect, near, far);
  }

  void setCustomProjection(List<double> projMatrix, double near, double far) {
    assert(projMatrix.length >= 16);
    native.instance.filament_camera_set_projection_custom(
        _mNativeHandle, projMatrix, projMatrix.length, near, far);
  }

  void setCustomProjectionWithCulling(List<double> projMatrix,
      List<double> projMatrixCulling, double near, double far) {
    throw Exception('Not implemented');
  }

  void setScaling(double scalingX, double scalingY) {
    native.instance
        .filament_camera_set_scaling(_mNativeHandle, scalingX, scalingY);
  }

  void setShift(double shiftX, double shiftY) {
    native.instance.filament_camera_set_shift(_mNativeHandle, shiftX, shiftY);
  }

  void setModelMatrix(List<double> viewMatrix) {
    throw Exception('Not implemented');
  }

  void setExposure(double aperture, double shutterSpeed, double sensitivity) {
    native.instance.filament_camera_set_exposure(
        _mNativeHandle, aperture, shutterSpeed, sensitivity);
  }

  void lookAt(double eyeX, double eyeY, double eyeZ, double centerX,
      double centerY, double centerZ, double upX, double upY, double upZ) {
    native.instance.filament_camera_set_lookat(_mNativeHandle, eyeX, eyeY, eyeZ,
        centerX, centerY, centerZ, upX, upY, upZ);
  }

  set focusDistance(double distance) => native.instance
      .filament_camera_set_focus_distance(_mNativeHandle, distance);

  static double computeEffectiveFocalLength(
          double focalLength, double focusDistance) =>
      native.instance.filament_camera_compute_effective_focal_length(
          focalLength, focusDistance);

  static double computeEffectiveFov(
          double fovInDegrees, double focusDistance) =>
      native.instance
          .filament_camera_compute_effective_fov(fovInDegrees, focusDistance);
}

Camera createCameraFromNative(native.CameraRef handle, int entity) =>
    Camera._(handle, entity);

native.CameraRef getNativeHandleForCamera(Camera? object) => object?._mNativeHandle ?? nullptr;