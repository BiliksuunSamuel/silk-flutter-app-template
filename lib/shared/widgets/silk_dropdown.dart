import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkSelectItem<T> {
  const SilkSelectItem({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final Widget? icon;
}

class SilkDropdown<T> extends StatelessWidget {
  const SilkDropdown({
    required this.items,
    required this.onChanged,
    this.value,
    this.hint = 'Select an option',
    this.label,
    this.errorText,
    super.key,
  });

  final List<SilkSelectItem<T>> items;
  final T? value;
  final ValueChanged<T> onChanged;
  final String hint;
  final String? label;
  final String? errorText;

  String? get _selectedLabel {
    if (value == null) return null;
    return items.where((i) => i.value == value).firstOrNull?.label;
  }

  Future<void> _show(BuildContext context) async {
    final tokens = context.tokens;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(tokens.radiusLg)),
      ),
      builder: (_) => _DropdownSheet<T>(
        items: items,
        selectedValue: value,
        onSelected: (v) {
          Navigator.of(context).pop();
          onChanged(v);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final label_ = _selectedLabel;
    final hasValue = label_ != null;

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
            height: 52,
            decoration: BoxDecoration(
              color: tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              border: Border.all(
                color: errorText != null ? tokens.danger : tokens.divider,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: tokens.spaceMd),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? label_ : hint,
                    style: tokens.bodyStyle.copyWith(
                      color: hasValue ? tokens.onSurface : tokens.onSurfaceMuted,
                    ),
                  ),
                ),
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

class _DropdownSheet<T> extends StatelessWidget {
  const _DropdownSheet({
    required this.items,
    required this.onSelected,
    this.selectedValue,
  });

  final List<SilkSelectItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: tokens.divider,
                indent: tokens.spaceLg,
                endIndent: tokens.spaceLg,
              ),
              itemBuilder: (_, i) {
                final item = items[i];
                final isSelected = item.value == selectedValue;
                return _DropdownOption(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    Haptics.light();
                    onSelected(item.value);
                  },
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

class _DropdownOption<T> extends StatefulWidget {
  const _DropdownOption({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final SilkSelectItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_DropdownOption<T>> createState() => _DropdownOptionState<T>();
}

class _DropdownOptionState<T> extends State<_DropdownOption<T>> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.6 : 1.0,
        duration: MotionTokens.micro,
        child: Container(
          color: _pressed ? tokens.surfaceMuted : Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spaceLg,
            vertical: tokens.spaceMd,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: tokens.onSurface, size: 20),
                  child: widget.item.icon!,
                ),
                SizedBox(width: tokens.spaceMd),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: tokens.bodyStyle.copyWith(
                    color: widget.isSelected ? tokens.accent : tokens.onSurface,
                    fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (widget.isSelected)
                Icon(Icons.check, size: 18, color: tokens.accent),
            ],
          ),
        ),
      ),
    );
  }
}
