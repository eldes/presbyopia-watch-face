import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class TimeDrawable extends WatchUi.Drawable {

  private var _lightFont as FontType;
  private var _boldFont as FontType;
  private var _regularColor as ColorType;
  private var _accentColor as ColorType;
  private var _clockTime as ClockTime;

  public var locX as Number = 0;
  public var locY as Number = 0;
  public var width as Number = 0;
  public var height as Number = 0;

  function initialize(
    lightFont as FontType,
    boldFont as FontType,
    regularColor as ColorType,
    accentColor as ColorType
  ) {
    _clockTime = System.getClockTime();
    _lightFont = lightFont;
    _boldFont = boldFont;
    _regularColor = regularColor;
    _accentColor = accentColor;

    var dictionary = {
      :identifier => "Time"
    };

    Drawable.initialize(dictionary);
  }

  function setClockTime(clockTime as System.ClockTime) {
    _clockTime = clockTime;
  }

  function draw(dc as Dc) as Void {
    var hoursFont = _lightFont;
    var minutesFont = _boldFont;
    var hoursColor = _regularColor;
    var minutesColor = _accentColor;

    var hoursString = _makeHoursString();
    var minutesString = _makeMinutesString();

    var hoursDimensions = dc.getTextDimensions(hoursString, hoursFont);
    var hoursWidth = hoursDimensions[0];
    var hoursHeight = hoursDimensions[1];
    var minutesDimensions = dc.getTextDimensions(minutesString, minutesFont);
    var minutesWidth = minutesDimensions[0];
    var minutesHeight = minutesDimensions[1];

    var hoursX = (dc.getWidth() - hoursWidth - minutesWidth) / 2;
    var hoursY = (dc.getHeight() - hoursHeight) / 2;
    var minutesX = hoursX + hoursWidth;
    var timeY = hoursY;

    dc.setColor(hoursColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(hoursX, hoursY, hoursFont, hoursString, Graphics.TEXT_JUSTIFY_LEFT);
    dc.setColor(minutesColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(minutesX, timeY, minutesFont, minutesString, Graphics.TEXT_JUSTIFY_LEFT);

    locX = hoursX;
    locY = timeY;
    width = hoursWidth + minutesWidth;
    height = hoursHeight;
  }

  private function _makeHoursString() as String {
    var hours = _clockTime.hour;
    
    if (!System.getDeviceSettings().is24Hour && (_clockTime.hour > 12)) {
      hours = _clockTime.hour - 12;
    }

    var hoursString = hours.format("%02d");
    if (!getApp().getProperty("UseLeadingZero")) {
      hoursString = hours.format("%d");
    }

    return hoursString;
  }

  private function _makeMinutesString() as String {
    return _clockTime.min.format("%02d");
  }
}
