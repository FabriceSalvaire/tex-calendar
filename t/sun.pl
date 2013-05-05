####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

# Test de Astro::Sunrise

use Astro::Sunrise;
#use Astro::Sunrise qw(:constants);

#my ($sunrise, $sunset) = sunrise(YYYY,MM,DD,longitude,latitude,Time Zone,DST);
my ($sunrise, $sunset) = sunrise (2003, 10, 1, 10.0, 53.33, 0, 0, -0.833, 5);

print "$sunrise $sunset\n";

####################################################################################################
# 
# End
# 
####################################################################################################
