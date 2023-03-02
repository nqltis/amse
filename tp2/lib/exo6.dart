import 'package:flutter/material.dart';
import 'tilemodel.dart' as tilemodel;

class Tile {
  Image image;
  Alignment alignment;

  Tile({required this.image, required this.alignment});

  Widget croppedImageTile(int size) {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: this.alignment,
            widthFactor: 1 / size,
            heightFactor: 1 / size,
            child: image,
          ),
        ),
      ),
    );
  }
}

Tile tile =
    Tile(image: Image.asset('images/image.jpg'), alignment: Alignment(1, 0));

class DisplayGridViewWidget extends StatefulWidget {
  @override
  _DisplayGridViewWidget createState() => _DisplayGridViewWidget();
}

class _DisplayGridViewWidget extends State<DisplayGridViewWidget> {
  Image myImage = Image.asset('images/image.jpg');
  double _currentSliderValue = 5;

  List<Widget> getGridViewTiles(int size) {
    List<Widget> list = [];

    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        list.add(
          createTileWidgetFrom(Tile(
              image: myImage,
              alignment:
                  Alignment(2 * j / (size - 1) - 1, 2 * i / (size - 1) - 1))),
        );
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Display Image in a variable GridView'),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Container(
              width: 480.0,
              height: 480.0,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                crossAxisCount: _currentSliderValue.toInt(),
                children: getGridViewTiles(_currentSliderValue.toInt()),
              )),
          Container(
              width: 480,
              child: Slider(
                value: _currentSliderValue,
                min: 3,
                max: 8,
                divisions: 5,
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              )),
        ]));
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(_currentSliderValue.toInt()),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
}
