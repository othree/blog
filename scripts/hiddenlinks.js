// written by othree, 2008
// hidden links 3.0 <http://blog.othree.net/>
// better working with events.js <http://dean.edwards.name/weblog/2005/10/add-event/>

(function () {
    if (window.navigator.userAgent.indexOf("MSIE 5.0") > 0 && window.navigator.userAgent.indexOf("Windows") > 0) return false;

    var links = Array(
        {title: "主控台", url: "http://othree.net/mt/mt.cgi"},
        {title: "Analytics", url: "https://www.google.com/analytics/reporting/dashboard?id=39463&scid=77906"},
        {title: "Adsense", url: "https://www.google.com/adsense/report/overview"},
        {title: "FeedBurner", url: "http://www.feedburner.com/fb/a/dashboard?id=923720"}
    );

    var period = 500;
    var hide = {top: -80, right: 20};
    var show = {top: 20, right: 20};
    var triggerSize = 20;

    var init = function () {
        var body = document.getElementsByTagName('body')[0];
        var list = document.createElement('ul');
        var trigger = document.createElement('div');
        for (var i in links) {
            var listItem = document.createElement('li');
            var anchor = document.createElement('a');
            anchor.appendChild(document.createTextNode(links[i].title));
            anchor.href = links[i].url;
            listItem.appendChild(anchor);
            list.appendChild(listItem);
        }

        setStyle(list, {position: 'absolute', display: 'none', top: hide.top, right: hide.right, zIndex: 1000, opacity: 0});
        setStyle(trigger, {position: 'absolute', top: 0, right: 0, width: triggerSize, height: triggerSize, zIndex: 999});
        list.id = 'hidden-links';
        trigger.id = 'hidden-links-trigger';
        trigger.appendChild(list);
        body.appendChild(trigger);

        trigger.onclick = function () {
            if (list.startTime) return false;
            var out = (list.style.display == 'none')?false:true;
            list.style.display = 'block';
            list.startTime = new Date().getTime();
            list.interval = setInterval(function () {
                var pos = (new Date().getTime() - list.startTime) / period;
                if (pos >= 1 && (pos = 1)) {
                    clearInterval(list.interval);
                    list.startTime = null;
                    if (out) list.style.display = 'none';
                }
                if (out) pos = 1 - pos;
                setStyle(list, {top: (Math.sin(pos*Math.PI/2)*(show.top-hide.top) + hide.top),
                                right: (Math.sin(pos*Math.PI/2)*(show.right-hide.right) + hide.right),
                                opacity: pos});
            }, 20);
            return true;
        };
    };

    function setStyle (elem, style) {
        for (var i in style) {
            if (i == 'opacity' && elem.filter && (elem.style.filter = 'alpha(opacity='+ style[i] +')')) continue;
            elem.style[i] = style[i] + ((/top|right|left|height|width/.test(i))?'px':'');
        }
    }

    if (window.addEventListener) window.addEventListener('load', init, false);
    else if (typeof attachEvent == 'function') attachEvent(window, 'load', init);
    else {
        var onloadFuncs = window.onload;
        window.onload = function () {
            if (typeof onloadFuncs == 'function') onloadFuncs();
            init();
        };
    }
})();
