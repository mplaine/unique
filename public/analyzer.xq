xquery version "3.0";


(: Imports :)
import module namespace datetime    = "http://zorba.io/modules/datetime";
import module namespace dc          = "http://dataconverters.28.io/dataconverters";
import module namespace functx      = "http://www.functx.com";
import module namespace http-req    = "http://www.28msec.com/modules/http-request";
import module namespace http-res    = "http://www.28msec.com/modules/http-response";
import module namespace jx          = "http://zorba.io/modules/json-xml";
import module namespace qc          = "http://queryconverters.28.io/queryconverters";
import module namespace uqerr       = "http://unique.28.io/errors";
import module namespace zhttp       = "http://zorba.io/modules/http-client";
import module namespace zq          = "http://zorba.io/modules/zorba-query";

(: Namespaces :)
declare namespace js                = "http://john.snelson.org.uk/parsing-json-into-xquery";

(: Variables :)
declare variable $userAgent         := "Mozilla/5.0";

(: Functions :)
declare function local:get-mode( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( not( $parameterTrimmed = 'echoer' or $parameterTrimmed = 'queryconverter' or $parameterTrimmed = 'dataconverter' or $parameterTrimmed = 'processor' ) ) then
            $default
        else
            $parameterTrimmed
};

declare %an:sequential function local:get-data( $parameter as xs:string? ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        (: No data :)
        if ( empty( $parameter ) ) then
            error( xs:QName( $uqerr:UQ0401 ), $uqerr:UQ0401_MESSAGE )
        (: Data :)
        else
            (: Absolute URL data :)
            if ( $parameterTrimmed castable as xs:anyURI = true() and functx:is-absolute-uri( $parameterTrimmed ) = true() and local:is-absolute-uri( $parameterTrimmed ) = true() ) then
                let $httpResponse   :=
                    try {
                        jx:json-to-xml( zhttp:send-request( { "href": $parameterTrimmed, "options": { "user-agent": $userAgent } } ) )
                        (:jx:json-to-xml( zhttp:send-request( { "href": $parameterTrimmed, "options": { "user-agent": $userAgent }, "headers": { "Accept-Encoding": "gzip,deflate" } } ) ):)
                    } catch * {
                        error( xs:QName( $uqerr:UQ0402 ), concat( $uqerr:UQ0402_MESSAGE_1, $parameterTrimmed, $uqerr:UQ0402_MESSAGE_2 ) )
                    }
                return
                    (: HTTP request OK :)
                    if ( $httpResponse/js:pair[ @name = "status" ]/text() = "200" and $httpResponse/js:pair[ @name = "message" ]/text() = "OK" ) then
                        let $data           := $httpResponse/js:pair[ @name = "body" ]/js:pair[ @name = "content" ]/text()
                        return
                            (: No data :)
                            if ( empty( $data ) ) then
                                ''
                            (: Data :)
                            else
                                $data
                    (: Failed HTTP request :)
                    else
                        error( xs:QName( $uqerr:UQ0403 ), concat( $uqerr:UQ0403_MESSAGE_1, $parameterTrimmed, $uqerr:UQ0403_MESSAGE_2 ) )
            (: Inline text data :)
            else
                $parameter
};

declare function local:is-absolute-uri( $uri as xs:string ) as xs:boolean {
    matches( $uri, "^(http|https)://" )
};

declare function local:get-format( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( not( $parameterTrimmed = 'csv' or $parameterTrimmed = 'html' or $parameterTrimmed = 'json' or $parameterTrimmed = 'xml' ) ) then
            $default
        else
            $parameterTrimmed
};

declare function local:get-header( $header as xs:string?, $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $headerTrimmed              := functx:trim( $header )
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $header ) and empty( $parameter ) ) then
            $default
        else if ( not( $headerTrimmed = 'present' or $headerTrimmed = 'absent' or $parameterTrimmed = 'present' or $parameterTrimmed = 'absent' ) ) then
            $default
        else
            if ( $headerTrimmed = 'present' or $headerTrimmed = 'absent' ) then
                $headerTrimmed
            else
                $parameterTrimmed
};

declare function local:get-separator( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( string-length( $parameterTrimmed ) != 1 ) then
            $default
        else
            $parameterTrimmed
};

declare function local:get-quote( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( string-length( $parameterTrimmed ) != 1 ) then
            $default
        else
            $parameterTrimmed
};

declare function local:get-rfc7159( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( string-length( $parameterTrimmed ) = 0 ) then
            $default
        else if ( not( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' or $parameterTrimmed = 'n' or $parameterTrimmed = 'no' or $parameterTrimmed = 'f' or $parameterTrimmed = 'false' or $parameterTrimmed = '0' ) ) then
            $default
        else
            if ( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' ) then
                'yes'
            else
                'no'
};

declare function local:get-rt( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( string-length( $parameterTrimmed ) = 0 ) then
            $default
        else if ( not( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' or $parameterTrimmed = 'n' or $parameterTrimmed = 'no' or $parameterTrimmed = 'f' or $parameterTrimmed = 'false' or $parameterTrimmed = '0' ) ) then
            $default
        else
            if ( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' ) then
                'yes'
            else
                'no'
};

declare function local:get-encode( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( string-length( $parameterTrimmed ) = 0 ) then
            $default
        else if ( not( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' or $parameterTrimmed = 'n' or $parameterTrimmed = 'no' or $parameterTrimmed = 'f' or $parameterTrimmed = 'false' or $parameterTrimmed = '0' ) ) then
            $default
        else
            if ( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' ) then
                'yes'
            else
                'no'
};

declare function local:get-query( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( string-length( $parameterTrimmed ) = 0 ) then
            $default
        else
            $parameterTrimmed
};

declare function local:get-ns-names( $ns-prefix as xs:string ) as xs:string* {
    for $parameter in http-req:param-names()
        where
            starts-with( $parameter, $ns-prefix )
        return
            $parameter
};

declare function local:get-wrap( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( string-length( $parameterTrimmed ) = 0 ) then
            $default
        else if ( not( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' or $parameterTrimmed = 'n' or $parameterTrimmed = 'no' or $parameterTrimmed = 'f' or $parameterTrimmed = 'false' or $parameterTrimmed = '0' ) ) then
            $default
        else
            if ( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' ) then
                'yes'
            else
                'no'
};

declare function local:get-analysis( $parameter as xs:string?, $default as xs:string ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        if ( empty( $parameter ) ) then
            $default
        else if ( string-length( $parameterTrimmed ) = 0 ) then
            $default
        else if ( not( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' or $parameterTrimmed = 'n' or $parameterTrimmed = 'no' or $parameterTrimmed = 'f' or $parameterTrimmed = 'false' or $parameterTrimmed = '0' ) ) then
            $default
        else
            if ( $parameterTrimmed = 'y' or $parameterTrimmed = 'yes' or $parameterTrimmed = 't' or $parameterTrimmed = 'true' or $parameterTrimmed = '1' ) then
                'yes'
            else
                'no'
};

declare function local:convert-data( $data as xs:string, $format as xs:string, $header as xs:string, $separator as xs:string, $quote as xs:string, $rfc7159 as xs:string, $rt as xs:string, $encode as xs:string ) as document-node() {
    if ( $format = 'csv' ) then
        dc:parse-csv-to-xml( $data, $header, $separator, $quote, $rt, $encode )
    else if ( $format = 'html' ) then
        dc:parse-html-to-xml( $data )
    else if ( $format = 'json' ) then
        dc:parse-json-to-xml( $data, $rfc7159, $rt, $encode )
    else
        dc:parse-xml-to-xml( $data )
};

declare %an:sequential function local:convert-query( $query as xs:string, $ns-names as xs:string* ) as xs:string {
    qc:convert-query-to-xquery( $query, $ns-names )
};

declare %an:sequential function local:execute-expression( $xml as document-node(), $xquery as xs:string, $wrap as xs:string ) as node()* {
    local:execute-xquery-against-xml( $xml, $xquery, $wrap )
};

declare %an:sequential function local:execute-xquery-against-xml( $xml as document-node(), $xquery as xs:string, $wrap as xs:string ) as node()* {
    let $preparedXQuery             := zq:prepare-main-module( $xquery )
    let $result                     :=
        {
            zq:bind-context-item( $preparedXQuery, $xml );
            zq:evaluate( $preparedXQuery )
        }
    return
        local:wrap-result( $result, $wrap )
};

declare function local:wrap-result( $result as node()*, $wrap as xs:string ) as node()* {
    if ( $wrap = 'yes' ) then
        element response {
            $result
        }
    else
        $result
};


(: Application :)
variable $start         := datetime:current-dateTime();

(: Input reading :)
variable $startIR       := datetime:current-dateTime();
variable $mode          := local:get-mode( http-req:param-values( 'mode' )[ 1 ], 'processor' );
variable $data          := if ( $mode = 'echoer' or $mode = 'dataconverter' or $mode = 'processor' ) then local:get-data( http-req:param-values( 'data' )[ 1 ] ) else ();
variable $format        := local:get-format( http-req:param-values( 'format' )[ 1 ], 'json' );
variable $header        := local:get-header( tokenize( http-req:header-value( 'header' ), ',' )[ 1 ], http-req:param-values( 'header' )[ 1 ], 'absent' );
variable $separator     := local:get-separator( http-req:param-values( 'separator' )[ 1 ], ',' );
variable $quote         := local:get-quote( http-req:param-values( 'quote' )[ 1 ], '"' );
variable $rfc7159       := local:get-rfc7159( http-req:param-values( 'rfc7159' )[ 1 ], 'yes' );
variable $rt            := local:get-rt( http-req:param-values( 'rt' )[ 1 ], 'yes' );
variable $encode        := local:get-encode( http-req:param-values( 'encode' )[ 1 ], 'yes' );
variable $query         := local:get-query( http-req:param-values( 'query' )[ 1 ], '/' );
variable $ns-names      := local:get-ns-names( 'ns-' );
variable $wrap          := local:get-wrap( http-req:param-values( 'wrap' )[ 1 ], 'yes' );
variable $analysis      := local:get-analysis( http-req:param-values( 'analysis' )[ 1 ], 'no' );
variable $stopIR        := datetime:current-dateTime();

(: Data conversion :)
variable $startDC       := datetime:current-dateTime();
variable $xml           := if ( $mode = 'dataconverter' or $mode = 'processor' ) then local:convert-data( $data, $format, $header, $separator, $quote, $rfc7159, $rt, $encode ) else ();
variable $stopDC        := datetime:current-dateTime();

(: Query conversion :)
variable $startQC       := datetime:current-dateTime();
variable $xquery        := if ( $mode = 'queryconverter' or $mode = 'processor' ) then local:convert-query( $query, $ns-names ) else '';
variable $stopQC        := datetime:current-dateTime();

(: Query processing :)
variable $startQP       := datetime:current-dateTime();
variable $result        := if ( $mode = 'processor' ) then local:execute-expression( $xml, $xquery, $wrap ) else '';
variable $stopQP        := datetime:current-dateTime();

variable $stop          := datetime:current-dateTime();

(: Calculate times :)
variable $irTime        := seconds-from-duration( xs:dateTime( $stopIR ) - xs:dateTime( $startIR ) );
variable $dcTime        := seconds-from-duration( xs:dateTime( $stopDC ) - xs:dateTime( $startDC ) );
variable $qcTime        := seconds-from-duration( xs:dateTime( $stopQC ) - xs:dateTime( $startQC ) );
variable $qpTime        := seconds-from-duration( xs:dateTime( $stopQP ) - xs:dateTime( $startQP ) );
variable $totalTime     := seconds-from-duration( xs:dateTime( $stop ) - xs:dateTime( $start ) );

(: Return result with or without analysis :)
if ( $analysis = 'yes' ) then {
    http-res:content-type( 'text/plain' );
    (
        concat( ' Input reading time:    ', ( $irTime * 1000 ), ' ms', '&#xA;' ),
        concat( 'Data conversion time:  ', ( $dcTime * 1000 ), ' ms', '&#xA;' ),
        concat( 'Query conversion time: ', ( $qcTime * 1000 ), ' ms', '&#xA;' ),
        concat( 'Query processing time: ', ( $qpTime * 1000 ), ' ms', '&#xA;' ),
        concat( 'Total time:            ', ( $totalTime * 1000 ), ' ms' )
    )
}
else
    if ( $mode = 'echoer' ) then
        $data
    else if ( $mode = 'dataconverter' ) then {
        http-res:content-type( 'application/xml' );
        $xml
    }
    else if ( $mode = 'queryconverter' ) then {
        http-res:content-type( 'text/plain' );
        $xquery
    }
    else {
        http-res:content-type( 'application/xml' );
        $result
    }