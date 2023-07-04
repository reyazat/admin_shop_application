import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String> getApplicationDirectory() async {
    String parentDirectory = '/Media_smartshopadmin/files';
    String customPath = '$parentDirectory/media_';
    Directory appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    if (await Directory(appDocDirectory.path + parentDirectory).exists() !=
        true) {
      new Directory(appDocDirectory.path + parentDirectory)
          .createSync(recursive: true);

      if (await Directory(appDocDirectory.path + parentDirectory).exists() ==
          true) {
      } else {
        print("Directory is not exist");
      }
    }

    customPath = appDocDirectory.path + customPath;
    // +

    return customPath;
  }

  static Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }
}
