import 'package:bot_toast/bot_toast.dart';
import 'package:disposable_tool/pages/home.dart';
import 'package:disposable_tool/provider/app.dart';
import 'package:disposable_tool/provider/file_explorer.dart';
import 'package:disposable_tool/provider/generate_json.dart';
import 'package:disposable_tool/provider/read_json.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
    size: Size(1200, 700),
    minimumSize: Size(1200, 700),
    center: true,
  );

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  MediaKit.ensureInitialized();

  // generateAssets('assets', 'my_value');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ReadJsonProvider()),
        ChangeNotifierProvider(create: (_) => FileExplorerProvider()),
        ChangeNotifierProvider(create: (_) => GenerateJsonProvider()),
      ],
      child: MaterialApp(
        title: 'Disposable Tool',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'MiSans',
        ),
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [BotToastNavigatorObserver()],
        home: const HomePage(),
      ),
    );
  }
}
