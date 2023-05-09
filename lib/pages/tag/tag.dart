import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/components/empty_view.dart';
import 'package:youcomic/components/filter/book_fliter_drawer.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/pages/tag/menu.dart';
import 'package:youcomic/pages/tag/provider.dart';

import '../../components/books_view.dart';

class TagPage extends StatelessWidget {
  final TagEntity tagEntity;

  TagPage({required this.tagEntity});

  static launch(BuildContext context, TagEntity tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TagPage(
                tagEntity: tag,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TagProvider>(
      create: (_) => TagProvider(tag: tagEntity),
      child: Consumer<TagProvider>(builder: (context, tagProvider, builder) {
        tagProvider.onLoad();
        tagProvider.checkIsSubscribe();
        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if (maxScroll == pixel) {
            tagProvider.loadMoreBooks();
          } else {}
        });
        Future _pullToRefresh() async {
          await tagProvider.onLoad(force: true);
        }

        Widget renderContent() {
          return RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: BooksView(
              books: tagProvider.bookDataSource.books,
              viewMode: tagProvider.viewMode,
              controller: _controller,
            ),
          );
        }

        Widget emptyView = EmptyView(
          isLoading: tagProvider.bookDataSource.isLoading,
          icon: Icon(
            Icons.bookmark_rounded,
            size: 96,
          ),
          text: "暂时没有订阅的标签",
          onRefresh: () {
            tagProvider.bookDataSource.loadBooks(true);
          },
        );
        getActionMenu() {
          if (ApplicationConfig().useNanoMode) {
            return [];
          }
          return renderAction(tagProvider);
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(Icons.filter_list_alt));
              }),
              ...getActionMenu()
            ],
            title: Text(
              tagProvider.title,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          endDrawer: Drawer(
            child: Builder(builder: (context) {
              return BookFilterDrawer(
                onClose: () {
                  Navigator.pop(context);
                },
                onOrderUpdate: tagProvider.bookFilter.updateOrderFilter,
                activeOrders: tagProvider.bookFilter.orderFilter,
                onCustomTimeRangeChange:
                    tagProvider.bookFilter.updateCustomDateRange,
                customTimeRange: tagProvider.bookFilter.customDateRange,
                onTimeRangeChange: tagProvider.bookFilter.onTimeRangeChange,
                onClearCustomTimeRange: tagProvider.bookFilter.onClearTimeRange,
                timeRangeSelectMode: tagProvider.bookFilter.timeRangeSelect,
                onPageRangeChange: tagProvider.bookFilter.updatePageRange,
                pageRangeSelectId: tagProvider.bookFilter.pageRangeItem.id,
              );
            }),
          ),
          body: tagProvider.bookDataSource.books.isEmpty
              ? emptyView
              : renderContent(),
        );
      }),
    );
  }
}
