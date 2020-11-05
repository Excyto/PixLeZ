import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:PixLeZ/data/state_notifier.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

class ConfigurationStarter extends StatefulWidget {
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ConfigurationStarter>
    with AutomaticKeepAliveClientMixin {
  double _valR = 0;
  double _valG = 0;
  double _valB = 0;
  double _valR_src = 0;
  double _valG_src = 0;
  double _valB_src = 0;
  double _valAlpha = 100;

  var _numController = TextEditingController();
  var _timeController = TextEditingController();
  var _timerController = TextEditingController();

  sendRequest(String res) async {
    String ipAd = Provider.of<StateNotifier>(context, listen: false).ip;
    String url = ipAd + res;
    http.Response response;
    try {
      response = await http.get(url);
      if (response.statusCode != 200) {
        Provider.of<StateNotifier>(context, listen: false).setRunning(0);
        Provider.of<StateNotifier>(context, listen: false).setConnected(false);
      } else {
        Provider.of<StateNotifier>(context, listen: false).setConnected(true);
        if (res.contains('start')) {
          Provider.of<StateNotifier>(context, listen: false).setRunning(1);
        }
        if (res.contains('stop')) {
          Provider.of<StateNotifier>(context, listen: false).setRunning(0);
        }
        if (res.contains('status')) {
          String answ = response.body.toString();
          var arr = answ.split(';');
          var col = arr[0].split('=');
          var time = arr[1].split('=');
          var timer = arr[2].split('=');
          var numb = arr[3].split('=');
          var mod = arr[4].split('=');
          var eff = arr[5].split('=');
          var proc = arr[6].split('=');

          var color = Color(int.parse(col[1].toString(), radix: 16));

          setState(() {
            //print(color);
            _valR = _valR_src = double.parse(color.red.toString());
            _valG = _valG_src = double.parse(color.green.toString());
            _valB = _valB_src = double.parse(color.blue.toString());
            _timeController.text = double.parse(time[1].toString()).toString();
            _timerController.text =
                double.parse(timer[1].toString()).toString();
            _numController.text = int.parse(numb[1].toString()).toString();
            Provider.of<StateNotifier>(context, listen: false)
                .setMode(int.parse(mod[1].toString()));
            Provider.of<StateNotifier>(context, listen: false)
                .setEffect(int.parse(eff[1].toString()));
            if (proc[1].toString().toLowerCase().contains('true')) {
              Provider.of<StateNotifier>(context, listen: false).setRunning(1);
            } else {
              Provider.of<StateNotifier>(context, listen: false).setRunning(0);
            }
          });
        }
      }
    } catch (e) {
      Provider.of<StateNotifier>(context, listen: false).setRunning(0);
      Provider.of<StateNotifier>(context, listen: false).setConnected(false);
      return;
    }
  }

  @override
  void initState() {
    sendRequest("/status");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('PixLeZ - Controller'),
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
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.red[700],
                inactiveTrackColor: Colors.red[100],
                thumbColor: Colors.redAccent,
                overlayColor: Colors.red.withAlpha(32),
              ),
              child: Slider(
                min: 0,
                max: 255,
                value: _valR_src,
                onChanged: (value) {
                  setState(() {
                    _valR_src = value;
                    _valR = _valR_src * (_valAlpha / 100);
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.green[700],
                inactiveTrackColor: Colors.green[100],
                thumbColor: Colors.greenAccent,
                overlayColor: Colors.green.withAlpha(32),
              ),
              child: Slider(
                min: 0,
                max: 255,
                value: _valG_src,
                onChanged: (value) {
                  setState(() {
                    _valG_src = value;
                    _valG = _valG_src * (_valAlpha / 100);
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blue[700],
                inactiveTrackColor: Colors.blue[100],
                thumbColor: Colors.blueAccent,
                overlayColor: Colors.blue.withAlpha(32),
              ),
              child: Slider(
                min: 0,
                max: 255,
                value: _valB_src,
                onChanged: (value) {
                  setState(() {
                    _valB_src = value;
                    _valB = _valB_src * (_valAlpha / 100);
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[200],
                thumbColor: Colors.grey[400],
                overlayColor: Colors.white.withAlpha(32),
              ),
              child: Slider(
                min: 0,
                max: 100,
                label: 'Intensity',
                value: _valAlpha,
                onChanged: (value) {
                  setState(() {
                    _valAlpha = value;
                    _valB = _valB_src * (_valAlpha / 100);
                    _valG = _valG_src * (_valAlpha / 100);
                    _valR = _valR_src * (_valAlpha / 100);
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                          // O anpassen
                          _valR.round(),
                          _valG.round(),
                          _valB.round(),
                          0.8),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text('R ' +
                      _valR.round().toString() +
                      ', G ' +
                      _valG.round().toString() +
                      ', B ' +
                      _valB.round().toString()),
                  //state.address.ip),
                ),
                Spacer(
                  flex: 1,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ButtonBar(
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Set Color'),
                          onPressed: () {
                            int r = _valR.round();
                            int g = _valG.round();
                            int b = _valB.round();

                            String re = r.toRadixString(16);
                            String gr = g.toRadixString(16);
                            String bl = b.toRadixString(16);

                            if (re.length == 1) {
                              re = '0' + re;
                            }
                            if (gr.length == 1) {
                              gr = '0' + gr;
                            }
                            if (bl.length == 1) {
                              bl = '0' + bl;
                            }
                            String ges = re + gr + bl;
                            ges = ges.toUpperCase();
                            String req = '/set/color/' + ges;
                            sendRequest(req);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _numController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.polymer),
                  labelText: 'Number in x',
                  border: OutlineInputBorder(),
                ),
                // maxLength: 20,
                // textInputAction: TextInputAction.send,
                onSubmitted: (text) {
                  try {
                    var n = int.parse(text);
                    setState(() {
                      String req =
                          '/set/number/' + int.parse(n.toString()).toString();
                      sendRequest(req);
                    });
                  } on FormatException {
                    _numController.text = '-1';
                    final snackBar = SnackBar(
                        content: Text('Please enter a decimal number.'));
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _timeController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.timelapse),
                  labelText: 'Time in sec',
                  border: OutlineInputBorder(),
                ),
                // maxLength: 20,
                // textInputAction: TextInputAction.send,
                onSubmitted: (text) {
                  try {
                    double d = double.parse(text);
                    if (!d.toString().contains('.')) {
                      text = text + '.0';
                    }
                    setState(() {
                      String req = '/set/time/' + text;
                      sendRequest(req);
                    });
                  } on FormatException {
                    setState(() {
                      _timeController.text = '-1';
                      final snackBar = SnackBar(
                          content: Text('Please enter a decimal number.'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _timerController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.timer),
                  labelText: 'Timer in sec',
                  border: OutlineInputBorder(),
                ),
                // maxLength: 20,
                // textInputAction: TextInputAction.send,
                onSubmitted: (text) {
                  try {
                    double d = double.parse(text);
                    if (!d.toString().contains('.')) {
                      text = text + '.0';
                    }
                    setState(() {
                      String req = '/set/timer/' + text;
                      sendRequest(req);
                    });
                  } on FormatException {
                    setState(() {
                      _timerController.text = '-1';
                      final snackBar = SnackBar(
                          content: Text('Please enter a decimal number.'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ButtonBar(
                children: <Widget>[
                  new RaisedButton(
                    child: Text('Update'),
                    onPressed: () {
                      sendRequest("/status");
                    },
                  ),
                  new RaisedButton(
                    child: Text('Restart'),
                    onPressed: () {
                      setState(
                        () {
                          String req = '/select/mode/' +
                              Provider.of<StateNotifier>(context, listen: false)
                                  .mode
                                  .toString();
                          sendRequest(req);
                          req = '/select/effect/' +
                              Provider.of<StateNotifier>(context, listen: false)
                                  .effect
                                  .toString();
                          sendRequest(req);
                        },
                      );
                    },
                  ),
                  new RaisedButton(
                    child: Text('Start'),
                    onPressed: () {
                      sendRequest("/start");
                    },
                  ),
                  new RaisedButton(
                    child: Text('Stop'),
                    onPressed: () {
                      sendRequest("/stop");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigator(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
