import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A tappable file upload zone that shows empty, selected, and loading states.
class SilkFileUploadZone extends StatelessWidget {
  const SilkFileUploadZone({
    required this.onTap,
    this.fileName,
    this.fileSize,
    this.isLoading = false,
    this.hint = 'Tap to upload or drag a file here',
    this.acceptLabel = 'PDF, JPG, PNG up to 10MB',
    this.icon = Icons.upload_file_outlined,
    this.onClear,
    super.key,
  });

  final VoidCallback onTap;
  final String? fileName;
  final String? fileSize;
  final bool isLoading;
  final String hint;
  final String acceptLabel;
  final IconData icon;
  final VoidCallback? onClear;

  bool get _hasFile => fileName != null;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final borderColor = _hasFile ? tokens.accent : tokens.divider;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: borderColor,
          radius: tokens.radiusLg,
          dashWidth: 6,
          dashGap: 4,
          strokeWidth: 1.5,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(tokens.spaceLg),
          decoration: BoxDecoration(
            color: _hasFile
                ? tokens.accent.withValues(alpha: 0.04)
                : tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(tokens.radiusLg),
          ),
          child: isLoading
              ? const _LoadingContent()
              : _hasFile
                  ? _FileContent(
                      fileName: fileName!,
                      fileSize: fileSize,
                      onClear: onClear,
                    )
                  : _EmptyContent(
                      icon: icon,
                      hint: hint,
                      acceptLabel: acceptLabel,
                    ),
        ),
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent({
    required this.icon,
    required this.hint,
    required this.acceptLabel,
  });

  final IconData icon;
  final String hint;
  final String acceptLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 36, color: tokens.onSurfaceMuted),
        SizedBox(height: tokens.spaceSm),
        Text(
          hint,
          style: tokens.bodySmStyle.copyWith(color: tokens.onSurface),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: tokens.spaceXs),
        Text(
          acceptLabel,
          style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FileContent extends StatelessWidget {
  const _FileContent({
    required this.fileName,
    required this.fileSize,
    required this.onClear,
  });

  final String fileName;
  final String? fileSize;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Icon(Icons.insert_drive_file_outlined, size: 28, color: tokens.accent),
        SizedBox(width: tokens.spaceSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fileName,
                style: tokens.bodySmStyle.copyWith(
                  color: tokens.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (fileSize != null) ...[
                const SizedBox(height: 2),
                Text(
                  fileSize!,
                  style: tokens.captionStyle.copyWith(
                    color: tokens.onSurfaceMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (onClear != null)
          GestureDetector(
            onTap: onClear,
            child: Padding(
              padding: EdgeInsets.all(tokens.spaceXs),
              child:
                  Icon(Icons.close, size: 18, color: tokens.onSurfaceMuted),
            ),
          ),
      ],
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(tokens.accent),
          ),
        ),
        SizedBox(height: tokens.spaceSm),
        Text(
          'Uploading…',
          style: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final segmentLength =
            (metric.length - distance).clamp(0.0, dashWidth);
        canvas.drawPath(
          metric.extractPath(distance, distance + segmentLength),
          paint,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth;
}
