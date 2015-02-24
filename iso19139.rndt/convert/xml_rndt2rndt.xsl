<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="geonet gml">

	<xsl:include href="../present/csw/iso-full.xsl"/>
	
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	<!-- ================================================================= -->

	<!-- skip the root element -->
	<xsl:template match="/root">
		<xsl:apply-templates select="gmd:MD_Metadata"/>
	</xsl:template>

    

</xsl:stylesheet>
