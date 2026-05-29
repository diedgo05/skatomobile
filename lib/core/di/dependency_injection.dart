import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// --- Núcleo ---
import '../http/http_client.dart';
import '../storage/token_storage.dart';

// --- Auth ---
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/viewmodels/auth_session_viewmodel.dart';
import '../../features/auth/presentation/viewmodels/login_viewmodel.dart';
import '../../features/auth/presentation/viewmodels/register_viewmodel.dart';

// --- Tricks ---
import '../../features/tricks/data/datasources/catalog_remote_data_source.dart';
import '../../features/tricks/data/datasources/trick_remote_data_source.dart';
import '../../features/tricks/data/repositories/catalog_repository_impl.dart';
import '../../features/tricks/data/repositories/repositories.dart';
import '../../features/tricks/domain/repositories/catalog_repository.dart';
import '../../features/tricks/domain/repositories/trick_repository.dart';
import '../../features/tricks/domain/usecases/create_trick_usecase.dart';
import '../../features/tricks/domain/usecases/delete_trick_usecase.dart';
import '../../features/tricks/domain/usecases/get_catalogs_usecase.dart';
import '../../features/tricks/domain/usecases/get_tricks_usecase.dart';
import '../../features/tricks/domain/usecases/update_trick_usecase.dart';
import '../../features/tricks/presentation/viewmodels/trick_list_viewmodel.dart';

/// Composition Root: instancia y cablea TODAS las dependencias a mano.
///
/// Esto es la "inyección de dependencias manual" que pide la práctica.
/// Cada capa recibe sus colaboradores por constructor; aquí los enchufamos
/// en el orden correcto:
///     core -> data sources -> repositorios -> casos de uso -> viewmodels
class DependencyInjection {
  static List<SingleChildWidget> providers() {
    // ---------- 1) Servicios base (singletons de toda la app) ----------
    final tokenStorage = TokenStorage();
    final httpClient = HttpClient(tokenStorage: tokenStorage);
    final authSession = AuthSession();

    // ---------- 2) AUTH: data ----------
    final authRemote = AuthRemoteDataSource(httpClient);
    final AuthRepository authRepo = AuthRepositoryImpl(
      remoteDataSource: authRemote,
      tokenStorage: tokenStorage,
    );
    // Casos de uso
    final loginUC = LoginUseCase(authRepo);
    final registerUC = RegisterUseCase(authRepo);
    final getCurrentUserUC = GetCurrentUserUseCase(authRepo);

    // ---------- 3) TRICKS: data ----------
    final trickRemote = TrickRemoteDataSource(httpClient);
    final catalogRemote = CatalogRemoteDataSource(httpClient);
    final TrickRepository trickRepo = TrickRepositoryImpl(trickRemote);
    final CatalogRepository catalogRepo = CatalogRepositoryImpl(catalogRemote);
    // Casos de uso
    final getTricksUC = GetTricksUseCase(trickRepo);
    final createTrickUC = CreateTrickUseCase(trickRepo);
    final updateTrickUC = UpdateTrickUseCase(trickRepo);
    final deleteTrickUC = DeleteTrickUseCase(trickRepo);
    final getCatalogsUC = GetCatalogsUseCase(catalogRepo);

    // ---------- 4) Lista de Providers para MultiProvider ----------
    return [
      // Servicios base: por si alguna vista quisiera acceder directo
      Provider<TokenStorage>.value(value: tokenStorage),
      Provider<HttpClient>.value(value: httpClient),

      // Casos de uso expuestos (los necesita el routing para construir el
      // TrickFormViewModel local con argumentos):
      Provider<GetCurrentUserUseCase>.value(value: getCurrentUserUC),
      Provider<CreateTrickUseCase>.value(value: createTrickUC),
      Provider<UpdateTrickUseCase>.value(value: updateTrickUC),
      Provider<GetCatalogsUseCase>.value(value: getCatalogsUC),

      // Sesión global del usuario (compartida entre Auth y Tricks)
      ChangeNotifierProvider<AuthSession>.value(value: authSession),

      // ViewModels globales (uno por feature, durables durante toda la app)
      ChangeNotifierProvider<LoginViewModel>(
        create: (_) => LoginViewModel(
          loginUseCase: loginUC,
          getCurrentUserUseCase: getCurrentUserUC,
          authSession: authSession,
        ),
      ),
      ChangeNotifierProvider<RegisterViewModel>(
        create: (_) => RegisterViewModel(registerUC),
      ),
      ChangeNotifierProvider<TrickListViewModel>(
        create: (_) => TrickListViewModel(
          getTricksUseCase: getTricksUC,
          deleteTrickUseCase: deleteTrickUC,
        ),
      ),
      // OJO: TrickFormViewModel NO va aquí. Se monta LOCAL en su ruta,
      //      porque su estado depende de si estamos creando o editando
      //      (recibe `Trick?` por argumento).
    ];
  }
}