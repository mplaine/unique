xquery version "3.0";


(: Imports :)
import module namespace functx      = "http://www.functx.com";
import module namespace http-req    = "http://www.28msec.com/modules/http-request";
import module namespace http-res    = "http://www.28msec.com/modules/http-response";
import module namespace qc          = "http://queryconverters.28.io/queryconverters";
import module namespace uqerrh      = "http://unique.28.io/errorhandler";

(: Variables :)
declare variable $errorFormat       := "xml";

(: Functions :)
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

declare %an:sequential function local:convert-query( $query as xs:string ) as xs:string {
    qc:convert-unique-to-xpath( $query )    
};


(: Application :)
try{
    (: Input reading :)
    let $query          := local:get-query( http-req:param-values( 'query' )[ 1 ], '/' )
    
    (: Query conversion :)
    let $xpath          := if ( $query = '/' ) then $query else local:convert-query( $query )
    
    (: Return XPath :)
    return {
        http-res:content-type( 'text/plain' );
        $xpath
    }
} catch * {
    uqerrh:error( $err:code, $err:description, $errorFormat, $zerr:stack-trace )
}