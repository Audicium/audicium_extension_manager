import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:extension_manager/models/extension_metadata_model.dart';
import 'package:extension_manager/models/extension_repo_model.dart';
import 'package:extension_manager/models/installed_extension_model.dart';
import 'package:logger/logger.dart';

class ExtensionFileManager {
  final Dio dio;
  final Directory savePath;
  final Logger? _logger;
  late final Directory tmpDir;
  late final Directory extensionDir;
  late final tmpLoc = '${tmpDir.path}/tmp.json';

  ExtensionFileManager({
    required this.dio,
    required this.savePath,
    Logger? logger,
  }) : _logger = logger;

  Future<void> createSupportDirectories() async {
    // create extension dir
    extensionDir = await Directory(savePath.path + '/extensions').create();

    // create tmp dir
    tmpDir = await Directory(savePath.path + '/tmp').create();
  }

  Future<(ExtensionRepoModel, List<ExtensionMetaData>, List<String>)?>
      installRepo(
    String jsonUrl,
  ) async {
    final response = await dio.download(
      jsonUrl,
      tmpLoc,
      deleteOnError: true,
    );

    // if (checkIfJson(response)) {
    //   return null;
    // }

    if (response.statusCode == 200) {
      final tmpFile = await File(tmpLoc);

      var input = await tmpFile.readAsString();
      var map = jsonDecode(input) as Map<String, dynamic>;

      tmpFile.delete();

      final repo = ExtensionRepoModel.fromJson(map);

      final successList = <ExtensionMetaData>[];
      final failedList = <String>[];

      for (final extMetaUrl in repo.extensionsMetaDataUrls) {
        final metaData =
            await getExtensionMetaData(url: extMetaUrl, filePath: tmpLoc);
        if (metaData != null) {
          successList.add(metaData);
        }

        failedList.add(extMetaUrl);
      }

      return (repo, successList, failedList);
    }
    _logger?.d(
        'Failed to download ${jsonUrl}: ${response.statusCode} ${response.statusMessage}');
    return null;
  }

  Future<ExtensionMetaData?> getExtensionMetaData({
    required String url,
    required String filePath,
  }) async {
    final resp = await dio.download(
      url,
      filePath,
      deleteOnError: true,
    );

    if (resp.statusCode == 200) {
      // read from file
      final file = File(filePath);
      final fileData = await file.readAsString();
      // parse json
      final data = jsonDecode(fileData) as Map<String, dynamic>;
      // delete data
      await file.delete();
      // return metadata object
      return ExtensionMetaData.fromJson(data);
    }

    _logger?.d('Script: ${resp.statusCode}: ${resp.statusMessage}');
    return null;
  }

  // Extension functions
  Future<InstalledExtension?> installExtension({
    required ExtensionMetaData ext,
    void Function(int, int)? onReceiveProgress,
    CancelToken? token,
  }) async {
    final scriptUrl = ext.scriptUrl;
    final metaDataUrl = ext.metaDataUrl;

    final metaData = await getExtensionMetaData(
      filePath: tmpLoc,
      url: metaDataUrl,
    );

    final scriptSavePath = await downloadScript(
      extSaveDir: extensionDir,
      scriptUrl: scriptUrl,
    );

    if (scriptSavePath != null && metaData != null) {

      return InstalledExtension(
        scriptFilePath: scriptSavePath,
        metadata: metaData,
      );
    } else {
      _logger?.e('Script or metaData failed to download');
      return null;
    }
  }

  Future<String?> downloadScript({
    required Directory extSaveDir,
    required String scriptUrl,
    void Function(int, int)? onReceiveProgress,
    CancelToken? token,
  }) async {
    // extract file name
    final fileName = Uri.parse(scriptUrl).pathSegments.last;

    final extSavePath = '${extSaveDir.path}/$fileName';

    final resp = await dio.download(
      onReceiveProgress: onReceiveProgress,
      scriptUrl,
      extSavePath,
      deleteOnError: true,
    );

    if (resp.statusCode == 200) {
      return extSavePath;
    }

    _logger?.d('Script: ${resp.statusCode}: ${resp.statusMessage}');
    return null;
  }

  // Future<String?> downloadMetaData({
  //   required Directory extSaveDir,
  //   required String metaDataUrl,
  //   void Function(int, int)? onReceiveProgress,
  //   CancelToken? token,
  // }) async {
  //   // get metadata file
  //   final metaName = Uri.parse(metaDataUrl).pathSegments.last;
  //
  //   final metaSavePath = '${extSaveDir.path}/$metaName';
  //
  //   final resp = await dio.download(
  //     onReceiveProgress: onReceiveProgress,
  //     metaDataUrl,
  //     metaSavePath,
  //     deleteOnError: true,
  //   );
  //
  //   if (checkIfJson(resp)) {
  //     return null;
  //   }
  //
  //   if (resp.statusCode == 200) {
  //     return metaSavePath;
  //   }
  //
  //   _logger?.d('Script: ${resp.statusCode}: ${resp.statusMessage}');
  //   return null;
  // }

  Future<void> deleteExtension(File extPath) async => extPath.delete();

  bool checkIfJson(Response<dynamic> resp) {
    if (resp.headers.map['Content-type'] != 'application/json') {
      _logger?.d(
          'failed to download file: ${resp.headers.map['Content-type']} is not allowed');
      return false;
    }
    return true;
  }
}
