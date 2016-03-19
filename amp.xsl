<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:b="http://blog.othree.net" xmlns:o="http://www.opml.org/spec2/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/" xmlns:link="http://purl.org/rss/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xmlns:str="http://exslt.org/strings" extension-element-prefixes="str" xsi:schemaLocation="http://blog.othree.net http://blog.othree.net/blooog.xsd http://www.w3.org/1999/XSL/Transform xslt.xsd" xml:lang="en" exclude-result-prefixes="html b o xsi rdf link taxo str">
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
<html amp="amp">
	<head>
		<meta charset="utf-8" />
		<title>
			<xsl:if test="$listType != 'i'"><xsl:value-of select="$listData" /> : </xsl:if><xsl:value-of select="b:blogTitle" />
		</title>
		<meta name="description">
			<xsl:attribute name="content">
				<xsl:if test="$listType != 'i'"><xsl:value-of select="$listData" /> : </xsl:if><xsl:value-of select="b:blogTitle" />
			</xsl:attribute>
		</meta>
		<meta name="keywords" content="othree, ooo, blog, acg, html, css, javascript, vim, web page design" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0" />
    <style amp-custom="amp-custom">
      .thumbnail,pre{display:block;line-height:20px}#content h3,h1{text-align:center}html body{background-color:#fffffb;font-family:-apple-system,PingFangTC-Regular,"微軟正黑體","Microsoft JhengHei",sans-serif;scroll-behavior:smooth}#page-info,hr{display:none}a:link,a:visited{margin-left:3px;margin-right:3px;text-decoration:none;color:#666}a:active,a:hover{text-decoration:underline}footer,header,main,nav{margin-left:auto;margin-right:auto;max-width:480px}h1{margin-bottom:30px}#content{padding:5px 5px 0}amp-img,img{width:auto\9;height:auto;max-width:100%;vertical-align:middle;border:0;-ms-interpolation-mode:bicubic}amp-iframe{margin-left:-5px;margin-right:-5px}ol,ul{padding-left:1.3em}.thumbnail{padding:4px;border:1px solid #ddd;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;-webkit-box-shadow:0 1px 3px rgba(0,0,0,.055);-moz-box-shadow:0 1px 3px rgba(0,0,0,.055);box-shadow:0 1px 3px rgba(0,0,0,.055);-webkit-transition:all .2s ease-in-out;-moz-transition:all .2s ease-in-out;-o-transition:all .2s ease-in-out;transition:all .2s ease-in-out}a.thumbnail:hover{border-color:#08c;-webkit-box-shadow:0 1px 4px rgba(0,105,214,.25);-moz-box-shadow:0 1px 4px rgba(0,105,214,.25);box-shadow:0 1px 4px rgba(0,105,214,.25)}.thumbnail img{border-radius:2px;display:block;max-width:100%;margin-right:auto;margin-left:auto}code,pre,pre code{font-size:12px;font-family:'Droid Sans Mono',Monaco,monospace}pre{padding:9.5px;margin:0 0 10px;font-size:13px;word-break:break-all;word-wrap:break-word;white-space:pre;background-color:#f5f5f5;border:1px solid #ccc;border:1px solid rgba(0,0,0,.15);-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;overflow-x:auto}@media (max-width:480px){pre{border-radius:0;border-left:none;border-right:none;margin-left:-5px;margin-right:-5px}}code{padding:2px 4px;color:#d14;background-color:#f7f7f9;border:1px solid #e1e1e8}pre code{padding:0;color:inherit;background-color:transparent;border:0}blockquote{padding:0 0 0 15px;margin:0 0 20px;border-left:5px solid #eee}.nav-inner{background:#51A8DD;padding:0 6px}.nav-inner a:link,.nav-inner a:visited{display:inline-block;padding:6px;color:#fff}#content footer a:active,#content footer a:hover,.nav-inner a:active,.nav-inner a:hover{text-decoration:none;color:#FFE600}#content header time{display:none}#content h3{color:#0872b3;font-size:24px;line-height:1.2;margin:0 0 1.2em}#content p{line-height:1.5}#content footer{color:#fff;background:#51A8DD;padding:0 6px 0 12px;margin-top:2em;margin-left:-5px;margin-right:-5px}#content footer a:link,#content footer a:visited{display:inline-block;padding:6px 6px 6px 0;color:#fff}#content footer .canonical{float:right}
    </style>
		<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
		<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="https://feeds.feedburner.com/othree" />
		<link rel="made" href="mailto:othree@gmail.com" />
		<xsl:choose>
      <xsl:when test="$listType = 's'">
        <link rel="canonical" href="{$canonical}" />
      </xsl:when>
    </xsl:choose>
    <xsl:text disable-output-escaping='yes'>&lt;style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}&lt;/style>&lt;noscript>&lt;style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}&lt;/style>&lt;/noscript>

    </xsl:text>
    <script async="async" custom-element="amp-iframe" src="https://cdn.ampproject.org/v0/amp-iframe-0.1.js"></script>
    <script async="async" src="https://cdn.ampproject.org/v0.js"></script>
	</head>
	<body itemscope="itemscope" itemtype="http://schema.org/Blog">
    <xsl:choose>
        <xsl:when test="$listType = 'about'">
            <xsl:attribute name="itemscope">itemscope</xsl:attribute>
            <xsl:attribute name="itemtype">http://schema.org/AboutPage</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
            <xsl:attribute name="itemscope">itemscope</xsl:attribute>
            <xsl:attribute name="itemtype">http://schema.org/Blog</xsl:attribute>
        </xsl:otherwise>
    </xsl:choose>

		<xsl:if test="$listType = 'about' or $listType = 'archive' or $listType = 'o'  or $listType = 'ca' or $listType = 'a'  or $listType = 'y'">
			<xsl:attribute name="class">layout-2</xsl:attribute>
		</xsl:if>
		<!--div id="skipnavigation"><a href="#content" title="跳過導覽列">跳過導覽列</a></div-->
        <nav>
          <div class="nav-inner">
            <div class="pure-menu pure-menu-horizontal">
                <a href="{$mainPath}{$ext}" class="pure-menu-item">
                    <xsl:if test="$listType = 'i'">
                        <xsl:attribute name="id">pure-menu-selected</xsl:attribute>
                        <xsl:attribute name="class">pure-menu-item pure-menu-selected</xsl:attribute>
                    </xsl:if>
                    首頁
                </a>
                <a href="{$mainPath}log/{$ext}" accesskey="3" class="pure-menu-item">
                    <xsl:if test="$listType = 'm' or $listType = 'y' or $listType = 'c' or $listType = 's' or $listType = 'a' or $listType = 'ca' or $listType = 'archive'">
                        <xsl:attribute name="id">pure-menu-selected</xsl:attribute>
                        <xsl:attribute name="class">pure-menu-item pure-menu-selected</xsl:attribute>
                    </xsl:if>
                    彙整
                </a>
                <a href="{$mainPath}blogroll/{$ext}" title="BLOGROLL" class="pure-menu-item">
                    <xsl:if test="$listType = 'o'">
                        <xsl:attribute name="id">pure-menu-selected</xsl:attribute>
                        <xsl:attribute name="class">pure-menu-item pure-menu-selected</xsl:attribute>
                    </xsl:if>
                    部落滾
                </a>	
                <a href="{$mainPath}about/me/{$ext}" class="pure-menu-item">
                    <xsl:if test="$listType = 'about'">
                        <xsl:attribute name="id">pure-menu-selected</xsl:attribute>
                        <xsl:attribute name="class">pure-menu-item pure-menu-selected</xsl:attribute>
                    </xsl:if>
                    關於
                </a>
                <a href="https://github.com/othree" target="_blank" class="pure-menu-item icon github">Github</a>
            </div>
          </div>
        </nav>
        <div id="container" class="container">
            <header role="banner" class="pure-g">
              <h1 class="pure-u-1">
                <a href="{$mainPath}{$ext}" accesskey="1" title="O3noBLOG">
                  <svg version="1.1" id="logo" x="0px" y="0px" width="320" height="37" viewBox="0 0 569 65">
                    <g>
                      <path fill="#F75C2F" stroke="#000000" stroke-width="2" d="M10,5.5V1h22.5H55v4.5V10h4.5H64v22.5V55h-4.5H55v4.5V64H32.5H10v-4.5V55H5.5H1V32.5V10h4.5H10V5.5z M46,32.5 V10H32.5H19v22.5V55h13.5H46V32.5z M82,5.5V1h27h27v4.5V10h-4.5H127v4.5V19h-4.5H118v4.5V28h4.5h4.5v4.5V37h4.5h4.5v9v9h-4.5H127v4.5V64h-22.5H82 v-4.5V55h-4.5H73v-4.5V46h9h9v4.5V55h13.5H118v-9v-9h-13.5H91v-4.5V28h4.5h4.5v-4.5V19h4.5h4.5v-4.5V10H95.5H82V5.5z M145,41.5V19h27h27v4.5V28h4.5h4.5v18v18h-9h-9V46V28h-13.5H163v18v18h-9h-9V41.5z M226,23.5V19h22.5H271v4.5V28h4.5h4.5v13.5V55h-4.5H271v4.5V64h-22.5H226v-4.5V55h-4.5H217V41.5V28h4.5h4.5 V23.5z M262,41.5V28h-13.5H235v13.5V55h13.5H262V41.5z M289,32.5V1h27h27v4.5V10h4.5h4.5v9v9h-4.5H343v4.5V37h4.5h4.5v9v9h-4.5H343v4.5V64h-27h-27V32.5z M334,19v-9 h-13.5H307v9v9h13.5H334V19z M334,46v-9h-13.5H307v9v9h13.5H334V46z M370,32.5V1h9h9v27v27h18h18v4.5V64h-27h-27V32.5z M442,5.5V1h22.5H487v4.5V10h4.5h4.5v22.5V55h-4.5H487v4.5V64h-22.5H442v-4.5V55h-4.5H433V32.5V10h4.5h4.5V5.5z M478,32.5V10h-13.5H451v22.5V55h13.5H478V32.5z M523,5.5V1h22.5H568v4.5V10h-18h-18v4.5V19h-4.5H523v13.5V46h4.5h4.5v4.5V55h9h9v-9v-9h-4.5H541v-4.5V28h13.5 H568v18v18h-22.5H523v-4.5V55h-4.5H514v-4.5V46h-4.5H505V32.5V19h4.5h4.5v-4.5V10h4.5h4.5V5.5z"/>
                    </g>
                  </svg>
                </a>
              </h1>
            </header>
            <div class="pure-g">
                <xsl:apply-templates select="b:entries/b:entriesMeta" />
                <main id="content" role="main" class="pure-u-1 pure-u-lg-3-4">
                    <hr/>
                    <xsl:apply-templates select="b:entries"/>
                </main>
            </div>
		</div>
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
        <time itemprop="datePublished" datetime="{b:datetime/b:date}T{b:datetime/b:time}">
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
      文章分類：
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

      <a class="canonical" href="{$permalink}" title="「{b:title}」的原始位置">原始位置</a>
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
                <a href="{$permalink}">閱讀「<xsl:value-of select="../b:title" />」全文</a>
            </em>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="b:extendContent" mode="content" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:if>

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
  <xsl:choose>
    <xsl:when test="local-name() = 'iframe'">
      <xsl:element name="amp-iframe">
        <xsl:attribute name="sandbox">allow-scripts allow-same-origin</xsl:attribute>
        <xsl:attribute name="layout">responsive</xsl:attribute>
        <xsl:copy-of select="@*" />
        <xsl:apply-templates mode="copy-no-ns" />
      </xsl:element>
    </xsl:when>
    <xsl:when test="local-name() = 'img'">
      <xsl:element name="amp-img">
        <xsl:attribute name="layout">responsive</xsl:attribute>
        <xsl:choose>
          <xsl:when test="local-name() = 'img' and $w = 's' and contains(@*[local-name() = 'src-1'], '')">
            <xsl:call-template name="srcset">
              <xsl:with-param name="set"><xsl:value-of select="substring(@*[local-name() = 'src-1'], 19)"/></xsl:with-param>
              <xsl:with-param name="res">1x</xsl:with-param>
              <xsl:with-param name="def"><xsl:value-of select="@*[local-name() = 'src']" /></xsl:with-param>
            </xsl:call-template>
            <xsl:copy-of select="@*[not(starts-with(local-name(), 'src'))]" />
          </xsl:when>
          <xsl:when test="local-name() = 'img' and $dpr >= 1.5 and contains(@*[local-name() = 'src-2'], '2x')">
            <xsl:call-template name="srcset">
              <xsl:with-param name="set"><xsl:value-of select="@*[local-name() = 'src-2']"/></xsl:with-param>
              <xsl:with-param name="res">2x</xsl:with-param>
              <xsl:with-param name="def"><xsl:value-of select="@*[local-name() = 'src']" /></xsl:with-param>
            </xsl:call-template>
            <xsl:copy-of select="@*[not(starts-with(local-name(), 'src'))]" />
          </xsl:when>
          <xsl:when test="local-name() = 'img' and $w = 's' and contains(@*[local-name() = 'srcset'], '')">
            <xsl:call-template name="srcset">
              <xsl:with-param name="set"><xsl:value-of select="@*[local-name() = 'srcset']"/></xsl:with-param>
              <xsl:with-param name="res">768w</xsl:with-param>
              <xsl:with-param name="def"><xsl:value-of select="@*[local-name() = 'src']" /></xsl:with-param>
            </xsl:call-template>
            <xsl:copy-of select="@*[not(starts-with(local-name(), 'src'))]" />
          </xsl:when>
          <xsl:when test="local-name() = 'img' and $dpr >= 1.5 and contains(@*[local-name() = 'srcset'], '768w 2x')">
            <xsl:call-template name="srcset">
              <xsl:with-param name="set"><xsl:value-of select="@*[local-name() = 'srcset']"/></xsl:with-param>
              <xsl:with-param name="res">2x</xsl:with-param>
              <xsl:with-param name="def"><xsl:value-of select="@*[local-name() = 'src']" /></xsl:with-param>
            </xsl:call-template>
            <xsl:copy-of select="@*[not(starts-with(local-name(), 'src'))]" />
          </xsl:when>
          <xsl:when test="local-name() = 'img' and $dpr >= 1.5 and contains(@*[local-name() = 'src'], 'staticflickr.com') and contains(@*[local-name() = 'src'], '_') = false">
            <xsl:attribute name="src">
              <xsl:variable name="p" select="@*[local-name() = 'src']" />
              <xsl:value-of select="substring($p, 1, string-length($p)-4)"/>
              <xsl:text>_b</xsl:text>
              <xsl:value-of select="substring($p, string-length($p)-3)"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[not(starts-with(local-name(), 'src'))]" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="@*[not(starts-with(local-name(), 'src-'))]" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:copy-of select="@*[not(starts-with(local-name(), 'src-'))]" />
        <xsl:apply-templates mode="copy-no-ns" />
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="{local-name()}">
        <xsl:copy-of select="@*" />
        <xsl:apply-templates mode="copy-no-ns" />
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
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
