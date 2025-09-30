  import 'package:intl/intl.dart';

  extension FormattedDateExtension on DateTime {
    String formatted({String format = 'MMMM, do'}) {
      switch (format) {
        case 'MMM dd, yyyy':
          return DateFormat('MMM dd, yyyy').format(this);
        case 'MMMM, do':
        default:
          final month = DateFormat('MMMM').format(this);
          final day = this.day;
          final daySuffix = _daySuffix(day);
          return "$month, $day$daySuffix";
      }
    }
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
