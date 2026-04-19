import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PhotoStorage {
  PhotoStorage._();
  static final PhotoStorage instance = PhotoStorage._();

  Future<Directory> get _photosDir async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'plant_photos'));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  /// Copies [sourceFile] into app storage and returns the saved path.
  Future<String> save(File sourceFile, String plantId) async {
    final dir = await _photosDir;
    final ext = p.extension(sourceFile.path).isNotEmpty
        ? p.extension(sourceFile.path)
        : '.jpg';
    final dest = File(p.join(dir.path, '$plantId$ext'));
    await sourceFile.copy(dest.path);
    return dest.path;
  }

  /// Deletes the photo file at [path] if it exists.
  Future<void> delete(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (file.existsSync()) await file.delete();
  }
}
