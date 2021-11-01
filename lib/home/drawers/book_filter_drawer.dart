import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/components/filter/book_fliter_drawer.dart';
import 'package:youcomic/home/tabs/books/provider.dart';

class HomeBookListFilterDrawer extends StatelessWidget {
  final BookListProvider externalBookListProvider;
  final Function() onClose;

  HomeBookListFilterDrawer({required this.onClose, required this.externalBookListProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListProvider>.value(
      value: externalBookListProvider,
      child:
          Consumer<BookListProvider>(builder: (context, bookProvider, child) {
        return BookFilterDrawer(
          onClose: this.onClose,
          onOrderUpdate: bookProvider.updateOrderFilter,
          activeOrders: bookProvider.orderFilter,
          onCustomTimeRangeChange: bookProvider.updateCustomDateRange,
          customTimeRange: bookProvider.customDateRange,
          onTimeRangeChange: bookProvider.onTimeRangeChange,
          onClearCustomTimeRange: bookProvider.onClearTimeRange,
          timeRangeSelectMode: bookProvider.timeRangeSelect,
        );
      }),
    );
  }
}
