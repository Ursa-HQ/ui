/// Seasonal theme system — maps the current month + hemisphere to one of four seasons.
///
/// Each season has a distinct Radix accent color and gray color.
/// See: ./ursa_colors.dart for the color constants.
/// See: ./ursa_theme.dart for the ThemeData builders.
library;

/// One of four seasons, each with a unique accent+gray palette.
enum Season {
  spring,
  summer,
  autumn,
  winter;

  /// Human-readable label.
  String get label {
    switch (this) {
      case Season.spring: return 'Spring';
      case Season.summer: return 'Summer';
      case Season.autumn: return 'Autumn';
      case Season.winter: return 'Winter';
    }
  }

  /// Emoji representation.
  String get emoji {
    switch (this) {
      case Season.spring: return '🌱';
      case Season.summer: return '☀️';
      case Season.autumn: return '🍂';
      case Season.winter: return '❄️';
    }
  }

  /// CSS class name used by the web app (kept for reference).
  String get cssClass => 'season-$name';

  /// The accent color scale name for this season.
  String get accentScale {
    switch (this) {
      case Season.spring: return 'violet';
      case Season.summer: return 'green';
      case Season.autumn: return 'orange';
      case Season.winter: return 'sky';
    }
  }

  /// The gray color scale name for this season.
  String get grayScale {
    switch (this) {
      case Season.spring: return 'mauve';
      case Season.summer: return 'sage';
      case Season.autumn: return 'sand';
      case Season.winter: return 'slate';
    }
  }
}

/// Hemisphere used for season calculation.
enum Hemisphere {
  north,
  south;
}

/// Northern hemisphere: month 0 (Jan) → season.
const _northSeasons = [
  Season.winter,  // Jan
  Season.winter,  // Feb
  Season.spring,  // Mar
  Season.spring,  // Apr
  Season.spring,  // May
  Season.summer,  // Jun
  Season.summer,  // Jul
  Season.summer,  // Aug
  Season.autumn,  // Sep
  Season.autumn,  // Oct
  Season.autumn,  // Nov
  Season.winter,  // Dec
];

/// Southern hemisphere: month 0 (Jan) → season.
const _southSeasons = [
  Season.summer,  // Jan
  Season.summer,  // Feb
  Season.autumn,  // Mar
  Season.autumn,  // Apr
  Season.autumn,  // May
  Season.winter,  // Jun
  Season.winter,  // Jul
  Season.winter,  // Aug
  Season.spring,  // Sep
  Season.spring,  // Oct
  Season.spring,  // Nov
  Season.summer,  // Dec
];

/// Get the season for a given 0-based month index and hemisphere.
Season getSeason(int month, Hemisphere hemisphere) {
  final table = switch (hemisphere) {
    Hemisphere.north => _northSeasons,
    Hemisphere.south => _southSeasons,
  };
  return table[month.clamp(0, 11)];
}

/// Get the auto-detected season for today (uses system clock, northern hemisphere).
Season getCurrentSeason() {
  final now = DateTime.now();
  return getSeason(now.month - 1, Hemisphere.north);
}
