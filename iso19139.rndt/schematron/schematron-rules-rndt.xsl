<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="#all"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
   <xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc"
                 select="document(concat('../loc/', $lang, '/', substring-before($rule, '.xsl'), '.xml'))"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="Schematron validation for ISO&#xA;&#x9;&#x9;19115(19139) RNDT Profile"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/srv" prefix="srv"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gco" prefix="gco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M1"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M2"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M3"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M4"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M5"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M6"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M7"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M8"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M9"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M13"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M14"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M15"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M30"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M31"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M32"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M33"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M34"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M35"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M36"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M37"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M38"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M39"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M45"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M46"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M50"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M51"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M52"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M53"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M60"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M61"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M62"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M63"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M64"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M65"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M66"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M99"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M100"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/M110"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron validation for ISO
		19115(19139) RNDT Profile</svrl:text>

   <!--PATTERN $loc/strings/M1-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M1"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:fileIdentifier/gco:CharacterString"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:fileIdentifier/gco:CharacterString">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M1"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M2-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M2"/>
   </svrl:text>
   <xsl:variable name="langCodeList">bul;cze;dan;est;fin;fre;gre;eng;gle;ita;lav;lit;mlt;dut;pol;por;rum;slo;slv;spa;swe;ger;hun</xsl:variable>
   <xsl:variable name="langCodeURI">http://www.loc.gov/standards/iso639-2/</xsl:variable>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
      <xsl:variable name="value" select="gmd:language/gmd:LanguageCode/@codeListValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="exists(tokenize($langCodeList, ';')[. = $value]) and gmd:language/gmd:LanguageCode!=''     and gmd:language/gmd:LanguageCode/@codeList= $langCodeURI"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="exists(tokenize($langCodeList, ';')[. = $value]) and gmd:language/gmd:LanguageCode!='' and gmd:language/gmd:LanguageCode/@codeList= $langCodeURI">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M2"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M3-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M3"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:parentIdentifier/gco:CharacterString"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:parentIdentifier/gco:CharacterString">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M3"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M4-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M4"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue and gmd:hierarchyLevel/gmd:MD_ScopeCode!=''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue and gmd:hierarchyLevel/gmd:MD_ScopeCode!=''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M4"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M5-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M5"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:metadataStandardName/gco:CharacterString and     gmd:metadataStandardName/gco:CharacterString = 'DM - Regole tecniche RNDT'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:metadataStandardName/gco:CharacterString and gmd:metadataStandardName/gco:CharacterString = 'DM - Regole tecniche RNDT'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M5"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M6-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M6"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:metadataStandardVersion/gco:CharacterString     and gmd:metadataStandardVersion/gco:CharacterString= '10 novembre 2011'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:metadataStandardVersion/gco:CharacterString and gmd:metadataStandardVersion/gco:CharacterString= '10 novembre 2011'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M6"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M7-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M7"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue     and gmd:characterSet/gmd:MD_CharacterSetCode!=''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue and gmd:characterSet/gmd:MD_CharacterSetCode!=''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M7"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M8-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M8"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue     and gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode!=''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue and gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode!=''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M8"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M9-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M9"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation"/>
      <xsl:variable name="responsibleParty"
                    select="(gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString)     and (gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue!='pointOfContact')     and (gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue!='distributor')     and (gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString) and ((gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString) or (gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$responsibleParty"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$responsibleParty">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M9"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M13-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M13"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:identifier/gmd:RS_Identifier/gmd:code/gco:CharacterString"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:identifier/gmd:RS_Identifier/gmd:code/gco:CharacterString">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M13"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M14-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M14"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:series/gmd:CI_Series/gmd:issueIdentification/gco:CharacterString"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:series/gmd:CI_Series/gmd:issueIdentification/gco:CharacterString">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M14"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M15-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M15"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation"/>
      <xsl:variable name="responsibleParty"
                    select="(gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString)     and (gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='pointOfContact')     and (gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString) and ((gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString) or (gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$responsibleParty"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$responsibleParty">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M15"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M30-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M30"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation"
                 priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:presentationForm/gmd:CI_PresentationFormCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:presentationForm/gmd:CI_PresentationFormCode">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M30"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M31-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M31"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification"
                 priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M31"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M32-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M32"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer    and gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer!='')    or (gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance    and gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance!='')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer and gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer!='') or (gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance and gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance!='')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M32"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M33-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M33"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"
                 priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification   |//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M33"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M34-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M34"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue     and gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode!=''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue and gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode!=''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M34"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M35-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M35"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality"
                 priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service'    or count(gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult[gmd:valueUnit/gml:BaseUnit/gml:identifier/@codeSpace    and gmd:valueUnit/gml:BaseUnit/gml:unitsSystem/@xlink:href and  gmd:value/gco:Record/gco:Real])&gt;0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service' or count(gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult[gmd:valueUnit/gml:BaseUnit/gml:identifier/@codeSpace and gmd:valueUnit/gml:BaseUnit/gml:unitsSystem/@xlink:href and gmd:value/gco:Record/gco:Real])&gt;0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M35"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M36-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M36"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service'    or gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString!=''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service' or gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString!=''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M36"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M37-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M37"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality"/>
      <xsl:variable name="specTitle">REGOLAMENTO (UE) N. 1089/2010 DELLA COMMISSIONE del 23 novembre 2010 recante attuazione della direttiva 2007/2/CE del Parlamento europeo e del Consiglio per quanto riguarda l'interoperabilità dei set di dati territoriali e dei servizi di dati territoriali</xsl:variable>
      <xsl:variable name="specTitleService">Service Abstract Test Suite</xsl:variable>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service'    or gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString= $specTitle    and gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date= '2010-12-08'    and gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='service' or gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString= $specTitle and gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date= '2010-12-08' and gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M37"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue!='service'    or gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString= $specTitleService    and gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date= '2007-11-21'    and gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue!='service' or gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString= $specTitleService and gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date= '2007-11-21' and gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M37"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M38-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M38"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='service' or gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString or (gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString and /gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString= 'http://www.epsg-registry.org')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='service' or gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString or (gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString and /gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString= 'http://www.epsg-registry.org')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M38"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M39-->
<xsl:variable name="inspireKeyWords">Condizioni atmosferiche;Atmospheric conditions;Copertura del suolo;Land cover;Distribuzione della popolazione - demografia;Population distribution — demography;Distribuzione delle specie;Species distribution;Edifici;Buildings;Elementi geografici meteorologici;Meteorological geographical features;Elementi geografici oceanografici;Oceanographic geographical features;Elevazione;Elevation;Geologia;Geology;Habitat e biotopi;Habitats and biotopes;Idrografia;Hydrography;Impianti agricoli e di acquacoltura;Agricultural and aquaculture facilities;Impianti di monitoraggio ambientale;Environmental monitoring facilities;Indirizzi;Addresses;Nomi geografici;Geographical names;Orto immagini;Orthoimagery;Parcelle catastali;Cadastral parcels;Produzione e impianti industriali;Production and industrial facilities;Regioni biogeografiche;Bio-geographical regions;Regioni marine;Sea regions;Reti di trasporto;Transport networks;Risorse energetiche;Energy resources;Risorse minerarie;Mineral resources;Salute umana e sicurezza;Human health and safety;Servizi di pubblica utilità e servizi amministrativi;Utility and governmental services</xsl:variable>
   <xsl:variable name="gemetThesaurusTitle">GEMET - INSPIRE themes, version 1.0</xsl:variable>
   <xsl:variable name="gemetThesaurusDate">2008-06-01</xsl:variable>
   <xsl:variable name="gemetThesaurusDateType">publication</xsl:variable>
   <xsl:variable name="inspireServicesKeyWords">humanInteractionService;humanCatalogueViewer;humanGeographicViewer;humanGeographicSpreadsheetViewer;humanServiceEditor;humanChainDefinitionEditor;humanWorkflowEnactmentManager;humanGeographicFeatureEditor;humanGeographicSymbolEditor;humanFeatureGeneralizationEditor;humanGeographicDataStructureViewer;infoManagementService;infoFeatureAccessService;infoMapAccessService;infoCoverageAccessService;infoSensorDescriptionService;infoProductAccessService;infoFeatureTypeService;infoCatalogueService;infoRegistryService;infoGazetteerService;infoOrderHandlingService;infoStandingOrderService;taskManagementService;chainDefinitionService;workflowEnactmentService;subscriptionService;spatialProcessingService;spatialCoordinateConversionService;spatialCoordinateTransformationService;spatialCoverageVectorConversionService;spatialImageCoordinateConversionService;spatialRectificationService;spatialOrthorectificationService;spatialSensorGeometryModelAdjustmentService;spatialImageGeometryModelConversionService;spatialSubsettingService;spatialSamplingService;spatialTilingChangeService;spatialDimensionMeasurementService;spatialFeatureManipulationService;spatialFeatureMatchingService;spatialFeatureGeneralizationService;spatialRouteDeterminationService;spatialPositioningService;spatialProximityAnalysisService;thematicProcessingService;thematicGeoparameterCalculationService;thematicClassificationService;thematicFeatureGeneralizationService;thematicSubsettingService;thematicSpatialCountingService;thematicChangeDetectionService;thematicGeographicInformationExtractionService;thematicImageProcessingService;thematicReducedResolutionGenerationService;thematicImageManipulationService;thematicImageUnderstandingService;thematicImageSynthesisService;thematicMultibandImageManipulationService;thematicObjectDetectionService;thematicGeoparsingService;thematicGeocodingService;temporalProcessingService;temporalReferenceSystemTransformationService;temporalSubsettingService;temporalSamplingService;temporalProximityAnalysisService;metadataProcessingService;metadataStatisticalCalculationService;metadataGeographicAnnotationService;comService;comEncodingService;comTransferService;comGeographicCompressionService;comMessagingService;comRemoteFileAndExecutableManagement</xsl:variable>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M39"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification"
                 priority="1001"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:descriptiveKeywords[contains($inspireKeyWords, gmd:MD_Keywords/gmd:keyword/gco:CharacterString)    and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString = $gemetThesaurusTitle    and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date = $gemetThesaurusDate    and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = $gemetThesaurusDateType]) &gt;0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:descriptiveKeywords[contains($inspireKeyWords, gmd:MD_Keywords/gmd:keyword/gco:CharacterString) and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString = $gemetThesaurusTitle and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date = $gemetThesaurusDate and gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = $gemetThesaurusDateType]) &gt;0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M39"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:descriptiveKeywords[contains($inspireServicesKeyWords, gmd:MD_Keywords/gmd:keyword/gco:CharacterString)]) &gt;0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:descriptiveKeywords[contains($inspireServicesKeyWords, gmd:MD_Keywords/gmd:keyword/gco:CharacterString)]) &gt;0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M39"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M45-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M45"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue!='service']"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue!='service']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString    and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString!='')    and (gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:version/gco:CharacterString    and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:version/gco:CharacterString!='')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString!='') and (gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:version/gco:CharacterString and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:version/gco:CharacterString!='')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M45"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M46-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M46"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue!='service']"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue!='service']"/>
      <xsl:variable name="name"
                    select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString    and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString!=''"/>
      <xsl:variable name="mail"
                    select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString    and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString!=''"/>
      <xsl:variable name="url"
                    select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL    and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString!=''"/>
      <xsl:variable name="phone"
                    select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString    and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact//gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString!=''"/>
      <xsl:variable name="role"
                    select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue    and gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='distributor'"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$name and $role and $mail and ($url or $phone)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$name and $role and $mail and ($url or $phone)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M46"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M50-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M50"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:resourceConstraints[gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString])&gt;0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:resourceConstraints[gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString])&gt;0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M50"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M51-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M51"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue])&gt;0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue])&gt;0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M51"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M52-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M52"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue])&gt;0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue])&gt;0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M52"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M53-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M53"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification|//gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString    and gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue!='otherRestrictions'    and gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue!='otherRestrictions']) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString and gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue!='otherRestrictions' and gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue!='otherRestrictions']) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M53"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M60-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M60"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"
                 priority="1000"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:contentInfo/gmd:MD_ImageDescription/gmd:contentType/gmd:MD_CoverageContentTypeCode/@codeListValue"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:contentInfo/gmd:MD_ImageDescription/gmd:contentType/gmd:MD_CoverageContentTypeCode/@codeListValue">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M60"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M61-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M61"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription/gco:RecordType"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription/gco:RecordType">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M61"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M62-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M62"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"
                 priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions/gco:Integer    or gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions/gco:Integer"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions/gco:Integer or gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions/gco:Integer">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M62"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M63-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M63"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionName/gmd:MD_DimensionNameTypeCode/@codeListValue    and gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer    and gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer!='')    or (gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionName/gmd:MD_DimensionNameTypeCode/@codeListValue    and gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer    and gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer!='')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionName/gmd:MD_DimensionNameTypeCode/@codeListValue and gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer and gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer!='') or (gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionName/gmd:MD_DimensionNameTypeCode/@codeListValue and gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer and gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:dimensionSize/gco:Integer!='')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M63"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M64-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M64"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cellGeometry/gmd:MD_CellGeometryCode/@codeListValue    or gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:cellGeometry/gmd:MD_CellGeometryCode/@codeListValue"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cellGeometry/gmd:MD_CellGeometryCode/@codeListValue or gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:cellGeometry/gmd:MD_CellGeometryCode/@codeListValue">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M64"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M65-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M65"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"
                 priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:transformationParameterAvailability/gco:Boolean    or gmd:spatialRepresentationInfo//gmd:MD_Georeferenceable/gmd:transformationParameterAvailability/gco:Boolean"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:transformationParameterAvailability/gco:Boolean or gmd:spatialRepresentationInfo//gmd:MD_Georeferenceable/gmd:transformationParameterAvailability/gco:Boolean">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M65"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M66-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M66"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid'   and gmd:spatialRepresentationInfo/gmd:MD_Georectified]"
                 priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue='grid'   and gmd:spatialRepresentationInfo/gmd:MD_Georectified]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointAvailability/gco:Boolean"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointAvailability/gco:Boolean">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M66"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M99-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M99"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata/gmd:dateStamp" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata/gmd:dateStamp"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gco:Date"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gco:Date">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M99"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M100-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M100"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="gmd:CI_Date" priority="1000" mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="gmd:CI_Date"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:date/gco:Date"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:date/gco:Date">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M100"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>

   <!--PATTERN $loc/strings/M110-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/M110"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="/gmd:MD_Metadata" priority="1000" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/gmd:MD_Metadata"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(//*[@gco:nilReason])=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(//*[@gco:nilReason])=0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.M110"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
</xsl:stylesheet>