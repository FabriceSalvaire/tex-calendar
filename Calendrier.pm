####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

####################################################################################################

package Calendrier;

####################################################################################################
#
# Notes
#

# localisation Fr
# check and clean the code

####################################################################################################

use warnings;
#use strict;

####################################################################################################

use English;

use Params::Validate qw (:all);
Params::Validate::validation_options( allow_extra => 1 );

# use Carp;

use DateTime::Format::Strptime;

use Astro::Sunrise;

####################################################################################################

use vars qw [ $VERSION ]; $VERSION = '0.01';

####################################################################################################
#
# Time conversion Fr
#

our $strptime = new DateTime::Format::Strptime (
						pattern     => '%d %b %Y',
						locale      => 'fr_FR',
#					        time_zone   => 'France/Paris',
						);

####################################################################################################
#
# Sub
#

sub debug
{
  print 'DEBUG #', join (', ', @_), "\n";
}

sub error
{
  my ($message) = @_;

  print STDERR $message, "\n";
}

#
# Sub : sting date -> (day, month, year)
#
sub decode_date
{
  my ($date) = @_;

  $date =~ s/ +/ /g;
  $date =~ s/^ //g;

  if (my $dt = $strptime->parse_datetime ($date)) # $date must be encoded in latin 1 !
  {
    return ($dt->day, $dt->month, $dt->year);
  }
  else
  {
    print "bad date : [$date]\n";
  }
}

####################################################################################################
#
# int <=> month Fr
#

our %month_to_int =
  (
   'janvier'   =>  1,
   'février'   =>  2,
   'mars'      =>  3,
   'avril'     =>  4,
   'mai'       =>  5,
   'juin'      =>  6,
   'juillet'   =>  7,
   'août'      =>  8,
   'septembre' =>  9,
   'octobre'   => 10,
   'novembre'  => 11,
   'décembre'  => 12,
   );

sub month_to_int
{
  return $month_to_int{$_[0]};
}

our @int_to_month = sort { month_to_int ($a) <=> month_to_int ($b) } keys %month_to_int;

sub int_to_month
{
  return $int_to_month[$_[0] - 1];
}

####################################################################################################
#
# Localisation Fr
#

our %month_to_french =
  (
   'january'   => 'janvier',
   'february'  => 'février',
   'march'     => 'mars',
   'april'     => 'avril',
   'may'       => 'mai',
   'june'      => 'juin',
   'july'      => 'juillet',
   'august'    => 'août',
   'september' => 'septembre',
   'october'   => 'octobre',
   'november'  => 'novembre',
   'december'  => 'décembre',

   'jan' => 'janvier',
   'feb' => 'février',
   'mar' => 'mars',
   'apr' => 'avril',
   'may' => 'mai',
   'jun' => 'juin',
   'jul' => 'juillet',
   'aug' => 'août',
   'sep' => 'septembre',
   'oct' => 'octobre',
   'nov' => 'novembre',
   'dec' => 'décembre',
   );

our %day_to_french =
  (
   'sun' => 'di',
   'mon' => 'lu',
   'tue' => 'ma',
   'wed' => 'me',
   'thu' => 'je',
   'fri' => 've',
   'sat' => 'sa',
   );

our %short_to_long_day =
  (
   'di' => 'dimanche',
   'lu' => 'lundi',
   'ma' => 'mardi',
   'me' => 'mercredi',
   'je' => 'jeudi',
   've' => 'vendredi',
   'sa' => 'samedi',
   );

sub short_to_long_day
{
  return $short_to_long_day{$_[0]};
}

our %fixed_date;
$fixed_date{'1 mai'}       = { key => 'holiday', value => 'Fête du travail'};
$fixed_date{'1 janvier'}   = { key => 'holiday', value => 'Jour de l\'an'};
$fixed_date{'8 mai'}       = { key => 'holiday', value => 'Jour de la Victoire'};
$fixed_date{'14 juillet'}  = { key => 'holiday', value => 'Fête national'};
$fixed_date{'15 août'}     = { key => 'holiday', value => 'Ascension de la Vierge'};
$fixed_date{'11 novembre'} = { key => 'holiday', value => 'Jour de l\'Armistice'};
$fixed_date{'25 décembre'} = { key => 'holiday', value => 'Noël'};

our %motif_holiday;
$motif_holiday{'Easter Monday'}           = { key => 'holiday', value => 'Pâques' }; # le lundi de Pâques
$motif_holiday{'Christ\'s Ascension Day'} = { key => 'holiday', value => 'Ascension'}; # l'Ascension
$motif_holiday{'Whit Monday'}             = { key => 'holiday', value => 'Pentecôte'}; # le lundi de Pentecôte
$motif_holiday{'All Saints\' Day'}        = { key => 'holiday', value => 'Toussaint'}; # la Toussaint

#New Moon 02:48 (Ast)                     - Thu, Oct  14th 2004
#Waxing Half Moon 21:59 (Ast)             - Wed, Oct  20th 2004
#Full Moon 03:07 (Ast)                    - Thu, Oct  28th 2004
#Waning Half Moon 05:53 (Ast)             - Fri, Nov   5th 2004 

$motif_holiday{'New Moon'}         = { key => 'moon', value => 'new moon'};
$motif_holiday{'Waxing Half Moon'} = { key => 'moon', value => 'waxing half moon'};
$motif_holiday{'Full Moon'}        = { key => 'moon', value => 'full moon'};
$motif_holiday{'Waning Half Moon'} = { key => 'moon', value => 'waning half moon'};

#Equinox Day 06:49 (Ast)                  - Sat, Mar  20th 2004 Vernal equinox
#Solstice Day 00:57 (Ast)                 - Mon, Jun  21st 2004 Summer soltice
#Equinox Day 16:30 (Ast)                  - Wed, Sep  22nd 2004 Autumnal equinox
#Solstice Day 12:41 (Ast)                 - Tue, Dec  21st 2004 Winter solstice

$motif_holiday{'Equinox'}  = { key => 'season', value => 'equinox'};
$motif_holiday{'Solstice'} = { key => 'season', value => 'solstice'};

#Solar Eclipse/Partial 13:35 (Ast)        - Mon, Apr  19th 2004
#Lunar Eclipse/Total 20:31 (Ast)          - Tue, May   4th 2004
#Solar Eclipse/Partial 03:00 (Ast)        - Thu, Oct  14th 2004
#Lunar Eclipse/Total 03:04 (Ast)          - Thu, Oct  28th 2004

# Eternal holiday list:                      The year 2003 is NO leap year
# 
# New Year's Day (FR)                      + Wed, Jan   1st 2003 = -342 days 1er janvier
# Quinquagesima Sunday (FR)                - Sun, Mar   2nd 2003 = -282 days
## Equinox Day 01:00 (Ast)                  - Fri, Mar  21st 2003 = -263 days
# Good Friday (FR)                         * Fri, Apr  18th 2003 = -235 days
# Easter Sunday (FR)                       + Sun, Apr  20th 2003 = -233 days
# Easter Monday (FR)                       + Mon, Apr  21st 2003 = -232 days lundi de Pâques
# Labour Day (FR)                          + Thu, May   1st 2003 = -222 days 1er mai
# Victory Day (FR)                         + Thu, May   8th 2003 = -215 days 8 mai
# Christ's Ascension Day (FR)              + Thu, May  29th 2003 = -194 days l'Ascension
# Whitsunday/Pentecost (FR)                + Sun, Jun   8th 2003 = -184 days 
# Whit Monday (FR)                         + Mon, Jun   9th 2003 = -183 days lundi Pentecôte
## Solstice Day 19:11 (Ast)                 - Sat, Jun  21st 2003 = -171 days
# National Holiday (FR)                    + Mon, Jul  14th 2003 = -148 days 14 juillet
# Mary's Ascension Day (FR)                + Fri, Aug  15th 2003 = -116 days 15 août
## Equinox Day 10:47 (Ast)                  - Tue, Sep  23rd 2003 =  -77 days
# All Saints' Day (FR)                     + Sat, Nov   1st 2003 =  -38 days la Toussaint
# Armistice Day (FR)                       + Tue, Nov  11th 2003 =  -28 days 11 novembre
## Solstice Day 07:04 (Ast)                 - Mon, Dec  22nd 2003 =  +13 days 
# Christmas Eve (FR)                       - Wed, Dec  24th 2003 =  +15 days #
# Christmas Day (FR)                       + Thu, Dec  25th 2003 =  +16 days Noël
# Boxing Day (FR)                          * Fri, Dec  26th 2003 =  +17 days #
# Sylvester/New Year's Eve (FR)            - Wed, Dec  31st 2003 =  +22 days #

####################################################################################################
#
# Définition des trois zones de vacances pour la France
#

our %zone =
  (
   'a' =>
   [
    'Caen',
    'Clermont-Ferrand',
    'Grenoble',
    'Lyon',
    'Montpellier',
    'Nancy-Metz',
    'Nantes',
    'Rennes',
    'Toulouse',
    ],

   'b' =>
   [
    'Aix-Marseille',
    'Amiens',
    'Besançon',
    'Dijon',
    'Lille',
    'Limoges',
    'Nice',
    'Orléans-Tours',
    'Poitiers',
    'Reims',
    'Rouen',
    'Strasbourg',
    ],

   'c' =>
   [
    'Bordeaux',
    'Créteil',
    'Paris',
    'Versailles',
    ],
   );

####################################################################################################
#
# TeX
#

our %moon_symbole =
  (
   'new moon'         => '\\newmoon',
   'waxing half moon' => '\\rightmoon',
   'full moon'        => '\\fullmoon',
   'waning half moon' => '\\leftmoon',
   );

####################################################################################################
#
# Data structures
#

#
# $obj->{dates}[$i] = $date_obj;
# 
# $obj->{month}{$month}[$date] = $date_obj;
# 
# $obj->{weeks}[$i] = $date_obj;
#
# date object keys :
#  
#  date        => int
#  day         => ''
#  day_counter => int
#  dst         => +/-1
#  holiday     => ''
#  month       => ''
#  moon        => ''
#  season      => ''
#  week        => int
#  year        => int
#  zone        => ['a', 'b', 'c']
#

####################################################################################################


#
# Constructor:
#
sub new
{
  my $invocant = shift;
  my $class = ref ($invocant) || $invocant;

  my %p = validate ( @_,
		     {
		       'year' => { type => SCALAR },
		     });

  my $obj = bless ({}, $class);

  map { $obj->{$_} = $p{$_} } qw (year);

  my ($year) = map { $obj->{$_} } qw (year);;

  #
  # Parse gcal output
  #
  
  my $command = "LC_ALL=C gcal -b 12 -i -H no $year";

  print "run '$command'\n";

  open (GCAL, "$command |");

#
#         2004
#
#
#      January
#
#Sun       4 11 18 25
#Mon       5 12 19 26
#Tue       6 13 20 27
#Wed       7 14 21 28
#Thu    1  8 15 22 29
#Fri    2  9 16 23 30
#Sat    3 10 17 24 31
#
#
#      February
# ...
#

  my $month_name = '';

  while (<GCAL>)
  {
    #if (/^\s+([[:alpha:]]+)/)
    if (/^\s\s\s\s+([[:alpha:]].+)/)
    {
      $month_name = $month_to_french{lc $1};

      # print "New month : $month_name $year\n";
    }
    elsif (/^(\w\w\w)\s+([ \d]+)/)
    {
      my $day   = $day_to_french{lc $1};
      my @dates = split (/\s+/, $2);
      
      foreach my $date (@dates)
      {
	$obj->{month}{$month_name}[$date] =
	{
	  day   => $day,
	  date  => $date,
	  month => $month_name,
	  year  => $year,
	};

	# print "  $day $date $month_name $year\n";
      }
    }
  }
  
  close (GCAL);

  my $day_counter  = 0;
  my $first_day = 1;
  my $week_counter = 0;

  #
  # Year loop
  #

  #
  # Month loop
  #

  foreach my $month_name (@int_to_month)
  {
    print "\n", ucfirst $month_name, " $year \n";

    my $month = $obj->get_month ($month_name);

    #
    # Date loop
    #

    foreach my $date (1 .. $#$month)
    {
      my $date_obj = $month->[$date];

      my ($day) = map { $date_obj->{$_} || '' } qw (day);

      $day_counter++;
      $date_obj->{day_counter} = $day_counter;

      $obj->{dates}[$day_counter] = $date_obj;

      my $new_week = 0;

      if ($first_day)
      {
	print "first day\n";
	$new_week = 1;
	$first_day = 0;
	$week_counter = ($day eq 'lu') ? 0 : -1;
      }
      else
      {
	$new_week = 1 if ($day eq 'lu');
      }

      if ($new_week)
      {
	$week_counter++;

	$obj->{weeks}[$week_counter] = $date_obj;

	print '-' x 10, " week #$week_counter \n";
      }

      $date_obj->{week} = $week_counter;

      print " $date $day, day #$day_counter\n";
    }
  }

  $obj->{number_of_days}  = $day_counter;
  $obj->{number_of_weeks} = $week_counter;

  # print "\n";
  # print "number of weeks : $week_counter\n";
  # print "number of days  : $day_counter\n";

  return $obj;
}

####################################################################################################
#
# Accessor:
#

sub year
{
  my $obj = shift;

  return $obj->{year};
}

sub number_of_days
{
  my $obj = shift;

  return $obj->{number_of_days};
}

sub number_of_weeks
{
  my $obj = shift;

  return $obj->{number_of_weeks};
}

sub get_month
{
  my ($obj, $month) = @_;

  return $obj->{month}{$month} or undef;
}

sub month_date_range
{
  my ($month_obj) = @_;

  return (1 .. $#$month_obj); 
}

sub get_month_date
{
  my ($obj, $month, $date) = @_;

  return ($date <= $obj->last_date_of_the_month ($month)) ? $obj->get_month ($month)->[$date] : undef;
}

sub get_week_date_range
{
  my ($obj, $week_i) = @_;

  my $first_date_i = $obj->{weeks}[$week_i]{day_counter};
  
  my $last_date_i = ($week_i < $obj->number_of_weeks) ? $obj->{weeks}[$week_i+1]{day_counter} -1 : $obj->number_of_days;
  
  return ($first_date_i, $last_date_i);
}

sub get_week_from_to
{
  my ($obj, $week_i) = @_;

  if ($week_i <= $obj->number_of_weeks)
  {
    return map { $obj->get_date ($_) } $obj->get_week_date_range ($week_i);
  }
  else
  {
    return undef;
  }
}

sub get_date
{
  my ($obj, $date_i) = @_;

  return ($date_i <= $obj->number_of_days) ? $obj->{dates}[$date_i] : undef;
}

#
# Method: return the last date of the month
#
sub last_date_of_the_month
{
  my ($obj, $month) = @_;

  return $#{$obj->get_month ($month)};
}

sub date_minus
{
  my ($obj, $date_i) = @_;

  return $obj->number_of_days - $date_i;
}

sub get_date_keys
{
  my $date = shift;

  return map { $date->{$_} || '' } @_;
}

####################################################################################################
#
# Formater
#

sub format_date
{
  my ($date_obj) = @_;

  my ($date, $month, $year) = map { $date_obj->{$_} || '' } qw (date month year);

  return "$date $month $year";
}

####################################################################################################
#
# Holidays
#

sub set_holidays
{
  my ($obj) = @_;

  my $year = $obj->year;

  my $command = "LC_ALL=C gcal --holiday-list -q FR --astronomical-holidays -H no -u $year";

  open (GCAL, "$command |");

  while (<GCAL>)
  {
    # New Moon 11:37 (Ast)                     - Tue, Jan   8th 2008 = -155 days
    # New Moon 11:37 (Ast)                     - Ma,   8 Jan 2008 = -155 jours

    # my $line = $_;

    foreach my $motif (keys %motif_holiday)
    {
      if (/^$motif[^,]+,\s+(\w+)\s+(\d+)/)
      {
	my ($date, $month) = ($2, $month_to_french{lc $1});

#     if (/^$motif[^,]+,\s+(\d+)\s+(\w+)/)
#     {
#       my ($date, $month) = ($1, $month_to_french{lc $2});

	my $motif_holiday = $motif_holiday{$motif};

	# print "$line $month $date $motif_holiday->{value}\n";

	$obj->get_month_date ($month, $date)->{$motif_holiday->{key}} = $motif_holiday->{value};
      }
    }
  }

  close (GCAL);

  #
  # Fixed days
  #

  foreach my $date_month (keys %fixed_date)
  {
    my ($date, $month) =  split (/ /, $date_month);

    my $fixed_date = $fixed_date{$date_month};

    # print "$month $date $fixed_date->{key} $fixed_date->{value}\n";

    $obj->get_month_date ($month, $date)->{$fixed_date->{key}} = $fixed_date->{value};
  }
}

####################################################################################################
#
# Zones de vacances pour la France
#

#
# Method: Définit les vacances par zones
#
sub set_zone
{
  my ($obj, $start_date, $end_date, @zone) = @_;

  my $year = $obj->year;

  my ($date_d, $month_d, $year_d) = decode_date ($start_date);
  my ($date_f, $month_f, $year_f) = decode_date ($end_date);

  unless ($year_d <= $year_f)
  {
    error ("set_zone: [$year_d] > [$year_f]");
    
    return ;
  }
  
  if ($year_d == $year_f)
  {
    # dans la même année
    
    unless ($month_d <= $month_f)
    {
      error ("set_zone: dans la même année [$month_d] > [month_f]");
      
      return ;
    }
  }
  else
  {
    # sur deux ans
    
    unless ($month_d >= $month_f)
    {
      error ("set_zone: sur deux ans [$month_d] < [month_f]");
      
      return ;
    }
    
    if ($year_d < $year)
    {
      $date_d  = 1;
      $month_d = 1;
      $year_d  = $year;
    }
    elsif ($year < $year_f)
    {
      $date_f  = 31;
      $month_f = 12;
      $year_f  = $year;
    }
  }

  #print "($date_d, $month_d, $year_d)-($date_f, $month_f, $year_f)\n";

  foreach my $month ($month_d .. $month_f)
  {
    my $month_name = int_to_month ($month);

    my $d = ($month == $month_d) ? $date_d : 1;
    my $f = ($month == $month_f) ? $date_f : $obj->last_date_of_the_month ($month_name);;

    foreach my $date ($d .. $f)
    {
      push (@{$obj->get_month_date ($month_name, $date)->{zone}}, @zone);
    }
  }
}

####################################################################################################
#
# DST
#

#
# Method: Recherche la date du changement d'horaire
#
sub find_dst
{
  my ($obj, $month, $dst) = @_;

  my $date = $obj->last_date_of_the_month ($month);

  # last sunday of the month
  while ($obj->get_month_date ($month, $date)->{day} ne 'di')
  {
    $date--;
  }

  $obj->get_month_date ($month, $date)->{dst} = $dst;
}

#
# Method: Définit les dates de changement d'horaire
#
sub set_dst
{
  my ($obj) = @_;

  $obj->find_dst ('mars',    '+1');
  $obj->find_dst ('octobre', '-1');
}

sub is_dst
{
  my ($month) = @_;

  return (($month > month_to_int ('mars')) && ($month <= month_to_int ('octobre'))) ? 1 : 0;
}

####################################################################################################
#
# Ephemeris
#

sub set_ephemeris
{
  my $obj = shift;

  my %p = validate ( @_,
		     {
		       'place'     => { type => SCALAR },
		       'longitude' => { type => SCALAR },
		       'latitude'  => { type => SCALAR },
		     });

  my ($place, $longitude, $latitude) = map { $p{$_} } qw (place longitude latitude);

  my $year = $obj->year;

  foreach my $month (1 .. 12)
  {
    my $dst = is_dst ($month);
    
    my ($sun_rise, $sun_set) = sunrise ($year, $month, 1,
					$longitude, $latitude,
					1, $dst,
					-0.833, 5);
    
    #print STDERR "$month $sun_rise $sun_set $dst\n";
    
    $obj->get_month_date (int_to_month ($month), 1)->{sun}{$place} = { rise => $sun_rise, set => $sun_set };
  }
}

####################################################################################################

sub week_loop
{
  my $obj = shift;

  my %p = validate ( @_,
		     {
		       'hook_week' => { type => CODEREF },
		     });

  my ($hook_week) = map { $p{$_} } qw (hook_week);

  #
  # Week loop
  #
  
  foreach my $week_i (1 .. $obj->number_of_weeks)
  {
    &$hook_week ($obj, $week_i);
  }
}

sub date_loop
{
  my $obj = shift;

  my %p = validate ( @_,
		     {
		       'hook_date' => { type => CODEREF },
		     });

  my ($hook_date) = map { $p{$_} } qw (hook_date);

  #
  # Date loop
  #
  
  foreach my $date_i (1 .. $obj->number_of_days)
  {
    &$hook_date ($obj, $date_i);
  }
}

# Agenda :
#
# hook agenda begin 
# week loop
#   hook week begin
#   days of the week loop
#     hook day
#   make a month tabular for the month of the week
#   hook week end
# hook agenda end 
#

sub agenda
{
  my $obj = shift;

  my %p = validate ( @_,
		     {
		       'hook_agenda_begin' => { type => CODEREF },
		       'hook_agenda_end'   => { type => CODEREF },
		       'hook_week_begin'   => { type => CODEREF },
		       'hook_week_end'     => { type => CODEREF },
		       'hook_day'          => { type => CODEREF },
		     });

  my ($hook_agenda_begin, $hook_agenda_end, $hook_week_begin, $hook_week_end, $hook_day) =
    map { $p{$_} } qw (hook_agenda_begin hook_agenda_end hook_week_begin hook_week_end hook_day);

  #
  # Year loop
  #

  my ($year, $number_of_weeks, $number_of_days) =
    map { $obj->{$_} } qw (year number_of_weeks number_of_days);

  &$hook_agenda_begin ($obj);

  #
  # Week loop
  #
  
  foreach my $week_i (1 .. $number_of_weeks)
  {
    &$hook_week_begin ($obj, $week_i);

    my ($d, $f) = $obj->get_week_date_range ($week_i);

    map { &$hook_day ($obj, $_) } ($d .. $f);

    &$hook_week_end ($obj, $week_i);
  }
  
  &$hook_agenda_end ($obj);
}

# Calendar :
#
# hook calendar begin 
# month loop
#   hook month begin
#   days of the week loop
#     hook day
#   hook month end
# hook calendar end 
#

sub calendar
{
  my $obj = shift;

  my %p = validate ( @_,
		     {
		       'hook_calendar_begin' => { type => CODEREF },
		       'hook_calendar_end'   => { type => CODEREF },
		       'hook_month_begin'    => { type => CODEREF },
		       'hook_month_end'      => { type => CODEREF },
		       'hook_day'            => { type => CODEREF },
		     });

  my ($hook_calendar_begin, $hook_calendar_end, $hook_month_begin, $hook_month_end, $hook_day) =
    map { $p{$_} } qw (hook_calendar_begin hook_calendar_end hook_month_begin hook_month_end hook_day);

  #
  # Year loop
  #

  my ($year, $number_of_weeks, $number_of_days) =
    map { $obj->{$_} } qw (year number_of_weeks number_of_days);

  &$hook_calendar_begin ($obj);

  #
  # Month loop
  #

  foreach my $month (@int_to_month)
  {
    &$hook_month_begin ($obj, $month);

    my $month_obj = $obj->get_month ($month);

    map { &$hook_day ($obj, $month, $_) } month_date_range ($month_obj);

    &$hook_month_end ($obj, $month);
  }

  &$hook_calendar_end ($obj);
}

# Month tabular :
#
# hook month begin
# week loop
#  hook week begin
#  days of the week loop
#    hook day
#  hook week end
# hook month end
#

sub month_tabular
{
  my $obj = shift;

  my %p = validate ( @_,
		     {
		       'hook_month_begin' => { type => CODEREF },
		       'hook_month_end'   => { type => CODEREF },
		       'hook_week'        => { type => CODEREF },
		       'month'            => { type => SCALAR },
		       'week'             => { type => SCALAR, optional => 1 },
		     });

  my ($hook_month_begin, $hook_month_end, $hook_week, $month) =
    map { $p{$_} } qw (hook_month_begin hook_month_end hook_week month);

  #
  # Year loop
  #

  my ($year, $number_of_weeks, $number_of_days) =
    map { $obj->{$_} } qw (year number_of_weeks number_of_days);

   #
  # Month loop
  #

  &$hook_month_begin ($obj, $month);

  my $month_obj = $obj->get_month ($month);
  
  my @month_date_range = month_date_range ($month_obj);

  my $mf = $month_date_range[-1];

  my ($wd, $wf) = (1, undef);

  my $week_counter = 1;

  foreach my $date_i (@month_date_range)
  {
    if ($date_i == $mf or $month_obj->[$date_i]{day} eq 'di')
    {
      $wf = $date_i;

      my $padding = 7 - ($wf - $wd +1);

      my @week_padding = map { 0 } (1 .. $padding);

      my @week = ($wd .. $wf);

      unless ($month_obj->[$wd]{day} eq 'lu')
      {
	@week = (@week_padding, @week);
      }

      unless ($month_obj->[$wf]{day} eq 'di')
      {
	@week = (@week, @week_padding);
      }

      my $week_i = $month_obj->[$wd]{week};
 
      my $this_week = (exists $p{week} && $p{week} == $week_i) ? 1 : 0;

      &$hook_week ($obj, $month, $week_i, $this_week, @week);

      $wd = $wf + 1;

      $week_counter++;
    }
  }

  &$hook_month_end ($obj, $month, $week_counter);
}

####################################################################################################
#
# Dump the data structure
#

sub dump
{
  my ($obj) = @_;

  #
  # Year loop
  #

  my ($year, $number_of_weeks, $number_of_days) =
    map { $obj->{$_} } qw (year number_of_weeks number_of_days);

  #
  # Week loop
  #
  
  print "Weeks :\n";

  $obj->week_loop ( hook_week => sub
		    {
		      my ($obj, $week_i) = @_;

		      my ($first_date_i, $last_date_i) = $obj->get_week_date_range ($week_i);

		      my $first_date = $obj->get_date ($first_date_i);
		      
		      my ($day, $date, $month) = get_date_keys ($first_date, qw (day date month));

		      print " \#$week_i $first_date_i-$last_date_i $day $date $month\n";
		    } );
  
  #
  # Date loop
  #

  print "\nDates :\n";

  $obj->date_loop ( hook_date => sub
		    {
		      my ($obj, $date_i) = @_;
		      
		      my $date_obj = $obj->get_date ($date_i);
		      
		      my ($day, $date, $month) = get_date_keys ($date_obj, qw (day date month));
		      
		      my $date_minus = $obj->date_minus ($date_i);
		      
		      print " \#$date-$date_minus $day $date $month\n";
		    } );

  $obj->calendar
    ( 'hook_calendar_begin'  => sub {},
      'hook_calendar_end'    => sub {},
      'hook_month_end'       => sub {},
      
      'hook_month_begin' => sub
      {
	my ($obj, $month) = @_;

	my $month_obj = $obj->get_month ($month);
	
	print "\n", ucfirst $month, " $year \n";
	
	my $first_of_the_month = $month_obj->[1];
	
	if (exists $first_of_the_month->{sun})
	{
	  my $sun = $first_of_the_month->{sun};
	  
	  foreach my $place (keys %$sun)
	  {
	    my ($sun_rise, $sun_set) = map { $sun->{$place}{$_} } qw (rise set);
	    
	    print " \@$place sunrise $sun_rise sunset $sun_set\n";
	  }
	}
      },
      
      'hook_day' => sub
      {
	my ($obj, $month, $date_i) = @_;
	
	my $date_obj = $obj->get_month_date ($month, $date_i);
	
	my ($day, $holiday, $dst, $moon, $season) = get_date_keys ($date_obj, qw (day holiday dst moon season));
	
	my $zone = (exists $date_obj->{zone}) ? "@{$date_obj->{zone}}" : '';
	
	my $new_week = ($date_obj->{day} eq 'lu') ? $date_obj->{week} : 0;
	
	if ($new_week)
	{
	  print '-' x 10, " week #$new_week \n";
        }
	
	print " $date_i $day, holiday : '$holiday', zone : '$zone', dst : '$dst', moon : '$moon', season : '$season'\n";
      },
      );
}

####################################################################################################

1;

####################################################################################################
#
# End
#
####################################################################################################
