library extension_manager;

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:extension_manager/managers/extension_server_manager.dart';
import 'package:logger/logger.dart';
import 'package:serious_python/serious_python.dart';

import 'package:extension_manager/managers/extension_file_manger.dart';
import 'package:extension_manager/managers/extension_worker.dart';

class ExtensionManager {
  final Directory workDir;

  late final ExtensionFileManager manager;
  late final ExtensionWorker worker;
  late final ExtensionServerManager server;

  final Dio dio;
  final Logger? logger;

  ExtensionManager({
    required this.workDir,
    required this.dio,
    this.logger,
  }) {
    manager = ExtensionFileManager(
      logger: logger,
      dio: dio,
      savePath: workDir,
    );

    server = ExtensionServerManager(
      logger: logger,
      dio: dio,
    );

    worker = ExtensionWorker(
      logger: logger,
      server: server,
    );
  }

  Future<void> setupExtensionManager({
    required String mobileZipPath,
    required String desktopZipPath,
  }) async {
    await manager.createSupportDirectories();
    await server.initializePyServer(
      mobileZipPath: mobileZipPath,
      desktopZipPath: desktopZipPath,
    );
  }
}

// class ExtensionController with PageStatusMixin {
//   final TextEditingController searchController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//
//   String get query => searchController.text;
//
//   /// holds results
//   final booksList = ValueNotifier<List<DisplayBook>>([]);
//
//   // pagination
//   Future<void> _onScrollOverflow() async {
//     if (scrollController.position.pixels ==
//             scrollController.position.maxScrollExtent &&
//         !isPageLoading) {
//       await requestBooks();
//     }
//   }
//
//   /// be sure to call this when you want to load the first page
//   Future<void> init() async {
//     await requestBooks();
//     scrollController.addListener(_onScrollOverflow);
//   }
//
//   void dispose() {
//     searchController.dispose();
//     scrollController.dispose();
//   }
//
//   Future<void> searchOrRefresh();
//
//   /// Use this to search or paginate results;
//   ///
//   /// only way to get results
//   Future<void> requestBooks();
//
//   void resetPage() {
//     booksList.value = [];
//     pageIdle();
//   }
//
//   /// loads the full details page with playable audio links
//   Future<BookMetaData> loadDetailsPage(String url);
// }
