import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/components/book_info_bottom_sheet.dart';
import 'package:youcomic/components/book_item.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/pages/tag/menu.dart';
import 'package:youcomic/pages/tag/provider.dart';

class TagPage extends StatelessWidget {
  final TagEntity tagEntity;
  TagPage({this.tagEntity});
  static launch(BuildContext context, TagEntity tag) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TagPage(tagEntity: tag,)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TagProvider>(
      create: (_) => TagProvider(tag: tagEntity),
      child: Consumer<TagProvider>(builder: (context, tagProvider, builder) {
        tagProvider.onLoad();
        tagProvider.checkIsSubscribe();
        Future _pullToRefresh() async {
          await tagProvider.bookDataSource.loadBooks(true);
        }
        List<Widget> items = [];
        createBookItem(book){
          items.add(BookItem(book:book,onLongPress: () {
            HapticFeedback.vibrate();
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BookInfoBottomSheet(
                    bookEntity: book,
                  );
                });
          },));
          items.add(Divider(height: 0,));
        }
        tagProvider.bookDataSource.books.forEach((book) => createBookItem(book));

        ScrollController _controller = new ScrollController();
        _controller.addListener(() {
          var maxScroll = _controller.position.maxScrollExtent;
          var pixel = _controller.position.pixels;
          if (maxScroll == pixel) {
            tagProvider.loadMoreBooks();
          } else {
          }
        });

        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            actions: ApplicationConfig().useNanoMode
                ? null
                : renderAction(tagProvider),
            title: Text(
              tagProvider.title,
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: ListView(
              children: items.toList(),
              controller: _controller,
            ),
          ),
        );
      }),
    );
  }
}
