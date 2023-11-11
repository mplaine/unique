xquery version "3.0";


(: Module :)
module namespace qc                         = "http://queryconverters.28.io/queryconverters_1-1";

(: Imports :)
import module namespace functx              = "http://www.functx.com";
import module namespace http-req            = "http://www.28msec.com/modules/http-request";
import module namespace qcerr               = "http://queryconverters.28.io/errors";
import module namespace uql11-par           = "http://queryconverters.28.io/unique_level_1-1_parser";
(:import module namespace xp3-par           = "http://queryconverters.28.io/xpath_3-0_parser";:)
(:import module namespace xq3-par           = "http://queryconverters.28.io/xquery_3-0_parser";:)

(: Functions :)
declare %an:sequential %public function qc:convert-unique-to-xpath( $query as xs:string ) as xs:string {
    let $xpathString                        := qc:convert-unique-string-to-xpath-string( $query )
    return
        $xpathString
};

declare %an:sequential %public function qc:convert-query-to-xquery( $query as xs:string, $ns-names as xs:string* ) as xs:string {
    let $xqueryString                       := qc:convert-query-string-to-xquery-string( $query, $ns-names )
    return
        $xqueryString
};

declare %private function qc:convert-unique-string-to-xpath-string( $query as xs:string ) as xs:string {
    let $uql11ParserResult                  := uql11-par:parse-selectors_group( $query )
    return
        (: Selectors or UniQue :)
        if ( empty( $uql11ParserResult/self::ERROR ) ) then
            let $unfixedXPath               := string-join( qc:parse-result-tree( $uql11ParserResult ), '' )
            (: Quick fix to a problem, in which more than one condition contains a position calculation :)
            let $xpath                      := functx:trim( replace( $unfixedXPath, '\]\[', ' and ' ) )
            return
                $xpath
        (: XPath, XQuery, or unsupported/invalid query :)
        else
            error( xs:QName( $qcerr:QC0201 ), concat( $qcerr:QC0201_MESSAGE_1, $query, $qcerr:QC0201_MESSAGE_2, '&#xA;', $uql11ParserResult, '&#xA;' ) )
};

declare %private function qc:convert-query-string-to-xquery-string( $query as xs:string, $ns-names as xs:string* ) as xs:string {
    let $uql11ParserResult                  := uql11-par:parse-selectors_group( $query )
    return
        (: Selectors or UniQue :)
        if ( empty( $uql11ParserResult/self::ERROR ) ) then
            let $unfixedXPath               := string-join( qc:parse-result-tree( $uql11ParserResult ), '' )
            (: Quick fix to a problem, in which more than one condition contains a position calculation :)
            let $xpath                      := functx:trim( replace( $unfixedXPath, '\]\[', ' and ' ) )
            return
                qc:convert-xpath-string-to-xquery-string( $xpath, $ns-names )
        (: XPath, XQuery, or unsupported/invalid query :)
        else
            qc:convert-xpath-or-xquery-string-to-xquery-string( $query, $ns-names )
            (:
            (: Unfortunately, simply including the code for parsing the query with the XPath and/or especially XQuery parsers yields much slower (several seconds in the case of XQuery) response times :)
            let $xp3ParserResult            := xp3-par:parse-XPath( $query )
            return
                (: XPath :)
                if ( empty( $xp3ParserResult/self::ERROR ) ) then
                    let $xpath              := $query
                    return
                        qc:convert-xpath-string-to-xquery-string( $xpath, $ns-names )
                (: XQuery or unsupported/invalid query :)
                else
                    let $xq3ParserResult    := xq3-par:parse-XQuery( $query )
                    return
                        (: XQuery :)
                        if ( empty( $xq3ParserResult/self::ERROR ) ) then
                            $query
                        (: Unsupported/invalid query :)
                        else
                            error( xs:QName( $qcerr:QC0202 ), concat( $qcerr:QC0202_MESSAGE_1, $query, $qcerr:QC0202_MESSAGE_2, '&#xA;', $xq3ParserResult, '&#xA;' ) )
            :)
};

declare %private function qc:convert-xpath-string-to-xquery-string( $xpath as xs:string, $ns-names as xs:string* ) as xs:string {
    let $versionDeclaration                 := 'xquery version "3.0";&#xA;'
    let $namespaceDeclarations              :=
        if ( count( $ns-names ) > 0 ) then
            for $ns-name in $ns-names
                return
                    concat( 'declare namespace ', substring( $ns-name, 1+string-length( 'ns-' ) ), '="', http-req:param-values( $ns-name )[ 1 ], '";&#xA;' )
        else
            ''
    return
        concat( $versionDeclaration, string-join( $namespaceDeclarations, '' ), $xpath )
};

declare %private function qc:convert-xpath-or-xquery-string-to-xquery-string( $query as xs:string, $ns-names as xs:string* ) as xs:string {
    (: XPath :)
    if ( count( $ns-names ) > 0 ) then
        let $versionDeclaration             := 'xquery version "3.0";&#xA;'
        let $namespaceDeclarations          :=
            for $ns-name in $ns-names
                return
                    concat( 'declare namespace ', substring( $ns-name, 1+string-length( 'ns-' ) ), '="', http-req:param-values( $ns-name )[ 1 ], '";&#xA;' )
        return
            concat( $versionDeclaration, string-join( $namespaceDeclarations, '' ), $query )            
    (: XQuery :)
    else
        $query
};

declare %private function qc:convert-attrib-ident( $element as element() ) as xs:string {
    (: Attribute name :)
    if ( not( boolean( $element/preceding-sibling::IDENT ) ) ) then
        let $matchToken := $element/following-sibling::TOKEN[1]/text()
        let $negBegin   :=
            (: negation_arg :)
            if ( local-name( $element/../.. ) = "negation_arg" ) then
                "not("
            (: simple_selector_sequence :)
            else
                ""
        let $negEnd     :=
            (: negation_arg :)
            if ( local-name( $element/../.. ) = "negation_arg" ) then
                ")"
            (: simple_selector_sequence :)
            else
                ""
        let $condition  :=
            let $conditionAttName   := qc:convert-attrib-name( $element/.. )
            return
                if ( $matchToken = "^=" or $matchToken = "$=" or $matchToken = "*=" or $matchToken = "=" or $matchToken = "~=" or $matchToken = "|=" ) then
                    ""
                (: no value = attribute name only :)
                else
                    concat( '[', $negBegin, '@', $conditionAttName, $negEnd, ']' )
        return
            $condition
    (: Attribute value (without quotes) :)
    else
        let $matchToken := $element/preceding-sibling::TOKEN[1]/text()
        (:let $attName    := $element/preceding-sibling::IDENT/text():)
        let $attValue   := $element/text()
        let $negBegin   :=
            (: negation_arg :)
            if ( local-name( $element/../.. ) = "negation_arg" ) then
                "not("
            (: simple_selector_sequence :)
            else
                ""
        let $negEnd     :=
            (: negation_arg :)
            if ( local-name( $element/../.. ) = "negation_arg" ) then
                ")"
            (: simple_selector_sequence :)
            else
                ""
        let $condition  :=
            let $conditionAttName   := qc:convert-attrib-name( $element/.. )
            return        
                if ( $matchToken = "^=" ) then
                    concat( '[', $negBegin, 'starts-with(@', $conditionAttName, ',', '"', $attValue, '")', $negEnd, ']' )
                else if ( $matchToken = "$=" ) then
                    concat( '[', $negBegin, 'substring(@', $conditionAttName, ',string-length(@', $conditionAttName, ')-string-length("', $attValue, '")+1)="', $attValue, '"', $negEnd, ']' )
                else if ( $matchToken = "*=" ) then
                    concat( '[', $negBegin, 'contains(@', $conditionAttName, ',', '"', $attValue, '") and string-length("', $attValue, '")>0', $negEnd, ']' )
                else if ( $matchToken = "=" ) then
                    concat( '[', $negBegin, '@', $conditionAttName, '=', '"', $attValue, '"', $negEnd, ']' )
                else if ( $matchToken = "~=" ) then
                    concat( '[', $negBegin, 'contains(concat(" ",normalize-space(@', $conditionAttName, ')," ")," ', $attValue, ' ") and string-length(normalize-space("', $attValue, '"))>0', $negEnd, ']' )
                else if ( $matchToken = "|=" ) then
                    concat( '[', $negBegin, '@', $conditionAttName, '=', '"', $attValue, '" or starts-with(@', $conditionAttName, ',"', $attValue, '-")', $negEnd, ']' )
                else
                    error( xs:QName( $qcerr:QC0101 ), concat( $qcerr:QC0101_MESSAGE_1, $matchToken, $qcerr:QC0101_MESSAGE_2, string( root( $element ) ), $qcerr:QC0101_MESSAGE_3 ) )
        return
            $condition
};

declare %private function qc:convert-attrib-name( $element as element() ) as xs:string {
    let $nsName         := $element/namespace_prefix/IDENT/text()
    let $nsToken1       := $element/namespace_prefix/TOKEN[1]/text()
    let $nsToken2       := $element/namespace_prefix/TOKEN[2]/text()
    let $attributeName  := $element/IDENT[1]/text()
    return
        (: ns|att, with namespace, namespace prefix ns :)
        if ( string-length( $nsName ) > 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
            concat( $nsName, ':', $attributeName )
        (: *|att, with or without namespace :)
        else if ( string-length( $nsName ) = 0 and $nsToken1 = "*" and $nsToken2 = "|" ) then
            concat( '*', ':', $attributeName )
        (: |att, without namespace :)
        else if ( string-length( $nsName ) = 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
            $attributeName
        (: att, without namespace :)
        else
            $attributeName
};

declare %private function qc:convert-attrib-string( $element as element() ) as xs:string {
    let $matchToken := $element/preceding-sibling::TOKEN[1]/text()
    let $attValue   := $element/text()
    let $negBegin   :=
        (: negation_arg :)
        if ( local-name( $element/../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd     :=
        (: negation_arg :)
        if ( local-name( $element/../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""
    let $condition  :=
        let $conditionAttName   := qc:convert-attrib-name( $element/.. )
        return
            if ( $matchToken = "^=" ) then
                concat( '[', $negBegin, 'starts-with(@', $conditionAttName, ',', $attValue, ')', $negEnd, ']' )
            else if ( $matchToken = "$=" ) then
                concat( '[', $negBegin, 'substring(@', $conditionAttName, ',string-length(@', $conditionAttName, ')-string-length(', $attValue, ')+1)=', $attValue, $negEnd, ']' )
            else if ( $matchToken = "*=" ) then
                concat( '[', $negBegin, 'contains(@', $conditionAttName, ',', $attValue, ') and string-length(', $attValue, ')>0', $negEnd, ']' )
            else if ( $matchToken = "=" ) then
                concat( '[', $negBegin, '@', $conditionAttName, '=', $attValue, $negEnd, ']' )
            else if ( $matchToken = "~=" ) then
                concat( '[', $negBegin, 'contains(concat(" ",normalize-space(@', $conditionAttName, ')," ")," ', substring( $attValue, 2, string-length( $attValue ) - 2 ), ' ") and string-length(normalize-space(', $attValue, '))>0', $negEnd, ']' )
            else if ( $matchToken = "|=" ) then
                concat( '[', $negBegin, '@', $conditionAttName, '=', $attValue, ' or starts-with(@', $conditionAttName, ',"', substring( $attValue, 2, string-length( $attValue ) - 2 ), '-")', $negEnd, ']' )
            else
                error( xs:QName( $qcerr:QC0102 ), concat( $qcerr:QC0102_MESSAGE_1, $matchToken, $qcerr:QC0102_MESSAGE_2, string( root( $element ) ), $qcerr:QC0102_MESSAGE_3 ) )
    return
        $condition
};

declare %private function qc:convert-class-ident( $element as element() ) as xs:string {
    let $className  := $element/text()
    let $negBegin   :=
        (: negation_arg :)
        if ( local-name( $element/../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd     :=
        (: negation_arg :)
        if ( local-name( $element/../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""
    let $condition  :=
        concat( '[', $negBegin, 'contains(concat(" ",normalize-space(@class)," ")," ', $className, ' ")', $negEnd, ']' )
    return
        $condition
};

declare %private function qc:convert-expression-dimension( $element as element() ) as xs:string {
    let $functionName       := $element/../preceding-sibling::FUNCTION/text()
    let $condition          :=
        (: nth-child(an+b) (pseudo-class) :)
        if ( $functionName = "nth-child(" ) then
            qc:convert-nth-child-condition( $element )
        (: nth-last-child(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-last-child(" ) then
            qc:convert-nth-last-child-condition( $element )
        (: nth-last-of-type(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-last-of-type(" ) then
            qc:convert-nth-last-of-type-condition( $element )
        (: nth-of-type(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-of-type(" ) then
            qc:convert-nth-of-type-condition( $element )
        (: Illegal functional pseudo-class :)
        else
            error( xs:QName( $qcerr:QC0103 ), concat( $qcerr:QC0103_MESSAGE_1, string( $element/../../.. ), $qcerr:QC0103_MESSAGE_2, string( root( $element ) ), $qcerr:QC0103_MESSAGE_3 ) )
    return
        $condition
};

declare %private function qc:convert-expression-ident( $element as element() ) as xs:string {
    let $identValue         := $element/text()
    let $functionName       := $element/../preceding-sibling::FUNCTION/text()
    let $alphabetsUpperCase := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let $alphabetsLowerCase := "abcdefghijklmnopqrstuvwxyz"
    let $negBegin           :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd             :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""        
    let $condition          :=
        (: lang(C) (pseudo-class) :)
        if ( $functionName = "lang(" ) then
            concat( '[', $negBegin, '(translate((ancestor-or-self::*[@lang])[1]/@lang,"', $alphabetsUpperCase, '","', $alphabetsLowerCase, '")=translate("', $identValue, '","', $alphabetsUpperCase, '","', $alphabetsLowerCase, '") or translate((ancestor-or-self::*[@xml:lang])[1]/@xml:lang,"', $alphabetsUpperCase, '","', $alphabetsLowerCase, '")=translate("', $identValue, '","', $alphabetsUpperCase, '","', $alphabetsLowerCase, '") or starts-with(translate((ancestor-or-self::*[@lang])[1]/@lang,"', $alphabetsUpperCase, '","', $alphabetsLowerCase, '"),translate("', $identValue, '-","', $alphabetsUpperCase, '","', $alphabetsLowerCase, '")) or starts-with(translate((ancestor-or-self::*[@xml:lang])[1]/@xml:lang,"', $alphabetsUpperCase, '","', $alphabetsLowerCase, '"),translate("', $identValue, '-","', $alphabetsUpperCase, '","', $alphabetsLowerCase, '"))) and string-length(normalize-space("', $identValue, '"))>0', $negEnd, ']' )
        (: nth-child(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-child(" ) then
            qc:convert-nth-child-condition( $element )
        (: nth-last-child(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-last-child(" ) then
            qc:convert-nth-last-child-condition( $element )
        (: nth-last-of-type(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-last-of-type(" ) then
            qc:convert-nth-last-of-type-condition( $element )
        (: nth-of-type(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-of-type(" ) then
            qc:convert-nth-of-type-condition( $element )
        (: Illegal functional pseudo-class :)
        else
            error( xs:QName( $qcerr:QC0104 ), concat( $qcerr:QC0104_MESSAGE_1, string( $element/../../.. ), $qcerr:QC0104_MESSAGE_2, string( root( $element ) ), $qcerr:QC0104_MESSAGE_3 ) )
    return
        $condition
};

declare %private function qc:convert-expression-number( $element as element() ) as xs:string {
    let $functionName   := $element/../preceding-sibling::FUNCTION/text()
    let $condition      :=
        (: item(position) (pseudo-class) :)
        if ( $functionName = "item(" ) then
            qc:convert-item-condition( $element )
        (: nth-child(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-child(" ) then
            qc:convert-nth-child-condition( $element )
        (: nth-last-child(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-last-child(" ) then
            qc:convert-nth-last-child-condition( $element )
        (: nth-last-of-type(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-last-of-type(" ) then
            qc:convert-nth-last-of-type-condition( $element )
        (: nth-of-type(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-of-type(" ) then
            qc:convert-nth-of-type-condition( $element )
        (: Illegal functional pseudo-class :)
        else
            error( xs:QName( $qcerr:QC0105 ), concat( $qcerr:QC0105_MESSAGE_1, string( $element/../../.. ), $qcerr:QC0105_MESSAGE_2, string( root( $element ) ), $qcerr:QC0105_MESSAGE_3 ) )
    return
        $condition
};

declare %private function qc:convert-expression-string( $element as element() ) as xs:string {
    let $xpathValue         := $element/text()
    let $functionName       := $element/../preceding-sibling::FUNCTION/text()
    let $condition          :=
        (: xpath(xpath) (pseudo-class) :)
        if ( $functionName = "xpath(" ) then
            substring( $xpathValue, 2, string-length( $xpathValue ) - 2 )
        (: Illegal functional pseudo-class :)
        else
            error( xs:QName( $qcerr:QC0106 ), concat( $qcerr:QC0106_MESSAGE_1, string( $element/../../.. ), $qcerr:QC0106_MESSAGE_2, string( root( $element ) ), $qcerr:QC0106_MESSAGE_3 ) )
    return
        $condition
};

declare %private function qc:convert-function( $element as element() ) as xs:string {
    let $functionName   := $element/text()
    let $condition      :=
        (: contains(val) (pseudo-class) :)
        if ( $functionName = "contains(" ) then
            error( xs:QName( $qcerr:QC0112 ), concat( $qcerr:QC0112_MESSAGE_1, string( $element/.. ), $qcerr:QC0112_MESSAGE_2, string( root( $element ) ), $qcerr:QC0112_MESSAGE_3 ) )    
        (: item(position) (pseudo-class) :)
        else if ( $functionName = "item(" ) then
            ""
        (: lang(C) (pseudo-class) :)
        else if ( $functionName = "lang(" ) then
            ""
        (: nth-child(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-child(" ) then
            ""
        (: nth-last-child(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-last-child(" ) then
            ""
        (: nth-last-of-type(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-last-of-type(" ) then
            ""
        (: nth-of-type(an+b) (pseudo-class) :)
        else if ( $functionName = "nth-of-type(" ) then
            ""
        (: xpath(xpath) (pseudo-class) :)
        else if ( $functionName = "xpath(" ) then
            ""
        (: Illegal functional pseudo-class :)
        else
            error( xs:QName( $qcerr:QC0107 ), concat( $qcerr:QC0107_MESSAGE_1, string( $element/../.. ), $qcerr:QC0107_MESSAGE_2, string( root( $element ) ), $qcerr:QC0107_MESSAGE_3 ) )
    return
        $condition
};

declare %private function qc:convert-hash( $element as element() ) as xs:string {
    let $idName     := $element/text()
    let $negBegin   :=
        (: negation_arg :)
        if ( local-name( $element/.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd     :=
        (: negation_arg :)
        if ( local-name( $element/.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""
    let $condition  :=
        concat( '[', $negBegin, '@id="', substring( $idName, 2 ), '"', $negEnd, ']' )
    return
        $condition
};

declare %private function qc:convert-item-condition( $element as element() ) as xs:string {
    let $position                   := $element/text()
    let $negBegin                   :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd                     :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""
    let $condition                  :=
        let $conditionElemName      := qc:convert-simple_selector_sequence-element_name( $element/../../../.. )
        return
            concat( '[', $negBegin, '(count(preceding-sibling::', $conditionElemName, ')+1)=', $position, $negEnd, ']' )
    return
        $condition
};

declare %private function qc:convert-negation_arg-element_name( $element as element() ) as xs:string {
    (: type_selector :)
    if ( boolean( $element/type_selector ) ) then
        let $nsName         := $element/type_selector/namespace_prefix/IDENT/text()
        let $nsToken1       := $element/type_selector/namespace_prefix/TOKEN[1]/text()
        let $nsToken2       := $element/type_selector/namespace_prefix/TOKEN[2]/text()
        let $elementName    := $element/type_selector/element_name/IDENT/text()
        return
            (: ns|E, with namespace, namespace prefix ns :)
            if ( string-length( $nsName ) > 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
                concat( '[not(name()="', $nsName, ':', $elementName, '")]' )
                (: TODO: Change the condition to the one below in comments :)
                (:concat( '[not(local-name()="', $elementName, '" and namespace-uri()="', $nsURI, '")]' ):)
            (: *|E, with or without namespace :)
            else if ( string-length( $nsName ) = 0 and $nsToken1 = "*" and $nsToken2 = "|" ) then
                concat( '[not(local-name()="', $elementName, '")]' )
            (: |E, without namespace :)
            else if ( string-length( $nsName ) = 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
                concat( '[not(local-name()="', $elementName, '" and namespace-uri()="")]' )
            (: E, with or without namespace; or ns|E if default namespace for selector has been declared :)
            else
                concat( '[not(local-name()="', $elementName, '")]' )
                (: TODO: Change the condition to the one below in comments if default namespace has been declared :)
                (:concat( '[not(local-name()="', $elementName, '" and namespace-uri()="', $defaultNSURI, '")]' ):)
    (: universal :)
    else if ( boolean( $element/universal ) ) then
        let $nsName         := $element/universal/namespace_prefix/IDENT/text()
        let $nsToken1       := $element/universal/namespace_prefix/TOKEN[1]/text()
        let $nsToken2       := $element/universal/namespace_prefix/TOKEN[2]/text()
        let $universalToken := $element/universal/TOKEN/text()
        return
            (: ns|*, with namespace, namespace prefix ns :)
            if ( string-length( $nsName ) > 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
                error( xs:QName( $qcerr:QC0108 ), concat( $qcerr:QC0108_MESSAGE_1, string( $element/.. ), $qcerr:QC0108_MESSAGE_2, string( root( $element ) ), $qcerr:QC0108_MESSAGE_3 ) )
                (: This one gives wrong results: concat( '[not(name()="', $nsName, ':', $universalToken, '")]' ):)
                (: TODO: Change the condition to the one below in comments :)
                (:concat( '[not(namespace-uri()="', $nsURI, '")]' ):)
            (: *|*, with or without namespace :)
            else if ( string-length( $nsName ) = 0 and $nsToken1 = "*" and $nsToken2 = "|" ) then
                concat( '[local-name()="', $universalToken, '"]' )
            (: |*, without namespace :)
            else if ( string-length( $nsName ) = 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
                '[not(local-name()=name() and namespace-uri()="")]'
            (: *, with or without namespace; or ns|* if default namespace for selector has been declared :)
            else
                concat( '[local-name()="', $universalToken, '"]' )
                (: TODO: Change the condition to the one below in comments if default namespace has been declared :)
                (:concat( '[local-name()="', $universalToken, '" and namespace-uri()="', $defaultNSURI, '"]' ):)
    (: Neither type_selector nor universal, but either HASH, class, attrib, or pseudo :)
    else
        ""
};

declare %private function qc:convert-nth-child-condition( $element as element() ) as xs:string {
    let $negBegin   :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd     :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""
    let $condition  :=
        (: Perform the conversion at the number element :)
        if ( boolean( $element/following-sibling::NUMBER ) ) then
            ""
        else
            let $a  := qc:parse-expression-a( $element/.. )   
            let $b  := qc:parse-expression-b( $element/.. )   
            return
                if ( $a < 0 ) then
                    concat( '[', $negBegin, '(count(preceding-sibling::*)+1)<=', $b, ' and (count(preceding-sibling::*)+1) mod ', $a, '=', ( abs( $a ) + ( $b mod $a ) ) mod $a, ' and parent::*', $negEnd, ']' )
                else if ( $a = 0 ) then
                    concat( '[', $negBegin, '(count(preceding-sibling::*)+1)=', $b, ' and parent::*', $negEnd, ']' )
                else
                    concat( '[', $negBegin, '(count(preceding-sibling::*)+1)>=', $b, ' and (count(preceding-sibling::*)+1) mod ', $a, '=', ( abs( $a ) + ( $b mod $a ) ) mod $a, ' and parent::*', $negEnd, ']' )
    return
        $condition
};

declare %private function qc:convert-nth-last-child-condition( $element as element() ) as xs:string {
    let $negBegin   :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd     :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""
    let $condition  :=
        (: Perform the conversion at the number element :)
        if ( boolean( $element/following-sibling::NUMBER ) ) then
            ""
        else
            let $a  := qc:parse-expression-a( $element/.. )   
            let $b  := qc:parse-expression-b( $element/.. )
            return
                if ( $a < 0 ) then
                    concat( '[', $negBegin, '(count(following-sibling::*)+1)<=', $b, ' and (count(following-sibling::*)+1) mod ', $a, '=', ( abs( $a ) + ( $b mod $a ) ) mod $a, ' and parent::*', $negEnd, ']' )
                else if ( $a = 0 ) then
                    concat( '[', $negBegin, '(count(following-sibling::*)+1)=', $b, ' and parent::*', $negEnd, ']' )
                else
                    concat( '[', $negBegin, '(count(following-sibling::*)+1)>=', $b, ' and (count(following-sibling::*)+1) mod ', $a, '=', ( abs( $a ) + ( $b mod $a ) ) mod $a, ' and parent::*', $negEnd, ']' )    
    return
        $condition
};

declare %private function qc:convert-nth-last-of-type-condition( $element as element() ) as xs:string {
    let $negBegin                   :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd                     :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""
    let $condition                  :=
        (: Perform the conversion at the number element :)
        if ( boolean( $element/following-sibling::NUMBER ) ) then
            ""
        else
            let $a                  := qc:parse-expression-a( $element/.. )   
            let $b                  := qc:parse-expression-b( $element/.. )
            let $conditionElemName  := qc:convert-simple_selector_sequence-element_name-type_selector( $element/../../../.., true() )
            return
                if ( $a < 0 ) then
                    concat( '[', $negBegin, '(count(following-sibling::', $conditionElemName, ')+1)<=', $b, ' and (count(following-sibling::', $conditionElemName, ')+1) mod ', $a, '=', ( abs( $a ) + ( $b mod $a ) ) mod $a, ' and parent::*', $negEnd, ']' )
                else if ( $a = 0 ) then
                    concat( '[', $negBegin, '(count(following-sibling::', $conditionElemName, ')+1)=', $b, ' and parent::*', $negEnd, ']' )
                else
                    concat( '[', $negBegin, '(count(following-sibling::', $conditionElemName, ')+1)>=', $b, ' and (count(following-sibling::', $conditionElemName, ')+1) mod ', $a, '=', ( abs( $a ) + ( $b mod $a ) ) mod $a, ' and parent::*', $negEnd, ']' )    
    return
        $condition
};

declare %private function qc:convert-nth-of-type-condition( $element as element() ) as xs:string {
    let $negBegin                   :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd                     :=
        (: negation_arg :)
        if ( local-name( $element/../../../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""
    let $condition                  :=
        (: Perform the conversion at the number element :)
        if ( boolean( $element/following-sibling::NUMBER ) ) then
            ""
        else
            let $a                  := qc:parse-expression-a( $element/.. )   
            let $b                  := qc:parse-expression-b( $element/.. )
            let $conditionElemName  := qc:convert-simple_selector_sequence-element_name-type_selector( $element/../../../.., true() )
            return
                if ( $a < 0 ) then
                    concat( '[', $negBegin, '(count(preceding-sibling::', $conditionElemName, ')+1)<=', $b, ' and (count(preceding-sibling::', $conditionElemName, ')+1) mod ', $a, '=', ( abs( $a ) + ( $b mod $a ) ) mod $a, ' and parent::*', $negEnd, ']' )
                else if ( $a = 0 ) then
                    concat( '[', $negBegin, '(count(preceding-sibling::', $conditionElemName, ')+1)=', $b, ' and parent::*', $negEnd, ']' )
                else
                    concat( '[', $negBegin, '(count(preceding-sibling::', $conditionElemName, ')+1)>=', $b, ' and (count(preceding-sibling::', $conditionElemName, ')+1) mod ', $a, '=', ( abs( $a ) + ( $b mod $a ) ) mod $a, ' and parent::*', $negEnd, ']' )
    return
        $condition
};

declare %private function qc:convert-pseudo-ident( $element as element() ) as xs:string {
    let $pseudoName         := $element/text()
    let $tsLocalName        := $element/../preceding-sibling::type_selector/element_name/IDENT/text()
    let $negBegin           :=
        (: negation_arg :)
        if ( local-name( $element/../.. ) = "negation_arg" ) then
            "not("
        (: simple_selector_sequence :)
        else
            ""
    let $negEnd             :=
        (: negation_arg :)
        if ( local-name( $element/../.. ) = "negation_arg" ) then
            ")"
        (: simple_selector_sequence :)
        else
            ""    
    let $condition          :=
        (: active (pseudo-class) :)
        if ( $pseudoName = "active" ) then
            error( xs:QName( $qcerr:QC0110 ), concat( $qcerr:QC0110_MESSAGE_1, string( $element/.. ), $qcerr:QC0110_MESSAGE_2, string( root( $element ) ), $qcerr:QC0110_MESSAGE_3 ) )
        (: after (pseudo-element) :)
        else if ( $pseudoName = "after" ) then
            error( xs:QName( $qcerr:QC0109 ), concat( $qcerr:QC0109_MESSAGE_1, string( $element/.. ), $qcerr:QC0109_MESSAGE_2, string( root( $element ) ), $qcerr:QC0109_MESSAGE_3 ) )
        (: before (pseudo-element) :)
        else if ( $pseudoName = "before" ) then
            error( xs:QName( $qcerr:QC0109 ), concat( $qcerr:QC0109_MESSAGE_1, string( $element/.. ), $qcerr:QC0109_MESSAGE_2, string( root( $element ) ), $qcerr:QC0109_MESSAGE_3 ) )
        (: checked (pseudo-class) :)
        else if ( $pseudoName = "checked" ) then
            concat( '[', $negBegin, '(@checked="" or translate(@checked,"CHEKD","chekd")="checked" or @selected="" or translate(@selected,"SELCTD","selctd")="selected") and (@type="radio" or @type="checkbox") and (translate(local-name(),"INPUT","input")="input")', $negEnd, ']' )
        (: disabled (pseudo-class) :)
        else if ( $pseudoName = "disabled" ) then
            concat( '[', $negBegin, '(@disabled="" or translate(@disabled,"DISABLE","disable")="disabled") and (translate(local-name(),"BUTON","buton")="button" or translate(local-name(),"FIELDST","fieldst")="fieldset" or translate(local-name(),"INPUT","input")="input" or translate(local-name(),"OPTGRU","optgru")="optgroup" or translate(local-name(),"OPTIN","optin")="option" or translate(local-name(),"SELCT","selct")="select" or translate(local-name(),"TEXAR","texar")="textarea")', $negEnd, ']' )
        (: empty (pseudo-class) :)
        else if ( $pseudoName = "empty" ) then
            concat( '[', $negBegin, 'not(* or text())', $negEnd, ']' )
        (: enabled (pseudo-class) :)
        else if ( $pseudoName = "enabled" ) then
            concat( '[(', $negBegin, 'not(@disabled="" or translate(@disabled,"DISABLE","disable")="disabled")', $negEnd, ') and (translate(local-name(),"BUTON","buton")="button" or translate(local-name(),"FIELDST","fieldst")="fieldset" or translate(local-name(),"INPUT","input")="input" or translate(local-name(),"OPTGRU","optgru")="optgroup" or translate(local-name(),"OPTIN","optin")="option" or translate(local-name(),"SELCT","selct")="select" or translate(local-name(),"TEXAR","texar")="textarea")]' )
        (: first-child (pseudo-class) :)
        else if ( $pseudoName = "first-child" ) then
            concat( '[', $negBegin, '(count(preceding-sibling::*)+1)=1 and parent::*', $negEnd, ']' )
        (: first-letter (pseudo-element) :)
        else if ( $pseudoName = "first-letter" ) then
            error( xs:QName( $qcerr:QC0109 ), concat( $qcerr:QC0109_MESSAGE_1, string( $element/.. ), $qcerr:QC0109_MESSAGE_2, string( root( $element ) ), $qcerr:QC0109_MESSAGE_3 ) )
        (: first-line (pseudo-element) :)
        else if ( $pseudoName = "first-line" ) then
            error( xs:QName( $qcerr:QC0109 ), concat( $qcerr:QC0109_MESSAGE_1, string( $element/.. ), $qcerr:QC0109_MESSAGE_2, string( root( $element ) ), $qcerr:QC0109_MESSAGE_3 ) )
        (: first-of-type (pseudo-class) :)
        else if ( $pseudoName = "first-of-type" ) then
            concat( '[', $negBegin, 'count(preceding-sibling::*[local-name()="', $tsLocalName, '"])=0 and parent::*', $negEnd, ']' )
        (: focus (pseudo-class) :)
        else if ( $pseudoName = "focus" ) then
            concat( '[', $negBegin, '(@autofocus="" or translate(@autofocus,"AUTOFCS","autofcs")="autofocus") and (translate(local-name(),"A","a")="a" or translate(local-name(),"BUTON","buton")="button" or translate(local-name(),"COMAND","comand")="command" or translate(local-name(),"INPUT","input")="input" or translate(local-name(),"LINK","link")="link" or translate(local-name(),"SELCT","selct")="select" or translate(local-name(),"TEXAR","texar")="textarea") and (not(@disabled="" or translate(@disabled,"DISABLE","disable")="disabled"))', $negEnd, ']' )
        (: hover (pseudo-class) :)
        else if ( $pseudoName = "hover" ) then
            error( xs:QName( $qcerr:QC0110 ), concat( $qcerr:QC0110_MESSAGE_1, string( $element/.. ), $qcerr:QC0110_MESSAGE_2, string( root( $element ) ), $qcerr:QC0110_MESSAGE_3 ) )
        (: indeterminate (pseudo-class) :)
        else if ( $pseudoName = "indeterminate" ) then
            error( xs:QName( $qcerr:QC0110 ), concat( $qcerr:QC0110_MESSAGE_1, string( $element/.. ), $qcerr:QC0110_MESSAGE_2, string( root( $element ) ), $qcerr:QC0110_MESSAGE_3 ) )
        (: last-child (pseudo-class) :)
        else if ( $pseudoName = "last-child" ) then
            concat( '[', $negBegin, '(count(following-sibling::*)+1)=1 and parent::*', $negEnd, ']' )
        (: last-of-type (pseudo-class) :)
        else if ( $pseudoName = "last-of-type" ) then
            concat( '[', $negBegin, 'count(following-sibling::*[local-name()="', $tsLocalName, '"])=0 and parent::*', $negEnd, ']' )
        (: link (pseudo-class) :)
        else if ( $pseudoName = "link" ) then
            error( xs:QName( $qcerr:QC0110 ), concat( $qcerr:QC0110_MESSAGE_1, string( $element/.. ), $qcerr:QC0110_MESSAGE_2, string( root( $element ) ), $qcerr:QC0110_MESSAGE_3 ) )
        (: only-child (pseudo-class) :)
        else if ( $pseudoName = "only-child" ) then
            concat( '[', $negBegin, '(count(preceding-sibling::*)+1)=1 and (count(following-sibling::*)+1)=1 and parent::*', $negEnd, ']' )
        (: only-of-type (pseudo-class) :)
        else if ( $pseudoName = "only-of-type" ) then
            concat( '[', $negBegin, 'count(preceding-sibling::*[local-name()="', $tsLocalName, '"])=0 and count(following-sibling::*[local-name()="', $tsLocalName, '"])=0 and parent::*', $negEnd, ']' )
        (: selection (pseudo-element) :)
        else if ( $pseudoName = "selection" ) then
            error( xs:QName( $qcerr:QC0109 ), concat( $qcerr:QC0109_MESSAGE_1, string( $element/.. ), $qcerr:QC0109_MESSAGE_2, string( root( $element ) ), $qcerr:QC0109_MESSAGE_3 ) )
        (: root (pseudo-class) :)
        else if ( $pseudoName = "root" ) then
            concat( '[', $negBegin, 'not(parent::*)', $negEnd, ']' )
        (: target (pseudo-class) :)
        else if ( $pseudoName = "target" ) then
            error( xs:QName( $qcerr:QC0110 ), concat( $qcerr:QC0110_MESSAGE_1, string( $element/.. ), $qcerr:QC0110_MESSAGE_2, string( root( $element ) ), $qcerr:QC0110_MESSAGE_3 ) )
        (: visited (pseudo-class) :)
        else if ( $pseudoName = "visited" ) then
            error( xs:QName( $qcerr:QC0110 ), concat( $qcerr:QC0110_MESSAGE_1, string( $element/.. ), $qcerr:QC0110_MESSAGE_2, string( root( $element ) ), $qcerr:QC0110_MESSAGE_3 ) )
        (: Unsupported pseudo :)
        else
            error( xs:QName( $qcerr:QC0111 ), concat( $qcerr:QC0111_MESSAGE_1, string( $element/.. ), $qcerr:QC0111_MESSAGE_2, string( root( $element ) ), $qcerr:QC0111_MESSAGE_3 ) )
    return
        $condition
};

declare %private function qc:convert-simple_selector_sequence-element_name( $element as element() ) as xs:string {
    let $useSpecialCase1        :=
        (: Special case #1: certain pseudo-classes and pseudo-elements must use element name within a condition due to counting their child position :)
        if ( boolean( $element/pseudo ) ) then
            let $specialCases   :=
                string-join(
                    (: Iterate over all pseudo-classes and pseudo-elements :)
                    for $pseudoElement in $element/pseudo
                        return
                            (: pseudo IDENT :)
                            if ( boolean( $pseudoElement/IDENT ) ) then
                                let $pseudoName := $pseudoElement/IDENT/text()
                                return
                                    (: first-child (pseudo-class) :)
                                    if ( $pseudoName = "first-child" ) then
                                        "match"
                                    (: last-child (pseudo-class) :)
                                    else if ( $pseudoName = "last-child" ) then
                                        "match"
                                    (: only-child (pseudo-class) :)
                                    else if ( $pseudoName = "only-child" ) then
                                        "match"
                                    else
                                        ""
                            (: pseudo functional_pseudo :)
                            else
                                let $functionName   := $pseudoElement/functional_pseudo/FUNCTION/text()
                                return
                                    (: nth-child(an+b) (pseudo-class) :)
                                    if ( $functionName = "nth-child(" ) then
                                        "match"
                                    (: nth-last-child(an+b) (pseudo-class) :)
                                    else if ( $functionName = "nth-last-child(" ) then
                                        "match"
                                    else
                                        ""
                    ,
                    ""
                )
            return
                if ( string-length( $specialCases ) > 0 ) then
                    true()
                else
                    false()
        else
            false()
    let $useSpecialCase2        :=
        (: Special case #2: certain pseudo-classes and pseudo-elements cannot be implemented using XPath :)
        if ( boolean( $element/pseudo ) ) then
            let $specialCases   :=
                string-join(
                    (: Iterate over all pseudo-classes and pseudo-elements :)
                    for $pseudoElement in $element/pseudo
                        return
                            (: pseudo IDENT :)
                            if ( boolean( $pseudoElement/IDENT ) ) then
                                let $pseudoName := $pseudoElement/IDENT/text()
                                return
                                    (: first-of-type (pseudo-class) :)
                                    if ( $pseudoName = "first-of-type" ) then
                                        "match"
                                    (: last-of-type (pseudo-class) :)
                                    else if ( $pseudoName = "last-of-type" ) then
                                        "match"
                                    (: only-of-type (pseudo-class) :)
                                    else if ( $pseudoName = "only-of-type" ) then
                                        "match"
                                    else
                                        ""
                            (: pseudo functional_pseudo :)
                            else
                                let $functionName   := $pseudoElement/functional_pseudo/FUNCTION/text()
                                return
                                    (: nth-of-type(an+b) (pseudo-class) :)
                                    if ( $functionName = "nth-of-type(" ) then
                                        "match"
                                    (: nth-last-of-type(an+b) (pseudo-class) :)
                                    else if ( $functionName = "nth-last-of-type(" ) then
                                        "match"
                                    else
                                        ""
                    ,
                    ""
                )
            return
                if ( string-length( $specialCases ) > 0 ) then
                    true()
                else
                    false()
        else
            false()
    return
        (: type_selector :)
        if ( boolean( $element/type_selector ) ) then
            qc:convert-simple_selector_sequence-element_name-type_selector( $element, $useSpecialCase1 )
        (: universal :)
        else if ( boolean( $element/universal ) ) then
            qc:convert-simple_selector_sequence-element_name-universal( $element, $useSpecialCase2 )
        (: Neither type_selector nor universal, use universal :)
        (: *, with or without namespace; or ns|* if default namespace for selector has been declared :)
        else
            if ( $useSpecialCase2 ) then
                error( xs:QName( $qcerr:QC0113 ), concat( $qcerr:QC0113_MESSAGE_1, string( $element ), $qcerr:QC0113_MESSAGE_2, string( root( $element ) ), $qcerr:QC0113_MESSAGE_3 ) )
            else
                (: TODO: Change the condition to the one below in comments if default namespace has been declared :)
                '*'
                (:concat( '*', '[namespace-uri()="', $defaultNSURI, '"]' ):)
};

declare %private function qc:convert-simple_selector_sequence-element_name-type_selector( $element as element(), $useSpecialCase as xs:boolean ) as xs:string {
    let $nsName         := $element/type_selector/namespace_prefix/IDENT/text()
    let $nsToken1       := $element/type_selector/namespace_prefix/TOKEN[1]/text()
    let $nsToken2       := $element/type_selector/namespace_prefix/TOKEN[2]/text()
    let $elementName    := $element/type_selector/element_name/IDENT/text()
    return
        (: ns|E, with namespace, namespace prefix ns :)
        if ( string-length( $nsName ) > 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
            if ( $useSpecialCase ) then
                concat( '*', '[name()="', $nsName, ':', $elementName, '"]' )
                (: TODO: Change the condition to the one below in comments :)
                (:concat( '*', '[local-name()="', $elementName, '" and namespace-uri()="', $nsURI, '"]' ):)
            else
                concat( $nsName, ':', $elementName )
        (: *|E, with or without namespace :)
        else if ( string-length( $nsName ) = 0 and $nsToken1 = "*" and $nsToken2 = "|" ) then
            if ( $useSpecialCase ) then
                concat( '*', '[local-name()="', $elementName, '"]' )
            else
                concat( '*', '[local-name()="', $elementName, '"]' )
        (: |E, without namespace :)
        else if ( string-length( $nsName ) = 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
            if ( $useSpecialCase ) then
                concat( '*', '[local-name()="', $elementName, '" and namespace-uri()=""]' )
            else
                $elementName
        (: E, with or without namespace; or ns|E if default namespace for selector has been declared :)
        else
            if ( $useSpecialCase ) then
                concat( '*', '[local-name()="', $elementName, '"]' )
                (: TODO: Change the condition to the one below in comments if default namespace has been declared :)
                (:concat( '*', '[local-name()="', $elementName, '" and namespace-uri()="', $defaultNSURI, '"]' ):)
            else
                concat( '*', '[local-name()="', $elementName, '"]' )
                (: TODO: Change the condition to the one below in comments if default namespace has been declared :)
                (:concat( '*', '[local-name()="', $elementName, '" and namespace-uri()="', $defaultNSURI, '"]' ):)
};

declare %private function qc:convert-simple_selector_sequence-element_name-universal( $element as element(), $useSpecialCase as xs:boolean ) as xs:string {
    let $nsName         := $element/universal/namespace_prefix/IDENT/text()
    let $nsToken1       := $element/universal/namespace_prefix/TOKEN[1]/text()
    let $nsToken2       := $element/universal/namespace_prefix/TOKEN[2]/text()
    let $universalToken := $element/universal/TOKEN/text()
    return
        (: ns|*, with namespace, namespace prefix ns :)
        if ( string-length( $nsName ) > 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
            if ( $useSpecialCase ) then
                error( xs:QName( $qcerr:QC0114 ), concat( $qcerr:QC0114_MESSAGE_1, string( $element ), $qcerr:QC0114_MESSAGE_2, string( root( $element ) ), $qcerr:QC0114_MESSAGE_3 ) )
            else
                concat( $nsName, ':', $universalToken )
        (: *|*, with or without namespace :)
        else if ( string-length( $nsName ) = 0 and $nsToken1 = "*" and $nsToken2 = "|" ) then
            if ( $useSpecialCase ) then
                error( xs:QName( $qcerr:QC0114 ), concat( $qcerr:QC0114_MESSAGE_1, string( $element ), $qcerr:QC0114_MESSAGE_2, string( root( $element ) ), $qcerr:QC0114_MESSAGE_3 ) )
            else
                $universalToken
        (: |*, without namespace :)
        else if ( string-length( $nsName ) = 0 and $nsToken1 = "|" and string-length( $nsToken2 ) = 0 ) then
            if ( $useSpecialCase ) then
                error( xs:QName( $qcerr:QC0114 ), concat( $qcerr:QC0114_MESSAGE_1, string( $element ), $qcerr:QC0114_MESSAGE_2, string( root( $element ) ), $qcerr:QC0114_MESSAGE_3 ) )
            else
                concat( $universalToken, '[local-name()=name() and namespace-uri()=""]' )
        (: *, with or without namespace; or ns|* if default namespace for selector has been declared :)
        else
            if ( $useSpecialCase ) then
                error( xs:QName( $qcerr:QC0114 ), concat( $qcerr:QC0114_MESSAGE_1, string( $element ), $qcerr:QC0114_MESSAGE_2, string( root( $element ) ), $qcerr:QC0114_MESSAGE_3 ) )
            else
                $universalToken
                (: TODO: Change the condition to the one below in comments if default namespace has been declared :)
                (:concat( '*', '[namespace-uri()="', $defaultNSURI, '"]' ):)
};

declare %private function qc:parse-expression-a( $expression as element() ) as xs:integer {
    let $expressionNS   := normalize-space( string( $expression ) )
    let $a              :=
        (: even :)
        if ( $expressionNS = "even" ) then
            2
        (: odd :)
        else if ( $expressionNS = "odd" ) then
            2
        (: an+b :)
        else
            (: a exists :)
            if ( contains( $expressionNS, "n" ) ) then
                (: Substring before first match :)
                let $ss := substring-before( $expressionNS, "n" )
                return
                    (: a is invalid :)
                    if ( contains( $ss, " " ) ) then
                        error( xs:QName( $qcerr:QC0115 ), concat( $qcerr:QC0115_MESSAGE_1, string( $expression ), $qcerr:QC0115_MESSAGE_2, string( root( $expression ) ), $qcerr:QC0115_MESSAGE_3 ) )
                    (: a should be valid :)
                    else
                        (: +n :)
                        if ( $ss = "+" ) then
                            1
                        (: n :)
                        else if ( $ss = "" ) then
                            1
                        (: -n :)
                        else if ( $ss = "-" ) then
                            -1
                        (: +an, an, -an :)
                        else
                            try {
                                1 * xs:integer( $ss )
                            } catch * {
                                error( xs:QName( $qcerr:QC0116 ), concat( $qcerr:QC0116_MESSAGE_1, string( $expression ), $qcerr:QC0116_MESSAGE_2, string( root( $expression ) ), $qcerr:QC0116_MESSAGE_3 ) )
                            }
            (: a does not exist, i.e., b only :)
            else
                0
    return
        $a
};

declare %private function qc:parse-expression-b( $expression as element() ) as xs:integer {
    let $expressionNS   := normalize-space( string( $expression ) )
    let $b              :=
        (: even :)
        if ( $expressionNS = "even" ) then
            0
        (: odd :)
        else if ( $expressionNS = "odd" ) then
            1
        (: an+b :)
        else
            (: a exists :)
            if ( contains( $expressionNS, "n" ) ) then
                (: Substring after first match and remove all allowed whitespaces :)
                let $ss := replace( substring-after( $expressionNS, "n" ), " ", "" )
                return
                    (: b does not exist :)
                    if ( $ss = "" ) then
                        0
                    (: b exists :)
                    else
                        (: +b, -b :)
                        try {
                            1 * xs:integer( $ss )
                        } catch * {
                            error( xs:QName( $qcerr:QC0117 ), concat( $qcerr:QC0117_MESSAGE_1, string( $expression ), $qcerr:QC0117_MESSAGE_2, string( root( $expression ) ), $qcerr:QC0117_MESSAGE_3 ) )
                        }
            (: a does not exist, i.e., b only :)
            else
                (: b is invalid :)
                if ( contains( $expressionNS, " " ) ) then
                    error( xs:QName( $qcerr:QC0118 ), concat( $qcerr:QC0118_MESSAGE_1, string( $expression ), $qcerr:QC0118_MESSAGE_2, string( root( $expression ) ), $qcerr:QC0118_MESSAGE_3 ) )
                (: b should be valid :)
                else
                    (: +b, b, -b :)
                    try {
                        1 * xs:integer( $expressionNS )
                    } catch * {
                        error( xs:QName( $qcerr:QC0119 ), concat( $qcerr:QC0119_MESSAGE_1, string( $expression ), $qcerr:QC0119_MESSAGE_2, string( root( $expression ) ), $qcerr:QC0119_MESSAGE_3 ) )
                    }
    return
        $b
};

declare %private function qc:parse-result-tree( $element as element() ) as xs:string* {
    (: attrib :)
    if ( local-name( $element ) = "attrib" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "TOKEN" or local-name( $childElement ) = "S" or local-name( $childElement ) = "namespace_prefix" or local-name( $childElement ) = "IDENT" or local-name( $childElement ) = "STRING" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0001 ), concat( $qcerr:QC0001_MESSAGE_1, string( $element ), $qcerr:QC0001_MESSAGE_2, string( root( $element ) ), $qcerr:QC0001_MESSAGE_3 ) )
    (: class :)
    else if ( local-name( $element ) = "class" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "TOKEN" or local-name( $childElement ) = "IDENT" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0002 ), concat( $qcerr:QC0002_MESSAGE_1, string( $element ), $qcerr:QC0002_MESSAGE_2, string( root( $element ) ), $qcerr:QC0002_MESSAGE_3 ) )
    (: combinator :)
    else if ( local-name( $element ) = "combinator" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "PLUS" or local-name( $childElement ) = "GREATER" or local-name( $childElement ) = "TILDE" or local-name( $childElement ) = "LESS" or local-name( $childElement ) = "S" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0003 ), concat( $qcerr:QC0003_MESSAGE_1, string( $element ), $qcerr:QC0003_MESSAGE_2, string( root( $element ) ), $qcerr:QC0003_MESSAGE_3 ) )
    (: COMMA :)
    else if ( local-name( $element ) = "COMMA" ) then
        "|"
    (: DIMENSION :)
    else if ( local-name( $element ) = "DIMENSION" ) then
        qc:convert-expression-dimension( $element )
    (: element_name :)
    else if ( local-name( $element ) = "element_name" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "IDENT" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0004 ), concat( $qcerr:QC0004_MESSAGE_1, string( $element ), $qcerr:QC0004_MESSAGE_2, string( root( $element ) ), $qcerr:QC0004_MESSAGE_3 ) )
    (: expression :)
    else if ( local-name( $element ) = "expression" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "PLUS" or local-name( $childElement ) = "TOKEN" or local-name( $childElement ) = "DIMENSION" or local-name( $childElement ) = "NUMBER" or local-name( $childElement ) = "STRING" or local-name( $childElement ) = "IDENT" or local-name( $childElement ) = "S" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0005 ), concat( $qcerr:QC0005_MESSAGE_1, string( $element ), $qcerr:QC0005_MESSAGE_2, string( root( $element ) ), $qcerr:QC0005_MESSAGE_3 ) )
    (: FUNCTION :)
    else if ( local-name( $element ) = "FUNCTION" ) then
        qc:convert-function( $element )
    (: functional_pseudo :)
    else if ( local-name( $element ) = "functional_pseudo" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "FUNCTION" or local-name( $childElement ) = "S" or local-name( $childElement ) = "expression" or local-name( $childElement ) = "TOKEN" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0006 ), concat( $qcerr:QC0006_MESSAGE_1, string( $element/.. ), $qcerr:QC0006_MESSAGE_2, string( root( $element ) ), $qcerr:QC0006_MESSAGE_3 ) )
    (: GREATER :)
    else if ( local-name( $element ) = "GREATER" ) then
        "/"
    (: HASH :)
    else if ( local-name( $element ) = "HASH" ) then
        qc:convert-hash( $element )
    (: IDENT :)
    else if ( local-name( $element ) = "IDENT" ) then
        if ( local-name( $element/.. ) = "attrib" ) then
            qc:convert-attrib-ident( $element )
        else if ( local-name( $element/.. ) = "class" ) then
            qc:convert-class-ident( $element )
        else if ( local-name( $element/.. ) = "element_name" ) then
            ""
        else if ( local-name( $element/.. ) = "expression" ) then
            qc:convert-expression-ident( $element )
        else if ( local-name( $element/.. ) = "namespace_prefix" ) then
            ""
        else if ( local-name( $element/.. ) = "pseudo" ) then
            qc:convert-pseudo-ident( $element )
        else
            error( xs:QName( $qcerr:QC0007 ), concat( $qcerr:QC0007_MESSAGE_1, string( $element ), $qcerr:QC0007_MESSAGE_2, string( root( $element ) ), $qcerr:QC0007_MESSAGE_3 ) )
    (: LESS :)
    else if ( local-name( $element ) = "LESS" ) then
        "/../"
    (: namespace_prefix :)
    else if ( local-name( $element ) = "namespace_prefix" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "IDENT" or local-name( $childElement ) = "TOKEN" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0008 ), concat( $qcerr:QC0008_MESSAGE_1, string( $element ), $qcerr:QC0008_MESSAGE_2, string( root( $element ) ), $qcerr:QC0008_MESSAGE_3 ) )
    (: negation :)
    else if ( local-name( $element ) = "negation" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "NOT" or local-name( $childElement ) = "S" or local-name( $childElement ) = "negation_arg" or local-name( $childElement ) = "TOKEN" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0009 ), concat( $qcerr:QC0009_MESSAGE_1, string( $element/.. ), $qcerr:QC0009_MESSAGE_2, string( root( $element ) ), $qcerr:QC0009_MESSAGE_3 ) )
    (: negation_arg :)
    else if ( local-name( $element ) = "negation_arg" ) then
        let $elemName   := qc:convert-negation_arg-element_name( $element )
        let $conditions :=
            string-join(
                for $childElement in $element/element()
                    return
                        if ( local-name( $childElement ) = "type_selector" or local-name( $childElement ) = "universal" or local-name( $childElement ) = "HASH" or local-name( $childElement ) = "class" or local-name( $childElement ) = "attrib" or local-name( $childElement ) = "pseudo" ) then
                            qc:parse-result-tree( $childElement )
                        else
                            error( xs:QName( $qcerr:QC0010 ), concat( $qcerr:QC0010_MESSAGE_1, string( $element ), $qcerr:QC0010_MESSAGE_2, string( root( $element ) ), $qcerr:QC0010_MESSAGE_3 ) )
                ,
                ""
            )
        return        
            concat( $elemName, $conditions )
    (: NOT :)
    else if ( local-name( $element ) = "NOT" ) then
        ""
    (: NUMBER :)
    else if ( local-name( $element ) = "NUMBER" ) then
        if ( local-name( $element/.. ) = "expression" ) then
            qc:convert-expression-number( $element )
        else
            error( xs:QName( $qcerr:QC0011 ), concat( $qcerr:QC0011_MESSAGE_1, string( $element ), $qcerr:QC0011_MESSAGE_2, string( root( $element ) ), $qcerr:QC0011_MESSAGE_3 ) )
    (: PLUS :)
    else if ( local-name( $element ) = "PLUS" ) then
        if ( local-name( $element/.. ) = "combinator" ) then
            "/following-sibling::*[1]/self::"
        else if ( local-name( $element/.. ) = "expression" ) then
            ""
        else
            error( xs:QName( $qcerr:QC0012 ), concat( $qcerr:QC0012_MESSAGE_1, string( $element ), $qcerr:QC0012_MESSAGE_2, string( root( $element ) ), $qcerr:QC0012_MESSAGE_3 ) )
    (: pseudo :)
    else if ( local-name( $element ) = "pseudo" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "TOKEN" or local-name( $childElement ) = "IDENT" or local-name( $childElement ) = "functional_pseudo" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0013 ), concat( $qcerr:QC0013_MESSAGE_1, string( $element ), $qcerr:QC0013_MESSAGE_2, string( root( $element ) ), $qcerr:QC0013_MESSAGE_3 ) )
    (: S :)
    else if ( local-name( $element ) = "S" ) then
        if ( local-name( $element/.. ) = "combinator" and not( boolean( $element/preceding-sibling::GREATER ) ) and not( boolean( $element/preceding-sibling::PLUS ) ) and not( boolean( $element/preceding-sibling::TILDE ) ) and not( boolean( $element/preceding-sibling::LESS ) ) ) then
            "//"
        else
            "" (: other whitespaces within other parent elements :)
    (: selector :)
    else if ( local-name( $element ) = "selector" ) then
        concat(
            '//'
            ,
            string-join(
                for $childElement in $element/element()
                    return
                        if ( local-name( $childElement ) = "simple_selector_sequence" or local-name( $childElement ) = "combinator" ) then
                            qc:parse-result-tree( $childElement )
                        else
                            error( xs:QName( $qcerr:QC0014 ), concat( $qcerr:QC0014_MESSAGE_1, string( $element ), $qcerr:QC0014_MESSAGE_2, string( root( $element ) ), $qcerr:QC0014_MESSAGE_3 ) )
                ,
                ""
            )
        )
    (: selectors_group :)
    else if ( local-name( $element ) = "selectors_group" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "selector" or local-name( $childElement ) = "COMMA" or local-name( $childElement ) = "S" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0015 ), concat( $qcerr:QC0015_MESSAGE_1, string( $element ), $qcerr:QC0015_MESSAGE_2, string( root( $element ) ), $qcerr:QC0015_MESSAGE_3 ) )
    (: simple_selector_sequence :)
    else if ( local-name( $element ) = "simple_selector_sequence" ) then
        let $elemName   := qc:convert-simple_selector_sequence-element_name( $element )
        let $conditions :=
            string-join(
                for $childElement in $element/element()
                    return
                        if ( local-name( $childElement ) = "type_selector" or local-name( $childElement ) = "universal" or local-name( $childElement ) = "HASH" or local-name( $childElement ) = "class" or local-name( $childElement ) = "attrib" or local-name( $childElement ) = "pseudo" or local-name( $childElement ) = "negation" ) then
                            qc:parse-result-tree( $childElement )
                        else
                            error( xs:QName( $qcerr:QC0016 ), concat( $qcerr:QC0016_MESSAGE_1, string( $element ), $qcerr:QC0016_MESSAGE_2, string( root( $element ) ), $qcerr:QC0016_MESSAGE_3 ) )
                ,
                ""
            )
        return        
            concat( $elemName, $conditions )
    (: STRING :)
    else if ( local-name( $element ) = "STRING" ) then
        if ( local-name( $element/.. ) = "attrib" ) then
            qc:convert-attrib-string( $element )
        else if ( local-name( $element/.. ) = "expression" ) then
            qc:convert-expression-string( $element )
        else
            error( xs:QName( $qcerr:QC0017 ), concat( $qcerr:QC0017_MESSAGE_1, string( $element ), $qcerr:QC0017_MESSAGE_2, string( root( $element ) ), $qcerr:QC0017_MESSAGE_3 ) )
    (: TILDE :)
    else if ( local-name( $element ) = "TILDE" ) then
        "/following-sibling::"
    (: TOKEN :)
    else if ( local-name( $element ) = "TOKEN" ) then
        if ( local-name( $element/.. ) = "attrib" ) then
            if ( $element/text() = "[" ) then
                ""
            else if ( $element/text() = "^=" ) then
                ""
            else if ( $element/text() = "$=" ) then
                ""
            else if ( $element/text() = "*=" ) then
                ""
            else if ( $element/text() = "=" ) then
                ""
            else if ( $element/text() = "~=" ) then
                ""
            else if ( $element/text() = "|=" ) then
                ""
            else if ( $element/text() = "]" ) then
                ""
            else
                error( xs:QName( $qcerr:QC0018 ), concat( $qcerr:QC0018_MESSAGE_1, string( $element ), $qcerr:QC0018_MESSAGE_2, string( root( $element ) ), $qcerr:QC0018_MESSAGE_3 ) )
        else if ( local-name( $element/.. ) = "class" ) then
            if ( $element/text() = "." ) then
                ""
            else
                error( xs:QName( $qcerr:QC0018 ), concat( $qcerr:QC0018_MESSAGE_1, string( $element ), $qcerr:QC0018_MESSAGE_2, string( root( $element ) ), $qcerr:QC0018_MESSAGE_3 ) )
        else if ( local-name( $element/.. ) = "expression" ) then
            if ( $element/text() = "-" ) then
                ""
            else
                error( xs:QName( $qcerr:QC0018 ), concat( $qcerr:QC0018_MESSAGE_1, string( $element ), $qcerr:QC0018_MESSAGE_2, string( root( $element ) ), $qcerr:QC0018_MESSAGE_3 ) )
        else if ( local-name( $element/.. ) = "functional_pseudo" ) then
            if ( $element/text() = ")" ) then
                ""
            else
                error( xs:QName( $qcerr:QC0018 ), concat( $qcerr:QC0018_MESSAGE_1, string( $element ), $qcerr:QC0018_MESSAGE_2, string( root( $element ) ), $qcerr:QC0018_MESSAGE_3 ) )
        else if ( local-name( $element/.. ) = "namespace_prefix" ) then
            if ( $element/text() = "*" ) then
                ""
            else if ( $element/text() = "|" ) then
                ""
            else
                error( xs:QName( $qcerr:QC0018 ), concat( $qcerr:QC0018_MESSAGE_1, string( $element ), $qcerr:QC0018_MESSAGE_2, string( root( $element ) ), $qcerr:QC0018_MESSAGE_3 ) )
        else if ( local-name( $element/.. ) = "negation" ) then
            if ( $element/text() = ")" ) then
                ""
            else
                error( xs:QName( $qcerr:QC0018 ), concat( $qcerr:QC0018_MESSAGE_1, string( $element ), $qcerr:QC0018_MESSAGE_2, string( root( $element ) ), $qcerr:QC0018_MESSAGE_3 ) )
        else if ( local-name( $element/.. ) = "pseudo" ) then
            if ( $element/text() = ":" ) then
                ""
            else
                error( xs:QName( $qcerr:QC0018 ), concat( $qcerr:QC0018_MESSAGE_1, string( $element ), $qcerr:QC0018_MESSAGE_2, string( root( $element ) ), $qcerr:QC0018_MESSAGE_3 ) )
        else if ( local-name( $element/.. ) = "universal" ) then
            if ( $element/text() = "*" ) then
                ""
            else
                error( xs:QName( $qcerr:QC0018 ), concat( $qcerr:QC0018_MESSAGE_1, string( $element ), $qcerr:QC0018_MESSAGE_2, string( root( $element ) ), $qcerr:QC0018_MESSAGE_3 ) )
        else
            error( xs:QName( $qcerr:QC0019 ), concat( $qcerr:QC0019_MESSAGE_1, string( $element ), $qcerr:QC0019_MESSAGE_2, string( root( $element ) ), $qcerr:QC0019_MESSAGE_3 ) )
    (: type_selector :)
    else if ( local-name( $element ) = "type_selector" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "namespace_prefix" or local-name( $childElement ) = "element_name" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0020 ), concat( $qcerr:QC0020_MESSAGE_1, string( $element ), $qcerr:QC0020_MESSAGE_2, string( root( $element ) ), $qcerr:QC0020_MESSAGE_3 ) )
    (: universal :)
    else if ( local-name( $element ) = "universal" ) then
        for $childElement in $element/element()
            return
                if ( local-name( $childElement ) = "namespace_prefix" or local-name( $childElement ) = "TOKEN" ) then
                    qc:parse-result-tree( $childElement )
                else
                    error( xs:QName( $qcerr:QC0021 ), concat( $qcerr:QC0021_MESSAGE_1, string( $element ), $qcerr:QC0021_MESSAGE_2, string( root( $element ) ), $qcerr:QC0021_MESSAGE_3 ) )
    (: Unsupported element :)
    else
        error( xs:QName( $qcerr:QC0022 ), concat( $qcerr:QC0022_MESSAGE_1, string( root( $element ) ), $qcerr:QC0022_MESSAGE_2 ) )
};