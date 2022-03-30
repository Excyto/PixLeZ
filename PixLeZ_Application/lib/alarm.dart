import 'dart:convert';

import 'package:PixLeZ/data/AlarmEntry.dart';
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

  List<AlarmEntry> alarmEntries = List.empty();

  getAlarms(String res) async {
    String url =
        Provider.of<StateNotifier>(context, listen: false).ip.toString() + res;
    http.Response response;
    try {
      response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        Provider.of<StateNotifier>(context, listen: false).setRunning(0);
        Provider.of<StateNotifier>(context, listen: false).setConnected(false);
      } else {
        Provider.of<StateNotifier>(context, listen: false).setConnected(true);
        final parsedJson = jsonDecode(response.body.toString());
        final alarmEntries = AlarmEntry.listFromJson(parsedJson);
        // TODO: How to reload UI?
        return alarmEntries;
      }
    } catch (e) {
      Provider.of<StateNotifier>(context, listen: false).setRunning(0);
      Provider.of<StateNotifier>(context, listen: false).setConnected(false);
      return;
    }
  }

  @override
  void initState() {
    alarmEntries = getAlarms("/alarms");
    super.initState();
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
      body: _myListView(),
      bottomNavigationBar: CustomBottomNavigator(),
    );
  }

  Widget _myListView() {
    return ListView.builder(
      itemCount: alarmEntries.length,
      itemBuilder: (context, index) {
        var entry = alarmEntries[index];
        return Card(
          margin: EdgeInsets.all(10.0),
          child: ListTile(
            leading: Icon(Icons.alarm),
            title: Text(entry.name),
            subtitle: Text(entry.dayNames.toString()),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
