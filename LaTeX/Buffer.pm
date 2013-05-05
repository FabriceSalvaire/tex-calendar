####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

####################################################################################################

package LaTeX::Buffer;

####################################################################################################

use warnings;
use strict;

use English;

use Params::Validate qw (:all);
Params::Validate::validation_options( allow_extra => 1 );

use FileHandle;

####################################################################################################

sub new
{
  my $invocant = shift;
  my $class = ref ($invocant) || $invocant;

  my %p = validate ( @_,
		     {
		       begin => { type => ARRAYREF, default => [] },
		       end   => { type => ARRAYREF, default => [] },
		     });

  my $obj = bless ({}, $class);

  map { $obj->{$_} = $p{$_} } qw (begin end);

  $obj->flush ();

  $obj->{buffer} = [];

  return $obj;
}

sub push_internal
{
  my ($obj, $buffer_name, $contents) = @_;

  my $class = ref ($obj);
  my $type  = ref ($contents);
  
  # print "LaTeX::Buffer::push class is $class, content is $type\n";

  # push a reference on the contents

  my $buffer = $obj->{$buffer_name};

  if (($type eq 'SCALAR') || UNIVERSAL::isa ($contents, 'LaTeX::Buffer'))
  {
    push (@$buffer, $contents);
  }
  elsif ($type eq '') 
  {
    push (@$buffer, \$contents);
  }
}

sub push
{
  my ($obj, @contents) = @_;

  foreach my $content (@contents)
  {
    my $type = ref ($content);

    if ($type eq 'ARRAY')
    {
      # print "LaTeX::Buffer::push content is an array\n";

      map { $obj->push_internal ('buffer', $_) } @$content;
    }
    else
    {
      $obj->push_internal ('buffer', $content);
    }
  }
}

sub push_begin
{
  my $obj = shift;
  
  $obj->push_internal ('begin', @_);
}

sub push_end
{
  my $obj = shift;
  
  $obj->push_internal ('end', @_);
}

sub write
{
  my ($obj, $handle) = @_;

  my $class = ref ($obj);
  # print "-> write $class\n";

  foreach my $contents (@{$obj->{begin}}, @{$obj->{buffer}}, reverse @{$obj->{end}})
  {
    my $type = ref ($contents);

    # print "LaTeX::Buffer::write content is $type\n";

    if ($type eq 'SCALAR')
    {
      print $handle "% LaTeX::Buffer::write contents was unitialised\n" unless ($$contents);

      print $handle $$contents;
    }
    elsif (UNIVERSAL::isa ($contents, 'LaTeX::Buffer'))
    {
      $contents->write ($handle);
    }
    else
    {
      die "Bad type [$type] in LaTeX::Buffer: [$contents]\n";
    }
  }
}

sub flush
{
  my $obj = shift;

  $obj->{begin}  = [];
  $obj->{buffer} = [];
  $obj->{end}    = [];
}

####################################################################################################

1;

####################################################################################################
#
# End
#
####################################################################################################
