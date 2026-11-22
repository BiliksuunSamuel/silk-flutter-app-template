import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/frosted_bar.dart';
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
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final canPop = Navigator.of(context).canPop();

    // Solid UI: transparent over the canvas (or frosted when requested); a
    // hairline appears only once content scrolls under the bar.
    return AppBar(
      backgroundColor: blurBackground ? Colors.transparent : tokens.canvas,
      flexibleSpace: blurBackground
          ? const FrostedBar(showHairline: false, child: SizedBox.expand())
          : null,
      surfaceTintColor: Colors.transparent,
      shadowColor: tokens.hairlineStrong,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: true,
      leading:
          leading ??
          (showBackButton && canPop
              ? Padding(
                  padding: EdgeInsets.only(left: tokens.spaceSm),
                  child: const SilkBackButton(),
                )
              : null),
      automaticallyImplyLeading: false,
      title: Text(title, style: tokens.titleSmStyle),
      actions: actions != null
          ? [...actions!, SizedBox(width: tokens.spaceSm)]
          : null,
      bottom: bottom,
    );
  }
}
