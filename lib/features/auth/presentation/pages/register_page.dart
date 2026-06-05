import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/register_viewmodel.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  /// Los ids vienen del seed: 1=Principiante, 2=Intermedio, 3=Avanzado, 4=Pro.
  int _selectedLevel = 1;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<RegisterViewModel>();
    final ok = await vm.submit(
      username: _usernameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      idLevelUser: _selectedLevel,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada. ¡Inicia sesión!')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'No se pudo registrar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final vm = context.watch<RegisterViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.person_add_alt_1,
                    size: 64, color: colorScheme.primary),
                const SizedBox(height: 8),
                Text('Únete a Skato',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _usernameCtrl,
                  label: 'Nombre de usuario',
                  icon: Icons.person_outline,
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailCtrl,
                  label: 'Correo',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Correo inválido'
                      : null,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordCtrl,
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 4)
                      ? 'Mínimo 4 caracteres'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _selectedLevel,
                  decoration: const InputDecoration(
                    labelText: 'Nivel de skater',
                    prefixIcon: Icon(Icons.trending_up),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Principiante')),
                    DropdownMenuItem(value: 2, child: Text('Intermedio')),
                    DropdownMenuItem(value: 3, child: Text('Avanzado')),
                    DropdownMenuItem(value: 4, child: Text('Pro')),
                  ],
                  onChanged: (v) => setState(() => _selectedLevel = v ?? 1),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: vm.loading ? null : _submit,
                  child: vm.loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Crear cuenta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}