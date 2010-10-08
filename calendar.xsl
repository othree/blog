<?xml version="1.0"?>
<!--
	Copyright (C) 2000 KAGA Shu
	All rights reserved.
	$Id$
-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:b="http://blog.othree.net"
	exclude-result-prefixes="b"
	version="1.0">
<!--
	Calendar XSLT Ver 0.23a  2000/11/18
		作成者:  加賀 周
		
		! このXSLTは山本陽平さん作成の
		   [XSLT 用日付操作ライブラリ XSLT Date]
		が必要です。
	
		月を指定することでその年月のカレンダーが作成できる XSLT の
		テンプレートます。日本の休日に対応しています。
		
		表示を変更する場合でも、このファイルを書き直す必要はありません。
		表示変更を行う場合は [応用] を読んでください。
	
	
	利用方法:
		まず、xsl:import でこのファイルをロードします。
		
		<xsl:import href="calendar.xsl"/>
		
		基本となるテンプレートは makeCalendar という名前です。
		
		<xsl:template name="makeCalendar">
			<xsl:param name="year"/>		[年]
			<xsl:param name="month"/>	[月]
		</xsl:template>
		
		このテンプレートを呼び出すには、次のようにします。
		
		<xsl:call-template name="makeCalendar">
			<xsl:with-param name="year" select="2000"/>
			<xsl:with-param name="month" select="1"/>
		</xsl:call-template>
		
		この例では2000年1月のカレンダーが得られます。
		
		見栄えに関する変更は、すぐ下の attribute-set 要素を編集すること
		で行えます。
		
	応用
	
		一部のテンプレートは上書きして、表示を変更できます。
		上書きしてもいいテンプレートは以下の通り。
		
			makeCalendarTable	（テーブル内のキャプション出現位置等）
			calendarHeading	（テーブルヘッダ表示部）
			calendarCaption	（[x年x月]表示部）
			makeCalendarCell	（各セル表示部）
		
		上書きは、このファイルを呼び出すXSLTシート内で行ってください。
		このファイルを改変する必要はありません。
		
		変更したいテンプレートは、このファイルからコピーして編集することを
		おすすめします。
		
		注意:
			パラメタは必ず同じものを宣言してください。
		
		
	遍歴
		Version 0.23
			シンプルに。日指定削除。
		Version 0.22
			日指定をつける。
		Version 0.2
			山本さんの XSLT Date に対応。
		Version 0.2
			処理の大幅改善。
			見た目の変更を容易（?）にできるようにしました。
		Version 0.11
			休日判定XSLTのデバッグ（秋分、春分の日による振替休日に対応）
			少しだけ処理の改善。
		Version 0.1
			とりあえず組んだもの（未公開）
-->
	
	<xsl:template name="makeCalendar">
		<!-- 変数宣言 -->
		<xsl:param name="month"/>
		<xsl:param name="year"/>

		<xsl:variable name="endDay">
			<xsl:choose>
				<xsl:when test="$month = 2">
					<xsl:choose>
						<xsl:when test="$year mod 4 = 0">
							<xsl:choose>
								<xsl:when test="not($year mod 100 = 0 and not($year mod 400 = 0))">29</xsl:when>
								<xsl:otherwise>28</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>28</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- 4,6,9,11月 -->
				<xsl:when test="$month=4 or $month=6 or $month=9 or $month=11">30</xsl:when>
				<xsl:otherwise>31</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<!-- Table 構築 -->
		<xsl:call-template name="makeCalendarTable">
			<xsl:with-param name="year" select="$year"/>
			<xsl:with-param name="month" select="$month"/>
			<xsl:with-param name="endDay" select="$endDay"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="makeCalendarTable">
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		<xsl:param name="endDay"/>

		<table class="calendar" summary="{$year}/{$month}">
			<xsl:call-template name="calendarCaption">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
			</xsl:call-template>
			<xsl:call-template name="calendarHeading"/>
			<tbody>
			
				<xsl:call-template name="_createTR">
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="endDay" select="$endDay"/>
					<xsl:with-param name="startDay" select="1"/>
				</xsl:call-template>
			
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template name="calendarCaption">
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		<caption>
			<xsl:value-of select="$year"/>
			<xsl:text>年</xsl:text>
			<xsl:value-of select="$month"/>
			<xsl:text>月</xsl:text>
		</caption>
	</xsl:template>

	<xsl:template name="calendarHeading">
		<thead>
			<tr>
				<th abbr="sunday">
					<xsl:text>日</xsl:text>
				</th>
				<th abbr="monday">
					<xsl:text>一</xsl:text>
				</th>
				<th abbr="tuesday">
					<xsl:text>二</xsl:text>
				</th>
				<th abbr="wednesday">
					<xsl:text>三</xsl:text>
				</th>
				<th abbr="thursday">
					<xsl:text>四</xsl:text>
				</th>
				<th abbr="friday">
					<xsl:text>五</xsl:text>
				</th>
				<th abbr="saturday">
					<xsl:text>六</xsl:text>
				</th>
			</tr>
		</thead>
	</xsl:template>

	<xsl:template name="_createTR">
		<!-- 変数宣言 -->
		<xsl:param name="year"/>
		<xsl:param name="month"/>
		<xsl:param name="endDay"/>
		<xsl:param name="startDay"/>
		
		<xsl:variable name="wday">
			<xsl:choose>
				<xsl:when test="$startDay = 1">
					<xsl:call-template name="dayOfWeek">
						<xsl:with-param name="year" select="$year"/>
						<xsl:with-param name="month" select="$month"/>
						<xsl:with-param name="day" select="$startDay"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
				
		
		<tr>
			<xsl:if test="$startDay = 1 and $wday != 1">
				<!-- 空のTD挿入 -->
				<xsl:call-template name="_createNullTD">
					<xsl:with-param name="count" select="$wday - 1"/>
				</xsl:call-template>
			</xsl:if>
					
			<xsl:call-template name="_createTD">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="numDay" select="$startDay"/>
				<xsl:with-param name="limit" select="$endDay"/>
				<xsl:with-param name="wday" select="$wday"/>
			</xsl:call-template>
							
			<xsl:if test="($startDay + 7 &gt; $endDay)
				 and ($wday + ($endDay - $startDay) != 7)">
				<!-- 空のTD挿入 -->
				<xsl:call-template name="_createNullTD">
					<xsl:with-param name="count" select="7 - ($wday + ($endDay - $startDay))"/>
				</xsl:call-template>
			</xsl:if>
		</tr>

		<!-- 再帰 -->
		<xsl:if test="not($startDay + 7 &gt; $endDay)">
			<xsl:call-template name="_createTR">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="startDay" select="$startDay + (8-$wday)"/>
				<xsl:with-param name="endDay" select="$endDay"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="dayOfWeek">
		<xsl:param name="year" />
		<xsl:param name="month" />
		<xsl:param name="day" />
		
		<!--
		  PASCAL からの移植
		
		  (参) コンピュータアルゴリズム事典 p.17
		    奥村晴彦著 : 技術評論社
		    ISBN4-87408-913-5 C3055 \2200E
		
		  Zeller の公式。
		  戻り値 1:日、2:月、...、7:土
		
		  日数の一定でない 2月 を最後にもっていき、
		  1月、2月 をそれぞれ前年の 13月、14月 とみなしている。
		  PASCAL 版は if で条件分岐していたが、計算で出すよう改造。
		-->
		<xsl:variable name="year_"  select="$year - ($month &lt; 3)" />
		<xsl:variable name="month_" select="(($month +9) mod 12) +3" />
		
		<xsl:value-of select="((
		    $year_
		  + floor($year_ div 4)
		  - floor($year_ div 100)
		  + floor($year_ div 400)
		  + floor((13 * $month_ +8) div 5)
		  + $day
		) mod 7 ) +1" />
	</xsl:template>

	<!-- 空白TD挿入 -->	
	<xsl:template name="_createNullTD">
		<xsl:param name="count"/>
		<td><xsl:comment>empty table cell</xsl:comment></td>
		<!-- 再帰 -->
		<xsl:if test="$count &gt; 1">
			<xsl:call-template name="_createNullTD">
				<xsl:with-param name="count" select="$count -1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="_createTD">
		<xsl:param name="numDay"/>
		<xsl:param name="year"/>
		<xsl:param name="month"/>
		<xsl:param name="limit"/>
		<xsl:param name="wday"/>
		
		<xsl:call-template name="makeCalendarCell">
			<xsl:with-param name="numDay" select="$numDay"/>
			<xsl:with-param name="wday" select="$wday"/>
			<xsl:with-param name="year" select="$year"/>
			<xsl:with-param name="month" select="$month"/>
		</xsl:call-template>
		
		<!-- 再帰処理 -->
		<xsl:if test="($wday &lt; 7) and not($numDay = $limit)">
			<xsl:call-template name="_createTD">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="numDay" select="$numDay +1"/>
				<xsl:with-param name="limit" select="$limit"/>
				<xsl:with-param name="wday" select="$wday + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="makeCalendarCell">
		<xsl:param name="year"/>
		<xsl:param name="month"/>
		<xsl:param name="numDay"/>
		<xsl:param name="wday"/>
		<xsl:variable name="today"><xsl:value-of select="$year"/>-<xsl:value-of select="$month"/>-<xsl:number value="$numDay" format="01"/></xsl:variable>
		
		<td title="{$today}">
		<xsl:choose>
			<xsl:when test="count($blog/b:entries/b:entry/b:datetime/b:date[. = $today]) &gt; 0">
				<a href="/log/{$year}/{$month}/#date-{$today}"><xsl:value-of select="$numDay" /></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$numDay" />
			</xsl:otherwise>
		</xsl:choose>
		</td>
	</xsl:template>
	
</xsl:transform>
