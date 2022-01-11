class Viewport {
  final int left;
  final int bottom;
  final int width;
  final int height;

  Viewport(this.left, this.bottom, this.width, this.height) {
    assert(width > 0 && height > 0);
  }
}
