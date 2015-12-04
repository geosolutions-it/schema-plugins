<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" 
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco" 
                xmlns:gmx="http://www.isotc211.org/2005/gmx" 
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gml="http://www.opengis.net/gml" 
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork" 
                xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet">

    <xsl:import href="metadata-fop.xsl"/>
    <xsl:include href="metadata-rndt.xsl"/>
    <xsl:include href="metadata-view.xsl"/>  
    <xsl:include href="metadata-ovr.xsl"/>
	
    <xsl:template name="iso19139.rndtCompleteTab">
        <xsl:param name="tabLink"/>
        <xsl:param name="schema"/>
  	
        <!-- RNDT tab -->
        <xsl:call-template name="displayTab">
            <xsl:with-param name="tab"     select="'rndt'"/>
            <xsl:with-param name="text"    select="/root/gui/schemas/iso19139.rndt/strings/rndtTab"/>
            <xsl:with-param name="tabLink" select="$tabLink"/>
        </xsl:call-template>  	
  	
        <xsl:call-template name="iso19139.rndtTab">
            <xsl:with-param name="tabLink" select="$tabLink"/>
            <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
    </xsl:template>

    <!-- ===================================================================== -->
    <!-- Overrides iso19139/metadata template at #1304                         -->
    <!-- Forces format to date only (no time)                                  -->
    <!-- gml:TimePeriod (format = %Y-%m-%d)                                    -->
    <!-- ===================================================================== -->

    <xsl:template mode="iso19139" match="gml:*[gml:beginPosition|gml:endPosition]|gml:TimeInstant[gml:timePosition]" priority="3">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        <xsl:for-each select="*">
            <xsl:choose>
                <xsl:when test="$edit=true() and (name(.)='gml:beginPosition' or name(.)='gml:endPosition' or name(.)='gml:timePosition')">
                    <xsl:apply-templates mode="simpleElement" select=".">
                        <xsl:with-param name="schema"  select="$schema"/>
                        <xsl:with-param name="edit"   select="$edit"/>
                        <xsl:with-param name="editAttributes" select="$currTab!='rndt' and $currTab!='simple' "/>
                        <xsl:with-param name="text">
                            <xsl:variable name="ref" select="geonet:element/@ref"/>
                            <xsl:variable name="format" select="'%Y-%m-%d'"/>

                            <xsl:call-template name="calendar">
                                <xsl:with-param name="ref" select="$ref"/>
                                <xsl:with-param name="date" select="text()"/>
                                <xsl:with-param name="format" select="$format"/>
                            </xsl:call-template>

                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="name(.)='gml:timeInterval'">
                    <xsl:apply-templates mode="iso19139" select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="simpleElement" select=".">
                        <xsl:with-param name="schema"  select="$schema"/>
                        <xsl:with-param name="text">
                            <xsl:value-of select="text()"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
	
    <!-- ===================================================================== -->
    <!-- descriptiveKeywords                                                   -->
    <!-- ===================================================================== -->
    <!-- ===================================================================== -->
    <!-- Overrides iso19139/metadata template at #1056                         -->
    <!-- Uses a complex element also in presentation mode in order to          -->
    <!-- show the thesaurus part of a metadata keyword.                        -->
    <!-- ===================================================================== -->
    <xsl:template mode="iso19139" match="gmd:descriptiveKeywords" priority="2">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
		
        <xsl:choose>
            <xsl:when test="$edit=true()">
				
                <xsl:variable name="content">
                    <xsl:for-each select="gmd:MD_Keywords">
                        <tr>
                            <td class="padded-content" width="100%" colspan="2">
                                <table width="100%">
                                    <tr>
                                        <td width="50%" valign="top">
                                            <table width="100%">
                                                <xsl:apply-templates mode="elementEP" select="gmd:keyword|geonet:child[string(@name)='keyword']">
                                                    <xsl:with-param name="schema" select="$schema"/>
                                                    <xsl:with-param name="edit"   select="$edit"/>
                                                </xsl:apply-templates>
                                                <xsl:apply-templates mode="elementEP" select="gmd:type|geonet:child[string(@name)='type']">
                                                    <xsl:with-param name="schema" select="$schema"/>
                                                    <xsl:with-param name="edit"   select="$edit"/>
                                                </xsl:apply-templates>
                                            </table>
                                        </td>
                                        <td valign="top">
                                            <table width="100%">
                                                <xsl:apply-templates mode="elementEP" select="gmd:thesaurusName|geonet:child[string(@name)='thesaurusName']">
                                                    <xsl:with-param name="schema" select="$schema"/>
                                                    <xsl:with-param name="edit"   select="$edit"/>
                                                </xsl:apply-templates>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:variable>
				
                <xsl:apply-templates mode="complexElement" select=".">
                    <xsl:with-param name="schema"  select="$schema"/>
                    <xsl:with-param name="edit"    select="$edit"/>
                    <xsl:with-param name="content" select="$content"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- We use a complexElement here in order to show the thesaurus part -->
                <xsl:apply-templates mode="complexElement" select=".">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="text">
                        <xsl:variable name="value">
                            <xsl:for-each select="gmd:MD_Keywords/gmd:keyword">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="gmx:Anchor">
                                        <a href="{gmx:Anchor/@xlink:href}">
                                            <xsl:value-of select="if (gmx:Anchor/text()) then gmx:Anchor/text() else gmx:Anchor/@xlink:href"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>
										
                                        <xsl:call-template name="translatedString">
                                            <xsl:with-param name="schema" select="$schema"/>
                                            <xsl:with-param name="langId">
                                                <xsl:call-template name="getLangId">
                                                    <xsl:with-param name="langGui" select="/root/gui/language"/>
                                                    <xsl:with-param name="md" select="ancestor-or-self::*[name(.)='gmd:MD_Metadata' or @gco:isoType='gmd:MD_Metadata']" />
                                                </xsl:call-template>
                                            </xsl:with-param>
                                        </xsl:call-template>
										
                                    </xsl:otherwise>
                                </xsl:choose>
								
                            </xsl:for-each>
                            <xsl:if test="gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode/@codeListValue!=''">
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode/@codeListValue"/>
                                <xsl:text>)</xsl:text>
                            </xsl:if>
                            <xsl:text>.</xsl:text>
                        </xsl:variable>
                        <table width="100%">
                            <tr>
                                <td colspan="2">
                                    <xsl:copy-of select="$value"/>
                                </td>
                            </tr>
                            <xsl:variable name="thesaurusTitle" select="gmd:MD_Keywords/gmd:thesaurusName/*/gmd:title/*[1]"/>
                            <xsl:for-each select="gmd:MD_Keywords/gmd:thesaurusName/*/gmd:identifier/*/gmd:code/gmx:Anchor[starts-with(string(),'geonetwork.thesaurus')]">
                                <tr>
                                    <td width="20%">
                                        <xsl:value-of select="/root/gui/strings/thesaurus/thesaurus"/>
                                    </td>
                                    <td>
                                        <a href="{@xlink:href}">
                                            <xsl:choose>
                                                <xsl:when test="normalize-space($thesaurusTitle)!=''">
                                                    <xsl:value-of select="$thesaurusTitle"/>
                                                </xsl:when>
                                                <xsl:when test="normalize-space()!=''">
                                                    <xsl:value-of select="text()"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@src"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </a>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="iso19139.rndtTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>

		<!-- INSPIRE tab -->
		<xsl:if test="/root/gui/env/inspire/enable = 'true' and /root/gui/env/metadata/enableInspireView = 'true'">
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'inspire'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/inspireTab"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>
        </xsl:if>

		<xsl:if test="/root/gui/env/metadata/enableIsoView = 'true'">
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'groups'"/> <!-- just a non-existing tab -->
				<xsl:with-param name="text"    select="/root/gui/strings/byGroup"/>
				<xsl:with-param name="tabLink" select="''"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'ISOMinimum'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/isoMinimum"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'ISOCore'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/isoCore"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'ISOAll'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/isoAll"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="/root/gui/config/metadata-tab/advanced">
			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'packages'"/> <!-- just a non-existing tab -->
				<xsl:with-param name="text"    select="/root/gui/strings/byPackage"/>
				<xsl:with-param name="tabLink" select="''"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'metadata'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/metadata"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'identification'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/identificationTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'maintenance'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/maintenanceTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'constraints'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/constraintsTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'spatial'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/spatialTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'refSys'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/refSysTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'distribution'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/distributionTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'dataQuality'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/dataQualityTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'appSchInfo'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/appSchInfoTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'porCatInfo'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/porCatInfoTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

			<xsl:call-template name="displayTab">
				<xsl:with-param name="tab"     select="'contentInfo'"/>
				<xsl:with-param name="text"    select="/root/gui/strings/contentInfoTab"/>
				<xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
				<xsl:with-param name="tabLink" select="$tabLink"/>
			</xsl:call-template>

		</xsl:if>		
	</xsl:template>
	
	<!-- ============================================================================= -->
	<!-- Online Resource: protocol custom visualization                                -->
	<!-- ============================================================================= -->

	<xsl:template mode="iso19139" match="gmd:protocol" priority="10000">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:call-template name="simpleElementGui">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
					<xsl:with-param name="title">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name"   select="name(.)"/>
							<xsl:with-param name="schema" select="$schema"/>
						</xsl:call-template>
					</xsl:with-param>

					<xsl:with-param name="helpLink">
		                <xsl:call-template name="getHelpLink">
		                    <xsl:with-param name="name" select="name(.)"/>
		                    <xsl:with-param name="schema" select="$schema"/>
		                </xsl:call-template>
		            </xsl:with-param>
					<xsl:with-param name="text">
						<xsl:variable name="value" select="string(gco:CharacterString)"/>
						<xsl:variable name="ref" select="gco:CharacterString/geonet:element/@ref"/>
						<xsl:variable name="fref" select="../gmd:name/gco:CharacterString/geonet:element/@ref|../gmd:name/gmx:MimeFileType/geonet:element/@ref"/>
						<xsl:variable name="relatedJsAction">
			            	<xsl:value-of select="concat('checkForFileUpload(&quot;',$fref,'&quot;, &quot;',$ref,'&quot;, this.options[this.selectedIndex].value);')" />
			      		</xsl:variable>
			            
			            <input type="hidden" id="_{$ref}" name="_{$ref}" value="{$value}"/>
			            <input type="hidden" id="previous_{$ref}" name="previous_{$ref}" value="{$value}"/>
			            <xsl:for-each select="gco:CharacterString">
			             <xsl:call-template name="helperProtocol">
			               <xsl:with-param name="schema" select="$schema"/>
			               <xsl:with-param name="attribute" select="false()"/>
			               <xsl:with-param name="jsAction" select="$relatedJsAction"/>
			               <xsl:with-param name="selectedValue" select="$value"/>
			             </xsl:call-template>
			           </xsl:for-each>
			          </xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="element" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="false()"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
		<!-- Create an helper list for the current input element.
		Current input could be an element or an attribute (eg. uom). 
	
	In editing mode, for gco:CharacterString elements (with no codelist 
	or enumeration defined in the schema) an helper list could be defined 
	in loc files using the helper tag. Then a list of values
	is displayed next to the input field. 
	-->
	<xsl:template name="helperProtocol">
		<xsl:param name="schema"/>
		<xsl:param name="attribute"/>
		<xsl:param name="jsAction"/>
		<xsl:param name="selectedValue"/>
		
		<!-- Define the element to look for. -->
		<xsl:variable name="parentName">
			<xsl:choose>
				<!-- In dublin core element contains value.
					In ISO, attribute also but element contains characterString which contains the value -->
				<xsl:when test="$attribute=true() or $schema = 'dublin-core'">
					<xsl:value-of select="name(.)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="name(parent::node())"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Look for the helper -->
		<xsl:variable name="helper">
			<xsl:choose>
			  <xsl:when test="starts-with($schema,'iso19139') and not(/root/gui/schemas/*[name(.)=$schema]/labels/element[@name = $parentName]/helper)">
					<!-- Fallback to iso19139 helper for ISO profil if not exist ... -->
					<xsl:copy-of select="/root/gui/schemas/iso19139/labels/element[@name = $parentName]/helper"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="/root/gui/schemas/*[name(.)=$schema]/labels/element[@name = $parentName]/helper"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Display the helper list -->
		<xsl:if test="normalize-space($helper)!=''">
		  <xsl:variable name="list" select="exslt:node-set($helper)"/>
		  <xsl:variable name="refId" select="if ($attribute=true()) then concat(../geonet:element/@ref, '_', name(.)) else geonet:element/@ref"/>
		  <xsl:variable name="relatedElementName" select="$list/*/@rel"/>
		  <xsl:variable name="relatedElementAction">
		    <xsl:if test="$relatedElementName!=''">
		      <xsl:variable name="relatedElement" select="../following-sibling::node()[name()=$relatedElementName]/gco:CharacterString"/>
		      <xsl:variable name="relatedElementRef" select="../following-sibling::node()[name()=$relatedElementName]/gco:CharacterString/geonet:element/@ref"/>
		      <xsl:variable name="relatedElementIsEmpty" select="normalize-space($relatedElement)=''"/>
		      
		      <xsl:value-of select="concat('if ($(&quot;_', $relatedElementRef, '&quot;)) $(&quot;_', $relatedElementRef, '&quot;).value=this.options[this.selectedIndex].title;')"/>
		       
		    </xsl:if>
		  </xsl:variable>
			<xsl:text> </xsl:text>
		  <xsl:variable name="descr" select="$list/*/option[@value=$selectedValue]"/>
		  <input type="label" for="s_{$refId}" size="50" id="label-s_{$refId}" name="label-s_{$refId}" value="{$descr}"/>
		  <select id="s_{$refId}" name="s_{$refId}" size="1"
		  onchange="$('label-s_{$refId}').value=this.options[this.selectedIndex].text; $('_{$refId}').value=this.options[this.selectedIndex].value; if ($('_{$refId}').onkeyup) $('_{$refId}').onkeyup(); {$relatedElementAction} {$jsAction}" class="md">
		    <option/>
		    <!-- This assume that helper list is already sort in alphabetical order in loc file. -->
		    <xsl:copy-of select="$list/*"/>
			</select>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
