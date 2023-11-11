xquery version "1.0" encoding "UTF-8";

(: This file was generated on Thu Aug 21, 2014 10:34 (UTC+03) by REx v5.30 which is Copyright (c) 1979-2014 by Gunther Rademacher <grd@gmx.net> :)
(: REx command line: unique_level_1.ebnf -xquery -tree :)

(:~
 : The parser that was generated for the unique_level_1 grammar.
 :)
module namespace p="http://queryconverters.28.io/unique_level_1_parser";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

(:~
 : The index of the parser state for accessing the combined
 : (i.e. level > 1) lookahead code.
 :)
declare variable $p:lk as xs:integer := 1;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the token that has been shifted.
 :)
declare variable $p:b0 as xs:integer := 2;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the token that has been shifted.
 :)
declare variable $p:e0 as xs:integer := 3;

(:~
 : The index of the parser state for accessing the code of the
 : level-1-lookahead token.
 :)
declare variable $p:l1 as xs:integer := 4;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the level-1-lookahead token.
 :)
declare variable $p:b1 as xs:integer := 5;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the level-1-lookahead token.
 :)
declare variable $p:e1 as xs:integer := 6;

(:~
 : The index of the parser state for accessing the code of the
 : level-2-lookahead token.
 :)
declare variable $p:l2 as xs:integer := 7;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the level-2-lookahead token.
 :)
declare variable $p:b2 as xs:integer := 8;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the level-2-lookahead token.
 :)
declare variable $p:e2 as xs:integer := 9;

(:~
 : The index of the parser state for accessing the code of the
 : level-3-lookahead token.
 :)
declare variable $p:l3 as xs:integer := 10;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the level-3-lookahead token.
 :)
declare variable $p:b3 as xs:integer := 11;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the level-3-lookahead token.
 :)
declare variable $p:e3 as xs:integer := 12;

(:~
 : The index of the parser state for accessing the token code that
 : was expected when an error was found.
 :)
declare variable $p:error as xs:integer := 13;

(:~
 : The index of the parser state that points to the first entry
 : used for collecting action results.
 :)
declare variable $p:result as xs:integer := 14;

(:~
 : The codepoint to charclass mapping for 7 bit codepoints.
 :)
declare variable $p:MAP0 as xs:integer+ :=
(
  0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 1, 0, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 4, 5, 6, 7, 4, 4,
  8, 9, 10, 11, 12, 13, 14, 15, 4, 16, 17, 17, 17, 18, 19, 20, 19, 17, 17, 21, 4, 4, 22, 23, 4, 4, 24, 24, 24, 24, 24,
  24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25, 26, 27, 28, 24, 4, 29, 29, 29,
  29, 30, 31, 24, 24, 24, 24, 24, 24, 24, 32, 33, 24, 24, 24, 24, 34, 24, 24, 24, 24, 24, 24, 4, 35, 4, 36, 4
);

(:~
 : The codepoint to charclass mapping for codepoints below the surrogate block.
 :)
declare variable $p:MAP1 as xs:integer+ :=
(
  54, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62,
  62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 133, 126, 149,
  181, 164, 212, 196, 227, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165,
  165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165,
  165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 165, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 1, 0, 2, 3, 0, 0, 37, 4, 5, 6, 7, 4, 4, 8, 9, 10, 11, 12, 13, 14, 15,
  4, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 16, 17, 17, 17, 18, 19, 20, 19, 17, 17, 21, 4, 4,
  22, 23, 4, 29, 29, 29, 29, 30, 31, 24, 24, 24, 24, 24, 24, 24, 32, 33, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25,
  26, 27, 28, 24, 24, 24, 24, 34, 24, 24, 24, 24, 24, 24, 4, 35, 4, 36, 4
);

(:~
 : The codepoint to charclass mapping for codepoints above the surrogate block.
 :)
declare variable $p:MAP2 as xs:integer+ :=
(
  57344, 65536, 65533, 1114111, 24, 24
);

(:~
 : The token-set-id to DFA-initial-state mapping.
 :)
declare variable $p:INITIAL as xs:integer+ :=
(
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 275, 276, 277
);

(:~
 : The DFA transition table.
 :)
declare variable $p:TRANSITION as xs:integer+ :=
(
  615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 1378, 608, 625, 614, 642, 651, 1266,
  669, 869, 684, 970, 702, 1562, 930, 1132, 615, 1378, 608, 625, 614, 642, 651, 1585, 712, 704, 724, 1130, 702, 985,
  1131, 1132, 615, 1378, 608, 625, 614, 642, 736, 813, 753, 789, 765, 777, 787, 757, 778, 779, 615, 615, 615, 1166,
  1637, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 616, 900, 1166, 1031, 615, 1458, 673, 809, 690,
  615, 692, 688, 615, 693, 694, 615, 615, 1177, 821, 1637, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461,
  615, 615, 1579, 1583, 1637, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 643, 1547, 1166, 1025,
  615, 1458, 673, 835, 951, 615, 953, 949, 615, 954, 955, 615, 615, 615, 1166, 1019, 615, 842, 1484, 797, 841, 675, 843,
  839, 676, 844, 1461, 615, 1191, 1194, 1195, 1637, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615,
  852, 856, 864, 1637, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 615, 1160, 1060, 1637, 1165,
  878, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 615, 615, 1123, 1637, 615, 895, 673, 797, 1457, 615, 1459,
  617, 615, 1460, 1461, 615, 915, 908, 1264, 1365, 728, 939, 923, 669, 869, 947, 1130, 867, 716, 1131, 1132, 615, 615,
  1335, 963, 1037, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 615, 1154, 1167, 1527, 728, 978,
  1004, 1012, 1045, 1053, 1074, 1100, 1108, 1116, 1132, 615, 615, 1154, 1167, 1527, 728, 978, 1140, 1148, 1659, 1175,
  1185, 661, 1203, 1542, 1132, 615, 615, 1154, 1167, 1527, 728, 978, 1211, 1219, 1237, 1245, 1257, 1287, 1274, 1282,
  1132, 615, 615, 1154, 1167, 1527, 728, 978, 1140, 1148, 1659, 1295, 1185, 1299, 1307, 1315, 1330, 615, 615, 1154,
  1167, 1527, 728, 978, 1211, 1219, 1237, 1245, 1257, 1249, 1274, 1282, 1132, 615, 615, 1343, 1351, 1637, 615, 1458,
  673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 615, 741, 745, 1637, 1359, 1458, 673, 797, 1457, 615, 1459, 617,
  615, 1460, 1461, 615, 615, 615, 1081, 1637, 615, 1373, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 992, 996,
  827, 1505, 728, 870, 923, 669, 869, 947, 1130, 867, 716, 1131, 1132, 615, 615, 801, 1386, 1637, 615, 1458, 673, 797,
  1457, 615, 1459, 617, 615, 1460, 1461, 615, 1394, 1398, 1322, 1406, 1229, 1600, 1414, 1430, 1445, 1453, 1469, 1437,
  1434, 1421, 1422, 615, 883, 883, 887, 1637, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 615, 630,
  634, 1637, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 992, 996, 1066, 1477, 728, 1492, 1140,
  1148, 1659, 1175, 1185, 661, 1203, 1542, 1132, 615, 992, 996, 1066, 1477, 728, 1492, 1140, 1513, 1659, 1175, 1185,
  661, 1203, 1542, 1132, 615, 992, 996, 1066, 1477, 728, 1492, 1140, 1148, 1659, 1521, 1185, 661, 1203, 1542, 1132, 615,
  992, 996, 827, 1505, 769, 870, 1535, 669, 869, 947, 1130, 867, 716, 1131, 1132, 615, 992, 996, 827, 1505, 728, 870,
  1092, 669, 1555, 1575, 1088, 867, 716, 1131, 1132, 615, 992, 996, 827, 1505, 728, 870, 923, 669, 1567, 1593, 1130,
  936, 933, 1131, 1132, 615, 1226, 1608, 1616, 1637, 615, 1458, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615,
  615, 656, 1624, 1637, 615, 1632, 673, 797, 1457, 615, 1459, 617, 615, 1460, 1461, 615, 1378, 608, 1645, 1653, 642,
  651, 1499, 669, 704, 724, 1130, 702, 985, 1131, 1132, 615, 409, 0, 409, 417, 409, 417, 409, 0, 0, 0, 0, 0, 0, 0, 0,
  29, 30, 409, 409, 425, 425, 425, 0, 0, 0, 0, 36, 0, 0, 0, 0, 0, 0, 1175, 417, 0, 0, 0, 0, 0, 0, 0, 30, 425, 1175,
  1179, 29, 30, 0, 0, 0, 0, 38, 0, 0, 0, 0, 1256, 1257, 106, 107, 29, 29, 30, 30, 2480, 1703, 0, 0, 0, 0, 0, 0, 0, 2304,
  0, 1703, 1703, 0, 52, 0, 0, 0, 0, 0, 0, 1280, 30, 0, 0, 0, 0, 0, 0, 0, 66, 0, 0, 1175, 1179, 29, 30, 0, 2480, 0, 29,
  0, 30, 2480, 1703, 0, 0, 0, 0, 0, 1175, 0, 1703, 0, 52, 0, 0, 0, 0, 0, 0, 1703, 0, 425, 1205, 1207, 57, 59, 0, 0, 0,
  0, 3200, 0, 0, 0, 0, 0, 0, 1175, 0, 57, 0, 59, 2503, 1737, 0, 0, 0, 0, 112, 1205, 0, 1737, 0, 88, 0, 0, 0, 0, 0, 0,
  1703, 52, 1205, 1207, 57, 59, 2503, 1737, 0, 0, 0, 0, 0, 101, 0, 0, 1205, 1207, 57, 59, 0, 2503, 29, 29, 30, 30, 0, 0,
  0, 0, 0, 0, 3328, 3328, 1280, 1280, 30, 30, 0, 0, 0, 0, 0, 1205, 0, 1207, 0, 39, 39, 39, 39, 0, 0, 1175, 0, 0, 0,
  1175, 1175, 1175, 29, 29, 1280, 1280, 0, 0, 0, 0, 0, 1408, 29, 30, 0, 0, 0, 0, 2304, 0, 2688, 0, 0, 0, 0, 2688, 0, 35,
  0, 2688, 2688, 35, 2688, 0, 0, 0, 0, 0, 1175, 1179, 29, 30, 2480, 2480, 2480, 1792, 0, 0, 29, 30, 0, 0, 0, 0, 3456, 0,
  0, 0, 0, 0, 0, 1175, 2048, 0, 0, 29, 30, 0, 0, 0, 29, 0, 29, 0, 0, 0, 26, 22, 2838, 0, 2838, 22, 22, 0, 0, 0, 0, 26,
  22, 22, 2480, 1703, 0, 0, 1175, 1175, 1179, 1179, 29, 30, 2480, 1703, 0, 0, 80, 0, 0, 1175, 1179, 29, 30, 47, 0, 2480,
  1703, 1703, 0, 0, 0, 0, 0, 0, 29, 1280, 0, 0, 0, 0, 0, 0, 0, 2944, 2944, 2944, 2944, 0, 0, 1175, 1179, 29, 30, 2480,
  1703, 0, 52, 0, 1206, 1208, 58, 60, 1582, 0, 2480, 1703, 0, 0, 0, 0, 80, 1175, 0, 0, 0, 0, 1179, 1175, 1175, 0, 1175,
  1175, 1175, 2493, 1726, 63, 0, 1175, 1219, 1179, 1220, 29, 69, 30, 70, 2504, 1738, 75, 0, 0, 1408, 1179, 29, 30, 0, 0,
  0, 1179, 29, 1280, 0, 0, 0, 1179, 1280, 30, 0, 0, 0, 1179, 29, 30, 0, 31, 77, 0, 1233, 1234, 83, 84, 2480, 2517, 1703,
  1750, 87, 0, 89, 0, 91, 0, 0, 1792, 1792, 1792, 0, 0, 1175, 0, 0, 0, 1175, 1175, 1194, 1245, 1246, 95, 96, 2529, 1762,
  99, 0, 0, 1920, 1920, 1920, 0, 0, 1175, 1179, 29, 30, 2480, 1703, 0, 66, 1175, 1175, 1179, 1179, 100, 0, 102, 0, 1256,
  1257, 106, 107, 2540, 1773, 0, 110, 0, 111, 0, 1175, 1179, 113, 114, 2547, 1780, 0, 117, 0, 0, 2048, 2048, 2048, 0, 0,
  1175, 1179, 29, 30, 2480, 1703, 0, 0, 0, 0, 2493, 1726, 0, 0, 1175, 1219, 1179, 1220, 29, 69, 30, 70, 2504, 1738, 0,
  0, 0, 1568, 0, 1568, 0, 0, 0, 1792, 0, 1792, 0, 0, 0, 0, 0, 0, 0, 1175, 1194, 1703, 1750, 0, 0, 0, 0, 0, 0, 39, 39,
  1245, 1246, 95, 96, 2529, 1762, 0, 0, 0, 2560, 0, 0, 0, 0, 2560, 0, 0, 1175, 2540, 1773, 0, 0, 0, 0, 0, 1175, 2493,
  1726, 64, 0, 1175, 1219, 1179, 1220, 29, 69, 30, 70, 2504, 1738, 64, 0, 0, 3584, 0, 0, 0, 0, 0, 0, 50, 51, 78, 0,
  1233, 1234, 83, 84, 2480, 2517, 1703, 1750, 64, 0, 78, 0, 0, 0, 1256, 1257, 106, 107, 1245, 1246, 95, 96, 2529, 1762,
  64, 0, 22, 0, 0, 0, 0, 1175, 1175, 1179, 1179, 2540, 1773, 64, 78, 0, 0, 0, 1175, 1179, 113, 114, 2547, 1780, 78, 0,
  0, 103, 1256, 1257, 106, 107, 1703, 1750, 0, 0, 0, 0, 92, 0, 1256, 1257, 106, 107, 2540, 1773, 0, 0, 0, 92, 0, 1175,
  1179, 113, 114, 2547, 1780, 0, 92, 0, 24, 0, 0, 0, 24, 24, 1175, 29, 30, 2480, 1703, 92, 0, 0, 0, 31, 0, 31, 2944,
  2944, 0, 3072, 0, 0, 0, 0, 3072, 3112, 0, 3112, 3112, 3112, 3112, 0, 0, 1175, 0, 896, 1024, 768, 640, 512, 0, 0, 1179,
  1179, 29, 30, 0, 47, 1920, 0, 0, 29, 30, 0, 0, 0, 409, 409, 0, 0, 409, 0, 3328, 3328, 3328, 3328, 0, 0, 1175, 24, 0,
  0, 0, 0, 28, 24, 24, 0, 24, 24, 24, 0, 28, 28, 1179, 44, 45, 0, 49, 2480, 1703, 0, 65, 24, 24, 28, 28, 44, 45, 49, 50,
  0, 0, 0, 0, 44, 44, 45, 45, 49, 50, 0, 0, 79, 0, 0, 24, 28, 44, 45, 0, 79, 24, 28, 44, 45, 49, 49, 50, 50, 0, 65, 0,
  0, 0, 0, 29, 30, 0, 0, 0, 0, 0, 0, 24, 28, 44, 45, 49, 50, 0, 65, 0, 1179, 1179, 1195, 29, 30, 0, 2480, 1703, 0, 0, 0,
  0, 1408, 1408, 0, 1206, 1208, 58, 60, 2480, 2480, 2480, 1703, 0, 0, 0, 1175, 0, 1179, 1179, 1179, 29, 30, 0, 2480, 29,
  69, 30, 70, 2504, 1738, 0, 76, 1703, 1750, 0, 0, 0, 90, 0, 0, 1179, 1195, 29, 30, 1582, 1568, 2480, 1703, 52, 0, 1175,
  1175, 1179, 1179, 113, 114, 2547, 1780, 0, 0, 0, 30, 0, 30, 0, 0, 66, 0, 1175, 1179, 29, 30, 2480, 2480, 1703, 0, 0,
  66, 0, 80, 1175, 1179, 29, 30, 2480, 2480, 1703, 1703, 0, 66, 0, 0, 0, 0, 34, 0, 0, 0, 0, 0, 0, 1175, 0, 1179, 1703,
  1703, 0, 0, 0, 0, 80, 0, 24, 28, 29, 30, 49, 49, 49, 3584, 0, 3584, 0, 37, 0, 3584, 3584, 3621, 3584, 0, 3584, 3584,
  0, 0, 1175, 38, 0, 2176, 2176, 2176, 0, 0, 1175, 2176, 0, 0, 29, 30, 0, 0, 0, 1179, 29, 30, 0, 0, 409, 409, 425, 425,
  425, 0, 0, 1175, 409, 0, 0, 1179, 29, 30, 0, 0, 1233, 1234, 83, 84, 2480, 2517
);

(:~
 : The DFA-state to expected-token-set mapping.
 :)
declare variable $p:EXPECTED as xs:integer+ :=
(
  30, 34, 38, 42, 46, 50, 56, 60, 64, 68, 72, 79, 82, 52, 89, 82, 85, 91, 95, 97, 73, 82, 97, 73, 82, 84, 74, 83, 75,
  85, 256, 1048576, 134217728, 524292, 67108868, 1280, 1048832, 772, 134742020, 8389888, 135266564, 2370308, 83886332,
  2894596, 181408004, 181539072, 218104060, 181539076, 46395396, 180613124, 181137412, 256, 256, 256, 1280, 1280, 4,
  1280, 1280, 1280, 512, 512, 264192, 264192, 8196, 64, 128, 32, 16, 8, 4096, 131072, 122884, 256, 1280, 512, 512,
  262144, 4096, 512, 264192, 262144, 262144, 4096, 131072, 131072, 131072, 256, 1280, 512, 512, 512, 512, 262144,
  262144, 4096, 4096, 131072, 131072, 131072, 131072
);

(:~
 : The token-string table.
 :)
declare variable $p:TOKEN as xs:string+ :=
(
  "(0)",
  "END",
  "S",
  "'~='",
  "'|='",
  "'^='",
  "'$='",
  "'*='",
  "IDENT",
  "STRING",
  "FUNCTION",
  "NUMBER",
  "HASH",
  "PLUS",
  "GREATER",
  "COMMA",
  "TILDE",
  "NOT",
  "DIMENSION",
  "')'",
  "'*'",
  "'-'",
  "'.'",
  "':'",
  "'='",
  "'['",
  "']'",
  "'|'"
);

(:~
 : Match next token in input string, starting at given index, using
 : the DFA entry state for the set of tokens that are expected in
 : the current context.
 :
 : @param $input the input string.
 : @param $begin the index where to start in input string.
 : @param $token-set the expected token set id.
 : @return a sequence of three: the token code of the result token,
 : with input string begin and end positions. If there is no valid
 : token, return the negative id of the DFA state that failed, along
 : with begin and end positions of the longest viable prefix.
 :)
declare function p:match($input as xs:string,
                         $begin as xs:integer,
                         $token-set as xs:integer) as xs:integer+
{
  let $result := $p:INITIAL[1 + $token-set]
  return p:transition($input,
                      $begin,
                      $begin,
                      $begin,
                      $result,
                      $result mod 128,
                      0)
};

(:~
 : The DFA state transition function. If we are in a valid DFA state, save
 : it's result annotation, consume one input codepoint, calculate the next
 : state, and use tail recursion to do the same again. Otherwise, return
 : any valid result or a negative DFA state id in case of an error.
 :
 : @param $input the input string.
 : @param $begin the begin index of the current token in the input string.
 : @param $current the index of the current position in the input string.
 : @param $end the end index of the result in the input string.
 : @param $result the result code.
 : @param $current-state the current DFA state.
 : @param $previous-state the  previous DFA state.
 : @return a sequence of three: the token code of the result token,
 : with input string begin and end positions. If there is no valid
 : token, return the negative id of the DFA state that failed, along
 : with begin and end positions of the longest viable prefix.
 :)
declare function p:transition($input as xs:string,
                              $begin as xs:integer,
                              $current as xs:integer,
                              $end as xs:integer,
                              $result as xs:integer,
                              $current-state as xs:integer,
                              $previous-state as xs:integer) as xs:integer+
{
  if ($current-state = 0) then
    let $result := $result idiv 128
    return
      if ($result != 0) then
      (
        $result - 1,
        $begin,
        $end
      )
      else
      (
        - $previous-state,
        $begin,
        $current - 1
      )
  else
    let $c0 := (string-to-codepoints(substring($input, $current, 1)), 0)[1]
    let $c1 :=
      if ($c0 < 128) then
        $p:MAP0[1 + $c0]
      else if ($c0 < 55296) then
        let $c1 := $c0 idiv 16
        let $c2 := $c1 idiv 64
        return $p:MAP1[1 + $c0 mod 16 + $p:MAP1[1 + $c1 mod 64 + $p:MAP1[1 + $c2]]]
      else
        p:map2($c0, 1, 2)
    let $current := $current + 1
    let $i0 := 128 * $c1 + $current-state - 1
    let $i1 := $i0 idiv 8
    let $next-state := $p:TRANSITION[$i0 mod 8 + $p:TRANSITION[$i1 + 1] + 1]
    return
      if ($next-state > 127) then
        p:transition($input, $begin, $current, $current, $next-state, $next-state mod 128, $current-state)
      else
        p:transition($input, $begin, $current, $end, $result, $next-state, $current-state)
};

(:~
 : Recursively translate one 32-bit chunk of an expected token bitset
 : to the corresponding sequence of token strings.
 :
 : @param $result the result of previous recursion levels.
 : @param $chunk the 32-bit chunk of the expected token bitset.
 : @param $base-token-code the token code of bit 0 in the current chunk.
 : @return the set of token strings.
 :)
declare function p:token($result as xs:string*,
                         $chunk as xs:integer,
                         $base-token-code as xs:integer) as xs:string*
{
  if ($chunk = 0) then
    $result
  else
    p:token
    (
      ($result, if ($chunk mod 2 != 0) then $p:TOKEN[$base-token-code] else ()),
      if ($chunk < 0) then $chunk idiv 2 + 2147483648 else $chunk idiv 2,
      $base-token-code + 1
    )
};

(:~
 : Calculate expected token set for a given DFA state as a sequence
 : of strings.
 :
 : @param $state the DFA state.
 : @return the set of token strings
 :)
declare function p:expected-token-set($state as xs:integer) as xs:string*
{
  if ($state > 0) then
    for $t in 0 to 0
    let $i0 := $t * 117 + $state - 1
    let $i1 := $i0 idiv 4
    return p:token((), $p:EXPECTED[$i0 mod 4 + $p:EXPECTED[$i1 + 1] + 1], $t * 32 + 1)
  else
    ()
};

(:~
 : Classify codepoint by doing a tail recursive binary search for a
 : matching codepoint range entry in MAP2, the codepoint to charclass
 : map for codepoints above the surrogate block.
 :
 : @param $c the codepoint.
 : @param $lo the binary search lower bound map index.
 : @param $hi the binary search upper bound map index.
 : @return the character class.
 :)
declare function p:map2($c as xs:integer, $lo as xs:integer, $hi as xs:integer) as xs:integer
{
  if ($lo > $hi) then
    0
  else
    let $m := ($hi + $lo) idiv 2
    return
      if ($p:MAP2[$m] > $c) then
        p:map2($c, $lo, $m - 1)
      else if ($p:MAP2[2 + $m] < $c) then
        p:map2($c, $m + 1, $hi)
      else
        $p:MAP2[4 + $m]
};

(:~
 : Parse the 1st loop of production combinator (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(17, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-combinator-1($input, $state)
};

(:~
 : Parse the 2nd loop of production combinator (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(17, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-combinator-2($input, $state)
};

(:~
 : Parse the 3rd loop of production combinator (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator-3($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(17, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-combinator-3($input, $state)
};

(:~
 : Parse the 4th loop of production combinator (one or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator-4($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:shift(2, $input, $state)                (: S :)
    let $state := p:lookahead1(17, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        p:parse-combinator-4($input, $state)
};

(:~
 : Parse combinator.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state :=
    if ($state[$p:l1] = 13) then                            (: PLUS :)
      let $state := p:shift(13, $input, $state)             (: PLUS :)
      let $state := p:parse-combinator-1($input, $state)
      return $state
    else if ($state[$p:l1] = 14) then                       (: GREATER :)
      let $state := p:shift(14, $input, $state)             (: GREATER :)
      let $state := p:parse-combinator-2($input, $state)
      return $state
    else if ($state[$p:l1] = 16) then                       (: TILDE :)
      let $state := p:shift(16, $input, $state)             (: TILDE :)
      let $state := p:parse-combinator-3($input, $state)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:parse-combinator-4($input, $state)
      return $state
  let $end := $state[$p:e0]
  return p:reduce($state, "combinator", $count, $begin, $end)
};

(:~
 : Parse negation_arg.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-negation_arg($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state :=
    if ($state[$p:l1] eq 27) then                           (: '|' :)
      let $state := p:lookahead2(6, $input, $state)         (: IDENT | '*' :)
      return $state
    else if ($state[$p:l1] = (8,                            (: IDENT :)
                              20)) then                     (: '*' :)
      let $state := p:lookahead2(8, $input, $state)         (: S | ')' | '|' :)
      let $state :=
        if ($state[$p:lk] = (872,                           (: IDENT '|' :)
                             884)) then                     (: '*' '|' :)
          let $state := p:lookahead3(6, $input, $state)     (: IDENT | '*' :)
          return $state
        else
          $state
      return $state
    else
      ($state[$p:l1], subsequence($state, $p:lk + 1))
  let $state :=
    if ($state[$p:lk] = 72                                  (: IDENT S :)
     or $state[$p:lk] = 283                                 (: '|' IDENT :)
     or $state[$p:lk] = 616                                 (: IDENT ')' :)
     or $state[$p:lk] = 9064                                (: IDENT '|' IDENT :)
     or $state[$p:lk] = 9076) then                          (: '*' '|' IDENT :)
      let $state := p:parse-type_selector($input, $state)
      return $state
    else if ($state[$p:lk] = 12) then                       (: HASH :)
      let $state := p:shift(12, $input, $state)             (: HASH :)
      return $state
    else if ($state[$p:lk] = 22) then                       (: '.' :)
      let $state := p:parse-class($input, $state)
      return $state
    else if ($state[$p:lk] = 25) then                       (: '[' :)
      let $state := p:parse-attrib($input, $state)
      return $state
    else if ($state[$p:lk] = 23) then                       (: ':' :)
      let $state := p:parse-pseudo($input, $state)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:parse-universal($input, $state)
      return $state
  let $end := $state[$p:e0]
  return p:reduce($state, "negation_arg", $count, $begin, $end)
};

(:~
 : Parse the 1st loop of production negation (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-negation-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(14, $input, $state)          (: S | IDENT | HASH | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-negation-1($input, $state)
};

(:~
 : Parse the 2nd loop of production negation (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-negation-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(3, $input, $state)           (: S | ')' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-negation-2($input, $state)
};

(:~
 : Parse negation.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-negation($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:shift(17, $input, $state)                 (: NOT :)
  let $state := p:parse-negation-1($input, $state)
  let $state := p:parse-negation_arg($input, $state)
  let $state := p:parse-negation-2($input, $state)
  let $state := p:shift(19, $input, $state)                 (: ')' :)
  let $end := $state[$p:e0]
  return p:reduce($state, "negation", $count, $begin, $end)
};

(:~
 : Parse the 2nd loop of production expression (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-expression-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(13, $input, $state)          (: S | IDENT | STRING | NUMBER | PLUS | DIMENSION | ')' |
                                                               '-' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-expression-2($input, $state)
};

(:~
 : Parse the 1st loop of production expression (one or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-expression-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state :=
      if ($state[$p:l1] = 13) then                          (: PLUS :)
        let $state := p:shift(13, $input, $state)           (: PLUS :)
        return $state
      else if ($state[$p:l1] = 21) then                     (: '-' :)
        let $state := p:shift(21, $input, $state)           (: '-' :)
        return $state
      else if ($state[$p:l1] = 18) then                     (: DIMENSION :)
        let $state := p:shift(18, $input, $state)           (: DIMENSION :)
        return $state
      else if ($state[$p:l1] = 11) then                     (: NUMBER :)
        let $state := p:shift(11, $input, $state)           (: NUMBER :)
        return $state
      else if ($state[$p:l1] = 9) then                      (: STRING :)
        let $state := p:shift(9, $input, $state)            (: STRING :)
        return $state
      else if ($state[$p:error]) then
        $state
      else
        let $state := p:shift(8, $input, $state)            (: IDENT :)
        return $state
    let $state := p:parse-expression-2($input, $state)
    return
      if ($state[$p:l1] = 19) then                          (: ')' :)
        $state
      else
        p:parse-expression-1($input, $state)
};

(:~
 : Parse expression.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-expression($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:parse-expression-1($input, $state)
  let $end := $state[$p:e0]
  return p:reduce($state, "expression", $count, $begin, $end)
};

(:~
 : Parse the 1st loop of production functional_pseudo (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-functional_pseudo-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(11, $input, $state)          (: S | IDENT | STRING | NUMBER | PLUS | DIMENSION | '-' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-functional_pseudo-1($input, $state)
};

(:~
 : Parse functional_pseudo.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-functional_pseudo($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:shift(10, $input, $state)                 (: FUNCTION :)
  let $state := p:parse-functional_pseudo-1($input, $state)
  let $state := p:parse-expression($input, $state)
  let $state := p:shift(19, $input, $state)                 (: ')' :)
  let $end := $state[$p:e0]
  return p:reduce($state, "functional_pseudo", $count, $begin, $end)
};

(:~
 : Parse pseudo.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-pseudo($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:shift(23, $input, $state)                 (: ':' :)
  let $state := p:lookahead1(9, $input, $state)             (: IDENT | FUNCTION | ':' :)
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:l1] = 23) then                       (: ':' :)
      let $state := p:shift(23, $input, $state)             (: ':' :)
      return $state
    else
      $state
  let $state := p:lookahead1(5, $input, $state)             (: IDENT | FUNCTION :)
  let $state :=
    if ($state[$p:l1] = 8) then                             (: IDENT :)
      let $state := p:shift(8, $input, $state)              (: IDENT :)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:parse-functional_pseudo($input, $state)
      return $state
  let $end := $state[$p:e0]
  return p:reduce($state, "pseudo", $count, $begin, $end)
};

(:~
 : Parse the 1st loop of production attrib (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(10, $input, $state)          (: S | IDENT | '*' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-attrib-1($input, $state)
};

(:~
 : Parse the 2nd loop of production attrib (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(12, $input, $state)          (: S | INCLUDES | DASHMATCH | PREFIXMATCH | SUFFIXMATCH |
                                                               SUBSTRINGMATCH | '=' | ']' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-attrib-2($input, $state)
};

(:~
 : Parse the 3rd loop of production attrib (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib-3($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(7, $input, $state)           (: S | IDENT | STRING :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-attrib-3($input, $state)
};

(:~
 : Parse the 4th loop of production attrib (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib-4($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(4, $input, $state)           (: S | ']' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-attrib-4($input, $state)
};

(:~
 : Parse attrib.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:shift(25, $input, $state)                 (: '[' :)
  let $state := p:parse-attrib-1($input, $state)
  let $state :=
    if ($state[$p:l1] eq 8) then                            (: IDENT :)
      let $state := p:lookahead2(16, $input, $state)        (: S | INCLUDES | DASHMATCH | PREFIXMATCH | SUFFIXMATCH |
                                                               SUBSTRINGMATCH | '=' | ']' | '|' :)
      return $state
    else
      ($state[$p:l1], subsequence($state, $p:lk + 1))
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:lk] = 20                             (: '*' :)
          or $state[$p:lk] = 27                             (: '|' :)
          or $state[$p:lk] = 872) then                      (: IDENT '|' :)
      let $state := p:parse-namespace_prefix($input, $state)
      return $state
    else
      $state
  let $state := p:lookahead1(0, $input, $state)             (: IDENT :)
  let $state := p:shift(8, $input, $state)                  (: IDENT :)
  let $state := p:parse-attrib-2($input, $state)
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:l1] != 26) then                      (: ']' :)
      let $state :=
        if ($state[$p:l1] = 5) then                         (: PREFIXMATCH :)
          let $state := p:shift(5, $input, $state)          (: PREFIXMATCH :)
          return $state
        else if ($state[$p:l1] = 6) then                    (: SUFFIXMATCH :)
          let $state := p:shift(6, $input, $state)          (: SUFFIXMATCH :)
          return $state
        else if ($state[$p:l1] = 7) then                    (: SUBSTRINGMATCH :)
          let $state := p:shift(7, $input, $state)          (: SUBSTRINGMATCH :)
          return $state
        else if ($state[$p:l1] = 24) then                   (: '=' :)
          let $state := p:shift(24, $input, $state)         (: '=' :)
          return $state
        else if ($state[$p:l1] = 3) then                    (: INCLUDES :)
          let $state := p:shift(3, $input, $state)          (: INCLUDES :)
          return $state
        else if ($state[$p:error]) then
          $state
        else
          let $state := p:shift(4, $input, $state)          (: DASHMATCH :)
          return $state
      let $state := p:parse-attrib-3($input, $state)
      let $state :=
        if ($state[$p:l1] = 8) then                         (: IDENT :)
          let $state := p:shift(8, $input, $state)          (: IDENT :)
          return $state
        else if ($state[$p:error]) then
          $state
        else
          let $state := p:shift(9, $input, $state)          (: STRING :)
          return $state
      let $state := p:parse-attrib-4($input, $state)
      return $state
    else
      $state
  let $state := p:shift(26, $input, $state)                 (: ']' :)
  let $end := $state[$p:e0]
  return p:reduce($state, "attrib", $count, $begin, $end)
};

(:~
 : Parse class.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-class($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:shift(22, $input, $state)                 (: '.' :)
  let $state := p:lookahead1(0, $input, $state)             (: IDENT :)
  let $state := p:shift(8, $input, $state)                  (: IDENT :)
  let $end := $state[$p:e0]
  return p:reduce($state, "class", $count, $begin, $end)
};

(:~
 : Parse universal.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-universal($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state :=
    if ($state[$p:l1] eq 20) then                           (: '*' :)
      let $state := p:lookahead2(20, $input, $state)        (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               ')' | '.' | ':' | '[' | '|' :)
      return $state
    else
      ($state[$p:l1], subsequence($state, $p:lk + 1))
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:lk] = 8                              (: IDENT :)
          or $state[$p:lk] = 27                             (: '|' :)
          or $state[$p:lk] = 884) then                      (: '*' '|' :)
      let $state := p:parse-namespace_prefix($input, $state)
      return $state
    else
      $state
  let $state := p:lookahead1(1, $input, $state)             (: '*' :)
  let $state := p:shift(20, $input, $state)                 (: '*' :)
  let $end := $state[$p:e0]
  return p:reduce($state, "universal", $count, $begin, $end)
};

(:~
 : Parse element_name.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-element_name($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:lookahead1(0, $input, $state)             (: IDENT :)
  let $state := p:shift(8, $input, $state)                  (: IDENT :)
  let $end := $state[$p:e0]
  return p:reduce($state, "element_name", $count, $begin, $end)
};

(:~
 : Parse namespace_prefix.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-namespace_prefix($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:l1] != 27) then                      (: '|' :)
      let $state :=
        if ($state[$p:l1] = 8) then                         (: IDENT :)
          let $state := p:shift(8, $input, $state)          (: IDENT :)
          return $state
        else if ($state[$p:error]) then
          $state
        else
          let $state := p:shift(20, $input, $state)         (: '*' :)
          return $state
      return $state
    else
      $state
  let $state := p:lookahead1(2, $input, $state)             (: '|' :)
  let $state := p:shift(27, $input, $state)                 (: '|' :)
  let $end := $state[$p:e0]
  return p:reduce($state, "namespace_prefix", $count, $begin, $end)
};

(:~
 : Parse type_selector.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-type_selector($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state :=
    if ($state[$p:l1] eq 8) then                            (: IDENT :)
      let $state := p:lookahead2(20, $input, $state)        (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               ')' | '.' | ':' | '[' | '|' :)
      return $state
    else
      ($state[$p:l1], subsequence($state, $p:lk + 1))
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:lk] = 20                             (: '*' :)
          or $state[$p:lk] = 27                             (: '|' :)
          or $state[$p:lk] = 872) then                      (: IDENT '|' :)
      let $state := p:parse-namespace_prefix($input, $state)
      return $state
    else
      $state
  let $state := p:parse-element_name($input, $state)
  let $end := $state[$p:e0]
  return p:reduce($state, "type_selector", $count, $begin, $end)
};

(:~
 : Parse the 1st loop of production simple_selector_sequence (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-simple_selector_sequence-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(18, $input, $state)          (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               '.' | ':' | '[' :)
    return
      if ($state[$p:l1] != 12                               (: HASH :)
      and $state[$p:l1] != 17                               (: NOT :)
      and $state[$p:l1] != 22                               (: '.' :)
      and $state[$p:l1] != 23                               (: ':' :)
      and $state[$p:l1] != 25) then                         (: '[' :)
        $state
      else
        let $state :=
          if ($state[$p:l1] = 12) then                      (: HASH :)
            let $state := p:shift(12, $input, $state)       (: HASH :)
            return $state
          else if ($state[$p:l1] = 22) then                 (: '.' :)
            let $state := p:parse-class($input, $state)
            return $state
          else if ($state[$p:l1] = 25) then                 (: '[' :)
            let $state := p:parse-attrib($input, $state)
            return $state
          else if ($state[$p:l1] = 23) then                 (: ':' :)
            let $state := p:parse-pseudo($input, $state)
            return $state
          else if ($state[$p:error]) then
            $state
          else
            let $state := p:parse-negation($input, $state)
            return $state
        return p:parse-simple_selector_sequence-1($input, $state)
};

(:~
 : Parse the 2nd loop of production simple_selector_sequence (one or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-simple_selector_sequence-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state :=
      if ($state[$p:l1] = 12) then                          (: HASH :)
        let $state := p:shift(12, $input, $state)           (: HASH :)
        return $state
      else if ($state[$p:l1] = 22) then                     (: '.' :)
        let $state := p:parse-class($input, $state)
        return $state
      else if ($state[$p:l1] = 25) then                     (: '[' :)
        let $state := p:parse-attrib($input, $state)
        return $state
      else if ($state[$p:l1] = 23) then                     (: ':' :)
        let $state := p:parse-pseudo($input, $state)
        return $state
      else if ($state[$p:error]) then
        $state
      else
        let $state := p:parse-negation($input, $state)
        return $state
    let $state := p:lookahead1(18, $input, $state)          (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               '.' | ':' | '[' :)
    return
      if ($state[$p:l1] != 12                               (: HASH :)
      and $state[$p:l1] != 17                               (: NOT :)
      and $state[$p:l1] != 22                               (: '.' :)
      and $state[$p:l1] != 23                               (: ':' :)
      and $state[$p:l1] != 25) then                         (: '[' :)
        $state
      else
        p:parse-simple_selector_sequence-2($input, $state)
};

(:~
 : Parse simple_selector_sequence.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-simple_selector_sequence($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:lookahead1(15, $input, $state)            (: IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
  let $state :=
    if ($state[$p:l1] = 8                                   (: IDENT :)
     or $state[$p:l1] = 20                                  (: '*' :)
     or $state[$p:l1] = 27) then                            (: '|' :)
      let $state :=
        if ($state[$p:l1] eq 27) then                       (: '|' :)
          let $state := p:lookahead2(6, $input, $state)     (: IDENT | '*' :)
          return $state
        else if ($state[$p:l1] = (8,                        (: IDENT :)
                                  20)) then                 (: '*' :)
          let $state := p:lookahead2(19, $input, $state)    (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               '.' | ':' | '[' | '|' :)
          let $state :=
            if ($state[$p:lk] = (872,                       (: IDENT '|' :)
                                 884)) then                 (: '*' '|' :)
              let $state := p:lookahead3(6, $input, $state) (: IDENT | '*' :)
              return $state
            else
              $state
          return $state
        else
          ($state[$p:l1], subsequence($state, $p:lk + 1))
      let $state :=
        if ($state[$p:lk] = 40                              (: IDENT END :)
         or $state[$p:lk] = 72                              (: IDENT S :)
         or $state[$p:lk] = 283                             (: '|' IDENT :)
         or $state[$p:lk] = 392                             (: IDENT HASH :)
         or $state[$p:lk] = 424                             (: IDENT PLUS :)
         or $state[$p:lk] = 456                             (: IDENT GREATER :)
         or $state[$p:lk] = 488                             (: IDENT COMMA :)
         or $state[$p:lk] = 520                             (: IDENT TILDE :)
         or $state[$p:lk] = 552                             (: IDENT NOT :)
         or $state[$p:lk] = 712                             (: IDENT '.' :)
         or $state[$p:lk] = 744                             (: IDENT ':' :)
         or $state[$p:lk] = 808                             (: IDENT '[' :)
         or $state[$p:lk] = 9064                            (: IDENT '|' IDENT :)
         or $state[$p:lk] = 9076) then                      (: '*' '|' IDENT :)
          let $state := p:parse-type_selector($input, $state)
          return $state
        else if ($state[$p:error]) then
          $state
        else
          let $state := p:parse-universal($input, $state)
          return $state
      let $state := p:parse-simple_selector_sequence-1($input, $state)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:parse-simple_selector_sequence-2($input, $state)
      return $state
  let $end := $state[$p:e0]
  return p:reduce($state, "simple_selector_sequence", $count, $begin, $end)
};

(:~
 : Parse the 1st loop of production selector (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selector-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    if ($state[$p:l1] = 1                                   (: END :)
     or $state[$p:l1] = 15) then                            (: COMMA :)
      $state
    else
      let $state := p:parse-combinator($input, $state)
      let $state := p:parse-simple_selector_sequence($input, $state)
      return p:parse-selector-1($input, $state)
};

(:~
 : Parse selector.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selector($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:parse-simple_selector_sequence($input, $state)
  let $state := p:parse-selector-1($input, $state)
  let $end := $state[$p:e0]
  return p:reduce($state, "selector", $count, $begin, $end)
};

(:~
 : Parse the 2nd loop of production selectors_group (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selectors_group-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(17, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-selectors_group-2($input, $state)
};

(:~
 : Parse the 1st loop of production selectors_group (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selectors_group-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    if ($state[$p:l1] != 15) then                           (: COMMA :)
      $state
    else
      let $state := p:shift(15, $input, $state)             (: COMMA :)
      let $state := p:parse-selectors_group-2($input, $state)
      let $state := p:parse-selector($input, $state)
      return p:parse-selectors_group-1($input, $state)
};

(:~
 : Parse selectors_group.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selectors_group($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $begin := $state[$p:e0]
  let $state := p:parse-selector($input, $state)
  let $state := p:parse-selectors_group-1($input, $state)
  let $end := $state[$p:e0]
  return p:reduce($state, "selectors_group", $count, $begin, $end)
};

(:~
 : Create a textual error message from a parsing error.
 :
 : @param $input the input string.
 : @param $error the parsing error descriptor.
 : @return the error message.
 :)
declare function p:error-message($input as xs:string, $error as element(error)) as xs:string
{
  let $begin := xs:integer($error/@b)
  let $context := string-to-codepoints(substring($input, 1, $begin - 1))
  let $linefeeds := index-of($context, 10)
  let $line := count($linefeeds) + 1
  let $column := ($begin - $linefeeds[last()], $begin)[1]
  return
    if ($error/@o) then
      concat
      (
        "syntax error, found ", $p:TOKEN[$error/@o + 1], "&#10;",
        "while expecting ", $p:TOKEN[$error/@x + 1], "&#10;",
        if ($error/@e = $begin) then
          ""
        else
          concat("after successfully scanning ", string($error/@e - $begin), " characters "),
        "at line ", string($line), ", column ", string($column), "&#10;",
        "...", substring($input, $begin, 32), "..."
      )
    else
      let $expected := p:expected-token-set($error/@s)
      return
        concat
        (
          "lexical analysis failed&#10;",
          "while expecting ",
          "["[exists($expected[2])],
          string-join($expected, ", "),
          "]"[exists($expected[2])],
          "&#10;",
          if ($error/@e = $begin) then
            ""
          else
            concat("after successfully scanning ", string($error/@e - $begin), " characters "),
          "at line ", string($line), ", column ", string($column), "&#10;",
          "...", substring($input, $begin, 32), "..."
        )
};

(:~
 : Shift one token, i.e. compare lookahead token 1 with expected
 : token and in case of a match, shift lookahead tokens down such that
 : l1 becomes the current token, and higher lookahead tokens move down.
 : When lookahead token 1 does not match the expected token, raise an
 : error by saving the expected token code in the error field of the
 : parser state.
 :
 : @param $code the expected token.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:shift($code as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else if ($state[$p:l1] = $code) then
  (
    subsequence($state, $p:l1, $p:e3 - $p:l1 + 1),
    0,
    $state[$p:e3],
    subsequence($state, $p:e3),
    let $begin := $state[$p:e0]
    let $end := $state[$p:b1]
    where $begin ne $end
    return
      text
      {
        substring($input, $begin, $end - $begin)
      },
    let $token := $p:TOKEN[1 + $state[$p:l1]]
    let $name := if (starts-with($token, "'")) then "TOKEN" else $token
    let $begin := $state[$p:b1]
    let $end := $state[$p:e1]
    return
      element {$name}
      {
        substring($input, $begin, $end - $begin)
      }
  )
  else
  (
    subsequence($state, 1, $p:error - 1),
    element error
    {
      attribute b {$state[$p:b1]},
      attribute e {$state[$p:e1]},
      if ($state[$p:l1] < 0) then
        attribute s {- $state[$p:l1]}
      else
        (attribute o {$state[$p:l1]}, attribute x {$code})
    },
    subsequence($state, $p:error + 1)
  )
};

(:~
 : Lookahead one token on level 1.
 :
 : @param $set the code of the DFA entry state for the set of valid tokens.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:lookahead1($set as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:l1] != 0) then
    $state
  else
    let $match := p:match($input, $state[$p:b1], $set)
    return
    (
      $match[1],
      subsequence($state, $p:lk + 1, $p:l1 - $p:lk - 1),
      $match,
      0, $match[3], 0,
      subsequence($state, $p:e2 + 1)
    )
};

(:~
 : Lookahead one token on level 2 with whitespace skipping.
 :
 : @param $set the code of the DFA entry state for the set of valid tokens.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:lookahead2($set as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  let $match :=
    if ($state[$p:l2] != 0) then
      subsequence($state, $p:l2, $p:e2 - $p:l2 + 1)
    else
      p:match($input, $state[$p:e1], $set)
  return
  (
    $match[1] * 32 + $state[$p:l1],
    subsequence($state, $p:lk + 1, $p:l2 - $p:lk - 1),
    $match,
    0, $match[3], 0,
    subsequence($state, $p:e3 + 1)
  )
};

(:~
 : Lookahead one token on level 3 with whitespace skipping.
 :
 : @param $set the code of the DFA entry state for the set of valid tokens.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:lookahead3($set as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  let $match :=
    if ($state[$p:l3] != 0) then
      subsequence($state, $p:l3, $p:e3 - $p:l3 + 1)
    else
      p:match($input, $state[$p:e2], $set)
  return
  (
    $match[1] * 1024 + $state[$p:lk],
    subsequence($state, $p:lk + 1, $p:l3 - $p:lk - 1),
    $match,
    subsequence($state, $p:e3 + 1)
  )
};

(:~
 : Reduce the result stack, creating a nonterminal element. Pop
 : $count elements off the stack, wrap them in a new element
 : named $name, and push the new element.
 :
 : @param $state the parser state.
 : @param $name the name of the result node.
 : @param $count the number of child nodes.
 : @param $begin the input index where the nonterminal begins.
 : @param $end the input index where the nonterminal ends.
 : @return the updated parser state.
 :)
declare function p:reduce($state as item()+, $name as xs:string, $count as xs:integer, $begin as xs:integer, $end as xs:integer) as item()+
{
  subsequence($state, 1, $count),
  element {$name}
  {
    subsequence($state, $count + 1)
  }
};

(:~
 : Parse start symbol selectors_group from given string.
 :
 : @param $s the string to be parsed.
 : @return the result as generated by parser actions.
 :)
declare function p:parse-selectors_group($s as xs:string) as item()*
{
  let $state := p:parse-selectors_group($s, (0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, false()))
  let $error := $state[$p:error]
  return
    if ($error) then
      element ERROR {$error/@*, p:error-message($s, $error)}
    else
      subsequence($state, $p:result)
};

(: End :)
