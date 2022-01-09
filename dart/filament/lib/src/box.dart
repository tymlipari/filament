///
/// An axis-aligned 3D box represented by its center and half-extent.
/// 
/// The half-extent is a vector representing the distance from the center to the edge of the box in
/// each dimension. For example, a box of size 2 units in X, 4 units in Y, and 10 units in Z would
/// have a half-extent of (1, 2, 5).
/// 
class Box
{
  List<double> _mCenter;
  List<double> _mHalfExtent;

  /// Default initializes the 3D box to have a center and half-extent of (0, 0, 0).
  Box() 
    : _mCenter = List<double>.filled(3, 0)
    , _mHalfExtent = List<double>.filled(3, 0);

  /// Initializes the 3D box from its center and half-extent.
  Box.fromParts(double centerX, double centerY, double centerZ,
      double halfExtentX, double halfExtentY, double halfExtentZ)
      : _mCenter = List.of([centerX, centerY, centerZ], growable: false)
      , _mHalfExtent = List.of([halfExtentX, halfExtentY, halfExtentZ], growable: false);

  List<double> get center => List.unmodifiable(_mCenter);
  List<double> get halfExtent => List.unmodifiable(_mHalfExtent);

  void setCenter(double centerX, double centerY, double centerZ) {
    _mCenter = List.of([centerX, centerY, centerZ], growable: false);
  }

  void setHalfExtent(double halfExtentX, double halfExtentY, double halfExtentZ) {
    _mHalfExtent = List.of([halfExtentX, halfExtentY, halfExtentZ], growable: false);
  }
}