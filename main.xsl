<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:b="http://blog.othree.net" xmlns:o="http://www.opml.org/spec2/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/" xmlns:link="http://purl.org/rss/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xmlns:str="http://exslt.org/strings" extension-element-prefixes="str" xsi:schemaLocation="http://blog.othree.net http://blog.othree.net/blooog.xsd http://www.w3.org/1999/XSL/Transform xslt.xsd" xml:lang="en" exclude-result-prefixes="b o xsi rdf link taxo str">
<!-- <xsl:import href="calendar.xsl" /> -->
<!--xsl:output method="xml" encoding="UTF-8" media-type="application/xhtml+xml" omit-xml-declaration="no" indent="yes" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN" cdata-section-elements="script" /-->
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes" />
<xsl:strip-space elements="*"/>
<xsl:param name="ext"></xsl:param>
<xsl:param name="canonical">https://blog.othree.net</xsl:param>
<xsl:param name="mime">html</xsl:param>
<xsl:param name="dpr">1</xsl:param>
<xsl:param name="w">s</xsl:param>
<xsl:variable name="blog" select="//b:blog" />
<xsl:variable name="blogData" select="document('sidebar.xml')" />
<xsl:variable name="blogCategories" select="$blogData//b:blogData/b:categories" />
<xsl:variable name="blogID" select="$blogData//b:blogData/@blogID" />
<xsl:variable name="listType" select="b:blog/b:entries/b:entriesMeta/b:listType" />
<xsl:variable name="listData" select="b:blog/b:entries/b:entriesMeta/b:listData" />
<xsl:variable name="listID" select="b:blog/b:entries/b:entriesMeta/b:listData/@listID" />
<xsl:variable name="mainPath" select="'/'" />
<xsl:variable name="logPath"><xsl:value-of select="$mainPath" />log/</xsl:variable>

<!-- template blog -->

<xsl:template match="b:blog">
<!-- html5 DTD -->
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html>
</xsl:text>
<html lang="zh-tw">
    <xsl:choose>
        <xsl:when test="$listType = 's'">
            <xsl:attribute name="itemscope">itemscope</xsl:attribute>
            <xsl:attribute name="itemtype">http://schema.org/Blog</xsl:attribute>
        </xsl:when>
        <xsl:when test="$listType = 'about'">
            <xsl:attribute name="itemscope">itemscope</xsl:attribute>
            <xsl:attribute name="itemtype">http://schema.org/AboutPage</xsl:attribute>
        </xsl:when>
    </xsl:choose>
	<head>
		<meta charset="UTF-8" />
		<title>
			<xsl:if test="$listType != 'i'"><xsl:value-of select="$listData" /> : </xsl:if><xsl:value-of select="b:blogTitle" />
		</title>
		<meta name="description">
			<xsl:attribute name="content">
				<xsl:if test="$listType != 'i'"><xsl:value-of select="$listData" /> : </xsl:if><xsl:value-of select="b:blogTitle" />
			</xsl:attribute>
		</meta>
		<meta name="keywords" content="othree, ooo, blog, acg, html, css, javascript, vim, web page design" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
        <link rel="stylesheet" type='text/css' href="/stylesheets/bootstrap/css/bootstrap.min.css" />
        <link rel="stylesheet" type='text/css' href="/stylesheets/bootstrap/css/bootstrap-responsive.min.css" />
        <!-- <link rel="stylesheet" type='text/css' href='//fonts.googleapis.com/css?family=Droid+Sans+Mono|Press+Start+2P' /> -->
        <link rel="stylesheet" type='text/css' href="/stylesheets/othree.min.css" />
		<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="http://feeds.feedburner.com/othree" />
		<link rel="made" href="mailto:othree@gmail.com" />
		<xsl:choose>
			<xsl:when test="$listType = 'about'">
				<link rel="previous" title="BLOGROLL" href="{$mainPath}blogroll/{$ext}" />
			</xsl:when>
			<xsl:when test="$listType = 'search'">
				<link rel="previous" title="首頁" href="{$mainPath}{$ext}" />
			</xsl:when>
			<xsl:when test="$listType = 'i'">
				<link rel="next" title="彙整" href="{$mainPath}log/{$ext}" />
			</xsl:when>
			<xsl:when test="$listType = 'a'">
				<link rel="previous" title="首頁" href="{$mainPath}{$ext}" />
				<link rel="next" title="BLOGROLL" href="{$mainPath}blogroll/{$ext}" />
			</xsl:when>
			<xsl:when test="$listType = 'o'">
				<link rel="previous" title="彙整" href="{$mainPath}log/{$ext}" />
				<link rel="next" title="關於" href="{$mainPath}about/me/{$ext}" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="prev_next">
					<xsl:with-param name="porn" select="'prev'" />
					<xsl:with-param name="type" select="'link'" />
				</xsl:call-template>
				<xsl:call-template name="prev_next">
					<xsl:with-param name="porn" select="'next'" />
					<xsl:with-param name="type" select="'link'" />
				</xsl:call-template>
				<link rel="up" title="上一層" href="../" />
			</xsl:otherwise>
		</xsl:choose>
		<link rel="top" title="首頁" href="{$mainPath}{$ext}" />
		<link rel="openid.server" href="http://www.myopenid.com/server" />
		<link rel="openid.delegate" href="http://othree.myopenid.com/" />
		<xsl:choose>
            <xsl:when test="$listType = 's'">
                <link rel="canonical" itemprop="url" href="{$canonical}" />
                <xsl:choose>
                    <xsl:when test="descendant::*[name() = 'p'][1]/descendant::*[name() = 'img']">
                        <meta name="twitter:card" content="photo" />
                        <meta name="twitter:site" content="@othree" />
                    </xsl:when>
                    <xsl:otherwise>
                        <meta name="twitter:card" content="summary" />
                        <meta name="twitter:creator" content="@othree" />
                    </xsl:otherwise>
                </xsl:choose>
                <meta property="og:title" content="{//b:blog/b:entries/b:entry/b:title}" />
                <meta property="og:url" content="{$canonical}" />
                <meta property="og:type" content="article" />
                <meta property="og:description" content="{//b:blog/b:entries/b:entry/b:content/b:summary}" />
                <xsl:for-each select="descendant::*[local-name() = 'img'][1]">
                    <xsl:choose>
                        <xsl:when test="starts-with(@src, '//')">
                            <meta property="og:image" content="http:{@src}" />
                        </xsl:when>
                        <xsl:otherwise>
                            <meta property="og:image" content="{@src}" />
                        </xsl:otherwise>
                    </xsl:choose>
                    <meta property="og:image:width" content="{@width}" />
                    <meta property="og:image:height" content="{@height}" />
                </xsl:for-each>
                <xsl:if test="not(descendant::*[local-name() = 'img'][1])">
                    <meta property="og:image" content="https://blog.othree.net/images/O3-240x240.png" />
                    <meta property="og:image:width" content="240" />
                    <meta property="og:image:height" content="240" />
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <meta property="og:title" content="{b:blogTitle}" />
                <meta property="og:description" content="本網站是othree的個人部落格，主要內容為網路標準、網頁設計，穿插些ACG心得和敗家紀錄" />
                <meta property="og:url" content="{$canonical}" />
                <meta property="og:type" content="website" />
                <meta property="og:image" content="https://blog.othree.net/images/O3-240x240.png" />
                <meta property="og:image:width" content="240" />
                <meta property="og:image:height" content="240" />
            </xsl:otherwise>
		</xsl:choose>
        <meta property="fb:admins" content="582724207" />
	</head>
	<body>

		<xsl:if test="$listType = 'about' or $listType = 'archive' or $listType = 'o'  or $listType = 'ca' or $listType = 'a'  or $listType = 'y'">
			<xsl:attribute name="class">layout-2</xsl:attribute>
		</xsl:if>
		<!--div id="skipnavigation"><a href="#content" title="跳過導覽列">跳過導覽列</a></div-->
        <nav class="navbar navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container">
                    <form method="get" id="nav-search" class="navbar-search o-hidden" action="//www.google.com/search" role="search">
                        <input id="search" type="search" name="q" size="20" tabindex="8" placeholder="搜尋" required="required" aria-required="true" class="search-query input-medium" />
                        <input type="hidden"  name="sitesearch" value="blog.othree.net" />
                    </form>
                    <ul class="nav pull-right">
                        <li>
                            <xsl:if test="$listType = 'i'">
                                <xsl:attribute name="id">active</xsl:attribute>
                                <xsl:attribute name="class">active</xsl:attribute>
                            </xsl:if>
                            <a href="{$mainPath}{$ext}">首頁</a>
                        </li>
                        <li>
                            <xsl:if test="$listType = 'm' or $listType = 'y' or $listType = 'c' or $listType = 's' or $listType = 'a' or $listType = 'ca' or $listType = 'archive'">
                                <xsl:attribute name="id">active</xsl:attribute>
                                <xsl:attribute name="class">active</xsl:attribute>
                            </xsl:if>
                            <a href="{$mainPath}log/{$ext}" accesskey="3">彙整</a>
                        </li>
                        <li>
                            <xsl:if test="$listType = 'o'">
                                <xsl:attribute name="id">active</xsl:attribute>
                                <xsl:attribute name="class">active</xsl:attribute>
                            </xsl:if>
                            <a href="{$mainPath}blogroll/{$ext}" title="BLOGROLL">部落滾</a>
                        </li>	
                        <li>
                            <xsl:if test="$listType = 'about'">
                                <xsl:attribute name="id">active</xsl:attribute>
                                <xsl:attribute name="class">active</xsl:attribute>
                            </xsl:if>
                            <a href="{$mainPath}about/me/{$ext}">關於</a>
                        </li>
                        <li class="icon github">
                            <a href="https://github.com/othree">Github</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <div id="container" class="container">
            <header role="banner" class="row">
                <h1 class="span12">
                    <a href="{$mainPath}{$ext}" accesskey="1" title="O3noBLOG">O3noBLOG</a>
                </h1>
            </header>
            <div class="row">
                
                <xsl:apply-templates select="b:entries/b:entriesMeta" />
                <div id="content" role="main" class="span9">
                    <hr/>
                    <xsl:apply-templates select="b:entries"/>
                </div>
                <aside role="complementary" class="span3">
                    <hr />
                    <h2>其它資訊</h2>
                    <form method="get" id="search-form" class="form-search" action="http://www.google.com/search" role="search">
                        <input accesskey="4" id="search" type="search" name="q" size="20" tabindex="8" placeholder="搜尋" required="required" aria-required="true" class="search-query input-medium" />
                        <input type="hidden"  name="sitesearch" value="blog.othree.net" />
                        <!-- <button type="submit" value="GO" tabindex="9" class="btn" >GO</button> -->
                    </form>
                    <hr />
                    <div role="contentinfo">
                    <xsl:if test="$listType = 's'">
                        <h3>關於本文章</h3>
                        <p><strong><xsl:value-of select="//b:blog/b:entries/b:entriesMeta/b:listData"/></strong>發表於 <xsl:value-of select="//b:blog/b:entries/b:entry/b:datetime/b:date"/>，文章類別為
                        <xsl:choose>
                        <xsl:when test="//b:blog/b:entries/b:entry/b:category != ''">
                            <a href="{$logPath}{//b:blog/b:entries/b:entry/b:category}/{$ext}">
                                <xsl:variable name="temp" select="//b:blog/b:entries/b:entry/b:category" />
                                <xsl:choose>
                                    <xsl:when test="$blogCategories/b:category[b:categoryTitle = $temp]/b:categoryDescription/text()">
                                        <xsl:value-of select="$blogCategories/b:category[b:categoryTitle = $temp]/b:categoryDescription" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="b:category" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> 無類別 </xsl:text>
                        </xsl:otherwise>
                        </xsl:choose>
                        ，目前共有 <xsl:value-of select="//b:blog/b:entries/b:entry/b:comments/@commentCount" /> 篇讀者迴響，你可以為此篇文章<a href="#comment-form">留下你的想法</a>，或是訂閱<a href="rss">讀者迴響的RSS</a>。</p>

                        <div>
                            <xsl:variable name="permalink">
                                <xsl:value-of select="'https%3A%2F%2Fblog.othree.net'" />
                                <xsl:call-template name="string-replace-all">
                                    <xsl:with-param name="text" select="concat('/log/',translate(//b:blog/b:entries/b:entry/b:datetime/b:date,'-','/'),'/',//b:blog/b:entries/b:entry/@baseName,'/',$ext)" />
                                    <xsl:with-param name="replace" select="'/'" />
                                    <xsl:with-param name="by" select="'%2F'" />
                                </xsl:call-template>
                            </xsl:variable>
                            <iframe id="fb-button" allowTransparency="true" frameborder="0" scrolling="no" src="//www.facebook.com/plugins/like.php?href=https%3A%2F%2Fblog.othree.net%2F{$permalink}&amp;send=false&amp;layout=box_count&amp;width=41&amp;show_faces=false&amp;font&amp;colorscheme=light&amp;action=like&amp;height=61&amp;appId=263583993673371"></iframe>
                            <iframe id="gp-button" allowtransparency="true" frameborder="0" scrolling="no" src="//plusone.google.com/_/+1/fastbutton?size=tall&amp;hl=zh-TW&amp;url={$permalink}"></iframe>
                            <iframe id="tw-button" allowtransparency="true" frameborder="0" scrolling="no" src="//platform.twitter.com/widgets/tweet_button.html?count=vertical&amp;via=othree&amp;lang=zh-tw&amp;url={$permalink}"></iframe>
                            <!-- <xsl:variable name="permalink" select="concat('/log/',translate(//b:blog/b:entries/b:entry/b:datetime/b:date,'-','/'),'/',//b:blog/b:entries/b:entry/@baseName,'/',$ext)" /> -->
                            <!-- <div class="fb-like" data-href="https://blog.othree.net{$permalink}" data-send="false" data-layout="box_count" data-show-faces="false" data-font="lucida grande"><xsl:text> </xsl:text></div> -->
                            <!-- <div class="g-plusone" data-size="tall" data-href="https://blog.othree.net{$permalink}"><xsl:text> </xsl:text></div> -->
                            <!-- <a href="https://twitter.com/share" class="twitter-share-button" data-url="https://blog.othree.net{$permalink}" data-via="othree" data-lang="zh-tw" data-count="vertical">Tweet</a> -->
                        </div>

                        <xsl:if test="//b:blog/b:entries/b:entriesMeta/b:previous or //b:blog/b:entries/b:entriesMeta/b:next">
                        <p>
                            <xsl:if test="//b:blog/b:entries/b:entriesMeta/b:previous">
                                <div><a class="prev pn" href="/log/{translate(//b:blog/b:entries/b:entriesMeta/b:previous/b:mDate, '-', '/')}/{//b:blog/b:entries/b:entriesMeta/b:previous/b:mBase}/{$ext}"><span class="prefix">上一篇：</span><xsl:value-of select="//b:blog/b:entries/b:entriesMeta/b:previous/b:mTitle"/><time><xsl:value-of select="//b:blog/b:entries/b:entriesMeta/b:previous/b:mDate"/></time></a></div>
                            </xsl:if>

                            <xsl:if test="//b:blog/b:entries/b:entriesMeta/b:next">
                                <div><a class="next pn" href="/log/{translate(//b:blog/b:entries/b:entriesMeta/b:next/b:mDate, '-', '/')}/{//b:blog/b:entries/b:entriesMeta/b:next/b:mBase}/{$ext}"><span class="prefix">下一篇：</span><xsl:value-of select="//b:blog/b:entries/b:entriesMeta/b:next/b:mTitle"/><time><xsl:value-of select="//b:blog/b:entries/b:entriesMeta/b:next/b:mDate"/></time></a></div>
                            </xsl:if>
                        </p>
                        </xsl:if>

                    </xsl:if>

                    <xsl:if test="$listType = 'o'">
                        <h3>關於部落滾</h3>
                        <p>部落滾就是blogroll，這裡列出所有我訂閱的網站feed。</p>
                    </xsl:if>
                    </div>

                    <xsl:if test="$listType != 'about'">
                        <h3>關於本網站</h3>
                        <address itemprop="author" itemscope="itemscope" itemtype="http://schema.org/Person">
                            <p class="vcard">本網站是<a itemprop="name" href="https://twitter.com/othree" class="fn nickname" rel="me">othree</a>的個人部落格，主要內容為網路標準、網頁設計，穿插些ACG心得和敗家紀錄，更詳細的資訊請見<a href="http://blog.othree.net/about/here/">關於這</a>，如要聯絡我請寄信到 <a itemprop="email" href="mailto:othree@gmail.com" class="email">othree@gmail.com</a>。</p>
                        </address>
                    </xsl:if>
                    <xsl:if test="$listType = 'i'">
                    </xsl:if>
                    <!-- <xsl:if test="$listType = 'm'">
                        <h3>月曆</h3>
                        <xsl:call-template name="makeCalendar">
                            <xsl:with-param name="year" select="substring($listID,1,4)"/>
                            <xsl:with-param name="month" select="substring($listID,6,2)"/>
                        </xsl:call-template>
                    </xsl:if> -->
                    <xsl:apply-templates select="$blogData//b:blogData" />
                    <xsl:if test="$listType = 'about'">
                        <h3>關於這的子頁面</h3>
                        <ul>
                            <li><a href="/about/me/{$ext}">關於我</a></li>
                            <li><a href="/about/here/{$ext}">本站資訊</a></li>
                        </ul>
                    </xsl:if>
                    <xsl:if test="$listType != 'archive'">
                        <h3>分類彙整</h3>
                        <ul>
                            <xsl:call-template name="categoryArchive">
                                <xsl:with-param name="cArchive" select="$blogData//b:blog/b:blogData/b:archives/b:archive[b:archiveMeta/b:listType = 'c']" />
                            </xsl:call-template>
                        </ul>
                    </xsl:if>
                    <h3>我在看什麼</h3>
                    <ul>
                        <li><a href="http://www.anobii.com/people/othree/">aNobii書櫃</a></li>
                    </ul>
                    <h3>訂閱本網誌</h3>
                    <ul id="feeds">
                        <li><a href="http://feeds.feedburner.com/othree"><img src="/feedburner/~fc/othree?bg=3366FF&amp;fg=FFFFCC&amp;anim=0" height="26" width="88" alt="訂閱本部絡格" /></a></li>
                    </ul>
                    <h3>貼紙</h3>
                    <p id="stickers">
                        <a href="http://happybusy.googlepages.com/"><img src="/images/busy_banner.png" width="200" height="40" alt="時間がない" /></a>
                        <a href='https://developer.mozilla.org/en/JavaScript' title='JavaScript Reference, JavaScript Guide, JavaScript API, JS API, JS Guide, JS Reference, Learn JS, JS Documentation'><img src='/images/promotejshs.png' height='150' width='180' alt='JavaScript Reference, JavaScript Guide, JavaScript API, JS API, JS Guide, JS Reference, Learn JS, JS Documentation'/></a>
                    </p>
                </aside>
            </div>
            <footer class="row">
                <h2 class="span12">使用技術、規範、服務</h2>
                <p class="span12">
                    <!--a href="http://validator.w3.org/check?uri=referer" xml:lang="en" title="本站所有頁面皆通過W3C檢測器的的檢測為合於規範的XHTML 1.1文件">XHTML</a-->
                    <!--a href="http://jigsaw.w3.org/css-validator/validator?uri=http://blog.othree.net/&amp;warning=2&amp;profile=css3&amp;usermedium=all" xml:lang="en" title="本站使用的CSS語法通過W3C檢測器的的檢測合於CSS 3的規範">CSS</a--> 
                    <a href="http://www.whatwg.org/specs/web-apps/current-work/multipage/" title="HTML 標準">HTML</a>
                    <a href="http://www.w3.org/Style/CSS/current-work" title="CSS 標準">CSS</a>
                    <a href="http://www.w3.org/WAI/intro/aria">WAI-ARIA</a>
                    <a href="http://www.w3.org/TR/WAI-WEBCONTENT/">WCAG</a>
                    <a href="http://creativecommons.org/licenses/by/4.0/deed.zh_TW">CC BY 4.0</a>
                    <a href="https://plus.google.com/108698651587282496682?rel=author">Google+</a>
                </p>
            </footer>
		</div>
        <script src="/scripts/detect_cleartype.js"></script>
        <script src="/scripts/device-pixel-ratio.js"></script>
        <script src="/scripts/nav-search.js"> </script>
        <!-- <xsl:if test="$listType = 's'"> -->
            <!-- <div id="fb-root"><xsl:text> </xsl:text></div> -->
            <!-- <script src="/scripts/googleplusone.js"> </script> -->
            <!-- <script src="/scripts/facebook.js"> </script> -->
            <!-- <script src="/scripts/twitter.js"> </script> -->
        <!-- </xsl:if> -->
        <script src="/scripts/googleanalytic.js"> </script>
	</body>
</html>
</xsl:template>

<!-- template entries -->

<xsl:template match="b:entries">
<xsl:if test="count(b:entry) = 0 and $listType = 'o'">
	<xsl:variable name="blogRoll" select="document('blogroll.opml')" />
	<ul>
		<xsl:apply-templates select="$blogRoll//o:opml/o:body/o:outline" />
	</ul>
</xsl:if>

<xsl:if test="count(b:entry) = 0 and $listType != 'o'">
	<h3>近期無新文章</h3>
</xsl:if>
<xsl:if test="count(b:entry) > 0">
	<xsl:choose>
		<xsl:when test="$listType = 'about'">
			<div class="c special">
				<xsl:for-each select="b:entry">
					<h3><xsl:value-of select="b:title" /></h3>
					<xsl:apply-templates select="b:content/b:mainContent" mode="content" />
				</xsl:for-each>
			</div>
		</xsl:when>
		<xsl:when test="$listType = 'archive'">
			<h3>依照日期整理</h3>
			<ul class="month-archive">
				<xsl:call-template name="monthArchive" >
                    <xsl:with-param name="mArchive" select="$blogData//b:blog/b:blogData/b:archives/b:archive[b:archiveMeta/b:listType = 'm']" />
				</xsl:call-template>
			</ul>
			<h3>依照分類整理</h3>
			<ul>
				<xsl:call-template name="categoryArchive">
					<xsl:with-param name="cArchive" select="$blogData//b:blog/b:blogData/b:archives/b:archive[b:archiveMeta/b:listType = 'c']" />
					<xsl:with-param name="type">full</xsl:with-param>
				</xsl:call-template>
			</ul>
			<h3>其它</h3>
			<ul>
				<li><a href="all/">全部文章索引</a></li>
			</ul>
		</xsl:when>
		<xsl:when test="$listType = 'a' or $listType = 'ca' or $listType = 'y'">
			<ul>
				<xsl:for-each select="b:entry">
					<li>
						<a href="{concat('/log/',translate(b:datetime/b:date,'-','/'),'/',@baseName,'/',$ext)}"><xsl:value-of select="b:title" /></a>
						<time><xsl:value-of select="b:datetime/b:date" /></time>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:when>
		<xsl:when test="$listType = 'i'">
            <xsl:for-each select="b:entry[position()  &lt; last()]">
                <xsl:variable name="showdate">
                    <xsl:if test="position() = 1 or preceding-sibling::b:entry[1]/b:datetime/b:date != b:datetime/b:date">1</xsl:if>
                </xsl:variable>
                <xsl:call-template name="b:entry">
                    <xsl:with-param name="showdate" select="$showdate" />
                </xsl:call-template>
			</xsl:for-each>
            <a id="prev-link" href="/log/{translate(substring(b:entry[last()]/b:datetime/b:date, 0, 8), '-', '/')}/{$ext}#entry-{b:entry[last()]/@baseName}">➡ 看看其它文章</a>
		</xsl:when>
		<xsl:otherwise>
            <xsl:for-each select="b:entry">
                <xsl:variable name="showdate">
                    <xsl:if test="position() = 1 or preceding-sibling::b:entry[1]/b:datetime/b:date != b:datetime/b:date">1</xsl:if>
                </xsl:variable>
                <xsl:call-template name="b:entry">
                    <xsl:with-param name="showdate" select="$showdate" />
                </xsl:call-template>
			</xsl:for-each>
			<xsl:if test="$listType = 'c'">
            <a id="prev-link" href="/log/{//b:entriesMeta/b:listData}/all/{$ext}" class="center">此類別所有文章</a>
			</xsl:if>
			<xsl:if test="$listType = 'm'">
                <a id="prev-link" href="/log/{translate(substring(//b:entries/b:entriesMeta/b:previous/b:mDate, 0, 8), '-', '/')}/{$ext}">➡ 前一個月的文章</a>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:if>
</xsl:template>

<!-- template blogroll -->

<xsl:template match="o:outline">
<li>
	<xsl:choose>
		<xsl:when test="o:outline">
			<xsl:value-of select="@text" />
			<ul>
				<xsl:apply-templates select="o:outline" />
			</ul>
		</xsl:when>
		<xsl:otherwise>
			<a href="{@htmlUrl}"><xsl:value-of select="@title" /></a>
		</xsl:otherwise>
	</xsl:choose>
</li>
</xsl:template>

<!-- template entriesMate -->

<xsl:template match="b:entriesMeta">
<div id="page-info" class="span9">
    <div class="row">
        
	<div class="span6">
        <xsl:apply-templates select="b:listType" />
    </div>
	<div id="page-nav" class="span2">
	<xsl:if test="b:listType = 'c' or b:listType = 'ca' or b:listType = 'm' or b:listType = 'y'">
		<xsl:call-template name="prev_next">
			<xsl:with-param name="porn" select="'prev'" />
			<xsl:with-param name="type" select="'a'" />
		</xsl:call-template>
		<a href="../{$ext}">上一層</a>
		<xsl:call-template name="prev_next">
			<xsl:with-param name="porn" select="'next'" />
			<xsl:with-param name="type" select="'a'" />
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="b:listType = 'o' or b:listType = 'about' or b:listType = 'archive' or b:listType = 's'">
        <a href="../{$ext}">上一層</a>
	</xsl:if>
	<xsl:comment>fix for ie</xsl:comment>
	</div>
    </div>
</div>
</xsl:template>
<!-- template listType -->

<xsl:template match="b:listType">
	<h2>
		<xsl:choose>
			<xsl:when test=". = 'about'"><xsl:value-of select="//b:entriesMeta/b:listData" /></xsl:when>
			<xsl:when test=". = 'search'">搜尋結果</xsl:when>
			<xsl:when test=". = 'archive'">彙整</xsl:when>
			<xsl:when test=". = 'o'">BLOGROLL</xsl:when>
			<xsl:when test=". = 'a'">全部文章索引</xsl:when>
			<xsl:when test=". = 'y'"><xsl:value-of select="//b:entriesMeta/b:listData" /> 文章索引</xsl:when>
			<xsl:when test=". = 'm'">
				<xsl:value-of select="$listData" />
			</xsl:when>
			<xsl:when test=". = 'c' or . = 'ca'">
				<xsl:choose>
					<xsl:when test="$blogCategories/b:category[b:categoryTitle = $listData]/b:categoryDescription/text()">
						<xsl:value-of select="$blogCategories/b:category[b:categoryTitle = $listData]/b:categoryDescription" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$listData" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test=". = 'ca'">文章索引</xsl:if>
			</xsl:when>
			<xsl:when test=". = 's'">單篇彙整</xsl:when>
			<xsl:when test=". = 'i'">最新文章</xsl:when>
		</xsl:choose>
	</h2>
</xsl:template>

<!-- template entry -->

<xsl:template name="b:entry">

<xsl:param name="showdate"></xsl:param>
<xsl:variable name="permalink" select="concat('/log/',translate(b:datetime/b:date,'-','/'),'/',@baseName,'/',$ext)" />
<article itemprop="blogPost" itemscope="itemscope" itemtype="http://schema.org/BlogPosting" id="entry-{@baseName}">
    <header>
        <time itemprop="datePublished" datetime="{b:datetime/b:date}T{b:datetime/b:time}" pubdate="pubdate">
            <xsl:choose>
                <xsl:when test="$showdate != '1'">
                    <xsl:attribute name="class">same-date</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="id">date-<xsl:value-of select="b:datetime/b:date"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <span class="mon"><xsl:value-of select="substring(b:datetime/b:date,6,2)" />月</span>
            <span class="day"><xsl:value-of select="substring(b:datetime/b:date,9,2)" />日</span>
        </time>
        
        <h3 itemprop="name">
            <xsl:choose>
            <xsl:when test="$listType = 's'">
                <xsl:value-of select="b:title" />
            </xsl:when>
            <xsl:otherwise>
                <a href="{$permalink}"><xsl:value-of select="b:title" /></a>
            </xsl:otherwise>
            </xsl:choose>
        </h3>
    </header>
    <section itemprop="articleBody">
        <xsl:apply-templates select="b:content">
            <xsl:with-param name="entryID" select="@entryID" />
            <xsl:with-param name="permalink" select="$permalink" />
        </xsl:apply-templates>
    </section>
    <footer>
        <xsl:choose>
            <xsl:when test="b:category != ''">
                <a href="{$logPath}{b:category}/{$ext}" rel="tag">
                    <xsl:variable name="temp" select="b:category" />
                    <xsl:choose>
                        <xsl:when test="$blogCategories/b:category[b:categoryTitle = $temp]/b:categoryDescription/text()">
                            <xsl:value-of select="$blogCategories/b:category[b:categoryTitle = $temp]/b:categoryDescription" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="b:category" />
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> 無類別 </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <a href="{$permalink}#comments" title="「{b:title}」的迴響">迴響(<xsl:value-of select="b:comments/@commentCount" />)</a>

        <!--<a href="{$permalink}#trackbacks" title="「{b:title}」的引用">引用(<xsl:value-of select="b:trackbacks/@trackbackCount" />)</a>-->
    </footer>
    <xsl:if test="$listType = 's'">
        <xsl:if test="$mime = 'xhtml'">
        <!--object id="GoogleAdSense" data="/adsense.php" type="text/html"  width="468" height="60"><xsl:text> </xsl:text></object-->
        </xsl:if>
        <xsl:if test="$mime = 'html'">
        <!--div id="GoogleAdSense">
            <script type="text/javascript"><![CDATA[
// Adsense for content
google_ad_client = "pub-5627928804904245";
google_ad_width = 468;
google_ad_height = 60;
google_ad_format = "468x60_as";
google_ad_type = "text_image";

google_ad_channel = "1101096509";
google_color_border = "336699";
google_color_bg = "FFFFFF";
google_color_link = "0000FF";
google_color_text = "000000";
google_color_url = "008000";
            ]]></script>
            <script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
        </div-->
        </xsl:if>
        <!--<xsl:apply-templates select="b:trackbacks">-->
            <!--<xsl:with-param name="entryID" select="@entryID" />-->
            <!--<xsl:with-param name="accepted" select="b:PingsAccepted/text()" />-->
        <!--</xsl:apply-templates>-->
        <xsl:apply-templates select="b:comments">
            <xsl:with-param name="entryID" select="@entryID" />
            <xsl:with-param name="accepted" select="b:CommentsAccepted/text()" />
        </xsl:apply-templates>
    </xsl:if>
</article>
<hr/>
</xsl:template>

<!-- template content -->

<xsl:template match="b:content">
<xsl:param name="entryID" />
<xsl:param name="permalink" />
<xsl:apply-templates select="b:mainContent" mode="content" />
<xsl:if test="b:extendContent/*">
	<xsl:choose>
		<xsl:when test="$listType != 's'">
			<em class="extended">
                <a href="{$permalink}">閱讀 「<xsl:value-of select="../b:title" />」 全文</a>
            </em>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="b:extendContent" mode="content" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:if>

</xsl:template>

<!-- template comments -->

<xsl:template match="b:comments">
<xsl:param name="entryID" />
<xsl:param name="accepted" />
<hr/>
<div id="comments">
	<!-- <h4>迴響<span>( -->
	<!-- <xsl:choose> -->
		<!-- <xsl:when test="$accepted = 0"> -->
			<!-- 本文章目前不開放發表迴響 -->
		<!-- </xsl:when> -->
		<!-- <xsl:otherwise> -->
			<!-- <a href="#post_comment">發表你的迴響</a> -->
		<!-- </xsl:otherwise> -->
	<!-- </xsl:choose> -->
	<!-- )</span></h4> -->
	<xsl:choose>
	<xsl:when test="@commentCount &gt; 0">
        <xsl:apply-templates select="b:comment" />
	</xsl:when>
	<xsl:otherwise>
		<p>目前無人回應。</p>
	</xsl:otherwise>
	</xsl:choose>
    <xsl:if test="$accepted = 1">
        <hr/>
        <form id="comment-form" method="post" action="//othree.net/mt/mt-comments.cgi" class="form-horizontal">
            <fieldset>
            <div id="author-row" class="control-group">
              <label for="author" class="control-label">姓名暱稱：<span class="accesskey"><span>accesskey:</span>N</span></label>
              <div class="controls">
                  <input type="text" tabindex="3" id="author" name="author" accesskey="n" value="" />
              </div>
            </div>
            <div id="email-row" class="control-group">
              <label for="email" class="control-label">電子信箱：<span class="accesskey"><span>accesskey:</span>M</span></label>
              <div class="controls">
                  <input type="email" tabindex="4" id="email" name="email" accesskey="m" value="" />
              </div>
            </div>
            <div class="control-group">
              <label for="url" class="control-label">網站位置：<span class="accesskey"><span>accesskey:</span>U</span></label>
              <div class="controls">
                  <input type="url" tabindex="5" id="url" name="url" accesskey="u" placeholder="http://" value="" />
              </div>
            </div>
            <div class="control-group">
              <label for="text" class="control-label">迴響內容：<span class="accesskey"><span>accesskey:</span>C</span></label>
              <div class="controls">
                  <textarea tabindex="6" id="text" name="text" rows="15" cols="60" accesskey="c" class="input-mxlarge"></textarea>
                  <p class="field-tip"> 可以使用 Markdown 語法，<a href="http://markdown.tw">語法說明</a>。 </p>
              </div>
            </div>
            <!--p>
              <label for="remember">記住我：<span class="accesskey"><span>accesskey:</span>R</span></label>
              <input type="checkbox" tabindex="7" id="remember" name="remember" accesskey="r" value="yes" />
            </p-->
            <div class="form-actions">
              <input type="hidden" name="static" value="2"/>
              <input type="hidden" name="entry_id" value="{$entryID}"/>
              <input type="hidden" name="blog_id" value="{$blogID}"/>
              <input type="hidden" name="superstarooo" value="ryun" />

              <button type="submit" tabindex="7" name="post" value="送出" accesskey="p" class="btn btn-primary">送出</button>
              <span class="accesskey"><span>accesskey:</span>P</span>
            </div>
            </fieldset>
        </form>
	</xsl:if>
</div>
</xsl:template>

<!-- template comment -->

<xsl:template match="b:comment">
<article id="comment{@commentID}">
<xsl:attribute name="class">
<xsl:choose>
	<xsl:when test="b:author/b:authorUrl = 'http://blog.othree.net'">comment3 well</xsl:when>
	<xsl:otherwise>comment<xsl:value-of select="position() mod 2"/> well</xsl:otherwise>
</xsl:choose>
</xsl:attribute>

<h5><!--a href="#comment{@commentID}" class="num"><xsl:value-of select="position()" /></a-->
	由
	<xsl:choose>
		<xsl:when test="b:author/b:authorUrl/text()">
			<a href="{b:author/b:authorUrl}"><xsl:value-of select="b:author/b:authorName" /></a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="b:author/b:authorName" />
		</xsl:otherwise>
	</xsl:choose>
	在
	<xsl:value-of select="b:datetime/b:date" /><xsl:text> </xsl:text><xsl:value-of select="b:datetime/b:time" />
	發表：
</h5>
<hr/>
<xsl:apply-templates select="b:content/b:mainContent" mode="content" />
</article>
</xsl:template>

<!-- template blogData -->

<xsl:template match="b:blogData">
<xsl:if test="$listType != 'about' and $listType != 'search' and $listType != 'archive'">
	<xsl:apply-templates select="b:recent" />
</xsl:if>
</xsl:template>

<!-- template recent -->

<xsl:template match="b:recent">
<xsl:if test="$listType = 's'">
	<xsl:apply-templates select="b:recentEntries" />
</xsl:if>
<xsl:if test="$listType = 'i'">
	<xsl:apply-templates select="b:recentComments" />
</xsl:if>
</xsl:template>

<!-- template recentEntries -->

<xsl:template match="b:recentEntries">
<h3>近期文章</h3>
<ul>
    <xsl:for-each select="b:entry">
        <xsl:if test="@baseName != $listData/@baseName">
            <xsl:call-template name="b:entry-r" />
        </xsl:if>
    </xsl:for-each>
</ul>
</xsl:template>

<!-- template entry-recent -->

<xsl:template name="b:entry-r">
<li>
	<a href="{concat('/log/',translate(b:datetime/b:date,'-','/'),'/',@baseName,'/',$ext)}" title="{b:datetime/b:date}"><xsl:value-of select="b:title" /></a>
</li>
</xsl:template>

<!-- template recentComments -->

<xsl:template match="b:recentComments">
<h3>近期迴響</h3>
<ul class="relative">
	<xsl:for-each select="b:comment">
		<xsl:call-template name="b:comment-r" />

	</xsl:for-each>
</ul>
</xsl:template>

<!-- template comment-recent -->

<xsl:template name="b:comment-r">
<li>
	<a href="{concat('/log/',translate(b:entry/b:datetime/b:date,'-','/'),'/',@baseName,'/',$ext,'#comment',@commentID)}" title="{concat(translate(b:datetime/b:date,'\-','\/'),' ',b:datetime/b:time)}">
		Re: <xsl:value-of select="b:entry/b:title" />
	</a>
	<xsl:text> </xsl:text><span>by <xsl:value-of select="b:author/b:authorName" /></span>
	<span class="hideinfo">at <xsl:value-of select="concat(translate(b:datetime/b:date,'\-','\/'),' ',substring(b:datetime/b:time,1,5))" /></span>
</li>
</xsl:template>

<xsl:template name="item">
<li>
	<a href="{link}"><xsl:value-of select="title" /></a>
	<xsl:if test="description">
		<span class="desc"><xsl:value-of select="description" /></span>
	</xsl:if>
	<xsl:if test="category">
		<span class="hideinfo">
			tags: <xsl:apply-templates select="category" />
		</span>
	</xsl:if>
</li>
</xsl:template>

<!-- template link tag -->

<xsl:template match="category">
<xsl:variable name="tag" select="." />
	<a href="{@domain}" title="{$tag} at del.icio.us"><xsl:value-of select="$tag" /></a>
	<xsl:if test="following-sibling::category">, </xsl:if>
</xsl:template>

<!-- template archives -->

<xsl:template match="b:archives">
	<xsl:apply-templates/>
</xsl:template>

<!-- template archive -->

<xsl:template match="b:archive">
<h3>
	<xsl:choose>
		<xsl:when test="b:archiveMeta/b:listType = 'm'">按月彙整</xsl:when>
		<xsl:when test="b:archiveMeta/b:listType = 'w'">按週彙整</xsl:when>
		<xsl:when test="b:archiveMeta/b:listType = 'd'">按日彙整</xsl:when>
		<xsl:when test="b:archiveMeta/b:listType = 'c'">分類彙整</xsl:when>
		<xsl:when test="b:archiveMeta/b:listType = 's'">單篇彙整</xsl:when>
	</xsl:choose>
</h3>
<ul>
	<xsl:choose>
		<xsl:when test="b:archiveMeta/b:listType = 'm'">
			<xsl:attribute name="class">month-archive</xsl:attribute>
			<xsl:call-template name="monthArchive">
					<xsl:with-param name="mArchive" select="." />
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="b:archiveMeta/b:listType = 'c'">
			<xsl:attribute name="id">category-archive</xsl:attribute>
			<xsl:call-template name="categoryArchive">
					<xsl:with-param name="cArchive" select="." />
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</ul>
</xsl:template>

<!-- template monthArchive -->

<xsl:template name="monthArchive">
<xsl:param name="mArchive" />
<xsl:for-each select="$mArchive/b:archiveItem">
	<xsl:sort select="." order="descending" />
	<xsl:if test="substring(preceding-sibling::b:archiveItem[1],1,4) != substring(.,1,4) or not(preceding-sibling::b:archiveItem[1])">
        <li>
			<a href="/log/{substring(.,1,4)}/{$ext}"><xsl:value-of select="substring(.,1,4)" /></a>
			<xsl:text> </xsl:text>:<xsl:text> </xsl:text>
			<ol>
				<xsl:call-template name="loop">
					<xsl:with-param name="y" select="substring(.,1,4)" />
					<xsl:with-param name="cm" select="1" />
				</xsl:call-template>
			</ol>
        </li>
	</xsl:if>
</xsl:for-each>

</xsl:template>

<!-- template loop for monthArchive -->

<xsl:template name="loop">
<xsl:param name="y" />
<xsl:param name="cm">13</xsl:param>
<xsl:param name="m"><xsl:number value="$cm" format="01" /></xsl:param>
<xsl:if test="$cm &lt; 13">
	<xsl:choose>
		<xsl:when test="count(../b:archiveItem[text() = concat($y,'_',$m)]) != 0">
			<xsl:variable name="count" select="../b:archiveItem[text() = concat($y,'_',$m)]/@archiveCount" />
			<li><a href="{$logPath}{concat($y,'/',$m)}/{$ext}" title="{$y}年{$cm}月-共有{$count}篇文章"><xsl:value-of select="$cm" /></a></li>
		</xsl:when>
		<xsl:otherwise>
			<li><span><xsl:value-of select="$cm" /></span></li>
		</xsl:otherwise>
	</xsl:choose><xsl:text> </xsl:text>
	<xsl:call-template name="loop">
		<xsl:with-param name="y" select="$y" />
		<xsl:with-param name="cm" select="$cm +1" />
	</xsl:call-template>
</xsl:if>
</xsl:template>

<!-- template categoryArchive -->

<xsl:template name="categoryArchive">
<xsl:param name="cArchive" />
<xsl:param name="type" />
<xsl:param name="archivetemp">
	<b:archive>
		<xsl:for-each select="b:archiveItem">
			<xsl:sort select="text()" order="ascending" />
			<xsl:copy-of select="." />
		</xsl:for-each>
	</b:archive>
</xsl:param>

<xsl:for-each select="$cArchive/b:archiveItem">
	<li>
		<a href="{$logPath}{.}/{$ext}">
			<xsl:variable name="temp" select="." />
			<xsl:choose>
				<xsl:when test="$blogCategories/b:category[b:categoryTitle = $temp]/b:categoryDescription/text()">
					<xsl:value-of select="$blogCategories/b:category[b:categoryTitle = $temp]/b:categoryDescription" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="." />
				</xsl:otherwise>
			</xsl:choose>
		</a>
		<xsl:text> </xsl:text>
		<span>(<xsl:value-of select="@archiveCount" /><xsl:if test="$type = 'full'">,<a href="{$logPath}{.}/all/{$ext}">索引</a></xsl:if>)</span>
	</li>
</xsl:for-each>
</xsl:template>

<!-- template content -->

<xsl:template mode="content" match="*">
	<xsl:apply-templates mode="copy-no-ns" />
</xsl:template>

<!-- function to get src -->

<xsl:template name="srcset">
    <xsl:param name="set"/>
    <xsl:param name="res"/>
    <xsl:param name="def"/>
    <xsl:variable name="src">
        <xsl:for-each select="str:tokenize($set, ',')">
            <xsl:if test="$res = '' and not(contains(normalize-space(.), ' '))">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:if>
            <xsl:if test="substring-after(normalize-space(.), ' ') = $res">
                <xsl:value-of select="substring-before(normalize-space(.), ' ')"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:attribute name="src">
        <xsl:choose>
            <xsl:when test="$src != ''">
                <xsl:value-of select="$src"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$def"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:attribute>
</xsl:template>

<xsl:template name="src-n">
    <xsl:param name="set"/>
    <xsl:param name="res"/>
    <xsl:param name="def"/>
    <xsl:variable name="src">
        <xsl:for-each select="str:tokenize($set, ',')">
            <xsl:if test="$res = '' and not(contains(normalize-space(.), ' '))">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:if>
            <xsl:if test="substring-after(normalize-space(.), ' ') = $res">
                <xsl:value-of select="substring-before(normalize-space(.), ' ')"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:attribute name="src">
        <xsl:choose>
            <xsl:when test="$src != ''">
                <xsl:value-of select="$src"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$def"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:attribute>
</xsl:template>

<!-- template copy without namespace -->

<xsl:template mode="copy-no-ns" match="*">
<xsl:element name="{local-name()}">
    <xsl:choose>
        <xsl:when test="local-name() = 'img' and $w = 's' and contains(@*[local-name() = 'src-1'], '')">
            <xsl:call-template name="src-n">
                <xsl:with-param name="set"><xsl:value-of select="substring(@*[local-name() = 'src-1'], 19)"/></xsl:with-param>
                <xsl:with-param name="res">1x</xsl:with-param>
                <xsl:with-param name="def"><xsl:value-of select="@*[local-name() = 'src']" /></xsl:with-param>
            </xsl:call-template>
            <xsl:copy-of select="@*[local-name() != 'src']" />
        </xsl:when>
        <xsl:when test="local-name() = 'img' and $dpr >= 1.5 and contains(@*[local-name() = 'src-2'], '2x')">
            <xsl:call-template name="src-n">
                <xsl:with-param name="set"><xsl:value-of select="@*[local-name() = 'src-2']"/></xsl:with-param>
                <xsl:with-param name="res">2x</xsl:with-param>
                <xsl:with-param name="def"><xsl:value-of select="@*[local-name() = 'src']" /></xsl:with-param>
            </xsl:call-template>
            <xsl:copy-of select="@*[local-name() != 'src']" />
        </xsl:when>
        <xsl:when test="local-name() = 'img' and $w = 's' and contains(@*[local-name() = 'srcset'], '')">
            <xsl:call-template name="srcset">
                <xsl:with-param name="set"><xsl:value-of select="@*[local-name() = 'srcset']"/></xsl:with-param>
                <xsl:with-param name="res">768w</xsl:with-param>
                <xsl:with-param name="def"><xsl:value-of select="@*[local-name() = 'src']" /></xsl:with-param>
            </xsl:call-template>
            <xsl:copy-of select="@*[local-name() != 'src']" />
        </xsl:when>
        <xsl:when test="local-name() = 'img' and $dpr >= 1.5 and contains(@*[local-name() = 'srcset'], '768w 2x')">
            <xsl:call-template name="srcset">
                <xsl:with-param name="set"><xsl:value-of select="@*[local-name() = 'srcset']"/></xsl:with-param>
                <xsl:with-param name="res">2x</xsl:with-param>
                <xsl:with-param name="def"><xsl:value-of select="@*[local-name() = 'src']" /></xsl:with-param>
            </xsl:call-template>
            <xsl:copy-of select="@*[local-name() != 'src']" />
        </xsl:when>
        <xsl:when test="local-name() = 'img' and $dpr >= 1.5 and contains(@*[local-name() = 'src'], 'staticflickr.com') and contains(@*[local-name() = 'src'], '_') = false">
            <xsl:attribute name="src">
                <xsl:variable name="p" select="@*[local-name() = 'src']" />
                <xsl:value-of select="substring($p, 1, string-length($p)-4)"/>
                <xsl:text>_b</xsl:text>
                <xsl:value-of select="substring($p, string-length($p)-3)"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[local-name() != 'src']" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy-of select="@*" />
        </xsl:otherwise>
    </xsl:choose>
	<xsl:apply-templates mode="copy-no-ns" />
</xsl:element>
</xsl:template>

<!-- template previous & next -->

<xsl:template name="prev_next">
<xsl:param name="porn">next</xsl:param>
<xsl:param name="type">a</xsl:param>
<xsl:variable name="porn_text">
	<xsl:choose>
		<xsl:when test="$porn = 'next'"><xsl:text>下</xsl:text></xsl:when>
		<xsl:when test="$porn = 'prev'"><xsl:text>上</xsl:text></xsl:when>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="p">
	<xsl:value-of select="$logPath" />
</xsl:variable>
<xsl:variable name="id">
<xsl:choose>
	<xsl:when test="$listType = 'c' or b:listType = 'ca'">
		<xsl:choose>
			<xsl:when test="$porn = 'next'">
				<xsl:value-of select="$blogCategories/b:category[b:categoryTitle = $listData]/following-sibling::b:category[1]/b:categoryTitle"/>
			</xsl:when>
			<xsl:when test="$porn = 'prev'">
				<xsl:value-of select="$blogCategories/b:category[b:categoryTitle = $listData]/preceding-sibling::b:category[1]/b:categoryTitle" />
			</xsl:when>
		</xsl:choose>
	</xsl:when>
	<xsl:when test="$listType = 'm' or $listType = 'y'">
		<xsl:choose>
			<xsl:when test="$porn = 'next'">
				<xsl:value-of select="//b:entries/b:entriesMeta/b:next/b:mDate" />
			</xsl:when>
			<xsl:when test="$porn = 'prev'">
				<xsl:value-of select="//b:entries/b:entriesMeta/b:previous/b:mDate" />
			</xsl:when>
		</xsl:choose>
	</xsl:when>
	<xsl:when test="$listType = 's'">
		<xsl:choose>
			<xsl:when test="$porn = 'next' and /b:entries/b:entriesMeta/b:next">
				<xsl:value-of select="translate(//b:entries/b:entriesMeta/b:next/b:mDate, '-', '/')" />
                <xsl:text>/</xsl:text>
                <xsl:value-of select="//b:entries/b:entriesMeta/b:next/b:mBase" />
			</xsl:when>
			<xsl:when test="$porn = 'prev' and //b:entries/b:entriesMeta/b:previous">
                <xsl:value-of select="translate(//b:entries/b:entriesMeta/b:previous/b:mDate, '-', '/')" />
                <xsl:text>/</xsl:text>
                <xsl:value-of select="//b:entries/b:entriesMeta/b:previous/b:mBase" />
			</xsl:when>
		</xsl:choose>
	</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="t"> 
<xsl:choose>
	<xsl:when test="$listType = 'c' or b:listType = 'ca'">
		<xsl:choose>
			<xsl:when test="$porn = 'next'">
				<xsl:value-of select="$blogCategories/b:category[b:categoryTitle = $listData]/following-sibling::b:category[1]/b:categoryDescription"/>
			</xsl:when>
			<xsl:when test="$porn = 'prev'">
				<xsl:value-of select="$blogCategories/b:category[b:categoryTitle = $listData]/preceding-sibling::b:category[1]/b:categoryDescription"/>
			</xsl:when>
		</xsl:choose>
	</xsl:when>
	<xsl:when test="$listType = 'm' or $listType = 'y' or $listType = 's'">
		<xsl:choose>
			<xsl:when test="$porn = 'next'">
				<xsl:value-of select="//b:entries/b:entriesMeta/b:next/b:mTitle" />
			</xsl:when>
			<xsl:when test="$porn = 'prev'">
				<xsl:value-of select="//b:entries/b:entriesMeta/b:previous/b:mTitle" />
			</xsl:when>
		</xsl:choose>
	</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:if test="$id != ''">
	<xsl:if test="$porn = 'next' and $type= 'a'"> | </xsl:if>
	<xsl:element name="{$type}">
		<xsl:if test="$type = 'link'">
			<xsl:attribute name="rel"><xsl:value-of select="$porn" /></xsl:attribute>
		</xsl:if>
		<xsl:attribute name="title"><xsl:value-of select="$t" /></xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$p" /><xsl:value-of select="$id" /><xsl:text>/</xsl:text><xsl:value-of select="$ext" /></xsl:attribute>
		<xsl:if test="$type = 'a'">
			<xsl:if test="$porn = 'prev'">« </xsl:if>
			<xsl:choose>
				<xsl:when test="$listType = 'c' or b:listType = 'ca'">
					<xsl:value-of select="$t" />
				</xsl:when>
				<xsl:when test="$listType = 'm' or $listType = 'y'"><xsl:value-of select="$t" /></xsl:when>
				<xsl:when test="$listType = 's'"><xsl:value-of select="$porn_text" /><xsl:text>一篇文章</xsl:text></xsl:when>
			</xsl:choose>
			<xsl:if test="$porn = 'next'"> »</xsl:if>
		</xsl:if>
	</xsl:element>
	<xsl:if test="$porn = 'prev' and $type= 'a'"> | </xsl:if>
</xsl:if>
</xsl:template>

<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:transform>
