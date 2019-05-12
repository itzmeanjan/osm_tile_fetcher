import 'bounding_box.dart';
import 'generator.dart';
import 'dart:io';
import 'dart:async' show Completer, StreamController;
import 'package:path/path.dart' show join;

class TileFetcher {
  /// current zoom level, for which tiles to be fetched
  int zoomLevel;

  /// Target directory path, where to store fetched tiles
  /// This one is done for local caching purpose
  String targetPath;

  /// Helps in fetching tiles for a certain zoom level
  TileFetcher(this.zoomLevel, this.targetPath);

  /// Tile fetcher, for a certain zoom level fetches all tiles and stores them in targetDir, for caching purpose
  /// Works in a lazy fashion - if a certain tile is present in target directory and lazy is set to true, then it's not going to refetch that tile
  /// To override this behavior, make sure you set lazy to false, while invoking method
  Stream<String> fetchTiles(BoundingBox areaToConsider,
      {String baseURL = 'https://tile.openstreetmap.org/', bool lazy = true}) {
    StreamController streamController;
    int count = 0;

    /// closes stream of data
    close() {
      if (!streamController.isClosed) streamController.close();
    }

    /// initializes stream and sends success report back
    init() => areaToConsider != null
        ? TileGenerator(zoomLevel).tilesWithExtent().forEach(
            (tileId, bounds) {
              if (!areaToConsider.shouldFetchTile(
                  BoundingBox(bounds[0], bounds[1], bounds[2], bounds[3]))) {
                // this is where we perform the filtering of tiles
                // whether to fetch a tile or not, done here

                count += 1;
                if (count == TileGenerator(zoomLevel).tileCountInZoomLevel())
                  streamController.close();
                return;
              }
              // processing filtered tiles
              if (lazy) if (File(join(targetPath, '${zoomLevel}_$tileId.png'))
                  .existsSync()) {
                count += 1;
                if (!streamController.isClosed || !streamController.isPaused)
                  streamController.add('${zoomLevel}_$tileId');
                if (count == TileGenerator(zoomLevel).tileCountInZoomLevel())
                  streamController.close();
                return;
              }
              _tileFetcher(
                      '$baseURL/$zoomLevel/${tileId.split('_').join('/')}.png',
                      join(targetPath, '${zoomLevel}_$tileId.png'))
                  .then(
                (val) {
                  count += 1;
                  if (!streamController.isClosed || !streamController.isPaused)
                    streamController.add(val ? '${zoomLevel}_$tileId' : '');
                  if (count == TileGenerator(zoomLevel).tileCountInZoomLevel())
                    streamController.close();
                },
              );
            },
          )
        : TileGenerator(zoomLevel).tilesWithOutExtent().forEach(
            (tileId) {
              if (lazy) if (File(join(targetPath, '${zoomLevel}_$tileId.png'))
                  .existsSync()) {
                count += 1;
                if (!streamController.isClosed || !streamController.isPaused)
                  streamController.add('${zoomLevel}_$tileId');
                if (count == TileGenerator(zoomLevel).tileCountInZoomLevel())
                  streamController.close();
                return;
              }
              _tileFetcher(
                      '$baseURL/$zoomLevel/${tileId.split('_').join('/')}.png',
                      join(targetPath, '${zoomLevel}_$tileId.png'))
                  .then(
                (val) {
                  count += 1;
                  if (!streamController.isClosed || !streamController.isPaused)
                    streamController.add(val ? '${zoomLevel}_$tileId' : '');
                  if (count == TileGenerator(zoomLevel).tileCountInZoomLevel())
                    streamController.close();
                },
              );
            },
          );
    streamController = StreamController<String>(
      onCancel: close,
      onListen: init,
    );
    return streamController.stream;
  }

  /// generates target URLs only, for a certain zoom level
  List<String> urlGenerator(
          {String baseURL = 'https://tile.openstreetmap.org'}) =>
      TileGenerator(zoomLevel)
          .tilesWithOutExtent()
          .map((String tileId) =>
              '$baseURL/$zoomLevel/${tileId.split('_').join('/')}.png')
          .toList();

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
