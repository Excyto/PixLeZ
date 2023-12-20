import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:pixlez/app_theme/bottom_navigator.dart';
import 'package:pixlez/app_theme/app_drawer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutStarter extends StatefulWidget {
  const AboutStarter({super.key});

  @override
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
        title: const Text('PixLeZ - About'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Colors.redAccent, Colors.lightGreenAccent, Colors.lightBlueAccent]
              )
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: rootBundle.loadString("lib/assets/about_page.md"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data.toString(),
              onTapLink: (text, href, title) => launchUrlString(text),
              styleSheet: MarkdownStyleSheet(
                  // h1: TextStyle(color: Colors.orange, fontSize: 40),
                  ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigator(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
