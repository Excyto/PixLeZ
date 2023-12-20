import 'package:flutter/material.dart';

import 'package:pixlez/settings.dart';
import 'package:pixlez/effects.dart';
import 'package:pixlez/modes.dart';
import 'package:pixlez/configuration.dart';
import 'package:pixlez/color_theme_config.dart';
import 'package:pixlez/about.dart';
import 'package:pixlez/help.dart';
import 'package:pixlez/page_license.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Colors.redAccent, Colors.lightGreenAccent, Colors.lightBlueAccent]
                )
            ),
            child: Stack(
              children: <Widget>[
                const Positioned(
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
          const Divider(),
          ListTile(
            title: const Row(
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
                    builder: (BuildContext context) => const ConfigurationStarter())),
          ),
          const Divider(),
          ListTile(
            title: const Row(
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
                    builder: (BuildContext context) => const ColorTheme())),
          ),
          const Divider(),
          ListTile(
            title: const Row(
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
                    builder: (BuildContext context) => const EffectsStarter())),
          ),
          ListTile(
            title: const Row(
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
                    builder: (BuildContext context) => const ModesStarter())),
          ),
          const Divider(),
          ListTile(
            title: const Row(
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
                    builder: (BuildContext context) => const SettingsStarter())),
          ),
          const Divider(),
          ListTile(
            title: const Row(
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
                    builder: (BuildContext context) => const HelpStarter())),
          ),
          ListTile(
            title: const Row(
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
                    builder: (BuildContext context) => const AboutStarter())),
          ),
          ListTile(
            title: const Row(
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
                    builder: (BuildContext context) => const LicenseStarter())),
          ),
        ],
      ),
    );
  }
}
