import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_badge.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'All Variants', type: SilkBadge)
Widget allBadges(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: const [
        SilkBadge(label: 'Accent'),
        SilkBadge(label: 'Success', variant: SilkBadgeVariant.success),
        SilkBadge(label: 'Danger', variant: SilkBadgeVariant.danger),
        SilkBadge(label: 'Muted', variant: SilkBadgeVariant.muted),
        SilkBadge.count(count: 99),
      ],
    ),
  );
}
