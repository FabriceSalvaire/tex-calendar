####################################################################################################
#
# tex-calendar - A Perl script to generate a (French) calendar and an agenda using pdflatex.
# Copyright (C) 2008 Salvaire Fabrice
#
####################################################################################################

####################################################################################################

package LaTeX::DocumentLabel;

####################################################################################################

use warnings;
use strict;

use English;

use Params::Validate qw (:all);
Params::Validate::validation_options( allow_extra => 1 );

use LaTeX::Document;

use vars qw (@ISA);

@ISA = qw (LaTeX::Document);

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
                       # unit is mm

		       # fix to paper format
		       paper_width  => { type => SCALAR },
		       paper_height => { type => SCALAR },

                       # number of labels on the paper sheet
		       number_of_columns => { type => SCALAR },
		       number_of_rows    => { type => SCALAR },

                       # top and left margin at the top left corner
		       hoffset => { type => SCALAR },
		       voffset => { type => SCALAR },
		       # correction to them
		       hoffset_correction => { type => SCALAR, default => 0 },
		       voffset_correction => { type => SCALAR, default => 0 },
		       
		       # label size
		       label_width   => { type => SCALAR },
		       label_height  => { type => SCALAR },

		       # label offset
		       label_hoffset => { type => SCALAR },
		       label_voffset => { type => SCALAR },

		       # inner margin in the label : used it to prevent printer jitter, and to center the content
		       label_margin  => { type => SCALAR, default => 0 },

		       macro => { type => SCALAR, default => 'labelTextBox'},
		     });
  
  my $obj = bless ({}, $class);

  my %args = @_;
  
  $obj->SUPER::base_init ( %args, style => 'article', style_options => '10pt' );

  map { $obj->{$_} = $p{$_} } qw (number_of_columns number_of_rows
				  paper_width paper_height
				  hoffset voffset
				  hoffset_correction voffset_correction
				  label_width label_height
				  label_hoffset label_voffset
				  label_margin
				  macro);

  map { $obj->{$_} += $obj->{"${_}_correction"} } qw (hoffset voffset);


  ($obj->{label_text_width}, $obj->{label_text_height}) =
    map { $obj->{$_} - 2*$obj->{label_margin} } qw (label_width label_height);

  my $preambule_buffer = $obj->preambule ();
  my $document_buffer  = $obj->document  ();

  my $preambule = << 'END';

%**** Page settings *********************

\usepackage[%
paper=a4paper,%
%includeheadfoot,%
margin=0cm,%
headsep=0cm, footskip=0cm,%
dvips,%
]{geometry}

\pagestyle{empty}

%****************************************

END

  my ($paper_width, $paper_height, $label_width, $label_height, $label_text_width, $label_text_height) =
  map { $obj->{$_} }
  qw (paper_width paper_height label_width label_height label_text_width label_text_height);

  $preambule .= << "END";
\\newcommand{\\labelBox}[1]{\\makebox($label_width,$label_height){#1}}
\\newcommand{\\labelFrameBox}[1]{\\framebox($label_width,$label_height){#1}}

\\newcommand{\\labelTextBox}[1]{\\makebox($label_text_width,$label_text_height){%
  \\begin{minipage}{${label_text_width}mm}#1\\end{minipage}}}
\\newcommand{\\labelTextFrameBox}[1]{\\framebox($label_text_width,$label_text_height){%
  \\begin{minipage}{${label_text_width}mm}#1\\end{minipage}}}

END

  $preambule_buffer->push (\$preambule);

  my $document .= << "END";
\\setlength{\\unitlength}{1mm}%
\\noindent\\begin{picture}($paper_width,$paper_height)%
END

  $document_buffer->push (\$document);

  $document_buffer->push_end ("\\end{picture}\n");

  $obj->{page_counter}  = 0;
  $obj->{label_counter} = 0;

  return $obj;
}

###################################################

# compute the (i,j) position
sub compute_i_j
{
  my ($obj, $n) = @_; # from 0

  my ($number_of_rows, $number_of_columns) = map { $obj->{$_} } qw (number_of_rows number_of_columns);

  my $i = int ($n/$number_of_columns); # from 0

  my $newpage = ($i+1 > $number_of_rows) ? 1 : 0;

  my $j; # from 0

  if ($newpage)
  {
    ($i, $j) = (0, 0);
  }
  else
  {
    $j = $n - $number_of_columns*$i; 
  }

  return ($i, $j, $newpage);
}

sub push
{
  my ($obj, $content) = @_;

  my ($paper_width, $paper_height,
      $hoffset, $voffset,
      $label_hoffset, $label_voffset,
      $label_margin,
      $page_counter, $label_counter,
      $document,
      $macro)
    = map { $obj->{$_} }
  qw (paper_width paper_height hoffset voffset
      label_hoffset label_voffset label_margin
      page_counter label_counter document macro);

  my ($i, $j, $newpage) = $obj->compute_i_j ($label_counter);

  if ($newpage)
  {
    $label_counter = 0;
    
    $page_counter++;
 
      $document->push ("\\end{picture}\n\\newpage\\noindent\\begin{picture}($paper_width,$paper_height)%\n");
  }

  my ($x, $y) = ($hoffset+$j*$label_hoffset, $paper_height-($voffset+($i+1)*$label_voffset));

  my ($xm, $ym) = map { $_ + $label_margin } ($x, $y);

  #$document->push ("% p$page_counter l$label_counter i$i j$j np$newpage $x $y\n");
  #$document->push ("\\put($x, $y){+}\n");
  #$document->push ("\\put($x, $y){\\labelFrameBox{}}\n");
  $document->push ("\\put($xm, $ym){\\" . $macro . "{$content}}\n");
  
  $label_counter++;

  # save class variable
  $obj->{label_counter} = $label_counter;
  $obj->{page_counter}  = $page_counter;
}

####################################################################################################

1;

####################################################################################################
#
# End
#
####################################################################################################
