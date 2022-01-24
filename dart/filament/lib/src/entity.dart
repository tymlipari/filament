import 'entity_manager.dart';

class Entity {
  final EntityManager _mOwner;
  final int id;

  Entity._(this._mOwner, this.id);

  bool get isAlive => _mOwner.isEntityAlive(this);
}

Entity createEntityFromId(EntityManager owner, int id) => Entity._(owner, id);