<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"                
xmlns:str="http://exslt.org/strings"                              
xmlns:regexp="http://exslt.org/regular-expressions"                
extension-element-prefixes="str regexp">

<xsl:output method="html" indent="yes"/>

<xsl:param name="queryString"/>                       

<!--Предотвращаем вывод всех данных по умолчанию-->
<xsl:template match="text()|@*"/>    

<xsl:template match="/">
	<html>
		<head>
			<title>Валидация</title>
		</head>
		<body>
			<xsl:apply-templates select="/xforms/form/fields"/>
		</body>
	</html>
</xsl:template>

<xsl:template match="/xforms/form/fields">
	<!--Получаем отдельные записи для каждого поля-->
	<xsl:variable name="params" select="str:split($queryString, '&amp;')"/>
	<!--Все поля с атрибутом name-->
	<xsl:variable name="currentNode" select="./*[@name]"/>
	<!--Список ограничений для каждого поля-->
	<xsl:variable name="bindNodes" select="../model/bind[@nodeset]"/>
	
	<xsl:for-each select="$params">
		<xsl:call-template name="keyValueParse">
			<xsl:with-param name="query" select="."/>
			<xsl:with-param name="currentNode" select="$currentNode"/>
			<xsl:with-param name="bindNodes" select="$bindNodes"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template name="keyValueParse">
	<xsl:param name="query"/>
	<xsl:param name="currentNode"/>
	<xsl:param name="bindNodes"/>
	
	<!--Выделение имени поля и соответствующего ему значения-->
	<xsl:variable name="fieldName" select="str:split($query, '=')[position()=1]"/>
	<xsl:variable name="fieldValue" select="str:split($query, '=')[position()=2]"/>

	<!--Получаем атрибут ref, связывающий поле с описанием ограничений в блоке с данными-->
	<xsl:call-template name="getRestrictions">
		<xsl:with-param name="reference" select="$currentNode[@name=$fieldName]/@ref"/>
		<xsl:with-param name="bindNodes" select="$bindNodes"/>
		<xsl:with-param name="value" select="$fieldValue"/>
	</xsl:call-template>
</xsl:template>

<!--Получение списка ограничений для конкретного поля-->
<xsl:template name="getRestrictions">
	<xsl:param name="reference"/>
	<xsl:param name="bindNodes"/>
	<xsl:param name="value"/>
	
	<xsl:for-each  select="$bindNodes[@nodeset=$reference]/@*[name()!='nodeset']">

		<xsl:choose>
			<xsl:when test="name() = 'length'">
				<xsl:call-template name="validateLength">
					<xsl:with-param name="value" select="$value"/>
					<xsl:with-param name="restrictValue" select="."/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="name() = 'min'">
				<xsl:call-template name="validateMin">
					<xsl:with-param name="value" select="$value"/>
					<xsl:with-param name="restrictValue" select="."/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="name() = 'max'">
				<xsl:call-template name="validateMax">
					<xsl:with-param name="value" select="$value"/>
					<xsl:with-param name="restrictValue" select="."/>
				</xsl:call-template>
			</xsl:when>
			
			<!--EXSLT RegExp не поддерживается в xsltproc
			С помощью javascript-процессора использовать xslt:test() тоже не получилось
			ниже в закомментированном виде представлен код, как на мой взгляд это должно работать
			По факту, проверка паттерна не осуществляется-->
			
			<!--<xsl:when test="name() = 'regexp'">
				<xsl:call-template name="validateRegExp">
					<xsl:with-param name="value" select="$value"/>
					<xsl:with-param name="restrictValue" select="."/>
				</xsl:call-template>
			</xsl:when>-->
		</xsl:choose>
	</xsl:for-each>

</xsl:template>

<xsl:template name="validateLength">
	<xsl:param name="value"/>
	<xsl:param name="restrictValue"/>

	<xsl:if test="string-length($value) &gt;= $restrictValue">
		<p>
			<xsl:text>Ошибка: Длина строки "</xsl:text>
			<strong>
				<xsl:value-of select="$value"/>
			</strong>
			<xsl:text>" превышает допустимый размер в </xsl:text>
			<strong>
				<xsl:value-of select="$restrictValue"/>
			</strong>
			<xsl:text> символов.</xsl:text>
		</p>
	</xsl:if>
</xsl:template>

<xsl:template name="validateMin">
	<xsl:param name="value"/>
	<xsl:param name="restrictValue"/>
	
	<xsl:if test="$value &lt; $restrictValue">
		<p>
			<xsl:text>Ошибка: Значение "</xsl:text>
			<strong>
				<xsl:value-of select="$value"/>
			</strong>
			<xsl:text>" меньше минимально допустимого значения "</xsl:text>
			<strong>
				<xsl:value-of select="$restrictValue"/>
			</strong>
			<xsl:text>".</xsl:text>
		</p>	
	</xsl:if>
</xsl:template>

<xsl:template name="validateMax">
	<xsl:param name="value"/>
	<xsl:param name="restrictValue"/>
	
	<xsl:if test="$value &gt; $restrictValue">
		<p>
			<xsl:text>Ошибка: Значение "</xsl:text>
			<strong>
				<xsl:value-of select="$value"/>
			</strong>
			<xsl:text>" больше максимально допустимого значения "</xsl:text>
			<strong>
				<xsl:value-of select="$restrictValue"/>
			</strong>
			<xsl:text>".</xsl:text>	
		</p>
	</xsl:if>
</xsl:template>

<!--Валидация паттерна-->
<!--<xsl:template name="validateRegExp">
	<xsl:param name="value"/>
	<xsl:param name="restrictValue"/>
	
	<xsl:if test="regexp:test($value, $restrictValue)">
	<p>
			<xsl:text>Ошибка: Значение "</xsl:text>
			<strong>
				<xsl:value-of select="$value"/>
			</strong>
			<xsl:text>" не соответствует паттерну "</xsl:text>
			<strong>
				<xsl:value-of select="$restrictValue"/>
			</strong>
			<xsl:text>".</xsl:text>	
		</p>
	</xsl:if>
</xsl:template>
-->

</xsl:stylesheet>
