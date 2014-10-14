<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="year"/>
<xsl:param name="sort" select="'artist'" />
<xsl:param name="order" select="'ascending'" />
<xsl:param name="artist"/>
<xsl:output method="html" indent="yes"/>

<!--Предотвращаем вывод всех данных по умолчанию-->
<xsl:template match="text()|@*"/>

<xsl:template match="/">
    <html>
		<head>
			<title>Audio-CD</title>
		</head>
		<body>
			<xsl:apply-templates select="audio">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="artist" select="$artist"/>
				<xsl:with-param name="sort" select="$sort"/>
			</xsl:apply-templates>
		</body>
    </html>
</xsl:template>

<xsl:template match="audio">
<h1>
	<xsl:text>Список альбомов</xsl:text>
	<xsl:if test="$artist">
		<xsl:text> исполнителя </xsl:text>
		<xsl:value-of select="$artist"/>
	</xsl:if>
	<xsl:if test="$year">
		<xsl:text>, выпущенных в </xsl:text>
		<xsl:value-of select="$year"/>
		<xsl:text> году</xsl:text>
	</xsl:if>
</h1>
<table border="1">
	<thead>
		<tr>
			<th>Обложка</th>
			<th>Альбом</th>
			<th>Исполнитель</th>
			<th>Студия</th>
			<th>Список треков</th>
		</tr>
	</thead>
	<tbody>
		<xsl:apply-templates select="cd[( @year = $year or $year = '' ) and ( @artist = $artist or $artist = '' )]">
			<xsl:sort select="@*[name()=$sort]" order="{$order}" data-type="text"/>
		</xsl:apply-templates>
	</tbody>
</table>
</xsl:template>

<xsl:template match="cd">
	<tr>
	<!--Обложка-->
	<td>
			<xsl:apply-templates select="cover/@href">
				<xsl:with-param name="src"/>
			</xsl:apply-templates>
	</td>
	<!--Название альбома-->
	<td>
		<xsl:value-of select="@name"/>
	</td>
	<!--Исполнитель-->
	<td>
		<xsl:value-of select="@artist"/>
	</td>
	<!--Студия-->
	<td>
		<xsl:value-of select="@label"/>
	</td>
	<!--Список треков-->
	<td>
		<ol>
			<xsl:apply-templates select="track"/>
		</ol>
	</td>
	</tr>

</xsl:template>

<xsl:template match="track">
	<li>
		<xsl:value-of select="."></xsl:value-of>
		<xsl:text> ( </xsl:text>
		<xsl:value-of select="@duration"/>
		<xsl:text> )</xsl:text>
	</li>
</xsl:template>

<xsl:template match="@href">
	<img src="{.}"/>
</xsl:template>
</xsl:stylesheet>
