import 'package:json_annotation/json_annotation.dart';

part 'extension_repo_model.g.dart';

@JsonSerializable()
class ExtensionRepoModel {
  final String repoName;
  final List<String> extensionsMetaDataUrls;
  final String repoUrl;
  final String jsonRepoUrl;

  ExtensionRepoModel({
    required this.repoName,
    required this.extensionsMetaDataUrls,
    required this.repoUrl,
    required this.jsonRepoUrl,
  });

  factory ExtensionRepoModel.fromJson(Map<String, dynamic> json) => _$ExtensionRepoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionRepoModelToJson(this);
}
