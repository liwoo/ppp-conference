import 'package:flutter/material.dart';
import 'package:ppp_conference/screens/comments/list.dart';

class CommentForm extends StatefulWidget {
  final Color color;
  final String slotId;

  const CommentForm({Key key, @required this.color, @required this.slotId}) : super(key: key);

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  double _keyboardHeihgt = 0;
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: widget.color,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        title: GestureDetector(
          onTap: () => dismissKeyboard(context),
          child: Text(
            'Add Comment',
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomAppBar(context),
      body: GestureDetector(
        onTap: () => dismissKeyboard(context),
        child: ListView(
          padding: EdgeInsets.all(18),
          children: <Widget>[
            CommentList(context: context, myComments: comments, color: widget.color, slotId: 'Some Slot ID')
          ],
        ),
      ),
    );
  }

  Widget buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[300],
      elevation: 12,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: 10 + _keyboardHeihgt, left: 18, right: 18, top: 8),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      border: Border.all(color: Colors.grey[400])),
                  child: TextField(
                    controller: _controller,
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 200));
                      setState(() {
                        _keyboardHeihgt =
                            MediaQuery.of(context).viewInsets.bottom;
                      });
                    },
                    onSubmitted: (text) {
                      setState(() {
                        _keyboardHeihgt = 0;
                      });
                    },
                    keyboardAppearance: Brightness.light,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Leave a Comment or a Question'),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.grey[700],
                ),
                onPressed: () {
                  _controller.clear();
                  dismissKeyboard(context);
                  print('Sending Message');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void dismissKeyboard(BuildContext context) {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _keyboardHeihgt = 0;
    });
  }
}
