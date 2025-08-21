import 'dart:ui';

class ChatBubbleColors {
  static const Color softGray = Color(0xFFD3D3D3); // Soft Gray
  static const Color coolSilver = Color(0xFFB0BEC5); // Cool Silver
  static const Color warmBeige = Color(0xFFF5DEB3); // Warm Beige
  static const Color midnightBlue = Color(0xFF2C3E50); // Midnight Blue
  static const Color tealGreen = Color(0xFF008080); // Teal Green
  static const Color forestGreen = Color(0xFF2E7D32); // Forest Green
  static const Color coralOrange = Color(0xFFFF6F61); // Coral Orange
  static const Color sunsetPink = Color(0xFFE57373); // Sunset Pink
  static const Color lavenderPurple = Color(0xFF9575CD); // Lavender Purple
  static const Color skyBlue = Color(0xFF4A90E2); // Sky Blue
  static const Color goldenSand = Color(0xFFB8860B); // Golden Sand
  static const Color slateGray = Color(0xFF455A64); // Slate Gray

  static List<Color> availableColors = [
    softGray,
    coolSilver,
    warmBeige,
    midnightBlue,
    tealGreen,
    forestGreen,
    coralOrange,
    sunsetPink,
    lavenderPurple,
    skyBlue,
    goldenSand,
    slateGray
  ];

  static const Color softGrayText = Color(0xFF000000); // For Soft Gray
  static const Color coolSilverText = Color(0xFF000000); // For Cool Silver
  static const Color warmBeigeText = Color(0xFF654321); // For Warm Beige
  static const Color midnightBlueText = Color(0xFFFFFFFF); // For Midnight Blue
  static const Color tealGreenText = Color(0xFFFFFFFF); // For Teal Green
  static const Color forestGreenText = Color(0xFFFFFFFF); // For Forest Green
  static const Color coralOrangeText = Color(0xFF5A1E1E); // For Coral Orange
  static const Color sunsetPinkText = Color(0xFF5A1E1E); // For Sunset Pink
  static const Color lavenderPurpleText =
      Color(0xFF2E1A47); // For Lavender Purple
  static const Color skyBlueText = Color(0xFF12264E); // For Sky Blue
  static const Color goldenSandText = Color(0xFF4A3000); // For Golden Sand
  static const Color slateGrayText = Color(0xFFE0E0E0); // For Slate Gray

  static Map<Color, Color> chatBubbleColorWithTextColor = {
    softGray: softGrayText,
    coolSilver: coolSilverText,
    warmBeige: warmBeigeText,
    midnightBlue: midnightBlueText,
    tealGreen: tealGreenText,
    forestGreen: forestGreenText,
    coralOrange: coralOrangeText,
    sunsetPink: sunsetPinkText,
    lavenderPurple: lavenderPurpleText,
    skyBlue: skyBlueText,
    slateGray: slateGrayText,
    goldenSand: goldenSandText,
  };

  static const Color softGrayUnread = Color(0xFFFFFFFF); // White for unread
  static const Color softGrayRead = Color(0xFFB0B0B0); // Light Gray for read

  static const Color coolSilverUnread = Color(0xFFFFFFFF);
  static const Color coolSilverRead = Color(0xFFB0B0B0);

  static const Color warmBeigeUnread = Color(0xFFFFFFFF);
  static const Color warmBeigeRead = Color(0xFFD4B996); // Light Beige

  static const Color midnightBlueUnread = Color(0xFF000000); // Black for unread
  static const Color midnightBlueRead = Color(0xFF444444); // Dark Gray for read

  static const Color tealGreenUnread = Color(0xFF000000);
  static const Color tealGreenRead = Color(0xFF444444);

  static const Color forestGreenUnread = Color(0xFF000000);
  static const Color forestGreenRead = Color(0xFF444444);

  static const Color coralOrangeUnread = Color(0xFFFFFFFF); // White
  static const Color coralOrangeRead = Color(0xFFD48B8B); // Soft Coral

  static const Color sunsetPinkUnread = Color(0xFFFFFFFF);
  static const Color sunsetPinkRead = Color(0xFFD48B8B);

  static const Color lavenderPurpleUnread = Color(0xFFFFFFFF);
  static const Color lavenderPurpleRead = Color(0xFFB099C4); // Soft Lavender

  static const Color skyBlueUnread = Color(0xFFFFFFFF);
  static const Color skyBlueRead = Color(0xFF8094C4); // Soft Blue

  static const Color goldenSandUnread = Color(0xFFFFFFFF);
  static const Color goldenSandRead = Color(0xFFD4A875); // Soft Gold

  static const Color slateGrayUnread = Color(0xFF000000); // Black for unread
  static const Color slateGrayRead = Color(0xFF707070); // Medium Gray

  static const Map<String, List<Color>> readAndUnreadColor = {
    "softGray": [softGrayUnread, softGrayRead], // Soft Gray
    "coolSilver": [coolSilverUnread, coolSilverRead], // Cool Silver
    "warmBeige": [warmBeigeUnread, warmBeigeRead], // Warm Beige
    "midnightBlue": [midnightBlueUnread, midnightBlueRead], // Midnight Blue
    "tealGreen": [tealGreenUnread, tealGreenRead], // Teal Green
    "forestGreen": [forestGreenUnread, forestGreenRead], // Forest Green
    "coralOrange": [coralOrangeUnread, coralOrangeRead], // Coral Orange
    "sunsetPink": [sunsetPinkUnread, sunsetPinkRead], // Sunset Pink
    "lavenderPurple": [
      lavenderPurpleUnread,
      lavenderPurpleRead
    ], // Lavender Purple
    "skyBlue": [skyBlueUnread, skyBlueRead], // Sky Blue
    "goldenSand": [goldenSandUnread, goldenSandRead], // Golden Sand
    "slateGray": [slateGrayUnread, slateGrayRead], // Slate Gray
  };
}
