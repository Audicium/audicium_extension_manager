// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:extension_manager/extension_manager.dart';
import 'package:extension_manager/models/installed_extension_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

InstalledExtension? installedExt;
ExtensionManager? manager;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final workDir = await getApplicationSupportDirectory();
  final dio = Dio();
  final Logger logger = Logger();
  manager = ExtensionManager(workDir: workDir, dio: dio, logger: logger);

  await manager!.setupExtensionManager(
    mobileZipPath: 'app/mobile.zip',
    desktopZipPath: 'app/desktop.zip',
  );

  final extFileMan = manager!.manager;

  const repo =
      'https://raw.githubusercontent.com/RA341/test_scripts/main/test_repo.json';

  final extModel = await extFileMan.installRepo(repo);

  print(extModel?.$1);
  print(extModel?.$2);
  print(extModel?.$3);

  if (extModel != null) {
    final metaData = extModel.$2.first;

    final installed = await extFileMan.installExtension(ext: metaData);

    if (installed == null) {
      return print('lmao it failed');
    }

    print(installed.scriptFilePath);
    print(installed.metadata?.name);
    print(installed.modulePath);

    installedExt = installed;
  }

  runApp(const MyApp());
}

Future<void> printGoogleResponseBody() async {
  try {
    final response = await manager!.worker.homePage();

    if (response != null) {
      print(response);
    } else {
      print('Error:');
    }
  } catch (error) {
    print('Error making request: $error');
  }
}

Future<void> loadScript({
  required String path,
  required String moduleName,
}) async {
  final res =  await manager!.worker.loadExtension(module: moduleName, filePath: path);

  if (res != null){
    print(res);
  }
}

Future<void> quit() async {

  await manager!.server.quitServer();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              child: const Text('Load script'),
              onPressed: () async {
                // final res = await getPathAndModuleName();
                // print(res);
                await loadScript(
                    path: installedExt!.scriptFilePath,
                    moduleName: installedExt!.modulePath);
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Press me'),
              onPressed: () async {
                await printGoogleResponseBody();
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('quit'),
              onPressed: () async => await quit(),
            ),
          ),
        ],
      ),
    );
  }
}
