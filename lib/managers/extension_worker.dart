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


}
