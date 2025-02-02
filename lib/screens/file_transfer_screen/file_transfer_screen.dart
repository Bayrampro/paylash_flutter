// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:paylash/providers/file_transfer_provider.dart';

// class FileTransferScreen extends ConsumerWidget {
//   final String fileName;

//   const FileTransferScreen({
//     super.key,
//     required this.fileName, required List<String> selectedFiles,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Listen to the file transfer state
//     final transferStatus = ref.watch(fileTransferProvider);

//     // Determine screen content based on the current transfer state
//     Widget content;
//     switch (transferStatus.state) {
//       case FileTransferState.idle:
//         content = const Text(
//           'Ожидание начала передачи...',
//           style: TextStyle(fontSize: 18, color: Colors.blueGrey),
//         );
//         break;

//       case FileTransferState.transferring:
//         content = Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Передача файла: $fileName',
//               style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
//             ),
//             const SizedBox(height: 20),
//             LinearProgressIndicator(
//               value: transferStatus.progress / 100,
//               backgroundColor: Colors.grey[300],
//               valueColor: const AlwaysStoppedAnimation(Colors.blue),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               '${transferStatus.progress.toStringAsFixed(1)}%',
//               style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
//             ),
//           ],
//         );
//         break;

//       case FileTransferState.completed:
//         content = const Text(
//           'Передача завершена успешно!',
//           style: TextStyle(fontSize: 18, color: Colors.green),
//         );
//         break;

//       case FileTransferState.error:
//         content = Text(
//           'Ошибка передачи файла: ${transferStatus.errorMessage}',
//           style: const TextStyle(fontSize: 18, color: Colors.red),
//         );
//         break;
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         title: const Text(
//           'Передача файла',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.blueGrey,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: content,
//         ),
//       ),
//       floatingActionButton: transferStatus.state == FileTransferState.completed
//           ? FloatingActionButton.extended(
//               onPressed: () {
//                 // Return to the main screen after successful transfer
//                 Navigator.of(context).pop();
//               },
//               label: const Text('Готово'),
//               icon: const Icon(Icons.check),
//               backgroundColor: Colors.green,
//             )
//           : null,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylash/providers/file_transfer_provider.dart';

class FileTransferScreen extends ConsumerWidget {
  final List<String> selectedFiles;

  const FileTransferScreen({
    super.key,
    required this.selectedFiles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the file transfer state
    final transferStatus = ref.watch(fileTransferProvider);

    // Determine screen content based on the current transfer state
    Widget content;
    switch (transferStatus.state) {
      case FileTransferState.idle:
        content = const Text(
          'Ожидание начала передачи...',
          style: TextStyle(fontSize: 18, color: Colors.blueGrey),
        );
        break;

      case FileTransferState.transferring:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Передача файлов:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = selectedFiles[index];
                  final progress = transferStatus.fileProgress[file] ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Файл: ${file.split('/').last}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.blueGrey),
                      ),
                      LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation(Colors.blue),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Общий прогресс: ${transferStatus.overallProgress.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
          ],
        );
        break;

      case FileTransferState.completed:
        content = const Text(
          'Передача завершена успешно!',
          style: TextStyle(fontSize: 18, color: Colors.green),
        );
        break;

      case FileTransferState.error:
        content = Text(
          'Ошибка передачи файла: ${transferStatus.errorMessage}',
          style: const TextStyle(fontSize: 18, color: Colors.red),
        );
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Передача файлов',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ),
      floatingActionButton: transferStatus.state == FileTransferState.completed
          ? FloatingActionButton.extended(
              onPressed: () {
                // Return to the main screen after successful transfer
                Navigator.of(context).pop();
              },
              label: const Text('Готово'),
              icon: const Icon(Icons.check),
              backgroundColor: Colors.green,
            )
          : transferStatus.state == FileTransferState.transferring
              ? FloatingActionButton.extended(
                  onPressed: () {
                    // Cancel the transfer
                    ref.read(fileTransferProvider.notifier).cancelTransfer();
                  },
                  label: const Text('Отмена'),
                  icon: const Icon(Icons.cancel),
                  backgroundColor: Colors.red,
                )
              : null,
    );
  }
}
