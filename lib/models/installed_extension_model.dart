import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'extension_metadata_model.dart';

part 'installed_extension_model.g.dart';

@JsonSerializable()
class InstalledExtension {
  final String scriptFilePath;
  late final String modulePath;
  late final ExtensionMetaData? metadata;

  InstalledExtension({
    required this.scriptFilePath,
    this.metadata,
  }) {
    final filePath = File(scriptFilePath);

    // strip out .py
    final fileName = filePath.uri.pathSegments.last.split('.').first;

    // we do this here because filePath.parent.uri.pathSegments gives
    // 0 = "data"
    // 1 = "user"
    // 2 = "0"
    // 3 = "com.example.example"
    // 4 = "files"
    // 5 = "extensions"
    // 6 = ""

    final parentFolder = filePath.parent.uri.pathSegments
        .elementAt(filePath.parent.uri.pathSegments.length - 2);

    modulePath = '$parentFolder.$fileName';
  }

  factory InstalledExtension.fromJson(Map<String, dynamic> json) =>
      _$InstalledExtensionFromJson(json);

  Map<String, dynamic> toJson() => _$InstalledExtensionToJson(this);

  Future<void> setMetaData(File metaPath) async {
    // load in file
    final metaJson = await metaPath.readAsString();
    // convert json to map
    final dataMap = jsonDecode(metaJson) as Map<String, dynamic>;
    // load in metadata using metadata to json constructor
    metadata = ExtensionMetaData.fromJson(dataMap);
    // delete file
    await metaPath.delete();
  }
}
