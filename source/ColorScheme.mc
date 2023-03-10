import Toybox.Lang;

class ColorScheme {

  enum Code {
    // dark mode 1 color on black:
    WHITE_ON_BLACK = 0xff0,
    YELLOW_ON_BLACK = 0xee0,
    CYAN_ON_BLACK = 0xdd0,
    GREEN_ON_BLACK = 0xcc0,
    MAGENTA_ON_BLACK = 0xbb0,
    ORANGE_ON_BLACK = 0xaa0,
    RED_ON_BLACK = 0x990,
    BLUE_ON_BLACK = 0x880,

    // dark mode 2 colors on black
    YELLOW_AND_WHITE_ON_BLACK = 0xef0,
    CYAN_AND_WHITE_ON_BLACK = 0xdf0,
    GREEN_AND_WHITE_ON_BLACK = 0xcf0,
    MAGENTA_AND_WHITE_ON_BLACK = 0xbf0,
    ORANGE_AND_WHITE_ON_BLACK = 0xaf0,
    RED_AND_WHITE_ON_BLACK = 0x9f0,
    BLUE_AND_WHITE_ON_BLACK = 0x8f0,

    // dark mode on red:
    WHITE_ON_RED = 0xff2,
    WHITE_AND_YELLOW_ON_RED = 0xef2,

    // light mode on white:
    BLACK_ON_WHITE = 0x00f,
    BLUE_ON_WHITE = 0x01f,
    RED_ON_WHITE = 0x02f,
    GREEN_ON_WHITE = 0x03f,
    VIOLET_ON_WHITE = 0x04f,

    // light mode on yellow:
    BLACK_ON_YELLOW = 0x00e,
    BLACK_ON_CYAN = 0x00d,
    BLACK_ON_GREEN = 0x00c,
    BLACK_ON_MAGENTA = 0x0b,

    DEFAULT = 0
  }

  private var _foregroundColor as Number = 0xffffff;
  private var _secondaryColor as Number = 0xcccccc;
  private var _backgroundColor as Number = 0x000000;
  private var _code as Code;
  private var _lowPowerModeColorScheme as ColorScheme;

  function initialize(code as Number) {
    _code = code as Code;
    switch (code) {
      // dark mode on black (1 color):
      case WHITE_ON_BLACK:
        _foregroundColor = 0xffffff;
        _secondaryColor = 0xcccccc;
        _backgroundColor = 0x000000;
        break;
      case YELLOW_ON_BLACK:
        _foregroundColor = 0xffff00;
        _secondaryColor = 0xcccc00;
        _backgroundColor = 0x000000;
        break;
      case CYAN_ON_BLACK:
        _foregroundColor = 0x00ffff;
        _secondaryColor = 0x00cccc;
        _backgroundColor = 0x000000;
        break;
      case GREEN_ON_BLACK:
        _foregroundColor = 0x00ff00;
        _secondaryColor = 0x00cc00;
        _backgroundColor = 0x000000;
        break;
      case MAGENTA_ON_BLACK:
        _foregroundColor = 0xff00ff;
        _secondaryColor = 0xcc00cc;
        _backgroundColor = 0x000000;
        break;
      case ORANGE_ON_BLACK:
        _foregroundColor = 0xff9933;
        _secondaryColor = 0xcc6600;
        _backgroundColor = 0x000000;
        break;
      case RED_ON_BLACK:
        _foregroundColor = 0xff0000;
        _secondaryColor = 0xcc0000;
        _backgroundColor = 0x000000;
        break;
      case BLUE_ON_BLACK:
        _foregroundColor = 0x6666ff;
        _secondaryColor = 0x0000cc;
        _backgroundColor = 0x000000;
        break;

      // dark mode on black (2 colors):
      case YELLOW_AND_WHITE_ON_BLACK:
        _foregroundColor = 0xffff00;
        _secondaryColor = 0xffffff;
        _backgroundColor = 0x000000;
        break;
      case CYAN_AND_WHITE_ON_BLACK:
        _foregroundColor = 0x00ffff;
        _secondaryColor = 0xffffff;
        _backgroundColor = 0x000000;
        break;
      case GREEN_AND_WHITE_ON_BLACK:
        _foregroundColor = 0x33ff33;
        _secondaryColor = 0xffffff;
        _backgroundColor = 0x000000;
        break;
      case MAGENTA_AND_WHITE_ON_BLACK:
        _foregroundColor = 0xff00ff;
        _secondaryColor = 0xffffff;
        _backgroundColor = 0x000000;
        break;
      case ORANGE_AND_WHITE_ON_BLACK:
        _foregroundColor = 0xff9933;
        _secondaryColor = 0xffffff;
        _backgroundColor = 0x000000;
        break;
      case RED_AND_WHITE_ON_BLACK:
        _foregroundColor = 0xff3333;
        _secondaryColor = 0xffffff;
        _backgroundColor = 0x000000;
        break;
      case BLUE_AND_WHITE_ON_BLACK:
        _foregroundColor = 0x6666ff;
        _secondaryColor = 0xffffff;
        _backgroundColor = 0x000000;
        break;

      // dark mode on red
      case WHITE_ON_RED:
        _foregroundColor = 0xffffff;
        _secondaryColor = 0xffcccc;
        _backgroundColor = 0xcc0000;
        break;

      case WHITE_AND_YELLOW_ON_RED:
        _foregroundColor = 0xffff00;
        _secondaryColor = 0xffffff;
        _backgroundColor = 0xcc0000;
        break;

      // light mode on white:
      case BLACK_ON_WHITE:
        _foregroundColor = 0x000000;
        _secondaryColor = 0x333333;
        _backgroundColor = 0xffffff;
        break;
      case BLUE_ON_WHITE:
        _foregroundColor = 0x0000cc;
        _secondaryColor = 0x3333cc;
        _backgroundColor = 0xffffff;
        break;
      case RED_ON_WHITE:
        _foregroundColor = 0xcc0000;
        _secondaryColor = 0xcc3333;
        _backgroundColor = 0xffffff;
        break;
      case GREEN_ON_WHITE:
        _foregroundColor = 0x009900;
        _secondaryColor = 0x339933;
        _backgroundColor = 0xffffff;
        break;
      case VIOLET_ON_WHITE:
        _foregroundColor = 0x660099;
        _secondaryColor = 0x663399;
        _backgroundColor = 0xffffff;
        break;

      // light mode on yellow:
      case BLACK_ON_YELLOW:
        _foregroundColor = 0x000000;
        _secondaryColor = 0x333300;
        _backgroundColor = 0xffff00;
        break;

      // light mode on cyan:
      case BLACK_ON_CYAN:
        _foregroundColor = 0x000000;
        _secondaryColor = 0x003333;
        _backgroundColor = 0x00ffff;
        break;

      // light mode on green:
      case BLACK_ON_GREEN:
        _foregroundColor = 0x000000;
        _secondaryColor = 0x003300;
        _backgroundColor = 0x00ff00;
        break;
      
      // light mode on magenta:
      case BLACK_ON_MAGENTA:
        _foregroundColor = 0x000000;
        _secondaryColor = 0x330033;
        _backgroundColor = 0xff00ff;
        break;

      case DEFAULT:
      default:
        _code = WHITE_ON_BLACK;
        _foregroundColor = 0xffffff;
        _secondaryColor = 0xcccccc;
        _backgroundColor = 0x000000;
    }

    _lowPowerModeColorScheme = _makeLowPowerModeColorScheme();
  }

  static function makeDefault() as ColorScheme {
    return new ColorScheme(0);
  }

  function getForegroundColor() as Number {
    return _foregroundColor;
  }

  function getSecondaryColor() as Number {
    return _secondaryColor;
  }

  function getBackgroundColor() as Number {
    return _backgroundColor;
  }

  function getLowPowerMode() as ColorScheme {
    return _lowPowerModeColorScheme;
  }

  function toNumber() as Number {
    return _code as Number;
  }
  
  private function _makeLowPowerModeColorScheme() as ColorScheme {
    switch (_code) {
      
      case YELLOW_ON_BLACK:
      case CYAN_ON_BLACK:
      case GREEN_ON_BLACK:
      case MAGENTA_ON_BLACK:
      case ORANGE_ON_BLACK:
      case RED_ON_BLACK:
      case BLUE_ON_BLACK:
      case WHITE_ON_BLACK:
      case YELLOW_AND_WHITE_ON_BLACK:
      case CYAN_AND_WHITE_ON_BLACK:
      case GREEN_AND_WHITE_ON_BLACK:
      case MAGENTA_AND_WHITE_ON_BLACK:
      case ORANGE_AND_WHITE_ON_BLACK:
      case RED_AND_WHITE_ON_BLACK:
      case BLUE_AND_WHITE_ON_BLACK:
        return self;

      case WHITE_ON_RED:
      case RED_ON_WHITE:
        return new ColorScheme(RED_ON_BLACK);

      case WHITE_AND_YELLOW_ON_RED:
        return new ColorScheme(ORANGE_ON_BLACK);

      case BLUE_ON_WHITE:
        return new ColorScheme(BLUE_ON_BLACK);
      
      case GREEN_ON_WHITE:
      case BLACK_ON_GREEN:
        return new ColorScheme(GREEN_ON_BLACK);

      case VIOLET_ON_WHITE:
      case BLACK_ON_MAGENTA:
        return new ColorScheme(MAGENTA_ON_BLACK);

      case BLACK_ON_YELLOW:
        return new ColorScheme(YELLOW_ON_BLACK);

      case BLACK_ON_CYAN:
        return new ColorScheme(CYAN_ON_BLACK);

      case BLACK_ON_WHITE:
      default:
        return new ColorScheme(WHITE_ON_BLACK);
    }
  }
}