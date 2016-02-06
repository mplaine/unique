xquery version "3.0";


(: Module :)
module namespace qcerr                      = "http://queryconverters.28.io/errors";


(: Query parser errors :)
declare variable $qcerr:QC0001              := 'QC0001';
declare variable $qcerr:QC0001_MESSAGE_1    := 'Invalid query. Please, verify that the attribute selector "';
declare variable $qcerr:QC0001_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0001_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0002              := 'QC0002';
declare variable $qcerr:QC0002_MESSAGE_1    := 'Invalid query. Please, verify that the class selector "';
declare variable $qcerr:QC0002_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0002_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0003              := 'QC0003';
declare variable $qcerr:QC0003_MESSAGE_1    := 'Invalid query. Please, verify that the combinator "';
declare variable $qcerr:QC0003_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0003_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0004              := 'QC0004';
declare variable $qcerr:QC0004_MESSAGE_1    := 'Invalid query. Please, verify that the element name "';
declare variable $qcerr:QC0004_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0004_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0005              := 'QC0005';
declare variable $qcerr:QC0005_MESSAGE_1    := 'Invalid query. Please, verify that the expression "';
declare variable $qcerr:QC0005_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0005_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0006              := 'QC0006';
declare variable $qcerr:QC0006_MESSAGE_1    := 'Invalid query. Please, verify that the functional pseudo-class "';
declare variable $qcerr:QC0006_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0006_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0007              := 'QC0007';
declare variable $qcerr:QC0007_MESSAGE_1    := 'Invalid query. Please, verify that the identifier "';
declare variable $qcerr:QC0007_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0007_MESSAGE_3    := '" is correctly positioned and used.';

declare variable $qcerr:QC0008              := 'QC0008';
declare variable $qcerr:QC0008_MESSAGE_1    := 'Invalid query. Please, verify that the namespace prefix "';
declare variable $qcerr:QC0008_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0008_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0009              := 'QC0009';
declare variable $qcerr:QC0009_MESSAGE_1    := 'Invalid query. Please, verify that the negation pseudo-class "';
declare variable $qcerr:QC0009_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0009_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0010              := 'QC0010';
declare variable $qcerr:QC0010_MESSAGE_1    := 'Invalid query. Please, verify that the negation argument "';
declare variable $qcerr:QC0010_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0010_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0011              := 'QC0011';
declare variable $qcerr:QC0011_MESSAGE_1    := 'Invalid query. Please, verify that the number "';
declare variable $qcerr:QC0011_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0011_MESSAGE_3    := '" is correctly positioned and used.';

declare variable $qcerr:QC0012              := 'QC0012';
declare variable $qcerr:QC0012_MESSAGE_1    := 'Invalid query. Please, verify that the plus "';
declare variable $qcerr:QC0012_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0012_MESSAGE_3    := '" is correctly positioned and used.';

declare variable $qcerr:QC0013              := 'QC0013';
declare variable $qcerr:QC0013_MESSAGE_1    := 'Invalid query. Please, verify that the pseudo-class "';
declare variable $qcerr:QC0013_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0013_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0014              := 'QC0014';
declare variable $qcerr:QC0014_MESSAGE_1    := 'Invalid query. Please, verify that the complex selector "';
declare variable $qcerr:QC0014_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0014_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0015              := 'QC0015';
declare variable $qcerr:QC0015_MESSAGE_1    := 'Invalid query. Please, verify that the selector list "';
declare variable $qcerr:QC0015_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0015_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0016              := 'QC0016';
declare variable $qcerr:QC0016_MESSAGE_1    := 'Invalid query. Please, verify that the compound selector "';
declare variable $qcerr:QC0016_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0016_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0017              := 'QC0017';
declare variable $qcerr:QC0017_MESSAGE_1    := 'Invalid query. Please, verify that the string ';
declare variable $qcerr:QC0017_MESSAGE_2    := ' in the UniQue or Selectors query "';
declare variable $qcerr:QC0017_MESSAGE_3    := '" is correctly positioned and used.';

declare variable $qcerr:QC0018              := 'QC0018';
declare variable $qcerr:QC0018_MESSAGE_1    := 'Invalid query. Please, verify that the token value "';
declare variable $qcerr:QC0018_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0018_MESSAGE_3    := '" is correctly positioned and used.';

declare variable $qcerr:QC0019              := 'QC0019';
declare variable $qcerr:QC0019_MESSAGE_1    := 'Invalid query. Please, verify that the token "';
declare variable $qcerr:QC0019_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0019_MESSAGE_3    := '" is correctly positioned and used.';

declare variable $qcerr:QC0020              := 'QC0020';
declare variable $qcerr:QC0020_MESSAGE_1    := 'Invalid query. Please, verify that the type selector "';
declare variable $qcerr:QC0020_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0020_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0021              := 'QC0021';
declare variable $qcerr:QC0021_MESSAGE_1    := 'Invalid query. Please, verify that the universal selector "';
declare variable $qcerr:QC0021_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0021_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0022              := 'QC0022';
declare variable $qcerr:QC0022_MESSAGE_1    := 'Invalid query. Please, verify that the UniQue or Selectors query "';
declare variable $qcerr:QC0022_MESSAGE_2    := '" is well-formed.';

(: Query parser helper function errors :)
declare variable $qcerr:QC0101              := 'QC0101';
declare variable $qcerr:QC0101_MESSAGE_1    := 'Invalid query. Illegal attribute value selector "';
declare variable $qcerr:QC0101_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0101_MESSAGE_3    := '".';

declare variable $qcerr:QC0102              := 'QC0102';
declare variable $qcerr:QC0102_MESSAGE_1    := 'Invalid query. Illegal attribute value selector "';
declare variable $qcerr:QC0102_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0102_MESSAGE_3    := '".';

declare variable $qcerr:QC0103              := 'QC0103';
declare variable $qcerr:QC0103_MESSAGE_1    := 'Invalid query. Illegal functional pseudo-class "';
declare variable $qcerr:QC0103_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0103_MESSAGE_3    := '".';

declare variable $qcerr:QC0104              := 'QC0104';
declare variable $qcerr:QC0104_MESSAGE_1    := 'Invalid query. Illegal functional pseudo-class "';
declare variable $qcerr:QC0104_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0104_MESSAGE_3    := '".';

declare variable $qcerr:QC0105              := 'QC0105';
declare variable $qcerr:QC0105_MESSAGE_1    := 'Invalid query. Illegal functional pseudo-class "';
declare variable $qcerr:QC0105_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0105_MESSAGE_3    := '".';

declare variable $qcerr:QC0106              := 'QC0106';
declare variable $qcerr:QC0106_MESSAGE_1    := 'Invalid query. Illegal functional pseudo-class "';
declare variable $qcerr:QC0106_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0106_MESSAGE_3    := '".';

declare variable $qcerr:QC0107              := 'QC0107';
declare variable $qcerr:QC0107_MESSAGE_1    := 'Invalid query. Illegal functional pseudo-class "';
declare variable $qcerr:QC0107_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0107_MESSAGE_3    := '".';

declare variable $qcerr:QC0108              := 'QC0108';
declare variable $qcerr:QC0108_MESSAGE_1    := 'Invalid query. Unsupported negation universal selector "';
declare variable $qcerr:QC0108_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0108_MESSAGE_3    := '". Support will be added later.';

declare variable $qcerr:QC0109              := 'QC0109';
declare variable $qcerr:QC0109_MESSAGE_1    := 'Invalid query. Unsupported pseudo-element "';
declare variable $qcerr:QC0109_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0109_MESSAGE_3    := '".';

declare variable $qcerr:QC0110              := 'QC0110';
declare variable $qcerr:QC0110_MESSAGE_1    := 'Invalid query. Unsupported pseudo-class "';
declare variable $qcerr:QC0110_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0110_MESSAGE_3    := '".';

declare variable $qcerr:QC0111              := 'QC0111';
declare variable $qcerr:QC0111_MESSAGE_1    := 'Invalid query. Illegal pseudo-class or pseudo-element "';
declare variable $qcerr:QC0111_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0111_MESSAGE_3    := '".';

declare variable $qcerr:QC0112              := 'QC0112';
declare variable $qcerr:QC0112_MESSAGE_1    := 'Invalid query. Unsupported functional pseudo-class "';
declare variable $qcerr:QC0112_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0112_MESSAGE_3    := '".';

declare variable $qcerr:QC0113              := 'QC0113';
declare variable $qcerr:QC0113_MESSAGE_1    := 'Invalid query. Unsupported compound selector "';
declare variable $qcerr:QC0113_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0113_MESSAGE_3    := '".';

declare variable $qcerr:QC0114              := 'QC0114';
declare variable $qcerr:QC0114_MESSAGE_1    := 'Invalid query. Unsupported compound selector "';
declare variable $qcerr:QC0114_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0114_MESSAGE_3    := '".';

declare variable $qcerr:QC0115              := 'QC0115';
declare variable $qcerr:QC0115_MESSAGE_1    := 'Invalid query. Please, verify that the "an" part (an+b) of the expression "';
declare variable $qcerr:QC0115_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0115_MESSAGE_3    := '" contains a valid integer.';

declare variable $qcerr:QC0116              := 'QC0116';
declare variable $qcerr:QC0116_MESSAGE_1    := 'Invalid query. Please, verify that the "an" part (an+b) of the expression "';
declare variable $qcerr:QC0116_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0116_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0117              := 'QC0117';
declare variable $qcerr:QC0117_MESSAGE_1    := 'Invalid query. Please, verify that the "b" part (an+b) of the expression "';
declare variable $qcerr:QC0117_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0117_MESSAGE_3    := '" is well-formed.';

declare variable $qcerr:QC0118              := 'QC0118';
declare variable $qcerr:QC0118_MESSAGE_1    := 'Invalid query. Please, verify that the "b" part (an+b) of the expression "';
declare variable $qcerr:QC0118_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0118_MESSAGE_3    := '" contains a valid integer.';

declare variable $qcerr:QC0119              := 'QC0119';
declare variable $qcerr:QC0119_MESSAGE_1    := 'Invalid query. Please, verify that the "b" part (an+b) of the expression "';
declare variable $qcerr:QC0119_MESSAGE_2    := '" in the UniQue or Selectors query "';
declare variable $qcerr:QC0119_MESSAGE_3    := '" is well-formed.';

(: Query converter errors :)
declare variable $qcerr:QC0201              := 'QC0201';
declare variable $qcerr:QC0201_MESSAGE_1    := 'Invalid query. Please, verify that the query:&#xA;&#xA;';
declare variable $qcerr:QC0201_MESSAGE_2    := '&#xA;&#xA;which is written in UniQue or Selectors is well-formed. Error details:';

declare variable $qcerr:QC0202              := 'QC0202';
declare variable $qcerr:QC0202_MESSAGE_1    := 'Invalid query. Please, verify that the query:&#xA;&#xA;';
declare variable $qcerr:QC0202_MESSAGE_2    := '&#xA;&#xA;which is written in UniQue, Selectors, XPath, or XQuery is well-formed. Error details:';