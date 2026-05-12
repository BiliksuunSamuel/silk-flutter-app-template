// Usage: dart run tool/new_feature.dart <feature_name>
// Creates the standard feature slice under lib/features/<feature_name>/.
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run tool/new_feature.dart <feature_name>');
    exit(1);
  }

  final raw = args.first.trim();
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(raw)) {
    stderr.writeln(
      'Feature name must be snake_case and start with a lowercase letter.',
    );
    exit(1);
  }

  final name = raw;
  final pascal = _toPascalCase(name);
  final base = 'lib/features/$name';

  final files = <String, String>{
    // Data layer
    '$base/data/models/${name}_model.dart': _model(name, pascal),
    '$base/data/${name}_api.dart': _api(name, pascal),
    '$base/data/${name}_repository.dart': _repository(name, pascal),

    // Domain layer
    '$base/domain/${name}_entity.dart': _entity(name, pascal),

    // Presentation — providers
    '$base/presentation/providers/${name}_controller.dart':
        _controller(name, pascal),

    // Presentation — screens
    '$base/presentation/screens/${name}_screen.dart': _screen(name, pascal),
  };

  for (final entry in files.entries) {
    final file = File(entry.key);
    file.parent.createSync(recursive: true);
    if (file.existsSync()) {
      stdout.writeln('skip  ${entry.key}  (already exists)');
    } else {
      file.writeAsStringSync(entry.value);
      stdout.writeln('create ${entry.key}');
    }
  }

  stdout
    ..writeln('\nDone. Next steps:')
    ..writeln('  1. Add route in lib/core/router/app_router.dart')
    ..writeln('  2. Add path constant in lib/core/router/route_paths.dart')
    ..writeln(
      '  3. Run: dart run build_runner build --delete-conflicting-outputs',
    )
    ..writeln(
      '  4. Add a widgetbook use case for any new Silk* widgets in widgetbook/use_cases/',
    );
}

String _toPascalCase(String snake) {
  return snake.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
}

String _model(String name, String pascal) => '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${name}_model.freezed.dart';
part '${name}_model.g.dart';

@freezed
abstract class ${pascal}Model with _\$${pascal}Model {
  const factory ${pascal}Model({
    required String id,
  }) = _${pascal}Model;

  factory ${pascal}Model.fromJson(Map<String, dynamic> json) =>
      _\$${pascal}ModelFromJson(json);
}
''';

String _api(String name, String pascal) => '''
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/network/dio_provider.dart';
import 'package:silk/features/$name/data/models/${name}_model.dart';

part '${name}_api.g.dart';

@riverpod
${pascal}Api ${name}Api(${pascal}ApiRef ref) => ${pascal}Api(ref.watch(dioProvider));

class ${pascal}Api {
  const ${pascal}Api(this._dio);

  final Dio _dio;

  Future<List<${pascal}Model>> getAll() async {
    final response = await _dio.get<List<dynamic>>('/$name');
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(${pascal}Model.fromJson)
        .toList();
  }
}
''';

String _repository(String name, String pascal) => '''
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/error/app_failure.dart';
import 'package:silk/core/error/failure_mapper.dart';
import 'package:silk/core/network/api_exception_mapper.dart';
import 'package:silk/core/network/result.dart';
import 'package:silk/features/$name/data/${name}_api.dart';
import 'package:silk/features/$name/domain/${name}_entity.dart';

part '${name}_repository.g.dart';

@riverpod
${pascal}Repository ${name}Repository(${pascal}RepositoryRef ref) =>
    ${pascal}Repository(ref.watch(${name}ApiProvider));

class ${pascal}Repository {
  const ${pascal}Repository(this._api);

  final ${pascal}Api _api;

  Future<Result<List<${pascal}Entity>, AppFailure>> getAll() async {
    try {
      final models = await _api.getAll();
      return Result.success(
        models.map((m) => ${pascal}Entity(id: m.id)).toList(),
      );
    } on DioException catch (e) {
      return Result.failure(FailureMapper.from(DioExceptionMapper.map(e)));
    } on Exception catch (e) {
      return Result.failure(AppFailure.unknown(e.toString()));
    }
  }
}
''';

String _entity(String name, String pascal) => '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${name}_entity.freezed.dart';

@freezed
abstract class ${pascal}Entity with _\$${pascal}Entity {
  const factory ${pascal}Entity({
    required String id,
  }) = _${pascal}Entity;
}
''';

String _controller(String name, String pascal) => '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/network/result.dart';
import 'package:silk/features/$name/domain/${name}_entity.dart';
import 'package:silk/features/$name/data/${name}_repository.dart';

part '${name}_controller.g.dart';

@riverpod
class ${pascal}Controller extends _\$${pascal}Controller {
  @override
  Future<List<${pascal}Entity>> build() => _load();

  Future<List<${pascal}Entity>> _load() async {
    final result = await ref.read(${name}RepositoryProvider).getAll();
    return result.when(
      success: (items) => items,
      failure: (e) => throw e,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }
}
''';

String _screen(String name, String pascal) => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/error/app_failure.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/features/$name/presentation/providers/${name}_controller.dart';

class ${pascal}Screen extends ConsumerWidget {
  const ${pascal}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final state = ref.watch(${name}ControllerProvider);

    return Scaffold(
      backgroundColor: tokens.surface,
      body: state.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => ListTile(title: Text(items[i].id)),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(e is AppFailure ? e.userMessage : e.toString()),
        ),
      ),
    );
  }
}
''';
