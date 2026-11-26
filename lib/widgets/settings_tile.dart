import 'package:flutter/material.dart';
import 'package:flutter_application_3/theme/app_theme.dart';

/// Isi [switchValue] dan [onSwitchChanged] untuk tile switch,
/// atau isi [onTap] untuk tile dengan panah.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.switchValue,
    this.onSwitchChanged,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final leading = Icon(icon, color: AppColors.textSecondary);
    if (switchValue != null) {
      return SwitchListTile(
        secondary: leading,
        title: Text(title),
        value: switchValue!,
        onChanged: onSwitchChanged,
      );
    }
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}