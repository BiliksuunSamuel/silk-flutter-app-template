import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_back_button.dart';

class SilkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SilkAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.blurBackground = false,
    this.bottom,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool blurBackground;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      backgroundColor: tokens.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: leading ??
          (showBackButton && canPop
              ? Padding(
                  padding: EdgeInsets.only(left: tokens.spaceSm),
                  child: const SilkBackButton(),
                )
              : null),
      automaticallyImplyLeading: false,
      title: Text(title, style: tokens.titleStyle),
      actions: actions != null
          ? [
              ...actions!,
              SizedBox(width: tokens.spaceSm),
            ]
          : null,
      bottom: bottom,
    );
  }
}
