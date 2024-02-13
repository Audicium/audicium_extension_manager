import 'package:extension_manager/models/extension_metadata_model.dart';
import 'package:extension_manager/models/extension_repo_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('show json blobs', () {
    final metaData = ExtensionMetaData(
      name: 'awesome extension',
      version: '0.0.1',
      repoUrl: 'https://github.com/RA341/test_scripts',
      scriptUrl: 'https://raw.githubusercontent.com/RA341/test_scripts/main/test.py',
      metaDataUrl: 'https://raw.githubusercontent.com/RA341/test_scripts/main/test_extension.json',
    );

    final repo = ExtensionRepoModel(
      repoName: 'awesome repo',
      extensionsMetaDataUrls: [
        'https://raw.githubusercontent.com/RA341/test_scripts/main/test_extension.json',
      ],
      jsonRepoUrl: 'https://raw.githubusercontent.com/RA341/test_scripts/main/test_repo.json',
      repoUrl: 'https://github.com/RA341/test_scripts',
    );

    print(metaData.toJson());
    print(repo.toJson());
  });
}
