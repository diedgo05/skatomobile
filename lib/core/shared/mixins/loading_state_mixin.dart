import 'package:flutter/foundation.dart';

import '../../error/failure.dart';

/// Mixin que añade estado de "cargando" y "error" + manejo de async con

/// La cláusula `on ChangeNotifier` significa que SOLO puede aplicarse a
/// clases que extiendan ChangeNotifier (por eso lo restringimos a los
/// ViewModels de presentación; tiene sentido únicamente para ellos).

mixin LoadingStateMixin on ChangeNotifier {
  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  /// Métodos "protegidos": pensados para que los use la clase que mezcla
  /// este mixin, no la View. El @protected lo marca para el analizador.
  @protected
  void setLoading(bool value) {
    if (_loading == value) return;
    _loading = value;
    notifyListeners();
  }

  @protected
  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  /// Permite limpiar el error desde la View (p. ej. al cerrar un SnackBar).
  void clearError() => setError(null);
  Future<T?> guard<T>(Future<T> Function() action) async {
    setError(null);
    setLoading(true);
    try {
      return await action();
    } on ApiException catch (e) {
      setError(e.message);
      return null;
    } catch (_) {
      setError('Error inesperado. Revisa tu conexión.');
      return null;
    } finally {
      setLoading(false);
    }
  }
}