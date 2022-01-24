import 'package:filament/src/disposable.dart';
import 'package:filament/src/entity.dart';
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

  Entity createEntity() =>
      createEntityFromId(this, native.instance.filament_entity_manager_create_entity(_mNativeHandle));

  void destroyEntity(Entity entity) =>
      native.instance.filament_entity_manager_destroy_entity(entity.id);

  bool isEntityAlive(Entity entity) =>
      native.instance.filament_entity_manager_entity_is_alive(entity.id) != 0;
}

EntityManager createEntityManagerFromNative(native.EntityManagerRef handle) =>
    EntityManager._(handle);
