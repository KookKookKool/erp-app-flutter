String formatDate(String dateStr) {
  if (dateStr.isEmpty) return '';
  final d = DateTime.parse(dateStr);
  return "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
}

String getWorkDuration(String startDateStr) {
  if (startDateStr.isEmpty) return "";
  final startDate = DateTime.parse(startDateStr);
  final now = DateTime.now();
  int years = now.year - startDate.year;
  int months = now.month - startDate.month;
  int days = now.day - startDate.day;

  if (days < 0) {
    final prevMonth = DateTime(now.year, now.month, 0);
    days += prevMonth.day;
    months -= 1;
  }
  if (months < 0) {
    months += 12;
    years -= 1;
  }
  return "$years ปี $months เดือน $days วัน";
}
