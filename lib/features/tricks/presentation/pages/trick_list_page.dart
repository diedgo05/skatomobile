import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../auth/presentation/providers/auth_session_viewmodel.dart';
import '../../domain/entities/trick.dart';
import '../providers/trick_list_viewmodel.dart';
import '../widgets/trick_card.dart';

class TrickListPage extends StatefulWidget {
  const TrickListPage({super.key});

  @override
  State<TrickListPage> createState() => _TrickListPageState();
}

class _TrickListPageState extends State<TrickListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthSession>().user;
      if (user != null) {
        context.read<TrickListViewModel>().load(user.id);
      }
    });
  }

  Future<void> _confirmDelete(Trick trick) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Borrar truco?'),
        content: Text('Se eliminará "${trick.title}".'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Borrar')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final user = context.read<AuthSession>().user;
    if (user == null) return;
    await context.read<TrickListViewModel>().remove(trick.id, user.id);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final vm = context.watch<TrickListViewModel>();
    final user = context.watch<AuthSession>().user;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        onPressed: () async {
          await Navigator.of(context).pushNamed(AppRoutes.trickForm);
          if (user != null && mounted) {
            // ignore: use_build_context_synchronously
            context.read<TrickListViewModel>().load(user.id);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (user != null) {
              await context.read<TrickListViewModel>().load(user.id);
            }
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Hola, ${user?.username ?? 'skater'}',
                    style: textTheme.titleMedium,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await context.read<TokenStorage>().clear();
                      if (!context.mounted) return;
                      context.read<AuthSession>().clear();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login, (_) => false);
                    },
                  ),
                ],
              ),
              if (vm.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (vm.error != null)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(vm.error!,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.error)),
                    ),
                  ),
                )
              else if (vm.tricks.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Aún no tienes trucos.\nToca "Nuevo" para crear uno.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.95,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (ctx, i) {
                          final trick = vm.tricks[i];
                          return TrickCard(
                            trick: trick,
                            onTap: () async {
                              await Navigator.of(context).pushNamed(
                                AppRoutes.trickForm,
                                arguments: trick,
                              );
                              if (user != null && mounted) {
                                // ignore: use_build_context_synchronously
                                context.read<TrickListViewModel>().load(user.id);
                              }
                            },
                            onLongPress: () => _confirmDelete(trick),
                          );
                        },
                        childCount: vm.tricks.length,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}