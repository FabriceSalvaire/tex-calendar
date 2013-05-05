Design
======

Data Structure:
---------------

* year
 * is leap year
 * number of days

* month
 * relative year
 * name using localisation
 * number within year
 * number of days

* week
 * number within year

* day
 * relative month and week
 * weed day, name using localisation
 * number within month
 * number within year
 * events

Recommandations de l'Organisation Internationale de Standardisation:
Le lundi est considéré comme le premier jour de la semaine.
Les semaines d'une màªme année sont numérotées de 01 à 52 (parfois 53).
La semaine qui porte le numéro 01 est celle qui contient le premier jeudi de janvier.
Il peut exister une semaine n° 53 (années communes finissant un jeudi, bissextiles finissant un jeudi ou un vendredi). 

Date tools
----------

* week day for a particular date (cf. datetime)

Iterators
---------

* month iterator within year
* day iterator within month
* week iterator within year
* day range iterator

Event Registration
------------------

An event is a subclass of Event and can be added to dates.

Painter can be associated to Event.

Template engine
---------------

* iterate over month
* iterate over day
* test if:
 * day is start week
 * day is saturday or sunday
 * day is holyday

Dates
=====

* fixed holydays
* dst day

Catholic Calendar
-----------------

* Easter Monday / lundi de Pâques
easter's sunday +1, cf. computus

* Christ's Ascension Day / Ascension 
10 days before Pentecost

* Whit Monday / lundi de Pentecôte
Le Lundi de Pentecôte a donc lieu cinquante jours (7 semaines + 1 jour) après le dimanche de Pâques

* All Saints' Day / Toussaint
1er nov

Sunset and Sunrise
------------------

Moon Phase
----------

* New Moon
* Waxing Half Moon
* Full Moon
* Waning Half Moon

Season
------

* Equinox
* Solstice

Leap year Algorithm
===================

A leap year has 29 days in februray.

if year modulo 400 is 0 then
   is_leap_year
else if year modulo 100 is 0 then
   not_leap_year
else if year modulo 4 is 0 then
   is_leap_year
else
   not_leap_year

Date of Easter
==============

http://en.wikipedia.org/wiki/Computus

gcal use Knuth algorithm

Oudin's Algorithm: "Étude sur la date de Pâques", published in the "Bulletin astronomique" in 1940

Software
========

http://www.gnu.org/software/gcal/
http://search.cpan.org/~rkhill/Astro-Sunrise-0.91/Sunrise.pm

http://rhodesmill.org/pyephem/
provides rise/set, equinox/solstice computation

http://astrolabe.sourceforge.net/

References
==========

http://fr.wikipedia.org/wiki/Comput
http://www.ortelius.de/kalender/east_en.php

Institut de Mécanique Céleste et de Calcul des Éphémérides
http://www.imcce.fr

Astronomical Algorithms (1998), 2nd ed, ISBN 0-943396-61-1
http://en.wikipedia.org/wiki/Jean_Meeus

http://aa.usno.navy.mil/data/docs/RS_OneYear.php

# End
