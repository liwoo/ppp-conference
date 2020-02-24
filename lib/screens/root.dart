import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppp_conference/bloc/schedule/bloc.dart';
import 'package:ppp_conference/models/slot.dart';
import 'package:ppp_conference/repositories/user_schedule_repository.dart';
import 'package:ppp_conference/screens/schedule/widgets/slot.dart';

class RootScreen extends StatefulWidget {
  final String title;

  RootScreen({this.title});

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final DateTime conferenceDate = DateTime(2020, 2, 26, 8, 0);
  static const CONFERENCE_START = 8;
  static const CONFERENCE_END = 18;
  static const HOUR_SECTIONS = 4;
  ScheduleBloc _scheduleBloc;
  PageController _controller;
  int _conferenceDay;

  String expandedSlot;

  @override
  void initState() {
    _conferenceDay = 1;
    _controller = PageController(initialPage: 0);
    _scheduleBloc = ScheduleBloc(
        userScheduleRepository: UserScheduleRepository(Firestore.instance));
    _scheduleBloc.add(InitializeSchedule('tz4R3avRES42KNMkZbre'));
    expandedSlot = '';
    super.initState();
  }



  final int timeIntervals = (CONFERENCE_END - CONFERENCE_START) * HOUR_SECTIONS;

  _changeConferenceDay(int page) {
    setState(() {
      _conferenceDay = page + 1;
    });
  }

  _handleDayChange(int day) {
    setState(() {
      _conferenceDay = day;
    });

    _controller.animateToPage(day - 1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = Platform.isIOS ? 110 : 80;
    List<Widget> timeScale = List.generate(
        timeIntervals,
        (i) => buildTimeScalePeriod(context,
            time: TimeOfDay.fromDateTime(
                conferenceDate.add(Duration(minutes: (i * 15))))));

    return BlocProvider(
      create: (BuildContext context) => _scheduleBloc,
      child: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) => Scaffold(
          appBar: PreferredSize(
              child: AppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                title: Text(
                  '${widget.title.toUpperCase()}',
                  style: Theme.of(context).textTheme.display1,
                ),
                flexibleSpace: Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildDatePill(context,
                          day: '24', month: 'Feb', handleDayChange: () => _handleDayChange(1), selected: _conferenceDay == 1),
                      buildDatePill(context, day: '25', month: 'Feb', handleDayChange: () => _handleDayChange(2),  selected: _conferenceDay == 2),
                      buildDatePill(context, day: '26', month: 'Feb', handleDayChange: () => _handleDayChange(3), selected: _conferenceDay == 3)
                    ],
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(140)),
          body: state is LoadingScheduleState
              ? Loading()
              : state is FailedLoadingScheduleState
                  ? Text('Something Happened')
                  : PageView(
            onPageChanged: (page) => _changeConferenceDay(page),
              controller: _controller, children: [
                      DaySchdule(
                          daySlots: (state as LoadedScheduleState).dayOneSlots,
                          timeScale: timeScale,
                          startTime: DateTime(2020, 2, 24, 8, 0)),
                      DaySchdule(
                          daySlots: (state as LoadedScheduleState).dayTwoSlots,
                          timeScale: timeScale,
                          startTime: DateTime(2020, 2, 25, 8, 0)),
                      DaySchdule(
                          daySlots:
                              (state as LoadedScheduleState).dayThreeSlots,
                          timeScale: timeScale,
                          startTime: DateTime(2020, 2, 26, 8, 0)),
                    ]),
        ),
      ),
    );
  }
}

class DaySchdule extends StatelessWidget {
  const DaySchdule({
    Key key,
    @required this.daySlots,
    @required this.timeScale,
    @required this.startTime,
  }) : super(key: key);

  final List<Slot> daySlots;
  final List<Widget> timeScale;
  final DateTime startTime;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).accentColor,
      color: Colors.white,
      onRefresh: () async {
        BlocProvider.of<ScheduleBloc>(context).add(InitializeSchedule('some-id'));
      },
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildTimeScale(timeScale),
                buildSlots(daySlots
                    .map((slot) => FutureBuilder(
                        future: slot.category,
                        builder: (BuildContext context, AsyncSnapshot snaphsot) {
                          if (snaphsot.hasData) {
                            var category =
                                SlotCategory.fromReference(snaphsot.data);
                            return SlotContainer(
                              slot: slot,
                              category: category?.name ?? 'Error',
                              startTime: startTime,
                              changeExpanded: () => print('Expanding'),
                              color: HexColor.fromHex(category.color),
                              isExpanded: false,
                            );
                          }

                          return SlotContainer(
                            slot: slot,
                            category: 'Uncategorized',
                            startTime: startTime,
                            changeExpanded: () => print('Expanding'),
                            color: Colors.brown,
                            isExpanded: false,
                          );
                        }))
                    .toList())
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: CircularProgressIndicator(),
    ));
  }
}

Widget buildSlots(List<Widget> slots) {
  return Expanded(
    child: Container(
      child: Stack(children: slots),
    ),
  );
}

Widget buildTimeScale(List<Widget> timeScale) {
  return Container(
    decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[500]))),
    padding: EdgeInsets.symmetric(horizontal: 18.0),
    child: Column(
      children: timeScale,
    ),
  );
}

Widget buildTimeScalePeriod(BuildContext context, {TimeOfDay time}) {
  return Container(
    height: 80,
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: TextStyle(
              color: Colors.grey[600],
              fontSize: 22,
              fontWeight: FontWeight.bold),
          text: '${time.hour.toString().padLeft(2, '0')}',
          children: [
            TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16, height: 0.7),
                text: '\n${time.minute.toString().padLeft(2, '0')}')
          ]),
    ),
  );
}

Widget buildDatePill(BuildContext context,
        {String day, String month, Function handleDayChange, bool selected = false}) =>
    InkWell(
      onTap: handleDayChange,
      child: Container(
        decoration: BoxDecoration(
            gradient: selected == true
                ? LinearGradient(colors: [
                    Color(0xFF02B4E3),
                    Theme.of(context).primaryColor,
                  ], begin: Alignment.topLeft)
                : null,
            borderRadius: BorderRadius.all(Radius.circular(99))),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        height: 60,
        width: 60,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: selected == true
                      ? Colors.white
                      : Theme.of(context).primaryColor),
              text: day,
              children: [
                TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                    text: '\n${month.toUpperCase()}')
              ]),
        ),
      ),
    );

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
