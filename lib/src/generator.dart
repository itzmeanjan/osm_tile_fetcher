import 'dart:math' show pow, sqrt;

class TileGenerator {
  int zoomLevel;

  /// Helps us to generate Tiles, zoom level to be considered needs to be provided during invokation of methods
  TileGenerator(this.zoomLevel);

  /// Gives number of tiles to be present in a certain zoom level
  int tileCountInZoomLevel() => pow(2 * 2, zoomLevel) as int;

  /// Generates only tile identifiers without extent value
  /// Simply a List<String> is returned, where each entry of List is a String, identifies a certain tile
  List<String> tilesWithOutExtent() {
    if (zoomLevel == 0) return ['0_0'];
    var tileCountAlongXOrY = sqrt(tileCountInZoomLevel()).toInt();
    var tiles = <String>[];
    for (var y = 0; y < tileCountAlongXOrY; y++)
      for (var x = 0; x < tileCountAlongXOrY; x++) tiles.add('${x}_$y');
    return tiles;
  }

  /// This is the method that you might be actually interested in using mostly
  /// Generates all the tiles along with their corresponding extents, which can be present in a certain zoom level
  /// Returns value in form of Map<String, List<double>>
  /// Keys of Map, used as tile identifier
  /// May be you'll be breaking a key using 'x-y'.split('-'), to get tileIdX and tileIdY in List<String> form.
  Map<String, List<double>> tilesWithExtent() {
    if (zoomLevel == 0)
      return {
        '0_0': [-180, -90, 180, 90]
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
      tmp['${i}_$yIndex'] = [
        startAtX,
        startAtY - decrementByAlongY,
        startAtX += incrementByAlongX,
        startAtY
      ];
    }
    return tmp;
  }
}
