import 'package:flutter/material.dart';

class TextInputBottomSheet extends StatefulWidget {
  final String buttonText;
  final Function onOk;
  final String initValue;
  TextInputBottomSheet({this.buttonText= "确定", this.onOk,this.initValue = "" });

  @override
  _TextInputBottomSheetState createState() => _TextInputBottomSheetState();
}

class _TextInputBottomSheetState extends State<TextInputBottomSheet> {
  String inputText = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
          shape: RoundedRectangleBorder(),
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      autofocus: true,
                      initialValue: widget.initValue,
                      onChanged: (newText){
                        setState(() {
                          inputText = newText;
                        });
                      },
                    ),
                    RaisedButton(
                      elevation: 0,
                      color: Colors.blue,
                      onPressed: inputText.length != 0 ? () {this.widget.onOk(inputText);} : null,
                      child: Text(widget.buttonText,style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
