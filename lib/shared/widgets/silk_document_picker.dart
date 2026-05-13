import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkDocumentStatus { empty, selected, uploading, done, error }

/// Visual file-upload tile. Caller manages state and provides a real file
/// picker via [onPick]; this widget only handles the visual layer.
///
/// Usage:
/// ```dart
/// SilkDocumentPicker(
///   label: 'ID document',
///   status: _status,
///   fileName: _fileName,
///   uploadProgress: _progress,
///   onPick: _pickFile,
///   onRemove: _clearFile,
/// )
/// ```
class SilkDocumentPicker extends StatelessWidget {
  const SilkDocumentPicker({
    required this.onPick,
    this.label,
    this.hint = 'Tap to upload document',
    this.acceptedFormats = 'PDF · JPG · PNG',
    this.fileName,
    this.status = SilkDocumentStatus.empty,
    this.uploadProgress,
    this.errorText,
    this.onRemove,
    super.key,
  });

  final VoidCallback onPick;
  final String? label;
  final String hint;

  /// Shown below the hint, e.g. "PDF · JPG · PNG  ·  max 5 MB".
  final String acceptedFormats;

  /// File name displayed when a file is attached.
  final String? fileName;

  final SilkDocumentStatus status;

  /// 0.0–1.0, shown as a progress bar when [status] is
  /// [SilkDocumentStatus.uploading].
  final double? uploadProgress;

  final String? errorText;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasFile = status != SilkDocumentStatus.empty;
    final hasError = status == SilkDocumentStatus.error;
    final isDone = status == SilkDocumentStatus.done;
    final isUploading = status == SilkDocumentStatus.uploading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
          ),
          SizedBox(height: tokens.spaceXs),
        ],
        GestureDetector(
          onTap: isUploading ? null : onPick,
          child: AnimatedContainer(
            duration: MotionTokens.standard,
            padding: EdgeInsets.all(tokens.spaceMd),
            decoration: BoxDecoration(
              color: hasError
                  ? tokens.danger.withValues(alpha: 0.05)
                  : isDone
                      ? tokens.success.withValues(alpha: 0.05)
                      : tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              border: Border.all(
                color: hasError
                    ? tokens.danger
                    : hasFile
                        ? tokens.accent.withValues(alpha: 0.5)
                        : tokens.divider,
                width: hasFile ? 1.5 : 1.0,
              ),
            ),
            child: hasFile
                ? _FileView(
                    fileName: fileName ?? '',
                    status: status,
                    progress: uploadProgress,
                    onRemove: onRemove,
                  )
                : _EmptyView(hint: hint, acceptedFormats: acceptedFormats),
          ),
        ),
        if (hasError && errorText != null) ...[
          SizedBox(height: tokens.spaceXs),
          Text(
            errorText!,
            style: tokens.captionStyle.copyWith(color: tokens.danger),
          ),
        ],
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.hint, required this.acceptedFormats});

  final String hint;
  final String acceptedFormats;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: tokens.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(tokens.radiusSm),
          ),
          child: Icon(
            Icons.upload_file_outlined,
            color: tokens.accent,
            size: 20,
          ),
        ),
        SizedBox(width: tokens.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hint, style: tokens.bodyStyle),
              const SizedBox(height: 2),
              Text(
                acceptedFormats,
                style: tokens.captionStyle
                    .copyWith(color: tokens.onSurfaceMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FileView extends StatelessWidget {
  const _FileView({
    required this.fileName,
    required this.status,
    required this.progress,
    required this.onRemove,
  });

  final String fileName;
  final SilkDocumentStatus status;
  final double? progress;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (icon, iconColor) = switch (status) {
      SilkDocumentStatus.done => (Icons.check_circle_outline, tokens.success),
      SilkDocumentStatus.error => (Icons.error_outline, tokens.danger),
      SilkDocumentStatus.uploading =>
        (Icons.upload_outlined, tokens.accent),
      _ => (Icons.insert_drive_file_outlined, tokens.accent),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            SizedBox(width: tokens.spaceSm),
            Expanded(
              child: Text(
                fileName,
                style: tokens.bodySmStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onRemove != null && status != SilkDocumentStatus.uploading)
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: tokens.onSurfaceMuted,
                ),
              ),
          ],
        ),
        if (status == SilkDocumentStatus.uploading) ...[
          SizedBox(height: tokens.spaceXs),
          ClipRRect(
            borderRadius: BorderRadius.circular(tokens.radiusPill),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: tokens.divider,
              valueColor: AlwaysStoppedAnimation<Color>(tokens.accent),
              minHeight: 4,
            ),
          ),
        ],
      ],
    );
  }
}
