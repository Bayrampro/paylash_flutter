// import 'package:flutter_riverpod/flutter_riverpod.dart';

// /// Enum representing the state of the file transfer.
// enum FileTransferState {
//   idle, // No transfer in progress
//   transferring, // File is being transferred
//   completed, // Transfer completed successfully
//   error, // An error occurred
// }

// /// Model to hold the file transfer progress and state.
// class FileTransferStatus {
//   final FileTransferState state;
//   final double progress; // Percentage of transfer completed (0.0 to 100.0)
//   final String? errorMessage; // Error message, if any

//   FileTransferStatus({
//     required this.state,
//     this.progress = 0.0,
//     this.errorMessage,
//   });

//   FileTransferStatus copyWith({
//     FileTransferState? state,
//     double? progress,
//     String? errorMessage,
//   }) {
//     return FileTransferStatus(
//       state: state ?? this.state,
//       progress: progress ?? this.progress,
//       errorMessage: errorMessage,
//     );
//   }
// }

// /// Notifier to manage file transfer state.
// class FileTransferNotifier extends StateNotifier<FileTransferStatus> {
//   FileTransferNotifier()
//       : super(FileTransferStatus(state: FileTransferState.idle));

//   /// Starts the file transfer.
//   void startTransfer() {
//     state =
//         state.copyWith(state: FileTransferState.transferring, progress: 0.0);
//   }

//   /// Updates the progress of the transfer.
//   void updateProgress(double progress) {
//     state = state.copyWith(progress: progress);
//     if (progress >= 100.0) {
//       completeTransfer();
//     }
//   }

//   /// Completes the file transfer.
//   void completeTransfer() {
//     state = state.copyWith(state: FileTransferState.completed, progress: 100.0);
//   }

//   /// Handles an error during file transfer.
//   void setError(String errorMessage) {
//     state = state.copyWith(
//         state: FileTransferState.error, errorMessage: errorMessage);
//   }

//   /// Resets the file transfer state to idle.
//   void reset() {
//     state = FileTransferStatus(state: FileTransferState.idle);
//   }
// }

// /// Provider for the file transfer state.
// final fileTransferProvider =
//     StateNotifierProvider<FileTransferNotifier, FileTransferStatus>(
//   (ref) => FileTransferNotifier(),
// );
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum representing the state of the file transfer.
enum FileTransferState {
  idle, // No transfer in progress
  transferring, // File is being transferred
  completed, // Transfer completed successfully
  error, // An error occurred
}

/// Model to hold the file transfer progress and state.
class FileTransferStatus {
  final FileTransferState state;
  final Map<String, double>
      fileProgress; // Progress of each file (0.0 to 100.0)
  final double overallProgress; // Overall progress (0.0 to 100.0)
  final String? errorMessage; // Error message, if any

  FileTransferStatus({
    required this.state,
    required this.fileProgress,
    required this.overallProgress,
    this.errorMessage,
  });

  /// Factory for the initial state.
  factory FileTransferStatus.initial() {
    return FileTransferStatus(
      state: FileTransferState.idle,
      fileProgress: {},
      overallProgress: 0.0,
      errorMessage: null,
    );
  }

  /// Method to copy and update state.
  FileTransferStatus copyWith({
    FileTransferState? state,
    Map<String, double>? fileProgress,
    double? overallProgress,
    String? errorMessage,
  }) {
    return FileTransferStatus(
      state: state ?? this.state,
      fileProgress: fileProgress ?? this.fileProgress,
      overallProgress: overallProgress ?? this.overallProgress,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier to manage file transfer state.
class FileTransferNotifier extends StateNotifier<FileTransferStatus> {
  FileTransferNotifier() : super(FileTransferStatus.initial());

  /// Starts the file transfer for the provided files.
  void startTransfer(List<String> files) {
    // Reset progress for each file
    final progressMap = {for (var file in files) file: 0.0};
    state = state.copyWith(
      state: FileTransferState.transferring,
      fileProgress: progressMap,
      overallProgress: 0.0,
    );

    // Simulate transfer for demonstration (this should be replaced with real logic)
    _simulateFileTransfer(files);
  }

  /// Simulate file transfer for demo purposes.
  Future<void> _simulateFileTransfer(List<String> files) async {
    for (var file in files) {
      for (var progress = 0; progress <= 100; progress += 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        _updateFileProgress(file, progress.toDouble());
      }
    }
    _completeTransfer();
  }

  /// Updates progress for a specific file.
  void _updateFileProgress(String file, double progress) {
    final updatedFileProgress = Map<String, double>.from(state.fileProgress);
    updatedFileProgress[file] = progress;

    state = state.copyWith(
      fileProgress: updatedFileProgress,
      overallProgress: _calculateOverallProgress(updatedFileProgress),
    );
  }

  /// Completes the file transfer.
  void _completeTransfer() {
    state = state.copyWith(state: FileTransferState.completed);
  }

  /// Handles an error during file transfer.
  void setError(String errorMessage) {
    state = state.copyWith(
      state: FileTransferState.error,
      errorMessage: errorMessage,
    );
  }

  /// Cancels the file transfer and resets the state.
  void cancelTransfer() {
    state = FileTransferStatus.initial();
  }

  /// Calculates the overall progress as the average of all file progress.
  double _calculateOverallProgress(Map<String, double> fileProgress) {
    if (fileProgress.isEmpty) return 0.0;

    final totalProgress = fileProgress.values.reduce((a, b) => a + b);
    return totalProgress / fileProgress.length;
  }
}

/// Provider for the file transfer state.
final fileTransferProvider =
    StateNotifierProvider<FileTransferNotifier, FileTransferStatus>(
  (ref) => FileTransferNotifier(),
);
