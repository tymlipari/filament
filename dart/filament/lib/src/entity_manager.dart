import 'package:filament/src/native.dart' as native;

class EntityManager {
  native.EntityManagerRef _mNativeHandle;

  EntityManager._(this._mNativeHandle);
  EntityManager._global() : this._(native.instance.filament_get_entity_manager());

  int createEntity() => native.instance.filament_entity_manager_create_entity(_mNativeHandle);

  void destroyEntity(int entityId) => native.instance.filament_entity_manager_destroy_entity(entityId);

  bool isEntityAlive(int entityId) => native.instance.filament_entity_manager_entity_is_alive(entityId) != 0;
}

EntityManager createEntityManagerFromNative(native.EntityManagerRef handle) => EntityManager._(handle);