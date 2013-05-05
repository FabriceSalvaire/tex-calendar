===================
tex-calendar V0.1.0
===================

A Perl script to generate a (French) custom calendar and an agenda using pdflatex. 

Un Perl script pour générer via pdflatex un calendrier et un agenda personnalisable avec les
vacances scolaires Française (zone A, B et C).

:Info: The home page of tex-calendar is located at http://fabricesalvaire.github.com/tex-calendar

Source Repository
-----------------

The tex-calendar project is hosted at github
http://github.com/FabriceSalvaire/tex-calendar

Requirements
------------

* Perl

 * Getopt::Long
 * DateTime::Format::Strptime
 * Params::Validate
 * Astro::Sunrise

* `gcal <http://www.gnu.org/software/gcal>`_

Building & Installing
---------------------

* Install ``cgal`` and use ``cpan`` to install missing Perl modules.
* Download the source using git.

Running
-------

Special (French) holidays are set in the file ``steering.pl``. 

To generate a 2013 calendar do in a terminal::

  ./calendrier --steering=steering.pl --year=2013 --calendar
  pdflatex calendar.tex

To get the command help use::

  ./calendrier --help

To Go Further
-------------

:Warning: The development of tex-calendar is on standby since several years now.

I plan a day to reimplement it in Python. My idea is to remove the need of ``gcal`` and to have a
nicer code. Python raw string are much better than Perl for TeX.  There is two obstacles to do this:
Actually Python library doesn't have a calendar tool equivalent to ``gcal``. Also I have to get a
sunset-sunrise Python implementation. The directory ``doc`` contains some stuffs about this.

.. End
