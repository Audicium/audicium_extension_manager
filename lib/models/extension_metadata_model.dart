import 'package:json_annotation/json_annotation.dart';

part 'extension_metadata_model.g.dart';

/// Extensions not installed yet
@JsonSerializable()
class ExtensionMetaData {
  const ExtensionMetaData({
    required this.name,
    required this.version,
    required this.repoUrl,
    required this.scriptUrl,
    required this.metaDataUrl,
    this.icon = '',
    this.author = '',
    this.audioHeaders = const {},
    this.headers = const {},
  });

  /// Name of the extension
  final String name;

  /// optional: add any image url
  final String? icon;

  /// optional: add the author of the plugin
  final String? author;

  /// specify the version number of the plugin
  ///
  /// remember to update the number after each release else the app wont download the file
  final String version;

  /// the repo where the extension resides
  final String repoUrl;

  /// The actual link to the extension
  /// used to update the extension
  final String scriptUrl;

  /// link to the metadata file
  final String metaDataUrl;

  /// optional: store any headers required for the audio link to work
  final Map<String, String>? audioHeaders;

  /// optional: store any other headers required for getting other metaata from the site
  /// e.g images
  final Map<String, String>? headers;

  factory ExtensionMetaData.fromJson(Map<String, dynamic> json) => _$ExtensionMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionMetaDataToJson(this);
}
