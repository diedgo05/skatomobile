import 'package:flutter/material.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/theme.dart';
import 'core/theme/util.dart';

class SkatoApp extends StatelessWidget {
  final String initialRoute;
  const SkatoApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // 1) Tipografía: "Aleo" para body/label, "Actor" para titulares.
    final textTheme = createTextTheme(context, "Aleo", "Actor");

    // 2) Construye el tema de Material Theme Builder con esa tipografía.
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Skato',
      debugShowCheckedModeBanner: false,
      // 3) Aplicamos light/dark y dejamos que el sistema elija.

      theme: _withComponentStyles(materialTheme.light()),
      darkTheme: _withComponentStyles(materialTheme.dark()),
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }

  ThemeData _withComponentStyles(ThemeData base) {
    final scheme = base.colorScheme;
    return base.copyWith(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}