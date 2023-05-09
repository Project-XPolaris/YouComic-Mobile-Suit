import 'package:flutter/material.dart';
import 'package:youcomic/config/application.dart';

import 'filter_section.dart';

class RangeItem {
  late String id;
  int? max;
  int? min;

  String get displayText {
    if (max == null && min == null) {
      return "all";
    }
    if (max == null) {
      return "least ${min} pages";
    }
    if (min == null) {
      return "most ${max} pages";
    }
    return "${min} - ${max}";
  }

  Map<String,dynamic> toJson(){
    return {
      "id":id,
      "max":max,
      "min":min
    };
  }
  RangeItem.fromJson(Map<String,dynamic> json){
    id = json["id"];
    max = json["max"];
    min = json["min"];
  }

  RangeItem({required this.id, this.max, this.min});

}

class RangeSaveFilterSection extends StatefulWidget {
  final bool showDivider;
  final String title;
  final String? selectId;
  final Function(RangeItem item) onSelectChange;
  final String storeKey;

  RangeSaveFilterSection(
      {this.showDivider = false,
      this.title = "排序",
      required this.selectId,
      required this.onSelectChange,
      required this.storeKey});

  @override
  State<RangeSaveFilterSection> createState() => _RangeSaveFilterSectionState();
}

class _RangeSaveFilterSectionState extends State<RangeSaveFilterSection> {
  List<RangeItem> items = [];

  final minTextFieldController = TextEditingController();

  final maxTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var rawStoreValue = ApplicationConfig().getOrDefault(widget.storeKey, null);
    bool hasAll = false;
    if (rawStoreValue != null) {
      rawStoreValue.forEach((element) {
        if (element["id"] == "all") {
          hasAll = true;
        }
        items.add(RangeItem.fromJson(element));
      });
    }
    if (!hasAll) {
      items.insert(0,RangeItem(id: "all"));
    }

  }

  @override
  Widget build(BuildContext context) {
    _onSaveRange(int? min, int? max) {
      var item = RangeItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        min: min,
        max: max,
      );
      items.add(item);
      ApplicationConfig().updateConfig(widget.storeKey, items);
      setState(() {
        items = items;
      });
    }

    String getSelectTagId(){
      if(widget.selectId == null){
        return "all";
      }
      return items.firstWhere((element) => element.id == widget.selectId).id;
    }

    return FilterSection(
      title: widget.title,
      showDivider: false,
      child: Wrap(
        children: <Widget>[
          ...items.map(
            (tag) => Padding(
                padding: EdgeInsets.only(right: 8, bottom: 8),
                child: ChoiceChip(
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  label: Text(tag.displayText),
                  onSelected: (isSelected) {
                    widget.onSelectChange(tag);
                  },
                  selected: getSelectTagId() == tag.id,
                )),
          ),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: TextField(
                    controller: minTextFieldController,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Min",
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: TextField(
                    controller: maxTextFieldController,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Max",
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: OutlinedButton(
                  onPressed: () {
                    int? max;
                    int? min;
                    if (maxTextFieldController.text.isNotEmpty) {
                      max = int.parse(maxTextFieldController.text);
                    }
                    if (minTextFieldController.text.isNotEmpty) {
                      min = int.parse(minTextFieldController.text);
                    }
                    _onSaveRange(min, max);
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
