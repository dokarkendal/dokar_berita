import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

import '../style/styleset.dart';

class Version extends StatefulWidget {
  // Version({
  //   Key key,
  //   this.width,
  //   this.height,
  // }) : super(key: key);

  // final double width;
  // final double height;

  @override
  State<Version> createState() => _VersionState();
}

class _VersionState extends State<Version> {
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        // centerTitle: true,
        title: Text(
          "ABOUT APP",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _infoTile('App name', _packageInfo.appName),
          // _infoTile('Package name', _packageInfo.packageName),
          _infoTile('App version', _packageInfo.version),
          _infoTile('Build number', _packageInfo.buildNumber),
          // _infoTile('Build signature', _packageInfo.buildSignature),
        ],
      ),
    );
  }
}
