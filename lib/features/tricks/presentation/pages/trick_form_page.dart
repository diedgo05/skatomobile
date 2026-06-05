import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_session_viewmodel.dart';
import '../providers/trick_form_viewmodel.dart';

class TrickFormPage extends StatefulWidget {
  const TrickFormPage({super.key});

  @override
  State<TrickFormPage> createState() => _TrickFormPageState();
}

class _TrickFormPageState extends State<TrickFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    final vm = context.read<TrickFormViewModel>();
    _titleCtrl = TextEditingController(text: vm.editing?.title ?? '');
    _descCtrl = TextEditingController(text: vm.editing?.description ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) => vm.loadCatalogs());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<TrickFormViewModel>();
    final user = context.read<AuthSession>().user;
    if (user == null) return;
    final ok = await vm.submit(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      idUser: user.id,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'No se pudo guardar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final vm = context.watch<TrickFormViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.isEditing ? 'Editar truco' : 'Nuevo truco'),
      ),
      body: SafeArea(
        child: vm.loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  vm.isEditing
                      ? 'Edita los datos de tu truco'
                      : 'Comparte un truco nuevo',
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                _catalogDropdown(
                  label: 'Categoría',
                  icon: Icons.category_outlined,
                  items: vm.categories,
                  value: vm.selectedCategoryId,
                  onChanged: vm.setCategory,
                ),
                const SizedBox(height: 16),
                _catalogDropdown(
                  label: 'Dificultad',
                  icon: Icons.bar_chart,
                  items: vm.difficulties,
                  value: vm.selectedDifficultyId,
                  onChanged: vm.setDifficulty,
                ),
                const SizedBox(height: 16),
                _catalogDropdown(
                  label: 'Nivel del truco',
                  icon: Icons.star_outline,
                  items: vm.levels,
                  value: vm.selectedLevelId,
                  onChanged: vm.setLevel,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: vm.loading ? null : _save,
                  child: vm.loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child:
                    CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(vm.isEditing ? 'Guardar cambios' : 'Crear'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _catalogDropdown({
    required String label,
    required IconData icon,
    required List items,
    required int? value,
    required void Function(int?) onChanged,
  }) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      items: items
          .map<DropdownMenuItem<int>>(
            (e) => DropdownMenuItem<int>(value: e.id, child: Text(e.name)),
      )
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Selecciona una opción' : null,
    );
  }
}