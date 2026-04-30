<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html"/>
    
    <xsl:template match="/">
        <xsl:variable name="DATETIME" select="current-dateTime()"/>
        <xsl:variable name="_TOPIC" select="/stat/@job"/>
        <xsl:variable name="_STAT_ROOT" select="/stat/@statroot"/>

        <xsl:variable name="_STAT_TESTREPORTCOMMONFILENAME" select="/stat/@reportfile"/>
        <xsl:variable name="_STAT_TESTREPORTCOMMONFILE" select="document($_STAT_TESTREPORTCOMMONFILENAME)"/>
        <xsl:variable name="_STAT_STATISTICSCOMMONFILENAME" select="/stat/@statfile"/>
        <xsl:variable name="_STAT_STATISTICSCOMMONFILE" select="document($_STAT_STATISTICSCOMMONFILENAME)"/>

        
        <html>
            <head>
                <title>Automated <xsl:value-of select="$_TOPIC"/> Test Report</title>
            </head>
            <body>
                <p><xsl:value-of select="$_STAT_ROOT"/></p>
                <p><xsl:value-of select="$_STAT_ROOT"/></p>
               <xsl:for-each select="$_STAT_TESTREPORTCOMMONFILE/NMTCompareReport/testqueue[@name=$THISTASK]/inputfile">
                <p><span style="color: red; font-weight: bold;">TXT: <xsl:value-of select="./@name"/></span></p>
               </xsl:for-each>                      
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
