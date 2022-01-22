#ifndef FILAMENT_DART_H_
#define FILAMENT_DART_H_

#ifdef __cplusplus
extern "C" {
#endif

// todo clean up
typedef unsigned char bool;

typedef struct BufferObjectBuilder *BufferObjectBuilderRef;
typedef struct BufferObject *BufferObjectRef;
typedef struct Camera *CameraRef;
typedef struct ColorGrading *ColorGradingRef;
typedef struct Engine *EngineRef;
typedef struct EntityManager *EntityManagerRef;
typedef struct Fence *FenceRef;
typedef struct IndexBuffer *IndexBufferRef;
typedef struct IndirectLight *IndirectLightRef;
typedef struct LightManager *LightManagerRef;
typedef struct Material *MaterialRef;
typedef struct MaterialInstance *MaterialInstanceRef;
typedef struct NativeSurface *NativeSurfaceRef;
typedef struct Parameter *ParameterRef;
typedef struct Renderer *RendererRef;
typedef struct RenderTarget *RenderTargetRef;
typedef struct Scene *SceneRef;
typedef struct Skybox *SkyboxRef;
typedef struct SwapChain *SwapChainRef;
typedef struct Texture *TextureRef;
typedef struct TextureSampler *TextureSamplerRef;
typedef struct TransformManager *TransformManagerRef;
typedef struct View *ViewRef;

///
/// Math types
///

typedef struct {
  float x;
  float y;
  float z;
} Vector3, *Vector3Ref;

typedef struct {
  float x;
  float y;
  float z;
  float w;
} Vector4, *Vector4Ref;

typedef struct {
  Vector3 rows[3];
} Matrix3x3, *Matrix3x3Ref;

typedef struct {
  Vector4 rows[4];
} Matrix4x4, *Matrix4x4Ref;

///
/// Common types
///
typedef struct {
  int left;
  int bottom;
  int width;
  int height;
} filament_viewport_t;

///
/// Memory helpers
///
void* filament_allocate(long long bytes);
void filament_free(void* ptr);

///
/// Engine
///
EngineRef filament_create_engine(int backend);
void filament_destroy_engine(EngineRef instance);

int filament_engine_get_backend(EngineRef instance);
void filament_engine_flush_and_wait(EngineRef engine);

EntityManagerRef filament_engine_get_entity_manager(EngineRef instance);

///
/// Creates a swap chain against the given surface
///
/// instance - A FILAMENT_HANDLE pointing to an engine instance
/// surface - the OS surface to create a swap chain against
/// flags - swap chain creation flags
///
/// Returns a handle to a swap chain instance
///
SwapChainRef filament_engine_create_swapchain(EngineRef instance, void* surface, long flags);

SwapChainRef filament_engine_create_swapchain_headless(EngineRef instance, int width, int height, long flags);

void filament_destroy_swapchain(SwapChainRef instance);

///
/// View
///
ViewRef filament_engine_create_view(EngineRef engine);
void filament_destroy_view(ViewRef view);

///
/// Renderer
///
typedef struct {
  float refreshRate;
  long long presentationDeadlineNanos;
  long long vsyncOffsetNanos;
} filament_display_info_t;

typedef struct {
  float interval;
  float headRoomRatio;
  float scaleRate;
  int history;
} filament_framerate_options_t;

typedef struct {
  Vector4 clearColor;
  bool clear;
  bool discard;
} filament_clear_options_t;

RendererRef filament_engine_create_renderer(EngineRef engine);
void filament_destroy_renderer(RendererRef renderer);

void                          filament_renderer_set_display_info(RendererRef renderer, filament_display_info_t info);
filament_display_info_t       filament_renderer_get_display_info(RendererRef renderer);
void                          filament_renderer_set_framerate_options(RendererRef renderer, filament_framerate_options_t options);
filament_framerate_options_t  filament_renderer_get_framerate_options(RendererRef renderer);
void                          filament_renderer_set_clear_options(RendererRef renderer, filament_clear_options_t options);
filament_clear_options_t      filament_renderer_get_clear_options(RendererRef renderer);

bool                          filament_renderer_begin_frame(RendererRef renderer, SwapChainRef swapChain, long long frameTimeNanos);
void                          filament_renderer_end_frame(RendererRef renderer);
void                          filament_renderer_render(RendererRef renderer, ViewRef view);
void                          filament_renderer_render_standalone_view(RendererRef renderer, ViewRef view);
void                          filament_renderer_copy_frame(RendererRef renderer, SwapChainRef dest, filament_viewport_t destViewport, filament_viewport_t srcViewport, int flags);

void                          filament_renderer_reset_user_time(RendererRef renderer);

///
/// Camera
///
CameraRef filament_engine_create_camera(EngineRef engine, int entity);
CameraRef filament_engine_get_camera_component(EngineRef engine, int entity);
void filament_destroy_camera_component(int entity);

void filament_camera_set_projection(CameraRef camera, int projectionKind, double left, double right, double bottom, double top, double near, double far);
void filament_camera_set_projection_fov(CameraRef camera, double fovInDegrees, double aspect, double near, double far, int direction);
void filament_camera_set_projection_lens(CameraRef camera, double focalLength, double aspect, double near, double far);
void filament_camera_set_projection_custom(CameraRef camera, Matrix4x4 projection, double near, double far);
void filament_camera_set_scaling(CameraRef camera, double scalingX, double scalingY);
void filament_camera_set_shift(CameraRef camera, double shiftX, double shiftY);
void filament_camera_set_lookat(CameraRef camera, double eyeX, double eyeY, double eyeZ, double centerX, double centerY, double centerZ, double upX, double upY, double upZ);
void filament_camera_set_exposure(CameraRef camera, float aperture, float shutterSpeed, float sensitivity);
float filament_camera_get_near(CameraRef camera);
float filament_camera_get_culling_far(CameraRef camera);
void filament_camera_get_projection_matrix(CameraRef camera, Matrix4x4* result);
void filament_camera_get_culling_projection_matrix(CameraRef camera, Matrix4x4* result);
Vector4 filament_camera_get_scaling(CameraRef camera);
Matrix4x4 filament_camera_get_model_matrix(CameraRef camera);
Vector3 filament_camera_get_position(CameraRef camera);
Vector3 filament_camera_get_left_vector(CameraRef camera);
Vector3 filament_camera_get_up_vector(CameraRef camera);
Vector3 filament_camera_get_forward_vector(CameraRef camera);
float filament_camera_get_aperture(CameraRef camera);
float filament_camera_get_shutter_speed(CameraRef camera);
float filament_camera_get_sensitivity(CameraRef camera);
double filament_camera_get_focal_length(CameraRef camera);
void filament_camera_set_focus_distance(CameraRef camera, float distance);
float filament_camera_get_focus_distance(CameraRef camera);

double filament_camera_compute_effective_focal_length(double focalLength, double focusDistance);
double filament_camera_compute_effective_fov(double fovInDegrees, double focusDistance);

///
/// Scene
///
SceneRef    filament_engine_create_scene(EngineRef engine);
void        filament_destroy_scene(SceneRef scene);

void        filament_scene_set_skybox(SceneRef scene, SkyboxRef skybox);
void        filament_scene_set_indirect_light(SceneRef scene, IndirectLightRef light);
void        filament_scene_add_entity(SceneRef scene, int entity);
void        filament_scene_remove_entity(SceneRef scene, int entity);
int         filament_scene_get_renderable_count(SceneRef scene);
int         filament_scene_get_light_count(SceneRef scene);

///
/// Fence
///
FenceRef filament_engine_create_fence(EngineRef engine);
void filament_destroy_fence(FenceRef fence);

int filament_fence_wait(FenceRef fence, int mode, long long timeoutMS);

ColorGradingRef filament_engine_create_color_grading(EngineRef engine);
void filament_destroy_color_grading(ColorGradingRef colorGrading);

///
/// Color
///
Vector3 filament_color_cct(float temperature);
Vector3 filament_color_illuminantD(float temperature);

///
/// EntityManager
///
EntityManagerRef filament_get_entity_manager();
int filament_entity_manager_create_entity(EntityManagerRef manager);
void filament_entity_manager_destroy_entity(int entityId);
int filament_entity_manager_entity_is_alive(int entityId);

///
/// IndexBuffer
///
IndexBufferRef filament_engine_create_index_buffer(EngineRef engine, int indexCount, int indexType);
int filament_index_buffer_get_index_count(IndexBufferRef buffer);
void filament_index_buffer_set_buffer(EngineRef engine, IndexBufferRef buffer, int destOffsetInBytes, int count);

///
/// IndirectLight
///
IndirectLightRef filament_engine_create_indirect_light(
    EngineRef engine, 
    TextureRef cubeMap,
    int irradianceBands, float* irradianceSh, int irradianceShCount,
    int radianceBands, float* radianceSh, int radianceShCount,
    float envIntensity,
    Matrix3x3* rotation);

float       filament_indirect_light_get_intensity(IndirectLightRef light);
void        filament_indirect_light_set_intensity(IndirectLightRef light, float intensity);
void        filament_indirect_light_get_rotation(IndirectLightRef light, Matrix3x3* result);
void        filament_indirect_light_set_rotation(IndirectLightRef light, Matrix3x3* rotation);
TextureRef  filament_indirect_light_get_reflections_texture(IndirectLightRef light);
TextureRef  filament_indirect_light_get_irradiance_texture(IndirectLightRef light);

Vector3     filament_indirect_light_get_direction_estimate(float* sh, int shCount, Vector3 direction);
Vector4     filament_indirect_light_get_color_estimate(Vector4 colorIntensity, float* sh, int shCount, float x, float y, float z);

///
/// LightManager
///
LightManagerRef     filament_engine_get_light_manager(EngineRef engine);
int                 filament_light_manager_get_component_count(LightManagerRef lightManager);
int                 filament_light_manager_has_component(LightManagerRef lightManager, int entity);
int                 filament_light_manager_get_instance(LightManagerRef lightManager, int entity);
void                filament_light_manager_destroy(LightManagerRef lightManager, int entity);
int                 filament_light_manager_get_type(LightManagerRef lightManager, int entityInstance);
void                filament_light_manager_set_light_channel(LightManagerRef lightManager, int entityInstance, int channel, int enabled);
int                 filament_light_manager_get_light_channel(LightManagerRef lightManager, int entityInstance, int channel);
void                filament_light_manager_set_position(LightManagerRef lightManager, int entityInstance, double posX, double posY, double posZ);
void                filament_light_manager_get_position(LightManagerRef lightManager, int entityInstance, Vector3* result);
void                filament_light_manager_set_direction(LightManagerRef lightManager, int entityInstance, double dirX, double dirY, double dirZ);
void                filament_light_manager_get_direction(LightManagerRef lightManager, int entityInstance, Vector3* result);
void                filament_light_manager_set_color(LightManagerRef lightManager, float colorR, float colorG, float colorB);
void                filament_light_manager_get_color(LightManagerRef lightManager, Vector3* result);
void                filament_light_manager_set_intensity(LightManagerRef lightManager, int entityInstance, float intensity);
float               filament_light_manager_get_intensity(LightManagerRef lightManager, int entityInstance);
void                filament_light_manager_set_falloff(LightManagerRef lightManager, int entityInstance, float falloff);
float               filament_light_manager_get_falloff(LightManagerRef lightManager, int entityInstance);
void                filament_light_manager_set_spotlight_cone(LightManagerRef lightManager, int entityInstance, float inner, float outer);
void                filament_light_manager_set_sun_angular_radius(LightManagerRef lightManager, int entityInstance, float angularRadius);
float               filament_light_manager_get_sun_angular_radius(LightManagerRef lightManager, int entityInstance);
void                filament_light_manager_set_sun_halo_size(LightManagerRef lightManager, int entityInstance, float haloSize);
float               filament_light_manager_get_sun_halo_size(LightManagerRef lightManager, int entityInstance);
void                filament_light_manager_set_sun_halo_falloff(LightManagerRef lightManager, int entityInstance, float haloFalloff);
float               filament_light_manager_get_sun_halo_falloff(LightManagerRef lightManager, int entityInstance);
void                filament_light_manager_set_shadow_caster(LightManagerRef lightManager, int entityInstance, int castShadows);
int                 filament_light_manager_get_shadow_caster(LightManagerRef lightManager, int entityInstance);
float               filament_light_manager_get_outer_cone_angle(LightManagerRef lightManager, int entityInstance);
float               filament_light_manager_get_inner_cone_angle(LightManagerRef ligthManager, int entityInstance);

///
/// Material
///
MaterialRef         filament_engine_create_material_from_payload(EngineRef engine, void* data, int dataLen);
MaterialInstanceRef filament_material_get_default_instance(MaterialRef material);
MaterialInstanceRef filament_material_create_instance(MaterialRef material);
MaterialInstanceRef filament_material_create_instance_with_name(MaterialRef material, const char* name);
const char*         filament_material_get_name(MaterialRef material);
int                 filament_material_get_shading(MaterialRef material);
int                 filament_material_get_interpolation(MaterialRef material);
int                 filament_material_get_blending_mode(MaterialRef material);
int                 filament_material_get_refraction_mode(MaterialRef material);
int                 filament_material_get_refraction_type(MaterialRef material);
int                 filament_material_get_vertex_domain(MaterialRef material);
int                 filament_material_get_culling_mode(MaterialRef material);
int                 filament_material_get_is_color_write_enabled(MaterialRef material);
int                 filament_material_get_is_depth_write_enabled(MaterialRef material);
int                 filament_material_get_is_depth_culling_enabled(MaterialRef material);
int                 filament_material_get_is_double_sided(MaterialRef material);
float               filament_material_get_mask_threshold(MaterialRef material);
float               filament_material_get_specular_aa_variance(MaterialRef material);
float               filament_material_get_specular_aa_threshold(MaterialRef material);
int                 filament_material_get_required_attributes(MaterialRef material);
int                 filament_material_get_parameter_count(MaterialRef material);
int                 filament_material_get_parameters(MaterialRef material, ParameterRef parameters[], int parameterCount);
int                 filament_material_get_has_parameter(MaterialRef material, const char* name);

///
/// MaterialInstance
///
MaterialRef         filament_material_instance_get_material(MaterialInstanceRef materialInstance);
MaterialInstanceRef filament_duplicate_material_instance(MaterialInstanceRef otherInstance, const char* newName);
const char*         filament_material_instance_get_name(MaterialInstanceRef materialInstance);
void                filament_material_instance_set_param_bool(MaterialInstanceRef materialInstance, const char* name, bool x);
void                filament_material_instance_set_param_bool2(MaterialInstanceRef materialInstance, const char* name, bool x, bool y);
void                filament_material_instance_set_param_bool3(MaterialInstanceRef materialInstance, const char* name, bool x, bool y, bool z);
void                filament_material_instance_set_param_bool4(MaterialInstanceRef materialInstance, const char* name, bool x, bool y, bool z, bool w);
void                filament_material_instance_set_param_int(MaterialInstanceRef materialInstance, const char* name, int x);
void                filament_material_instance_set_param_int2(MaterialInstanceRef materialInstance, const char* name, int x, int y);
void                filament_material_instance_set_param_int3(MaterialInstanceRef materialInstance, const char* name, int x, int y, int z);
void                filament_material_instance_set_param_int4(MaterialInstanceRef materialInstance, const char* name, int x, int y, int z, int w);
void                filament_material_instance_set_param_float(MaterialInstanceRef materialInstance, const char* name, float x);
void                filament_material_instance_set_param_float2(MaterialInstanceRef materialInstance, const char* name, float x, float y);
void                filament_material_instance_set_param_float3(MaterialInstanceRef materialInstance, const char* name, float x, float y, float z);
void                filament_material_instance_set_param_float4(MaterialInstanceRef materialInstance, const char* name, float x, float y, float z, float w);
void                filament_material_instance_set_param_rgb(MaterialInstanceRef materialInstance, const char* name, float r, float g, float b);
void                filament_material_instance_set_param_rgba(MaterialInstanceRef materialInstance, const char* name, float r, float g, float b, float a);
void                filament_material_instance_set_param_bool_array(MaterialInstanceRef materialInstance, const char* name, int type, bool v[], int offset, int count);
void                filament_material_instance_set_param_int_array(MaterialInstanceRef materialInstance, const char* name, int type, int v[], int offset, int count);
void                filament_material_instance_set_param_float_array(MaterialInstanceRef materialInstance, const char* name, int type, float v[], int offset, int count);
void                filament_material_instance_set_param_texture(MaterialInstanceRef materialInstance, const char* name, TextureRef texture, TextureSamplerRef sampler);
void                filament_material_instance_set_scissor(MaterialInstanceRef materialInstance, int left, int bottom, int width, int height);
void                filament_material_instance_unset_scissor(MaterialInstanceRef materialInstance);
void                filament_material_instance_set_polygon_offset(MaterialInstanceRef materialInstance, float scale, float constant);
void                filament_material_instance_set_mask_threshold(MaterialInstanceRef materialInstance, float threshold);
void                filament_material_instance_set_specular_aa_variance(MaterialInstanceRef materialInstance, float variance);
void                filament_material_instance_set_specular_aa_threshold(MaterialInstanceRef materialInstance, float threshold);
void                filament_material_instance_set_double_sided(MaterialInstanceRef materialInstance, bool doubleSided);
void                filament_material_instance_set_culling_mode(MaterialInstanceRef materialInstance, int cullingMode);
void                filament_material_instance_set_color_write(MaterialInstanceRef materialInstance, bool enable);
void                filament_material_instance_set_depth_write(MaterialInstanceRef materialInstance, bool enable);
void                filament_material_instance_set_depth_culling(MaterialInstanceRef materialInstance, bool enable);

///
/// NativeSurface
///
NativeSurfaceRef    filament_create_native_surface(int width, int height);
void                filament_destroy_native_surface(NativeSurfaceRef surface);

///
/// RenderTarget
///
typedef struct {
    int attachment;
    TextureRef texture;
    int mipLevel;
    int cubemapFace;
    int layer;
} filament_render_target_attachment_config_t;

RenderTargetRef     filament_engine_create_render_target(EngineRef engine, filament_render_target_attachment_config_t attachmentConfigs[], int attachmentConfigsCount);
void                filament_destroy_render_target(RenderTargetRef renderTarget);


///
/// TextureSampler
///
TextureSamplerRef   filament_create_texture_sampler(int min, int mag, int wrapS, int wrapT, int wrapR);
TextureSamplerRef   filament_create_compare_texture_sampler(int mode, int function);
void                filament_destroy_texture_sampler(TextureSamplerRef sampler);

int                 filament_texture_sampler_get_min_filter(TextureSamplerRef sampler);
void                filament_texture_sampler_set_min_filter(TextureSamplerRef sampler, int minFilter);
int                 filament_texture_sampler_get_mag_filter(TextureSamplerRef sampler);
void                filament_texture_sampler_set_mag_filter(TextureSamplerRef sampler, int magFilter);
int                 filament_texture_sampler_get_wrap_mode_s(TextureSamplerRef sampler);
void                filament_texture_sampler_set_wrap_mode_s(TextureSamplerRef sampler, int wrapMode);
int                 filament_texture_sampler_get_wrap_mode_t(TextureSamplerRef sampler);
void                filament_texture_sampler_set_wrap_mode_t(TextureSamplerRef sampler, int wrapMode);
int                 filament_texture_sampler_get_wrap_mode_r(TextureSamplerRef sampler);
void                filament_texture_sampler_set_wrap_mode_r(TextureSamplerRef sampler, int wrapMode);
int                 filament_texture_sampler_get_compare_mode(TextureSamplerRef sampler);
void                filament_texture_sampler_set_compare_mode(TextureSamplerRef sampler, int compareMode);
int                 filament_texture_sampler_get_compare_function(TextureSamplerRef sampler);
void                filament_texture_sampler_set_compare_function(TextureSamplerRef sampler, int compareFunction);
float               filament_texture_sampler_get_ansiotropy(TextureSamplerRef sampler);
void                filament_texture_sampler_set_ansiotropy(TextureSamplerRef sampler, float ansiotropy);

///
/// TransformManager
///
bool                filament_transform_manager_has_component(TransformManagerRef manager, int entity);
int                 filament_transform_manager_get_instance(TransformManagerRef manager, int entity);
int                 filament_transform_manager_create(TransformManagerRef manager, int entity);
int                 filament_transform_manager_create_array(TransformManagerRef manager, int entity, int parent, float localTransform[]);
int                 filament_transform_manager_create_array_fp64(TransformManagerRef manager, int entity, int parent, double localTransform[]);
void                filament_transform_manager_destroy(TransformManagerRef manager, int entity);
void                filament_transform_manager_set_parent(TransformManagerRef manager, int i, int newParent);
int                 filament_transform_manager_get_parent(TransformManagerRef manager, int i);
void                filament_transform_manager_set_transform(TransformManagerRef manager, int i, float localTransform[]);
void                filament_transform_manager_set_transform_fp64(TransformManagerRef manager, int i, double localTransform[]);
void                filament_transform_manager_get_transform(TransformManagerRef manager, int i, float outLocalTransform[]);
void                filament_transform_manager_get_transform_fp64(TransformManagerRef manager, int i, double outLocalTransform[]);
void                filament_transform_manager_get_world_transform(TransformManagerRef manager, int i, float outWorldTransform[]);
void                filament_transform_manager_get_world_transform_fp64(TransformManagerRef manager, int i, double outWorldTransform[]);
void                filament_transform_manager_open_local_tranform_transaction(TransformManagerRef manager);
void                filament_transform_manager_commit_local_transform_transaction(TransformManagerRef manager);
void                filament_transform_manager_set_accurate_translations_enabled(TransformManagerRef manager, bool enabled);
bool                filament_transform_manager_get_accurage_translations_enabled(TransformManagerRef manager);


///
/// View
///
const char*         filament_view_get_name(ViewRef view);
void                filament_view_set_name(ViewRef view, const char* name);
void                filament_view_set_scene(ViewRef view, SceneRef scene);
void                filament_view_set_camera(ViewRef view, CameraRef camera);
void                filament_view_set_viewport(ViewRef view, int left, int bottom, int width, int height);
void                filament_view_set_blendmode(ViewRef view, int blendMode);
void                filament_view_set_visible_layers(ViewRef view, unsigned char select, unsigned char values);
void                filament_view_set_shadowing_enabled(ViewRef view, bool enabled);
bool                filament_view_get_shadowing_enabled(ViewRef view);
void                filament_view_set_screenspace_refraction_enabled(ViewRef view, bool enabled);
bool                filament_view_get_screenspace_refraction_enabled(ViewRef view);
void                filament_view_set_render_target(ViewRef view, RenderTargetRef renderTarget);
void                filament_view_set_antialiasing(ViewRef view, int type);
int                 filament_view_get_antialiasing(ViewRef view);
void                filament_view_set_msaa_options(ViewRef view, bool enabled, int sampleCount, bool customResolve);
void                filament_view_set_taa_options(ViewRef view, float feedback, float filterWidth, bool enabled);
void                filament_view_set_color_grading(ViewRef view, ColorGradingRef colorGrading);
void                filament_view_set_dithering(ViewRef view, int dithering);
int                 filament_view_get_dithering(ViewRef view);
void                filament_view_set_dynamic_resolution_options(ViewRef view, bool enabled, bool homogenousScaling, float minScale, float maxScale, float sharpness, int quality);
void                filament_view_set_render_quality(ViewRef view, int hdrColorBufferQuality);
void                filament_view_set_post_processing_enabled(ViewRef view, bool enabled);
bool                filament_view_get_post_processing_enabled(ViewRef view);
void                filament_view_set_front_face_winding_inverted(ViewRef view, bool inverted);
bool                filament_view_get_front_face_winding_inverted(ViewRef view);
void                filament_view_set_dynamic_lighting_options(ViewRef view, float zLightNear, float zLightFar);
void                filament_view_set_shadow_type(ViewRef view, int shadowType);
void                filament_view_set_vsm_shadow_options(ViewRef view, int ansiotropy, bool mipmapping, float minVarianceScale, float lightBleedReduction);
void                filament_view_set_soft_shadow_options(ViewRef view, float penumbraScale, float penumbraRatioScale);
void                filament_view_set_ambient_occlusion_options(ViewRef view, float radius, float bias, float power, float resolution, float intensity, float bilateralThreshold, int quality, int lowPassFilter, int upsampling, bool enabled, bool bentNormals, float minHorizonAngleRad);
void                filament_view_set_ssct_options(ViewRef view, float ssctLightConeRad, float ssctStartTraceDistance, float ssctContactDistanceMax, float ssctIntensity, float v, float v1, float v2, float ssctDepthBias, float ssctDepthSlopeBias, int ssctSampleCount, int ssctRayCount, bool ssctEnabled);
void                filament_view_set_bloom_options(ViewRef view, TextureRef dirtTexture, float dirtStrength, float strength, int resolution, float anamorphism, int levels, int blendMode, bool threshold, bool enabled, float highlight,
                        bool lensFlare, bool starburst, float chromaticAberration, int ghostCount, float ghostSpacing, float ghostThreshold, float haloThickness, float haloRadius, float haloThreshold);
void                filament_view_set_vignette_options(ViewRef view, float midPoint, float roundness, float feather, float r, float g, float b, float a, bool enabled);
void                filament_view_set_fog_options(ViewRef view, float distance, float maximumOpacity, float height, float heightFalloff, float v, float v1, float v2, float density, float inScatteringStart, float inScatteringSize, bool fogColorFromIbl, bool enabled);
void                filament_view_set_depth_of_field_options(ViewRef view, float cocScale, float maxApertureDiameter, bool enabled, int filter, 
                        bool nativeResolution, int foregroundRingCount, int backgroundRingCount, int fastGatherRingCount, int maxForegroundCOC, int maxBackgroundCOC);


///
/// BufferObject
///
BufferObjectBuilderRef  filament_create_BufferObjectBuilder();
void                    filament_destroy_BufferObjectBuilder(BufferObjectBuilderRef builder);
void                    filament_BufferObjectBuilder_set_size(BufferObjectBuilderRef builder, int byteCount);
void                    filament_BufferObjectBuilder_set_bindingType(BufferObjectBuilderRef builder, int bindingType);
BufferObjectRef         filament_BufferObjectBuilder_build(BufferObjectBuilderRef builder, EngineRef engine);

int                     filament_BufferObject_get_byteCount(BufferObjectRef bufferObj);
void                    filament_BufferObject_set_buffer(BufferObjectRef bufferObj, EngineRef engine, void* buffer, int remaining, int destOffsetInBytes, int count);

#ifdef __cplusplus
}
#endif

#endif