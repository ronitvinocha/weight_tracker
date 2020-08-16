import 'package:flutter/material.dart';
import 'package:weight_tracker/pages/root.dart';
import '../services/auth.dart';
import 'package:weight_tracker/uielements/logo.dart';
class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth});
   final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();

}

class _LoginSignupPageState extends State<LoginSignupPage>{
  final _formKey = new GlobalKey<FormState>();
  bool isloading=false;
  String email,password;
  String errormessage="";
  bool isloginform=true;
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
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: Visibility(
            child:  new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(context),
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
      return Center(child: Container(
               width: 50,
               height: 50,
               child: CircularProgressIndicator(backgroundColor: Colors.white70,valueColor: new AlwaysStoppedAnimation<Color>(Colors.tealAccent),
             )));
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
        style: TextStyle(color: Colors.white70),
        decoration: new InputDecoration(
            hintText: 'Email',
             errorBorder: UnderlineInputBorder(
               borderSide: BorderSide(color: Colors.white70)
             ),
             focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
          ),
             errorStyle: TextStyle(color: Colors.white70),
            hintStyle: TextStyle(color: Theme.of(context).accentColor),
            icon: new Icon(
              Icons.mail,
              color: Theme.of(context).accentColor,
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
        style: TextStyle(color: Colors.white70),
        decoration: new InputDecoration(
            errorBorder: UnderlineInputBorder(
               borderSide: BorderSide(color: Colors.white70)
             ),
            focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
          ),
            hintText: 'Password',
            errorStyle: TextStyle(color: Colors.white70),
            hintStyle: TextStyle(color: Theme.of(context).accentColor),
            icon: new Icon(
              Icons.lock,
              color:Theme.of(context).accentColor,
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
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => new RootPage(
          auth: widget.auth)));
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
            color: Theme.of(context).accentColor,
            child: new Text(isloginform ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.black)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            isloginform ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0,color: Colors.white70, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }
  void toggleFormMode() {
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
            fontSize: 18.0,
            color: Colors.white,
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