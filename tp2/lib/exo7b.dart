import 'dart:io';

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
  late int initialIndex;
  Alignment alignment;

  Tile(this.index, this.image, this.size, this.alignment) {
    initialIndex = index;
  }

  static Alignment genAlignment(int index, int size) {
    return Alignment(
      (2 * (index % size) / (size - 1) - 1).toDouble(),
      (2 * (index ~/ size) / (size - 1) - 1).toDouble(),
    );
  }

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

  Widget coloredBox() {
    return Container(
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(70.0),
        ));
  }
}

// ==============
// Widgets
// ==============

class TileWidget extends StatelessWidget {
  final Tile tile;

  const TileWidget(this.tile, {super.key});

  @override
  Widget build(BuildContext context) {
    if (tile.alignment == const Alignment(-1, -1)) {
      return tile.coloredBox();
    } else {
      return tile.croppedImageTile();
    }
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
  bool shuffled = false;

  late List<Tile> tiles = List<Tile>.generate(size * size,
      (index) => Tile(index, image, size, Tile.genAlignment(index, size)));

  int emptySlotIndex = 0;

  @override
  Widget build(BuildContext context) {
    size = ModalRoute.of(context)!.settings.arguments as int;
    if (!shuffled) {
      shuffle();
      shuffled = true;
    }
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
                          if (checkWin()) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Vous avez gagné !'),
                                content: const Text(
                                    'Vous avez complété ce taquin ! Bravo l\'ami !'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      shuffled = false;
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Recommencer'),
                                  ),
                                ],
                              ),
                            );
                          }
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
    if (index + size == emptySlotIndex && index >= 0) {
      //check tile bellow
      return true;
    }
    if (index - size == emptySlotIndex && index < size * size) {
      //check tile above
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

  shuffle() {
    for (int i = 0; i < size * 10; i++) {
      int direction = random.nextInt(4);
      int newIndex;
      switch (direction) {
        case 0:
          newIndex = tiles[emptySlotIndex].index - 1;
          break;
        case 1:
          newIndex = tiles[emptySlotIndex].index + 1;
          break;
        case 2:
          newIndex = tiles[emptySlotIndex].index - size;
          break;
        case 3:
          newIndex = tiles[emptySlotIndex].index + size;
          break;
        default:
          newIndex = 0;
          break;
      }
      print("going to index $newIndex");
      if (checkRules(newIndex)) {
        swapTiles(newIndex);
      }
    }
  }

  checkWin() {
    for (int i = 0; i < size * size; i++) {
      if (tiles[i].initialIndex != i) {
        return false;
      }
    }
    return true;
  }
}
