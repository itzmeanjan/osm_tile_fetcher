import 'package:osm_tile_fetcher/main.dart'
    show TileFetcher, TileGenerator, BoundingBox;

main() {
  /*var tileGenerator = TileGenerator(2);
  tileGenerator.tilesWithExtent()
    ..removeWhere((key, val) => !BoundingBox(-180, 0, 0, 90)
        .shouldFetchTile(BoundingBox(val[0], val[1], val[2], val[3])))
    ..forEach((key, val) {
      print('$key - $val');
    });*/
  var tileFetcher = TileFetcher(2, '.');
  //tileFetcher.urlGenerator().forEach((String url) => print(url));
  tileFetcher.fetchTiles(BoundingBox(-180, 0, 0, 90)).listen(
        (data) => print(data),
        cancelOnError: true,
        onDone: () => print('Done'),
        onError: (e) => print('Error: $e'),
      );
}

double getDiff(double a, double b) {
  num res = a - b;
  return res < 0 ? -res : res;
}
