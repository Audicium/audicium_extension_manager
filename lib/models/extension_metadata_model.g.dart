// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtensionMetaData _$ExtensionMetaDataFromJson(Map<String, dynamic> json) =>
    ExtensionMetaData(
      name: json['name'] as String,
      version: json['version'] as String,
      repoUrl: json['repoUrl'] as String,
      scriptUrl: json['scriptUrl'] as String,
      metaDataUrl: json['metaDataUrl'] as String,
      icon: json['icon'] as String? ?? '',
      author: json['author'] as String? ?? '',
      audioHeaders: (json['audioHeaders'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$ExtensionMetaDataToJson(ExtensionMetaData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'author': instance.author,
      'version': instance.version,
      'repoUrl': instance.repoUrl,
      'scriptUrl': instance.scriptUrl,
      'metaDataUrl': instance.metaDataUrl,
      'audioHeaders': instance.audioHeaders,
      'headers': instance.headers,
    };
