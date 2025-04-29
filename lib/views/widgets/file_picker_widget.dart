import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FilePickerWidget extends StatelessWidget {
  final File? pickedFile;
  final String title;
  final VoidCallback onPickFile;
  final String fileType;
  final bool isDocumentFile;

  const FilePickerWidget({
    super.key,
    this.pickedFile,
    required this.title,
    required this.onPickFile,
    this.fileType = 'image',
    this.isDocumentFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickFile,
          child: Container(
            width: isDocumentFile ? 200 : 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(isDocumentFile ? 8 : 60),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: _buildFilePreview(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Tap to ${pickedFile != null ? 'change' : 'upload'}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        if (pickedFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              fileType == 'pdf' 
                  ? path.basename(pickedFile!.path) 
                  : 'Image file',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildFilePreview() {
    if (pickedFile == null) {
      return _buildPlaceholder();
    }

    if (fileType == 'pdf') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 40,
              color: Colors.red[700],
            ),
            const SizedBox(height: 4),
            const Text(
              'PDF Document',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isDocumentFile ? 8 : 60),
        child: Image.file(
          pickedFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
  }

  Widget _buildPlaceholder() {
    IconData iconData = Icons.person;
    if (isDocumentFile) {
      iconData = Icons.file_copy;
    }

    return Center(
      child: Icon(
        iconData,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
} 