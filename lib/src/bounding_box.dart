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
      var intersection = _rectangleThis.intersection(rectangleThat);
      return intersection == null
          ? false
          : (intersection.width > 0 && intersection.height > 0);
    }
  }

  /// Checks whether this bounding box hold that or not
  bool _containsBoundingBox(BoundingBox that) =>
      minLongitude <= that.minLongitude &&
      maxLongitude >= that.maxLongitude &&
      maxLatitude >= that.maxLatitude &&
      minLatitude <= that.minLatitude;

  BoundingBox _intersection(BoundingBox that) {
    var x0 = max(minLongitude, that.minLongitude);
    var x1 = min(maxLongitude, that.maxLongitude);
    if (x0 <= x1) {
      var y0 = min(minLatitude, that.minLatitude);
      var y1 = max(maxLatitude, that.maxLatitude);
      if (y0 >= y1) {
        return BoundingBox();
      }
    } else
      return null;
  }
}
