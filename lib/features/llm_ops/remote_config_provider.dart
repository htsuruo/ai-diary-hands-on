import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_provider.g.dart';

@Riverpod(keepAlive: true)
Future<FirebaseRemoteConfig> remoteConfig(Ref ref) async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // デフォルト値を設定
  await remoteConfig.setDefaults({
    'ai_feedback_template_id': 'diary-feedback-v1-0-0',
  });

  // 開発中は短いフェッチ間隔を設定
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ),
  );

  // 値をフェッチして有効化
  await remoteConfig.fetchAndActivate();

  // リアルタイム更新を購読
  remoteConfig.onConfigUpdated.listen((event) async {
    await remoteConfig.activate();
    ref.invalidateSelf();
  });

  return remoteConfig;
}

@riverpod
Future<String> aiFeedbackTemplateId(Ref ref) async {
  final config = await ref.watch(remoteConfigProvider.future);
  return config.getString('ai_feedback_template_id');
}
