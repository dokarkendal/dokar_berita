import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:dokar_aplikasi/style/constants.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final passController = TextEditingController();

  bool isLogin = false;

  String name = '';
  String pass = '';
  String msg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: formKey,
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
                      vertical: 120.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/dokar.png',
                          width: 100.0,
                          height: 100.0,
                        ),
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
                        _username(context),
                        SizedBox(
                          height: 30.0,
                        ),
                        _password(context),
                        _buildForgotPasswordBtn(context),
                        _buttonLogin(context),
                        Text(
                          msg,
                          style: TextStyle(fontSize: 20.0, color: Colors.red),
                        )
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

  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin")) {
      Navigator.pushReplacementNamed(context, '/AdminTes');
    }
  }

  String validatePass(String value) {
    if (value.isEmpty) {
      return 'Password harus diisi';
    }
    return null;
  }

  String validateUser(String value) {
    if (value.isEmpty) {
      return 'User harus diisi';
    }
    return null;
  }

  void submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(nameController.value.text);

      if (nameController.value.text == "2000") {
        if (passController.value.text == "1234") {
          SharedPreferences pref = await SharedPreferences.getInstance();
          // pref.setString("userName", nameController.value.text);
          pref.setBool("isLogin", true);

          //pindah form
          Navigator.pushReplacementNamed(context, '/AdminTes');
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("isLogin", false);

          SnackBar snackBar = SnackBar(
            content: Text(
              'Password Salah',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      } else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("isLogin", false);
        SnackBar snackBar = SnackBar(
          content: Text(
            'Username salah',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  Widget _username(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //padding: EdgeInsets.all(8.0),
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
          child: TextFormField(
            controller: nameController,
            validator: validateUser,
            onSaved: (String value) {
              name = value;
            },
            key: Key('username'),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'username',
              hintStyle: kHintTextStyle,
            ),
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _password(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //padding: EdgeInsets.all(8.0),
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
          child: TextFormField(
            controller: passController,
            validator: validatePass,
            onSaved: (String value) {
              name = value;
            },
            key: Key('password'),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'password',
              hintStyle: kHintTextStyle,
            ),
            style: TextStyle(fontSize: 20.0, color: Colors.white),
            obscureText: true,
          ),
        ),
      ],
    );
    /*return Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          controller: passController,
          validator: validatePass,
          onSaved: (String value) {
            pass = value;
          },
          key: Key('password'),
          decoration:
              InputDecoration(hintText: 'password', labelText: 'password'),
          style: TextStyle(fontSize: 20.0, color: Colors.black),
          obscureText: true,
        ));*/
  }

  Widget _buildForgotPasswordBtn(BuildContext context) {
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

  Widget _buttonLogin(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: InkWell(
        onTap: () {
          submit();
        },
        child: new Container(
          height: 55.0,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(30.0),
          ),
          child: new Center(
            child: new Text(
              'LOGIN',
              style: new TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
