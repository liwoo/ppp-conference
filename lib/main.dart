import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ppp_conference/presentation/forms.dart';
import 'package:ppp_conference/screens/root.dart';

void main() => runApp(PPPConference());

class PPPConference extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          canvasColor: Colors.grey[300],
          primaryColor: Color(0xFF017DC3),
          accentColor: Color(0xFF20368C),
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),
          textTheme: TextTheme(
              title: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[600]),
              display1: TextStyle(fontSize: 28, fontWeight: FontWeight.w400))),
      title: 'PPP Conference App 2020',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  void _loginToGoogle() {
    print('logging in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(48),
              topLeft: Radius.circular(48),
            )),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 100,
              left: 100,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(300)),
                    gradient: LinearGradient(
                        colors: [Theme.of(context).primaryColor, Colors.blue])),
              ),
            ),
            Positioned(
              top: 50,
              left: 50,
              child: Container(
                  width: 70,
                  height: 70,
                  child: Image.asset(
                    'assets/icon-white.png',
                  )),
            )
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => dismissKeyboard(context),
        child: ListView(
          padding: EdgeInsets.all(18),
          children: <Widget>[
            Text('Login High Level\nPPP Conference',
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 12,
            ),
            Row(
              children: <Widget>[
                Container(
                  height: 3,
                  width: 150,
                  color: Colors.grey,
                ),
                Container()
              ],
            ),
            SizedBox(
              height: 60,
            ),
            buildLoginButton(
                'Sign in with Google', Color(0xFFC84949), _loginToGoogle),
            SizedBox(
              height: 24,
            ),
            buildLoginButton(
                'Sign in with Apple', Colors.grey[900], _loginToGoogle),
            SizedBox(
              height: 24,
            ),
            buildPhoneLogin(context),
            SizedBox(
              height: 12,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: false,
                  onChanged: (value) =>
                      print('get new value and change to true'),
                ),
                RichText(
                  text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Colors.grey[700]),
                      text: 'I agree to the terms of the ',
                      children: [
                        TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            text: 'Privacy Policy')
                      ]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Row buildPhoneLogin(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.grey[400],
                border: Border.all(color: Colors.grey[500])),
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Or Enter Phone Number'),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Theme.of(context).primaryColor),
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_forward),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PhonePin())),
            ),
          ),
        )
      ],
    );
  }

  MaterialButton buildLoginButton(
      String title, Color color, Function onPressed) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      elevation: 1,
      color: color,
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}


//TODO: Create Controllers for each box and make sure to switch to the next when a pin has been filled
//TODO: Automatically submit when all numbers are filled
class PhonePin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey[700]),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('📲', style: Theme.of(context).textTheme.display3.copyWith(fontSize: 84),),
              SizedBox(
                height: 24,
              ),
              Text(
                'OTP Verification',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    text: 'Enter the OTP sent to ',
                    children: [
                      TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          text: '+250 784 717 438')
                    ]),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  buildPinField(context),
                  buildPinField(context),
                  buildPinField(context),
                  buildPinField(context),
                ],
              ),
              SizedBox(
                height: 48,
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.body1,
                  text: 'Did not receive the OTP? ',
                  children: [
                    TextSpan(
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      text: 'RESEND OTP'
                    )
                  ]
                ),
              )
            ],
          ),
        ));
  }

  Container buildPinField(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.numberWithOptions(),
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: ''
        ),
        style: Theme.of(context).textTheme.display1,
      ),
    );
  }
}
