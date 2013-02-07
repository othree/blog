(function () {
"use strict";

function toggleNavSearch(delay) {
    if (!toggleNavSearch.timerId) {
        toggleNavSearch.timerId = setTimeout(function () {
            var s = document.getElementById('nav-search'),
                t = document.getElementById('search-form').getBoundingClientRect().top;
            if (t <= 0 || t >= 500) {
                s.className = s.className.replace(/ o-hidden/g, '');
            } else {
                s.className = s.className + ' o-hidden';
            }
            toggleNavSearch.timerId = null;
        }, parseInt(delay, 10) || 200);
    }
}

window.addEventListener('scroll', toggleNavSearch, false);
window.addEventListener('resize', toggleNavSearch, false);
toggleNavSearch(0);

}());
