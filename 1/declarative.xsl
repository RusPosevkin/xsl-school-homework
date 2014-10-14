<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--ID формы [number]-->
	<xsl:param name="sectionID"/>
    <xsl:output method="html" indent="yes"/>
    <!--Предотвращаем вывод всех данных по умолчанию-->
    <xsl:template match="text()|@*"/>

    <xsl:template match="/">
    <html>
		<head>
			<title>Платежная форма</title>
		</head>
		<body>
			<xsl:apply-templates>
				<xsl:with-param name="sectionID" select="$sectionID" />
			</xsl:apply-templates>
		</body>
    </html>
    </xsl:template>

    <xsl:template match="announcements/section">
    <xsl:param name="sectionID"/>
		<xsl:if test="@id=$sectionID">
			<xsl:apply-templates/>
		</xsl:if>
    </xsl:template>

    <xsl:template match="title">
    <h1>
		<xsl:value-of select="."></xsl:value-of>
    </h1>
    </xsl:template>

    <xsl:template match="para">
    <p>
		<xsl:value-of select="."></xsl:value-of>
    </p>
    </xsl:template>

</xsl:stylesheet>
