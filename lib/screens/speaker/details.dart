import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ppp_conference/models/attendee.dart';
class SpeakerDetails extends StatelessWidget {
  final Attendee speaker;

  const SpeakerDetails({Key key, this.speaker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF02B4E3),
                      Theme.of(context).primaryColor,
                    ], begin: Alignment.topLeft)),
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                width: double.infinity,
                color: Theme.of(context).canvasColor,
              ),
            )
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: ListView(padding: EdgeInsets.all(24), children: [
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(99)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                speaker.image))),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.white),
                        text: speaker.fullName,
                        children: [
                          TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: Colors.white),
                              text: '\n${speaker.occupation}'),
                          TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: Colors.white),
                              text:
                              '\n${'${speaker.organization}'.toUpperCase()}')
                        ]),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'About ${speaker.fullName.split(' ')[0]}',
                        style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12,),
                      Html(data: speaker.profile,),
                      SizedBox(height: 16,),
//                      Container(
//                        width: double.infinity,
//                        padding: EdgeInsets.symmetric(vertical: 12),
//                        decoration: BoxDecoration(
//                            border: Border(
//                                top: BorderSide(color: Colors.grey[400])
//                            )
//                        ),
//                        child: Row(
//                          children: <Widget>[
//                            Image.asset('assets/facebook.png', height: 50, width: 50,),
//                            Image.asset('assets/linkedin.png', height: 50, width: 50,),
//                            Image.asset('assets/twitter.png', height: 50, width: 50,),
//                          ],
//                        ),
//                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }
}