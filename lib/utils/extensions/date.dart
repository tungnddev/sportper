extension Convert on DateTime {
  String get timeDifferenceFromNow {
    Duration difference = DateTime.now().difference(this);
    if (difference.inSeconds < 5) {
      return "Just now";
    } else if (difference.inMinutes < 1) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }

  String get timeAwayFromNow {
    Duration difference = this.difference(DateTime.now());
    if (difference.inSeconds < 5) {
      return "Just now";
    } else if (difference.inMinutes < 1) {
      return "Seconds away: ${difference.inSeconds}";
    } else if (difference.inHours < 1) {
      return "Minutes away: ${difference.inMinutes}";
    } else if (difference.inHours < 24) {
      return "Hours away: ${difference.inHours}";
    } else {
      return "Days away: ${difference.inDays}";
    }
  }

  int get age {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - this.year;
    int month1 = currentDate.month;
    int month2 = this.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = this.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}