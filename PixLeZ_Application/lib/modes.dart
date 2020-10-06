import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:PixLeZ/data/state_notifier.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

class ModesStarter extends StatefulWidget {
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ModesStarter>
    with AutomaticKeepAliveClientMixin {
  List<String> _modeTitle = [
    'Shine It',
    'Chill Mode',
    'Color Theme',
    'No Effect'
  ];
  List<String> _modeDescription = [
    'Normal light Pixel mode',
    'Chillin with the Pixels',
    'Use your custom color Pixel theme',
    'Nope, not today'
  ];
  List<IconData> _modeIcon = [
    Icons.local_florist,
    Icons.weekend,
    Icons.center_focus_strong,
    Icons.no_encryption
  ];

  sendRequest(String res) async {
    String url =
        Provider.of<StateNotifier>(context, listen: false).ip.toString() + res;
    try {
      await http.get(url);
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
        title: Text('PixLeZ - Modes'),
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
      itemCount: _modeTitle.length,
      itemBuilder: (context, index) {
        final itemTitle = _modeTitle[index];
        final itemDesc = _modeDescription[index];
        final itemIcon = _modeIcon[index];

        return Card(
          margin: EdgeInsets.all(10.0),
          child: ListTile(
            leading: Icon(itemIcon),
            title: Text(itemTitle),
            subtitle: Text(itemDesc),
            trailing: Consumer<StateNotifier>(
              builder: (context, stateN, child) => Icon(
                stateN.mode == index ? Icons.pets : null,
              ),
            ),
            onTap: () {
              setState(() {
                //titles.insert(index, 'Planet');
              });
            },
            onLongPress: () {
              setState(() {
                Provider.of<StateNotifier>(context, listen: false)
                    .setMode(index);
                Provider.of<StateNotifier>(context, listen: false)
                    .setEffect(-1);
                String mo = '/select/mode/' + index.toString();
                sendRequest(mo);
              });
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
