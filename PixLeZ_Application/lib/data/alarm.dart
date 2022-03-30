import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:PixLeZ/data/state_notifier.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

class AlarmStarter extends StatefulWidget {
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AlarmStarter>
    with AutomaticKeepAliveClientMixin {

  sendRequest(String res) async {
    String url =
        Provider.of<StateNotifier>(context, listen: false).ip.toString() + res;
    try {
      await http.get(Uri.parse(url));
      Provider.of<StateNotifier>(context, listen: false).setConnected(true);
    } catch (e) {
      Provider.of<StateNotifier>(context, listen: false).setRunning(0);
      Provider.of<StateNotifier>(context, listen: false).setConnected(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('PixLeZ - Light Alarm Clock'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.orange],
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: CustomBottomNavigator(),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
