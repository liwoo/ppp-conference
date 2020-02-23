import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ppp_conference/models/attendee.dart';
import 'package:ppp_conference/models/comment.dart';
import 'package:ppp_conference/models/slot.dart';
import 'package:ppp_conference/presentation/forms.dart';
import 'package:ppp_conference/screens/schedule/widgets/category.dart';
import 'package:ppp_conference/screens/schedule/widgets/slot.dart';
import 'package:ppp_conference/screens/speaker/details.dart';

class SlotDetails extends StatefulWidget {
  final Slot slot;
  final String category;
  final Color color;

  const SlotDetails({Key key, this.slot, this.category, this.color})
      : super(key: key);

  @override
  _SlotDetailsState createState() => _SlotDetailsState();
}

class _SlotDetailsState extends State<SlotDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: widget.color,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => print('Setting Notification')
          ),
          IconButton(
              icon: Icon(Icons.thumb_up),
              onPressed: () => print('Liking')
          ),
          IconButton(
              icon: Icon(Icons.thumb_down),
              onPressed: () => print('Liking')
          )
        ],
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: FloatingActionButton(
          backgroundColor: widget.color,
          child: Icon(Icons.add_comment),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CommentForm(
                    color: widget.color,
                  ))),
        ),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          padding: EdgeInsets.all(18),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Text(
                    widget.slot.name,
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Category(
                    color: widget.color,
                    title: widget.category.toUpperCase(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: <Widget>[
                buildPill(
                    '📆 ${formatDate(widget.slot.startTime.add(Duration(hours: 2)), [
                  d,
                  ' ',
                  M,
                  ' ',
                  yyyy
                ])}'),
                SizedBox(
                  width: 12,
                ),
                buildPill(
                    '⏱ ${formatDate(widget.slot.startTime.add(Duration(hours: 2)), [
                  HH,
                  ':',
                  nn
                ])} - ${formatDate(widget.slot.endTime.add(Duration(hours: 2)), [
                  HH,
                  ':',
                  nn
                ])}'),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            buildSectionTitle(context, 'Description'),
            SizedBox(
              height: 12,
            ),
            Html(data: widget.slot?.summaryHTML ?? 'No Summary Included'),
            SizedBox(
              height: 24,
            ),
            ...buildUserSection(context, 'Speakers', widget.slot.slotSpeakers),
            ...buildUserSection(
                context, 'Facilitators', widget.slot.slotFacilitators),
            ...buildUserSection(
                context, 'Panelists', widget.slot.slotPanelists),
            buildSectionTitle(context, 'Comments (35)'),
            SizedBox(
              height: 12,
            ),
            ...buildComments(context, comments, widget.color)
          ],
        ),
      ),
    );
  }

  List<Widget> buildComments(
      BuildContext context, List<SlotComment> myComments, Color color) {
    return myComments.map((comment) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          children: <Widget>[
            Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(99))),
                child: Text(
                  'IM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 18,
            ),
            Flexible(
              child: RichText(
                text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.bold),
                    text: '${comment.commenter} ',
                    children: [
                      TextSpan(
                          style: Theme.of(context).textTheme.body1,
                          text: comment.comment)
                    ]),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  List<Widget> buildUserSection(
      BuildContext context, String title, var userList) {
    return (userList != null && userList != [])
        ? [
            buildSectionTitle(context, title),
            SizedBox(
              height: 12,
            ),
            ...userList.map((user) => FutureBuilder(
                  future: user.get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var user = Attendee.fromSnapshot(snapshot.data);
                      return _buildUserListItem(user, context);
                    }

                    return _buildUserListItem(null, context);
                  },
                )),
            SizedBox(
              height: 24,
            ),
          ]
        : [];
  }

  Widget _buildUserListItem(Attendee user, BuildContext context) {
    return user == null
        ? Text('Loading User')
        : InkWell(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SpeakerDetails())),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 6,
                    child: UserListItem(
                      name: user.fullName,
                      nationality: '${user.country} ${user.countryEmoji}',
                      image: user.image,
                      large: true,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Text buildSectionTitle(BuildContext context, String title) => Text(
        title,
        style: Theme.of(context)
            .textTheme
            .body1
            .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
      );

  Container buildPill(String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

var comments = [
  SlotComment(
      comment: 'This is a really good thing, I am in total support! 😀',
      commenter: 'Linda Nyongo',
      time: DateTime(2020, 2, 24, 9, 14, 22)),
  SlotComment(
      comment:
          'Really enjoying these sessions... Would love to hear more about this topic',
      commenter: 'Lucy Mwalwimba',
      time: DateTime(2020, 2, 24, 9, 27, 18)),
  SlotComment(
      comment:
          'Big up to you gius for such a wonderful experience we are having over here. Big up to the developer as well...',
      commenter: 'Enipher Chiguduli',
      time: DateTime(2020, 2, 24, 9, 29, 7))
];

class CommentForm extends StatefulWidget {
  final Color color;

  const CommentForm({Key key, @required this.color}) : super(key: key);

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
          children: <Widget>[...buildComments(context, comments, widget.color)],
        ),
      ),
    );
  }

  List<Widget> buildComments(
      BuildContext context, List<SlotComment> myComments, Color color) {
    return myComments.map((comment) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          children: <Widget>[
            Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(99))),
                child: Text(
                  'IM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 18,
            ),
            Flexible(
              child: RichText(
                text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.bold),
                    text: '${comment.commenter} ',
                    children: [
                      TextSpan(
                          style: Theme.of(context).textTheme.body1,
                          text: comment.comment)
                    ]),
              ),
            )
          ],
        ),
      );
    }).toList();
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
                  _dismissKeyboard(context);
                  print('Sending Message');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _dismissKeyboard(BuildContext context) {
    dismissKeyboard(context);
    setState(() {
      _keyboardHeihgt = 0;
    });
  }
}
