import 'dart:math' show max, min;

class BoundingBox {
  double minLongitude;
  double minLatitude;
  double maxLongitude;
  double maxLatitude;

  /// A bounding box represents a rectangular area by top left point and bottom right point
  BoundingBox(
      this.minLongitude, this.minLatitude, this.maxLongitude, this.maxLatitude);

  /// Decides whether to fetch a certain tile or not
  /// Tiles are represented in form of boundinb box
  /// This function checks whether boundingBox passed as argument is contained with this boundingBox
  /// If yes, okay, else we check intersection of two rectangles
  /// If they intersect and insection rectangle has both width and height greater than 0, we ask to fetch that tile
  bool shouldFetchTile(BoundingBox that) {
    if (_containsBoundingBox(that))
      return true;
    else {
      var box = _intersection(that);
      return box == null
          ? false
          : (_difference(box.minLongitude, box.maxLongitude) > 0 &&
              _difference(box.maxLatitude, box.minLatitude) > 0);
    }
  }

  /// Checks whether this bounding box hold that or not
  bool _containsBoundingBox(BoundingBox that) =>
      minLongitude <= that.minLongitude &&
      maxLongitude >= that.maxLongitude &&
      maxLatitude >= that.maxLatitude &&
      minLatitude <= that.minLatitude;

  /// Finds out intersection of two bounding boxes
  /// If they don't intersect returns null
  BoundingBox _intersection(BoundingBox that) {
    BoundingBox box;
    var x0 = max(minLongitude, that.minLongitude);
    var x1 = min(maxLongitude, that.maxLongitude);
    if (x0 <= x1) {
      var y0 = max(minLatitude, that.minLatitude);
      var y1 = min(maxLatitude, that.maxLatitude);
      if (y0 <= y1) box = BoundingBox(x0, y0, x1, y1);
    }
    return box;
  }

  /// Computes difference of two numbers
  double _difference(double a, double b) => (a - b) < 0 ? -(a - b) : (a - b);
}
