<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:java="java:org.fao.geonet.util.XslUtil" version="2.0">
	
	<!--
		Template for INSPIRE RNDT tab
	-->
	<xsl:template name="rndttabs">
		<xsl:param name="schema" />
		<xsl:param name="edit" />
		<xsl:param name="dataset" />

		<xsl:for-each
			select="gmd:identificationInfo/gmd:MD_DataIdentification|
			gmd:identificationInfo/srv:SV_ServiceIdentification|
			gmd:identificationInfo/*[@gco:isoType='gmd:MD_DataIdentification']|
			gmd:identificationInfo/*[@gco:isoType='srv:SV_ServiceIdentification']">
			
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/identification/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/identification/title)" />
				<xsl:with-param name="content">
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:title|
						gmd:CI_Citation/geonet:child[string(@name)='title']">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
										
					<xsl:apply-templates mode="elementEP" select="
						gmd:citation/gmd:CI_Citation/gmd:presentationForm|
						geonet:child[string(@name)='presentationForm']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<xsl:apply-templates mode="elementEP" select="gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Optional for RNDT -->
					<xsl:apply-templates mode="simpleElement" select="gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<xsl:apply-templates mode="elementEP"
						select="
						gmd:abstract|
						geonet:child[string(@name)='abstract']">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!-- Spatial Representation -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:spatialRepresentationType">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!-- Language -->
					<xsl:apply-templates mode="elementEP" select="gmd:language">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Character Set -->
					<xsl:apply-templates mode="elementEP" select="gmd:characterSet">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Date -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!--  Responsible -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!--  Keywords -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/schemas/iso19139.rndt/strings/keywords/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/schemas/iso19139.rndt/strings/keywords/title)" />
						<xsl:with-param name="content">
							
							<xsl:apply-templates mode="elementEP"
								select="
								gmd:descriptiveKeywords
								">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(gmd:descriptiveKeywords)">
								<xsl:apply-templates mode="elementEP"
									select="
									geonet:child[string(@name)='descriptiveKeywords']
									">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>
							
						</xsl:with-param>
					</xsl:call-template>
					
					<!-- Point of Contact -->
					<xsl:apply-templates mode="elementEP" 
						select="gmd:pointOfContact">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit" select="$edit"/>
						<xsl:with-param name="force" select="true()"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:pointOfContact)">
						<xsl:apply-templates mode="elementEP" select="
							geonet:child[string(@name)='pointOfContact']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit" select="$edit"/>
							<xsl:with-param name="force" select="true()"/>
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Spatial Resolution -->
					<xsl:apply-templates mode="elementEP" select="gmd:spatialResolution">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Topic Category -->
					<xsl:apply-templates mode="elementEP" select="gmd:topicCategory">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- SupplementalInformation (Optional for RNDT) -->						
					<xsl:apply-templates mode="elementEP" select="gmd:supplementalInformation">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>				
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Service info-->
			<xsl:if test="not($dataset)">				
				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title"
						select="/root/gui/schemas/iso19139.rndt/strings/services/title" />
					<xsl:with-param name="id"
						select="generate-id(/root/gui/schemas/iso19139.rndt/strings/services/title)" />
					<xsl:with-param name="content">
						
						<!-- Service Type -->
						<xsl:apply-templates mode="elementEP"
							select="
							srv:serviceType|
							geonet:child[string(@name)='serviceType']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						
						<!-- Coupling Type -->
						<xsl:apply-templates mode="elementEP"
							select="
							srv:couplingType|
							geonet:child[string(@name)='couplingType']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						
						<!-- Resource Coupled -->
						<xsl:apply-templates mode="elementEP"
							select="
							srv:operatesOn|
							geonet:child[string(@name)='operatesOn']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						
						<!-- Contains Operations -->
						<xsl:apply-templates mode="elementEP"
							select="
							srv:containsOperations|
							geonet:child[string(@name)='containsOperations']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			
			<!-- Constraint  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/constraint/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/constraint/title)" />
				<xsl:with-param name="content">
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:classification">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>					
				</xsl:with-param>
			</xsl:call-template>	
			
			<!-- Extent information -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/geoloc/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/geoloc/title)" />
				<xsl:with-param name="content">
					
					<!-- Geographic Extent -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:extent/gmd:EX_Extent/gmd:geographicElement">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!-- Vertical Extent -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/schemas/iso19139.rndt/strings/verticalExtent/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/schemas/iso19139.rndt/strings/verticalExtent/title)" />
						<xsl:with-param name="content">
							<xsl:apply-templates mode="elementEP"
								select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:apply-templates mode="elementEP"
								select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:apply-templates mode="simpleElement"
								select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:with-param>
					</xsl:call-template>					
				</xsl:with-param>					
			</xsl:call-template>
			
			<!-- Quality and validity  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/quality/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/quality/title)" />
				<xsl:with-param name="content">
					
					<!-- Quality level -->
					<xsl:apply-templates mode="elementEP" select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Positional accuracy -->
					<xsl:apply-templates mode="complexElement" 
						select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!-- Lineage -->
					<xsl:apply-templates mode="complexElement"
						select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>					
					<xsl:if	test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/geonet:child[string(@name)='lineage']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Conformity  -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/schemas/iso19139.rndt/strings/conformity/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/schemas/iso19139.rndt/strings/conformity/title)" />
						<xsl:with-param name="content">
							
							<xsl:apply-templates mode="iso19139"
								select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:if
								test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult)">
								<xsl:apply-templates mode="elementEP"
									select="
									../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/geonet:child[string(@name)='result']
									">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Spatial Reference System -->
			<xsl:apply-templates mode="elementEP"
				select="../../gmd:referenceSystemInfo">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>	
			
			<!-- Distribution -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/distribution/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/distribution/title)" />
				<xsl:with-param name="content">
					
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Data management -->
			<xsl:apply-templates mode="complexElement"
				select="
				gmd:resourceMaintenance/gmd:MD_MaintenanceInformation">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>
			
			<!-- Contenuto dei dati raster -->
			<xsl:apply-templates mode="complexElement" 
				select="../../gmd:contentInfo">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>
			
			<!-- Contenuto dei dati raster -->
			<xsl:apply-templates mode="complexElement" 
				select="../../gmd:spatialRepresentationInfo">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>
			
			<!-- Metadata  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/metadata/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/metadata/title)" />
				<xsl:with-param name="content">
					
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="string(/root/gui/*[name(.)=$schema]/element[@name='gmd:MD_Metadata']/label)" />
						<xsl:with-param name="content">
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:fileIdentifier|
								../../gmd:language|
								../../gmd:metadataStandardName|
								../../gmd:metadataStandardVersion|
								../../geonet:child[string(@name)='language']|
								../../gmd:characterSet|
								../../geonet:child[string(@name)='characterSet']|
								../../gmd:parentIdentifier|
								../../geonet:child[string(@name)='parentIdentifier']|
								../../gmd:hierarchyLevel|
								../../gmd:contact|
								../../gmd:dateStamp|
								../../geonet:child[string(@name)='dateStamp']
								">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:with-param>
					</xsl:call-template>
					
					
				</xsl:with-param>
			</xsl:call-template>
			
		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>