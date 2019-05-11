import 'dart:math' show Rectangle, Point;

class BoundingBox {
  double minLongitude;
  double minLatitude;
  double maxLongitude;
  double maxLatitude;
  Rectangle _rectangleThis;

  /// A bounding box represents a rectangular area by top left point and bottom right point
  BoundingBox(this.minLongitude, this.minLatitude, this.maxLongitude,
      this.maxLatitude) {
    _rectangleThis = Rectangle(minLongitude, maxLatitude,
        maxLongitude - minLongitude, maxLatitude - minLatitude);
  }

  /// Creates a boundingBox instance from a point, which is considered to be center of box
  /// Both width and height are required
  BoundingBox.fromCenter(Point centerLocation, double width, double height) {
    minLongitude = centerLocation.x - width / 2;
    minLatitude = centerLocation.y - height / 2;
    maxLongitude = centerLocation.x + width / 2;
    maxLatitude = centerLocation.y + height / 2;
    _rectangleThis = Rectangle(minLongitude, maxLatitude,
        maxLongitude - minLongitude, maxLatitude - minLatitude);
  }

  /// Decides whether to fetch a certain tile or not
  /// Tiles are represented in form of boundinb box
  /// This function checks whether boundingBox passed as argument is contained with this boundingBox
  /// If yes, okay, else we check intersection of two rectangles
  /// If they intersect and insection rectangle has both width and height greater than 0, we ask to fetch that tile
  bool shouldFetchTile(BoundingBox that) {
    Rectangle rectangleThat = Rectangle(
        that.maxLongitude,
        that.maxLatitude,
        that.maxLongitude - that.minLongitude,
        that.maxLatitude - that.maxLatitude);
    if (_rectangleThis.containsRectangle(rectangleThat))
      return true;
    else {
      var intersection = _rectangleThis.intersection(rectangleThat);
      return intersection == null
          ? false
          : (intersection.width > 0 && intersection.height > 0);
    }
  }

  /// Checks whether this tile contains a certain point or not
  bool holdsPoint(Point location) => _rectangleThis.containsPoint(location);
}
