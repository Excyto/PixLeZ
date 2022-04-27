import 'package:flutter/material.dart';

import 'package:PixLeZ/settings.dart';
import 'package:PixLeZ/effects.dart';
import 'package:PixLeZ/modes.dart';
import 'package:PixLeZ/configuration.dart';
import 'package:PixLeZ/color_theme_config.dart';
import 'package:PixLeZ/about.dart';
import 'package:PixLeZ/help.dart';
import 'package:PixLeZ/page_license.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Colors.redAccent, Colors.lightGreenAccent, Colors.lightBlueAccent]
                )
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 12.0,
                  left: 55.0,
                  child: Text(
                    "ixLeZ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                  bottom:20,
                  left:16,
                  child: Image.asset('lib/assets/icon/icon_fit.png', width: 50, height: 50,)
                )
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.looks),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Controller'),
                )
              ],
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => ConfigurationStarter())),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.whatshot),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Custom Themes'),
                )
              ],
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => ColorTheme())),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.landscape),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Effects'),
                )
              ],
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => EffectsStarter())),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.blur_on),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Modes'),
                )
              ],
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => ModesStarter())),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.settings),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Settings'),
                )
              ],
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => SettingsStarter())),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.help_outline),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Documentation'),
                )
              ],
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => HelpStarter())),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.info_outline),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('About'),
                )
              ],
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => AboutStarter())),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.receipt_long_rounded),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Licenses'),
                )
              ],
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => LicenseStarter())),
          ),
        ],
      ),
    );
  }
}
