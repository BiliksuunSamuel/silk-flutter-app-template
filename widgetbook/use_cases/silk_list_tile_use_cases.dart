import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_avatar.dart';
import 'package:silk/shared/widgets/silk_badge.dart';
import 'package:silk/shared/widgets/silk_list_tile.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Simple', type: SilkListTile)
Widget simpleListTile(BuildContext context) {
  return SilkListTile(
    title: const Text('Notifications'),
    onTap: () {},
  );
}

@UseCase(name: 'With Leading and Subtitle', type: SilkListTile)
Widget fullListTile(BuildContext context) {
  return SilkListTile(
    leading: const SilkAvatar(size: 40, initials: 'AB'),
    title: const Text('Alex Brown'),
    subtitle: const Text('Hey, are you coming tonight?'),
    trailing: const SilkBadge.count(count: 3),
    onTap: () {},
  );
}

@UseCase(name: 'List', type: SilkListTile)
Widget listOfTiles(BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: 5,
    itemBuilder: (_, i) => SilkListTile(
      leading: SilkAvatar(size: 40, initials: 'User $i'),
      title: Text('Contact $i'),
      subtitle: const Text('Last message preview'),
      onTap: () {},
    ),
  );
}
