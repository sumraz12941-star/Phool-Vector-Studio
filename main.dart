import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() => runApp(const PhoolVectorStudio());

class PhoolVectorStudio extends StatelessWidget {
  const PhoolVectorStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phool Vector Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B5CF6)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5FA),
      ),
      home: const EditorScreen(),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _showOriginal = true;
  bool _flowerLayer = true;
  bool _leafLayer = true;
  bool _vineLayer = true;
  String _status = 'একটি ছবি যোগ করে ডিজাইন শুরু করুন';

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );
      if (picked == null) return;
      setState(() {
        _image = File(picked.path);
        _status = 'ছবি যোগ হয়েছে। এটি এখন ক্যানভাসে দেখা যাচ্ছে।';
      });
    } catch (e) {
      _message('ছবি খোলা যায়নি: $e');
    }
  }

  Future<void> _saveProjectCopy() async {
    if (_image == null) {
      _message('আগে একটি ছবি যোগ করুন।');
      return;
    }
    try {
      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory('${dir.path}/PhoolVectorStudio');
      await folder.create(recursive: true);
      final name = 'phool_project_${DateTime.now().millisecondsSinceEpoch}.png';
      final saved = await _image!.copy('${folder.path}/$name');
      setState(() => _status = 'ছবির কপি সেভ হয়েছে: ${saved.path}');
      _message('ছবির কপি অ্যাপের ফোল্ডারে সেভ হয়েছে।');
    } catch (e) {
      _message('সেভ করা যায়নি: $e');
    }
  }

  Future<void> _shareImage() async {
    if (_image == null) {
      _message('শেয়ার করার আগে একটি ছবি যোগ করুন।');
      return;
    }
    await Share.shareXFiles([XFile(_image!.path)], text: 'Phool Vector Studio');
  }

  void _message(String value) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(value)),
    );
  }

  Widget _toolButton(IconData icon, String label, VoidCallback action) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E2F0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF7044B8)),
            const SizedBox(height: 5),
            Text(label, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _layer(String name, bool value, ValueChanged<bool> changed) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(name, style: const TextStyle(fontSize: 13)),
      value: value,
      onChanged: changed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phool Vector Studio',
            style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            tooltip: 'Share image',
            onPressed: _shareImage,
            icon: const Icon(Icons.share_outlined),
          ),
          IconButton(
            tooltip: 'Save copy',
            onPressed: _saveProjectCopy,
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: const Text('ছবি যোগ করুন'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _saveProjectCopy,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('সেভ'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE5DFEC)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _image == null
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_florist_outlined,
                                        size: 58, color: Color(0xFFB69AD8)),
                                    SizedBox(height: 12),
                                    Text('আপনার ডিজাইন এখানে দেখা যাবে',
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 5),
                                    Text('গ্যালারি থেকে ফুলের ছবি যোগ করুন',
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              )
                            : InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 5,
                                child: Center(
                                  child: Image.file(_image!, fit: BoxFit.contain),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE5DFEC)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Layers',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            _layer('মূল ছবি', _showOriginal, (v) =>
                                setState(() => _showOriginal = v)),
                            _layer('ফুল', _flowerLayer, (v) =>
                                setState(() => _flowerLayer = v)),
                            _layer('পাতা', _leafLayer, (v) =>
                                setState(() => _leafLayer = v)),
                            _layer('লতা', _vineLayer, (v) =>
                                setState(() => _vineLayer = v)),
                            const Spacer(),
                            const Text('নোট',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('এগুলো প্রাথমিক UI লেয়ার। আলাদা করে কাটিং/এডিটিং পরের সংস্করণে যোগ হবে।',
                                style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                padding: const EdgeInsets.all(12),
                scrollDirection: Axis.horizontal,
                children: [
                  _toolButton(Icons.image_outlined, 'Import', _pickImage),
                  const SizedBox(width: 8),
                  _toolButton(Icons.auto_fix_high, 'Remove BG',
                      () => _message('AI Background Removal পরবর্তী সংস্করণে যোগ হবে।')),
                  const SizedBox(width: 8),
                  _toolButton(Icons.polyline, 'Vector SVG',
                      () => _message('Vector tracing পরবর্তী সংস্করণে যোগ হবে।')),
                  const SizedBox(width: 8),
                  _toolButton(Icons.layers_outlined, 'Layers',
                      () => _message('ডান পাশে প্রাথমিক layer panel আছে।')),
                  const SizedBox(width: 8),
                  _toolButton(Icons.file_download_outlined, 'Export',
                      _shareImage),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
              color: const Color(0xFFEDE7F5),
              child: Text(_status,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}
