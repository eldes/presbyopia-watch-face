import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class PresbyopiaWatchFaceView extends WatchUi.WatchFace {

    // fonts:
    private var _largeBoldFont;
    private var _largeLightFont;
    private var _mediumFont;

    // drawables:
    private var _background;
    private var _time;

    // data:
    private var _lastMinute = 0;

    function initialize() {
        WatchFace.initialize();

        // load fonts:
        _largeBoldFont = WatchUi.loadResource(Rez.Fonts.LargeBold);
        _largeLightFont = WatchUi.loadResource(Rez.Fonts.LargeLight);
        _mediumFont = WatchUi.loadResource(Rez.Fonts.Medium);
    }

    function onLayout(dc as Dc) as Void {
        _background = new Background();
        _time = new TimeDrawable(
            _largeLightFont,
            _largeBoldFont,
            Graphics.COLOR_LT_GRAY,
            Graphics.COLOR_WHITE
        );
    }

    function onUpdate(dc as Dc) as Void {

        var clockTime = System.getClockTime();
        _time.setClockTime(clockTime);

        if (clockTime.min != _lastMinute) {
            _background.draw(dc);
            _time.draw(dc);
        }
    }
}
