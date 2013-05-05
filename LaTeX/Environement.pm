####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

####################################################################################################

package LaTeX::Environement;

####################################################################################################

use warnings;
use strict;

use English;

use Params::Validate qw (:all);
Params::Validate::validation_options( allow_extra => 1 );

use FileHandle;

use LaTeX::Buffer;

use vars qw (@ISA);

@ISA = qw (LaTeX::Buffer);

####################################################################################################

sub new
{
  my $invocant = shift;
  my $class = ref ($invocant) || $invocant;

  my %p = validate ( @_,
		     {
		       name => { type => SCALAR },
 		     });

  my $obj = bless ({}, $class);

  my ($name) = map { $obj->{$_} = $p{$_} } qw (name);

  $obj->flush ();

  $obj->begin ();
  $obj->end ();

  return $obj;
}

sub begin
{
  my $obj = shift;

  my ($name) = map { $obj->{$_} } qw (name);

  $obj->push_begin ("\\begin{$name}\n");
}

sub end
{
  my $obj = shift;

  my ($name) = map { $obj->{$_} } qw (name);

  $obj->push_end ("\\end{$name}\n");
}

####################################################################################################

1;

####################################################################################################
#
# End
#
####################################################################################################
