import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;

class PresbyopiaWatchFaceView extends WatchUi.WatchFace {

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
  private var _colorScheme as ColorScheme = new ColorScheme(ColorScheme.DEFAULT);
  private var _useLeadingZero as Boolean = true;

  // pseudo-properties:
  private var _hoursFont as FontType = Graphics.FONT_LARGE;
  private var _minutesFont as FontType = Graphics.FONT_LARGE;
  private var _hoursColor as Number = 0xffffff;
  private var _minutesColor as Number = 0xffffff;
  private var _monthDayFont as FontType = Graphics.FONT_LARGE;
  private var _weekDayFont as FontType = Graphics.FONT_LARGE;
  private var _monthDayColor as Number = 0xffffff;
  private var _weekDayColor as Number = 0xffffff;
  private var _batteryFont as FontType = Graphics.FONT_LARGE;
  private var _batteryTextColor as Number = 0xffffff;
  private var _batteryIconColor as Number = 0xffffff;

  // drawables:
  private var _timeX = 0;
  private var _timeY = 0;
  private var _timeWidth = 0;
  private var _timeHeight = 0;

  function initialize() {
    WatchFace.initialize();
  }

  public function onSettingsChanged() as Void {
    _loadSettings();
    requestUpdate();
  }

  function onLayout(dc as Dc) as Void {
    _loadResources();
    _loadSettings();
  }

  function onUpdate(dc as Dc) as Void {

    var clockTime = System.getClockTime();
    var now = new Time.Moment(Time.now().value() + clockTime.timeZoneOffset);
    var dateInfo = Gregorian.info(now, Time.FORMAT_SHORT);

    _drawBackground(dc);
    _drawTime(dc, clockTime);
    _drawDate(dc, dateInfo);
    _drawBattery(dc);
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
    _useLeadingZero = Application.Properties.getValue("UseLeadingZero") as Boolean;
    _colorScheme = new ColorScheme(Application.Properties.getValue("ColorScheme") as Number);

    // calculate pseudo-properties:
    _hoursFont = _largeLightFont;
    _minutesFont = _largeBoldFont;
    _hoursColor = _colorScheme.getSecondaryColor();
    _minutesColor = _colorScheme.getForegroundColor();
    _monthDayFont = _mediumFont;
    _weekDayFont = _mediumFont;
    _monthDayColor = _colorScheme.getForegroundColor();
    _weekDayColor = _colorScheme.getSecondaryColor();
    _batteryFont = _mediumFont;
    _batteryTextColor = _colorScheme.getForegroundColor();
    _batteryIconColor = _colorScheme.getSecondaryColor();
  }

  private function _drawBackground(dc as Dc) as Void {
    dc.setColor(Graphics.COLOR_TRANSPARENT, _colorScheme.getBackgroundColor());
    dc.clear();
  }

  private function _drawTime(dc as Dc, clockTime as ClockTime) as Void {
    var hoursString = _makeHoursString(clockTime);
    var minutesString = _makeMinutesString(clockTime);

    var hoursWidth = dc.getTextDimensions(hoursString, _hoursFont)[0];
    var minutesWidth = dc.getTextDimensions(minutesString, _minutesFont)[0];

    var hoursX = (dc.getWidth() - hoursWidth - minutesWidth) / 2;
    var hoursY = (dc.getHeight() - _largeFontBodyHeight) / 2 - _largeFontTopHeight;

    var minutesX = hoursX + hoursWidth;
    var minutesY = hoursY;

    dc.setColor(_hoursColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(hoursX, hoursY, _hoursFont, hoursString, Graphics.TEXT_JUSTIFY_LEFT);

    dc.setColor(_minutesColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(minutesX, minutesY, _minutesFont, minutesString, Graphics.TEXT_JUSTIFY_LEFT);

    _timeX = (dc.getWidth() - hoursWidth - minutesWidth) / 2;
    _timeY = (dc.getHeight() - _largeFontBodyHeight) / 2;
    _timeWidth = hoursWidth + minutesWidth;
    _timeHeight = _largeFontBodyHeight;
  }

  private function _drawDate(dc as Dc, dateInfo as Gregorian.Info) as Void {
    var monthDayString = _makeMonthDayString(dateInfo);
    var weekDayString = _makeWeekDayString(dateInfo);

    var monthDayWidth = dc.getTextDimensions(monthDayString, _monthDayFont)[0];
    var weekDayWidth = dc.getTextDimensions(weekDayString, _weekDayFont)[0];

    var monthDayX = (dc.getWidth() - monthDayWidth - weekDayWidth) / 2;
    var monthDayY = _timeY + _timeHeight + _row_gap - _mediumFontTopHeight;
    var weekDayX = monthDayX + monthDayWidth;
    var weekDayY = monthDayY;
    
    dc.setColor(_monthDayColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(monthDayX, monthDayY, _monthDayFont, monthDayString, Graphics.TEXT_JUSTIFY_LEFT);

    dc.setColor(_weekDayColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(weekDayX, weekDayY, _weekDayFont, weekDayString, Graphics.TEXT_JUSTIFY_LEFT);
  }

  function _drawBattery(dc as Dc) as Void {
    var stats = System.getSystemStats();
    var percentage = Math.round(stats.battery);
    var percentageString = percentage.format("%d");

    var batteryTextDimensions = dc.getTextDimensions(percentageString, _batteryFont);
    var batteryTextWidth = batteryTextDimensions[0];
    var batteryTextHeight = batteryTextDimensions[1];

    var batteryIconHeight = batteryTextHeight / 3;
    var batteryIconWidth = batteryIconHeight * 2.5;
    var batteryIconRadius = batteryIconHeight / 5;

    var gap = 4;

    var batteryTextX = (dc.getWidth() - batteryTextWidth - batteryIconWidth) / 2;
    var batteryTextY = _timeY - _mediumFontTopHeight - _mediumFontBodyHeight - _row_gap;
    var batteryIconX = batteryTextX + batteryTextWidth + gap;
    var batteryIconY = batteryTextY + (batteryTextHeight - batteryIconHeight) / 2;

    dc.setColor(_batteryTextColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(batteryTextX, batteryTextY, _mediumFont, percentageString, Graphics.TEXT_JUSTIFY_LEFT);

    dc.setColor(_batteryIconColor, Graphics.COLOR_TRANSPARENT);
    dc.drawRoundedRectangle(batteryIconX, batteryIconY, batteryIconWidth, batteryIconHeight, batteryIconRadius);
    dc.fillRoundedRectangle(batteryIconX, batteryIconY, batteryIconWidth * percentage / 100, batteryIconHeight, batteryIconRadius);
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
    }
    
    return weekDayStrings[dateInfo.day_of_week - 1].substring(0, 3).toUpper();
  }
}
