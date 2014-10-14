<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl">
<xsl:output method="html" indent="yes"/>

<!-- Определение текущего элемента меню -->
<xsl:param name="currentItem">
	<xsl:value-of select="/root/request/url"/>
</xsl:param>

<xsl:param name="host">
	<xsl:value-of select="/root/request/host"/>
</xsl:param>

<!--Предотвращаем вывод всех данных по умолчанию-->
<xsl:template match="text()|@*"/>

<xsl:template match="/">
	<!--Формирование временного дерева-->
	<xsl:variable name="tempTree">
		<xsl:apply-templates />
	</xsl:variable>
	<!--Формирование html-разметки меню-->
	<xsl:apply-templates select="exsl:node-set($tempTree)" mode="html"/>
	<!--<xsl:apply-templates select="/xforms/form/fields"/>-->
</xsl:template>

<!--Шаблоны временного дерева-->
	<xsl:template match="root">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="project">
		<menu>
			<xsl:apply-templates/>
		</menu>
	</xsl:template>

	<xsl:template match="page">
		<item>
			<xsl:if test=".=$currentItem">
				<!--Текущий выбранный элемент меню-->
				<xsl:attribute name="is-current">
					<xsl:text>true</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<title>
				<xsl:value-of select="@name"/>
			</title>
			<url>
				<xsl:value-of select="$host"/>
				<xsl:value-of select="."/>
			</url>
		</item>
	</xsl:template>

	<!--Шаблоны выходного html-файла-->
	<xsl:template match="menu" mode="html">
		<html>
		<head>
			<title>Menu</title>
		</head>
		<body>
		<style type="text/css">
			<![CDATA[
			li {
				list-style-type: none;
			}
			]]>
		</style>
		<ul>
			<xsl:apply-templates mode="html"/>
		</ul>
		</body>
    </html>

	</xsl:template>

	<!--Невыбранные элементы меню — ссылки-->
	<xsl:template match="item[@is-current=false()]" mode="html">
		<li>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="url"/>
				</xsl:attribute>
				<xsl:value-of select="title"/>
			</a>
		</li>
	</xsl:template>

	<!--Текущий выбранный элемент меню-->
	<xsl:template match="item" mode="html">
		<li>
			<cite>
				<xsl:value-of select="title"/>
			</cite>
		</li>
	</xsl:template>
</xsl:stylesheet>
