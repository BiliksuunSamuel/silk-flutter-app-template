import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_dropdown.dart';

class SilkMultiValueSelectInput<T> extends StatelessWidget {
  const SilkMultiValueSelectInput({
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.hint = 'Select options',
    this.label,
    this.errorText,
    this.maxSelectable,
    super.key,
  });

  final List<SilkSelectItem<T>> items;
  final List<T> selectedValues;
  final ValueChanged<List<T>> onChanged;
  final String hint;
  final String? label;
  final String? errorText;

  /// If set, the user cannot select more than this many items.
  final int? maxSelectable;

  List<String> get _selectedLabels {
    return selectedValues
        .map((v) => items.where((i) => i.value == v).firstOrNull?.label ?? v.toString())
        .toList();
  }

  Future<void> _show(BuildContext context) async {
    final tokens = context.tokens;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(tokens.radiusLg)),
      ),
      builder: (_) => _MultiSelectSheet<T>(
        items: items,
        initialSelection: List.of(selectedValues),
        maxSelectable: maxSelectable,
        onConfirm: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labels = _selectedLabels;
    final hasValue = labels.isNotEmpty;

    return GestureDetector(
      onTap: () => _show(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(label!, style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted)),
            SizedBox(height: tokens.spaceXs),
          ],
          AnimatedContainer(
            duration: MotionTokens.fast,
            curve: MotionTokens.standardCurve,
            constraints: const BoxConstraints(minHeight: 52),
            decoration: BoxDecoration(
              color: tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              border: Border.all(
                color: errorText != null ? tokens.danger : tokens.divider,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceMd,
              vertical: hasValue ? tokens.spaceSm : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: hasValue
                      ? Wrap(
                          spacing: tokens.spaceXs,
                          runSpacing: tokens.spaceXs,
                          children: labels
                              .map(
                                (l) => _Chip(
                                  label: l,
                                  onRemove: () {
                                    final idx = labels.indexOf(l);
                                    final newValues = List<T>.of(selectedValues)
                                      ..removeAt(idx);
                                    onChanged(newValues);
                                  },
                                ),
                              )
                              .toList(),
                        )
                      : SizedBox(
                          height: 52,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              hint,
                              style: tokens.bodyStyle.copyWith(
                                color: tokens.onSurfaceMuted,
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(width: tokens.spaceXs),
                Icon(Icons.expand_more, size: 20, color: tokens.onSurfaceMuted),
              ],
            ),
          ),
          if (errorText != null) ...[
            SizedBox(height: tokens.spaceXs),
            Text(
              errorText!,
              style: tokens.captionStyle.copyWith(color: tokens.danger),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: EdgeInsets.only(
        left: tokens.spaceSm,
        right: tokens.spaceXs,
        top: 4,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        color: tokens.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(tokens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: tokens.captionStyle.copyWith(
              color: tokens.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: tokens.accent),
          ),
        ],
      ),
    );
  }
}

class _MultiSelectSheet<T> extends StatefulWidget {
  const _MultiSelectSheet({
    required this.items,
    required this.initialSelection,
    required this.onConfirm,
    this.maxSelectable,
  });

  final List<SilkSelectItem<T>> items;
  final List<T> initialSelection;
  final ValueChanged<List<T>> onConfirm;
  final int? maxSelectable;

  @override
  State<_MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<_MultiSelectSheet<T>> {
  late List<T> _selection;

  @override
  void initState() {
    super.initState();
    _selection = List.of(widget.initialSelection);
  }

  void _toggle(T value) {
    setState(() {
      if (_selection.contains(value)) {
        _selection.remove(value);
      } else {
        final max = widget.maxSelectable;
        if (max != null && _selection.length >= max) return;
        _selection.add(value);
      }
    });
    Haptics.selection();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final max = widget.maxSelectable;
    final atMax = max != null && _selection.length >= max;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: tokens.spaceSm),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: tokens.divider,
              borderRadius: BorderRadius.circular(tokens.radiusPill),
            ),
          ),
          SizedBox(height: tokens.spaceMd),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
                  ),
                ),
                if (max != null)
                  Text(
                    '${_selection.length} / $max',
                    style: tokens.captionStyle.copyWith(
                      color: atMax ? tokens.accent : tokens.onSurfaceMuted,
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    widget.onConfirm(_selection);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Done',
                    style: tokens.bodyStyle.copyWith(
                      color: tokens.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.spaceSm),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.55,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.items.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: tokens.divider,
                indent: tokens.spaceLg,
                endIndent: tokens.spaceLg,
              ),
              itemBuilder: (_, i) {
                final item = widget.items[i];
                final isSelected = _selection.contains(item.value);
                final isDisabled = atMax && !isSelected;

                return _MultiSelectOption(
                  item: item,
                  isSelected: isSelected,
                  isDisabled: isDisabled,
                  onTap: isDisabled ? null : () => _toggle(item.value),
                );
              },
            ),
          ),
          SizedBox(height: tokens.spaceMd),
        ],
      ),
    );
  }
}

class _MultiSelectOption<T> extends StatefulWidget {
  const _MultiSelectOption({
    required this.item,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final SilkSelectItem<T> item;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  State<_MultiSelectOption<T>> createState() => _MultiSelectOptionState<T>();
}

class _MultiSelectOptionState<T> extends State<_MultiSelectOption<T>> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: widget.isDisabled ? 0.4 : (_pressed ? 0.6 : 1.0),
        duration: MotionTokens.micro,
        child: Container(
          color: _pressed ? tokens.surfaceMuted : Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spaceLg,
            vertical: tokens.spaceMd,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: MotionTokens.fast,
                curve: MotionTokens.standardCurve,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: widget.isSelected ? tokens.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(tokens.radiusSm),
                  border: Border.all(
                    color: widget.isSelected ? tokens.accent : tokens.divider,
                    width: 1.5,
                  ),
                ),
                child: widget.isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              SizedBox(width: tokens.spaceMd),
              if (widget.item.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: tokens.onSurface, size: 20),
                  child: widget.item.icon!,
                ),
                SizedBox(width: tokens.spaceSm),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: tokens.bodyStyle.copyWith(
                    color: widget.isSelected ? tokens.accent : tokens.onSurface,
                    fontWeight:
                        widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
