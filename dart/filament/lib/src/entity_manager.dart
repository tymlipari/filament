import 'package:filament/src/disposable.dart';
import 'package:filament/src/native.dart' as native;

class EntityManager implements Disposable {
  native.EntityManagerRef _mNativeHandle;

  ///
  /// Constructors
  ///

  factory EntityManager._(native.EntityManagerRef handle) {
    var entityManager =
        native.NativeObjectFactory.tryGet<EntityManager>(handle);
    if (entityManager == null) {
      entityManager = EntityManager._fromHandle(handle);
      native.NativeObjectFactory.insert(handle, entityManager);
    }
    return entityManager;
  }

  EntityManager._fromHandle(this._mNativeHandle);

  static EntityManager _global() =>
      EntityManager._(native.instance.filament_get_entity_manager());

  ///
  /// Methods
  ///

  int createEntity() =>
      native.instance.filament_entity_manager_create_entity(_mNativeHandle);

  void destroyEntity(int entityId) =>
      native.instance.filament_entity_manager_destroy_entity(entityId);

  bool isEntityAlive(int entityId) =>
      native.instance.filament_entity_manager_entity_is_alive(entityId) != 0;
}

EntityManager createEntityManagerFromNative(native.EntityManagerRef handle) =>
    EntityManager._(handle);
