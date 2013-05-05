# -*- coding: latin-1 -*-

####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

#  for zone !

####################################################################################################
#
# Ephemeris
#

# $calendrier->set_ephemeris ({ 'place' => 'De', 'longitude' => 10.0, 'latitude' => 53.33 }); # Hamburg

$calendrier->set_ephemeris ({ 'place' => 'Fr', 'longitude' => 2.20, 'latitude' => 48.50 }); # Paris

####################################################################################################
#
# D�finition des trois zones de vacances pour la France
#

#
# 2010
#

# $calendrier->set_zone ('19 d�cembre  2009', ' 3 janvier   2010', 'a', 'b', 'c');
# 
# $calendrier->set_zone ('13 f�vrier   2010', '28 f�vrier   2010', 'a');
# $calendrier->set_zone (' 6 f�vrier   2010', '21 f�vrier   2010', 'b');
# $calendrier->set_zone ('20 f�vrier   2010', ' 7 mars      2010', 'c');
# 
# $calendrier->set_zone ('10 avril     2010', '25 avril     2010', 'a');
# $calendrier->set_zone (' 3 avril     2010', '18 avril     2010', 'b');
# $calendrier->set_zone ('17 avril     2010', ' 2 mai       2010', 'c');
# 
# $calendrier->set_zone (' 2 juillet   2010', ' 1 septembre 2010', 'a', 'b', 'c');
# 
# $calendrier->set_zone ('23 octobre   2010', ' 3 novembre  2010', 'a', 'b', 'c');

# $calendrier->set_zone ('18 d�cembre  2010', ' 2 janvier   2011', 'a', 'b', 'c');

#
# 2011
#

# $calendrier->set_zone ('26 f�vrier   2011', '13 mars      2011', 'a');
# $calendrier->set_zone ('19 f�vrier   2011', ' 6 mars      2011', 'b');
# $calendrier->set_zone ('12 f�vrier   2011', '27 f�vrier   2011', 'c');
# 
# $calendrier->set_zone ('23 avril     2011', ' 8 mai       2011', 'a');
# $calendrier->set_zone ('16 avril     2011', ' 1 mai       2011', 'b');
# $calendrier->set_zone (' 9 avril     2011', '25 avril     2011', 'c');
# 
# $calendrier->set_zone (' 2 juillet   2011', ' 4 septembre 2011', 'a', 'b', 'c');

$calendrier->set_zone ('17 d�cembre 2011', '2 janvier 2012', 'a', 'b', 'c');

#
# 2012
#

# $calendrier->set_zone ('11 f�vrier   2012', '26 f�vrier   2012', 'a');
# $calendrier->set_zone ('25 f�vrier   2012', '11 mars      2012', 'b');
# $calendrier->set_zone ('18 f�vrier   2012', ' 4 mars      2012', 'c');
# 
# $calendrier->set_zone (' 7 avril     2012', '22 avril     2012', 'a');
# $calendrier->set_zone ('21 avril     2012', ' 6 mai       2012', 'b');
# $calendrier->set_zone ('14 avril     2012', '29 avril     2012', 'c');
# 
# $calendrier->set_zone (' 5 juillet   2012', ' 3 septembre 2012', 'a', 'b', 'c');
# 
# $calendrier->set_zone ('27 octobre 2012', '7 novembre 2012', 'a', 'b', 'c');
 
$calendrier->set_zone ('22 d�cembre 2012', '6 janvier 2013', 'a', 'b', 'c');

#
# 2013
#

$calendrier->set_zone ('23 f�vrier 2013', '10 mars 2013', 'a');
$calendrier->set_zone ('16 f�vrier 2013', '3  mars 2013', 'b');
$calendrier->set_zone ('2  mars    2013', '17 mars 2013', 'c');

$calendrier->set_zone ('20 avril 2013', '5  mai 2013', 'a');
$calendrier->set_zone ('13 avril 2013', '28 avril 2013', 'b');
$calendrier->set_zone ('27 avril 2013', '12 mai   2013', 'c');

$calendrier->set_zone ('6 juillet 2013', ' 2 septembre 2013', 'a', 'b', 'c');

$calendrier->set_zone ('19 octobre 2013', '3 novembre 2013', 'a', 'b', 'c');

$calendrier->set_zone ('21 d�cembre 2013', '5 janvier 2014', 'a', 'b', 'c');

####################################################################################################

1;

####################################################################################################
#
# End
#
####################################################################################################
