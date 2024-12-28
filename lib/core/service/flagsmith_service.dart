import 'dart:convert';

import 'package:flagsmith/flagsmith.dart';

class FlagSmithService {
  static const _apikey = 'R7QoLuw8SGLThBfYRQ3VVN';

  late FlagsmithClient _flagsmithClient;

  late String _link;
  late bool _usePrivacy;
  late final String _privacyLink;
  late final String _termsLink;

  Future<FlagSmithService> init() async {
    _flagsmithClient = await FlagsmithClient.init(
      apiKey: _apikey,
      config: const FlagsmithConfig(
        caches: true,
      ),
    );
    await _flagsmithClient.getFeatureFlags(reload: true);

    final config = jsonDecode(
        await _flagsmithClient.getFeatureFlagValue(ConfigKey.config.name) ??
            '') as Map<String, dynamic>;

    _link = config[ConfigKey.link.name];
    _usePrivacy = config[ConfigKey.usePrivacy.name];
    _privacyLink = config[ConfigKey.privacyLink.name];
    _termsLink = config[ConfigKey.termsLink.name];
    return this;
  }

  void closeClient() => _flagsmithClient.close();

  bool get usePrivacy => _usePrivacy;

  String get link => _link;

  String get privacyLink => _privacyLink;

  String get termsLink => _termsLink;
}

enum ConfigKey {
  config,
  link,
  usePrivacy,
  privacyLink,
  termsLink,
}