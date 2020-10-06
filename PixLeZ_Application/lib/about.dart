import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:PixLeZ/data/state_notifier.dart';

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
              colors: [Colors.black, Colors.orange],
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: new Container(
                // margin: const EdgeInsets.all(15.0),
                // padding: EdgeInsets.all(10.0),
                alignment: Alignment.topLeft,
                // margin: EdgeInsets.all(10.0),
                // height: 20,
                // width: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Consumer<StateNotifier>(
                      builder: (context, stateN, child) => Text(
                        stateN.about,
                        style: TextStyle(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(
            flex: 3,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigator(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
