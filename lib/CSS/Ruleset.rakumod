unit class CSS::Ruleset;

use CSS::Properties;
use CSS::Selectors;
use CSS::Module::CSS3;

has CSS::Selectors $.selectors handles<xpath specificity>;
has CSS::Properties $.properties;

submethod TWEAK(:%ast! is copy) {
    $!properties .= new: :ast(%ast<declarations>:delete);    
    $!selectors .= new: :%ast;
}

method parse(Str :$css!) {
    my $p := CSS::Module::CSS3.module.parse($css, :rule<ruleset>);
    my $ast = $p.ast;
    self.new: :$ast;
}

=begin pod

=head1 NAME

## CSS::Ruleset - contains a single CSS rule-set (a selector and properties)

=head1 SYNOPSIS

    use CSS::Ruleset;
    my CSS::Ruleset $rules .= parse('h1 { font-size: 2em; margin: 3px; }');
    say $css.properties; # font-size: 2em; margin: 3px;
    say $css.selectors.xpath;       # '//h1'
    say $css.selectors.specificity; #

=head1 DESCRIPTION

This is a container class for a CSS ruleset; a single set of CSS selectors and
declarations (or properties)/

=head1 METHODS

=begin item
parse

parse a single rule-set; creates a rule-set object.
=end item

=begin item
selectors

returns the selectors (type CSS::Selectors)
=end item

=begin item
properties

returns the properties (type CSS::Properties)
=end item

=end pod