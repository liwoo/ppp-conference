import 'package:flutter/material.dart';
class SpeakerDetails extends StatelessWidget {
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
                                'https://res.cloudinary.com/tiyeni/image/upload/v1564216876/payday.jpg'))),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.white),
                        text: 'Kip Kollison',
                        children: [
                          TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: Colors.white),
                              text: '\nAngel Investor'),
                          TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: Colors.white),
                              text:
                              '\n${'United States of America'.toUpperCase()}')
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
                        'About Kip',
                        style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12,),
                      Text(
                          '''Kip is the Managing Partner of Citadel Advocates (previously Oundo&Co Advocates), a legal and consultancy firm that specialises in Project finance, Energy and Infrastructure. \n\nHe has previously served as Legal Counsel at the Privatisation Unit, Ministry of Finance, Planning and Economic Development, Legal Expert at the Public Private Partnership Unit and as a Board member of the Uganda Railways Corporation. \n\nKip advises governments and Development Finance Institutions (on infrastructure projects in Africa Bernard holds a Master of Laws with Distinction in Petroleum Law and Policy (from the University of Dundee, a Professional Certification of Certified Public Private Partnership Specialist from the Institute of Public Private Partnerships, Loughborough University and is also an alumnus of the Harvard Kennedy School Executive Programme'''),
                      SizedBox(height: 16,),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.grey[400])
                            )
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/facebook.png', height: 50, width: 50,),
                            Image.asset('assets/linkedin.png', height: 50, width: 50,),
                            Image.asset('assets/twitter.png', height: 50, width: 50,),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Kip\'s Sessions',
                      style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],),
              ),
            )
          ]),
        )
      ],
    );
  }
}