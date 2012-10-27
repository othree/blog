(function () {
    if (window.devicePixelRatio) {
        e = new Date();
        e.setDate(e.getDate() + 365*10);
        e = e.toUTCString();
        document.cookie = 'devicePixelRatio='+ window.devicePixelRatio +'; expires=' + e;
    }
}());
