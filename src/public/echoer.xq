xquery version "3.0";


(: Imports :)
import module namespace functx      = "http://www.functx.com";
import module namespace http-req    = "http://www.28msec.com/modules/http-request";
import module namespace jx          = "http://zorba.io/modules/json-xml";
import module namespace uqerr       = "http://unique.28.io/errors";
import module namespace uqerrh      = "http://unique.28.io/errorhandler";
import module namespace zhttp       = "http://zorba.io/modules/http-client";

(: Namespaces :)
declare namespace js                = "http://john.snelson.org.uk/parsing-json-into-xquery";

(: Variables :)
declare variable $errorFormat       := "xml";
declare variable $userAgent         := "Mozilla/5.0";

(: Functions :)
declare %an:sequential function local:get-data( $parameter as xs:string? ) as xs:string {
    let $parameterTrimmed           := functx:trim( $parameter )
    return
        (: No data :)
        if ( empty( $parameter ) ) then
            error( xs:QName( $uqerr:UQ0301 ), $uqerr:UQ0301_MESSAGE )
        (: Data :)
        else
            (: Absolute URL data :)
            if ( $parameterTrimmed castable as xs:anyURI = true() and functx:is-absolute-uri( $parameterTrimmed ) = true() and local:is-absolute-uri( $parameterTrimmed ) = true() ) then
                let $httpResponse   :=
                    try {
                        jx:json-to-xml( zhttp:send-request( { "href": $parameterTrimmed, "options": { "user-agent": $userAgent } } ) )
                        (:jx:json-to-xml( zhttp:send-request( { "href": $parameterTrimmed, "options": { "user-agent": $userAgent }, "headers": { "Accept-Encoding": "gzip,deflate" } } ) ):)
                    } catch * {
                        error( xs:QName( $uqerr:UQ0302 ), concat( $uqerr:UQ0302_MESSAGE_1, $parameterTrimmed, $uqerr:UQ0302_MESSAGE_2 ) )
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
                        error( xs:QName( $uqerr:UQ0303 ), concat( $uqerr:UQ0303_MESSAGE_1, $parameterTrimmed, $uqerr:UQ0303_MESSAGE_2 ) )
            (: Inline text data :)
            else
                $parameter
};

declare function local:is-absolute-uri( $uri as xs:string ) as xs:boolean {
    matches( $uri, "^(http|https)://" )
};


(: Application :)
try {
    (: Input reading :)
    let $data       := local:get-data( http-req:param-values( 'data' )[ 1 ] )

    (: Return data :)
    return
        $data
} catch * {
    uqerrh:error( $err:code, $err:description, $errorFormat, $zerr:stack-trace )
}