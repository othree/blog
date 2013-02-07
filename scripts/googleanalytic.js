/*jslint nomen: true, windows: true */
(function() {
"use strict";

window._gaq = window._gaq || [];
window._gaq.push(['_setAccount', 'UA-77906-1']);
window._gaq.push(['_trackPageview']);
window._gaq.push(['_trackPageLoadTime']);

var ga = document.createElement('script'),
    s;

ga.type = 'text/javascript';
ga.async;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
s = document.getElementsByTagName('script')[0]; 
s.parentNode.insertBefore(ga, s);

})();
