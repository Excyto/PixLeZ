import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:pixlez/data/color_theme.dart';

class StateNotifier extends ChangeNotifier {
  String ip = 'http://127.0.0.1:5500';
  // String ip = 'http://localhost:8080';
  // String ip = 'http://192.168.178.55:8080';
  int maxPixel = 160;
  int running = 0;
  bool connected = false;
  int mode = -1;
  int effect = -1;
  String version = 'v2.3.8';  // Change this in pubspec.yaml also!
  late String about;

  // Color Theme Configuration
  ColThemeConfiguration? activeConfig;
  List<ColThemeConfiguration> configList = [];
  int selectedConfig = -1;

  StateNotifier() {
    about = 'PixLeZ - Application\nVersion: $version\n\nCreated by Tobias Schreiweis in 2020 \n\nPixLeZ is used controlling Pixels on a Raspberry Pi.\nFor more information read the documentation.\n\nLicense: tbd';
    loadDatabase();
  }

  void loadDatabase() async {
    // https://docs.hivedb.dev/#/basics/boxes
    var box = Hive.box('settings');
    String tmpIp = box.get('ipAdr');
    int tmpPix = box.get('maxPix');
    ip = tmpIp;
      maxPixel = tmpPix;
    }

  void setActiveConfig(ColThemeConfiguration colThemeConfiguration) {
    activeConfig = colThemeConfiguration;
    // notifyListeners();
  }

  void addConfig(ColThemeConfiguration config) {
    var box = Hive.box("ColTheme");
    box.add(config);
    // configList.add(config);
    notifyListeners();
  }

  void deleteConfig(int pos) {
    var box = Hive.box("ColTheme");
    box.deleteAt(pos);
    //configList.removeAt(pos);
  }

  void setSelectedConfig(int value) {
    selectedConfig = value;
    notifyListeners();
  }

  int getConfigLength() {
    var box = Hive.box("ColTheme");
    return box.length;
    // return configList.length;
  }

  ColThemeConfiguration getConfigList(int index) {
    var box = Hive.box("ColTheme");
    return box.getAt(index);
    // return configList[index];
  }

  // _______________
  // Configuration
  // _______________

  void setIp(String s) {
    var box = Hive.box('settings');
    box.put('ipAdr', s);
    ip = s;
    notifyListeners();
  }

  void setMaxPixel(int val) {
    var box = Hive.box('settings');
    box.put('maxPix', val);
    maxPixel = val;
    notifyListeners();
  }

  void setRunning(int i) {
    running = i;
    notifyListeners();
  }

  void setConnected(bool b) {
    connected = b;
    notifyListeners();
  }

  void setMode(int val) {
    mode = val;
    notifyListeners();
  }

  void setEffect(int val) {
    effect = val;
    notifyListeners();
  }
}
