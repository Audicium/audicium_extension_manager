// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installed_extension_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstalledExtension _$InstalledExtensionFromJson(Map<String, dynamic> json) =>
    InstalledExtension(
      scriptFilePath: json['scriptFilePath'] as String,
      metadata: json['metadata'] == null
          ? null
          : ExtensionMetaData.fromJson(
              json['metadata'] as Map<String, dynamic>),
    )..modulePath = json['modulePath'] as String;

Map<String, dynamic> _$InstalledExtensionToJson(InstalledExtension instance) =>
    <String, dynamic>{
      'scriptFilePath': instance.scriptFilePath,
      'modulePath': instance.modulePath,
      'metadata': instance.metadata,
    };
