import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkFilterChip<T> {
  const SilkFilterChip({required this.value, required this.label});

  final T value;
  final String label;
}

/// Horizontally scrollable row of filter chips with an optional sort button.
///
/// Usage:
/// ```dart
/// SilkSortFilterBar<String>(
///   filters: const [
///     SilkFilterChip(value: 'all', label: 'All'),
///     SilkFilterChip(value: 'credit', label: 'Credits'),
///     SilkFilterChip(value: 'debit', label: 'Debits'),
///   ],
///   selected: _filter,
///   onSelected: (v) => setState(() => _filter = v),
///   onSortTap: _showSortSheet,
///   sortActive: _sortApplied,
/// )
/// ```
class SilkSortFilterBar<T> extends StatelessWidget {
  const SilkSortFilterBar({
    required this.filters,
    required this.selected,
    required this.onSelected,
    this.onSortTap,
    this.sortLabel = 'Sort',
    this.sortActive = false,
    super.key,
  });

  final List<SilkFilterChip<T>> filters;
  final T? selected;
  final void Function(T?) onSelected;
  final VoidCallback? onSortTap;
  final String sortLabel;

  /// Highlights the sort button when a sort is currently applied.
  final bool sortActive;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              itemCount: filters.length,
              separatorBuilder: (_, __) =>
                  SizedBox(width: tokens.spaceXs),
              itemBuilder: (context, i) {
                final chip = filters[i];
                final isActive = chip.value == selected;
                return GestureDetector(
                  onTap: () =>
                      onSelected(isActive ? null : chip.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spaceMd,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? tokens.accent
                          : tokens.surfaceMuted,
                      borderRadius:
                          BorderRadius.circular(tokens.radiusPill),
                      border: Border.all(
                        color: isActive
                            ? tokens.accent
                            : tokens.divider,
                      ),
                    ),
                    child: Text(
                      chip.label,
                      style: tokens.captionStyle.copyWith(
                        color: isActive
                            ? Colors.white
                            : tokens.onSurface,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (onSortTap != null) ...[
            VerticalDivider(
              color: tokens.divider,
              width: 1,
              indent: 8,
              endIndent: 8,
            ),
            GestureDetector(
              onTap: onSortTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceMd),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sort_rounded,
                      size: 16,
                      color: sortActive
                          ? tokens.accent
                          : tokens.onSurface,
                    ),
                    SizedBox(width: tokens.spaceXs),
                    Text(
                      sortLabel,
                      style: tokens.captionStyle.copyWith(
                        color: sortActive
                            ? tokens.accent
                            : tokens.onSurface,
                        fontWeight: sortActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
