import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_hidoc/config/router/app_router.dart';
import 'package:proyecto_hidoc/common/theme/app_theme.dart';
import 'package:proyecto_hidoc/common/theme/theme_provider.dart';
import 'package:proyecto_hidoc/providers/chat_provider.dart';
import 'package:provider/provider.dart';

//void main() {
//  runApp(const ProviderScope(child: MainApp()));
//}
void main(){
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const ProviderScope(child: MainApp()),
    ),
  );
}
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'HiDoc!',
      routerConfig: appRouter,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: mode, 
    );
  }
}