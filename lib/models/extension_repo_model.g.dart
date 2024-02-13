// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension_repo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtensionRepoModel _$ExtensionRepoModelFromJson(Map<String, dynamic> json) =>
    ExtensionRepoModel(
      repoName: json['repoName'] as String,
      extensionsMetaDataUrls: (json['extensionsMetaDataUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      repoUrl: json['repoUrl'] as String,
      jsonRepoUrl: json['jsonRepoUrl'] as String,
    );

Map<String, dynamic> _$ExtensionRepoModelToJson(ExtensionRepoModel instance) =>
    <String, dynamic>{
      'repoName': instance.repoName,
      'extensionsMetaDataUrls': instance.extensionsMetaDataUrls,
      'repoUrl': instance.repoUrl,
      'jsonRepoUrl': instance.jsonRepoUrl,
    };
