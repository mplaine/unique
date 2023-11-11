jsoniq version "1.0";


(:
 : JSON-to-XML converter. RFC 7159 compliant, i.e., allows a JSON text to be other than an object or array.
 :
 : 20140508 William Candillon authored the draft version of the code
 : 20140508 Markku Laine elaborated the code to better meet John Snelson's transformation rules
:)

(: Module :)
module namespace ejx                = "http://dataconverters.28.io/ejx.jq";

(: Imports :)
import module namespace dcerr       = "http://dataconverters.28.io/errors";

(: Public functions :)
declare %public function ejx:json-to-xml( $json ) {
    ejx:json-to-xml( $json, "json" )
};

(: Private functions :)
declare %private function ejx:json-to-xml( $json, $inner ) {
    ejx:json-to-xml( $json, $inner, () )
};

declare %private function ejx:json-to-xml( $json, $inner, $key-name ) {
    switch ( ejx:json-type( $json ) )
        (: object :)
        case "object"
            return
                element { $inner } {
                    if ( $key-name ) then
                        attribute name { $key-name }
                    else
                        (),
                    attribute type { "object" },
                    for $key in $json()
                        return
                            ejx:json-to-xml( $json( $key ), "pair", $key )
                }
        (: array :)
        case "array"
            return
                element { $inner } {
                    if ( $key-name ) then
                        attribute name { $key-name }
                    else
                        (),
                    attribute type { "array" },
                    for $item in $json()
                        return
                            ejx:json-to-xml( $item, "item" )
        }
        (: number :)
        case "number"
            return
                element { $inner } {
                    if ( $key-name ) then
                        attribute name { $key-name }
                    else
                        (),
                    attribute type { "number" },
                    $json
                }
        (: string :)
        case "string"
            return
                element { $inner } {
                    if ( $key-name ) then
                        attribute name { $key-name }
                    else
                        (),
                    attribute type { "string" },
                    $json
                }
        (: boolean :)
        case "boolean"
            return
                element { $inner } {
                    if ( $key-name ) then
                        attribute name { $key-name }
                    else
                        (),
                    attribute type { "boolean" },
                    $json
                }
        (: null :)
        case "null"
            return
                element { $inner } {
                    if ( $key-name ) then
                        attribute name { $key-name }
                    else
                        (),
                    attribute type { "null" }
                }
        (: unknown :)
        default
            return
                error( xs:QName( $dcerr:EJX0001 ), $dcerr:EJX0001_MESSAGE )
};

declare %private function ejx:json-type( $values as item()* ) as string* {
    for $val in $values
        return (
            typeswitch ( $val )
                case object
                    return
                        "object"
                case array
                    return
                        "array"
                case integer
                    return
                        "number"
                case decimal
                    return
                        "number"
                case double
                    return
                        "number"
                case string
                    return
                        "string"
                case boolean
                    return
                        "boolean"
                case null
                    return
                        "null"
                default
                    return
                        "unknown"
        )
};