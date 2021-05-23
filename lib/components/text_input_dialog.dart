import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final String label;
  final Function(String text) onOk;
  final Function onCancel;
  const TextInputDialog({Key key,this.title,this.label,this.onOk,this.onCancel}) : super(key: key);

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  String text;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        decoration: InputDecoration(
          labelText: widget.label,
        ),
        onChanged: (s) {
          setState(() {
            text = s;
          });
        },
      ),
      actions: [
        TextButton(onPressed: (){
          if (widget.onOk != null) {
            widget.onOk(text);
          }
        }, child: Text("OK")),
        TextButton(onPressed: (){
          if (widget.onCancel != null) {
            widget.onCancel();
          }
        }
        , child: Text("Cancel"))
      ],
    );
  }
}
