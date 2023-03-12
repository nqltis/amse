import 'package:flutter/material.dart';
import 'dart:math' as math;

// ==============
// Models
// ==============

math.Random random = math.Random();

class Tile {
  Color color = const Color.fromARGB(255, 0, 0, 255);

  Tile(this.color);
  Tile.randomColor() {
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
  List<Widget> tiles =
      List<Widget>.generate(9, (index) => TileWidget(Tile.randomColor()));

  int emptySlotIndex = 0;
  int tile2SwapIndex = 1;

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
                    (e) => InkWell(
                        child: e,
                        onTap: () {
                          setState(() {
                            swapTiles();
                          });
                        }),
                  )
                  .toList(),
            ],
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: swapTiles,
          child: const Icon(Icons.sentiment_very_satisfied)),
    );
  }

  swapTiles() {
    setState(() {
      tiles.insert(tile2SwapIndex, tiles.removeAt(emptySlotIndex));
    });
  }
}
