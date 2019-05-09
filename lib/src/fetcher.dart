import 'dart:math' show Rectangle;
import 'generator.dart';

class TileFetcher {
  /// current zoom level, for which tiles to be fetched
  int zoomLevel;

  /// Helps in fetching tiles for a certain zoom level
  TileFetcher(this.zoomLevel);

  fetchTiles({String targetURL = ''}) {}
}
