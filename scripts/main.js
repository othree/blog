// Cookie function by MovableType : http://www.movabletype.com/

(function (window, document, $) {
    $(function () {
        var form = $('#comment-form'),
            name = $('#author'),
            mail = $('#email'),
            home = $('#url'),
            remember = $('#remember');

        if (form.length > 0) {

            form.submit(function () {
                var text = document.getElementById('text'),
                    HOST = 'blog.othree.net',
                    mailv = mail.val(),
                    homev = home.val(),
                    expireTime = new Date(),
                    flag = false;
                if (text.value === '') {
                    text.focus();
                } else {
                    if (remember.attr('checked')) {
                        expireTime.setTime(expireTime.getTime() + 365 * 24 * 60 * 60 * 1000);
                        if (!/[^@]+@[^\.@]+(\.[^\.\@]+)+/.test(mailv)) {
                            mailv = '';
                        }
                        if (homev === 'http://') {
                            homev = '';
                        } else if (!/^http:\/\//.test(homev)) {
                            homev = 'http://' + homev;
                        }
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
            });
        }
    });

    function setCookie(name, value, expires, path, domain, secure) {
        document.cookie = name + '=' + escape(value) + ((expires) ? '; expires=' + expires.toGMTString() : '') + ((path) ? '; path=' + path : '') + ((domain) ? '; domain=' + domain : '') + ((secure) ? '; secure' : '');
    }

    function getCookie(name) {
        var prefix = name + '=',
            c = document.cookie,
            cookieStartIndex = c.indexOf(prefix),
            cookieEndIndex;
        if (cookieStartIndex === -1) {
            return '';
        }
        cookieEndIndex = c.indexOf(';', cookieStartIndex + prefix.length);
        if (cookieEndIndex === -1) {
            cookieEndIndex = c.length;
        }
        return unescape(c.substring(cookieStartIndex + prefix.length, cookieEndIndex));
    }

    function deleteCookie(name, path, domain) {
        if (getCookie(name)) {
            document.cookie = name + '=' + ((path) ? '; path=' + path : '') + ((domain) ? '; domain=' + domain : '') + '; expires=Thu, 01-Jan-70 00:00:01 GMT';
        }
    }

}(window, document, jQuery));
