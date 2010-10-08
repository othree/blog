// written by othree, 2008
// lightlightbox 1.0 <http://blog.othree.net/>
// better working with events.js <http://dean.edwards.name/weblog/2005/10/add-event/>

(function () {
    var sizeRatio = 0.9;
    var loadingPath = '/images/loading.gif';
    var closePath = '/images/closebox.png';
    var period = 300;
    var classFilter = '';

    var init = function () {
        var body = document.getElementsByTagName('body')[0];
        var links = document.getElementsByTagName('a');
        var wrapper = body.appendChild(document.createElement('div'));
        var border = wrapper.appendChild(document.createElement('div'));
        var close = preLoadImg(closePath, '', wrapper);
        var loading = preLoadImg(loadingPath, '', wrapper);
        setStyle(border, {border: '1px solid black', background: 'white', display: 'none', position: 'absolute'});
        wrapper.id = 'lightlightbox-wrapper';

        for (var i = 0; i < links.length; i++) {
            if (/(jpg|jpeg|gif|png)$/.test(links[i].href.toLowerCase())
                && ((classFilter.length > 0 && links[i].className.indexOf(classFilter) >= 0) || classFilter.length == 0)) {
                var onClickFuncs = links[i].onclick;
                links[i].onclick = function (event) {
                    event = event || window.event;
                    if (event.ctrlKey || event.altKey) return true;
                    if (typeof onClickFuncs == 'function') onClickFuncs();
                    var de = document.documentElement;
                    var w = window.innerWidth || self.innerWidth || (de && de.clientWidth) || body.clientWidth;
                    var h = window.innerHeight || self.innerHeight || (de && de.clientHeight) || body.clientHeight;
                    var x = window.pageXOffset || (de && de.scrollLeft) || body.scrollLeft;
                    var y = window.pageYOffset || (de && de.scrollTop) || body.scrollTop;
                    setStyle(loading, {display: 'block', top: 0.5*(h-loading.size[1])+y, left: 0.5*(w-loading.size[0]), zIndex: 1000, position: 'absolute'});
                    return !preLoadImg(this.href, this.title, border, function (img, imgObject) {
                        var size = [imgObject.width, imgObject.height];
                        if (imgObject.width/imgObject.height > w/h && imgObject.width > sizeRatio*w)
                            size = [sizeRatio*w, sizeRatio*w / imgObject.width * imgObject.height];
                        else if (imgObject.width/imgObject.height < w/h && imgObject.height > sizeRatio*h)
                            size = [sizeRatio*h / imgObject.height * imgObject.width, sizeRatio*h];
                        loading.style.display = 'none';
                        setStyle(border, {display: 'block', top: 0.5*(h-size[1])+y-4, left: 0.5*(w-size[0])+x-4, width: size[0]+6, height: size[1]+6, zIndex: 998, opacity: 0});
                        setStyle(close, {position: 'absolute', display: 'block', top: 0.5*(h-size[1]-close.size[1])+y-3, left: 0.5*(w-size[0]-close.size[0])+x-3, zIndex: 1000, cursor: 'pointer', opacity: 0});
                        setStyle(img, {position: 'absolute', display: 'block', top: 3, left: 3, width: size[0], height: size[1], zIndex: 999, opacity: 0});
                        fade([border, img, close], period, false, function () {
                            img.onclick = close.onclick = function () {fade([border, img, close], period, true);};
                        });
                        var keyPressFuncs = document.onkeypress;
                        document.onkeypress = function () {
                            if (typeof keyPressFuncs == 'function') keyPressFuncs();
                            close.onclick();
                            document.onkeypress = keyPressFuncs;
                        };
                    });
                };
            };
        }
    };

    function preLoadImg (src, alt, parent, callback) {
        try {
            var cache = (this.cache)?this.cache:[];
            if (!cache[src]) {
                var imgObject = new Image();
                var elem = (/MSIE 5|MSIE 6/.test(window.navigator.userAgent) && /png$/.test(src))?
                    setStyle(document.createElement('span'), {filter: 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\''+src+'\', sizingMethod=\'scale\')', display: 'block'}):document.createElement('img');
                imgObject.onload = function () {
                    elem.size = [imgObject.width, imgObject.height];
                    setStyle(elem, {width: elem.size[0], height: elem.size[1], display: 'none'});
                    if (typeof callback == 'function') callback(elem, imgObject);
                    cache[src].loaded = true;
                };
                elem.src = imgObject.src = src;
                elem.alt = alt || '';
                cache[src] = [parent.appendChild(elem), imgObject];
            }
            else if (typeof callback == 'function' && cache[src].loaded) callback(cache[src][0], cache[src][1]);
            return cache[src][0];
        }
        catch (e) { return false; }
    }

    function fade (elems, period, out, callback) {
        var startTime = new Date().getTime();
        var interval = setInterval(function () {
            var pos = (new Date().getTime() - startTime) / period;
            if (pos >= 1 && (pos = 1)) {
                clearInterval(interval);
                if (out) setStyle(elems, {display: 'none'});
                if (typeof callback == 'function') callback();
            }
            setStyle(elems, {opacity: (out)?1-pos:pos});
        }, 20);
    }

    function setStyle (elems, styles) {
        var tmp = elems;
        if (!elems.length) elems = [elems];
        for (var elem in elems) {
            for (var style in styles) {
                if (style == 'opacity' && elems[elem].filter && (elems[elem].style.filter = 'alpha(opacity='+ styles[style] +')')) continue;
                elems[elem].style[style] = styles[style] + ((/top|right|left|height|width/.test(style))?'px':'');
            }
        }
        return tmp;
    }

    if (window.addEventListener) window.addEventListener('load', init, false);
    else if (typeof attachEvent == 'function') attachEvent(window, 'load', init);
    else {
        var onloadFuncs = window.onload;
        window.onload = function () {
            if (onloadFuncs) onloadFuncs();
            init();
        };
    }
})();
