// written by othree, 2008
// Cookie function by MovableType : http://www.movabletype.com/

(function () {
    var init = function () {
        var form = document.getElementById('comment-form');
        if (form) {
            var name = document.getElementById('author'),
                mail = document.getElementById('email'),
                home = document.getElementById('url'),
                remember = document.getElementById('remember'),
                sign = document.getElementById('sign-info'),
                t1, t2, loginout;

            loginout = document.createElement('a');
            home.value = getCookie('o3home');

            if (commenter_name != '') {
                loginout.href = 'http://othree.net/mt/mt-comments.cgi?__mode=handle_sign_in&amp;static=1&amp;logout=1&amp;entry_id=' + entryID;
                loginout.appendChild(document.createTextNode('登出'));
                t1 = document.createTextNode(commenter_name + '您好，您已經使用OpenID登入了（');
                t2 = document.createTextNode('）。');
                name.parentNode.style.display = 'none';
                mail.parentNode.style.display = 'none';
            } else {
                loginout.href = 'http://othree.net/mt/mt-comments.cgi?__mode=login&amp;entry_id=' + entryID + '&amp;blog_id=1&amp;static=1';
                loginout.appendChild(document.createTextNode('登入'));
                t1 = document.createTextNode('你可以使用OpenID');
                t2 = document.createTextNode('此網站留言');
                name.value = getCookie('o3auth');
                mail.value = getCookie('o3mail');
            }
            if (name.value || mail.value || home.value) remember.checked = true;
            if (home.value == '') home.value = 'http://';
            while (sign.firstChild) sign.removeChild(sign.firstChild);
            sign.appendChild(t1);
            sign.appendChild(loginout);
            sign.appendChild(t2);

            var onsubmitFuncs = form.onsubmit;
            form.onsubmit = function () {
                var text = document.getElementById('text');
                var flag = false;
                if (text.value == '') text.focus();
                else {
                    if (remember.checked) {
                        var HOST = 'blog.othree.net';
                        var mailv = mail.value;
                        var homev = home.value;
                        var expireTime = new Date();
                        expireTime.setTime(expireTime.getTime() + 365 * 24 * 60 * 60 * 1000);
                        if (!/[^@]+@[^\.@]+(\.[^\.\@]+)+/.test(mailv)) mailv = '';
                        if (homev == 'http://') homev = '';
                        else if (!/^http:\/\//.test(homev)) homev = 'http://' + homev;
                        setCookie('o3auth', name.value, expireTime, '\/', HOST, '');
                        setCookie('o3mail', mailv, expireTime, '\/', HOST, '');
                        setCookie('o3home', homev, expireTime, '\/', HOST, '');
                    } else {
                        deleteCookie('o3auth', '\/', HOST);
                        deleteCookie('o3mail', '\/', HOST);
                        deleteCookie('o3home', '\/', HOST);
                    }
                    flag = true;
                }
                return (typeof onsubmitFuncs == 'function') ? submitFuncs() && flag : flag;
            };
        }
    };

    function setCookie(name, value, expires, path, domain, secure) {
        document.cookie = name + '=' + escape(value) + ((expires) ? '; expires=' + expires.toGMTString() : '') + ((path) ? '; path=' + path : '') + ((domain) ? '; domain=' + domain : '') + ((secure) ? '; secure' : '');
    }

    function getCookie(name) {
        var prefix = name + '=';
        var c = document.cookie;
        var cookieStartIndex = c.indexOf(prefix);
        if (cookieStartIndex == -1) return '';
        var cookieEndIndex = c.indexOf(';', cookieStartIndex + prefix.length);
        if (cookieEndIndex == -1) cookieEndIndex = c.length;
        return unescape(c.substring(cookieStartIndex + prefix.length, cookieEndIndex));
    }

    function deleteCookie(name, path, domain) {
        if (getCookie(name)) document.cookie = name + '=' + ((path) ? '; path=' + path : '') + ((domain) ? '; domain=' + domain : '') + '; expires=Thu, 01-Jan-70 00:00:01 GMT';
    }

    if (typeof attachEvent == 'function') attachEvent(window, 'load', init);
    else if (window.addEventListener) window.addEventListener('load', init, false);
    else {
        var onLoadFuncs = window.onload;
        window.onload = function () {
            return (typeof onLoadFuncs == 'function') ? onLoadFuncs() && init() : init();
        };
    }
})();// written by othree, 2008
// hidden links 3.0 <http://blog.othree.net/>
// better working with events.js <http://dean.edwards.name/weblog/2005/10/add-event/>

(function () {
    if (window.navigator.userAgent.indexOf('MSIE 5.0') > 0 && window.navigator.userAgent.indexOf('Windows') > 0) return false;

    var links = Array(
        {title: '主控台', url: 'http://othree.net/mt/mt.cgi'},
        {title: 'Analytics', url: 'https://www.google.com/analytics/reporting/dashboard?id=39463&scid=77906'},
        {title: 'Adsense', url: 'https://www.google.com/adsense/report/overview'},
        {title: 'FeedBurner', url: 'http://www.feedburner.com/fb/a/dashboard?id=923720'}
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
            var out = (list.style.display == 'none') ? false : true;
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
                setStyle(list, {top: (Math.sin(pos * Math.PI / 2) * (show.top - hide.top) + hide.top),
                                right: (Math.sin(pos * Math.PI / 2) * (show.right - hide.right) + hide.right),
                                opacity: pos});
            }, 20);
            return true;
        };
    };

    function setStyle(elem, style) {
        for (var i in style) {
            if (i == 'opacity' && elem.filter && (elem.style.filter = 'alpha(opacity=' + style[i] + ')')) continue;
            elem.style[i] = style[i] + ((/top|right|left|height|width/.test(i)) ? 'px' : '');
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
})();// written by othree, 2008
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
                    setStyle(loading, {display: 'block', top: 0.5 * (h - loading.size[1]) + y, left: 0.5 * (w - loading.size[0]), zIndex: 1000, position: 'absolute'});
                    return !preLoadImg(this.href, this.title, border, function (img, imgObject) {
                        var size = [imgObject.width, imgObject.height];
                        if (imgObject.width / imgObject.height > w / h && imgObject.width > sizeRatio * w)
                            size = [sizeRatio * w, sizeRatio * w / imgObject.width * imgObject.height];
                        else if (imgObject.width / imgObject.height < w / h && imgObject.height > sizeRatio * h)
                            size = [sizeRatio * h / imgObject.height * imgObject.width, sizeRatio * h];
                        loading.style.display = 'none';
                        setStyle(border, {display: 'block', top: 0.5 * (h - size[1]) + y - 4, left: 0.5 * (w - size[0]) + x - 4, width: size[0] + 6, height: size[1] + 6, zIndex: 998, opacity: 0});
                        setStyle(close, {position: 'absolute', display: 'block', top: 0.5 * (h - size[1] - close.size[1]) + y - 3, left: 0.5 * (w - size[0] - close.size[0]) + x - 3, zIndex: 1000, cursor: 'pointer', opacity: 0});
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
            }
        }
    };

    function preLoadImg(src, alt, parent, callback) {
        try {
            var cache = (this.cache) ? this.cache : [];
            if (!cache[src]) {
                var imgObject = new Image();
                var elem = (/MSIE 5|MSIE 6/.test(window.navigator.userAgent) && /png$/.test(src)) ?
                    setStyle(document.createElement('span'), {filter: 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + src + '\', sizingMethod=\'scale\')', display: 'block'}) : document.createElement('img');
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

    function fade(elems, period, out, callback) {
        var startTime = new Date().getTime();
        var interval = setInterval(function () {
            var pos = (new Date().getTime() - startTime) / period;
            if (pos >= 1 && (pos = 1)) {
                clearInterval(interval);
                if (out) setStyle(elems, {display: 'none'});
                if (typeof callback == 'function') callback();
            }
            setStyle(elems, {opacity: (out) ? 1 - pos : pos});
        }, 20);
    }

    function setStyle(elems, styles) {
        var tmp = elems;
        if (!elems.length) elems = [elems];
        for (var elem in elems) {
            for (var style in styles) {
                if (style == 'opacity' && elems[elem].filter && (elems[elem].style.filter = 'alpha(opacity=' + styles[style] + ')')) continue;
                elems[elem].style[style] = styles[style] + ((/top|right|left|height|width/.test(style)) ? 'px' : '');
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
// Analytic
//_uacct = "UA-77906-1";
//urchinTracker();

var pageTracker = _gat._getTracker('UA-77906-1');
pageTracker._initData();
pageTracker._trackPageview();
