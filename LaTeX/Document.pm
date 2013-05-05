####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

####################################################################################################

package LaTeX::Document;

# fix: package and doc api

####################################################################################################

use warnings;
use strict;

use English;

use Params::Validate qw (:all);
Params::Validate::validation_options( allow_extra => 1 );

use LaTeX::Base;

use vars qw (@ISA);

@ISA = qw (LaTeX::Base);

####################################################################################################

#
# Constructor:
#
sub new
{
  my $invocant = shift;
  my $class = ref ($invocant) || $invocant;
  
  my $obj = bless ({}, $class);

  my %args = @_;
  
  $obj->base_init ( %args );

  return $obj;
}

sub base_init ()
{
  my $obj = shift;

  my %p = validate ( @_,
		     {
		       style         => { type => SCALAR },
		       style_options => { type => SCALAR, default => '' },
		     });

  my %args = @_;

  $obj->SUPER::base_init ( %args );

  map { $obj->{$_} = $p{$_} } qw (style style_options);

  # section
  $obj->{preambule} = new LaTeX::Buffer ();
}

###################################################

#
# Accessor:
#
sub preambule
{
  my $obj = shift;

  return $obj->{preambule};
}

###################################################

#
# Method: Write the LaTeX file
#
sub write
{
  my $obj = shift;

  my $handle = $obj->open ();

  my ($style, $style_options) = map { $obj->{$_} } qw (style style_options);

  print $handle "\\documentclass[$style_options]{$style}\n";

  $obj->write_section ('preambule');

  $obj->write_section ('document');

  $obj->close ();
}

####################################################################################################

1;

####################################################################################################
#
# End
#
####################################################################################################
