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
						select="gmd:citation/gmd:CI_Citation/gmd:title">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:title)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:CI_Citation/geonet:child[string(@name)='title']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>		
					
					<xsl:apply-templates mode="elementEP" select="
						gmd:citation/gmd:CI_Citation/gmd:presentationForm">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:presentationForm)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:CI_Citation/geonet:child[string(@name)='presentationForm']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Identifier -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:CI_Citation/geonet:child[string(@name)='code']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Id Livello superiore -->
					<xsl:apply-templates mode="elementEP" 
						select="gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:CI_Citation/geonet:child[string(@name)='issueIdentification']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Optional for RNDT -->
					<xsl:apply-templates mode="simpleElement" 
						select="gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails)">
						<xsl:apply-templates mode="elementEP"
							select="gmd:CI_Citation/geonet:child[string(@name)='otherCitationDetails']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:abstract">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:abstract)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='abstract']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Spatial Representation -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:spatialRepresentationType">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:spatialRepresentationType)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='spatialRepresentationType']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Language -->
					<xsl:apply-templates mode="elementEP" select="gmd:language">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:language)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='language']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Character Set -->
					<xsl:apply-templates mode="elementEP" select="gmd:characterSet">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:characterSet)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='characterSet']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Topic Category -->
					<xsl:apply-templates mode="elementEP" select="gmd:topicCategory">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(gmd:topicCategory)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='topicCategory']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Date -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:date">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:date)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='date']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!--  Responsible -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='citedResponsibleParty']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!--  Keywords -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/schemas/iso19139.rndt/strings/keywords/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/schemas/iso19139.rndt/strings/keywords/title)" />
						<xsl:with-param name="content">
							
							<xsl:apply-templates mode="elementEP"
								select="gmd:descriptiveKeywords">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(gmd:descriptiveKeywords)">
								<xsl:apply-templates mode="elementEP"
									select="geonet:child[string(@name)='descriptiveKeywords']">
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
					<xsl:if test="not(gmd:spatialResolution)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='spatialResolution']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- SupplementalInformation (Optional for RNDT) -->						
					<xsl:apply-templates mode="elementEP" select="gmd:supplementalInformation">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>	
					<xsl:if test="not(gmd:supplementalInformation)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='supplementalInformation']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Service info-->
			<xsl:if test="not($dataset)">				
				<xsl:call-template name="complexElementGuiWrapper">
					<xsl:with-param name="title"
						select="/root/gui/schemas/iso19139.rndt/strings/service/title" />
					<xsl:with-param name="id"
						select="generate-id(/root/gui/schemas/iso19139.rndt/strings/service/title)" />
					<xsl:with-param name="content">
						
						<!-- Service Type -->
						<xsl:apply-templates mode="elementEP"
							select="srv:serviceType">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						<xsl:if test="not(gmd:serviceType)">
							<xsl:apply-templates mode="elementEP"
								select="geonet:child[string(@name)='serviceType']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Coupling Type -->
						<xsl:apply-templates mode="elementEP"
							select="srv:couplingType">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						<xsl:if test="not(gmd:couplingType)">
							<xsl:apply-templates mode="elementEP"
								select="geonet:child[string(@name)='couplingType']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Resource Coupled -->
						<xsl:apply-templates mode="elementEP"
							select="srv:operatesOn">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						<xsl:if test="not(gmd:operatesOn)">
							<xsl:apply-templates mode="elementEP"
								select="geonet:child[string(@name)='operatesOn']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:if>
						
						<!-- Contains Operations -->
						<xsl:apply-templates mode="elementEP"
							select="srv:containsOperations">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						<xsl:if test="not(gmd:containsOperations)">
							<xsl:apply-templates mode="elementEP"
								select="geonet:child[string(@name)='containsOperations']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:if>
						
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
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='useLimitation']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='accessConstraints']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='useConstraints']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='otherConstraints']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:classification">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					<xsl:if test="not(gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:classification)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='classification']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
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
					<xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:geographicElement)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='geographicElement']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
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
							<xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue)">
								<xsl:apply-templates mode="elementEP"
									select="geonet:child[string(@name)='minimumValue']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>
							
							<xsl:apply-templates mode="elementEP"
								select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue)">
								<xsl:apply-templates mode="elementEP"
									select="geonet:child[string(@name)='maximumValue']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>
							
							<xsl:apply-templates mode="simpleElement"
								select="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							<xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS)">
								<xsl:apply-templates mode="elementEP"
									select="geonet:child[string(@name)='verticalCRS']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:if>
							
						</xsl:with-param>
					</xsl:call-template>	
					
					<!-- Temporal extent -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:extent/gmd:EX_Extent/gmd:temporalElement">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
						<xsl:with-param name="force" select="true()" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:extent/gmd:EX_Extent/gmd:temporalElement)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='temporalElement']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
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
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					<xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='level']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Positional accuracy -->
					<xsl:apply-templates mode="complexElement" 
						select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy)">
						<xsl:apply-templates mode="elementEP"
							select="geonet:child[string(@name)='report']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					
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
								test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result)">
								<xsl:apply-templates mode="elementEP"
									select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/geonet:child[string(@name)='result']">
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
			<xsl:if	test="not(../../gmd:referenceSystemInfo)">
				<xsl:apply-templates mode="elementEP"
					select="../../geonet:child[string(@name)='referenceSystemInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="force" select="true()" />
				</xsl:apply-templates>
			</xsl:if>
			
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
					<xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='distributionFormat']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					<xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='distributor']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates mode="elementEP"
						select="../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>	
					<xsl:if	test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions)">
						<xsl:apply-templates mode="elementEP"
							select="../../gmd:distributionInfo/gmd:MD_Distribution/geonet:child[string(@name)='transferOptions']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Data management -->
			<xsl:apply-templates mode="complexElement"
				select="gmd:resourceMaintenance">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>
			<xsl:if	test="not(gmd:resourceMaintenance)">
				<xsl:apply-templates mode="elementEP"
					select="geonet:child[string(@name)='resourceMaintenance']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="force" select="true()" />
				</xsl:apply-templates>
			</xsl:if>
			
			<!-- Contenuto dei dati raster -->
			<xsl:apply-templates mode="complexElement" 
				select="../../gmd:contentInfo">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>			
			<xsl:if	test="not(../../gmd:contentInfo)">
				<xsl:apply-templates mode="elementEP"
					select="../../geonet:child[string(@name)='contentInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="force" select="true()" />
				</xsl:apply-templates>
			</xsl:if>
			
			<!-- Contenuto dei dati raster -->
			<xsl:apply-templates mode="complexElement" 
				select="../../gmd:spatialRepresentationInfo">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>
			<xsl:if	test="not(../../gmd:spatialRepresentationInfo)">
				<xsl:apply-templates mode="elementEP"
					select="../../geonet:child[string(@name)='spatialRepresentationInfo']">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="force" select="true()" />
				</xsl:apply-templates>
			</xsl:if>
			
			<!-- Metadata  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/schemas/iso19139.rndt/strings/metadata/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/schemas/iso19139.rndt/strings/metadata/title)" />
				<xsl:with-param name="content">
					
					<!-- fileIdentifier -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:fileIdentifier">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:fileIdentifier)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='fileIdentifier']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- language -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:language">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:language)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='language']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- metadataStandardName -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:metadataStandardName">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:metadataStandardName)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='metadataStandardName']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- metadataStandardVersion -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:metadataStandardVersion">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:metadataStandardVersion)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='metadataStandardVersion']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- characterSet -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:characterSet">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:characterSet)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='characterSet']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>	
					
					<!-- parentIdentifier -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:parentIdentifier">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:parentIdentifier)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='parentIdentifier']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>		
					
					<!-- hierarchyLevel -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:hierarchyLevel">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:hierarchyLevel)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='hierarchyLevel']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>	
								
					<!-- dateStamp -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:dateStamp">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:dateStamp)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='dateStamp']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- contact -->
					<xsl:apply-templates mode="elementEP" 
						select="../../gmd:contact">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if	test="not(../../gmd:contact)">
						<xsl:apply-templates mode="elementEP"
							select="../../geonet:child[string(@name)='contact']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>	
					
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>