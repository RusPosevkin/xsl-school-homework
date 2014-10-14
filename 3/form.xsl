<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes"/>
                       

<!--Предотвращаем вывод всех данных по умолчанию-->
<xsl:template match="text()|@*"/>    

    <xsl:template match="/">        
    <html>            
		<head>                
			<title>XFoms</title>            
		</head>           
		<body> 
			<xsl:apply-templates select="xforms"/>
		</body>        
    </html>    
    </xsl:template>
    
<xsl:template match="form">
	<form>
		<fieldset>
			<xsl:if test="@title">
				<legend>
					<xsl:value-of select="@title"/>
				</legend>
			</xsl:if>

			<xsl:apply-templates select="fields"/>
		</fieldset>
	</form>
</xsl:template>    

<xsl:template match="fields">
	<xsl:apply-templates/>
</xsl:template>
    
<xsl:template match="input">
	<xsl:if test="label and @type!='hidden'">
		<label>
		<!-- Связываем текст подписи с полем -->
			<xsl:attribute name="for">
				<xsl:value-of select="generate-id(.)"/>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</label>
	</xsl:if>
	<input>
	<!-- Связываем текст подписи с полем -->
		<xsl:attribute name="id">
				<xsl:value-of select="generate-id(.)"></xsl:value-of>
			</xsl:attribute>
		<xsl:attribute name="type">
			<xsl:value-of select="@type"/>
		</xsl:attribute>
		<xsl:if test="@ref">
			<xsl:variable name="reference" select="@ref"/>
			<xsl:attribute name="value">
				<xsl:value-of select="/xforms/form/model/instance/data/*[name()=$reference]"/>
			</xsl:attribute>
			<!-- Получаем все ограничения для текущего элемента -->
			<xsl:apply-templates select="/xforms/form/model/bind[@nodeset=$reference]/@*[name()!='nodeset']"/>
		</xsl:if>
	</input>
	<br/>
</xsl:template>

<xsl:template match="select">
	<xsl:if test="label">
		<label>
			<xsl:value-of select="label"/>
		</label>
	</xsl:if>
	<select>
		<xsl:apply-templates select="option"/>
	</select>
	
</xsl:template>

<xsl:template match="option">
	<option>
		<xsl:value-of select="."/>
	</option>
</xsl:template>

<xsl:template match="submit">
	<input type="submit">
		<xsl:if test="label">
			<xsl:attribute name="value">
				<xsl:value-of select="label"/>
			</xsl:attribute>
		</xsl:if>
	</input>
</xsl:template>

<!-- Определение ограничений полей -->
<xsl:template match="bind/@*">
<xsl:variable name="name" select="name()"></xsl:variable>
<xsl:choose>
	<xsl:when test="($name='min') or ($name='max')">
		<xsl:attribute name="{$name}">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:when>
	<xsl:when test="( $name = 'required') and ( . = 'true')">
		<xsl:attribute name="required">
				<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:when>
	<xsl:when test="$name='length'">
		<xsl:attribute name="maxlength">
				<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:when>
	<xsl:when test="$name='regexp'">
		<xsl:attribute name="pattern">
				<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:when>
</xsl:choose>
	
</xsl:template>



</xsl:stylesheet>
