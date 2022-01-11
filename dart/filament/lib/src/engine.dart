import 'dart:ffi';
import 'package:filament/src/disposable.dart';

import 'camera.dart';
import 'entity_manager.dart';
import 'fence.dart';
import 'native.dart' as native;
import 'renderer.dart' as renderer;
import 'scene.dart';
import 'swapchain.dart' as swapchain;
import 'view.dart' as view;

enum RenderBackend { def, opengl, vulkan, metal, noop }

class Engine implements Disposable {
  native.EngineRef _mNativeHandle;

  late EntityManager _mEntityManager;

  ///
  /// Constructors
  ///

  factory Engine._(native.EngineRef handle) {
    var engine = native.NativeObjectFactory.tryGet<Engine>(handle);
    if (engine == null) {
      engine = Engine._fromHandle(handle);
      native.NativeObjectFactory.insert<Engine>(handle, engine);
    }
    return engine;
  }

  Engine._fromHandle(this._mNativeHandle) {
    // mTransformManager = TransformManager(nGetTransformManager(_mNativeHandle));
    // mLightManager = LightManager(nGetLightManager(_mNativeHandle));
    // mRenderableManager = RenderableManager(nGetRenderableManager(_mNativeHandle));
    _mEntityManager = createEntityManagerFromNative(
        native.instance.filament_engine_get_entity_manager(_mNativeHandle));
  }

  static Engine create({RenderBackend backend = RenderBackend.def}) {
    var handle = native.instance.filament_create_engine(backend.index);
    if (handle == nullptr) throw Exception('Failed to create engine');
    return Engine._(handle);
  }

  ///
  /// Destructors
  ///

  @override
  void dispose() {
    native.instance.filament_destroy_engine(_mNativeHandle);
    native.NativeObjectFactory.clear(_mNativeHandle);
    _mNativeHandle = nullptr;
  }

  ///
  /// Properties
  ///

  EntityManager get entityManager => _mEntityManager;

  bool get isValid => _mNativeHandle != nullptr;

  /// The backend used by this [Engine]
  RenderBackend get backend => RenderBackend.values
      .elementAt(native.instance.filament_engine_get_backend(_mNativeHandle));

  swapchain.SwapChain createSwapChain(
      {required Object surface, int flags = 0}) {
    if (!Platform.get().validateSurface(surface)) {
      throw Exception('Invalid surface');
    }

    var handle = native.instance
        .filament_engine_create_swapchain(_mNativeHandle, surface, flags);
    if (handle == nullptr) throw Exception('Failed to create swap chain');
    return swapchain.createSwapChain(handle);
  }

  swapchain.SwapChain createHeadlessSwapChain(
      int width, int height, int flags) {
    if (width <= 0 || height <= 0) throw Exception('Invalid dimensions');

    var handle = native.instance.filament_engine_create_swapchain_headless(
        _mNativeHandle, width, height, flags);
    if (handle == nullptr) {
      throw Exception('Failed to create headless swapchain');
    }
    return swapchain.createSwapChain(handle);
  }

  swapchain.SwapChain createSwapChainFromNativeSurface(
      {required NativeSurface surface, int flags}) {
    var handle = native.instance
        .filament_engine_create_swapchain_from_raw_pointer(
            _mNativeHandle, surface, flags);
    if (handle == nullptr) {
      throw Exception('Failed to create swap chain from native instance');
    }
    return swapchain.createSwapChain(handle);
  }

  view.View createView() {
    var handle = native.instance.filament_engine_create_view(_mNativeHandle);
    if (handle == nullptr) throw Exception('Failed to create view');
    return view.createView(handle);
  }

  renderer.Renderer createRenderer() {
    var handle =
        native.instance.filament_engine_create_renderer(_mNativeHandle);
    if (handle == nullptr) throw Exception('Failed to create renderer');
    return renderer.createRenderer(handle);
  }

  Camera createCamera(int entity) {
    var handle =
        native.instance.filament_engine_create_camera(_mNativeHandle, entity);
    if (handle == nullptr) throw Exception('Failed to create camera');
    return createCameraFromNative(handle, entity);
  }

  Camera getCameraComponent(int entity) {
    var handle = native.instance
        .filament_engine_get_camera_component(_mNativeHandle, entity);
    if (handle == nullptr) {
      throw Exception('Failed to get camera component for entity');
    }
    return createCameraFromNative(handle, entity);
  }

  Scene createScene() {
    var handle = native.instance.filament_engine_create_scene(_mNativeHandle);
    if (handle == nullptr) throw Exception('Failed to create scene');
    return createSceneFromNative(handle);
  }

  void destroyStream(Stream stream) {
    throw Exception('Not implemented');
  }

  Fence createFence() {
    var handle = native.instance.filament_engine_create_fence(_mNativeHandle);
    if (handle == nullptr) throw Exception('Failed to create fence');
    return createFenceFromNative(handle);
  }

  void destroyIndexBuffer(IndexBuffer indexBuffer) {
    throw Exception('Not implemented');
  }

  void destroyVertexBuffer(VertexBuffer vertexBuffer) {
    throw Exception('Not implemented');
  }

  void destroySkinningBuffer(SkinningBuffer skinningBuffer) {
    throw Exception('Not implemented');
  }

  void destroyIndirectLight(IndirectLight indirectLight) {
    throw Exception('Not implemented');
  }

  void destroyMaterial(Material material) {
    throw Exception('Not implemented');
  }

  void destroyMaterialInstance(MaterialInstance materialInstance) {
    throw Exception('Not implemented');
  }

  void destroySkybox(Skybox skybox) {
    throw Exception('Not implemented');
  }

  void destroyColorGrading(ColorGrading colorGrading) {
    throw Exception('Not implemented');
  }

  void destroyTexture(Texture texture) {
    throw Exception('Not implemented');
  }

  void destroyRenderTarget(RenderTarget target) {
    throw Exception('Not implemented');
  }

  void destroyEntity(int entity) {
    throw Exception('Not implemented');
  }

  void flushAndWait() =>
      native.instance.filament_engine_flush_and_wait(_mNativeHandle);
}

native.EngineRef getEngineNativeHandle(Engine engine) => engine._mNativeHandle;
