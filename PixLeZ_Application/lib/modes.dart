import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:pixlez/data/state_notifier.dart';

import 'package:pixlez/app_theme/bottom_navigator.dart';
import 'package:pixlez/app_theme/app_drawer.dart';

class ModesStarter extends StatefulWidget {
  const ModesStarter({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ModesStarter>
    with AutomaticKeepAliveClientMixin {
  final List<String> _modeTitle = [
    'Shine It',
    'Chill Mode',
    'Color Theme',
    'No Effect'
  ];
  final List<String> _modeDescription = [
    'Normal light Pixel mode',
    'Chillin with the Pixels',
    'Use your custom color Pixel theme',
    'Nope, not today'
  ];
  final List<IconData> _modeIcon = [
    Icons.local_florist,
    Icons.weekend,
    Icons.center_focus_strong,
    Icons.no_encryption
  ];

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
        title: const Text('PixLeZ - Modes'),
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
      body: _myListView(),
      bottomNavigationBar: const CustomBottomNavigator(),
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
          margin: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: Icon(itemIcon, color: Colors.lightBlueAccent,),
            title: Text(itemTitle),
            subtitle: Text(itemDesc),
            trailing: Consumer<StateNotifier>(
              builder: (context, stateN, child) => Icon(
                stateN.mode == index ? Icons.pets : null,
                color: Colors.greenAccent,
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
                String mo = '/select/mode/$index';
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
