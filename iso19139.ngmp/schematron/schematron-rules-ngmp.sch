<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">
    <!-- 
        This script was developed for CMRE -
        by GeoSolutions SaS
        as part of a project to develop an XML implementation of the NATO Geospatial Metadata Profile.
    -->
    <sch:title>NGMP: STANAG 2586 Edition 1 validation</sch:title>
    <sch:ns prefix="gml" uri="http://www.opengis.net/gml" />
    <sch:ns prefix="gmx" uri="http://www.isotc211.org/2005/gmx"/>
    <sch:ns prefix="ngmp" uri="urn:int:nato:geometoc:geo:metadata:ngmp:1.0"/>


    <sch:pattern id="checkCodeList">
        <sch:rule context="//ngmp:*[@codeList]">
            <sch:let name="codeListDoc" value="document(substring-before(@codeList,'#'))//gmx:CodeListDictionary[@gml:id = substring-after(current()/@codeList,'#')]"/>
            <sch:assert test="$codeListDoc">Unable to find the specified codeList document or CodeListDictionary node.</sch:assert>
            <sch:assert test="@codeListValue = $codeListDoc/gmx:codeEntry/gmx:CodeDefinition/gml:identifier">codeListValue is not in the specified codeList.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
