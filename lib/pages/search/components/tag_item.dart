import 'package:flutter/material.dart';
import 'package:youcomic/util/icon.dart';

class TagItem extends StatelessWidget {
  var tag;

  TagItem(this.tag);

  @override
  Widget build(BuildContext context) {
    print(tag);
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                child: Icon(
                  selectIconByTagType(tag["type"]),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: 320,
                      child: Text(
                        tag["name"],
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    tag["type"] != null ? tag["type"] : "",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      Divider()
    ]);
  }
}
