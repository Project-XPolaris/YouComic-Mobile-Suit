import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/pages/read/page.dart';
import 'package:youcomic/pages/read/slider.dart';
import 'package:youcomic/pages/read/status_provider.dart';
import 'package:youcomic/pages/read/provider.dart';
import 'package:youcomic/pages/tag/color.dart';

class ReadPage extends StatefulWidget {
  final int bookId;

  ReadPage({required this.bookId});

  static launch(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReadPage(bookId: id)),
    );
  }

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  bool isShowAppBar = true;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ReadProvider(id: widget.bookId),
        ),
        ChangeNotifierProvider<ReadStatusProvider>(
          create: (_) => ReadStatusProvider(),
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
            offset +=
                (pageEntity.height / pageEntity.width) * size.width + 16.0;
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
                padding: EdgeInsets.only(top: 16),
                child: ImagePage(
                  page: pageEntity,
                  height: ((pageEntity.height / pageEntity.width) * size.width),
                  width: size.width,
                )));
            pageKeyMapping[idx] = pageKey;
            readProvider.loadedPage.add(idx);
          }
          print("render ${pages.length} pages");
          return pages;
        }

        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          // hide app bar
          if (_controller.position.userScrollDirection ==
                  ScrollDirection.reverse &&
              isShowAppBar) {
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
          Provider.of<ReadStatusProvider>(context, listen: false)
              .updateCurrentDisplayPage(pos);
          var sliderState = sliderKey.currentState;
          if (sliderState != null) {
            sliderState.onSliderValueChange(pos.toDouble());
          }
          if (maxScroll == pixel) {
          } else {}
        });
        return Scaffold(
          appBar: this.isShowAppBar ? AppBar() : null,
          extendBodyBehindAppBar: true,
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: _controller,
                child: Column(
                  children: buildPages(),
                ),
              ),
              Align(
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
                                transitionDuration: Duration(milliseconds: 300),
                                transitionBuilder:
                                    (context, anim1, anim2, child) {
                                  final curvedValue =
                                      Curves.ease.transform(anim1.value) - 1.0;
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
                                            pageStartMapping[to.toInt() - 1],
                                            duration: Duration(seconds: 1),
                                            curve: Curves.fastOutSlowIn);
                                        readStatusProvider.switchPageJumper();
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
                  })),
            ],
          ),
        );
      }),
    );
  }
}
