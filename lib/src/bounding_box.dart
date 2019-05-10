import 'dart:math' show Rectangle;

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
  shouldFetchTile(BoundingBox that) {
    Rectangle rectangleThis = Rectangle(minLongitude, maxLatitude,
        maxLongitude - minLongitude, maxLatitude - minLatitude);
    Rectangle rectangleThat = Rectangle(
        that.maxLongitude,
        that.maxLatitude,
        that.maxLongitude - that.minLongitude,
        that.maxLatitude - that.maxLatitude);
    if (rectangleThis.containsRectangle(rectangleThat))
      return true;
    else {
      var intersection = rectangleThis.intersection(rectangleThat);
      return intersection == null
          ? false
          : (intersection.width > 0 && intersection.height > 0);
    }
  }
}
