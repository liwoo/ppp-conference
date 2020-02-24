import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ppp_conference/bloc/auth/bloc.dart';
import 'package:ppp_conference/bloc/slot_comment/bloc.dart';
import 'package:ppp_conference/models/attendee.dart';
import 'package:ppp_conference/models/slot.dart';
import 'package:ppp_conference/repositories/user_schedule_repository.dart';
import 'package:ppp_conference/screens/comments/form.dart';
import 'package:ppp_conference/screens/comments/list.dart';
import 'package:ppp_conference/screens/schedule/widgets/category.dart';
import 'package:ppp_conference/screens/schedule/widgets/slot.dart';
import 'package:ppp_conference/screens/speaker/details.dart';

class SlotDetails extends StatefulWidget {
  final Slot slot;
  final String category;
  final Color color;
  final AuthBloc authBloc;

  const SlotDetails(
      {Key key, this.slot, this.category, this.color, this.authBloc})
      : super(key: key);

  @override
  _SlotDetailsState createState() => _SlotDetailsState();
}

class _SlotDetailsState extends State<SlotDetails> {
  CommentBloc _commentBloc;

  @override
  void initState() {
    _commentBloc = CommentBloc(
        authBloc: widget.authBloc,
        userScheduleRepository: UserScheduleRepository(Firestore.instance));
    _commentBloc.add(InitializeComments(widget.slot.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _commentBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: widget.color,
          elevation: 0,
//          actions: <Widget>[
//            IconButton(
//                icon: Icon(Icons.thumb_up), onPressed: () => print('Liking')),
//            IconButton(
//                icon: Icon(Icons.thumb_down), onPressed: () => print('Liking'))
//          ],
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
                      bloc: _commentBloc,
                      color: widget.color,
                      slotId: widget.slot.id,
                    ))),
          ),
        ),
        body: RefreshIndicator(
          color: Colors.grey[800],
          backgroundColor: widget.color,
          onRefresh: () async {
            _commentBloc.add(InitializeComments(widget.slot.id));
          },
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
              ...buildUserSection(
                  context, 'Speakers', widget.slot.slotSpeakers),
              ...buildUserSection(
                  context, 'Facilitators', widget.slot.slotFacilitators),
              ...buildUserSection(
                  context, 'Panelists', widget.slot.slotPanelists),
              BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
                if (state is LoadedCommentsState) {
                  return buildSectionTitle(
                      context, 'Comments(${state.slotComments.length})');
                }
                return buildSectionTitle(context, 'Comments');
              }),
              SizedBox(
                height: 12,
              ),
              CommentList(
                  bloc: _commentBloc,
                  context: context,
                  color: widget.color,
                  slotId: widget.slot.id)
            ],
          ),
        ),
      ),
    );
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
                MaterialPageRoute(builder: (context) => SpeakerDetails(speaker: user))),
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
