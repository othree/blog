<?PHP 
if (preg_match("/application\/xhtml\+xml/",getenv('HTTP_ACCEPT')) || preg_match("/W3C/", getenv('HTTP_USER_AGENT'))) {
    //$output_html = preg_replace("/\s*<meta http-equiv=.*>/","",$output_html);  //<meta http-equiv /> does not need for XHTML 1.1
    header("Content-type: application/xhtml+xml; charset=UTF-8");
}
?>
<!DOCTYPE html> 
<html xmlns="http://www.w3.org/1999/xhtml" lang="zh-tw"> 
  <head> 
    <meta charset="UTF-8" /> 
    <title>O3noBLOG</title>
    <meta name="description" content="O3noBLOG" />
    <meta name="keywords" content="ooo, blog, acg, html, xhtml, css, apache, web page design" />
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" type="text/css" href="/stylesheets/html5reset-1.6.css" /> 
    <link rel="stylesheet" type="text/css" href="/stylesheets/default/main.css" title="default" /> 
    <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="/rss2.xml" />
    <link rev="made" href="mailto:othree@gmail.com" />
    <link rel="next" title="彙整" href="/log/" />
    <link rel="top" title="首頁" href="/" />
  </head>
  <body class="layout-2">
    <div id="container">
      <header role="banner"> 
        <h1><a href="/" accesskey="1" title=""><img src="http://blog.othree.net/stylesheets/default/images/logo.png" alt="O3noBLOG" /></a></h1> 
        <nav> 
          <h2>導覽列</h2> 
          <ul> 
            <li><a href="/" title="O3的部落格">首頁</a></li> 
            <li><a href="/log/" title="O3的部落格的文章彙整">彙整</a></li> 
            <li><a href="/blogroll/" title="O3的BLOGROLL">部落滾</a></li> 
            <li><a href="/about/here/" title="關於O3的部落格">關於這</a></li> 
            <li id="active"><a href="/error.php">錯誤</a></li>
          </ul> 
        </nav> 
        <p id="happydesigner">A Happy(?)Designer ~~</p> 
      </header>
      <div id="page-info">
        <h2>找不到頁面</h2>
        <div id="page-nav">
	  <a href="/">上一層</a><!--fix for ie-->
        </div>
      </div>
      <div id="content" role="main"> 
	<p>你所尋找的頁面<strong><?PHP echo getenv('REQUEST_URI'); ?></strong>不存在，你可以使用以下幾種方法到達你所要的頁面：</p>
	<ul>
	 <li>使用<a href="#search">搜尋系統</a>搜尋你所尋找的內容。</li>
	 <li>回到<a href="/">首頁</a>，或是透過整理過的<a href="/log/">彙整</a>按照類別或日期尋找。</li>
	 <li>你也可以透過<a href="mailto:othree@gmail.com">email回報站長</a>此一錯誤。</li>
	</ul>
      </div>
      <hr/>
      <aside>
        <h2>其它資訊</h2>
        <form method="post" id="search-form" action="http://othree.net/mt/mt-search.cgi">
          <fieldset>
            <h3>
              <label for="search" id="search-label">關鍵字搜尋</label>
            </h3>
            <input type="hidden" name="IncludeBlogs" value="1" />
            <label for="search" id="sub-search-label" accesskey="4">尋找：</label>
            <input accesskey="s" id="search" type="search" name="search" size="20" tabindex="8" value="" />
            <input type="submit" value="搜尋" tabindex="9" onclick="this.readonly = 'readonly'" onkeypress="this.readonly = 'readonly'" />
          </fieldset>
        </form>
        <h3>關於本網站</h3>
        <address class="vcard">本網站是<span class="fn nickname">O3(othree)</span>的個人部落格，主要內容為網路標準、網頁設計，穿插些ACG心得和敗家紀錄，如果需要聯絡我請寄信到<strong><a href="mailto:othree@gmail.com" class="email">othree@gmail.com</a></strong>。</address>
        <h3>我在看什麼</h3>
        <ul>
          <li><a href="http://www.anobii.com/people/othree/">aNobii書櫃</a></li>
        </ul>
        <h3>訂閱本網誌</h3>
        <ul>
          <li><a href="http://feeds.feedburner.com/othree"><img src="http://feeds.feedburner.com/~fc/othree?bg=3366FF&amp;fg=FFFFCC&amp;anim=0" height="26" width="88" alt="訂閱本部絡格" /></a></li>
          <li><a href="/about/feeds/">其他版本與快速訂閱</a></li>
        </ul>
        <h3>貼紙</h3>
          <p><a href="http://happybusy.googlepages.com/"><img src="/images/busy_banner.png" width="200" height="40" alt="時間がない" /></a><a href="https://developer.mozilla.org/en/JavaScript" title="JavaScript Reference, JavaScript Guide, JavaScript API, JS API, JS Guide, JS Reference, Learn JS, JS Documentation"><img src="http://static.jsconf.us/promotejshs.png" height="150" width="180" alt="JavaScript Reference, JavaScript Guide, JavaScript API, JS API, JS Guide, JS Reference, Learn JS, JS Documentation" /></a><a xmlns:sioc="http://rdfs.org/sioc/ns#" rel="sioc:has_owner" href="https://creativecommons.net/othree/"> 
            <img src="http://i.creativecommons.net/p/othree/" style="border:0px;" /></a></p> 
      </aside>
      <div id="b">
        <hr/>
      </div>
    </div>
    <footer>
      <h2>認證、授權</h2>
      <p>
        <a href="http://dev.w3.org/html5/spec/Overview.html" title="HTML 5 標準">HTML 5</a>,
        <a href="http://www.w3.org/Style/CSS/current-work" title="CSS 3 標準">CSS 3</a>,
        <a href="http://www.w3.org/WAI/intro/aria">WAI-ARIA</a>,
        <a href="http://www.w3.org/TR/WAI-WEBCONTENT/">WCAG</a>,
        <a href="http://creativecommons.org/licenses/by/3.0/tw/">創用CC 姓名標示</a>
      </p> 
    </footer>
  </body>
</html>

