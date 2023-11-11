xquery version "3.0";


(: Module :)
module namespace dc                 = "http://dataconverters.28.io/dataconverters";

(: Imports :)
import module namespace dcerr       = "http://dataconverters.28.io/errors";
import module namespace ejn         = "http://dataconverters.28.io/ejn";
import module namespace ejx         = "http://dataconverters.28.io/ejx.jq";
import module namespace functx      = "http://www.functx.com";
import module namespace html        = "http://www.zorba-xquery.com/modules/converters/html";
import module namespace jc          = "http://zorba.io/modules/json-csv";
import module namespace jx          = "http://zorba.io/modules/json-xml";
import module namespace x           = "http://zorba.io/modules/xml";
import module namespace xslt        = "http://www.zorba-xquery.com/modules/languages/xslt";

(: Public functions :)
(:
   Based on Zorba.io, John Snelson, and XForms 2.0 (revision: March 18, 2015) proposals:
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/csv/
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/json/
    * http://john.snelson.org.uk/post/48547628468/parsing-json-into-xquery
    * http://www.w3.org/MarkUp/Forms/wiki/XForms_2.0#External_CSV_values
   
   RFC 4180:
    * http://tools.ietf.org/html/rfc4180

   RFC 7159:
    * http://tools.ietf.org/html/rfc7159
:)
declare %public function dc:parse-csv-to-xml( $csvString as xs:string, $header as xs:string, $separator as xs:string, $quote as xs:string, $rt as xs:string, $encode as xs:string ) as document-node() {
    let $zorbaXml   := dc:csv-string-to-zorba-xml( $csvString, $header, $separator, $quote )
    let $uniqueXml  := dc:csv-zorba-xml-to-unique-xml( $csvString, $zorbaXml, $header, $separator, $quote, $rt, $encode )
    return
        $uniqueXml
};

(:
   Based on Zorba.io and HTML Tidy proposals:
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/html/
    * http://tidy.sourceforge.net/
    
   HTML Tidy reference:
    * http://tidy.sourceforge.net/docs/quickref.html
:)
declare %public function dc:parse-html-to-xml( $htmlString as xs:string ) as document-node() {
    let $uniqueXml  := dc:html-string-to-zorba-xml( $htmlString )
    return
        $uniqueXml
};

(:
   Based on Zorba.io, John Snelson, and XForms 2.0 (revision: March 18, 2015) proposals:
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/json/
    * http://john.snelson.org.uk/post/48547628468/parsing-json-into-xquery
    * http://www.w3.org/MarkUp/Forms/wiki/XForms_2.0#External_JSON_values
    
   RFC 7159:
    * http://tools.ietf.org/html/rfc7159
:)
declare %public function dc:parse-json-to-xml( $jsonString as xs:string, $rfc7159 as xs:string, $rt as xs:string, $encode as xs:string ) as document-node() {
    let $zorbaXml   := dc:json-string-to-zorba-xml( $jsonString, $rfc7159 )
    let $uniqueXml  := dc:json-zorba-xml-to-unique-xml( $zorbaXml, $rt, $encode )
    return
        $uniqueXml
};

(:
   Based on Zorba.io and libxml2 proposals:
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/xml/
    * http://xmlsoft.org/html/libxml-parser.html
:)
declare %public function dc:parse-xml-to-xml( $xmlString as xs:string ) as document-node() {
    let $uniqueXml  := dc:xml-string-to-zorba-xml( $xmlString )
    return
        $uniqueXml
};

(: Private functions :)
(:
   Based on Zorba.io, John Snelson, and XForms 2.0 (revision: March 18, 2015) proposals:
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/csv/
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/json/
    * http://john.snelson.org.uk/post/48547628468/parsing-json-into-xquery
    * http://www.w3.org/MarkUp/Forms/wiki/XForms_2.0#External_CSV_values
   
   RFC 4180:
    * http://tools.ietf.org/html/rfc4180

   RFC 7159:
    * http://tools.ietf.org/html/rfc7159
:)
declare %private function dc:csv-string-to-zorba-xml( $csvString as xs:string, $header as xs:string, $separator as xs:string, $quote as xs:string ) as element() {
    let $csvOptions                 :=
        if ( $header = "present" ) then
            {
                "cast-unquoted-values": true,       (: Should field values be casted? :)
                "missing-value": "null",            (: Default value for missing field values. Transform it later to "" as that option is not available :)
                "quote-char": $quote,               (: Enclosing character for field values :)
                "quote-escape": $quote,             (: Escaping character for using enclosing character within field values :)
                "separator": $separator             (: Field value separator :)
            }
        else
            {
                "cast-unquoted-values": true,   (: Should field values be casted? :)
                "extra-name": "v#",             (: Header names for missing header names :)
                "field-names": [ "v1" ],        (: Header names :)
                "missing-value": "null",        (: Default value for missing field values. Transform it later to "" as that option is not available :)
                "quote-char": $quote,           (: Enclosing character for field values :)
                "quote-escape": $quote,         (: Escaping character for using enclosing character within field values :)
                "separator": $separator         (: Field value separator :)
            }
    return
        try {
            <csv>
                {
                    for $json in jc:parse( $csvString, $csvOptions )
                        return
                            jx:json-to-xml( $json )
                }
            </csv>
        } catch * {
            error( xs:QName( $dcerr:DC0001 ), $dcerr:DC0001_MESSAGE )
        }
};

(:
   Based on XForms 2.0 (revision: March 18, 2015) proposal:
    * http://www.w3.org/MarkUp/Forms/wiki/XForms_2.0#External_CSV_values
   
   RFC 4180:
    * http://tools.ietf.org/html/rfc4180
:)
declare %private function dc:csv-zorba-xml-to-unique-xml( $csvString as xs:string, $element as element(), $header as xs:string, $separator as xs:string, $quote as xs:string, $rt as xs:string, $encode as xs:string ) as document-node() {
    try {
        let $stylesheet             :=
            <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:js="http://john.snelson.org.uk/parsing-json-into-xquery" exclude-result-prefixes="js">
                 <!-- Define variables -->
                <xsl:variable name="vCsvString">{ $csvString }</xsl:variable>
                <xsl:variable name="vHeader">{ $header }</xsl:variable>
                <xsl:variable name="vSeparator">{ $separator }</xsl:variable>
                <xsl:variable name="vQuote">{ $quote }</xsl:variable>
                <xsl:variable name="vRt">{ $rt }</xsl:variable>
                <xsl:variable name="vEncode">{ $encode }</xsl:variable>
                <xsl:variable name="vUnderscores" select="'_______________________________________________________'" />
                <xsl:variable name="vColon" select="':'" />
                <xsl:variable name="vUpper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
                <xsl:variable name="vUnderscore" select="'_'" />
                <xsl:variable name="vLower" select="'abcdefghijklmnopqrstuvwxyz'" />
                <xsl:variable name="vDash" select="'-'" />
                <xsl:variable name="vPeriod" select="'.'" />
                <xsl:variable name="vDigits" select="'0123456789'" />
                <xsl:variable name="vNameStartChar" select="concat( $vUpper, $vUnderscore, $vLower )" />
                <!--<xsl:variable name="vNameStartChar" select="concat( $vColon, $vUpper, $vUnderscore, $vLower )" />-->
                <xsl:variable name="vNameChar" select="concat( $vNameStartChar, $vDash, $vPeriod, $vDigits )" />
                <xsl:variable name="vXMLUpper" select="'XML'" />
                <xsl:variable name="vXMLLower" select="'xml'" />
    
                <!-- Define the output format -->
                <xsl:output method="xml" version="1.0" />
    
                <!-- Identity transform all attributes and nodes -->
                <xsl:template match="@*|node()">
        	        <xsl:copy>
    			        <xsl:apply-templates select="@*|node()" />
    		        </xsl:copy>
    	        </xsl:template>

                <!-- Csv element -->
                <xsl:template match="/csv">
                    <!-- Create new element -->
                    <xsl:element name="csv">
                        <!-- Add the separator attribute if needed -->
                        <xsl:if test="$vRt = 'yes'">
                        	<xsl:attribute name="separator"><xsl:value-of select="$vSeparator" /></xsl:attribute>
        				</xsl:if>
                        <!-- Add the quote attribute if needed -->
                        <xsl:if test="$vRt = 'yes'">
                        	<xsl:attribute name="quote"><xsl:value-of select="$vQuote" /></xsl:attribute>
        				</xsl:if>
                        <xsl:choose>
                            <xsl:when test="$vHeader = 'present' and not( * )">
                                <!-- Define variables -->
                                <xsl:variable name="vCsvStringReplaced">
                                    <xsl:call-template name="stringReplace">
                                        <xsl:with-param name="pString" select="$vCsvString" />
                                        <xsl:with-param name="pReplace" select="concat( $vQuote, $vQuote )" />
                                    </xsl:call-template>
                                </xsl:variable>
                                <!-- Create new element -->
                                <xsl:element name="h">                                
                                    <xsl:call-template name="tokenizeHeaderString">
                                        <xsl:with-param name="pString" select="$vCsvStringReplaced" />
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Apply further templates -->
                                <xsl:apply-templates />                                
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:template>

                <!-- Json element -->
                <xsl:template match="//js:json | //json">
                    <!-- First record row -->
                    <xsl:if test="$vHeader = 'present' and count( preceding-sibling::js:json | preceding-sibling::json ) = 0">
                        <!-- Create new element -->
                        <xsl:element name="h">
                            <xsl:for-each select="js:pair | pair">
                                <!-- Define variables -->
                                <xsl:variable name="vElementName">
                                    <xsl:value-of select="@name" />
                                </xsl:variable>
                                <xsl:variable name="vEncodedElementName">
                                    <xsl:choose>
                                        <xsl:when test="$vEncode = 'yes'">
                                        	<xsl:call-template name="encodeElementName">
                        						<xsl:with-param name="pElementName" select="$vElementName" />
                        					</xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$vElementName" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- Create new element -->
                                <xsl:element name="{{ $vEncodedElementName }}">
                                    <xsl:value-of select="$vElementName" />
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                    <!-- Create new element -->
                    <xsl:element name="r">
                        <!-- Apply further templates -->
                        <xsl:apply-templates />
                    </xsl:element>
                </xsl:template>

                <!-- Pair element -->
                <xsl:template match="//js:pair | //pair">
                    <!-- Define variables -->
                    <xsl:variable name="vElementName">
                        <xsl:choose>
                            <xsl:when test="$vHeader = 'present'">
                                <xsl:value-of select="@name" />                        
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>v</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="vEncodedElementName">
                        <xsl:choose>
                            <xsl:when test="$vEncode = 'yes'">
                        		<xsl:call-template name="encodeElementName">
            						<xsl:with-param name="pElementName" select="$vElementName" />
            					</xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$vElementName" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- Create new element -->
                    <xsl:element name="{{ $vEncodedElementName }}">
                        <!-- Apply further templates -->
                        <xsl:apply-templates />
                    </xsl:element>
                </xsl:template>
    
                <!-- Encode element name -->
                <xsl:template name="encodeElementName">
                	<!-- Define parameters -->
            		<xsl:param name="pElementName" />
                    <!-- Define variables -->
                    <xsl:variable name="vElementName3FirstChars" select="substring( $pElementName, 1, 3 )" />
                    <!-- Prepend special cases -->
                    <xsl:variable name="vPrependedElementName">
                        <xsl:choose>
                            <!-- Element must have a name -> use underscore if needed -->
                            <xsl:when test="string-length( $pElementName ) = 0">
                                <xsl:text>_</xsl:text>
                            </xsl:when>
                            <!-- Element name's three first characters must not contain the word XML -> prepend with underscore if needed -->
                            <xsl:when test="string-length( $pElementName ) &gt;= 3 and translate( $vElementName3FirstChars, $vXMLUpper, $vXMLLower ) = $vXMLLower">
                                <xsl:value-of select="concat( '_', $pElementName )" />
                            </xsl:when>
                            <!-- Element name OK -->
                            <xsl:otherwise>
                                <xsl:value-of select="$pElementName" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- Replace illegal element name characters with underscore -->
                    <xsl:variable name="vAlmostLegalElementName">
                        <!-- Remove legal characters in the prepended element name -->
                        <xsl:variable name="vIllegalCharsInPrependedElementName" select="translate( $vPrependedElementName, $vNameChar, '' )" />
                        <!-- Replace illegal characters with underscore, i.e., apply the underscores hack: http://stackoverflow.com/questions/131619/restrict-a-string-to-whitelisted-characters-using-xslt-1-0 -->
                        <xsl:value-of select="translate( $vPrependedElementName, $vIllegalCharsInPrependedElementName, $vUnderscores )" />                    
                    </xsl:variable>
                    <!-- Prepend illegal element name start character with underscore -->
                    <xsl:variable name="vLegalElementName">
                        <xsl:variable name="vAlmostLegalElementNameStartChar" select="substring( $vAlmostLegalElementName, 1, 1 )" />                
                        <xsl:variable name="vLegalElementNameRestChars" select="substring( $vAlmostLegalElementName, 2 )" />
                        <!-- Remove legal characters in the almost legal element name start char -->
                        <xsl:variable name="vIllegalCharInAlmostLegalElementNameStartChar" select="translate( $vAlmostLegalElementNameStartChar, $vNameStartChar, '' )" />
                        <!-- Prepend an illegal start character with underscore -->
                        <xsl:variable name="vLegalElementNameStartChar">
                            <xsl:choose>
                                <!-- Does not contain an illegal character -->
                                <xsl:when test="string-length( $vIllegalCharInAlmostLegalElementNameStartChar ) = 0">
                                    <xsl:value-of select="$vAlmostLegalElementNameStartChar" />
                                </xsl:when>
                                <!-- Contains an illegal character -->
                                <xsl:otherwise>
                                    <xsl:value-of select="concat( '_', $vAlmostLegalElementNameStartChar )" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="concat( $vLegalElementNameStartChar, $vLegalElementNameRestChars )" />
                    </xsl:variable>
                    <xsl:value-of select="$vLegalElementName" />                
                </xsl:template>

                <!-- Tokenize header string in XSLT 1.0: http://www.heber.it/?p=1088 -->
                <!-- Todo: Remove all leading and trailing quote characters -->
                <xsl:template name="tokenizeHeaderString">
                    <!-- Define parameters -->
                    <xsl:param name="pString" />
                    <!-- Tokenize header string -->
                    <xsl:choose>
                        <xsl:when test="contains( $pString, $vSeparator )">
                            <!-- Define variables -->
                            <xsl:variable name="vElementName">
                                <xsl:value-of select="substring-before( $pString, $vSeparator )" />
                            </xsl:variable>
                            <xsl:variable name="vEncodedElementName">
                                <xsl:choose>
                                    <xsl:when test="$vEncode = 'yes'">
                                        <xsl:call-template name="encodeElementName">
                        					<xsl:with-param name="pElementName" select="$vElementName" />
                    					</xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$vElementName" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <!-- Create new element -->
                            <xsl:element name="{{ $vEncodedElementName }}">
                                <!-- Get everything in front of the first separator -->
                                <xsl:value-of select="$vElementName" />
                            </xsl:element>
                            <xsl:call-template name="tokenizeHeaderString">
                                <!-- Store anything left in another variable -->
                                <xsl:with-param name="pString" select="substring-after( $pString, $vSeparator )" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$pString = ''">
                                    <xsl:text />
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- Define variables -->
                                    <xsl:variable name="vElementName2">
                                        <xsl:value-of select="$pString" />
                                    </xsl:variable>
                                    <xsl:variable name="vEncodedElementName2">
                                        <xsl:choose>
                                            <xsl:when test="$vEncode = 'yes'">
                                                <xsl:call-template name="encodeElementName">
                                    				<xsl:with-param name="pElementName" select="$vElementName2" />
                            					</xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$vElementName2" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!-- Create new element -->
                                    <xsl:element name="{{ $vEncodedElementName2 }}">
                                        <xsl:value-of select="$vElementName2" />
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:template>  

                <!-- String replace in XSLT 1.0: http://stackoverflow.com/questions/7520762/xslt-1-0-string-replace-function -->
                <xsl:template name="stringReplace">
                    <!-- Define parameters -->
                    <xsl:param name="pString" />
                    <xsl:param name="pReplace" />
                    <xsl:choose>
                        <xsl:when test="contains( $pString, $pReplace )">
                            <xsl:value-of select="substring-before( $pString, $pReplace )" />
                            <xsl:value-of select="$vQuote" />
                            <xsl:call-template name="stringReplace">
                                <xsl:with-param name="pString" select="substring-after( $pString, $pReplace )" />
                                <xsl:with-param name="pReplace" select="$pReplace" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$pString" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:template>
  
            </xsl:stylesheet>
        return
            document { xslt:transform( $element, $stylesheet ) }
    } catch * {
        error( xs:QName( $dcerr:DC0002 ), $dcerr:DC0002_MESSAGE )
    }
};

(:
   Based on Zorba.io and HTML Tidy proposals:
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/html/
    * http://tidy.sourceforge.net/
    
   HTML Tidy reference:
    * http://tidy.sourceforge.net/docs/quickref.html
:)
declare %private function dc:html-string-to-zorba-xml( $htmlString as xs:string ) as document-node() {
    let $htmlTidyOptions            :=
        <options xmlns="http://www.zorba-xquery.com/modules/converters/html-options">
            <tidyParam name="char-encoding" value="utf8" />
            <tidyParam name="doctype" value="omit" />
            <tidyParam name="indent" value="yes" />
            <tidyParam name="new-blocklevel-tags" value="article,aside,audio,canvas,datalist,details,dialog,figcaption,figure,footer,header,hgroup,main,menu,nav,picture,ruby,section,summary,template,video" />
            <tidyParam name="new-empty-tags" value="command,embed,keygen,menuitem,source,track,wbr" />
            <tidyParam name="new-inline-tags" value="bdi,data,mark,meter,output,progress,rb,rp,rt,rtc,time" />
            <tidyParam name="newline" value="LF" />
            <tidyParam name="output-xml" value="yes" />
            <tidyParam name="quote-nbsp" value="no" />
            <tidyParam name="tidy-mark" value="no" />
            <tidyParam name="wrap" value="0" />
        </options>
        (:<tidyParam name="new-pre-tags" value="" />:)
    return
        try {
            document { html:parse( $htmlString, $htmlTidyOptions )/* }
        } catch * {
            error( xs:QName( $dcerr:DC0101 ), $dcerr:DC0101_MESSAGE )            
        }
};

(:
   Based on Zorba.io and John Snelson proposals:
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/json/
    * http://john.snelson.org.uk/post/48547628468/parsing-json-into-xquery
    
   RFC 7159:
    * http://tools.ietf.org/html/rfc7159
:)
declare %private function dc:json-string-to-zorba-xml( $jsonString as xs:string, $rfc7159 as xs:string ) as element() {
    try {
        if ( $rfc7159 = 'yes' ) then
            (: Use RFC 7159 compliant JSON parser, rather than RFC 4627 compliant JSON parser :)
            ejx:json-to-xml( ejn:parse-json( $jsonString ) )
        else
            jx:json-to-xml( jn:parse-json( $jsonString ) )
    } catch * {
        error( xs:QName( $dcerr:DC0201 ), $dcerr:DC0201_MESSAGE )
    }
};

(:
   Based on XForms 2.0 (revision: March 18, 2015) proposal:
    * http://www.w3.org/MarkUp/Forms/wiki/XForms_2.0#External_JSON_values
    
   RFC 7159:
    * http://tools.ietf.org/html/rfc7159
:)
declare %private function dc:json-zorba-xml-to-unique-xml( $element as element(), $rt as xs:string, $encode as xs:string ) as document-node() {
    try {
        let $stylesheet             :=
            <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:js="http://john.snelson.org.uk/parsing-json-into-xquery" exclude-result-prefixes="js">
    
                 <!-- Define variables -->
                <xsl:variable name="vRt">{ $rt }</xsl:variable>
                <xsl:variable name="vEncode">{ $encode }</xsl:variable>
                <xsl:variable name="vUnderscores" select="'_______________________________________________________'" />
                <xsl:variable name="vColon" select="':'" />
                <xsl:variable name="vUpper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
                <xsl:variable name="vUnderscore" select="'_'" />
                <xsl:variable name="vLower" select="'abcdefghijklmnopqrstuvwxyz'" />
                <xsl:variable name="vDash" select="'-'" />
                <xsl:variable name="vPeriod" select="'.'" />
                <xsl:variable name="vDigits" select="'0123456789'" />
                <xsl:variable name="vNameStartChar" select="concat( $vUpper, $vUnderscore, $vLower )" />
                <!--<xsl:variable name="vNameStartChar" select="concat( $vColon, $vUpper, $vUnderscore, $vLower )" />-->
                <xsl:variable name="vNameChar" select="concat( $vNameStartChar, $vDash, $vPeriod, $vDigits )" />
                <xsl:variable name="vXMLUpper" select="'XML'" />
                <xsl:variable name="vXMLLower" select="'xml'" />
    
                <!-- Define the output format -->
                <xsl:output method="xml" version="1.0" />
    
                <!-- Identity transform all attributes and nodes -->
                <xsl:template match="@*|node()">
    		        <xsl:copy>
    			        <xsl:apply-templates select="@*|node()" />
    		        </xsl:copy>
    	        </xsl:template>

                <!-- Json element -->
                <xsl:template match="/js:json | /json">
                    <!-- Define variables -->
                    <xsl:variable name="vElementName">
                        <xsl:value-of select="local-name( . )" />
                    </xsl:variable>
                    <!-- Create new element -->
                    <xsl:element name="{{ $vElementName }}">
                        <!-- Add the array attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and @type = 'array' and not( * )">
            				<xsl:attribute name="array">true</xsl:attribute>
        				</xsl:if>
                        <!-- Add the object attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and @type = 'object'">
                			<xsl:attribute name="object">true</xsl:attribute>
        				</xsl:if>
                        <!-- Add the type attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and not( @type = 'array' or @type = 'object' )">
                    		<xsl:attribute name="type"><xsl:value-of select="@type" /></xsl:attribute>
        				</xsl:if>
                        <!-- Apply further templates -->
                        <xsl:apply-templates />
                    </xsl:element>
                </xsl:template>
    
                <!-- Pair element: non array -->
                <xsl:template match="//js:pair[ not( @type = 'array' ) ] | //pair[ not( @type = 'array' ) ]">
                    <!-- Define variables -->
                    <xsl:variable name="vElementName">
                        <xsl:value-of select="@name" />
                    </xsl:variable>
                    <xsl:variable name="vEncodedElementName">
                        <xsl:choose>
                            <xsl:when test="$vEncode = 'yes'">
                    			<xsl:call-template name="encodeElementName">
            						<xsl:with-param name="pElementName" select="$vElementName" />
            					</xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$vElementName" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- Create new element -->
                    <xsl:element name="{{ $vEncodedElementName }}">
                        <!-- Add the name attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and not( $vElementName = $vEncodedElementName )">
                        	<xsl:attribute name="name"><xsl:value-of select="$vElementName" /></xsl:attribute>
        				</xsl:if>
                        <!-- Add the array attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and ../@type = 'array'">
            				<xsl:attribute name="array">true</xsl:attribute>
        				</xsl:if>
                        <!-- Add the object attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and @type = 'object'">
                			<xsl:attribute name="object">true</xsl:attribute>
        				</xsl:if>
                        <!-- Add the type attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and not( @type = 'array' or @type = 'object' )">
                    		<xsl:attribute name="type"><xsl:value-of select="@type" /></xsl:attribute>
        				</xsl:if>
                        <!-- Apply further templates -->
                        <xsl:apply-templates />
                    </xsl:element>
                </xsl:template>
    
                <!-- Pair element: array -->
                <xsl:template match="//js:pair[ @type = 'array' ] | //pair[ @type = 'array' ]">
                    <xsl:choose>
                        <!-- Empty array -->
                        <xsl:when test="not( * )">
                            <!-- Define variables -->
                            <xsl:variable name="vElementName">
                                <xsl:value-of select="@name" />
                            </xsl:variable>
                            <xsl:variable name="vEncodedElementName">
                                <xsl:choose>
                                    <xsl:when test="$vEncode = 'yes'">
                                    	<xsl:call-template name="encodeElementName">
                    						<xsl:with-param name="pElementName" select="$vElementName" />
                    					</xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$vElementName" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <!-- Create new element -->
                            <xsl:element name="{{ $vEncodedElementName }}">
                                <!-- Add the name attribute if needed -->
                                <xsl:if test="$vRt = 'yes' and not( $vElementName = $vEncodedElementName )">
                                    <xsl:attribute name="name"><xsl:value-of select="$vElementName" /></xsl:attribute>
                				</xsl:if>
                                <!-- Add the array attribute if needed -->
                                <xsl:if test="$vRt = 'yes' and @type = 'array'">
                        			<xsl:attribute name="array">true</xsl:attribute>
                				</xsl:if>
                                <!-- Add the type attribute if needed -->
                                <xsl:if test="$vRt = 'yes' and not( @type = 'array' or @type = 'object' )">
                                	<xsl:attribute name="type"><xsl:value-of select="@type" /></xsl:attribute>
                				</xsl:if>
                            </xsl:element>
                        </xsl:when>
                        <!-- Non-empty array -->
                        <xsl:otherwise>
                            <!-- Apply further templates -->
                            <xsl:apply-templates />                        
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:template>
    
                <!-- Item element -->
                <xsl:template match="//js:item | //item">
                    <!-- Define variables -->
                    <xsl:variable name="vElementName">
                        <xsl:choose>
                            <xsl:when test="../@name">
                                <xsl:value-of select="../@name" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text></xsl:text>                            
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="vEncodedElementName">
                        <xsl:choose>
                            <xsl:when test="$vEncode = 'yes'">
                        		<xsl:call-template name="encodeElementName">
            						<xsl:with-param name="pElementName" select="$vElementName" />
            					</xsl:call-template>                        
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <!-- Case: anonymous array -->
                                    <xsl:when test="string-length( $vElementName ) = 0">
                                        <xsl:text>_</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$vElementName" />                                
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- Create new element -->
                    <xsl:element name="{{ $vEncodedElementName }}">
                        <!-- Add the name attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and not( $vElementName = $vEncodedElementName )">
                        	<xsl:attribute name="name"><xsl:value-of select="$vElementName" /></xsl:attribute>
        				</xsl:if>
                        <!-- Add the array attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and ../@type = 'array'">
            				<xsl:attribute name="array">true</xsl:attribute>
        				</xsl:if>
                        <!-- Add the object attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and @type = 'object'">
                			<xsl:attribute name="object">true</xsl:attribute>
        				</xsl:if>
                        <!-- Add the type attribute if needed -->
                        <xsl:if test="$vRt = 'yes' and not( @type = 'array' or @type = 'object' )">
                    		<xsl:attribute name="type"><xsl:value-of select="@type" /></xsl:attribute>
        				</xsl:if>
                        <!-- Apply further templates -->
                        <xsl:apply-templates />
                    </xsl:element>
                </xsl:template>
    
                <!-- Encode element name -->
                <xsl:template name="encodeElementName">
                	<!-- Define parameters -->
            		<xsl:param name="pElementName" />
                    <!-- Define variables -->
                    <xsl:variable name="vElementName3FirstChars" select="substring( $pElementName, 1, 3 )" />
                    <!-- Prepend special cases -->
                    <xsl:variable name="vPrependedElementName">
                        <xsl:choose>
                            <!-- Element must have a name -> use underscore if needed -->
                            <xsl:when test="string-length( $pElementName ) = 0">
                                <xsl:text>_</xsl:text>
                            </xsl:when>
                            <!-- Element name's three first characters must not contain the word XML -> prepend with underscore if needed -->
                            <xsl:when test="string-length( $pElementName ) &gt;= 3 and translate( $vElementName3FirstChars, $vXMLUpper, $vXMLLower ) = $vXMLLower">
                                <xsl:value-of select="concat( '_', $pElementName )" />
                            </xsl:when>
                            <!-- Element name OK -->
                            <xsl:otherwise>
                                <xsl:value-of select="$pElementName" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- Replace illegal element name characters with underscore -->
                    <xsl:variable name="vAlmostLegalElementName">
                        <!-- Remove legal characters in the prepended element name -->
                        <xsl:variable name="vIllegalCharsInPrependedElementName" select="translate( $vPrependedElementName, $vNameChar, '' )" />
                        <!-- Replace illegal characters with underscore, i.e., apply the underscores hack: http://stackoverflow.com/questions/131619/restrict-a-string-to-whitelisted-characters-using-xslt-1-0 -->
                        <xsl:value-of select="translate( $vPrependedElementName, $vIllegalCharsInPrependedElementName, $vUnderscores )" />                    
                    </xsl:variable>
                    <!-- Prepend illegal element name start character with underscore -->
                    <xsl:variable name="vLegalElementName">
                        <xsl:variable name="vAlmostLegalElementNameStartChar" select="substring( $vAlmostLegalElementName, 1, 1 )" />                
                        <xsl:variable name="vLegalElementNameRestChars" select="substring( $vAlmostLegalElementName, 2 )" />
                        <!-- Remove legal characters in the almost legal element name start char -->
                        <xsl:variable name="vIllegalCharInAlmostLegalElementNameStartChar" select="translate( $vAlmostLegalElementNameStartChar, $vNameStartChar, '' )" />
                        <!-- Prepend an illegal start character with underscore -->
                        <xsl:variable name="vLegalElementNameStartChar">
                            <xsl:choose>
                                <!-- Does not contain an illegal character -->
                                <xsl:when test="string-length( $vIllegalCharInAlmostLegalElementNameStartChar ) = 0">
                                    <xsl:value-of select="$vAlmostLegalElementNameStartChar" />
                                </xsl:when>
                                <!-- Contains an illegal character -->
                                <xsl:otherwise>
                                    <xsl:value-of select="concat( '_', $vAlmostLegalElementNameStartChar )" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="concat( $vLegalElementNameStartChar, $vLegalElementNameRestChars )" />
                    </xsl:variable>
                    <xsl:value-of select="$vLegalElementName" />                
                </xsl:template>
    
            </xsl:stylesheet>
        return
            document { xslt:transform( $element, $stylesheet ) }
    } catch * {
        error( xs:QName( $dcerr:DC0202 ), $dcerr:DC0202_MESSAGE )
    }
};

(:
   Based on Zorba.io and libxml2 proposals:
    * http://zorba.28.io/documentation/latest/modules/zorba/data-converters/xml/
    * http://xmlsoft.org/html/libxml-parser.html
:)
declare %private function dc:xml-string-to-zorba-xml( $xmlString as xs:string ) as document-node() {
    let $libxml2Options             :=
        <options xmlns="http://zorba.io/modules/xml-options">
            <substitute-entities />
            <remove-redundant-ns />
        </options>
    return
        try {
            document { x:parse( $xmlString, $libxml2Options )/* }
        } catch * {
            error( xs:QName( $dcerr:DC0301 ), $dcerr:DC0301_MESSAGE )            
        }
};

(:
   Encode special characters etc.

   XForms 2.0 JSON-to-XML Mapping:
    * http://www.w3.org/MarkUp/Forms/wiki/XForms_2.0#External_JSON_values
    * http://www.w3.org/TR/xforms20/#External_JSON_values
    * http://www.w3.org/MarkUp/Forms/wiki/Json
:)
declare %private function dc:encode-element-name( $element-name as xs:string? ) as xs:string {
    (: Serialize :)
    let $stringElementName          :=
        if ( empty( $element-name ) = true() ) then
            ""
        else
            $element-name
    (: Prepend special cases :)
    let $prependedElementName       :=
        (: Element must have a name --> use underscore :)
        if ( string-length( $stringElementName ) = 0 ) then
            "_"
        (: Element name's first character must be allowed --> prepend with underscore :)
        else if ( string-length( $stringElementName ) = 1 and matches( $stringElementName, "[\I:]" ) ) then
            concat( "_", $stringElementName )
        (: Element name's three first characters must not contain the word XML --> prepend with underscore :)
        else if ( string-length( $stringElementName ) >= 3 and matches( $stringElementName, "^[Xx][Mm][Ll]" ) ) then
            concat( "_", $stringElementName )
        (: Element name OK :)
        else
            $stringElementName
    (: Encode special characters with underscore :)
    let $firstCharacter             := functx:replace-multi( substring( $prependedElementName, 1, 1 ), ( "\I", ":" ), ( "_", "_" ) )
    let $latterCharacters           := functx:replace-multi( substring( $prependedElementName, 2 ), ( "\C", ":" ), ( "_", "_" ) )
    let $encodedElementName         := concat( $firstCharacter, $latterCharacters )
    return
        $encodedElementName
};