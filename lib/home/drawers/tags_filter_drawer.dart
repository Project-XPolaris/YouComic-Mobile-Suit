import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/components/filter/tag_filter_drawer.dart';
import 'package:youcomic/home/tabs/tags/provider.dart';

class HomeTagsFilterDrawer extends StatelessWidget {
  final TagsProvider externalTagProvider;
  final Function() onClose;

  HomeTagsFilterDrawer({required this.externalTagProvider, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TagsProvider>.value(
      value: externalTagProvider,
      child: Consumer<TagsProvider>(builder: (context, tagProvider, child) {
        return TagFilterDrawer(
          onClose: onClose,
          activeTypeFilters: tagProvider.typesFilter,
          onTypeFilterChange: (List<String> filter) => tagProvider.refreshTagTypeFilter(filter),
        );
      }),
    );
  }
}
