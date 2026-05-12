import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_shimmer.dart';

enum _SkelType { listItem, card, text }

class SilkSkeleton extends StatelessWidget {
  const SilkSkeleton.listItem({super.key})
      : _type = _SkelType.listItem,
        _lines = 0;

  const SilkSkeleton.card({super.key})
      : _type = _SkelType.card,
        _lines = 0;

  const SilkSkeleton.text({int lines = 3, super.key})
      : _type = _SkelType.text,
        _lines = lines;

  final _SkelType _type;
  final int _lines;

  @override
  Widget build(BuildContext context) {
    return switch (_type) {
      _SkelType.listItem => _buildListItem(context),
      _SkelType.card => _buildCard(context),
      _SkelType.text => _buildText(context),
    };
  }

  Widget _buildListItem(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        SilkShimmer(width: 44, height: 44, borderRadius: tokens.radiusPill),
        SizedBox(width: tokens.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SilkShimmer(width: double.infinity, height: 14),
              SizedBox(height: tokens.spaceXs),
              const SilkShimmer(width: 120, height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    final tokens = context.tokens;
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusLg),
      child: ColoredBox(
        color: tokens.surfaceMuted,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SilkShimmer(width: double.infinity, height: 160, borderRadius: 0),
            Padding(
              padding: EdgeInsets.all(tokens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SilkShimmer(width: double.infinity, height: 16),
                  SizedBox(height: tokens.spaceSm),
                  const SilkShimmer(width: 200, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _lines; i++) ...[
          SilkShimmer(
            width: i == _lines - 1 ? 180 : double.infinity,
            height: 14,
          ),
          if (i < _lines - 1) SizedBox(height: tokens.spaceXs),
        ],
      ],
    );
  }
}
