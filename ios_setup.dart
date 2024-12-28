import 'dart:io';

void main(List<String> arguments) async {
  if (arguments.length != 2) {
    exit(1);
  }

  final bundleId = arguments[0];
  final displayName = arguments[1].replaceAll("", '');
  print('BundleID: $bundleId');
  print('DisplayName: $displayName');

  // Путь к проекту iOS
  const iosProjectPath = 'ios/Runner.xcodeproj/project.pbxproj';
  const infoPlistPath = 'ios/Runner/Info.plist';
  const podfilePath = 'ios/Podfile';

  await setBundleId(bundleId);
  await setDisplayName(displayName, infoPlistPath);
  await updatePodfilePlatform(podfilePath);
  await removeDestinations(iosProjectPath);
  await setDeploymentTargetInPBXProj(iosProjectPath, '13.0');

  print('iOS module successfully configured.');
}

// Устанавливаем Bundle ID
Future<void> setBundleId(String bundleId) async {
  print('Setting bundle ID...');
  final pbxprojFile = File('ios/Runner.xcodeproj/project.pbxproj');
  if (!pbxprojFile.existsSync()) {
    throw Exception('iOS project file not found');
  }
  final content = await pbxprojFile.readAsString();
  final updatedContent = content.replaceAllMapped(
      RegExp('(PRODUCT_BUNDLE_IDENTIFIER = )(.*?);'), (match) {
    return '${match[1]}$bundleId;';
  });
  await pbxprojFile.writeAsString(updatedContent);
  print('Bundle ID set to $bundleId');
}

// Устанавливаем Display Name и CFBundleName
Future<void> setDisplayName(String displayName, String infoPlistPath) async {
  print('Setting display name and CFBundleName...');

  // 1. Обновляем Info.plist
  final infoPlistFile = File(infoPlistPath);
  if (!infoPlistFile.existsSync()) {
    throw Exception('Info.plist not found');
  }

  var content = await infoPlistFile.readAsString();
  content = content.replaceAllMapped(
      RegExp(r'(<key>CFBundleDisplayName<\/key>\s*<string>)(.*?)(<\/string>)'),
      (match) {
    return '${match[1]}$displayName${match[3]}';
  }).replaceAllMapped(
      RegExp(r'(<key>CFBundleName<\/key>\s*<string>)(.*?)(<\/string>)'),
      (match) {
    return '${match[1]}$displayName${match[3]}';
  });

  await infoPlistFile.writeAsString(content);
  print('Display Name and CFBundleName set to $displayName in Info.plist');

  // 2. Обновляем значение INFOPLIST_KEY_CFBundleDisplayName в project.pbxproj
  await setCFBundleDisplayNameInPBXProj(displayName);
}

// Обновляем значение INFOPLIST_KEY_CFBundleDisplayName в project.pbxproj
Future<void> setCFBundleDisplayNameInPBXProj(String displayName) async {
  print('Setting INFOPLIST_KEY_CFBundleDisplayName in project.pbxproj...');

  final pbxprojFile = File('ios/Runner.xcodeproj/project.pbxproj');
  if (!pbxprojFile.existsSync()) {
    throw Exception('iOS project file not found');
  }

  var content = await pbxprojFile.readAsString();

  // Используем регулярное выражение для поиска и замены INFOPLIST_KEY_CFBundleDisplayName
  content = content.replaceAllMapped(
      RegExp('(INFOPLIST_KEY_CFBundleDisplayName = )(.*?);'), (match) {
    return '${match[1]}"$displayName";';
  });

  await pbxprojFile.writeAsString(content);
  print('INFOPLIST_KEY_CFBundleDisplayName set to $displayName in project.pbxproj');
}

// Обновляем значение IPHONEOS_DEPLOYMENT_TARGET в project.pbxproj
Future<void> setDeploymentTargetInPBXProj(
    String iosProjectPath, String deploymentTarget) async {
  print('Setting IPHONEOS_DEPLOYMENT_TARGET to $deploymentTarget in project.pbxproj...');

  final pbxprojFile = File(iosProjectPath);
  if (!pbxprojFile.existsSync()) {
    throw Exception('iOS project file not found');
  }

  var content = await pbxprojFile.readAsString();

  // Используем регулярное выражение для поиска и замены IPHONEOS_DEPLOYMENT_TARGET
  content = content.replaceAllMapped(
      RegExp('(IPHONEOS_DEPLOYMENT_TARGET = )(.*?);'), (match) {
    return '${match[1]}$deploymentTarget;';
    return '${match[1]}$deploymentTarget;';
  });

  await pbxprojFile.writeAsString(content);
  print('IPHONEOS_DEPLOYMENT_TARGET set to $deploymentTarget in project.pbxproj.');
}

// Устанавливаем версию платформы в Podfile
// Обновляем платформу в Podfile на '13.0'
Future<void> updatePodfilePlatform(String podfilePath) async {
  print('Updating iOS platform in Podfile...');

  try {
    final podfile = File(podfilePath);
  if (!podfile.existsSync()) {
    throw Exception('Podfile not found');
  }

  var content = await podfile.readAsString();

  // Заменяем любую строку с platform :ios (включая закомментированную) на platform :ios, '13.0'
  content =
      content.replaceAllMapped(RegExp("# platform :ios, '12.0'"), (match) {
    return "platform :ios, '13.0'";
  });

  await podfile.writeAsString(content);
  print('Podfile updated to iOS platform 13.0.');
  } catch (e) {
    print('Podfile was not found');
  }
}

// Убираем лишние девайсы (iPad, Mac, Apple Vision)
Future<void> removeDestinations(String iosProjectPath) async {
  print('Updating TARGETED_DEVICE_FAMILY to iPhone only...');
  final pbxprojFile = File(iosProjectPath);
  if (!pbxprojFile.existsSync()) {
    throw Exception('iOS project file not found');
  }
  var content = await pbxprojFile.readAsString();

  // Меняем значение TARGETED_DEVICE_FAMILY на 1 (только iPhone)
  content = content
      .replaceAllMapped(RegExp('(TARGETED_DEVICE_FAMILY = )(.*?);'), (match) {
    return '${match[1]}"1";';
  });

  await pbxprojFile.writeAsString(content);
  print('TARGETED_DEVICE_FAMILY updated to iPhone only.');
}
