import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;

class PresbyopiaWatchFaceView extends WatchUi.WatchFace {

  enum Position {
    POSITION_TOP,
    POSITION_BOTTOM
  }

  enum Field {
    FIELD_BATTERY = 1,
    FIELD_DATE = 2,
    FIELD_STEPS = 3,
    FIELD_HEART = 4
  }

  // resources:
  private var _largeBoldFont as FontType = Graphics.FONT_LARGE;
  private var _largeLightFont as FontType = Graphics.FONT_LARGE;
  private var _mediumFont as FontType = Graphics.FONT_LARGE;

  private var _largeFontTopHeight = 24;
  private var _largeFontBodyHeight = 68;
  private var _mediumFontTopHeight = 12;
  private var _mediumFontBodyHeight = 33;

  private var _row_gap = 16;

  // properties:
  private const PROPERTY_DEFAULT_TOP_FIELD = FIELD_BATTERY;
  private const PROPERTY_DEFAULT_BOTTOM_FIELD = FIELD_DATE;
  private const PROPERTY_DEFAULT_COLOR_SCHEME = ColorScheme.makeDefault();
  private const PROPERTY_DEFAULT_USE_LEADING_ZERO = false;
  private const PROPERTY_DEFAULT_DISPLAY_ALWAYS_ON = false;

  private var _topField = PROPERTY_DEFAULT_TOP_FIELD;
  private var _bottomField = PROPERTY_DEFAULT_BOTTOM_FIELD;
  private var _colorScheme = PROPERTY_DEFAULT_COLOR_SCHEME;
  private var _useLeadingZero = PROPERTY_DEFAULT_USE_LEADING_ZERO;
  private var _displayAlwaysOn = PROPERTY_DEFAULT_DISPLAY_ALWAYS_ON;

  // pseudo-properties:
  private var _hoursColor as Number = 0xffffff;
  private var _minutesColor as Number = 0xffffff;
  private var _primaryColor as Number = 0xffffff;
  private var _secondaryColor as Number = 0xffffff;

  // drawing:
  private var _topFieldY = 0;
  private var _bottomFieldY = 0;

  // controls:
  private var _lowPowerMode = false;

  function initialize() {
    WatchFace.initialize();
  }

  public function onSettingsChanged() as Void {
    _debug("onSettingsChanged");
    _loadSettings();
    WatchUi.requestUpdate();
  }

  function onLayout(dc as Dc) as Void {
    _debug("onLayout");
    _loadResources();
    _loadSettings();
  }

  function onUpdate(dc as Dc) as Void {
    _debug("onUpdate");
    var clockTime = System.getClockTime();
    var now = new Time.Moment(Time.now().value());
    var dateInfo = Gregorian.info(now, Time.FORMAT_SHORT);

    _drawBackground(dc);
    _drawTime(dc, clockTime);

    switch (_topField) {
      case FIELD_BATTERY:
        _drawBattery(dc, POSITION_TOP);
        break;
      case FIELD_STEPS:
        _drawSteps(dc, POSITION_TOP);
        break;
      case FIELD_HEART:
        _drawHeart(dc, POSITION_TOP);
        break;
      default:
        _drawDate(dc, dateInfo, POSITION_TOP);
        break;
    }

    switch (_bottomField) {
      case FIELD_BATTERY:
        _drawBattery(dc, POSITION_BOTTOM);
        break;
      case FIELD_STEPS:
        _drawSteps(dc, POSITION_BOTTOM);
        break;
      case FIELD_HEART:
        _drawHeart(dc, POSITION_BOTTOM);
        break;
      default:
        _drawDate(dc, dateInfo, POSITION_BOTTOM);
        break;
    }

    if (_lowPowerMode && !_displayAlwaysOn) {
      _drawDither(dc, clockTime);
    }
  }

  function onEnterSleep() as Void {
    _debug("onEnterSleep");
    _lowPowerMode = true;
    _calculatePseudoProperties();
  }

  function onExitSleep() as Void {
    _debug("onExitSleep");
    _lowPowerMode = false;
    _calculatePseudoProperties();
  }

  private function _loadResources() as Void {
    // load fonts:
    _largeBoldFont = WatchUi.loadResource(Rez.Fonts.LargeBold);
    _largeLightFont = WatchUi.loadResource(Rez.Fonts.LargeLight);
    _mediumFont = WatchUi.loadResource(Rez.Fonts.Medium);
    _largeFontTopHeight = WatchUi.loadResource(Rez.Strings.LargeFontTopHeight).toNumber();
    _largeFontBodyHeight = WatchUi.loadResource(Rez.Strings.LargeFontBodyHeight).toNumber();
    _mediumFontTopHeight = WatchUi.loadResource(Rez.Strings.MediumFontTopHeight).toNumber();
    _mediumFontBodyHeight = WatchUi.loadResource(Rez.Strings.MediumFontBodyHeight).toNumber();
    _row_gap = WatchUi.loadResource(Rez.Strings.RowGap).toNumber(); 
  }

  private function _loadSettings() as Void {
    // load properties:
    _topField = _getFieldPropValue("TopField", PROPERTY_DEFAULT_TOP_FIELD);
    _bottomField = _getFieldPropValue("BottomField", PROPERTY_DEFAULT_BOTTOM_FIELD);
    _colorScheme = _getColorSchemePropValue("ColorScheme", ColorScheme.makeDefault());
    _useLeadingZero = _getBooleanPropValue("UseLeadingZero", PROPERTY_DEFAULT_USE_LEADING_ZERO);
    _displayAlwaysOn = _getBooleanPropValue("DisplayAlwaysOn", PROPERTY_DEFAULT_DISPLAY_ALWAYS_ON) && !System.getDeviceSettings().requiresBurnInProtection;
    _calculatePseudoProperties();
  }

  private function _getBooleanPropValue(key as String, defaultValue as Boolean) as Boolean {
    try{
      var value = Application.Properties.getValue(key);
      if (value == null) {
        return defaultValue;
      } else {
        return value as Boolean;
      }
    } catch (e) {
      return defaultValue;
    }
  }

  private function _getNumberPropValue(key as String, defaultValue as Number) as Number {
    try{
      var value = Application.Properties.getValue(key);
      if (value == null) {
        return defaultValue;
      } else {
        return value as Number;
      }
    } catch (e) {
      return defaultValue;
    }
  }

  private function _getColorSchemePropValue(key as String, defaultValue as ColorScheme) as ColorScheme {
    return new ColorScheme(_getNumberPropValue(key, defaultValue.toNumber()));
  }

  private function _getFieldPropValue(key as String, defaultValue as Field) as Field {
    return _getNumberPropValue(key, defaultValue) as Field;
  }

  private function _calculatePseudoProperties() as Void {
    var colorScheme = _lowPowerMode ? _colorScheme.getLowPowerMode() : _colorScheme;
    _hoursColor = colorScheme.getSecondaryColor();
    _minutesColor = colorScheme.getForegroundColor();
    _primaryColor = colorScheme.getForegroundColor();
    _secondaryColor = colorScheme.getSecondaryColor();
  }

  private function _drawBackground(dc as Dc) as Void {
    if (_lowPowerMode && !_displayAlwaysOn) {
      dc.setColor(0x000000, 0x000000);  
    } else {
      dc.setColor(Graphics.COLOR_TRANSPARENT, _colorScheme.getBackgroundColor());
    }
    dc.clear();
  }

  private function _drawTime(dc as Dc, clockTime as ClockTime) as Void {
    var hoursString = _makeHoursString(clockTime);
    var minutesString = _makeMinutesString(clockTime);

    var hoursWidth = dc.getTextDimensions(hoursString, _largeLightFont)[0];
    var minutesWidth = dc.getTextDimensions(minutesString, _largeBoldFont)[0];

    var hoursX = (dc.getWidth() - hoursWidth - minutesWidth) / 2;
    var hoursY = (dc.getHeight() - _largeFontBodyHeight) / 2 - _largeFontTopHeight;

    var minutesX = hoursX + hoursWidth;
    var minutesY = hoursY;

    dc.setColor(_hoursColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(hoursX, hoursY, _largeLightFont, hoursString, Graphics.TEXT_JUSTIFY_LEFT);

    dc.setColor(_minutesColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(minutesX, minutesY, _largeBoldFont, minutesString, Graphics.TEXT_JUSTIFY_LEFT);

    var timeY = (dc.getHeight() - _largeFontBodyHeight) / 2;
    var timeHeight = _largeFontBodyHeight;

    _topFieldY = timeY - _mediumFontTopHeight - _mediumFontBodyHeight - _row_gap;
    _bottomFieldY = timeY + timeHeight + _row_gap - _mediumFontTopHeight;
  }

  private function _drawDate(dc as Dc, dateInfo as Gregorian.Info, position as Position) as Void {
    var monthDayString = _makeMonthDayString(dateInfo);
    var weekDayString = _makeWeekDayString(dateInfo);
    _drawTextInHorizontlCenter(dc, monthDayString, _primaryColor, weekDayString, _secondaryColor, position);
  }

  function _drawBattery(dc as Dc, position as Position) as Void {
    var stats = System.getSystemStats();
    var percentage = Math.round(stats.battery);
    var percentageString = percentage.format("%d");

    var batteryTextDimensions = dc.getTextDimensions(percentageString, _mediumFont);
    var batteryTextWidth = batteryTextDimensions[0];
    var batteryTextHeight = batteryTextDimensions[1];

    var batteryIconHeight = batteryTextHeight / 3;
    var batteryIconWidth = batteryIconHeight * 2.5;
    var batteryIconRadius = batteryIconHeight / 5;

    var gap = 4;

    var batteryTextX = (dc.getWidth() - batteryTextWidth - batteryIconWidth) / 2;
    var batteryTextY = (position == POSITION_TOP) ? _topFieldY : _bottomFieldY;
    var batteryIconX = batteryTextX + batteryTextWidth + gap;
    var batteryIconY = batteryTextY + (batteryTextHeight - batteryIconHeight) / 2;

    dc.setColor(_primaryColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(batteryTextX, batteryTextY, _mediumFont, percentageString, Graphics.TEXT_JUSTIFY_LEFT);

    dc.setColor(_secondaryColor, Graphics.COLOR_TRANSPARENT);
    dc.drawRoundedRectangle(batteryIconX, batteryIconY, batteryIconWidth, batteryIconHeight, batteryIconRadius);
    dc.fillRoundedRectangle(batteryIconX, batteryIconY, batteryIconWidth * percentage / 100, batteryIconHeight, batteryIconRadius);
  }

  private function _drawSteps(dc as Dc, position as Position) as Void {
    var steps = Toybox.ActivityMonitor.getInfo().steps;
    var hundreds = steps % 1000;
    var thousands = (steps - hundreds) / 1000;

    if (thousands) {
      var thousandsString = thousands.toString();
      var hundredsString = hundreds.format("%03d");
      _drawTextInHorizontlCenter(dc, thousandsString, _primaryColor, hundredsString, _secondaryColor, position);
    } else {
      var thousandsString = "";
      var hundredsString = _useLeadingZero ? hundreds.format("%03d") : hundreds.toString();
      _drawTextInHorizontlCenter(dc, thousandsString, _secondaryColor, hundredsString, _primaryColor, position);
    }
  }

  private function _drawHeart(dc as Dc, position as Position) as Void {
    var heartRate = Activity.getActivityInfo().currentHeartRate; //get the latest HR if available
    if (heartRate == null) {
      var history =  ActivityMonitor.getHeartRateHistory(1, true);
      heartRate = history.next().heartRate;
    }

    if (heartRate != null && heartRate != 255 /* ActivityMonitor.INVALID_HR_SAMPLE */) {
        _drawTextInHorizontlCenter(dc, heartRate.toString(), _primaryColor, "", _primaryColor, position);
    }
  }

  private function _drawTextInHorizontlCenter(dc as Dc, part1 as String, color1 as Number, part2 as String, color2 as Number, position as Position) as Void {
    var part1Width = dc.getTextDimensions(part1, _mediumFont)[0];
    var part2Width = dc.getTextDimensions(part2, _mediumFont)[0];

    var part1X = (dc.getWidth() - part1Width - part2Width) / 2;
    var part2X = part1X + part1Width;
    var y = (position == POSITION_TOP) ? _topFieldY : _bottomFieldY;
    
    dc.setColor(color1, Graphics.COLOR_TRANSPARENT);
    dc.drawText(part1X, y, _mediumFont, part1, Graphics.TEXT_JUSTIFY_LEFT);

    dc.setColor(color2, Graphics.COLOR_TRANSPARENT);
    dc.drawText(part2X, y, _mediumFont, part2, Graphics.TEXT_JUSTIFY_LEFT);
  }

  private function _drawDither(dc as Dc, clockTime as ClockTime) as Void {
    dc.setColor(0x000000, 0x000000);
    for (var y = (clockTime.min % 3); y < dc.getHeight(); y += 3) {
      dc.drawLine(0, y, dc.getWidth(), y);
      dc.drawLine(0, y+1, dc.getWidth(), y+1);
    }
  }

  private function _makeHoursString(clockTime as ClockTime) as String {
    var hours = clockTime.hour;
    
    if (!System.getDeviceSettings().is24Hour && (clockTime.hour > 12)) {
      hours = clockTime.hour - 12;
    }

    var hoursString = hours.format("%02d");
    if (!_useLeadingZero) {
      hoursString = hours.format("%d");
    }

    return hoursString;
  }

  private function _makeMinutesString(clockTime as ClockTime) as String {
    return clockTime.min.format("%02d");
  }

  private function _makeMonthDayString(dateInfo as Gregorian.Info) as String {
    return dateInfo.day.format(_useLeadingZero ? "%02d" : "%d");
  }

  private function _makeWeekDayString(dateInfo as Gregorian.Info) as String {
    var weekDayStrings = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

    switch (System.getDeviceSettings().systemLanguage) {
      case System.LANGUAGE_SPA:
        weekDayStrings = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"];
        break;

      case System.LANGUAGE_POR:
        weekDayStrings = ["Domingo", "Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado"];
        break;
      
      case System.LANGUAGE_ITA:
        weekDayStrings = ["Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato"];
        break;

      case System.LANGUAGE_DEU:
        weekDayStrings = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"];
        break;
    }
    
    return weekDayStrings[dateInfo.day_of_week - 1].substring(0, 3).toUpper();
  }

  (:debug)
  private function _debug(msg as String) as Void {
    System.println(msg);
  }

  (:release)
  private function _debug(msg as String) as Void {
    // do nothing
  }
}
