import 'package:osm_tile_fetcher/main.dart'
    show TileFetcher, TileGenerator, BoundingBox;
import 'dart:math';

main() {
  //var rect1 = Rectangle(-180, 90, 360, 180);
  //print(rect1.containsRectangle(Rectangle(0, 90, 180, 90)));
  var tileGenerator = TileGenerator(1);
  // print(tileGenerator.tileCountInZoomLevel());
  //tileGenerator.tilesWithOutExtent().forEach((String elem) => print(elem));
  tileGenerator.tilesWithExtent().map((key, bounds) {
    if (BoundingBox(-180, -90, 180, 90).shouldFetchTile(
        BoundingBox(bounds[0], bounds[1], bounds[2], bounds[3])))
      return MapEntry(key, bounds);
  }).forEach((key, bounds) {
    print(bounds);
  });
  //var tileFetcher = TileFetcher(2, '.');
  //tileFetcher.urlGenerator().forEach((String url) => print(url));
  /*tileFetcher.fetchTiles(BoundingBox(-180, -90, 180, 90)).listen(
        (data) => print(data),
        cancelOnError: true,
        onDone: () => print('Done'),
        onError: (e) => print('Error: $e'),
      );*/
}

double getDiff(double a, double b) {
  num res = a - b;
  return res < 0 ? -res : res;
}
