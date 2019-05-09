// import 'dart:math' show Rectangle;
import 'generator.dart';
import 'dart:io';
import 'dart:async' show Completer;
import 'package:path/path.dart' show join;

class TileFetcher {
  /// current zoom level, for which tiles to be fetched
  int zoomLevel;

  /// Target directory path, where to store fetched tiles
  /// This one is done for local caching purpose
  String targetPath;

  /// Helps in fetching tiles for a certain zoom level
  TileFetcher(this.zoomLevel, this.targetPath);

  /// actual tile fetcher, for a certain zoom level fetches all tiles and stores them in targetDir, for caching purpose
  fetchTiles({String baseURL = 'https://tile.openstreetmap.org/'}) =>
      TileGenerator(zoomLevel).tilesWithOutExtent().forEach((tileId) =>
          _tileFetcher(
              '$baseURL/$zoomLevel/${tileId.split('-').join('/')}.png',
              join(targetPath,
                  '${zoomLevel}_${tileId.split('-').join('_')}.png')));

  /// generates target URLs only, for a certain zoom level
  List<String> urlGenerator(
          {String baseURL = 'https://tile.openstreetmap.org'}) =>
      TileGenerator(zoomLevel).tilesWithOutExtent().map((String tileId) =>
          '$baseURL/$zoomLevel/${tileId.split('-').join('/')}');

  /// fetches a tile from OSM and then stores in target file, when completes returns status of operation by a boolean value
  /// true --> success
  /// false --> failure
  Future<bool> _tileFetcher(String targetURL, String targetFile) {
    var completer = Completer<bool>();
    HttpClient()
        .getUrl(Uri.parse(targetURL))
        .then(
          (HttpClientRequest req) => req.close(),
          onError: (e) => completer.complete(false),
        )
        .then(
          (HttpClientResponse resp) => File(targetFile)
              .openWrite(mode: FileMode.write)
              .addStream(resp)
              .then(
                (val) => completer.complete(true),
                onError: (e) => completer.complete(false),
              ),
          onError: (e) => completer.complete(false),
        );
    return completer.future;
  }
}
