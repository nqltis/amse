import 'package:flutter/material.dart';
import 'dart:math' as math;

// ==============
// Models
// ==============

math.Random random = math.Random();

class Tile {
  Image image;
  int index;
  int size;
  late Alignment alignment = Alignment(
    (2 * (index % size) / (size - 1) - 1).toDouble(),
    (2 * (index ~/ size) / (size - 1) - 1).toDouble(),
  );

  Tile(this.index, this.image, this.size);

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment,
          widthFactor: 1 / size,
          heightFactor: 1 / size,
          child: image,
        ),
      ),
    );
  }
}

// ==============
// Widgets
// ==============

class TileWidget extends StatelessWidget {
  final Tile tile;

  TileWidget(this.tile);

  @override
  Widget build(BuildContext context) {
    return tile.croppedImageTile();
  }
}

class PositionedTiles extends StatefulWidget {
  const PositionedTiles({super.key});
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  late int size;
  Image image = Image.asset('images/image.jpg');

  late List<Tile> tiles =
      List<Tile>.generate(size * size, (index) => Tile(index, image, size));

  int emptySlotIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("Building widget");
    size = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moving Tiles'),
        centerTitle: true,
      ),
      body: Container(
          width: 480.0,
          height: 480.0,
          child: GridView.count(
            primary: true,
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: size,
            //crossAxisCount: _currentSliderValue.toInt(),
            children: [
              ...tiles
                  .map(
                    (element) => InkWell(
                      child: TileWidget(element),
                      onTap: () {
                        if (checkRules(element.index)) {
                          setState(() {
                            swapTiles(element.index);
                          });
                        }
                      },
                    ),
                  )
                  .toList(),
            ],
          )),
    );
  }

  swapTiles(int index) {
    setState(() {
      //Swap index attribute of tiles
      tiles[index].index = emptySlotIndex;
      tiles[emptySlotIndex].index = index;
      //Swap Tiles in Tile List
      Tile shadow = tiles.elementAt(index);
      tiles[index] = tiles[emptySlotIndex];
      tiles[emptySlotIndex] = shadow;
      //Set new empty slot
      emptySlotIndex = index;
    });
  }

  checkRules(int index) {
    if (index + size == emptySlotIndex || index - size == emptySlotIndex) {
      //check tiles above and bellow
      return true;
    }
    if (index == emptySlotIndex + 1 && emptySlotIndex % size != size - 1) {
      //check right tile
      return true;
    }
    if (index == emptySlotIndex - 1 && emptySlotIndex % size != 0) {
      //check left tile
      return true;
    }
    return false;
  }
}
