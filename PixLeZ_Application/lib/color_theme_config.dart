import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:collection/collection.dart';

import 'dart:convert';

import 'package:PixLeZ/data/state_notifier.dart';

import 'package:PixLeZ/app_theme/bottom_navigator.dart';
import 'package:PixLeZ/app_theme/app_drawer.dart';

import 'package:PixLeZ/data/color_theme.dart';

// Main Widget
class ColorTheme extends StatefulWidget {
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ColorTheme>
    with AutomaticKeepAliveClientMixin {
  // Important Links
  // https://stackoverflow.com/questions/58416557/flutter-find-color-between-two-colors-depending-on-the-value
  // https://dev.to/mightytechno/how-to-use-gradient-in-flutter-1he1
  // https://flutter.dev/docs/cookbook/persistence/sqlite
  // https://www.digitalocean.com/community/tutorials/flutter-flutter-gradient
  // https://medium.com/@adp4infotech4/flutter-building-a-reorderable-listview-735013719cf3
  // CheatSheet: https://github.com/TakeoffAndroid/flutter-examples

  int _maxPixel;

  //_____________
  // Methods
  //________
  // Picker Dialog
  void _showPickerDialog(int _index) async {
    ColThemeEntry tmp;
    if (_index == -1) {
      tmp = null;
    } else {
      tmp = Provider.of<StateNotifier>(context, listen: false)
          .activConfig
          .entries[_index];
    }
    final colThemeEntry = await showDialog<ColThemeEntry>(
      context: context,
      builder: (context) => PickerDialog(entry: tmp),
    );

    if (colThemeEntry != null) {
      setState(() {
        if (_index == -1) {
          for (var item in Provider.of<StateNotifier>(context, listen: false)
              .activConfig
              .entries) {
            if (item.pos == colThemeEntry.pos) {
              return;
            }
          }
          Provider.of<StateNotifier>(context, listen: false)
              .activConfig
              .entries
              .add(colThemeEntry);
          Provider.of<StateNotifier>(context, listen: false)
              .activConfig
              .entries
              .sort((a, b) => a.pos.compareTo(b.pos));
        } else {
          Provider.of<StateNotifier>(context, listen: false)
              .activConfig
              .entries
              .removeAt(_index);
          Provider.of<StateNotifier>(context, listen: false)
              .activConfig
              .entries
              .add(colThemeEntry);
          Provider.of<StateNotifier>(context, listen: false)
              .activConfig
              .entries
              .sort((a, b) => a.pos.compareTo(b.pos));
        }
      });
    }
    _updateColorPreview();
  }

  // Save Dialog
  void _showSaveDialog() async {
    await showDialog<ColThemeConfiguration>(
      context: context,
      builder: (context) => SaverDialog(),
    );
  }

  // Load Dialog
  void _showLoadDialog() async {
    await showDialog(
      context: context,
      builder: (context) => LoaderDialog(),
    );
    // print(rec);
    // print(rec.select);
    // print(rec.configList[rec.select]);
    setState(() {
      if (Provider.of<StateNotifier>(context, listen: false).selectedConfig ==
          -1) {
        _clearActuallConfig();
      }
      _updateColorPreview();
    });
  }

  // rgb to Hex
  String _rgbToHex(int r, int g, int b) {
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
    return ges;
  }

  // clear Lists
  void _clearActuallConfig() {
    Provider.of<StateNotifier>(context, listen: false).setActivConfig(
        new ColThemeConfiguration([], [],
            List.filled(_maxPixel, "0x000000"), ''));
  }

  // update Color Preview
  _updateColorPreview() async {
    int actionState = 0;
    ColThemeEntry tmp;
    ColThemeEntry tmpNext;
    int range = 0;
    double steps = 0;
    List<String> _pixelListTmp = List.filled(_maxPixel, "0x000000");
    List<Color> _colListTmp = [];
    // action 1 = pixel flow
    // action 2 = pixel static
    // action 3 = pixel static floating

    for (int i = 0;
        i <
            Provider.of<StateNotifier>(context, listen: false)
                .activConfig
                .entries
                .length;
        i++) {
      if (i ==
          Provider.of<StateNotifier>(context, listen: false)
                  .activConfig
                  .entries
                  .length -
              1) {
        tmp = Provider.of<StateNotifier>(context, listen: false)
            .activConfig
            .entries[i];
        tmpNext = new ColThemeEntry(0, 0, 0, _maxPixel, -1);
      } else {
        tmp = Provider.of<StateNotifier>(context, listen: false)
            .activConfig
            .entries[i];
        tmpNext = Provider.of<StateNotifier>(context, listen: false)
            .activConfig
            .entries[i + 1];
      }
      actionState = tmp.action;
      if (actionState == 2) {
        _pixelListTmp[tmp.pos] = _rgbToHex(tmp.colR, tmp.colG, tmp.colB);
        continue;
      }
      range = tmpNext.pos - tmp.pos;
      if (actionState == 3) {
        for (int j = 0; j < range; j++) {
          _pixelListTmp[tmp.pos + j] = _rgbToHex(tmp.colR, tmp.colG, tmp.colB);
        }
        continue;
      }
      Color fromCol = Color.fromRGBO(tmp.colR, tmp.colG, tmp.colB, 1);
      Color toCol = Color.fromRGBO(tmpNext.colR, tmpNext.colG, tmpNext.colB, 1);
      steps = 1.0 / double.parse(range.toString());
      if (actionState == 1) {
        for (int j = 0; j < range; j++) {
          Color lerpCol = Color.lerp(fromCol, toCol, steps * j);
          _pixelListTmp[tmp.pos + j] =
              _rgbToHex(lerpCol.red, lerpCol.green, lerpCol.blue);
        }
      }
    }

    for (int i = 0; i < _pixelListTmp.length; i++) {
      if (_pixelListTmp[i] == null) _pixelListTmp[i] = '000000';
      _colListTmp.add(Color(int.parse("0xff" + _pixelListTmp[i])));
    }

    setState(() {
      Provider.of<StateNotifier>(context, listen: false).activConfig.preview =
          _colListTmp;
      Provider.of<StateNotifier>(context, listen: false).activConfig.send =
          _pixelListTmp;
    });

    // print(_pixelList);
    // print(_pixelListTmp);
    // print(_colList);
    // print(_colListTmp);
  }

  // https://stackoverflow.com/questions/45613160/restful-flask-parsing-json-arrays-with-parse-args?rq=1
  // https://pythonise.com/series/learning-flask/working-with-json-in-flask
  // send the actuall configuration to the Server
  _sendColorRequest() async {
    String res = '/set/pixels';
    // String data = _activConfig.send.toString();
    String url =
        Provider.of<StateNotifier>(context, listen: false).ip.toString() + res;

    String jsonString = jsonEncode(
        Provider.of<StateNotifier>(context, listen: false).activConfig.send);

    print(jsonString);

    var body = json.encode({"pixels": jsonString});

    try {
      // await http.get(url);
      await http
          .post(Uri.parse(url), body: body, headers: {'Content-type': 'application/json'});

      Provider.of<StateNotifier>(context, listen: false).setConnected(true);
    } catch (e) {
      Provider.of<StateNotifier>(context, listen: false).setRunning(0);
      Provider.of<StateNotifier>(context, listen: false).setConnected(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _maxPixel = Provider.of<StateNotifier>(context, listen: false).maxPixel;

    if (Provider.of<StateNotifier>(context, listen: false).activConfig ==
        null) {
      Provider.of<StateNotifier>(context, listen: false).setActivConfig(
          new ColThemeConfiguration([],
              [], List.filled(_maxPixel, "0x000000"), ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('PixLeZ - Custom Themes'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: ButtonBar(
              children: <Widget>[
                new IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'Add entry',
                  onPressed: () => _showPickerDialog(-1),
                ),
                new IconButton(
                  icon: Icon(Icons.clear_all),
                  tooltip: 'New Config',
                  onPressed: () {
                    setState(() {
                      _clearActuallConfig();
                    });
                  },
                ),
                new IconButton(
                  icon: Icon(Icons.bookmark_border),
                  tooltip: 'Load configuration',
                  onPressed: () {
                    _showLoadDialog();
                  },
                ),
                new IconButton(
                  icon: Icon(Icons.attach_file),
                  tooltip: 'Save configuration',
                  onPressed: () {
                    _updateColorPreview();
                    _showSaveDialog();
                    // _clearActuallConfig();
                  },
                ),
                new IconButton(
                  icon: Icon(Icons.publish),
                  tooltip: 'Send configuration',
                  onPressed: () {
                    // _updateColorPreview();
                    _sendColorRequest();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 12,
            child: Consumer<StateNotifier>(
              builder: (context, stateN, child) => ListView.builder(
                itemCount: stateN.activConfig.entries.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    // vertical_align_center
                    // keyboard_arrow_down
                    // last_page
                    // subdirectory_arrow_right
                    // trending_down
                    // trip_origin
                    child: ListTile(
                      leading: stateN.activConfig.entries[index].action == 2
                          ? Icon(Icons.arrow_forward_ios)
                          : (stateN.activConfig.entries[index].action == 1
                              ? Icon(Icons.more_vert)
                              : Icon(Icons.details)),
                      title: stateN.activConfig.entries[index].action == 2
                          ? Text('Static Pixel at pos ' +
                              stateN.activConfig.entries[index].pos.toString())
                          : (stateN.activConfig.entries[index].action == 1
                              ? Text('Flow Pixels from pos ' +
                                  stateN.activConfig.entries[index].pos
                                      .toString())
                              : Text('Static Floating Pixels from pos ' +
                                  stateN.activConfig.entries[index].pos
                                      .toString())),
                      subtitle: Text("Action: " +
                          stateN.activConfig.entries[index].action.toString() +
                          " Position: " +
                          stateN.activConfig.entries[index].pos.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.pets,
                            color: Color.fromRGBO(
                                stateN.activConfig.entries[index].colR,
                                stateN.activConfig.entries[index].colG,
                                stateN.activConfig.entries[index].colB,
                                0.8),
                          ),
                          IconButton(
                            icon: Icon(Icons.clear),
                            tooltip: 'Delete entry',
                            onPressed: () {
                              setState(() {
                                stateN.activConfig.entries.removeAt(index);
                                _updateColorPreview();
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          //titles.insert(index, 'Planet');
                        });
                      },
                      onLongPress: () => _showPickerDialog(index),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Consumer<StateNotifier>(
                builder: (context, stateN, child) => Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // end: Alignment(0.4, 0.0),
                      colors: stateN.activConfig.preview,
                      // colors: [Colors.white, Colors.blue],
                    ),
                  ),
                ),
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

// _____________
// Dialog Picker
class PickerDialog extends StatefulWidget {
  final ColThemeEntry entry;

  const PickerDialog({Key key, this.entry}) : super(key: key);

  @override
  _PickerDialogState createState() => _PickerDialogState();
}

class _PickerDialogState extends State<PickerDialog> {
  ColThemeEntry _tmp;
  int _valR;
  int _valG;
  int _valB;
  int _radioSelection;

  var _startPixelController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _tmp = widget.entry;
    _startPixelController.text = '0';
    if (_tmp == null) {
      _valR = 0;
      _valG = 0;
      _valB = 0;
      _radioSelection = 1;
    } else {
      _valR = _tmp.colR;
      _valG = _tmp.colG;
      _valB = _tmp.colB;
      _radioSelection = _tmp.action;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pixel Configuration'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _startPixelController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.fiber_smart_record),
                  labelText: 'Position of the Pixel',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
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
                  value: double.parse(_valR.toString()),
                  onChanged: (value) {
                    setState(() {
                      _valR = value.round();
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
                  value: double.parse(_valG.toString()),
                  onChanged: (value) {
                    setState(() {
                      _valG = value.round();
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
                  value: double.parse(_valB.toString()),
                  onChanged: (value) {
                    setState(() {
                      _valB = value.round();
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(_valR, _valG, _valB, 0.8),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('R ' +
                    _valR.toString() +
                    ', G ' +
                    _valG.toString() +
                    ', B ' +
                    _valB.toString()),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                title: const Text('Pixel flow'),
                leading: Radio(
                  value: 1,
                  groupValue: _radioSelection,
                  onChanged: (int value) {
                    setState(() {
                      _radioSelection = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                title: const Text('Pixel static'),
                leading: Radio(
                  value: 2,
                  groupValue: _radioSelection,
                  onChanged: (int value) {
                    setState(() {
                      _radioSelection = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                title: const Text('Pixel static floating'),
                leading: Radio(
                  value: 3,
                  groupValue: _radioSelection,
                  onChanged: (int value) {
                    setState(() {
                      _radioSelection = value;
                    });
                  },
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            try {
              int tmp = int.parse(_startPixelController.text);
              if (tmp <
                      Provider.of<StateNotifier>(context, listen: false)
                              .maxPixel +
                          1 &&
                  tmp > -1) {
                Navigator.pop(
                    context,
                    new ColThemeEntry(
                        _valR, _valG, _valB, tmp, _radioSelection));
              } else {
                _startPixelController.text = '-1';
              }
            } on FormatException {
              _startPixelController.text = '-1';
            }
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text('Cancel'),
        )
      ],
    );
  }
}

class SaverDialog extends StatefulWidget {
  const SaverDialog({Key key}) : super(key: key);

  @override
  _SaverDialogState createState() => _SaverDialogState();
}

class _SaverDialogState extends State<SaverDialog> {
  var _nameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Save Pixel Configuration'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400.0),
        child: TextField(
          controller: _nameController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.storage),
            labelText: 'Name of the Configuration',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              if (_nameController.text.isEmpty) {
                final snackBar = SnackBar(content: Text('Name is Empty'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                _nameController.clear();
              } else {
                Provider.of<StateNotifier>(context, listen: false)
                    .activConfig
                    .name = _nameController.text;
                Provider.of<StateNotifier>(context, listen: false).addConfig(
                    Provider.of<StateNotifier>(context, listen: false)
                        .activConfig);

                Provider.of<StateNotifier>(context, listen: false)
                    .setActivConfig(new ColThemeConfiguration(
                    [],
                    [],
                        List.filled(
                            Provider.of<StateNotifier>(context, listen: false)
                                .maxPixel,"0x000000"),
                        ''));

                Navigator.pop(context);
              }
            });
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text('Cancel'),
        )
      ],
    );
  }
}

class LoaderDialog extends StatefulWidget {
  const LoaderDialog({Key key}) : super(key: key);

  @override
  _LoaderDialogState createState() => _LoaderDialogState();
}

class _LoaderDialogState extends State<LoaderDialog> {
  // ColThemeConfigurationContainer _tmp;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Load Pixel Configuration'),
      content: Container(
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height / 4),
        width: MediaQuery.of(context).size.width -
            (MediaQuery.of(context).size.width / 4),
        child: Consumer<StateNotifier>(
          builder: (context, stateN, child) => ListView.builder(
            itemCount: stateN.getConfigLength(),
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(stateN.getConfigList(index).name),
                  ),
                  subtitle: SizedBox(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          // end: Alignment(0.4, 0.0),
                          colors: stateN.getConfigList(index).preview,
                        ),
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Consumer<StateNotifier>(
                        builder: (context, stateN, child) => Icon(
                          stateN.selectedConfig == index ? Icons.pets : null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        tooltip: 'Delete entry',
                        onPressed: () {
                          setState(() {
                            stateN.deleteConfig(index);
                            if (Provider.of<StateNotifier>(context,
                                        listen: false)
                                    .selectedConfig ==
                                index) {
                              stateN.setSelectedConfig(-1);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      //titles.insert(index, 'Planet');
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      stateN.setSelectedConfig(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (Provider.of<StateNotifier>(context, listen: false)
                    .selectedConfig ==
                -1) {
              Navigator.pop(context);
            }

            ColThemeConfiguration conf =
                Provider.of<StateNotifier>(context, listen: false)
                    .getConfigList(
                        Provider.of<StateNotifier>(context, listen: false)
                            .selectedConfig);

            List entries = [];
            List colors = [];
            List send = [];

            for (var entry in conf.entries) {
              entries.add(ColThemeEntry(
                  entry.colR, entry.colG, entry.colB, entry.pos, entry.action));
            }
            for (var col in conf.preview) {
              colors.add(Color(col.value));
            }
            for (var str in conf.send) {
              send.add('' + str.toString());
            }

            Provider.of<StateNotifier>(context, listen: false).setActivConfig(
                ColThemeConfiguration(entries, colors, send, conf.name));

            Navigator.pop(context);
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}
