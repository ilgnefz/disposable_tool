import 'package:disposable_tool/pages/home.dart';
import 'package:disposable_tool/provider/app.dart';
import 'package:disposable_tool/provider/file_directory.dart';
import 'package:disposable_tool/provider/read_json.dart';
import 'package:disposable_tool/utils/generate_assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(800, 600),
    center: true,
  );

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  generateAssets('assets', 'my_value');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ReadJsonProvider()),
        ChangeNotifierProvider(create: (_) => FileDirectoryProvider()),
      ],
      child: MaterialApp(
        title: 'Disposable Tool',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'MiSans',
        ),
        home: const HomePage(),
      ),
    );
  }
}
