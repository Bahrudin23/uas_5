enum TimeMode { day, night }

TimeMode getTimeMode() {
  final hour = DateTime.now().hour;
  return hour >= 5 && hour < 18 ? TimeMode.day : TimeMode.night;
}
