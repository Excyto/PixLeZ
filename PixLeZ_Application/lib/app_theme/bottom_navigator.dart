import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pixlez/data/state_notifier.dart';

class CustomBottomNavigator extends StatefulWidget {
  const CustomBottomNavigator({super.key});

  @override
  _CustomBottomNavigator createState() => _CustomBottomNavigator();
}

class _CustomBottomNavigator extends State<CustomBottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Consumer<StateNotifier>(
              builder: (context, stateN, child) => Text(stateN.version),
            ),
            Consumer<StateNotifier>(
              builder: (context, stateN, child) => Text(stateN.ip),
            ),
            Row(
              children: [
                Consumer<StateNotifier>(
                  builder: (context, stateN, child) => const Tooltip(
                    message: 'Debug off',
                    child: Icon(
                      // code - bug_report
                      Icons.bug_report,
                      // color:
                      // stateN.running == 1 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                Consumer<StateNotifier>(
                  builder: (context, stateN, child) => Tooltip(
                    message: 'Pixels running status',
                    child: Icon(
                      Icons.panorama_horizontal,
                      color: stateN.running == 1 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                Consumer<StateNotifier>(
                  builder: (context, stateN, child) => Tooltip(
                    message: 'Connection available status',
                    child: Icon(
                      Icons.wifi,
                      color:
                          stateN.connected == true ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
