import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:PixLeZ/data/state_notifier.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

class SettingsStarter extends StatefulWidget {
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
    var _ipController = new TextEditingController(
        text: Provider.of<StateNotifier>(context, listen: false).ip);
    var _pixelCountController = new TextEditingController(
        text: Provider.of<StateNotifier>(context, listen: false)
            .maxPixel
            .toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('PixLeZ - Settings'),
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
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.airplay),
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
              padding: EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _pixelCountController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.adjust),
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
                      final snackBar =
                          SnackBar(content: Text('Invalid Pixel input.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                },
              ),
            ),
          ),
          Spacer(
            flex: 7,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigator(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
