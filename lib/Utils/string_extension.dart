extension MyCustomFunctions on String {
  String capitalize() {
    if (this == null || this.isEmpty) {
      return this;
    }

    return this.substring(0, 1).toUpperCase() + this.substring(1).toLowerCase();
  }

  String capitalizeFirstofEach() {
    if (this == null || this.isEmpty) {
      return this;
    }

    return this.split(" ").map((str) {
      return str.capitalize();
    }).join(" ");
  }

  String splitDate() {
    if (this == null || this.isEmpty) {
      return this;
    }

    DateTime date = DateTime.parse(this);
    return "${months[date.month]} ${date.day}, ${date.year}";
  }

  String splitTime() {
    if (this == null || this.isEmpty) {
      return this;
    }

    DateTime date = DateTime.parse(this);
    return "${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute} ${date.hour > 12 ? "PM" : "AM"}";
  }

  String splitDay() {
    if (this == null || this.isEmpty) {
      return this;
    }

    DateTime date = DateTime.parse(this);
    return "${date.day}";
  }

  String splitMonth() {
    if (this == null || this.isEmpty) {
      return this;
    }

    DateTime date = DateTime.parse(this);
    return "${months[date.month]}";
  }

  String splitYear() {
    if (this == null || this.isEmpty) {
      return this;
    }

    DateTime date = DateTime.parse(this);
    return "${date.year}";
  }

  String removeUnderScore() {
    if (this == null || this.isEmpty) {
      return this;
    }

    List<String> words = this.split('_');
    StringBuffer result = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      result.write(
          words[i][0].toUpperCase() + words[i].substring(1).toLowerCase());
      if (i < words.length - 1) {
        result.write(' ');
      }
    }

    return result.toString();
  }

   String formatTimeAgo() {
    DateTime now = DateTime.now();
    DateTime date = DateTime.parse(this);

    Duration difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} ${difference.inSeconds == 1 ? 'second' : 'seconds'} ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
    } else {
      return date.toString().splitDate();
    }
  }
}

Map<int, String> months = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "June",
  7: "July",
  8: "Aug",
  9: "Sept",
  10: "Oct",
  11: "Nov",
  12: "Dec"
};
