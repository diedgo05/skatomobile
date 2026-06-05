import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_routes.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/presentation/providers/auth_session_viewmodel.dart';

void main() {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
      MultiProvider(
        providers: DependencyInjection.providers(),
        child: const _Bootstrap(),
      ),
    );
  } catch (e, stack) {
    debugPrint('❌ Error fatal durante el bootstrap: $e');
    debugPrint('$stack');
    runApp(_FatalErrorApp(error: e.toString()));
  } finally {
    debugPrint('✅ main() finalizado, control cedido a Flutter.');
  }
}

class _Bootstrap extends StatefulWidget {
  const _Bootstrap();

  @override
  State<_Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<_Bootstrap> {
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _decideInitialRoute();
  }

  Future<void> _decideInitialRoute() async {
    final tokenStorage = context.read<TokenStorage>();
    if (await tokenStorage.hasToken()) {
      try {
        final user = await context.read<GetCurrentUserUseCase>().call();
        if (!mounted) return;
        context.read<AuthSession>().setUser(user);
        setState(() => _initialRoute = AppRoutes.tricks);
        return;
      } catch (_) {
        await tokenStorage.clear();
      }
    }
    if (mounted) setState(() => _initialRoute = AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    if (_initialRoute == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return SkatoApp(initialRoute: _initialRoute!);
  }
}

/// Pantalla mínima de respaldo si la inicialización falla por completo.
/// La activa el catch de main().
class _FatalErrorApp extends StatelessWidget {
  final String error;
  const _FatalErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 56),
                  const SizedBox(height: 12),
                  const Text('No se pudo iniciar la app'),
                  const SizedBox(height: 8),
                  Text(error, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}