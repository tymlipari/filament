#ifndef FILAMENT_DART_H_
#define FILAMENT_DART_H_

#ifdef __cplusplus
extern "C" {
#endif

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
typedef struct Parameter *ParameterRef;
typedef struct Renderer *RendererRef;
typedef struct Scene *SceneRef;
typedef struct SwapChain *SwapChainRef;
typedef struct Texture *TextureRef;
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
  union {
    float v[9];
    float m[3][3];
  };
} Matrix3x3, *Matrix3x3Ref;

typedef struct {
  union {
    float v[16];
    float m[4][4];
  };
} Matrix4x4, *Matrix4x4Ref;

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
RendererRef filament_engine_create_renderer(EngineRef engine);
void filament_destroy_renderer(RendererRef renderer);

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

SceneRef filament_engine_create_scene(EngineRef engine);
void filament_destroy_scene(SceneRef scene);

///
/// Fence
///
FenceRef filament_engine_create_fence(EngineRef engine);
void filament_destroy_fence(FenceRef fence);

int filament_fence_wait(FenceRef fence, int mode, long long timeoutMS);

BufferObjectBuilderRef filament_create_buffer_builder();

BufferObjectRef filament_engine_create_buffer_object(EngineRef engine, int byteCount, int bindingType);

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

#ifdef __cplusplus
}
#endif

#endif