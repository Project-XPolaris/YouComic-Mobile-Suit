import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/history.dart';
import 'package:youcomic/components/book_item.dart';
import 'package:youcomic/components/empty_view.dart';
import 'package:youcomic/pages/history/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage() : super();
  static launch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HistoryPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryProvider>(
      create: (_) => HistoryProvider(),
      child: Consumer<HistoryProvider>(builder: (rootContext, provider, builder) {
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

        Widget listView = ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(height: 0,),
          itemCount: provider.dataSource.data.length,
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemBuilder: (itemContext, idx) {
            final HistoryEntity history = provider.dataSource.data[idx];
            final book = history.book;
            if (book == null) {
              return Container();
            }
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) async {
                var id = history.id;
                if (id == null) {
                  return;
                }
                await provider.onDeleteHistory(id);
                final snackBar = SnackBar(
                  content: Text('已删除'),
                  duration: Duration(seconds: 1),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: BookItem(
                  book: book,
                ),
              ),
            );
          },
        );
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(
              "浏览历史",
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: provider.dataSource.data.isEmpty?EmptyView(
              isLoading: provider.isLoading,
              icon: Icon(
                Icons.history,
                size: 96,
                color: Colors.black26,
              ),
              text: "没有历史记录",
              onRefresh: (){
                provider.onForceReload();
              },
            ):listView,
          ),
        );
      }),
    );
  }
}
