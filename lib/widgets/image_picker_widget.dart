import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImagePickerWidget extends StatelessWidget {
  final String? imageUrl;
  final XFile? pickedImage;
  final String title;
  final VoidCallback onPickImage;
  final bool enabled;
  final double size;
  final bool isLicenseImage;
  final bool supportsPdf;

  const ImagePickerWidget({
    super.key,
    this.imageUrl,
    this.pickedImage,
    required this.title,
    required this.onPickImage,
    this.enabled = true,
    this.size = 120,
    this.isLicenseImage = false,
    this.supportsPdf = false,
  });

  bool get isPdf => pickedImage != null && 
    path.extension(pickedImage!.path).toLowerCase() == '.pdf';

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
          onTap: enabled ? onPickImage : null,
          child: Container(
            width: isLicenseImage ? size * 1.6 : size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(isLicenseImage ? 8 : size / 2),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: _buildContent(),
          ),
        ),
        if (enabled)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Tap to ${imageUrl != null || pickedImage != null ? 'change' : 'upload'}' +
              (supportsPdf ? ' (Image or PDF)' : ''),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (pickedImage != null && isPdf) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isLicenseImage ? 8 : size / 2),
        child: Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf,
                color: Colors.red[700],
                size: size * 0.4,
              ),
              const SizedBox(height: 4),
              Text(
                path.basename(pickedImage!.path),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isLicenseImage ? 8 : size / 2),
        child: _buildImage(),
      );
    }
  }

  Widget _buildImage() {
    if (pickedImage != null && !isPdf) {
      return Image.file(
        File(pickedImage!.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    IconData icon;
    if (isLicenseImage) {
      icon = Icons.credit_card;
    } else if (supportsPdf) {
      icon = Icons.file_upload;
    } else {
      icon = Icons.person;
    }
    
    return Icon(
      icon,
      size: size / 2,
      color: Colors.grey[400],
    );
  }
} 