//ANCHOR Selesai
import 'dart:io';
import 'package:dokar_aplikasi/hal_pilih_user.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
//NOTE Variabel
  final int _totalPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

//NOTE Inistate
  @override
  void initState() {
    super.initState();
    setValue();
  }

//NOTE Fungsi set value count
  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    int launchCount = prefs.getInt('counter') ?? 0;
    prefs.setInt('counter', launchCount + 1);
    if (launchCount == 0) {
      print("first launch");
    } else {
      print("Not first launch");
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new PilihAKun()));
    }
  }

//NOTE Widget indicator next
  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

//NOTE Scaffold
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: SizeConfig.safeBlockVertical * 100,
        width: SizeConfig.safeBlockHorizontal * 100,
        child: Container(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              _currentPage = page;
              setState(() {});
            },
            children: <Widget>[
              _buildPageContent(
                  image: 'assets/images/boarding1.png',
                  title: 'Posting Informasi Dimana Saja',
                  body:
                      'Admin DOKAR bisa memposting informasi desa dan kelurahan lewat smartphone anda dimanapun dan kapanpun'),
              _buildPageContent(
                  image: 'assets/images/boarding2.png',
                  title: 'Dashboard Informasi Terintegrasi',
                  body:
                      'Semua informasi desa dan kelurahan jadi satu di dashbord di Kabuaten Kendal, memudahkan masayarakat melihat dalam satu portal informasi'),
              _buildPageContent(
                  image: 'assets/images/boarding3.png',
                  title: 'Terintegrasi data OPD',
                  body:
                      'Terintegrasi dengan OPD terkait untuk menyediakan data realtime tanpa perlu mengimputkan informasi')
            ],
          ),
        ),
      ),
      bottomSheet: _currentPage != 2
          ? Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      _pageController.animateToPage(2,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.yellow[700],
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    ),
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Row(children: [
                      for (int i = 0; i < _totalPages; i++)
                        i == _currentPage
                            ? _buildPageIndicator(true)
                            : _buildPageIndicator(false)
                    ]),
                  ),
                  TextButton(
                    onPressed: () {
                      _pageController.animateToPage(_currentPage + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                      setState(() {});
                    },
                    // splashColor: Colors.blue[50],
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.yellow[700],
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    ),
                    child: Text(
                      'Lanjut',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          : InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => new PilihAKun()));
              },
              child: Container(
                height: Platform.isIOS ? 70 : 60,
                color: Colors.yellow[700],
                alignment: Alignment.center,
                child: Text(
                  'Ayo Lihat Berita',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
    );
  }

//NOTE Widet page content
  Widget _buildPageContent({
    String image,
    String title,
    String body,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 30.0),
              child: Image.asset(
                image,
                width: 250,
                height: 250,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: AutoSizeText(
              title,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 22,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              body,
              style: TextStyle(fontSize: 16, height: 2.0),
            ),
          ),
        ],
      ),
    );
  }
}
