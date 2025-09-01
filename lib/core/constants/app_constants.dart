class AppConstants {
  // App Info
  static const String appName = 'Pickle Connect';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.pickleconnect.com/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String notificationSettingsKey = 'notification_settings';
  
  // Court Configuration
  static const int totalCourts = 8;
  static const Duration defaultBookingDuration = Duration(hours: 1, minutes: 30);
  static const Duration maxBookingAdvance = Duration(days: 14);
  
  // Tournament Configuration
  static const int topEightParticipants = 8;
  static const int maxTournamentParticipants = 32;
  static const Duration tournamentRegistrationPeriod = Duration(days: 14);
  
  // Ladder Configuration
  static const int maxChallengeRankDifference = 3;
  static const Duration challengeResponseTime = Duration(days: 7);
  static const Duration seasonDuration = Duration(days: 90);
  
  // Rating Ranges
  static const Map<String, Map<String, double>> ratingRanges = {
    'USTA': {
      'min': 2.5,
      'max': 7.0,
    },
    'UTR': {
      'min': 1.0,
      'max': 16.0,
    },
  };
  
  // Skill Division Mappings
  static const Map<String, Map<String, double>> skillDivisionRatings = {
    'beginner': {
      'USTA': 3.5,
      'UTR': 6.0,
    },
    'intermediate': {
      'USTA': 4.5,
      'UTR': 10.0,
    },
    'advanced': {
      'USTA': 5.5,
      'UTR': 13.0,
    },
  };
  
  // Notification Types
  static const String notificationTypeMatch = 'match';
  static const String notificationTypeTournament = 'tournament';
  static const String notificationTypeBooking = 'booking';
  static const String notificationTypeLadder = 'ladder';
  
  // Time Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'h:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy h:mm a';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const String phoneRegex = r'^\+?[\d\s\-\(\)]+$';
  static const String emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
}

class ImageAssets {
  static const String _imagesPath = 'assets/images';
  
  static const String logo = '$_imagesPath/logo.png';
  static const String tennisIcon = '$_imagesPath/tennis_icon.png';
  static const String courtPlaceholder = '$_imagesPath/court_placeholder.png';
  static const String trophyIcon = '$_imagesPath/trophy.png';
  static const String profilePlaceholder = '$_imagesPath/profile_placeholder.png';
}

class IconAssets {
  static const String _iconsPath = 'assets/icons';
  
  static const String courtIcon = '$_iconsPath/court.svg';
  static const String ladderIcon = '$_iconsPath/ladder.svg';
  static const String tournamentIcon = '$_iconsPath/tournament.svg';
  static const String playerIcon = '$_iconsPath/player.svg';
}