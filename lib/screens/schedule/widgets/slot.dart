import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ppp_conference/models/attendee.dart';
import 'package:ppp_conference/models/slot.dart';
import 'package:ppp_conference/screens/schedule/details.dart';
import 'package:ppp_conference/screens/schedule/widgets/category.dart';

class SlotContainer extends StatefulWidget {
  final Slot slot;
  final Color color;
  final String category;
  final Duration duration;
  final bool isExpanded;
  final DateTime startTime;
  final Function changeExpanded;

  SlotContainer(
      {@required this.slot,
      @required this.color,
      @required this.category,
        @required this.startTime,
      this.isExpanded = false,
      this.changeExpanded,
      Key key})
      : duration = slot.endTime.difference(slot.startTime),
        super(key: key);

  @override
  _SlotContainerState createState() => _SlotContainerState();
}

class _SlotContainerState extends State<SlotContainer> {
  static const SIDE_PADDING = 16.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _sidePadding = SIDE_PADDING;
    final _slotHeight = (widget.duration.inMinutes / 15) * 80 - 10;
    Duration minsFromStartTime =
        widget.slot.startTime.difference(widget.startTime);
    final _startMargin =
        minsFromStartTime == 0 ? 0 : (minsFromStartTime.inMinutes / 15) * 80;

    bool isHappeningNow = DateTime.now().isAfter(widget.slot.startTime) &&
        DateTime.now().isBefore(widget.slot.endTime);
    return Padding(
      padding: EdgeInsets.only(
          top: 5.0 + _startMargin,
          bottom: 5,
          left: _sidePadding,
          right: _sidePadding),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            height: _slotHeight,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                buildSlotMargin(),
                Expanded(child: buildMiniSlot(context, isHappeningNow)),
              ],
            )),
      ),
    );
  }

  Widget buildMiniSlot(BuildContext context, bool isHappeningNow) {
    return GestureDetector(
      onTap: widget.category.toLowerCase() != 'refreshments'
          ? () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SlotDetails(
                    slot: widget.slot,
                    category: widget.category,
                color: widget.color
                  )))
          : null,
      onLongPress:
          widget.duration.inMinutes < 45 ? () => expandSlot(grow: true) : null,
      onLongPressEnd: widget.duration.inMinutes < 45
          ? (details) => expandSlot(grow: false)
          : null,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12))),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isHappeningNow) buildStatusLight(),
            timeAndCategory(context),
            if (widget.duration.inMinutes > 15) ...[
            SizedBox(
              height: 4,
            ),
            Text('${widget.slot.name}',
                style: Theme.of(context).textTheme.title),
            SizedBox(
              height: 4,
            ),
            Text(widget.slot.summary.length < 70
                ? widget.slot.summary
                : '${widget.slot.summary.substring(0, 70)}..'),
            ],
            if (widget.duration.inMinutes > 30) ...[
              SizedBox(
                height: 8,
              ),
              widget.slot.slotFacilitators != null
                  ? FutureBuilder(
                      future: widget.slot.slotFacilitators[0].get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          var user = Attendee.fromSnapshot(snapshot.data);
                          return UserListItem(
                            name: user.fullName,
                            nationality: user.countryEmoji,
                            image: user.image,
                          );
                        }
                        return UserListItem(
                          name: 'Fetching Name',
                          nationality: '🏳',
                          image:
                              'https://res.cloudinary.com/tiyeni/image/upload/v1582367167/pppc_Logo.png',
                        );
                      })
                  : UserListItem(
                      name: 'PPPC',
                      nationality: '🇲🇼',
                      image:
                          'https://res.cloudinary.com/tiyeni/image/upload/v1582367167/pppc_Logo.png',
                    )
            ],
            if (widget.duration.inMinutes > 50) ...[
              SizedBox(
                height: 12,
              ),
              widget.category.toLowerCase() == 'refreshments'
                  ? Text(
                      '🌮',
                      style: Theme.of(context).textTheme.display3,
                      textAlign: TextAlign.center,
                    )
                  : Container(
                      decoration: BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Colors.grey[400]))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.add_alert,
                              color: Colors.grey,
                            ),
                            iconSize: 38,
                            onPressed: () => print('alerting'),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.thumb_up,
                              color: Colors.grey,
                            ),
                            iconSize: 38,
                            onPressed: () => print('liking'),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.thumb_down,
                              color: Colors.grey,
                            ),
                            iconSize: 38,
                            onPressed: () => print('disliking'),
                          )
                        ],
                      ),
                    )
            ]
          ],
        ),
      ),
    );
  }

  Widget timeAndCategory(BuildContext context) {
    return FittedBox(
      child: Row(
        children: <Widget>[
          Text(
            '${formatTime(widget.slot.startTime.add(Duration(hours: 2)))} - ${formatTime(widget.slot.endTime.add(Duration(hours: 2)))}',
            style: TextStyle(
                color: widget.color, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8,),
          FutureBuilder(
              future: widget.slot.category,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  SlotCategory category =
                      SlotCategory.fromReference(snapshot.data);
                  return Row(
                    children: <Widget>[
                      Category(
                          color: widget.color, title: category.name.toUpperCase()),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Category(color: widget.color, title: 'Error');
                }

                return Category(color: widget.color, title: 'Loading Session');
              })
        ],
      ),
    );
  }

  String formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Widget buildSlotMargin() {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
      width: 15,
    );
  }

  Widget buildStatusLight() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      shadowColor: Colors.greenAccent,
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }

  void expandSlot({bool grow = false}) {
    widget.changeExpanded(grow == true ? widget.slot.id : '');
    double defualtSize = 4.0 * 80 - 10;
//    double difference = defualtSize - _slotHeight;
//    setState(() {
//      if (grow == true) {
//        _slotHeight += difference;
//        _startMargin -= difference / 2;
//        _sidePadding -= 8;
//      }
//
//      if (grow == false) {
//        _slotHeight = calculateSlotHeight(widget.duration);
//        _startMargin = _startMargin;
//        _sidePadding = SIDE_PADDING;
//      }
//    });
  }
}

class UserListItem extends StatelessWidget {
  final String image;
  final String name;
  final String nationality;
  final bool large;
  const UserListItem(
      {Key key, this.image, this.name, this.nationality, this.large = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: large ? 50 : 30,
          height: large ? 50 : 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(99)),
          ),
          child: ClipOval(
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/logo.png', image: image)),
        ),
        SizedBox(
          width: 12,
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                text: name,
                children: [
                  TextSpan(
                      style:
                          Theme.of(context).textTheme.title.copyWith(height: 1),
                      text: '\n$nationality')
                ]),
          ),
        )
      ],
    );
  }
}
