import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
//import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
//import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    routes: {},
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAmplifyConfigured = false;

  bool isSignUpComplete = false;
  bool isSignedIn = false;

  Amplify amplifyInstance = Amplify();


  @override
  void initState() {
    super.initState();

    _configureAmplify();
  }

  void _configureAmplify() async {
    if(!mounted) return;

    try{
      AmplifyAuthCognito authPlugin = AmplifyAuthCognito();

      amplifyInstance.addPlugin(authPlugins: [authPlugin]);
      await amplifyInstance.configure(amplifyconfig);

      setState(() {
        _isAmplifyConfigured = true;
      });
    }catch (e) {
      print(e);
    }
  }


  // ignore: missing_return
  Future<String> _registerUser(LoginData data) async {

    try{
      Map<String, dynamic> userAttributes = {
        'email': data.name,

      };



      //name and password
      SignUpResult res = await Amplify.Auth.signUp(username: data.name, password: data.password);

      setState(() {
        isSignUpComplete = res.isSignUpComplete;

        print("Sign up is " + (isSignUpComplete ? "complete" : "not complete"));
      });
    } on AuthError catch(e){
      return e.toString();
    }
  }


    // ignore: missing_return
    Future<String> _signIn(LoginData data) async {
    try{
      SignInResult res = await Amplify.Auth.signIn(username: data.name, password: data.password);
      setState(() {
        isSignedIn = res.isSignedIn;
      });

      if(isSignedIn){
        Alert(
          context: context,
          type: AlertType.success,
          title: "Login Sucessful",
          desc: "Good job",
        ).show();
      }

    } on AuthError catch(e){
      Alert(context: context, type: AlertType.error,
      title: 'Login Failed',
      desc: e.toString(),
      ).show();
      return e.toString();
    }


    }



  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: FlutterLogin(
        logo: 'assets/vennify media.png',
        onLogin: _signIn,
        onSignup: _registerUser,
        onRecoverPassword: (_) => null,
        title: 'Flutter Amplify',
      ),

    );
  }
}