import 'package:flutter/material.dart';
import '../../domain/entities/trick.dart';

/// Usa Card + un layout en columna; click = editar, long-press = borrar.
class TrickCard extends StatelessWidget {
  final Trick trick;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const TrickCard({
    super.key,
    required this.trick,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.skateboarding,
                    color: scheme.onPrimaryContainer),
              ),
              const SizedBox(height: 12),
              Text(trick.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(trick.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}