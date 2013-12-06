/*jslint vars: true */
/*global window: false, document: false */
(function () {
    "use strict";

    if (!window.requestAnimationFrame || !document.documentElement) {
        return;
    }

    var tick = false;
    var scroll = 0;

    var scrolling = function () {
        tick = false;
        var currentScroll = document.documentElement.scrollTop || document.body.scrollTop;
        if (scroll === currentScroll) {
            return;
        }
        scroll = currentScroll;
        var offset = parseInt(scroll * 0.5, 10) % 128;
        document.body.style.backgroundPosition = "0 " + offset + 'px';
        document.documentElement.style.backgroundPosition = "0 " + offset + 'px';
    };

    var onscroll = function () {
        if (tick) {
            return;
        }
        tick = true;
        window.requestAnimationFrame(scrolling);
    };

    document.addEventListener('scroll', onscroll, false);

}());
