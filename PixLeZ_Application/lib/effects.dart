import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:PixLeZ/data/state_notifier.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

class EffectsStarter extends StatefulWidget {
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EffectsStarter>
    with AutomaticKeepAliveClientMixin {
  List<String> _effectTitle = [
    'Shine',
    'Walking Pixels',
    'Walking Pixels reverse',
    'Fill it',
    'Get empty',
    'Final countdown',
    'Pulsing Pixels',
    'Dim Off',
    'Rainbow Mode',
    'Rainbow Walk',
    'Rainbow Pulse',
    'Cyclone Pixels',
    'Twinkle It',
    'Twinkle It Colorful',
    'The Sparkle Pixels',
    'Snow Sparkling',
    'Pixel Runner',
    'Theater Chase Pixels',
    'Bouncing Pixels'
  ];
  List<String> _effectDescription = [
    'Switching all Pixels on',
    'Pixels walking to one side',
    'Pixels walking to the other side',
    'Insort the selected number of Pixels',
    'And the Pixels are going away',
    'Countdown with red Pixels',
    'Pulsating Pixels everywhere',
    'Dim the Pixels off',
    'The Pixels change in the Spectrum of the Rainbow',
    'Pixels walking in the Spectrum of the Rainbow',
    'Pixels pulsing in the Spectrum of the Rainbow',
    'Pixels making a huge Cyclone',
    'Pixels can twinkle',
    'Pixels can twinkle in different colors',
    'What a sparkle Pixel',
    'Feeling like snowin',
    'They are running very fast',
    'Maybe Pixels visited a Theater',
    'And they bounce to center and back'
  ];
  List<IconData> _effectIcon = [
    Icons.flare,
    Icons.directions_walk,
    Icons.undo,
    Icons.format_color_fill,
    Icons.hourglass_empty,
    Icons.slow_motion_video,
    Icons.brightness_high,
    Icons.flight_land,
    Icons.whatshot,
    Icons.trip_origin,
    Icons.wifi_tethering,
    Icons.beach_access,
    Icons.blur_on,
    Icons.blur_circular,
    Icons.grain,
    Icons.ac_unit,
    Icons.threesixty,
    Icons.theaters,
    Icons.bubble_chart
  ];
  /*
  List<int> _effectMap = [
    5,
    10,
    11,
    15,
    16,
    20,
    30,
    40,
    51,
    52,
    53,
    60,
    61,
    62,
    63,
    64,
    65,
    66,
    69
  ];
  */

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
        title: Text('PixLeZ - Effects'),
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
      body: _myListView(),
      bottomNavigationBar: CustomBottomNavigator(),
    );
  }

  Widget _myListView() {
    return ListView.builder(
      itemCount: _effectTitle.length,
      itemBuilder: (context, index) {
        final itemTitle = _effectTitle[index];
        final itemDesc = _effectDescription[index];
        final itemIcon = _effectIcon[index];

        return Card(
          margin: EdgeInsets.all(10.0),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            leading: Icon(itemIcon, color: Colors.lightBlueAccent),
            title: Text(itemTitle),
            subtitle: Text(itemDesc),
            trailing: Consumer<StateNotifier>(
              builder: (context, stateN, child) => Icon(
                stateN.effect == index ? Icons.pets : null,
                color: Colors.redAccent,
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
                    .setEffect(index);
                Provider.of<StateNotifier>(context, listen: false).setMode(-1);
                // String eff = '/select/effect/' + _effectMap[index].toString();
                String eff = '/select/effect/' + index.toString();
                sendRequest(eff);
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
