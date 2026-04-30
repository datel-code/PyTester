<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <xsl:variable name="DATETIME" select="current-dateTime()"/>
        <xsl:variable name="_TOPIC" select="/stat/topic"/>
        <xsl:variable name="_STAT_ROOT_UNC" select="/stat/statroot_unc"/>

        <xsl:variable name="_STAT_STATISTICSCOMMONFILENAME_UNC" select="/stat/statfile_unc"/>
        <xsl:variable name="_STAT_STATISTICSCOMMONFILE_UNC" select="document($_STAT_STATISTICSCOMMONFILENAME_UNC)"/>

        <xsl:variable name="_STAT_SOURCEFOLDER_UNC" select="/stat/sourcefolder_unc"/>
        <xsl:variable name="_STAT_PRECMPFOLDER_UNC" select="/stat/precmp_unc"/>
        <xsl:variable name="_STAT_PROCESSOUTFOLDER_UNC" select="/stat/processoutfolder_unc"/>
        <xsl:variable name="_STAT_REIMPORTOUTFOLDER_UNC" select="/stat/reimportoutfolder_unc"/>
        <xsl:variable name="_STAT_REFFOLDER_UNC" select="/stat/reffolder_unc"/>
        <xsl:variable name="_STAT_ARCHIVE_UNC" select="/stat/archive_unc"/>

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

        <xsl:variable name="_BUILDNUMBER" select="/stat/DPBuild"/>
        <xsl:variable name="_NDLBUILDNUMBER" select="/stat/NDLBuild"/>
        
        <xsl:variable name="_STAT_SUSPECTEDFILESCOUNTARRAY" select="/stat/ontopfilesarray"/>
        
        <xsl:variable name="_INPUT_FILES_COUNT_SUM" select="/stat/suminputfiles"/>
        <xsl:variable name="_INPUTFILETYPE" select="/stat/suminputfiles/@type"/>
        <xsl:variable name="_PROCESS_OUT_FILES_COUNT_SUM" select="/stat/sumprocessedfiles"/>
        <xsl:variable name="_OUTPUTFILETYPE" select="/stat/sumprocessedfiles/@type"/>
        <xsl:variable name="_REIMPORT_OUT_FILES_COUNT_SUM" select="/stat/sumreimportedfilesout"/>
        <xsl:variable name="_PRECMP_OUT_FILES_COUNT_SUM" select="/stat/sumprecomparefiles"/>
        <xsl:variable name="_STAT_CMPOUTPUTFILETYPE" select="/stat/sumprecomparefiles/@type"/>
        <xsl:variable name="_ONTOP_FILES_COUNT_SUM" select="/stat/sumontopfiles"/>
        <xsl:variable name="_REF_TIFF_FILES_COUNT_SUM" select="/stat/sumreffiles"/>
        <xsl:variable name="_NUMOFTASKS" select="/stat/numoftasks"/>
        <xsl:variable name="_ALL_INPUT_FILES" select="/stat/allinputfiles"/>
       
 
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
                table-layout: fixed;
                }
                th {
                text-align: left;
                }
                td {
                word-wrap:break-word
                }
            </style>
            <body>
                <h1 align="left" style="font-size:130%">Automatic Esko <xsl:value-of select="$_TOPIC"/> Tester Report</h1>
                <span style="font-style: italic;"><xsl:value-of select="$DATETIME"/></span> | Build / NDL build No.: <span style="font-weight: bold;"><xsl:value-of select="$_BUILDNUMBER"/> / <xsl:value-of select="$_NDLBUILDNUMBER"/></span> | <a href="#Links">Jump to links...</a>
                <br/>
                <p>
                    Suspected files per task: <xsl:value-of select="$_STAT_SUSPECTEDFILESCOUNTARRAY"/><br/>
                    No. of tasks: <span style="font-weight: bold;"><xsl:value-of select="$_NUMOFTASKS"/></span><br/>
                    No. of input <xsl:value-of select="$_INPUTFILETYPE"/> files: <span style="font-weight: bold;"><xsl:value-of select="$_INPUT_FILES_COUNT_SUM"/></span><br/>
                    Total no. input <xsl:value-of select="$_INPUTFILETYPE"/> files: <span style="font-weight: bold;"><xsl:value-of select="$_ALL_INPUT_FILES"/></span><br/>
                    <xsl:choose>
                        <xsl:when test="$_ONTOP_FILES_COUNT_SUM &gt; 0">
                            No. of DIFF files: <span style="font-weight: bold; color: red;"><xsl:value-of select="$_ONTOP_FILES_COUNT_SUM"/></span><br/>
                        </xsl:when>
                        <xsl:otherwise>
                            No. of DIFF files: <span style="font-weight: bold;"><xsl:value-of select="$_ONTOP_FILES_COUNT_SUM"/></span><br/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$_PROCESS_OUT_FILES_COUNT_SUM = $_ALL_INPUT_FILES">
                            No. of processed <xsl:value-of select="$_OUTPUTFILETYPE"/> files: <span style="font-weight: bold;"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT_SUM"/></span><br/>
                        </xsl:when>
                        <xsl:otherwise>
                            No. of processed <xsl:value-of select="$_OUTPUTFILETYPE"/> files: <span style="font-weight: bold; color: red;"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT_SUM"/> (<xsl:value-of select="$_PROCESS_OUT_FILES_COUNT_SUM - $_ALL_INPUT_FILES"/>)</span> <br/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- <xsl:choose>
                        <xsl:when test="$_REIMPORT_OUT_FILES_COUNT_SUM = 'N/A'">
                            No. of reimported files: <span style="font-weight: bold;"><xsl:value-of select="$_REIMPORT_OUT_FILES_COUNT_SUM"/></span><br/>
                        </xsl:when>
                        <xsl:when test="$_REIMPORT_OUT_FILES_COUNT_SUM = $_ALL_INPUT_FILES">
                            No. of reimported files: <span style="font-weight: bold;"><xsl:value-of select="$_REIMPORT_OUT_FILES_COUNT_SUM"/></span><br/>
                        </xsl:when>
                        <xsl:otherwise>
                            No. of reimported files: <span style="font-weight: bold; color: red;"><xsl:value-of select="$_REIMPORT_OUT_FILES_COUNT_SUM"/> (<xsl:value-of select="$_REIMPORT_OUT_FILES_COUNT_SUM - $_ALL_INPUT_FILES"/>)</span> <br/>
                        </xsl:otherwise>
                    </xsl:choose> -->
                    <xsl:choose>
                        <xsl:when test="$_PRECMP_OUT_FILES_COUNT_SUM = $_ALL_INPUT_FILES">
                            No. of pre-compare <xsl:value-of select="$_STAT_CMPOUTPUTFILETYPE"/> files: <span style="font-weight: bold;"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT_SUM"/></span><br/>
                        </xsl:when>
                        <xsl:otherwise>
                            No. of pre-compare <xsl:value-of select="$_STAT_CMPOUTPUTFILETYPE"/> files: <span style="font-weight: bold; color: red;"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT_SUM"/> (<xsl:value-of select="$_PRECMP_OUT_FILES_COUNT_SUM - $_ALL_INPUT_FILES"/>)</span><br/>
                        </xsl:otherwise>
                    </xsl:choose>
                     <xsl:choose>
                        <xsl:when test="$_REF_TIFF_FILES_COUNT_SUM &lt;= $_ALL_INPUT_FILES">
                            No. of reference files: <span style="font-weight: bold;"><xsl:value-of select="$_REF_TIFF_FILES_COUNT_SUM"/></span><bt/>
                        </xsl:when>
                        <xsl:otherwise>
                            No. of reference files: <span style="font-weight: bold; color: red;"><xsl:value-of select="$_REF_TIFF_FILES_COUNT_SUM"/> (<xsl:value-of select="$_REF_TIFF_FILES_COUNT_SUM - $_ALL_INPUT_FILES"/>)</span><br/>
                        </xsl:otherwise>
                    </xsl:choose>
                </p>
                Total time spent (previous / current) -<br/>
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
                 
                <xsl:for-each select="/stat/tasks/task">
                    <xsl:variable name="_THISTASK" select="./@taskname"/>
                    <xsl:variable name="_THISOUTPATH" select="concat($_STAT_ROOT_UNC,'/',$_THISTASK)"/>
                    <xsl:variable name="_THISDIFFPATH" select="concat($_THISOUTPATH,'/diff')"/>
                    <xsl:variable name="_THIS_TESTREPORTFILENAME" select="concat($_THISOUTPATH,'/Errors_',$_THISTASK,'.log')"/>
                    <xsl:variable name="_THIS_TESTREPORTCOMMONFILE" select="document($_THIS_TESTREPORTFILENAME)"/>

                    <xsl:variable name="_INPUT_FILES_COUNT" select="./files[@type='inputfiles']"/>
                    <xsl:variable name="_PROCESS_OUT_FILES_COUNT" select="./files[@type='processedfiles']"/>
                    <xsl:variable name="_REIMPORT_OUT_FILES_COUNT" select="./files[@type='reimportedfilesout']"/>
                    <xsl:variable name="_PRECMP_OUT_FILES_COUNT" select="./files[@type='precomparefiles']"/>
                    <xsl:variable name="_ONTOP_FILES_COUNT" select="./files[@type='ontopfiles']"/>
                    <xsl:variable name="_REF_TIFF_FILES_COUNT" select="./files[@type='reffiles']"/>

                    <table>
                        <tr style="background-color: #AEB6BF; font-weight: bold;">
                            <td colspan="2"><xsl:value-of select="$_THISTASK"/></td> 
                        </tr>
                        <tr>
                            <td>Number of input files:</td> 
                            <td style="font-weight: bold;"><xsl:value-of select="$_INPUT_FILES_COUNT"/></td>
                        </tr>
                        <tr>
                            <td style="width:400px">Number of DIFF files:</td> 
                            <xsl:choose>
                                <xsl:when test="$_ONTOP_FILES_COUNT &gt; 0">
                                    <td style="font-weight: bold; color: red; width:63px"><xsl:value-of select="$_ONTOP_FILES_COUNT"/></td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td style="font-weight: bold; width:63px"><xsl:value-of select="$_ONTOP_FILES_COUNT"/></td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                        <tr>
                            <td style="width:400px">Number of succesfully processed files:</td> 
                            <xsl:choose>
                                <xsl:when test="$_PROCESS_OUT_FILES_COUNT = 'N/A'">
                                    <td style="font-weight: bold; width:63px">N/A</td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$_INPUT_FILES_COUNT = 'N/A'">
                                            <td style="font-weight: bold; width:63px"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$_PROCESS_OUT_FILES_COUNT = $_INPUT_FILES_COUNT">
                                                    <td style="font-weight: bold; width:63px"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT"/></td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td style="font-weight: bold; color: red; width:63px"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT"/> (<xsl:value-of select="$_PROCESS_OUT_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                        <!-- <tr>
                            <td style="width:400px">Number of succesfully reimported files:</td> 
                            <xsl:choose>
                                <xsl:when test="_INPUT_FILES_COUNT = 'N/A' or $_REIMPORT_OUT_FILES_COUNT = 'N/A'">
                                    <td style="font-weight: bold; width:63px"><xsl:value-of select="$_REIMPORT_OUT_FILES_COUNT"/></td>
                                </xsl:when>
                                <xsl:when test="$_REIMPORT_OUT_FILES_COUNT = $_INPUT_FILES_COUNT">
                                    <td style="font-weight: bold; width:63px"><xsl:value-of select="$_REIMPORT_OUT_FILES_COUNT"/></td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td style="font-weight: bold; color: red; width:63px"><xsl:value-of select="$_REIMPORT_OUT_FILES_COUNT"/> (<xsl:value-of select="$_REIMPORT_OUT_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr> -->
                        <tr>
                            <td style="width:400px">Number of files pre-converted for comparison:</td> 
                            <xsl:choose>
                                <xsl:when test="$_PRECMP_OUT_FILES_COUNT = 'N/A'">
                                    <td style="font-weight: bold; width:63px">N/A</td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$_INPUT_FILES_COUNT = 'N/A'">
                                            <td style="font-weight: bold; width:63px"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$_PRECMP_OUT_FILES_COUNT = $_INPUT_FILES_COUNT">
                                                    <td style="font-weight: bold; width:63px"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT"/></td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td style="font-weight: bold; color: red; width:63px"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT"/> (<xsl:value-of select="$_PRECMP_OUT_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                        <tr>
                            <td style="width:400px">Number of reference files:</td> 
                            <xsl:choose>
                                <xsl:when test="$_REF_TIFF_FILES_COUNT = 'N/A'">
                                    <td style="font-weight: bold; width:63px">N/A</td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                       <xsl:when test="$_INPUT_FILES_COUNT = 'N/A'">
                                            <td style="font-weight: bold; width:63px"><xsl:value-of select="$_REF_TIFF_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$_REF_TIFF_FILES_COUNT &lt;= $_INPUT_FILES_COUNT">
                                                    <td style="font-weight: bold; width:63px"><xsl:value-of select="$_REF_TIFF_FILES_COUNT"/></td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td style="font-weight: bold; color: red; width:63px"><xsl:value-of select="$_REF_TIFF_FILES_COUNT"/> (<xsl:value-of select="$_REF_TIFF_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                    </table>

                    <xsl:copy-of select="$_THIS_TESTREPORTCOMMONFILE"/>
                    <br/><hr/>

                </xsl:for-each>
                    
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
                                    <xsl:attribute name="href"><xsl:value-of select="$_STAT_SOURCEFOLDER_UNC"/></xsl:attribute>
                                    <xsl:value-of select="$_STAT_SOURCEFOLDER_UNC"/>
                                </xsl:element>
                            </td>
                        </tr>
                        <tr>
                            <td>Processed files</td>
                            <td>
                                <xsl:element name="a">
                                    <xsl:attribute name="href"><xsl:value-of select="$_STAT_PROCESSOUTFOLDER_UNC"/></xsl:attribute>
                                    <xsl:value-of select="$_STAT_PROCESSOUTFOLDER_UNC"/>
                                </xsl:element>
                            </td>
                        </tr>
                        <!-- <tr>
                            <td>Reimported files</td>
                            <td>
                                <xsl:element name="a">
                                    <xsl:attribute name="href"><xsl:value-of select="$_STAT_REIMPORTOUTFOLDER_UNC"/></xsl:attribute>
                                    <xsl:value-of select="$_STAT_REIMPORTOUTFOLDER_UNC"/>
                                </xsl:element>
                            </td>
                        </tr> -->
                        <tr>
                            <td>Pre-processed files for comparing</td>
                            <td>
                                <xsl:element name="a">
                                    <xsl:attribute name="href"><xsl:value-of select="$_STAT_PRECMPFOLDER_UNC"/></xsl:attribute>
                                    <xsl:value-of select="$_STAT_PRECMPFOLDER_UNC"/>
                                </xsl:element>
                            </td>
                        </tr>
                        <tr>
                            <td>Reference files</td>
                            <td>
                                <xsl:element name="a">
                                    <xsl:attribute name="href"><xsl:value-of select="$_STAT_REFFOLDER_UNC"/></xsl:attribute>
                                    <xsl:value-of select="$_STAT_REFFOLDER_UNC"/>
                                </xsl:element>
                            </td>
                        </tr>
                        <tr>
                            <td>Archived to</td>
                            <td>
                                <xsl:element name="a">
                                    <xsl:attribute name="href"><xsl:value-of select="$_STAT_ARCHIVE_UNC"/></xsl:attribute>
                                    <xsl:value-of select="$_STAT_ARCHIVE_UNC"/>
                                </xsl:element>
                            </td>
                        </tr>
                    </tbody>
                </table>
                        
            </body>
        </html>
    </xsl:template>


</xsl:stylesheet>
