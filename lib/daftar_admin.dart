import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class DaftarAdmin extends StatefulWidget {
  DaftarAdmin({Key key}) : super(key: key);
  @override
  _DaftarAdminState createState() => _DaftarAdminState();
}

class _DaftarAdminState extends State<DaftarAdmin> {
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); //snackbar

  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  String username = '';
  String userStatus = '';
  //String msg = '';
  bool _isLoggedIn = false;
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") != null) {
      _isLoggedIn = true;
      Navigator.pushReplacementNamed(context, '/Haldua');
    } else {
      _isLoggedIn = false;
    }
  }

  Future<List> _login() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _isInAsyncCall = true;
    });

    Future.delayed(Duration(seconds: 1), () async {
      final response = await http
          .post("http://dokar.kendalkab.go.id/webservice/android/login", body: {
        "username": user.text,
        "password": pass.text,
      });
      var datauser = json.decode(response.body);

      if (datauser[0]['notif'] == 'Empty') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("_isLoggedIn", false);
        setState(() {
          _isInAsyncCall = false;
        });
        SnackBar snackBar = SnackBar(
          content: Text(
            'User dan password harus diisi',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                print('ULANGI snackbar');
              }),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      } else if (datauser[0]['notif'] == 'NoUser') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("_isLoggedIn", false);
        setState(() {
          _isInAsyncCall = false;
        });
        SnackBar snackBar = SnackBar(
          content: Text(
            'User tidak di temukan',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                print('ULANGI snackbar');
              }),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      } else if (datauser[0]['notif'] == 'NoPassword') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("_isLoggedIn", false);
        setState(() {
          _isInAsyncCall = false;
        });
        SnackBar snackBar = SnackBar(
          content: Text(
            'Password tidak di temukan',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                print('ULANGI snackbar');
              }),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("_isLoggedIn", true);
        String userStatus = 'Admin';
        setState(() {
          _isInAsyncCall = false;
        });
        setState(() {
          pref.setString('userStatus', userStatus);
          pref.setString('userAdmin', datauser[0]['user_name']);
          pref.setString('status', datauser[0]['status']);
          pref.setString('IdDesa', datauser[0]['id_desa']);
          username = datauser[0]['user_name'];
          Navigator.pushReplacementNamed(context, '/Haldua');
        });
        print(datauser[0]);
      }
    });

    /*if (datauser[0]['status'] == '01') {
          print("Welcome Admin");
        } else if (datauser[0]['status'] == '02') {
          print("Welcome Penulis");
        }*/
  }

  bool _rememberMe = false;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: user,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your Username',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: pass,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {},
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Lupa Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  /*Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }
*/
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _login();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  /*Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }*/

  /* Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }*/

  /* Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }*/

  /*Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFee002d),
                        Color(0xFFe3002a),
                        Color(0xFFd90028),
                        Color(0xFFcc0025),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 80.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /* Image.asset(
                          'assets/images/dokar.png',
                          width: 100.0,
                          height: 100.0,
                        ),*/
                        Text(
                          'Login Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                        //_buildRememberMeCheckbox(),
                        _buildLoginBtn(),
                        /*Text(
                        msg,
                        style: TextStyle(fontSize: 20.0, color: Colors.red),
                      )*/
                        // _buildSignInWithText(),
                        // _buildSocialBtnRow(),
                        //_buildSignupBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
