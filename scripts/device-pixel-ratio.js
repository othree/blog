(function () {
"use strict";

var e = new Date();
e.setDate(e.getDate() + 365*10);
e = e.toUTCString();
if (window.devicePixelRatio) {
    document.cookie = 'devicePixelRatio=; expires=-1';
    document.cookie = 'devicePixelRatio='+ window.devicePixelRatio +'; expires=' + e + '; secure';
}
document.cookie = 'w=; expires=-1';
document.cookie = 'w='+ Math.min(window.screen.width, window.screen.height) +'; expires=' + e + '; secure';

}());
