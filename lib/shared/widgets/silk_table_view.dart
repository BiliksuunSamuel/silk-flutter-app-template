import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkTableColumn {
  const SilkTableColumn({
    required this.label,
    this.flex = 1,
    this.alignment = TextAlign.left,
    this.numeric = false,
  });

  final String label;
  final int flex;
  final TextAlign alignment;

  /// When true the column header shows a sort indicator when active.
  final bool numeric;
}

/// Sortable data table with alternating row shading.
/// Tap a column header to sort ascending then descending.
///
/// Usage:
/// ```dart
/// SilkTableView(
///   columns: const [
///     SilkTableColumn(label: 'Asset'),
///     SilkTableColumn(label: 'Value', numeric: true),
///     SilkTableColumn(label: 'Return', numeric: true),
///   ],
///   rows: const [
///     ['Equities', r'$8,200', '+12.4%'],
///     ['Bonds', r'$3,100', '+4.1%'],
///   ],
/// )
/// ```
class SilkTableView extends StatefulWidget {
  const SilkTableView({
    required this.columns,
    required this.rows,
    this.onRowTap,
    super.key,
  });

  final List<SilkTableColumn> columns;
  final List<List<String>> rows;
  final void Function(int rowIndex)? onRowTap;

  @override
  State<SilkTableView> createState() => _SilkTableViewState();
}

class _SilkTableViewState extends State<SilkTableView> {
  int? _sortColumn;
  bool _sortAsc = true;
  late List<List<String>> _sorted;

  @override
  void initState() {
    super.initState();
    _sorted = List.from(widget.rows);
  }

  @override
  void didUpdateWidget(SilkTableView old) {
    super.didUpdateWidget(old);
    if (old.rows != widget.rows) {
      _sorted = List.from(widget.rows);
      _applySort();
    }
  }

  void _onHeaderTap(int col) {
    setState(() {
      if (_sortColumn == col) {
        _sortAsc = !_sortAsc;
      } else {
        _sortColumn = col;
        _sortAsc = true;
      }
      _applySort();
    });
  }

  void _applySort() {
    if (_sortColumn == null) return;
    final col = _sortColumn!;
    _sorted.sort((a, b) {
      final av = a.length > col ? a[col] : '';
      final bv = b.length > col ? b[col] : '';
      final numA = double.tryParse(av.replaceAll(RegExp('[^0-9.-]'), ''));
      final numB = double.tryParse(bv.replaceAll(RegExp('[^0-9.-]'), ''));
      final cmp = (numA != null && numB != null)
          ? numA.compareTo(numB)
          : av.compareTo(bv);
      return _sortAsc ? cmp : -cmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: tokens.divider),
        borderRadius: BorderRadius.circular(tokens.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          ColoredBox(
            color: tokens.surfaceMuted,
            child: Row(
              children: [
                for (var i = 0; i < widget.columns.length; i++)
                  Expanded(
                    flex: widget.columns[i].flex,
                    child: GestureDetector(
                      onTap: () => _onHeaderTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: tokens.spaceMd,
                          vertical: tokens.spaceSm + 2,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              widget.columns[i].alignment == TextAlign.right
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.columns[i].label,
                              style: tokens.captionStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _sortColumn == i
                                    ? tokens.accent
                                    : tokens.onSurface,
                              ),
                            ),
                            if (_sortColumn == i) ...[
                              const SizedBox(width: 2),
                              Icon(
                                _sortAsc
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                size: 12,
                                color: tokens.accent,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(color: tokens.divider, height: 1),
          // Rows
          for (var r = 0; r < _sorted.length; r++) ...[
            GestureDetector(
              onTap: widget.onRowTap != null
                  ? () => widget.onRowTap!(r)
                  : null,
              behavior: HitTestBehavior.opaque,
              child: ColoredBox(
                color: r.isOdd
                    ? tokens.surfaceMuted.withValues(alpha: 0.5)
                    : Colors.transparent,
                child: Row(
                  children: [
                    for (var c = 0; c < widget.columns.length; c++)
                      Expanded(
                        flex: widget.columns[c].flex,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: tokens.spaceMd,
                            vertical: tokens.spaceSm + 2,
                          ),
                          child: Text(
                            c < _sorted[r].length ? _sorted[r][c] : '',
                            style: tokens.bodySmStyle,
                            textAlign: widget.columns[c].alignment,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (r < _sorted.length - 1)
              Divider(color: tokens.divider, height: 1),
          ],
        ],
      ),
    );
  }
}
