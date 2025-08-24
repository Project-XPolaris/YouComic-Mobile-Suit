import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/components/empty_view.dart';
import 'package:youcomic/components/books_view.dart';
import 'package:youcomic/pages/history/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage() : super();
  static launch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryProvider>(
      create: (_) => HistoryProvider(),
      child:
          Consumer<HistoryProvider>(builder: (rootContext, provider, builder) {
        provider.onLoad();
        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if (maxScroll == pixel) {
            provider.onLoadMore();
          }
        });
        _pullToRefresh() async {
          await provider.onForceReload();
        }

        final List<BookEntity> books = provider.dataSource.data
            .map((e) => e.book)
            .whereType<BookEntity>()
            .toList();

        Widget listView = BooksView(
          books: books,
          viewMode: provider.viewMode,
          controller: _controller,
          itemWidth: provider.gridWidth,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "浏览历史",
            ),
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.more_vert_rounded),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    child: Text("List"),
                    value: "List",
                  ),
                  PopupMenuItem<String>(
                    child: Text("Large Grid"),
                    value: "LargeGrid",
                  ),
                  PopupMenuItem<String>(
                    child: Text("Medium Grid"),
                    value: "MediumGrid",
                  ),
                  PopupMenuItem<String>(
                    child: Text("Small Grid"),
                    value: "SmallGrid",
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case "List":
                      provider.changeViewMode("List");
                      break;
                    case "LargeGrid":
                      provider.changeViewMode("Grid");
                      provider.changeGridSize("Large");
                      break;
                    case "MediumGrid":
                      provider.changeViewMode("Grid");
                      provider.changeGridSize("Medium");
                      break;
                    case "SmallGrid":
                      provider.changeViewMode("Grid");
                      provider.changeGridSize("Small");
                      break;
                  }
                },
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: provider.dataSource.data.isEmpty
                ? EmptyView(
                    isLoading: provider.isLoading,
                    icon: Icon(
                      Icons.history_rounded,
                      size: 96,
                    ),
                    text: "没有历史记录",
                    onRefresh: () {
                      provider.onForceReload();
                    },
                  )
                : listView,
          ),
        );
      }),
    );
  }
}
