import 'package:file_picker/file_picker.dart'; // Импортируем пакет для выбора файлов
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:paylash/providers/file_picker_provider.dart';
import 'package:paylash/providers/is_device_connected_provider.dart';
import 'package:paylash/ui/ui.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

class FilePickerScreen extends ConsumerStatefulWidget {
  const FilePickerScreen({super.key});

  @override
  ConsumerState<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends ConsumerState<FilePickerScreen> {
  String _selectedFileType =
      'all'; // Тип файла: "all", "images", "videos", "audio"
  final List<String> _selectedFiles = [];
  bool _allowMultipleFiles = true; // Переключатель для выбора нескольких файлов

  @override
  void initState() {
    super.initState();
    // Загрузка файлов при открытии экрана, но не показываем все файлы, только выбранные
  }

  @override
  Widget build(BuildContext context) {
    final isDeviceConnected = ref.watch(isDeviceConnectedProvider);

    // Проверяем подключение устройства
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!isDeviceConnected) {
          context.go('/devices');
        }
      },
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SimpleAppBar(
          iconData: Icons.signal_wifi_connected_no_internet_4_sharp,
          onBack: () async {
            await GetIt.I.get<WifiDirectManager>().disconnectFromDevice();
            context.go('/devices');
          },
        ),
      ),
      body: Column(
        children: [
          // Кнопка для ручного выбора файлов
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _pickFilesManually(_selectedFileType),
              child: const Text('Выбрать файлы'),
            ),
          ),
          // Фильтр по типам файлов
          _buildFileTypeFilter(),
          // Переключатель для выбора нескольких файлов
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Разрешить выбор нескольких файлов'),
                Switch(
                  value: _allowMultipleFiles,
                  onChanged: (value) {
                    setState(() {
                      _allowMultipleFiles = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedFiles.isEmpty
                ? const Center(child: Text('Выберите файлы'))
                : _buildFileList(
                    _selectedFiles), // Показываем только выбранные файлы
          ),
          // Кнопка отправки выбранных файлов
          if (_selectedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _sendSelectedFiles,
                child: Text('Отправить (${_selectedFiles.length})'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFileTypeFilter() {
    const fileTypes = {
      'all': 'Все',
      'images': 'Изображения',
      'videos': 'Видео',
      'audio': 'Аудио'
    };
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: fileTypes.entries.map((entry) {
          final fileType = entry.key;
          final label = entry.value;
          final isSelected = _selectedFileType == fileType;

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => _onFileTypeChanged(fileType),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFileList(List<String> files) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final isSelected = _selectedFiles.contains(file);

        return ListTile(
          leading: Icon(
            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
            color: isSelected ? Colors.green : null,
          ),
          title: Text(file),
          onTap: () => _toggleFileSelection(file),
        );
      },
    );
  }

  void _onFileTypeChanged(String fileType) {
    setState(() {
      _selectedFileType = fileType;
      _selectedFiles.clear(); // Очищаем выбранные файлы при смене фильтра
    });
    ref.read(filePickerProvider.notifier).fetchFiles(fileType);
  }

  void _toggleFileSelection(String file) {
    setState(() {
      if (_selectedFiles.contains(file)) {
        _selectedFiles.remove(file);
      } else {
        _selectedFiles.add(file);
      }
    });
  }

  Future<void> _pickFilesManually(String fileType) async {
    FileType pickerFileType;
    List<String>? allowedExtensions;

    // Установка фильтров для выбора файлов
    switch (fileType) {
      case 'images':
        pickerFileType = FileType.image;
        allowedExtensions = null; // По умолчанию для изображений
        break;
      case 'audio':
        pickerFileType = FileType.custom;
        allowedExtensions = ['mp3'];
        break;
      case 'videos':
        pickerFileType = FileType.video;
        allowedExtensions = null; // По умолчанию для видео
        break;
      default:
        pickerFileType = FileType.any;
        allowedExtensions = null;
    }

    final result = await FilePicker.platform.pickFiles(
      type: pickerFileType,
      allowedExtensions: allowedExtensions,
      allowMultiple:
          _allowMultipleFiles, // Используем значение из переключателя
    );

    if (result != null) {
      // Добавляем выбранные файлы в список
      setState(() {
        _selectedFiles.addAll(result.paths.whereType<String>());
      });
    }
  }

  void _sendSelectedFiles() {
    // Логика отправки файлов
    context.go('/file_transfer', extra: _selectedFiles);
  }
}
