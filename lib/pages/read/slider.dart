import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youcomic/api/model/page.dart';

class PageJumpSlider extends StatefulWidget {
  final Function(double)? onValueSubmit;
  final int count;
  final double initValue;
  final List<PageEntity> pages;

  PageJumpSlider(
      {Key? key, this.onValueSubmit, required this.count, required this.initValue,required this.pages})
      : super(key: key);

  @override
  PageJumpSliderState createState() =>
      PageJumpSliderState(currentValue: initValue);
}

class PageJumpSliderState extends State<PageJumpSlider> {
  double currentValue;

  PageJumpSliderState({this.currentValue = 1});

  onSliderValueChange(double newValue) {
    setState(() {
      currentValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentPath = this.widget.pages[currentValue.toInt() - 1].path;
    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 270,
              width: 200,
              child: Center(
                child: currentPath != null ? CachedNetworkImage(
                  imageUrl: currentPath,
                  progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                ):Container(
                  height: 270,
                  width: 200,
                ),
              ),
            ),
            Container(
              height: 270,
              width: 90,
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 30,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: RotatedBox(
                              quarterTurns: 1,
                              child: Slider(
                                value: currentValue,
                                max: this.widget.count.toDouble(),
                                min: 1,
                                onChanged: onSliderValueChange,
                                onChangeEnd: this.widget.onValueSubmit,
                              )),
                        ),
                        Divider(
                          height: 0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Center(
                              child: Text(currentValue.round().toString()),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ));
  }
}
