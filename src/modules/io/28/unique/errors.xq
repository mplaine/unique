xquery version "3.0";


(: Module :)
module namespace uqerr                      = "http://unique.28.io/errors";


(: processor.xq errors :)
declare variable $uqerr:UQ0001              := 'UQ0001';
declare variable $uqerr:UQ0001_MESSAGE      := 'Missing data. Please, use the "data" parameter to pass in CSV, HTML, JSON, or XML data (either as an absolute URL or as an inline text).';

declare variable $uqerr:UQ0002              := 'UQ0002';
declare variable $uqerr:UQ0002_MESSAGE_1    := 'Missing data. Please, verify that the absolute URL "';
declare variable $uqerr:UQ0002_MESSAGE_2    := '" which is pointing to CSV, HTML, JSON, or XML data is valid.';

declare variable $uqerr:UQ0003              := 'UQ0003';
declare variable $uqerr:UQ0003_MESSAGE_1    := 'Missing data. Please, verify that the absolute URL "';
declare variable $uqerr:UQ0003_MESSAGE_2    := '" which is pointing to CSV, HTML, JSON, or XML data returns a successful response.';

(: queryconverter.xq errors :)

(: dataconverter.xq errors :)
declare variable $uqerr:UQ0201              := 'UQ0201';
declare variable $uqerr:UQ0201_MESSAGE      := 'Missing data. Please, use the "data" parameter to pass in CSV, HTML, JSON, or XML data (either as an absolute URL or as an inline text).';

declare variable $uqerr:UQ0202              := 'UQ0202';
declare variable $uqerr:UQ0202_MESSAGE_1    := 'Missing data. Please, verify that the absolute URL "';
declare variable $uqerr:UQ0202_MESSAGE_2    := '" which is pointing to CSV, HTML, JSON, or XML data is valid.';

declare variable $uqerr:UQ0203              := 'UQ0203';
declare variable $uqerr:UQ0203_MESSAGE_1    := 'Missing data. Please, verify that the absolute URL "';
declare variable $uqerr:UQ0203_MESSAGE_2    := '" which is pointing to CSV, HTML, JSON, or XML data returns a successful response.';

(: echoer.xq errors :)
declare variable $uqerr:UQ0301              := 'UQ0301';
declare variable $uqerr:UQ0301_MESSAGE      := 'Missing data. Please, use the "data" parameter to pass in data (either as an absolute URL or as an inline text).';

declare variable $uqerr:UQ0302              := 'UQ0302';
declare variable $uqerr:UQ0302_MESSAGE_1    := 'Missing data. Please, verify that the absolute URL "';
declare variable $uqerr:UQ0302_MESSAGE_2    := '" which is pointing to data is valid.';

declare variable $uqerr:UQ0303              := 'UQ0303';
declare variable $uqerr:UQ0303_MESSAGE_1    := 'Missing data. Please, verify that the absolute URL "';
declare variable $uqerr:UQ0303_MESSAGE_2    := '" which is pointing to data returns a successful response.';

(: analyzer.xq errors :)
declare variable $uqerr:UQ0401              := 'UQ0401';
declare variable $uqerr:UQ0401_MESSAGE      := 'Missing data. Please, use the "data" parameter to pass in CSV, HTML, JSON, or XML data (either as an absolute URL or as an inline text).';

declare variable $uqerr:UQ0402              := 'UQ0402';
declare variable $uqerr:UQ0402_MESSAGE_1    := 'Missing data. Please, verify that the absolute URL "';
declare variable $uqerr:UQ0402_MESSAGE_2    := '" which is pointing to CSV, HTML, JSON, or XML data is valid.';

declare variable $uqerr:UQ0403              := 'UQ0403';
declare variable $uqerr:UQ0403_MESSAGE_1    := 'Missing data. Please, verify that the absolute URL "';
declare variable $uqerr:UQ0403_MESSAGE_2    := '" which is pointing to CSV, HTML, JSON, or XML data returns a successful response.';