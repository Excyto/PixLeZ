import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:uuid/uuid.dart';

// Object Data for specific entry
class ColThemeEntry {
  int colR;
  int colG;
  int colB;
  int pos;
  int action;

  ColThemeEntry(this.colR, this.colG, this.colB, this.pos, this.action);
}

// Object Data for a configuration
class ColThemeConfiguration {
  List<ColThemeEntry> entries;
  List<Color> preview;
  List<String> send;
  String name;
  var id;

  ColThemeConfiguration(this.entries, this.preview, this.send, this.name) {
    preview.add(Colors.white);
    preview.add(Colors.white);
    var uuid = const Uuid();
    id = uuid.v4().toString();
  }
}

class ColThemeConfigurationAdapter extends TypeAdapter<ColThemeConfiguration> {
  @override
  final typeId = 0;

  @override
  ColThemeConfiguration read(BinaryReader reader) {
    var entriesLength = reader.readUint32();
    List<ColThemeEntry> entries = [];
    for (int i = 0; i < entriesLength; i++) {
      entries.add(ColThemeEntry(reader.readInt(), reader.readInt(),
          reader.readInt(), reader.readInt(), reader.readInt()));
    }

    var previewLength = reader.readUint32();
    List<Color> preview = [];
    for (int i = 0; i < previewLength; i++) {
      preview.add(Color(reader.readInt()));
    }

    List<String> send = reader.readStringList();
    String name = reader.readString();
    String id = reader.readString();

    var tmp = ColThemeConfiguration(entries, preview, send, name);
    tmp.id = id;

    return tmp;
  }

  @override
  void write(BinaryWriter writer, ColThemeConfiguration obj) {
    writer.writeUint32(obj.entries.length);
    for (ColThemeEntry entry in obj.entries) {
      writer.writeInt(entry.colR);
      writer.writeInt(entry.colG);
      writer.writeInt(entry.colB);
      writer.writeInt(entry.pos);
      writer.writeInt(entry.action);
    }

    writer.writeUint32(obj.preview.length);
    for (Color col in obj.preview) {
      writer.writeInt(col.value);
    }

    writer.writeStringList(obj.send);
    writer.writeString(obj.name);
    writer.writeString(obj.id);
  }
}
