<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html"/>

    <xsl:template match="/">
        <xsl:variable name="DATETIME" select="current-dateTime()"/>
        <xsl:variable name="_TOPIC" select="/stat/topic"/>
        <xsl:variable name="_STAT_ROOT_UNC" select="/stat/statroot_unc"/>

        <xsl:variable name="_STAT_TESTREPORTCOMMONFILENAME_UNC" select="/stat/reportfile_unc"/>
        <xsl:variable name="_STAT_TESTREPORTCOMMONFILE_UNC" select="document($_STAT_TESTREPORTCOMMONFILENAME_UNC)"/>
        <xsl:variable name="_STAT_KNOWNISSUESFILENAME_UNC" select="/stat/knownissuesfile_unc"/>
        <xsl:variable name="_STAT_KNOWNISSUESFILE_UNC" select="document($_STAT_KNOWNISSUESFILENAME_UNC)"/>

        <xsl:variable name="_STAT_SOURCEFOLDER_UNC" select="/stat/sourcefolder_unc"/>
        <xsl:variable name="_STAT_PRECMPFOLDER_UNC" select="/stat/precmp_unc"/>
        <xsl:variable name="_STAT_PROCESSOUTFOLDER_UNC" select="/stat/processoutfolder_unc"/>
        <xsl:variable name="_STAT_REIMPORTOUTFOLDER_UNC" select="/stat/reimportoutfolder_unc"/>
        <xsl:variable name="_STAT_REFFOLDER_UNC" select="/stat/reffolder_unc"/>

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

        <xsl:variable name="_NMTBUILDNUMBER" select="/stat/NMTVersion"/>
        <xsl:variable name="_BUILDNUMBER" select="/stat/DPBuild"/>
        <xsl:variable name="_NDLBUILDNUMBER" select="/stat/NDLBuild"/>
        
        <xsl:variable name="_STAT_SUSPECTEDFILESCOUNTARRAY" select="/stat/ontopfilesarray"/>
        
        <xsl:variable name="_INPUTFILESSTRUCTURE" select="/stat/inputfilesstructure"/>
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
                <span style="font-style: italic;"><xsl:value-of select="$DATETIME"/></span> | Build / NDL / NMT build No.: <span style="font-weight: bold;"><xsl:value-of select="$_BUILDNUMBER"/> / <xsl:value-of select="$_NDLBUILDNUMBER"/> / <xsl:value-of select="$_NMTBUILDNUMBER"/></span> | <a href="#Links">Jump to links...</a>
                <br/>
                <p>
                    Suspected files per task: <xsl:value-of select="$_STAT_SUSPECTEDFILESCOUNTARRAY"/><br/>
                    No. of tasks: <span style="font-weight: bold;"><xsl:value-of select="$_NUMOFTASKS"/></span><br/>
                    No. of input/cfg <xsl:value-of select="$_INPUTFILETYPE"/> files: <span style="font-weight: bold;"><xsl:value-of select="$_INPUT_FILES_COUNT_SUM"/></span><br/>
                    <xsl:if test="_INPUTFILESSTRUCTURE = 'FLAT'">
                        No. of tasks x input <xsl:value-of select="$_INPUTFILETYPE"/> files: <span style="font-weight: bold;"><xsl:value-of select="$_ALL_INPUT_FILES"/></span><br/>
                    </xsl:if>
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
                        <xsl:when test="$_REF_TIFF_FILES_COUNT_SUM = $_ALL_INPUT_FILES">
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

                    <xsl:variable name="_INPUT_FILES_COUNT" select="./files[@type='inputfiles']"/>
                    <xsl:variable name="_PROCESS_OUT_FILES_COUNT" select="./files[@type='processedfiles']"/>
                    <xsl:variable name="_REIMPORT_OUT_FILES_COUNT" select="./files[@type='reimportedfilesout']"/>
                    <xsl:variable name="_PRECMP_OUT_FILES_COUNT" select="./files[@type='precomparefiles']"/>
                    <xsl:variable name="_ONTOP_FILES_COUNT" select="./files[@type='ontopfiles']"/>
                    <xsl:variable name="_REF_TIFF_FILES_COUNT" select="./files[@type='reffiles']"/>

                    <table style="width: 80vw">
                        <tr style="background-color: #AEB6BF; font-weight: bold;">
                            <td style="width:15%;"><xsl:value-of select="$_THISTASK"/></td> 
                            <td/>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;"><xsl:value-of select="$_INPUT_FILES_COUNT"/></td>
                            <td>input/cfg files</td> 
                        </tr>
                        <tr>
                            <xsl:choose>
                                <xsl:when test="$_ONTOP_FILES_COUNT &gt; 0">
                                    <td style="font-weight: bold; color: red; width:80px"><xsl:value-of select="$_ONTOP_FILES_COUNT"/></td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td style="font-weight: bold; width:80px"><xsl:value-of select="$_ONTOP_FILES_COUNT"/></td>
                                </xsl:otherwise>
                            </xsl:choose>
                            <td>DIFF files</td> 
                        </tr>
                        <tr>
                            <xsl:choose>
                                <xsl:when test="$_PROCESS_OUT_FILES_COUNT = 'N/A'">
                                    <td style="font-weight: bold;">N/A</td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$_INPUT_FILES_COUNT = 'N/A'">
                                            <td style="font-weight: bold;"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$_PROCESS_OUT_FILES_COUNT = $_INPUT_FILES_COUNT">
                                                    <td style="font-weight: bold;"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT"/></td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td style="font-weight: bold; color: red;"><xsl:value-of select="$_PROCESS_OUT_FILES_COUNT"/> (<xsl:value-of select="$_PROCESS_OUT_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                            <td>succesfully processed files</td> 
                        </tr>
                        <tr>
                            <xsl:choose>
                                <xsl:when test="$_PRECMP_OUT_FILES_COUNT = 'N/A'">
                                    <td style="font-weight: bold;">N/A</td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$_INPUT_FILES_COUNT = 'N/A'">
                                            <td style="font-weight: bold;"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$_PRECMP_OUT_FILES_COUNT = $_INPUT_FILES_COUNT">
                                                    <td style="font-weight: bold;"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT"/></td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td style="font-weight: bold; color: red;"><xsl:value-of select="$_PRECMP_OUT_FILES_COUNT"/> (<xsl:value-of select="$_PRECMP_OUT_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                            <td>files pre-converted for comparison</td> 
                        </tr>
                        <tr>
                            <xsl:choose>
                                <xsl:when test="$_REF_TIFF_FILES_COUNT = 'N/A'">
                                    <td style="font-weight: bold;">N/A</td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                       <xsl:when test="$_INPUT_FILES_COUNT = 'N/A'">
                                            <td style="font-weight: bold;"><xsl:value-of select="$_REF_TIFF_FILES_COUNT"/></td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="$_REF_TIFF_FILES_COUNT &lt;= $_INPUT_FILES_COUNT">
                                                    <td style="font-weight: bold;"><xsl:value-of select="$_REF_TIFF_FILES_COUNT"/></td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td style="font-weight: bold; color: red;"><xsl:value-of select="$_REF_TIFF_FILES_COUNT"/> (<xsl:value-of select="$_REF_TIFF_FILES_COUNT - $_INPUT_FILES_COUNT"/>)</td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                            <td>reference files</td> 
                        </tr>

                        <tr>
                            <td colspan="2">
                                
                                <table style="border-spacing: 5px; width: 80vw; border-left: 1px; border-right: 1px; font-size:80%;">
                                    <tbody>
                                        <tr style="background-color: #EBEDEF; border-bottom: 2px">
                                            <th style="text-align: left; width:20%">File/Diff file</th>
                                            <th style="text-align: left; width:8%">Issue found</th>
                                            <th style="text-align: left; width:8%">How much different now</th>
                                            <th style="text-align: left; width:8%">Last difference</th>
                                            <th style="text-align: left; width:8%">Known as</th>
                                            <th style="text-align: left; width:8%">Last check on</th>
                                            <th style="text-align: left; width:30%">Comment</th>
                                            <th style="text-align: left; width:10%">JIRA</th>
                                        </tr>

                                        <xsl:for-each select="$_STAT_TESTREPORTCOMMONFILE_UNC/NMTCompareReport/testqueue[@name=$_THISTASK]/inputfile">

                                            <xsl:if test="./build/@changes = 'true'">

                                                <xsl:variable name="AFFECTEDFILENAME" select="./@name"/>
                                                <xsl:variable name="ISSUENAME"        select="substring($AFFECTEDFILENAME, 1, string-length($AFFECTEDFILENAME) - 4)"/>
                                                
                                                <xsl:variable name="ONTOPFILENAME"    select="concat($ISSUENAME,'.ontop')"/>
                                                <xsl:variable name="ONTOPFILE"        select="concat($_THISDIFFPATH, '/', $ONTOPFILENAME)"/>

                                                <xsl:variable name="DIFFAMOUNT"       select="./build/message[1]"/>
                                                <xsl:variable name="ISKPIX"           select="contains($DIFFAMOUNT,'Kpix')"/>
                                                
                                                <xsl:variable name="KNOWNISSUETYPE"        select="$_STAT_KNOWNISSUESFILE_UNC/KnownIssues/issue[@name=$ISSUENAME]/@type"/>
                                                <xsl:variable name="KNOWNISSUEDIFF"        select="$_STAT_KNOWNISSUESFILE_UNC/KnownIssues/issue[@name=$ISSUENAME]/@diff"/>
                                                <xsl:variable name="KNOWNISSUECHECKED"     select="$_STAT_KNOWNISSUESFILE_UNC/KnownIssues/issue[@name=$ISSUENAME]/@checked"/>
                                                <xsl:variable name="KNOWNISSUECOMMENT"     select="$_STAT_KNOWNISSUESFILE_UNC/KnownIssues/issue[@name=$ISSUENAME]/@comment"/>
      

                                                <xsl:variable name="ISSUELOG">
                                                    <xsl:choose>
                                                        <xsl:when test="$_STAT_KNOWNISSUESFILE_UNC/KnownIssues/issue[@name=$ISSUENAME]/@log = ''">
                                                            ---
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$_STAT_KNOWNISSUESFILE_UNC/KnownIssues/issue[@name=$ISSUENAME]/@log"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>

                                                <xsl:variable name="ISSUESTYLE">
                                                    <xsl:choose>
                                                        <xsl:when test="$ISKPIX">
                                                            <xsl:value-of select="'Bold'"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'Normal'"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>

                                                <xsl:variable name="KNOWNISSUECOLOR">
                                                    <xsl:choose>
                                                        <xsl:when test="$KNOWNISSUETYPE = 'IGNORE'">
                                                            <xsl:value-of select="'DarkGray'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KNOWNISSUETYPE = 'NOISE'">
                                                            <xsl:value-of select="'Gray'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KNOWNISSUETYPE = 'KNOWN'">
                                                            <xsl:value-of select="'Green'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KNOWNISSUETYPE = 'TODO'">
                                                            <xsl:value-of select="'Blue'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KNOWNISSUETYPE = 'QA'">
                                                            <xsl:value-of select="'Green'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KNOWNISSUETYPE = 'WATCH'">
                                                            <xsl:value-of select="'Red'"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'Black'"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                
                                                <tr>
                                                    <td>
                                                        <xsl:variable name="FIRSTISSUEDESCRIPTION" select="./build/message/@description[1]"/>
                                                        <span style="color: {$KNOWNISSUECOLOR}; font-weight: {$ISSUESTYLE}">
                                                            <xsl:choose>
                                                                <xsl:when test="$FIRSTISSUEDESCRIPTION = 'Visual Compare' or $FIRSTISSUEDESCRIPTION = ''">
                                                                    <xsl:element name="a">
                                                                        <xsl:attribute name="href"><xsl:value-of select="$ONTOPFILE"/></xsl:attribute>
                                                                        <xsl:value-of select="$ISSUENAME"/>
                                                                    </xsl:element>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="$ISSUENAME"/>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                         </span>
                                                    </td>
                                                    <td>
                                                        <xsl:for-each select="./build/message">
                                                            <xsl:variable name="ISSUEDESCRIPTION" select="./@description"/>
                                                            <xsl:variable name="DESCRIPTIONCOLOR">
                                                                <xsl:choose>
                                                                    <xsl:when test="$ISSUEDESCRIPTION = 'Visual Compare' or $ISSUEDESCRIPTION = ''">
                                                                        <xsl:value-of select="'Black'"/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:value-of select="'Red'"/>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:variable>
                                                            <span style="color: {$DESCRIPTIONCOLOR}; font-weight: {$ISSUESTYLE}">
                                                                <xsl:value-of select="$ISSUEDESCRIPTION"/>&#160;
                                                            </span>
                                                        </xsl:for-each>
                                                    </td>
                                                    <td>
                                                        <span style="color: {$KNOWNISSUECOLOR}; font-weight: {$ISSUESTYLE}">
                                                            <xsl:value-of select="$DIFFAMOUNT"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span style="color: {$KNOWNISSUECOLOR}; font-weight: {$ISSUESTYLE}">
                                                            <xsl:value-of select="$KNOWNISSUEDIFF"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span style="color: {$KNOWNISSUECOLOR}; font-weight: {$ISSUESTYLE}">
                                                            <xsl:value-of select="$KNOWNISSUETYPE"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span style="color: {$KNOWNISSUECOLOR}; font-weight: {$ISSUESTYLE}">
                                                            <xsl:value-of select="$KNOWNISSUECHECKED"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span style="color: {$KNOWNISSUECOLOR}; font-weight: {$ISSUESTYLE}">
                                                            <xsl:value-of select="$KNOWNISSUECOMMENT"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <xsl:if test="not($ISSUELOG = '---')">
                                                            <xsl:element name="a">
                                                                <xsl:attribute name="href"><xsl:value-of select="concat('https://packagingandcolor.atlassian.net/browse/',$ISSUELOG)"/></xsl:attribute>
                                                                <xsl:value-of select="$ISSUELOG"/>
                                                            </xsl:element>
                                                        </xsl:if>
                                                    </td>
                                                </tr>
                                            </xsl:if>

                                        </xsl:for-each>

                                        <xsl:for-each select="$_STAT_KNOWNISSUESFILE_UNC/KnownIssues/issue[@task=$_THISTASK]">

                                            <xsl:variable name="KDNAME"        select="@name"/>
                                            <xsl:variable name="KDTYPE"        select="@type"/>
                                            <xsl:variable name="KDCHECKED"     select="@checked"/>
                                            <xsl:variable name="KDCOMMENT"     select="@comment"/>
                                            <xsl:variable name="KDLOG"         select="@log"/>


                                                <xsl:variable name="KDCOLOR">
                                                    <xsl:choose>
                                                        <xsl:when test="$KDTYPE = 'IGNORE'">
                                                            <xsl:value-of select="'DarkGray'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KDTYPE = 'NOISE'">
                                                            <xsl:value-of select="'Gray'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KDTYPE = 'KNOWN'">
                                                            <xsl:value-of select="'Green'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KDTYPE = 'TODO'">
                                                            <xsl:value-of select="'Blue'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KDTYPE = 'QA'">
                                                            <xsl:value-of select="'Green'"/>
                                                        </xsl:when>
                                                        <xsl:when test="$KDTYPE = 'WATCH'">
                                                            <xsl:value-of select="'Red'"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'Black'"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>

                                             <xsl:if test="not($KDCOMMENT = '') and not($_STAT_TESTREPORTCOMMONFILE_UNC/NMTCompareReport/testqueue[@name=$_THISTASK]/inputfile[@name=concat($KDNAME,'.pdf')]/build[@changes='true'])">
                                            
  
                                                
                                                <tr style="color: {$KDCOLOR};">
                                                    <td>
                                                        <xsl:value-of select="$KDNAME"/>
                                                    </td>
                                                    <td>
                                                        -
                                                    </td>
                                                    <td>
                                                        -
                                                    </td>
                                                    <td>
                                                        -
                                                    </td>
                                                    <td>
                                                        <xsl:value-of select="$KDTYPE"/>
                                                    </td>
                                                    <td>
                                                        <xsl:value-of select="$KDCHECKED"/>
                                                    </td>
                                                    <td>
                                                        <xsl:value-of select="$KDCOMMENT"/>
                                                    </td>
                                                    <td>
                                                        <xsl:value-of select="$KDLOG"/>
                                                    </td>
                                                </tr>
                                            </xsl:if> 
                                        </xsl:for-each>

                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br/><hr/>

                </xsl:for-each>
                    
                <br/><hr/>
                
                <a name="Links"></a>
                <table style="border-spacing: 5px 0px; font-size:80%; text-align: left; width: 80vw">
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
                       <!--  <tr>
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
                    </tbody>
                </table>
                        
            </body>
        </html>
    </xsl:template>


</xsl:stylesheet>
