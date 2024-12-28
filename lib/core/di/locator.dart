import 'package:get_it/get_it.dart';
import 'package:habit_app/core/service/flagsmith_service.dart';

class ServiceLocator {
  static Future<void> setup() async {
    GetIt.I.registerSingletonAsync<FlagSmithService>(
          () => FlagSmithService().init(),
    );

    await GetIt.I.isReady<FlagSmithService>();
  }
}