import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:pixlez/data/state_notifier.dart';

import 'package:pixlez/app_theme/bottom_navigator.dart';
import 'package:pixlez/app_theme/app_drawer.dart';

class SettingsStarter extends StatefulWidget {
  const SettingsStarter({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SettingsStarter>
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
    var ipController = TextEditingController(
        text: Provider.of<StateNotifier>(context, listen: false).ip);
    var pixelCountController = TextEditingController(
        text: Provider.of<StateNotifier>(context, listen: false)
            .maxPixel
            .toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('PixLeZ - Settings'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: ipController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.airplay, color: Colors.lightBlueAccent,),
                  labelText: 'Ip-Address',
                  border: OutlineInputBorder(),
                ),
                // maxLength: 20,
                // textInputAction: TextInputAction.send,
                onSubmitted: (text) {
                  setState(() {
                    Provider.of<StateNotifier>(context, listen: false)
                        .setIp(text);
                    sendRequest('/status');
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: pixelCountController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.adjust, color: Colors.lightBlueAccent,),
                  labelText: 'Max Pixel',
                  border: OutlineInputBorder(),
                ),
                // maxLength: 20,
                // textInputAction: TextInputAction.send,
                onSubmitted: (text) {
                  setState(() {
                    try {
                      Provider.of<StateNotifier>(context, listen: false)
                          .setMaxPixel(int.parse(text));
                    } on FormatException {
                      const snackBar =
                          SnackBar(content: Text('Invalid Pixel input.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                },
              ),
            ),
          ),
          const Spacer(
            flex: 7,
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigator(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
