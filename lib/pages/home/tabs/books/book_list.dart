import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/components/books_view.dart';
import 'package:youcomic/components/filter/book_fliter_drawer.dart';
import 'package:youcomic/pages/home/tabs/books/provider.dart';

import '../../../../menu.dart';

class BookListPage extends StatelessWidget {
  final BookListProvider externalBookListProvider;

  BookListPage({required this.externalBookListProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListProvider>.value(
      value: externalBookListProvider,
      child: Consumer<BookListProvider>(
          builder: (context, bookListProvider, builder) {
        Future _pullToRefresh() async {
          await bookListProvider.loadBooks(true);
        }

        bookListProvider.loadBooks(false);

        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if ((maxScroll - pixel) < 20) {
            bookListProvider.loadMore();
          } else {}
        });
        Widget renderContent() {
          return BooksView(
              books: bookListProvider.dataSource.books,
              viewMode: bookListProvider.viewMode,
              itemWidth: bookListProvider.gridWidth,
              controller: _controller);
        }

        return Scaffold(
            appBar: renderAppBar(context, actions: [
              IconButton(onPressed: (){
                Scaffold.of(context).openEndDrawer();
              }, icon: Icon(Icons.filter_alt)),
              PopupMenuButton(
                icon: Icon(Icons.more_vert_rounded),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Text("List"),
                      value: "List",
                    ),
                    PopupMenuItem(
                      child: Text("Large Grid"),
                      value: "LargeGrid",
                    ),
                    PopupMenuItem(
                      child: Text("Medium Grid"),
                      value: "MediumGrid",
                    ),
                    PopupMenuItem(
                      child: Text("Small Grid"),
                      value: "SmallGrid",
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case "List":
                      bookListProvider.changeViewMode("List");
                      break;
                    case "LargeGrid":
                      bookListProvider.changeViewMode("Grid");
                      bookListProvider.changeGridSize("Large");
                      break;
                    case "MediumGrid":
                      bookListProvider.changeViewMode("Grid");
                      bookListProvider.changeGridSize("Medium");
                      break;
                    case "SmallGrid":
                      bookListProvider.changeViewMode("Grid");
                      bookListProvider.changeGridSize("Small");
                      break;
                  }
                },
              ),
            ]),
            body: RefreshIndicator(
              onRefresh: _pullToRefresh,
              child: renderContent(),
            ),
            drawer: BookFilterDrawer(
              onClose: bookListProvider.switchFilterDrawer,
              onOrderUpdate: bookListProvider.bookFilter.updateOrderFilter,
              activeOrders: bookListProvider.bookFilter.orderFilter,
              onCustomTimeRangeChange: bookListProvider.bookFilter.updateCustomDateRange,
              customTimeRange: bookListProvider.bookFilter.customDateRange,
              onTimeRangeChange: bookListProvider.bookFilter.onTimeRangeChange,
              onClearCustomTimeRange: bookListProvider.bookFilter.onClearTimeRange,
              timeRangeSelectMode: bookListProvider.bookFilter.timeRangeSelect,
              onPageRangeChange: bookListProvider.bookFilter.updatePageRange,
              pageRangeSelectId: bookListProvider.bookFilter.pageRangeItem.id,
            ));
      }),
    );
  }
}
