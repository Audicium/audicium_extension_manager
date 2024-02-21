import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:serious_python/serious_python.dart';

/// Manages all installed extensions
/// It is also responsible for downloading extensions

/// Contains all allowed extensions that can be downloaded
/// Should point to a json file that hosts the extension list
/// e.g - awesome_repo.json - will contain
/// 'Awesome_books':{'url' : 'https://...../list.json', 'included':'true'}
// final extensionRepo = {};

class ExtensionServerManager {
  late final Logger? _logger;
  final Dio _dio;
  final String appStart;

  // paths
  static const healthCheckPath = '/';
  static const loadExtensionUrl = '/script';

  late final String fullPath;

  ExtensionServerManager({
    required Dio dio,
    String basePath = 'http://localhost',
    int port = 55001,
    this.appStart = 'app.py',
    Logger? logger,
  }) : _dio = dio {
    fullPath = '$basePath:${port.toString()}';
    _logger = logger;
  }

  Future<void> initializePyServer({
    required String mobileZipPath,
    required String desktopZipPath,
  }) async {
    final isMobile = Platform.isAndroid || Platform.isIOS;

    final res = SeriousPython.run(
      isMobile ? mobileZipPath : desktopZipPath,
      appFileName: appStart,
    );

    _logger?.d('Python Result $res');
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
    final res = await makePostRequestToExtension(
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
    final res = await makeGetRequestToExtension(
        path: loadExtensionUrl,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken);

    return res;
  }

  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get<void>(healthCheckPath);
      if (response.statusCode == 200) {
        _logger?.d("Health check success");
        return true;
      } else {
        _logger?.d('failed health check\ndum dum: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      _logger?.d('this should not happen ;Error making request: $error');
      return false;
    }
  }

  Future<void> quitServer() async {
    try {
      SeriousPython.terminate();
      _logger?.i('exited server');
    } catch (error) {
      _logger?.d('this should probably happen : $error');
    }
  }

///////////////////////////////////////////////////////////////////////////
  String _buildPath(String path) => fullPath + path;

  Future<Map<String, dynamic>?> makeGetRequestToExtension({
    required String path,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.get<String>(
      _buildPath(path),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    if (response.statusCode == 200 && response.data != null) {
      _logger?.d('Received Data: ${response.data}');
      return jsonDecode(response.data!) as Map<String, dynamic>;
    }

    _logger?.e('Whoops failed to get data or the data is empty');
    _logger?.e('Status code ${response.statusCode}');
    _logger?.e('Response Body ${response.data}');
    return null;
  }

  Future<Map<String, dynamic>?> makePostRequestToExtension({
    required String path,
    Map<String, dynamic> body = const {},
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.post<String>(
      _buildPath(path),
      data: body,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );

    if (response.statusCode == 200 && response.data != null) {
      _logger?.d('Received Data: ${response.data}');
      return jsonDecode(response.data!) as Map<String, dynamic>;
    }

    _logger?.e('Whoops failed to get data or the data is empty');
    _logger?.e('Status code ${response.statusCode}');
    _logger?.e('Response Body ${response.data}');
    return null;
  }
}
