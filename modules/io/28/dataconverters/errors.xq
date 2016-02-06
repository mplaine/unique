xquery version "3.0";


(: Module :)
module namespace dcerr                      = "http://dataconverters.28.io/errors";

(:Variables :)
(: CSV converter errors :)
declare variable $dcerr:DC0001              := 'DC0001';
declare variable $dcerr:DC0001_MESSAGE      := 'Invalid CSV. Please, verify that the CSV is well-formed.';

declare variable $dcerr:DC0002              := 'DC0002';
declare variable $dcerr:DC0002_MESSAGE      := 'Invalid CSV. Please, verify that the CSV is well-formed.';

(: HTML converter errors :)
declare variable $dcerr:DC0101              := 'DC0101';
declare variable $dcerr:DC0101_MESSAGE      := 'Invalid HTML. Please, verify that the HTML is valid enough.';

(: JSON converter errors :)
declare variable $dcerr:DC0201              := 'DC0201';
declare variable $dcerr:DC0201_MESSAGE      := 'Invalid JSON. Please, verify that the JSON is well-formed and contains an object, array, number, or string, or one of the following three literal names: false, true, or null.';

declare variable $dcerr:DC0202              := 'DC0202';
declare variable $dcerr:DC0202_MESSAGE      := 'Invalid JSON. Please, verify that the JSON is well-formed and contains an object, array, number, or string, or one of the following three literal names: false, true, or null.';

(: XML converter errors :)
declare variable $dcerr:DC0301              := 'DC0301';
declare variable $dcerr:DC0301_MESSAGE      := 'Invalid XML. Please, verify that the XML is well-formed.';

(: JSONiq errors :)
declare variable $dcerr:EJX0001             := 'EJX0001';
declare variable $dcerr:EJX0001_MESSAGE     := 'Invalid JSON. Please, verify that all JSON types are valid.';