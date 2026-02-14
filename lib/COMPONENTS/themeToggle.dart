import 'package:flutter/material.dart';
class CompactThemeToggle extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;

  const CompactThemeToggle({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isDarkMode),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.light_mode,
              color: !isDarkMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Switch(
              value: isDarkMode,
              onChanged: onToggle,
              activeColor: Theme.of(context).colorScheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.dark_mode,
              color: isDarkMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}