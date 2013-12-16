/*jslint vars: true, browser: true */
(function () {
    "use strict";

    if (!window.requestAnimationFrame || !document.documentElement || !document.documentElement.classList) {
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

    var body = document.body;
    var timer;

    var onscroll = function () {
        clearTimeout(timer);
        if (!body.classList.contains('disable-hover')) {
            body.classList.add('disable-hover');
        }

        timer = setTimeout(function () {
            body.classList.remove('disable-hover');
        }, 500);

        if (tick) {
            return;
        }
        tick = true;
        window.requestAnimationFrame(scrolling);
    };

    document.addEventListener('scroll', onscroll, false);

}());
