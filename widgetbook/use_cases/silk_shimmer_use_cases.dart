import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_shimmer.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Row Skeletons', type: SilkShimmer)
Widget rowSkeletons(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SilkShimmer(width: 56, height: 56, borderRadius: 28),
        const SizedBox(height: 16),
        const SilkShimmer(width: 200, height: 16),
        const SizedBox(height: 8),
        const SilkShimmer(width: 140, height: 12),
        const SizedBox(height: 24),
        const SilkShimmer(width: double.infinity, height: 120),
      ],
    ),
  );
}
