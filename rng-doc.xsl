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

	<xsl:param name="base-dir">
		<xsl:value-of select="string-join(tokenize(base-uri(), '/')[position() != last()], '/')"/>
	</xsl:param>

	<xsl:variable name="schema-filename" select="tokenize(base-uri(), '/')[last()]"/>

	<xsl:variable name="schema-codename" select="replace($schema-filename, '\.rn(c|g)', '')"/>

	<xsl:param name="examples-path">
		<xsl:value-of select="concat($base-dir, '/examples?select=', $schema-codename, '-*.xml')"/>
	</xsl:param>

	<xsl:variable name="example-docs" select="collection($examples-path)"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="/rng:grammar">
		<d:book version="5.0">
			<xsl:call-template name="title"/>

			<d:chapter>
				<d:title>
					<xsl:text>Introduction</xsl:text>
				</d:title>

				<xsl:apply-templates select="rng:start"/>
			</d:chapter>
			
			<d:chapter>
				<d:title>
					<xsl:text>Elements</xsl:text>
				</d:title>
				
				<xsl:apply-templates select="rng:define"/>
			</d:chapter>
		</d:book>
	</xsl:template>

	<xsl:template match="rng:start">
		<xsl:call-template name="textual-documentation"/>
	</xsl:template>

	<xsl:template match="rng:define">
		<xsl:variable name="elem-name">
			<xsl:value-of select="@name"/>
		</xsl:variable>

		<d:section xml:id="{$elem-name}">
			<d:title>
				<xsl:value-of select="$elem-name"/>
			</d:title>

			<xsl:call-template name="textual-documentation"/>
			<xsl:call-template name="examples"/>
		</d:section>
	</xsl:template>

	<xsl:template name="title">
		<xsl:choose>
			<xsl:when test="//rng:start/d:title">
				<xsl:copy-of select="//rng:start/d:title"/>
				<xsl:copy-of select="//rng:start/d:subtitle"/>
			</xsl:when>
			<xsl:otherwise>
				<d:title>
					<xsl:value-of select="$schema-codename"/>
					<xsl:text>: schema documentation</xsl:text>
				</d:title>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="textual-documentation">
		<xsl:variable name="elem-name" select="@name"/>

		<xsl:variable name="elem-documentation">
			<xsl:copy-of select="d:subtitle | d:para | d:simplesect | d:indexterm"/>
		</xsl:variable>

		<xsl:if test="empty($elem-documentation/*)">
			<d:para>
				<xsl:text>No documentation available for element </xsl:text>
				<d:tag>
					<xsl:value-of select="$elem-name"/>
				</d:tag>
			</d:para>
		</xsl:if>

		<xsl:copy-of select="$elem-documentation"/>
	</xsl:template>

	<xsl:template name="examples">
		<xsl:variable name="embedded-examples" select="d:example"/>

		<xsl:variable name="external-examples">
			<xsl:call-template name="external-examples"/>
		</xsl:variable>

		<xsl:variable name="examples" select="$embedded-examples | $external-examples"/>

		<xsl:if test="$examples">
			<d:section>
				<d:title>
					<xsl:text>Examples</xsl:text>
				</d:title>

				<xsl:for-each select="$examples">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</d:section>
		</xsl:if>
	</xsl:template>

	<xsl:template name="external-examples">
		<xsl:variable name="elem-name" select="@name"/>

		<xsl:variable name="example-comments" select="$example-docs//comment()[./following-sibling::*[1][name() = $elem-name]]"/>

		<xsl:for-each select="$example-comments">
			<d:example>
				<d:title><xsl:value-of select="normalize-space(.)"/></d:title>
				<d:programlisting>
					<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
					<xsl:copy-of select="./following-sibling::*[1]"/>
					<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
				</d:programlisting>
			</d:example>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
