import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class PresbyopiaWatchFaceView extends WatchUi.WatchFace {

    // drawables:
    private var _background = new Background();

    // data:
    private var _lastMinute = 0;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
    }

    function onUpdate(dc as Dc) as Void {

        var clockTime = System.getClockTime();

        if (clockTime.min != _lastMinute) {
            _background.draw(dc);
        }
    }
}
