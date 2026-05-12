import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Heart reaction', type: SilkReactionBurst)
Widget heartReaction(BuildContext context) {
  return Center(
    child: SilkReactionBurst(
      color: const Color(0xFFE0245E),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.favorite_border, size: 24, color: Color(0xFFE0245E)),
            SizedBox(width: 6),
            Text('24', style: TextStyle(color: Color(0xFFE0245E))),
          ],
        ),
      ),
    ),
  );
}

@UseCase(name: 'Thumbs up', type: SilkReactionBurst)
Widget thumbsUpReaction(BuildContext context) {
  return Center(
    child: SilkReactionBurst(
      color: const Color(0xFF5B6CF5),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('👍', style: TextStyle(fontSize: 24)),
            SizedBox(width: 6),
            Text('142', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    ),
  );
}

@UseCase(name: 'Emoji reactions row', type: SilkReactionBurst)
Widget emojiReactionsRow(BuildContext context) {
  const reactions = [
    ('❤️', 24, Color(0xFFE0245E)),
    ('👍', 142, Color(0xFF5B6CF5)),
    ('😂', 8, Color(0xFFF7B731)),
    ('🔥', 3, Color(0xFFFF6348)),
  ];

  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (emoji, count, color) in reactions) ...[
            SilkReactionBurst(
              color: color,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (emoji != '🔥') const SizedBox(width: 4),
          ],
        ],
      ),
    ),
  );
}
