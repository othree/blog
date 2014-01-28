/**
 * Disable and enable event on scroll begin and scroll end.
 * @see http://www.thecssninja.com/javascript/pointer-events-60fps
 */
var root = document.documentElement;
var timer;

window.addEventListener('scroll', function() {
    // User scrolling so stop the timeout
    clearTimeout(timer);
    // Pointer events has not already been disabled.
    if (!root.style.pointerEvents) {
        root.style.pointerEvents = 'none';
    }

    timer = setTimeout(function() {
        root.style.pointerEvents = '';
    }, 500);
}, false);
