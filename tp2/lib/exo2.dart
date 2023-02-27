import 'package:flutter/material.dart';
// import 'package:Taquin/util.dart';
import 'dart:math';

class DisplayImageWidget extends StatefulWidget {
  @override
  _DisplayImageWidget createState() => _DisplayImageWidget();
}

class _DisplayImageWidget extends State<DisplayImageWidget> {
  double _currentXSliderValue = 0;
  double _currentYSliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Display image'),
        ),
        // body: Center(child: Image.network("https://picsum.photos/1024")));
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('RotateX:'),
                  Slider(
                    value: _currentXSliderValue,
                    max: 2 * pi,
                    onChanged: (double value) {
                      setState(() {
                        _currentXSliderValue = value;
                      });
                    },
                  ),
                  const Text('RotateY:'),
                  Slider(
                    value: _currentYSliderValue,
                    max: 2 * pi,
                    onChanged: (double value) {
                      setState(() {
                        _currentYSliderValue = value;
                      });
                    },
                  ),
                ],
              )
            ]));
  }
}
