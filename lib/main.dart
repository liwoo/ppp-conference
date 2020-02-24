import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ppp_conference/bloc/auth/bloc.dart';
import 'package:ppp_conference/presentation/forms.dart';
import 'package:ppp_conference/repositories/auth_repository.dart';
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
      home: AuthorizationScreen(),
    );
  }
}

class AuthorizationScreen extends StatefulWidget {
  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  AuthBloc _authBloc;
  @override
  void initState() {
    _authBloc = AuthBloc(
        authRepository: AuthRepository(FirebaseAuth.instance,
            googleSignIn: GoogleSignIn()));
    _authBloc.add(InitializeAuth());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => _authBloc,
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is LoggedOutState) {
            return LoginScreen();
          } else if (state is LoggedInState)
            return RootScreen(title: 'Schedule');
          else if (state is MobilePinSentState)
            return PhonePin();
          else if (state is LoginFailed)
            return LoginScreen(error: state.error);
          else if (state is UserNotRegisteredState) {
            return Register();
          } else
            return Splash();
        }));
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}

class LoginScreen extends StatelessWidget {
  final String error;
  LoginScreen({this.error});
  final TextEditingController phoneLoginController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    void _loginToGoogle() {
      authBloc.add(GoogleLogin());
    }

    if (error != null) {
      print(error);
    }
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) => Scaffold(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(300)),
                            gradient: LinearGradient(colors: [
                              Theme.of(context).primaryColor,
                              Colors.blue
                            ])),
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
                    LoginButton(title: 'Sign in with Google', color: Color(0xFFC84949), onPressed: _loginToGoogle),
                    SizedBox(
                      height: 24,
                    ),
                    LoginButton(title: 'Sign in with Apple', color: Colors.grey[900], onPressed: _loginToGoogle),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    text: 'Privacy Policy')
                              ]),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  Row buildPhoneLogin(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    void _phoneLogin() {
      var phoneNumber = phoneLoginController.text;
      authBloc.add(PhoneLogin(phoneNumber, context));
      print('logging in');
    }

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
              controller: phoneLoginController,
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
              onPressed: _phoneLogin,
            ),
          ),
        )
      ],
    );
  }
}

class LoginBottomSheet extends StatelessWidget {
  final double factor;
  const LoginBottomSheet({
    @required this.factor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * factor,
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
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required this.title,
    @required this.color,
    @required this.onPressed,
  }) : super(key: key);

  final String title;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
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

class PhonePin extends StatefulWidget {
  @override
  _PhonePinState createState() => _PhonePinState();
}

class _PhonePinState extends State<PhonePin> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  TextEditingController t6 = TextEditingController();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();

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
              Text(
                '📲',
                style:
                    Theme.of(context).textTheme.display3.copyWith(fontSize: 84),
              ),
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
                  buildPinField(context, t1, f1),
                  buildPinField(context, t2, f2),
                  buildPinField(context, t3, f3),
                  buildPinField(context, t4, f4),
                  buildPinField(context, t5, f5),
                  buildPinField(context, t6, f6),
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
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                          text: 'RESEND OTP')
                    ]),
              )
            ],
          ),
        ));
  }

  Container buildPinField(BuildContext context,
      TextEditingController controller, FocusNode focusNode) {
    void submit() {
      final authBloc = BlocProvider.of<AuthBloc>(context);

      var pin = "${t1.text}${t2.text}${t3.text}${t4.text}${t5.text}${t6.text}";
      print(t1.text);
      print(pin);
      authBloc.add(SubmitPin(pin));
    }

    return Container(
      width: 50,
      height: 50,
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.numberWithOptions(),
        textAlign: TextAlign.center,
        maxLength: 1,
        controller: controller,
        onChanged: (val) {
          if (val.length > 0) {
            if (focusNode == f6) {
              submit();
            } else {
              focusNode.nextFocus();
            }
          }
        },
        focusNode: focusNode,
        decoration: InputDecoration(counterText: ''),
        style: Theme.of(context).textTheme.display1,
      ),
    );
  }
}

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
      bottomNavigationBar: LoginBottomSheet(factor: 0.4),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Hmmmm...\nSeem like you aren\'t Registered',
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
              height: 24,
            ),
            Text('Don\'t worry.  This could be a mistake on our end.  Please contact the administrator to rectify this problem.'),
            SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              child: LoginButton(title: 'Logout and Try Again', color: Theme.of(context).primaryColor, onPressed: () => 'logging out',),
            )
          ],
        ),
      ),
    );
  }
}
