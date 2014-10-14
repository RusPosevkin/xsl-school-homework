<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--ID формы [number]-->
	<xsl:param name="sectionID"/>
	<xsl:variable name="titlePath" select="/announcements/section[@id=$sectionID]/title" />
	<xsl:variable name="paraPath" select="/announcements/section[@id=$sectionID]/para" />
    <xsl:output method="html" indent="yes"/>
    <!--Предотвращаем вывод всех данных по умолчанию-->
    <xsl:template match="text()|@*"/>

    <xsl:template match="/">
    <html>
		<head>
			<title>Платежная форма</title>
		</head>
		<body>
            <h1>
                <xsl:value-of select="$titlePath"/>
            </h1>
            <p>
                <xsl:value-of select="$paraPath"/>
            </p>
		</body>
    </html>
    </xsl:template>
</xsl:stylesheet>
