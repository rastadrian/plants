import 'package:intl/intl.dart';

final _dateFormat = DateFormat('MMM d, yyyy');

String formatDate(DateTime date) => _dateFormat.format(date);

String formatLastWatered(DateTime? lastWateredAt) {
  if (lastWateredAt == null) return 'Never watered';
  return 'Last watered ${formatDate(lastWateredAt)}';
}

String formatDaysUntil(int days) {
  if (days <= 0) return 'now';
  if (days == 1) return 'in 1 day';
  return 'in $days days';
}
