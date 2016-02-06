xquery version "3.0";


(:
 : This module provides improved implementations for the functions defined by the JSONiq specification.
 :
 : 20130613 Dennis Knochenwefel authored the functions
 : 20140508 Markku Laine wrapped the functions into the module
:)

(: Module :)
module namespace ejn    = "http://dataconverters.28.io/ejn";

(: Public functions :)
(: JSON parser that improves the implementation of the jn:parse-json function :)
declare %public function ejn:parse-json( $json-string as xs:string ) as item()* {
    let $json-temp      := "{""parsed-lax"": [" || $json-string || "] }"
    return
        jn:parse-json( $json-temp )( "parsed-lax" )()
};