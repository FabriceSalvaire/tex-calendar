####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

####################################################################################################

package LaTeX::Tabular;

####################################################################################################

use warnings;
use strict;

use English;

use Params::Validate qw (:all);
Params::Validate::validation_options( allow_extra => 1 );

use FileHandle;

use LaTeX::Environement;

use vars qw (@ISA);

@ISA = qw (LaTeX::Environement);

####################################################################################################

sub new
{
  my $invocant = shift;
  my $class = ref ($invocant) || $invocant;

  my %p = validate ( @_,
		     {
		       name     => { type => SCALAR },
		       position => { type => SCALAR, default => '' },
		       format   => { type => SCALAR },
		     });

  my $obj = bless ({}, $class);

  my ($name, $position, $format) = map { $obj->{$_} = $p{$_} } qw (name position format);

  $obj->flush ();

  $obj->push_begin ("\\begin{$name}[$position]{$format}\n");
  $obj->end ();

  return $obj;
}

sub push_with_line_vspace_internal
{
  my $obj = shift;
  my $line_vspace = shift;

  $obj->LaTeX::Buffer::push (join (' & ', @_) . " \\\\${line_vspace}\n");
}

sub push_with_line_vspace
{
  my $obj = shift;
  my $line_vspace = shift;

  $obj->push_with_line_vspace_internal ("[$line_vspace]", @_);
}

sub push
{
  my $obj = shift;

  $obj->push_with_line_vspace_internal ('', @_);
}

sub hline
{
  my $obj = shift;

  $obj->SUPER::push ("\\hline\n");
}

####################################################################################################

1;

####################################################################################################
#
# End
#
####################################################################################################
