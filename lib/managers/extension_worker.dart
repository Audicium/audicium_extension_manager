import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'extension_server_manager.dart';

/// Core Class that calls the actual scraping methods
class ExtensionWorker {
  final Logger? _logger;
  final ExtensionServerManager _server;

  ExtensionWorker({
    required ExtensionServerManager server,
    Logger? logger,
  })  : _server = server,
        _logger = logger;

  static const homePageUrl = '/script/home';
  static const loadExtensionUrl = '/script';

////////////////////////////////////////////////////////////////////////////////
  // core scraper functions
  Future<Map<String, dynamic>?> homePage({
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final res = await _server.makeGetRequestToExtension(
      path: homePageUrl,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    return res;
  }


////////////////////////////////////////////////////////////////////////////////
  // extension management

  Future<Map<String, dynamic>?> loadExtension({
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    required String module,
    required String filePath,
  }) async {
    final res = await _server.makePostRequestToExtension(
      path: loadExtensionUrl,
      body: {'module': module, 'path': filePath},
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );

    return res;
  }

  Future<Map<String, dynamic>?> unLoadExtension({
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final res = await _server.makeGetRequestToExtension(
        path: loadExtensionUrl,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken);

    return res;
  }
///////////////////////////////////////////////////////////////////////////
}
