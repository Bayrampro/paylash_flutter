import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilePickerState {
  final List<String> files;
  final bool isLoading;
  final String errorMessage;

  FilePickerState({
    required this.files,
    required this.isLoading,
    this.errorMessage = '',
  });

  FilePickerState.initial()
      : files = [],
        isLoading = false,
        errorMessage = '';
}

class FilePickerNotifier extends StateNotifier<FilePickerState> {
  static const MethodChannel _channel =
      MethodChannel('com.bynet.paylash/filePicker'); // New channel

  FilePickerNotifier() : super(FilePickerState.initial());

  Future<void> fetchFiles(String fileType) async {
    state = FilePickerState(
      files: state.files,
      isLoading: true,
    );

    try {
      final List<dynamic> result =
          await _channel.invokeMethod('fetchFiles', {'fileType': fileType});
      List<String> files = result.cast<String>();

      state = FilePickerState(
        files: files,
        isLoading: false,
      );
    } on PlatformException catch (e) {
      log("Error fetching files: ${e.message}");
      state = FilePickerState(
        files: [],
        isLoading: false,
        errorMessage: 'Failed to fetch files: ${e.message}',
      );
    } catch (e) {
      log("Unexpected error: $e");
      state = FilePickerState(
        files: [],
        isLoading: false,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  void clearSelection() {
    state = FilePickerState(
      files: [],
      isLoading: false,
    );
  }
}

// The provider for the FilePickerNotifier
final filePickerProvider =
    StateNotifierProvider<FilePickerNotifier, FilePickerState>(
  (ref) => FilePickerNotifier(),
);
