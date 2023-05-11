import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/pages/read/page.dart';
import 'package:youcomic/pages/read/slider.dart';
import 'package:youcomic/pages/read/status_provider.dart';
import 'package:youcomic/pages/read/provider.dart';

class ReadPage extends StatefulWidget {
  final int bookId;
  final String title;

  ReadPage({required this.bookId, required this.title});

  static launch(BuildContext context, int id, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReadPage(
                bookId: id,
                title: title,
              )),
    );
  }

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  bool isShowAppBar = true;
  ScrollController _controller = new ScrollController();
  double sidePadding = 120;
  double? pageSliderVal;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ReadProvider(id: widget.bookId),
        ),
        ChangeNotifierProvider<ReadStatusProvider>(
          create: (_) => ReadStatusProvider(bookId: widget.bookId),
        ),
      ],
      child: Consumer<ReadProvider>(builder: (context, readProvider, builder) {
        GlobalKey<PageJumpSliderState> sliderKey = new GlobalKey();
        readProvider.loadPage();
        List<double> _buildPageStartMapping() {
          if (readProvider.dataSource.pages.length == 0) {
            return [];
          }
          final size = MediaQuery.of(context).size;
          var offset = 0.0;
          final List<double> mapping = [];
          for (var idx = 0; idx < readProvider.dataSource.pages.length; idx++) {
            var pageEntity = readProvider.dataSource.pages[idx];
            mapping.add(offset);
            offset += (pageEntity.aspectRatio * size.width) -
                (sidePadding * 2 * pageEntity.aspectRatio);
          }
          return mapping;
        }

        final Map<int, GlobalKey> pageKeyMapping = {};
        buildPages() {
          final List<Widget> pages = [];
          final size = MediaQuery.of(context).size;
          for (var idx = 0; idx < readProvider.dataSource.pages.length; idx++) {
            final pageKey = GlobalKey();
            final pageEntity = readProvider.dataSource.pages[idx];
            pages.add(Container(
                key: pageKey,
                padding: EdgeInsets.only(
                    bottom: 16, left: sidePadding, right: sidePadding),
                child: ImagePage(
                  page: pageEntity,
                  height: (pageEntity.aspectRatio * size.width) -
                      (sidePadding * 2 * pageEntity.aspectRatio),
                )));
            pageKeyMapping[idx] = pageKey;
            readProvider.loadedPage.add(idx);
          }
          return pages;
        }

        _controller.addListener(() {
          // hide app bar
          if (isShowAppBar) {
            setState(() {
              isShowAppBar = false;
            });
          }
          final maxScroll = _controller.position.maxScrollExtent;
          final pixel = _controller.offset;
          final pageStartMapping = _buildPageStartMapping();
          var pos = pageStartMapping
              .indexWhere((offset) => offset > _controller.position.pixels);
          if (pos == -1) {
            pos = pageStartMapping.length;
          }
          ReadStatusProvider provider =
              Provider.of<ReadStatusProvider>(context, listen: false);
          if (pos != provider.currentDisplayPage) {
            provider.updateCurrentDisplayPage(pos);
            provider.saveReadProgress(pos);
          }
          var sliderState = sliderKey.currentState;
          if (sliderState != null) {
            sliderState.onSliderValueChange(pos.toDouble());
          }
          if (maxScroll == pixel) {
          } else {}
        });
        return Scaffold(
          appBar: this.isShowAppBar
              ? AppBar(
                  title: Text(widget.title),
                  backgroundColor: Colors.black.withAlpha(200),
                )
              : null,
          extendBodyBehindAppBar: true,
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: _controller,
                child: Column(
                  children: [
                    ...buildPages(),
                    Builder(builder: (context) {
                      if (readProvider.hasJumpToPage &&
                          readProvider.historyEntity != null &&
                          readProvider.historyEntity!.pagePos > 0) {
                        final pageStartMapping = _buildPageStartMapping();
                        _controller.animateTo(
                            pageStartMapping[
                                readProvider.historyEntity!.pagePos - 1],
                            duration: Duration(milliseconds: 1),
                            curve: Curves.fastOutSlowIn);
                        readProvider.hasJumpToPage = false;
                      }
                      return Container();
                    })
                  ],
                ),
              ),
              !isShowAppBar
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Consumer<ReadStatusProvider>(
                          builder: (context, readStatusProvider, builder) {
                        return Container(
                            color: Colors.black87,
                            child: GestureDetector(
                              onLongPress: () {
                                HapticFeedback.vibrate();
                                showGeneralDialog(
                                    context: context,
                                    barrierColor: Colors.black54,
                                    pageBuilder: (context, anim1, anim2) {
                                      return Container();
                                    },
                                    barrierLabel: '',
                                    barrierDismissible: true,
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                    transitionBuilder:
                                        (context, anim1, anim2, child) {
                                      final curvedValue =
                                          Curves.ease.transform(anim1.value) -
                                              1.0;
                                      return Transform(
                                        transform: Matrix4.translationValues(
                                            -curvedValue * 200, 0.0, 0.0),
                                        child: PageJumpSlider(
                                          key: sliderKey,
                                          pages: readProvider.dataSource.pages,
                                          initValue: readStatusProvider
                                              .currentDisplayPage
                                              .toDouble(),
                                          count: readProvider.dataSource.count,
                                          onValueSubmit: (double to) {
                                            final pageStartMapping =
                                                _buildPageStartMapping();
                                            _controller.animateTo(
                                                pageStartMapping[
                                                    to.toInt() - 1],
                                                duration: Duration(seconds: 1),
                                                curve: Curves.fastOutSlowIn);
                                            readStatusProvider
                                                .switchPageJumper();
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    });
                              },
                              onTap: () {
                                setState(() {
                                  this.isShowAppBar = true;
                                });
                              },
                              child: SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 2, left: 16, right: 16, bottom: 2),
                                  child: Text(
                                    "第${readStatusProvider.currentDisplayPage}页,共${readProvider.dataSource.count}页",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ));
                      }))
                  : Container(),
            ],
          ),
          extendBody: true,
          bottomNavigationBar: this.isShowAppBar
              ? Consumer<ReadStatusProvider>(
                  builder: (context, readStatusProvider, builder) {
                  return (Container(
                      height: 64,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      color: Colors.black.withAlpha(200),
                      child: Row(
                        children: [
                          Container(
                            height: 64,
                            child: Row(
                              children: [
                                Icon(Icons.width_normal),
                                Container(
                                  width: 160,
                                  child: Slider(
                                      max: 0.6,
                                      value: sidePadding /
                                          (MediaQuery.of(context).size.width -
                                              300),
                                      onChanged: (val) {
                                        setState(() {
                                          sidePadding = (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  300) *
                                              val;
                                        });
                                      }),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Slider(
                                min: 1,
                                max: readProvider.dataSource.count.toDouble() == 0? 2 : readProvider.dataSource.count.toDouble(),
                                divisions: readProvider.dataSource.count == 0? 1 : readProvider.dataSource.count,
                                value: pageSliderVal != null
                                    ? pageSliderVal ?? 0
                                    : readStatusProvider.currentDisplayPage
                                        .toDouble(),
                                onChanged: (val) {
                                  setState(() {
                                    pageSliderVal = val;
                                  });
                                },
                                onChangeEnd: (val) {
                                  final pageStartMapping =
                                      _buildPageStartMapping();
                                  _controller.animateTo(
                                      pageStartMapping[
                                          (val.round() - 1).toInt()],
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.fastOutSlowIn);
                                  setState(() {
                                    pageSliderVal = null;
                                  });
                                },
                                label:
                                    "${pageSliderVal != null ? pageSliderVal!.round().toString() : readStatusProvider.currentDisplayPage.toString()}页",
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                                "第${readStatusProvider.currentDisplayPage}页,共${readProvider.dataSource.count}页 ${(readStatusProvider.currentDisplayPage / readProvider.dataSource.count * 100).toStringAsFixed(0)}%"),
                          )
                        ],
                      )));
                })
              : null,
        );
      }),
    );
  }
}
