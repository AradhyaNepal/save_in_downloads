import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: downloadFile,
            child: const Text("Download"),
          ),
        ),
      ),
    );
  }

  void downloadFile() async {
    if(!Platform.isAndroid)return;
    await Permission.storage.request();
    String? downloadPath=await getDownloadPath();
    log(downloadPath??"",name: "Download Directory");
    log((await Saf.getPersistedPermissionDirectories()).toString(),name: "Permission Directory");
    if(downloadPath==null)return;
    downloadPath="$downloadPath/Pdot";
    Saf saf = Saf(downloadPath);
    log((await saf.getFilesPath()).toString()  );
    bool? isGranted = await saf.getDirectoryPermission(isDynamic: true);

    if (isGranted==true) {
      final file=File(downloadPath);
      await Dio().download("https://scholar.harvard.edu/files/torman_personal/files/samplepptx.pptx", file.path);
    } else {
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Cannot get permission",
          ),
        ),
      );
    }
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
}
