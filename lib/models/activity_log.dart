class ActivityLog {
  final String title;
  final String subtitle;
  final DateTime at;
  final String iconName;

  ActivityLog({
    required this.title,
    required this.subtitle,
    DateTime? at,
    this.iconName = 'info',
  }) : at = at ?? DateTime.now();
}
