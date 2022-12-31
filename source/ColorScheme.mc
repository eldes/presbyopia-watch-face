import Toybox.Lang;



class ColorScheme {

  enum Code {
    WHITE_ON_BLACK = 0,
    YELLOW_ON_BLACK = 10,
    BLACK_ON_WHITE = 100,
    BLACK_ON_YELLOW = 110,
    DEFAULT = 0
  }

  private var _foregroundColor as Number = 0xffffff;
  private var _secondaryColor as Number = 0xcccccc;
  private var _backgroundColor as Number = 0x000000;

  function initialize(code as Number) {
    switch (code) {
      case YELLOW_ON_BLACK:
        _foregroundColor = 0xffff00;
        _secondaryColor = 0xcccc00;
        _backgroundColor = 0x000000;
        break;
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
      case WHITE_ON_BLACK:
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