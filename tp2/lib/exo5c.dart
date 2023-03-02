import 'package:flutter/material.dart';

class Tile {
  Image image;
  Alignment alignment;

  Tile({required this.image, required this.alignment});

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: this.alignment,
            widthFactor: 0.3,
            heightFactor: 0.3,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Image in a GridView'),
        centerTitle: true,
      ),
      body: Center(
          child: Container(
              width: 480.0,
              height: 480.0,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: <Widget>[
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(-1, -1))),
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(0, -1))),
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(1, -1))),
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(-1, 0))),
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(0, 0))),
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(1, 0))),
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(-1, 1))),
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(0, 1))),
                  createTileWidgetFrom(
                      Tile(image: myImage, alignment: Alignment(1, 1))),
                ],
              ))),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
}
