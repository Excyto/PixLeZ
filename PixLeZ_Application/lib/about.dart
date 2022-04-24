import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

class AboutStarter extends StatefulWidget {
  _AboutStarterState createState() => _AboutStarterState();
}

class _AboutStarterState extends State<AboutStarter>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('PixLeZ - About'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Colors.redAccent, Colors.lightGreenAccent, Colors.lightBlueAccent]
              )
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: rootBundle.loadString("lib/assets/about_page.md"),
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
