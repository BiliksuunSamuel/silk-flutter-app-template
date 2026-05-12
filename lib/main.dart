import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/app/app.dart';
import 'package:silk/app/bootstrap.dart';

void main() async {
  await bootstrap(() => const ProviderScope(child: SilkApp()));
}
