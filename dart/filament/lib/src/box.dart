import 'math.dart';

///
/// An axis-aligned 3D box represented by its center and half-extent.
///
/// The half-extent is a vector representing the distance from the center to the edge of the box in
/// each dimension. For example, a box of size 2 units in X, 4 units in Y, and 10 units in Z would
/// have a half-extent of (1, 2, 5).
///
class Box {
  final Vector3 center;
  final Vector3 halfExtent;

  Box()
      : center = Vector3.zero(),
        halfExtent = Vector3.zero();

  Box.fromParts(this.center, this.halfExtent);
}
