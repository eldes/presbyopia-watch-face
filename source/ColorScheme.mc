import Toybox.Lang;



class ColorScheme {

  enum Code {
    // light mode:
    WHITE_ON_BLACK = 0x000,
    YELLOW_ON_BLACK = 0x001,
    GREEN_ON_BLACK = 0x002,
    CYAN_ON_BLACK = 0x003,
    MAGENTA_ON_BLACK = 0x004,
    
    YELLOW_ON_BLUE = 11,
    YELLOW_ON_RED = 12,
    YELLOW_AND_WHITE_ON_RED = 13,
    BLUE_ON_YELLOW = 111,

    // dark mode:
    BLACK_ON_WHITE = 100,
    BLACK_ON_YELLOW = 110,
    BLACK_ON_GREEN = 120,

    DEFAULT = 0
  }

  private var _foregroundColor as Number = 0xffffff;
  private var _secondaryColor as Number = 0xcccccc;
  private var _backgroundColor as Number = 0x000000;

  function initialize(code as Number) {
    switch (code) {
      // dark mode:
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
      case GREEN_ON_BLACK:
        _foregroundColor = 0x00ff00;
        _secondaryColor = 0x00cc00;
        _backgroundColor = 0x000000;
        break;
      case CYAN_ON_BLACK:
        _foregroundColor = 0x00ffff;
        _secondaryColor = 0x00cccc;
        _backgroundColor = 0x000000;
        break;
      case MAGENTA_ON_BLACK:
        _foregroundColor = 0xff00ff;
        _secondaryColor = 0xcc00cc;
        _backgroundColor = 0x000000;
        break;

      case YELLOW_ON_BLUE:
        _foregroundColor = 0xffff00;
        _secondaryColor = 0xcccc33;
        _backgroundColor = 0x000099;
        break;
      case YELLOW_ON_RED:
        _foregroundColor = 0xffff00;
        _secondaryColor = 0xffcc00;
        _backgroundColor = 0x990000;
        break;
      case YELLOW_AND_WHITE_ON_RED:
        _foregroundColor = 0xffffff;
        _secondaryColor = 0xffff00;
        _backgroundColor = 0x990000;
        break;
      

      // light mode:
      case BLACK_ON_WHITE:
        _foregroundColor = 0x000000;
        _secondaryColor = 0x333333;
        _backgroundColor = 0xffffff;
        break;
      case BLACK_ON_YELLOW:
        _foregroundColor = 0x000000;
        _secondaryColor = 0x333300;
        _backgroundColor = 0xffff00;
        break;

      case BLUE_ON_YELLOW:
        _foregroundColor = 0x000099;
        _secondaryColor = 0x3333cc;
        _backgroundColor = 0xffff00;
        break;
      case DEFAULT:
      default:
        _foregroundColor = 0xffffff;
        _secondaryColor = 0xcccccc;
        _backgroundColor = 0x000000;
    }
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
}