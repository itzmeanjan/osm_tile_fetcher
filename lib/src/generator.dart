import 'dart:math' show pow, sqrt;

class TileGenerator {
  int zoomLevel;

  /// Helps us to generate Tiles, zoom level to be considered needs to be provided during invokation of methods
  TileGenerator(this.zoomLevel);

  /// Gives number of tiles to be present in a certain zoom level
  int tileCountInZoomLevel() => pow(2 * 2, zoomLevel);

  /// This is the method that you might be actually interested in using mostly
  /// Generates all the tiles which can be present in a certain zoom level
  /// Returns value in form of Map<String, List<double>>
  /// Keys of Map, used as tile identifier
  /// May be you'll be breaking a key using 'x-y'.split('-'), to get tileIdX and tileIdY in List<String> form.
  Map<String, List<double>> tilesInZoomLevel() {
    if (zoomLevel == 0)
      return {
        '0-0': [-180, -90, 180, 90]
      };
    double startX = -180.0;
    double startY = 90.0;
    int width = 360;
    int height = 180;
    var tileCountAlongXOrY = sqrt(tileCountInZoomLevel()).toInt();
    var incrementByAlongX = width / tileCountAlongXOrY;
    var decrementByAlongY = height / tileCountAlongXOrY;
    var tiles = <String, List<double>>{};
    for (var i = 0; i < tileCountAlongXOrY; i++) {
      tiles.addAll(_generateTilesAlongX(startX, startY, i, tileCountAlongXOrY,
          incrementByAlongX, decrementByAlongY));
      startY -= decrementByAlongY;
    }
    return tiles;
  }

  /// Generates all the tiles along X axis, provided start point along X and Y supplied
  /// Call this method iteratively by incrementing value of yIndex, to generate all tiles, covering world
  /// Tiles are returned in form of Map<String, List<double>>
  /// Keys of Map, used as tile identifier
  Map<String, List<double>> _generateTilesAlongX(
      double startAtX,
      double startAtY,
      int yIndex,
      int tileCountAlongX,
      double incrementByAlongX,
      double decrementByAlongY) {
    var tmp = <String, List<double>>{};
    for (var i = 0; i < tileCountAlongX; i++) {
      tmp['$i-$yIndex'] = [
        startAtX,
        startAtY - decrementByAlongY,
        startAtX += incrementByAlongX,
        startAtY
      ];
    }
    return tmp;
  }
}
