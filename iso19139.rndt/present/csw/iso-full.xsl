<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:ows="http://www.opengis.net/ows"

                xmlns:dc ="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"

                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"

                xmlns:geonet="http://www.fao.org/geonetwork"
				
				xmlns:gml="http://www.opengis.net/gml/3.2"
                
                xmlns:ITgmd="http://www.cnipa.gov.it/RNDT/ITgmd"
				
                exclude-result-prefixes="geonet dc dct ows srv ITgmd">


	<xsl:param name="displayInfo"/>


    <xsl:variable name="isSrv" select="boolean(//srv:*)"/>

    <xsl:variable name="isTile" select="boolean(//gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='tile')"/>

	<!-- ================================================================= -->

	<!-- Generic node -->

	<xsl:template match="/">
        <!--<xsl:message>============ ISTILE <xsl:value-of select="$isTile"/></xsl:message>-->

        <xsl:choose>
            <xsl:when test="$isTile">
                <!-- I tile hanno un envelope Request esterno -->
                <ITgmd:Request
                               xmlns:ITgmd="http://www.cnipa.gov.it/RNDT/ITgmd"
                               xmlns:gmd="http://www.isotc211.org/2005/gmd"
                               xmlns:gco="http://www.isotc211.org/2005/gco"
                               xmlns:gsr="http://www.isotc211.org/2005/gsr"
                               xmlns:gss="http://www.isotc211.org/2005/gss"
                               xmlns:gts="http://www.isotc211.org/2005/gts"
                               xmlns:gml="http://www.opengis.net/gml/3.2"
                               xmlns:xlink="http://www.w3.org/1999/xlink">
                    <ITgmd:Update_RNDT domain="nazionale">
                        <ITgmd:DS_Tile>
                            <ITgmd:tileMetadata>
                                <xsl:apply-templates select="node()" mode="tile"/>
                            </ITgmd:tileMetadata>
                        </ITgmd:DS_Tile>
                    </ITgmd:Update_RNDT>
                </ITgmd:Request>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


	<xsl:template match="@*|node()">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>

			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()" mode="tile">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="tile"/>

			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>

		</xsl:copy>
	</xsl:template>


	<!-- ================================================================= -->

	<!-- Metadata root elem for non-tile metadata: set sane namespaces -->

	<xsl:template match="gmd:MD_Metadata">
		<xsl:element name="gmd:MD_Metadata">
			<xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
			<xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
			<xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
            <xsl:if test="$isSrv">
                <xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv'"/>
            </xsl:if>
			<xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
			<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
			<xsl:copy-of select="@*[name()!='xsi:schemaLocation' and name()!='gco:isoType']"/>

            <xsl:choose>
                <xsl:when test="$isSrv">
                    <xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmd http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmd http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>

			<xsl:apply-templates select="gmd:fileIdentifier"/>
			<xsl:apply-templates select="gmd:language"/>
			<xsl:apply-templates select="gmd:characterSet"/>
			<gmd:parentIdentifier>
				<gco:CharacterString>
					<xsl:choose>
						<xsl:when test="//gmd:MD_Metadata/gmd:parentIdentifier/gco:CharacterString != '' ">
							<xsl:value-of select="//gmd:MD_Metadata/gmd:parentIdentifier/gco:CharacterString"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./gmd:fileIdentifier/gco:CharacterString"/>
						</xsl:otherwise>	
					</xsl:choose>
				</gco:CharacterString>
			</gmd:parentIdentifier>
			<xsl:apply-templates select="child::* except (gmd:fileIdentifier|gmd:parentIdentifier|gmd:language|gmd:characterSet)"/>
			<!-- <xsl:apply-templates select="//*[not(self::gmd:fileIdentifier)|not(self::gmd:language)|not(self::gmd:characterSet)]"/> -->
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->

	<!-- Remove comments -->

	<xsl:template match="comment()" priority="100"/>

	<!-- Remove geonet's own stuff -->

	<xsl:template match="geonet:info" priority="100"/>

	<!-- ================================================================= -->
	<!-- Remap gml URI from /gml to /gml/3.2 -->
     
    <xsl:template match="@*[namespace-uri()='http://www.opengis.net/gml']">
        <xsl:attribute name="gml:{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
     
    <xsl:template match="*[namespace-uri()='http://www.opengis.net/gml']">
        <xsl:element name="gml:{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

	<!-- ================================================================= -->

	<!-- Replace RNDT metadata standard name/version -->

	<xsl:template match="gmd:metadataStandardName">
        <xsl:choose>
            <xsl:when test="$isTile">
                <ITgmd:metadataStandardName>
                    <gco:CharacterString>DM - Regole tecniche RNDT</gco:CharacterString>
                </ITgmd:metadataStandardName>
            </xsl:when>
            <xsl:otherwise>
                <gmd:metadataStandardName>
                    <gco:CharacterString>DM - Regole tecniche RNDT</gco:CharacterString>
                </gmd:metadataStandardName>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template match="gmd:metadataStandardVersion">
        <xsl:choose>
            <xsl:when test="$isTile">
                <ITgmd:metadataStandardVersion>
                    <gco:CharacterString>10 novembre 2011</gco:CharacterString>
                </ITgmd:metadataStandardVersion>
            </xsl:when>
            <xsl:otherwise>
                <gmd:metadataStandardVersion>
                    <gco:CharacterString>10 novembre 2011</gco:CharacterString>
                </gmd:metadataStandardVersion>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="*[@gco:isoType]" priority="100">
		<xsl:variable name="elemName" select="@gco:isoType"/>

		<xsl:element name="{$elemName}">
			<xsl:apply-templates select="@*[name()!='gco:isoType']"/>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- Manage the gmd:pass -->
	
<!--	<xsl:template match="gmd:DQ_ConformanceResult">
		<xsl:choose>
			<xsl:when test="not(exists(gmd:pass))">
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
					<xsl:element name="gmd:pass">
						<xsl:text></xsl:text>
						<xsl:attribute name="nilReason">unknown</xsl:attribute>
					</xsl:element>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="pass">
					<xsl:value-of select="gmd:pass"/>
				</xsl:variable>
				<xsl:if test="$pass = ''">
					<xsl:copy>
						<xsl:apply-templates select="@*|gmd:specification"/>
						<xsl:apply-templates select="@*|gmd:explanation"/>
						<xsl:element name="gmd:pass">
							<xsl:text></xsl:text>
							<xsl:attribute name="nilReason">unknown</xsl:attribute>
						</xsl:element>
					</xsl:copy>				    	
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	
	<!-- Use 'nilReason' to unknown for the pass element in un-compiled conformance	
	<xsl:template match="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass">
		<xsl:choose>
			<xsl:when test="../gmd:explanation/gco:CharacterString='non valutato'">
				<xsl:copy>
					<xsl:attribute name="nilReason">unknown</xsl:attribute>
				</xsl:copy>
				<xsl:comment>Conformance non compilata</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->
	
	<!-- ================================================================= -->
	
	<!-- Remove empty keywords
         1) remove parent <gmd:descriptiveKeywords> if all <gmd:MD_Keywords> are empty
         2) remove <gmd:keyword> if empty
    -->
	<!--
        <gmd:identificationInfo> 
            <srv:SV_ServiceIdentification | gmd:MD_DataIdentification >
                <gmd:descriptiveKeywords>   0..n, insieme di keywords da un determinato thesaurus
                    <gmd:MD_Keywords>       1..1
                        <gmd:keyword>
                            <gco:CharacterString/>
                        </gmd:keyword>
                    </gmd:MD_Keywords>
                </gmd:descriptiveKeywords>
    -->
	
	<!-- Remove empty keywords 1) remove parent <gmd:descriptiveKeywords> if all <gmd:MD_Keywords> are empty -->

	<xsl:template match="gmd:identificationInfo/*/gmd:descriptiveKeywords">
		<xsl:variable name="concatkw">
			<xsl:call-template name="extract_keywords_text"/>
		</xsl:variable>

		<!--<xsl:comment>lista keyword: [<xsl:copy-of select="$concatkw" />]</xsl:comment>-->

		<xsl:choose>
			<xsl:when test="not(string($concatkw))">
				<xsl:comment>descriptiveKeywords vuota</xsl:comment>
			</xsl:when>
            <xsl:when test="$isTile">
                <ITgmd:descriptiveKeywords>
					<xsl:apply-templates select="@*|node()"/>
                </ITgmd:descriptiveKeywords>
            </xsl:when>
			<xsl:otherwise>
                <xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Remove empty keywords 2) remove <gmd:keyword> if empty -->

	<xsl:template match="gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword">
		<xsl:choose>
			<xsl:when test="not(string(gco:CharacterString))">
				<xsl:comment>Keyword vuota</xsl:comment>
			</xsl:when>
<!--            <xsl:when test="$isTile">
                <ITgmd:keyword>
					<xsl:apply-templates select="@*|node()"/>
                </ITgmd:keyword>
            </xsl:when>-->
			<xsl:otherwise>
                <xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="extract_keywords_text">
		<xsl:for-each select="gmd:MD_Keywords/gmd:keyword"><xsl:copy-of select="gco:CharacterString" /></xsl:for-each>
	</xsl:template>
	
	<!-- ================================================================= -->
	<!-- ================================================================= -->
    <!-- Templates per i tile                                              -->
	<!-- ================================================================= -->
	<!-- ================================================================= -->

	<!-- Metadata root elem for tile related metadata -->

	<xsl:template match="gmd:MD_Metadata" mode="tile">
		<xsl:element name="ITgmd:MD_Metadata">
			<xsl:apply-templates select="gmd:fileIdentifier"/>
			<xsl:apply-templates select="gmd:language"/>
			<xsl:apply-templates select="gmd:characterSet"/>
			<ITgmd:parentIdentifier>
				<gco:CharacterString>
					<xsl:choose>
						<xsl:when test="//gmd:MD_Metadata/gmd:parentIdentifier/gco:CharacterString != '' ">
							<xsl:value-of select="//gmd:MD_Metadata/gmd:parentIdentifier/gco:CharacterString"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./gmd:fileIdentifier/gco:CharacterString"/>
						</xsl:otherwise>
					</xsl:choose>
				</gco:CharacterString>
			</ITgmd:parentIdentifier>
			<xsl:apply-templates select="child::* except (gmd:fileIdentifier|gmd:parentIdentifier|gmd:language|gmd:characterSet)"/>
			<!-- <xsl:apply-templates select="//*[not(self::gmd:fileIdentifier)|not(self::gmd:language)|not(self::gmd:characterSet)]"/> -->
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->
    <!-- remap generic gmd elements in tile metadata -->

    <xsl:template match="@*[namespace-uri()='http://www.isotc211.org/2005/gmd']">
        <xsl:choose>
            <xsl:when test="$isTile">
                <xsl:attribute name="ITgmd:{local-name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[namespace-uri()='http://www.isotc211.org/2005/gmd' and name()!= 'gmd:MD_Metadata'] ">
        <xsl:choose>
            <xsl:when test="$isTile">
                <xsl:element name="ITgmd:{local-name()}">
                    <xsl:apply-templates select="node()|@*"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="node()|@*"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- These elements do not need namespace conversion -->
    <xsl:template match="gmd:LanguageCode|gmd:MD_CharacterSetCode|gmd:MD_ScopeCode|gmd:MD_Format|gmd:name|gmd:version|
                         gmd:CI_OnlineResource|gmd:CI_Date|gmd:CI_DateTypeCode|gmd:CI_PresentationFormCode|gmd:CI_RoleCode|
                         gmd:linkage|gmd:URL|gmd:RS_Identifier|gmd:code|
                         gmd:dateType|gmd:MD_SpatialRepresentationTypeCode|
                         gmd:MD_Resolution|gmd:MD_Resolution//gmd:*|
                         gmd:descriptiveKeywords//gmd:*|
                         gmd:CI_Date//gmd:*|
                         gmd:DQ_DomainConsistency|gmd:DQ_DomainConsistency//gmd:*|
                         gmd:geographicElement//gmd:*|
                         gmd:DQ_Scope|gmd:level|
                         gmd:DQ_AbsoluteExternalPositionalAccuracy|gmd:DQ_AbsoluteExternalPositionalAccuracy//gmd:*"
                  priority="10">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>


	<!-- ================================================================= -->

	<xsl:template match="*[@gco:isoType]" priority="100">
		<xsl:variable name="elemName" select="@gco:isoType"/>

		<xsl:element name="{$elemName}">
			<xsl:apply-templates select="@*[name()!='gco:isoType']"/>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>


	<!-- ================================================================= -->

</xsl:stylesheet>
