<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <xsl:variable name="DATETIME" select="current-dateTime()"/>
        <xsl:variable name="_TOPIC" select="/stat/topic"/>
        <xsl:variable name="_STAT_ROOT" select="/stat/statroot"/>

        <xsl:variable name="_STAT_TESTREPORTCOMMONFILENAME" select="/stat/reportfile"/>
        <xsl:variable name="_STAT_TESTREPORTCOMMONFILE" select="document($_STAT_TESTREPORTCOMMONFILENAME)"/>
        <xsl:variable name="_STAT_STATISTICSCOMMONFILENAME" select="/stat/statfile"/>
        <xsl:variable name="_STAT_STATISTICSCOMMONFILE" select="document($_STAT_STATISTICSCOMMONFILENAME)"/>
        <xsl:variable name="_STAT_SOURCEFOLDER" select="/stat/sourcefolder"/>
        <xsl:variable name="_STAT_REFFOLDER" select="/stat/reffolder"/>
        <xsl:variable name="_STAT_OUTFOLDER" select="/stat/outfolder"/>

        <xsl:variable name="_STAT_PREVIOUSTIMESPENT" select="/stat/timesPrevious"/>
        <xsl:variable name="_PREVIOUSTIME_TOKENIZED" select="tokenize($_STAT_PREVIOUSTIMESPENT, ',')"/>
        <xsl:variable name="_PREVIOUSTIME_EXECUTE" select="$_PREVIOUSTIME_TOKENIZED[1]"/>
        <xsl:variable name="_PREVIOUSTIME_EXECUTE_10pc" select="number($_PREVIOUSTIME_EXECUTE) div 10"/>
        <xsl:variable name="_PREVIOUSTIME_EXPORT" select="$_PREVIOUSTIME_TOKENIZED[2]"/>
        <xsl:variable name="_PREVIOUSTIME_EXPORT_10pc" select="number($_PREVIOUSTIME_EXPORT) div 10"/>
        <xsl:variable name="_PREVIOUSTIME_OVERALL" select="$_PREVIOUSTIME_TOKENIZED[3]"/>
        <xsl:variable name="_PREVIOUSTIME_OVERALL_10pc" select="number($_PREVIOUSTIME_OVERALL) div 10"/>
        
        <xsl:variable name="_STAT_CURRENTTIMESPENT" select="/stat/timesCurrent"/>
        <xsl:variable name="_CURRENTTIME_TOKENIZED" select="tokenize($_STAT_CURRENTTIMESPENT, ',')"/>
        <xsl:variable name="_CURRENTTIME_EXECUTE" select="$_CURRENTTIME_TOKENIZED[1]"/>
        <xsl:variable name="_CURRENTTIME_EXPORT" select="$_CURRENTTIME_TOKENIZED[2]"/>
        <xsl:variable name="_CURRENTTIME_OVERALL" select="$_CURRENTTIME_TOKENIZED[3]"/>

        <xsl:variable name="TESTPASSED" select="$_STAT_TESTREPORTCOMMONFILE/testqueue/build[1]/message/@severity"/>
        
        <xsl:variable name="_NMTBUILDNUMBER" select="/stat/NMTVersion"/>
        <xsl:variable name="_BUILDNUMBER" select="/stat/DPBuild"/>
        <xsl:variable name="_NDLBUILDNUMBER" select="/stat/NDLBuild"/>
        <xsl:variable name="_INPUTFILETYPE" select="/stat/inputfiles/@type"/>
        
        <xsl:variable name="_INPUT_FILES_COUNT" select="/stat/inputfiles"/>
        <xsl:variable name="_STAT_CMPOUTPUTFILETYPE" select="/stat/cmpoutputfiletype"/>
        <xsl:variable name="_NUMOFTASKS" select="/stat/numoftasks"/>
        <xsl:variable name="_ALL_INPUT_FILES" select="_NUMOFTASKS * _INPUT_FILES_COUNT_SUM"/>
        
        <html>
            <head>
                <title>Automated <xsl:value-of select="$_TOPIC"/> Test Report</title>
            </head>
            <style>
                table, td, th {
                border: 1px solid black;
                }
                table {
                border-collapse: collapse;
                }
                th {
                text-align: left;
                }
            </style>
            <body>
                
                <xsl:choose>
                    <xsl:when test="$TESTPASSED = 'error'">
                        <p><span style="color: red; font-weight: bold;"><xsl:value-of select="$_TOPIC"/> Test FAILED!</span></p>
                        <p><xsl:value-of select="$_STAT_TESTREPORTCOMMONFILE/testqueue/build[1]/message/@description"/></p>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <h1 align="left" style="font-size:130%">Automatic Esko Tester <xsl:value-of select="$_TOPIC"/> Report</h1>
                        <span style="font-style: italic;"><xsl:value-of select="$DATETIME"/></span> | Build / NDL / NMT build No.: <span style="font-weight: bold;"><xsl:value-of select="$_BUILDNUMBER"/> / <xsl:value-of select="$_NDLBUILDNUMBER"/> / <xsl:value-of select="$_NMTBUILDNUMBER"/></span> | <a href="#Links">Jump to links...</a>
                        <br/>
                           
                        <p>No. of input <xsl:value-of select="$_INPUTFILETYPE"/> files: <span style="font-weight: bold;"><xsl:value-of select="$_INPUT_FILES_COUNT"/></span></p>
                        <p>Total time spent (previous / current) -</p>
                        <ul>
                            <li>
                                <xsl:choose>
                                    <xsl:when test="(number($_CURRENTTIME_EXECUTE) - number($_PREVIOUSTIME_EXECUTE)) &lt;= $_PREVIOUSTIME_EXECUTE_10pc">
                                        Execution: <xsl:value-of select="$_PREVIOUSTIME_EXECUTE"/> / <xsl:value-of select="$_CURRENTTIME_EXECUTE"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        Execution: <span style="font-weight: bold; color: red;"><xsl:value-of select="$_PREVIOUSTIME_EXECUTE"/> / <xsl:value-of select="$_CURRENTTIME_EXECUTE"/></span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                            <li>
                                <xsl:choose>
                                    <xsl:when test="(number($_CURRENTTIME_EXPORT) - number($_PREVIOUSTIME_EXPORT)) &lt;= $_PREVIOUSTIME_EXPORT_10pc">
                                        Export: <xsl:value-of select="$_PREVIOUSTIME_EXPORT"/> / <xsl:value-of select="$_CURRENTTIME_EXPORT"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        Export: <span style="font-weight: bold; color: red;"><xsl:value-of select="$_PREVIOUSTIME_EXPORT"/> / <xsl:value-of select="$_CURRENTTIME_EXPORT"/></span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                            <li>
                                <xsl:choose>
                                    <xsl:when test="(number($_CURRENTTIME_OVERALL) - number($_PREVIOUSTIME_OVERALL)) &lt;= $_PREVIOUSTIME_OVERALL_10pc">
                                        Overall: <xsl:value-of select="$_PREVIOUSTIME_OVERALL"/> / <xsl:value-of select="$_CURRENTTIME_OVERALL"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        Overall: <span style="font-weight: bold; color: red;"><xsl:value-of select="$_PREVIOUSTIME_OVERALL"/> / <xsl:value-of select="$_CURRENTTIME_OVERALL"/></span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                        </ul>
                         
                        <table>
                            <xsl:for-each select="/stat/tasks/task">
                                
                                <xsl:variable name="THISTASK" select="./@taskname"/>
                                <xsl:variable name="THISOUTPATH" select="concat($_STAT_ROOT,'/',$THISTASK)"/>
                                <xsl:variable name="THISDIFFPATH" select="concat($THISOUTPATH,'/diff')"/>
                                <xsl:variable name="_PROCESS_OUT_FILES_COUNT" select="./files[@type='PROCESS_OUT_FILES_COUNT']"/>
                                <xsl:variable name="_PRECMP_OUT_FILES_COUNT" select="./files[@type='PRECMP_OUT_FILES_COUNT']"/>
                                <xsl:variable name="_ONTOP_FILES_COUNT" select="./files[@type='ONTOP_FILES_COUNT']"/>
                                <xsl:variable name="_REF_TIFF_FILES_COUNT" select="./files[@type='REF_TIFF_FILES_COUNT']"/>
                            
                                <tr style="background-color: #AEB6BF; font-weight: bold;">
                                    <td colspan="2"><xsl:value-of select="$THISTASK"/></td> 
                                </tr>
                                <tr>
                                    <td>Number of succesfully processed files:</td> 
                                    <xsl:choose>
                                        <xsl:when test="$_PROCESS_OUT_FILES_COUNT = $_INPUT_FILES_COUNT">
                                            <td style="font-weight: bold;"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td style="font-weight: bold; color: red;"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT"/> (<xsl:value-of select="$_PROCESS_OUT_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </tr>
                                <tr>
                                    <td>Number of files pre-converted for comparison:</td> 
                                    <xsl:choose>
                                        <xsl:when test="$_PRECMP_OUT_FILES_COUNT = $_INPUT_FILES_COUNT">
                                            <td style="font-weight: bold;"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td style="font-weight: bold; color: red;"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT"/> (<xsl:value-of select="$_PRECMP_OUT_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </tr>
                                <tr>
                                    <td>Number of DIFF files:</td> 
                                    <xsl:choose>
                                        <xsl:when test="$_ONTOP_FILES_COUNT &gt; 0">
                                            <td style="font-weight: bold; color: red;"><xsl:value-of select="$_ONTOP_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td style="font-weight: bold;"><xsl:value-of select="$_ONTOP_FILES_COUNT"/></td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </tr>
                                <tr>
                                    <td>Number of reference files:</td> 
                                    <xsl:choose>
                                        <xsl:when test="$_REF_TIFF_FILES_COUNT &lt;= $_INPUT_FILES_COUNT">
                                            <td style="font-weight: bold;"><xsl:value-of select="$_REF_TIFF_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td style="font-weight: bold; color: red;"><xsl:value-of select="$_REF_TIFF_FILES_COUNT"/> (<xsl:value-of select="$_REF_TIFF_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </tr>
                               <tr>
                                    <td colspan="2">
                                        
                                        <table style="border-spacing: 5px 0px; width: 100%; border-left: 1px; border-right: 1px; font-size:80%;">
                                            <tbody>
                                                <tr style="background-color: #EBEDEF; border-bottom: 2px">
                                                    <th style="text-align: left;">File</th>
                                                    <th style="text-align: left;">Description</th>
                                                    <th style="text-align: left;">Diff file</th>
                                                    <th style="text-align: left;">How much different</th>
                                                </tr>
        
                                                 <xsl:for-each select="$_STAT_TESTREPORTCOMMONFILE/NMTCompareReport/testqueue[@name=$THISTASK]/inputfile">

												<xsl:if test="./build/@changes = 'true'">
                                                        
                                                    <xsl:variable name="DIFFSTRIP"
                                                        select="substring(./build/message/@href, 1, string-length(./build/message/@href) - 4)"/>
                                                    <xsl:variable name="DIFF"
                                                        select="substring($DIFFSTRIP, 6, string-length($DIFFSTRIP) - 5)"/>
                                                    <xsl:variable name="DIFFAMOUNT" 
                                                        select="./build/message[1]"></xsl:variable>
                                                    <xsl:variable name="ISKPIX" select="contains($DIFFAMOUNT,'Kpix')"></xsl:variable>
                                                        <tr>
                                                            <td>
                                                                <xsl:if test="$ISKPIX">
                                                                    <span style="font-weight: bold;">
                                                                        <xsl:value-of select="./@name"/>
                                                                    </span>
                                                                </xsl:if>
                                                                <xsl:if test="not($ISKPIX)">
                                                                    <span style="color: Gray;">
                                                                        <xsl:value-of select="./@name"/>
                                                                    </span>
                                                                </xsl:if>
                                                            </td>
                                                            <td>
																<xsl:for-each select="./build/message">
																	<xsl:choose>
																		<xsl:when test="./@description = 'Sizes' or ./@description = 'NumChannels'">
																			<span style="color: red;">
																				<xsl:value-of select="./@description"/>&#160;
																			</span>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="./@description"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:for-each>
                                                            </td>
                                                            <td>
                                                                <xsl:element name="a">
                                                                    <xsl:attribute name="href"><xsl:value-of select="concat($THISDIFFPATH,'/',$DIFF,'.ontop')"/></xsl:attribute>
                                                                    <xsl:value-of select="$DIFF"/>
                                                                </xsl:element>
                                                            </td>
                                                            <td>
                                                                
                                                                <xsl:if test="$ISKPIX">
                                                                    <span style="font-weight: bold;">
                                                                        <xsl:value-of select="$DIFFAMOUNT"/>
                                                                    </span>
                                                                </xsl:if>
                                                                <xsl:if test="not($ISKPIX)">
                                                                    <span style="color: Gray;">
                                                                        <xsl:value-of select="$DIFFAMOUNT"/>
                                                                    </span>
                                                                </xsl:if>
                                                            </td>
                                                        </tr>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </xsl:for-each>
                            
                        </table>
                        <br/><hr/>
                        <a name="Links"></a>
                        <table style="border-spacing: 5px 0px; font-size:80%; text-align: left;">
                            <tbody>
                                <tr style="font-weight: bold; background-color: #7CC1FF;">
                                    <th style="text-align: left;">Links</th>
                                    <th/>
                                </tr>
                                <tr>
                                    <td>Source files folder</td>
                                    <td>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href"><xsl:value-of select="$_STAT_SOURCEFOLDER"/></xsl:attribute>
                                            <xsl:value-of select="$_STAT_SOURCEFOLDER"/>
                                        </xsl:element>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Reference files</td>
                                    <td>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href"><xsl:value-of select="$_STAT_REFFOLDER"/></xsl:attribute>
                                            <xsl:value-of select="$_STAT_REFFOLDER"/>
                                        </xsl:element>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Processed files</td>
                                    <td>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href"><xsl:value-of select="$_STAT_OUTFOLDER"/></xsl:attribute>
                                            <xsl:value-of select="$_STAT_OUTFOLDER"/>
                                        </xsl:element>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>


</xsl:stylesheet>
