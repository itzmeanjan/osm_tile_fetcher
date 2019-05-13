# osm_tile_fetcher
A Dart Implementation of Open Street Map Tile Fetcher.

## purpose
This *Dart* package can be used for fetching tiles from Open Street Map Tile Server. You can select a certain area on Earth Surface and it fetches only those tiles required to cover that area.

It's *lazy* by default. And by *lazy*, I mean if you ask it fetch tiles for a certain zoom level and it finds those tiles are already present in certain directory, it won't simply fetch those files. 

You can override this nature by setting *lazy* to *false*, while invoking tile fetcher method.

It also provides you a tile generation functionality, which will generate tiles for a certain zoom level. Tiles are identified by a tileId, which is composed of three elements.

- Zoom Level
- Row number in which Tile resides
- Column number in which Tile resides

Above three elements are seperated by *underscore ( _ )*, and identifies a certain tile for a certain zoom level.

Tile generator can also give bound of certain tile i.e. the area which a certain tile covers.

Now let's use it.

## usage
Lets say you want to generate all tiles for zoom level **2**. This is how you can do so.

```dart
var tileGenerator = TileGenerator(2);
```
Gives you a list of tile identifiers.

```dart
tileGenerator.tilesWithOutExtent().forEach((tileId) => print(tileId));
```

If you want to get bounds of tiles too, try this one.

```dart
tileGenerator.tilesWithExtent().forEach((tileId, bounds) =>
    print('$tileId - $bounds'));
```

You may also query number of tiles required for a certain zoom level.

```dart
tileGenerator.tileCountInZoomLevel();
```
You'll be most likely using *TileFetcher*. 

Let's fetch tiles for zoom level **2** and store them is current working directory.

```dart
var tileFetcher = TileFetcher(2, '.');
```
This API leverages power of Asynchronous Programming with Dart using Stream<T> class.

So we'll fetch all tiles, which are required to cover **BoundingBox(-180, 0, 0, 90)**.

Calling *fetchTiles*, will give us a *Stream\<String>*, and we listen to it for data. As soon as a certain tile is fetched, we'll receive its identifier in response. And when all tiles are fetched, Stream will be closed.

```dart
tileFetcher.fetchTiles(BoundingBox(-180, 0, 0, 90)).listen(
        (data) => print(data),
        cancelOnError: true,
        onDone: () => print('Done'),
        onError: (e) => print('Error: $e'),
      );
```

By default, *fetchTiles* is lazy i.e. it won't fetch a tile if it finds that tile in target directory.

Override this nature by putting *lazy* false.

```dart
tileFetcher.fetchTiles(BoundingBox(-180, 0, 0, 90), lazy: false).listen(
        (data) => print(data),
        cancelOnError: true,
        onDone: () => print('Done'),
        onError: (e) => print('Error: $e'),
      );
```
You might be interested in not giving any bounds, just call *fetchTiles* with *null*, which will lead to fetching all tiles required for covering whole world for that certain zoom level.

Using this for higher zoom level, is not recommened.

```dart
tileFetcher.fetchTiles(null).listen(
        (data) => print(data),
        cancelOnError: true,
        onDone: () => print('Done'),
        onError: (e) => print('Error: $e'),
      );
```

Always try fetching those tiles which are required for current viewport.

Sometimes, you may be interested in generating urls for a certain zoom level.

```dart
tileFetcher
      .urlGenerator(BoundingBox(-180, -90, 0, 0))
      .forEach((String url) => print(url));
```

If you don't want to cover any certain region i.e. cover whole Earth surface, just pass null, while invoking *urlGenerator*.

Above method gives you a list of urls, no usage of Stream\<T> here.

And last but not least, we've also a BoundingBox class, represent a certain area on surface of Earth, by using 

- minLongitude
- minLatitude
- maxLongitude
- maxLatitude

It has a useful method, *shouldFetchTile*, helps you in taking decision whether you should fetch a tile or not. 
Tries to determine whether two bounding boxes are intersecting or not/ is second bounding box is contained with in first one or not.

```dart
BoundingBox(-180, -90, 180, 90)
        .shouldFetchTile(BoundingBox(-180, -90, 0, 0);
```

## end
Well that's it. Hope it helps :)