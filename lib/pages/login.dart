import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'package:weight_tracker/uielements/logo.dart';
class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});
   final BaseAuth auth;
   final VoidCallback loginCallback;
  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();

}

class _LoginSignupPageState extends State<LoginSignupPage>{
  final _formKey = new GlobalKey<FormState>();
  bool isloading=false;
  String email,password;
  String errormessage="";
  bool isloginform=false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
          children: <Widget>[
            _showForm(),
            showCircularProgress(),
          ],
        )
    );
  }
  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: Visibility(
            child:  new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: !isloading,
          ),
        ));
  }
  Widget showCircularProgress() {
    if (isloading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }


  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => password = value.trim(),
      ),
    );
  }
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
   void validateAndSubmit() async {
    setState(() {
      errormessage = "";
      isloading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (isloginform) {
          userId = await widget.auth.signIn(email, password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(email, password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        if (userId.length > 0 && userId != null ) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          isloading = false;
          errormessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
    else
      {
        setState(() {
          isloading=false;
        });
      }
  }
  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(isloginform ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            isloginform ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }
  void toggleFormMode() {
//    resetForm();
    setState(() {
      isloginform = !isloginform;
    });
  }
  void resetForm() {
    _formKey.currentState.reset();
    errormessage = "";
  }
  Widget showErrorMessage() {
    if (errormessage.length > 0 && errormessage != null) {
      return new Text(
        errormessage,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}