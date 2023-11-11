xquery version "3.0";


(: Module :)
module namespace uqerrh             = "http://unique.28.io/errorhandler";

(: Imports :)
import module namespace functx      = "http://www.functx.com";
import module namespace http-res    = "http://www.28msec.com/modules/http-response";
(:import module namespace jx        = "http://zorba.io/modules/json-xml";:)

(: Variables :)
declare variable $uqerrh:debug      := false();

(: Functions :)
declare %an:sequential function uqerrh:error( $code as xs:QName, $description as xs:string, $errorFormat as xs:string, $stack ) {
    switch ( $errorFormat )
        case "json"
            return {
                http-res:content-type( "application/json" );
                http-res:status-code( 400 );
                let $errorJson      :=
                    if ( $uqerrh:debug = false() ) then (
                        {
                            "error": true,
                            "code": $code,
                            "description": functx:substring-after-if-contains( $description, "]: " )
                        }
                    )
                    else (
                        {
                            "error": true,
                            "code": $code,
                            "description": $description,
                            "stack": serialize( $stack )
                        }
                    )
                return
                    $errorJson
                (:
                let $errorXml       :=
                    if ( $uqerrh:debug = false() ) then (
                        <json xmlns="http://john.snelson.org.uk/parsing-json-into-xquery" type="object">
                            <pair name="error" type="object">
                                <pair name="code" type="string">{ $code }</pair>
                                <pair name="description" type="string">{ functx:substring-after-if-contains( $description, "]: " ) }</pair>
                            </pair>
                        </json>
                    )
                    else (
                        <json xmlns="http://john.snelson.org.uk/parsing-json-into-xquery" type="object">
                            <pair name="error" type="object">
                                <pair name="code" type="string">{ $code }</pair>
                                <pair name="description" type="string">{ $description }</pair>
                            </pair>
                        </json>
                    )
                let $errorJson      := jx:xml-to-json( $errorXml )
                return
                    $errorJson
                :)
            }
        case "xml"
            return {
                http-res:content-type( "application/xml" );
                http-res:status-code( 400 );
                let $errorXml       :=
                    if ( $uqerrh:debug = false() ) then (
                        <error>
                            <code>{ $code }</code>
                            <description>{ functx:substring-after-if-contains( $description, "]: " ) }</description>
                        </error>
                    )
                    else (
                        <error>
                            <code>{ $code }</code>
                            <description>{ $description }</description>
                            { $stack }
                        </error>
                    )
                return
                    $errorXml
            }
        default
            return {
                http-res:content-type( "application/xml" );
                http-res:status-code( 400 );
                let $errorXml       :=
                    if ( $uqerrh:debug = false() ) then (
                        <error>
                            <code>{ $code }</code>
                            <description>{ functx:substring-after-if-contains( $description, "]: " ) }</description>
                        </error>
                    )
                    else (
                        <error>
                            <code>{ $code }</code>
                            <description>{ $description }</description>
                            { $stack }
                        </error>
                    )
                return
                    $errorXml
            }
};