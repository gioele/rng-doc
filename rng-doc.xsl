<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:d="http://docbook.org/ns/docbook"
	xmlns:rng="http://relaxng.org/ns/structure/1.0"
	version="2.0">
	
	<xsl:output
		encoding="UTF-8"
		method="xml"
		indent="yes"
	/>
	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="/rng:grammar">
		<xsl:variable name="grammar-pretty-name">Prosopograpy</xsl:variable>
		
		<d:book version="5.0">
			<d:title><xsl:value-of select="$grammar-pretty-name"/></d:title>
			
			<d:chapter>
				<d:title>
					<xsl:text>Introduction</xsl:text>
				</d:title>
			</d:chapter>
			
			<d:chapter>
				<d:title>
					<xsl:text>Elements</xsl:text>
				</d:title>
				
				<xsl:apply-templates select="rng:define"/>
			</d:chapter>
		</d:book>
	</xsl:template>
	
	<xsl:template match="rng:define">
		<xsl:variable name="elem-name">
			<xsl:value-of select="@name"/>
		</xsl:variable>

		<xsl:variable name="elem-documentation">
			<xsl:copy-of select="d:subtitle | d:para | d:example"/>
		</xsl:variable>

		<d:section>
			<d:title>
				<xsl:value-of select="$elem-name"/>
			</d:title>

			<xsl:if test="empty($elem-documentation/*)">
				<d:para>
					<xsl:text>No documentation available for element </xsl:text>
					<d:tag>
						<xsl:value-of select="$elem-name"/>
					</d:tag>
				</d:para>
			</xsl:if>

			<xsl:copy-of select="$elem-documentation"/>
		</d:section>
	</xsl:template>
</xsl:stylesheet>