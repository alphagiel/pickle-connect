/// Utility for deriving season from date
enum SeasonName {
  winter,
  spring,
  summer,
  fall,
}

extension SeasonNameExtension on SeasonName {
  String get displayName {
    switch (this) {
      case SeasonName.winter:
        return 'Winter';
      case SeasonName.spring:
        return 'Spring';
      case SeasonName.summer:
        return 'Summer';
      case SeasonName.fall:
        return 'Fall';
    }
  }
}

class SeasonUtils {
  /// Returns the season for a given month (1-12)
  /// January - March: Winter
  /// April - June: Spring
  /// July - September: Summer
  /// October - December: Fall
  static SeasonName getSeasonForMonth(int month) {
    if (month >= 1 && month <= 3) {
      return SeasonName.winter;
    } else if (month >= 4 && month <= 6) {
      return SeasonName.spring;
    } else if (month >= 7 && month <= 9) {
      return SeasonName.summer;
    } else {
      return SeasonName.fall;
    }
  }

  /// Returns the current season based on today's date
  static SeasonName getCurrentSeason() {
    return getSeasonForMonth(DateTime.now().month);
  }

  /// Returns formatted season string like "Spring 2026"
  static String getSeasonDisplay([DateTime? date]) {
    final d = date ?? DateTime.now();
    final season = getSeasonForMonth(d.month);
    return '${season.displayName} ${d.year}';
  }
}
