import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppp_conference/bloc/slot_comment/bloc.dart';
import 'package:ppp_conference/screens/comments/list.dart';

class CommentForm extends StatefulWidget {
  final CommentBloc bloc;
  final Color color;
  final String slotId;

  const CommentForm(
      {Key key,
      @required this.bloc,
      @required this.color,
      @required this.slotId})
      : super(key: key);

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
            CommentList(
                bloc: widget.bloc,
                context: context,
                color: widget.color,
                slotId: widget.slotId)
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
                      await Future.delayed(Duration(milliseconds: 100)); //hack
                      setState(() {
                        _keyboardHeihgt =
                            MediaQuery.of(context).viewInsets.bottom;
                      });
                    },
                    onChanged: (text) => {
                      if (_keyboardHeihgt !=
                          MediaQuery.of(context).viewInsets.bottom)
                        {
                          setState(() {
                            _keyboardHeihgt =
                                MediaQuery.of(context).viewInsets.bottom;
                          })
                        }
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
                  var comment = _controller.text;
                  _controller.clear();
                  widget.bloc
                      .add(SendComment('someID', comment, widget.slotId));
                  dismissKeyboard(context);
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
