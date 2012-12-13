(function () {
    e = new Date();
    e.setDate(e.getDate() + 365*10);
    e = e.toUTCString();
    if (window.devicePixelRatio) {
        document.cookie = 'devicePixelRatio='+ window.devicePixelRatio +'; expires=' + e;
    }
    document.cookie = 'w='+ Math.min(window.screen.width, window.screen.height) +'; expires=' + e;
}());
