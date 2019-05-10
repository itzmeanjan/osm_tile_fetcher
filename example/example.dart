import 'package:osm_tile_fetcher/main.dart' show TileFetcher, TileGenerator;

main() {
  //var tileGenerator = TileGenerator(1);
  // print(tileGenerator.tileCountInZoomLevel());
  //tileGenerator.tilesWithOutExtent().forEach((String elem) => print(elem));
  /*tileGenerator
      .tilesWithExtent()
      .forEach((String key, List<double> value) => print('$key -- $value'));*/
  var tileFetcher = TileFetcher(1, '.');
  //tileFetcher.urlGenerator().forEach((String url) => print(url));
  tileFetcher.fetchTiles().listen(
        (data) => print(data),
        cancelOnError: true,
        onDone: () => print('Done'),
        onError: (e) => print('Error: $e'),
      );
}
