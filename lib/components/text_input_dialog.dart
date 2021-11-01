import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final String label;
  final Function(String text)? onOk;
  final Function()? onCancel;
  const TextInputDialog({Key? key,required this.title,required this.label,this.onOk,this.onCancel}) : super(key: key);

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  String text = "";
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
          var handler = widget.onOk;
          if (handler != null && text.isNotEmpty) {
            handler(text);
          }
        }, child: Text("OK")),
        TextButton(onPressed: (){
          var handler = widget.onCancel;
          if (handler != null) {
            handler();
          }
        }
        , child: Text("Cancel"))
      ],
    );
  }
}
