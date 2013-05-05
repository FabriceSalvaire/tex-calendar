===================
tex-calendar V0.1.0
===================

A Perl script to generate a (French) calendar and an agenda using pdflatex. 

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

Special (French) hollydays are set in the file ``steering.pl``. 

To get the command help do::

  ./calendrier --help

To generate a 2013 calendar do in a terminal::

  ./calendrier --steering=steering.pl --year=2013 --calendar
  pdflatex calendar.tex

To Go Further
-------------

:Warning: The development of tex-calendar is on standby since several years now.

I plan a day to reimplement it in Python,

.. End
