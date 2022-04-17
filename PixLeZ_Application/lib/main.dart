import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:PixLeZ/data/state_notifier.dart';
import 'package:PixLeZ/data/color_theme.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  Hive.registerAdapter(ColThemeConfigurationAdapter());
  await Hive.openBox('ColTheme');
  runApp(
    ChangeNotifierProvider(
      create: (context) => StateNotifier(),
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PixLeZ',
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        bottomAppBarColor: Colors.orangeAccent,
        indicatorColor: Colors.orangeAccent,
        scaffoldBackgroundColor: Colors.grey[700], colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orangeAccent),
      ),
      home: Scaffold(
        // https://stackoverflow.com/questions/46551268/when-the-keyboard-appears-the-flutter-widgets-resize-how-to-prevent-this
        // Alternative: SingleChildScrollView
        // android:windowSoftInputMode="adjustResize" - to the <Activity> tag in the AndroidManifest.xml
        // resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,

        drawer: AppDrawer(),
        body: Container(
          // margin: EdgeInsets.all(10.0),
          // padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          child: AppDrawer(),
          alignment: Alignment(-1.0, 0.0),
        ),
        bottomNavigationBar: CustomBottomNavigator(),
      ),
    );
  }
}
