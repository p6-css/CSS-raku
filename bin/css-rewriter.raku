=begin pod

=head1 NAME

css-inliner.raku - tidy/optimise and rewrite CSS stylesheets

=head1 SYNOPSIS

 css-writer.raku infile.css [outfile.css] 

 Options:
    --/optimize       # disable optimizations
    --/terse          # enable multiline property lists
    --/warn           # disable warnings
    --color=names     # write color names (if possible)
    --color=values    # write color values
    --lax             # allow any functions and units

=head1 DESCRIPTION

This script rewrites CSS stylesheets after 

This script was written to help with visual verification of the Raku CSS
module. The output XHTML should be visually identical to the input.

=end pod

use CSS::Stylesheet;
subset ColorOptNames of Str where 'names'|'name'|'n';
subset ColorOptValues of Str where 'values'|'value'|'v';
subset ColorOpt of Str where ColorOptNames|ColorOptValues|Any:U;

sub MAIN($file = '-',            #= Input CSS Stylesheet path ('-' for stdin)
         $output?,               #= Processed stylesheet path (stdout)
         Bool :$optimize=True,   #= Optimize CSS properties
         Bool :$terse=True,      #= Single line property output
         Bool :$warn = True,     #= Output warnings
         Bool :$lax,             #= Allow any functions and units
         ColorOpt :$color,       #= Color output mode; 'names', or 'values'
        ) {

    my Bool $color-names  = True if $color ~~ ColorOptNames;
    my Bool $color-values = True if $color ~~ ColorOptValues;

    given ($file eq '-' ?? $*IN !! $file.IO).slurp {
        my CSS::Stylesheet $style .= new.parse: $_, :$lax, :$warn;
        my $out = $style.Str: :$optimize, :$terse, :$color-names, :$color-values; 

        with $output {
            .IO.spurt: $out
        }
        else {
            say $out;
        }
        note 'done';
    }
}
