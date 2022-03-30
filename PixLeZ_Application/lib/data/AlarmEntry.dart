class AlarmEntry {
  AlarmEntry({this.name, this.dayNames, this.hour, this.minute});
  final String name;
  final List<String> dayNames;
  final int hour;
  final int minute;

  factory AlarmEntry.fromJson(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final dayNames = data['dayNames'] as List<String>;
    final hour = data['hour'] as int;
    final minute = data['minute'] as int;
    return AlarmEntry(name: name, dayNames: dayNames, hour: hour, minute: minute);
  }

  static List<AlarmEntry> listFromJson(Map<String, dynamic> data){
    final entries = data['entries'] as List<dynamic>;
    return entries.map((entry) => AlarmEntry.fromJson(entry)).toList();
  }
}