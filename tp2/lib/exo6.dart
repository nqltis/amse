import 'package:flutter/material.dart';
import 'dart:math' as math;

// ==============
// Models
// ==============

math.Random random = math.Random();

class Tile {
  Color color = const Color.fromARGB(255, 0, 0, 255);
  int index = -1;

  Tile(this.index, this.color);
  Tile.randomColor(this.index) {
    color = Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
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
    return coloredBox();
  }

  Widget coloredBox() {
    return Container(
        color: tile.color,
        child: const Padding(
          padding: EdgeInsets.all(70.0),
        ));
  }
}

class PositionedTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  int size = 3;

  List<Tile> tiles = List<Tile>.generate(9, (index) => Tile.randomColor(index));

  int emptySlotIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moving Tiles'),
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
            crossAxisCount: 3,
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
