import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

class HelpStarter extends StatefulWidget {
  _HelpStarterState createState() => _HelpStarterState();
}

class _HelpStarterState extends State<HelpStarter>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('PixLeZ - Documentation'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.orange],
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: rootBundle.loadString("lib/assets/help_overview.md"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data,
              onTapLink: (text, href, title) => launch(text),
              styleSheet: MarkdownStyleSheet(
                  // h1: TextStyle(color: Colors.orange, fontSize: 40),
                  ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigator(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
