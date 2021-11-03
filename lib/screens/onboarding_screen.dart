import 'dart:io';
import 'package:dokar_aplikasi/pilih_akun.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final int _totalPages = 3;
  // ignore: unused_field
  bool _isInAsyncCall = true;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    setValue();
  }

  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    int launchCount = prefs.getInt('counter') ?? 0;
    prefs.setInt('counter', launchCount + 1);
    if (launchCount == 0) {
      print("first launch"); //setState to refresh or move to some other page
    } else {
      print("Not first launch");
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new PilihAKun()));
    }
  }

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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: SizeConfig.safeBlockVertical * 100, //10 for example
        width: SizeConfig.safeBlockHorizontal * 100, //10 for example
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
                  title: 'Posting berita kapanpun dan dimanapun.',
                  body:
                      'Anda bisa memposting berita dan kegiatan desa di smartphone maupun komputer anda dimanapun dan kapanpun ada berita'),
              _buildPageContent(
                  image: 'assets/images/boarding2.png',
                  title: 'Memiliki dashbord di Kabupaten Kendal',
                  body:
                      'Semua informasi desa akan jadi satu di dashbord kabuaten untuk memudahkan masayarakat melihat informasi desa dalam satu wadah'),
              _buildPageContent(
                  image: 'assets/images/boarding3.png',
                  title: 'Terintegrasi dengan OPD Terkait.',
                  body:
                      'Aplikasi dokar terintegrasi dengan OPD terkait untuk menyediakan data realtime tanpa desa perlu mengimputkan')
            ],
          ),
        ),
      ),
      bottomSheet: _currentPage != 2
          ? Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      _pageController.animateToPage(2,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                      setState(() {});
                    },
                    splashColor: Colors.blue[50],
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                          color: Colors.blue,
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
                  FlatButton(
                    onPressed: () {
                      _pageController.animateToPage(_currentPage + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                      setState(() {});
                    },
                    splashColor: Colors.blue[50],
                    child: Text(
                      'Lanjut',
                      style: TextStyle(
                          color: Colors.blue,
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
                color: Colors.blue[800],
                alignment: Alignment.center,
                child: Text(
                  'Ayo Lihat Berita',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
    );
  }

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
              child: Image.asset(image),
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
                  fontSize: 20, height: 1.5, fontWeight: FontWeight.w600),
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
