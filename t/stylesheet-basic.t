use v6;
use Test;
use CSS::Stylesheet;
plan 5;

my $css = q:to<END>;
 @charset "utf-8";
 
 html, body {
   margin: 0px;
   padding: 0px;
   border: 0px;
   color: #000;
   background: #fff;
   }
 html, body, p, th, td, li, dd, dt {
   font: 1em Arial, Helvetica, sans-serif;
 }
 h1, h2, h3, h4, h5, h6 {
   font-family: Arial, Helvetica, sans-serif;
 }
 h1 { font-size: 2em; }
 h2 { font-size: 1.5em; }
 h3 { font-size: 1.2em ; }
 h4 { font-size: 1.0em; }
 h5 { font-size: 0.9em; }
 h6 { font-size: 0.8em; }
 a:link { color: #00f; }
 a:visited { color: #009; }
 a:hover { color: #06f; }
 a:active { color: #0cf; }
END

my CSS::Stylesheet $stylesheet .= new.parse($css);
is $stylesheet.rules[0].xpath, '//html | //body';
is $stylesheet.rules[0].media, 'all';
is $stylesheet.rules[1].properties, "font-family:Arial, Helvetica, sans-serif; font-size:em;"; 
is $stylesheet.rules.[3].xpath, '//h1';
is $stylesheet.rules.tail.xpath, "//a[css-pseudo('active')]";
done-testing();