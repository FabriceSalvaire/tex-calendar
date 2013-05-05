####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

####################################################################################################

package LaTeX::Base;

# move to LaTeX::File ?

####################################################################################################

use warnings;
use strict;

use English;

use Params::Validate qw (:all);
Params::Validate::validation_options( allow_extra => 1 );

use FileHandle;

use LaTeX::Buffer;
use LaTeX::Environement;

use Exporter;

our @EXPORT_OK =
  (
   'escape',
   );

use vars qw (@ISA);

@ISA = qw (Exporter);

####################################################################################################

#
# Sub: end line
#
# single quote string '...'  ' -> \' \ -> \\
# double              "..."  \... 
#
sub end_line
{
  ${$_[0]} =~ s|\\el|\\\\|g;
}

#
# Sub: Escape for LaTeX
#
sub escape
{
  my ($ref_string) = @_;

  $$ref_string =~ s|_|\\_|g;
}

####################################################################################################

#
# Abstract Constructor:
#
sub new
{
  my $invocant = shift;
  my $class = ref ($invocant) || $invocant;

  die "The new method must be overridden in the $class subclass";
}

#
# Method: Init a LaTeX file 
#
sub base_init
{
  my $obj = shift;

  my %p = validate ( @_,
		     {
		       path      => { type => SCALAR, default => './' },
		       file_name => { type => SCALAR },
		     });

  map { $obj->{$_} = $p{$_} } qw (path file_name);

  # section
  $obj->{document} = new LaTeX::Environement ( name => 'document' ); # good name ?
}

#
# Method: retun the absolut file name
#
sub absolut_file_name
{
  my $obj = shift;

  return $obj->{path} . $obj->{file_name};
}

#
# Accessor:
#
sub document
{
  my $obj = shift;

  return $obj->{document};
}

#
# Method: Create and open a LaTeX file 
#
sub open
{
  my $obj = shift;

  my $tex_file = $obj->absolut_file_name (). '.tex';

  my $handle = $obj->{handle} = new FileHandle;

  $handle->open ("> $tex_file")
    || die "Can't create $tex_file:\n$ERRNO\n";

  return $handle;
}

#
# Method: Close the LaTeX file 
#
sub close
{
  my $obj = shift;

  $obj->{handle}->close ();
}

#
# Method: Write a section
#
sub write_section
{
  my ($obj, $section) = @_;

  my $handle = $obj->{handle};

  # print $handle "%dump $section\n";

  $obj->{$section}->write ($handle);

  # print $handle "%end $section\n";
}

#
# Method: insert newpage
#
sub newpage
{
  my $obj = shift;

  $obj->document ()->push ('\newpage' . "\n");
}

####################################################################################################

1;

####################################################################################################
#
# End
#
####################################################################################################
