import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/tricks/domain/entities/trick.dart';
import '../../features/tricks/domain/usecases/create_trick_usecase.dart';
import '../../features/tricks/domain/usecases/get_catalogs_usecase.dart';
import '../../features/tricks/domain/usecases/update_trick_usecase.dart';
import '../../features/tricks/presentation/pages/trick_form_page.dart';
import '../../features/tricks/presentation/pages/trick_list_page.dart';
import '../../features/tricks/presentation/providers/trick_form_viewmodel.dart';

/// Navegación 1.0 con rutas nombradas + onGenerateRoute.
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String tricks = '/tricks';
  static const String trickForm = '/tricks/form';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case tricks:
        return MaterialPageRoute(builder: (_) => const TrickListPage());

      case trickForm:
      // Si llegaron argumentos = un Trick = estamos EDITANDO; si no, CREANDO.
        final editing = settings.arguments as Trick?;
        return MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider<TrickFormViewModel>(
            // El form view-model se crea LOCAL a esta ruta, leyendo los
            // casos de uso del DI global.
            create: (_) => TrickFormViewModel(
              createTrickUseCase: ctx.read<CreateTrickUseCase>(),
              updateTrickUseCase: ctx.read<UpdateTrickUseCase>(),
              getCatalogsUseCase: ctx.read<GetCatalogsUseCase>(),
              editing: editing,
            ),
            child: const TrickFormPage(),
          ),
        );

      default:
      // Pantalla 404 mínima por si algún Navigator.pushNamed tipea mal.
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}