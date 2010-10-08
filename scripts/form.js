// written by othree, 2008
// Cookie function by MovableType : http://www.movabletype.com/

(function () {  
    var init = function () {
        var form = document.getElementById('comment-form');
        if (form) {
            var name = document.getElementById('author');
            var mail = document.getElementById('email');
            var home = document.getElementById('url');
            var remember = document.getElementById('remember');
            var sign = document.getElementById('sign-info');
            var t1, t2, loginout;
            loginout = document.createElement('a');
            home.value = getCookie('o3home');
            if (commenter_name != "") {
                loginout.href = 'http://othree.net/cgi-bin/mt/mt-comments.cgi?__mode=handle_sign_in&amp;static=1&amp;logout=1&amp;entry_id='+ entryID;
                loginout.appendChild(document.createTextNode('登出'));
                t1 = document.createTextNode(commenter_name +'您好，您已經使用OpenID登入了（');
                t2 = document.createTextNode('）。');
                name.parentNode.style.display = 'none';
                mail.parentNode.style.display = 'none';
            } else {
                loginout.href = 'http://othree.net/cgi-bin/mt/mt-comments.cgi?__mode=login&amp;entry_id='+ entryID +'&amp;blog_id=1&amp;static=1';
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
                if (text.value == "") text.focus();
                else {
                    if (remember.checked) {
                        var HOST = 'blog.othree.net';
                        var mailv = mail.value;
                        var homev = home.value;
                        var expireTime = new Date();
                        expireTime.setTime(expireTime.getTime() + 365 * 24 * 60 * 60 * 1000);
                        if (!/[^@]+@[^\.@]+(\.[^\.\@]+)+/.test(mailv)) mailv = "";
                        if (homev == "http://") homev = "";
                        else if (!/^http:\/\//.test(homev)) homev = "http://" + homev;
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
                return (typeof onsubmitFuncs == 'function')? submitFuncs() && flag : flag;
            };
        }
    };
    
    function setCookie (name, value, expires, path, domain, secure) {
        document.cookie = name + "=" + escape(value) + ((expires) ? "; expires=" + expires.toGMTString() : "") + ((path) ? "; path=" + path : "") + ((domain) ? "; domain=" + domain : "") + ((secure) ? "; secure" : "");
    }

    function getCookie (name) {
        var prefix = name + '=';
        var c = document.cookie;
        var cookieStartIndex = c.indexOf(prefix);
        if (cookieStartIndex == -1) return '';
        var cookieEndIndex = c.indexOf(";", cookieStartIndex + prefix.length);
        if (cookieEndIndex == -1) cookieEndIndex = c.length;
        return unescape(c.substring(cookieStartIndex + prefix.length, cookieEndIndex));
    }

    function deleteCookie (name, path, domain) {
        if (getCookie(name)) document.cookie = name + "=" + ((path) ? "; path=" + path : "") + ((domain) ? "; domain=" + domain : "") + "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }

    if (typeof attachEvent == 'function') attachEvent(window, 'load', init);
    else if (window.addEventListener) window.addEventListener('load', init, false);
    else {
        var onLoadFuncs = window.onload;
        window.onload = function () {
            return (typeof onLoadFuncs == 'function')? onLoadFuncs()&&init() : init() ;
        };
    }
})();
