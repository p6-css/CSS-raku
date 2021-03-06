[![Build Status](https://travis-ci.org/css-raku/CSS-raku.svg?branch=master)](https://travis-ci.org/css-raku/CSS-raku)

[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS]](https://css-raku.github.io/CSS-raku)

class CSS
---------

CSS Stylesheet processing

Synopsis
--------

    use CSS;
    use CSS::Properties;
    use CSS::Units :px; # define 'px' postfix operator
    use CSS::TagSet::XHTML;
    use LibXML::Document;

    my $string = q:to<\_(ツ)_/>;
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            @page :first { margin:4pt; }
            body {background-color: powderblue; font-size: 12pt}
            @media screen { h1:first-child {color: blue !important;} }
            @media print { h2 {color: green;} }
            p    {color: red;}
            div {font-size: 10pt }
          </style>
        </head>
        <body>
          <h1>This is a heading</h1>
          <h2>This is a sub-heading</h2>
          <h1>This is another heading</h1>
          <p>This is a paragraph.</p>
          <div style="color:green">This is a div</div>
        </body>
      </html>
    \_(ツ)_/

    my LibXML::Document $doc .= parse: :$string, :html;

    # define a selection media
    my CSS::Media $media .= new: :type<screen>, :width(480px), :height(640px), :color;

    # Create a tag-set for XHTML specific loading of style-sheets and styling
    my CSS::TagSet::XHTML $tag-set .= new();

    my CSS $css .= new: :$doc, :$tag-set, :$media, :inherit;

    # -- show some computed styles, based on CSS Selectors, media, inline styles and xhtml tags
    my CSS::Properties $body-props = $css.style('/html/body');
    say $body-props.font-size; # 12pt
    say $body-props;           # background-color:powderblue; display:block; font-size:12pt; margin:8px; unicode-bidi:embed;
    say $css.style('/html/body/h1[1]');
    # color:blue; display:block; font-size:12pt; font-weight:bolder; margin-bottom:0.67em; margin-top:0.67em; unicode-bidi:embed;
    say $css.style('/html/body/div');

    # color:green; display:block; font-size:10pt; unicode-bidi:embed;
    say $css.style($doc.first('/html/body/div'));
    # color:green; display:block; font-size:10pt; unicode-bidi:embed;

    # -- query first page properties (from @page rules)
    say $css.page(:first);     # margin:4pt;

Description
-----------

[CSS](https://css-raku.github.io/CSS-raku) is a module for parsing style-sheets and applying them to HTML or XML documents.

This module aims to be W3C compliant and complete, including: style-sheets, media specific and inline styling and the application of HTML specific styling (based on tags and attributes).

Methods
-------

### method new

```raku
method new(
    LibXML::Document :$doc!,       # document to be styled.
    CSS::Stylesheet :$stylesheet!, # stylesheet to apply
    CSS::TagSet :$tag-set,         # tag-specific styling
    CSS::Media :$media,            # target media
    Bool :$inherit = True,         # perform property inheritance
) returns CSS;
```

In particular, the `CSS::TagSet :$tag-set` options specifies a tag-specific styler; For example CSS::TagSet::XHTML. 

### method style

```raku
multi method style(LibXML::Element:D $elem) returns CSS::Properties;
multi method style(Str:D $xpath) returns CSS::Properties;
```

Computes a style for an individual element, or XPath to an element.

### method page

```raku
method page(Bool :$first, Bool :$right, Bool :$left,
            Str :$margin-box --> CSS::Properties)
```

Query and extract `@page` at rules.

The `:first`, `:right` and `:left` flags can be used to select rules applicable to a given logical page.

In addition, the `:margin-box` can be used to select a specific [Page Margin Box](https://www.w3.org/TR/css-page-3/#margin-boxes). For example given the at-rule `@page { margin:2cm; size:a4; @top-center { content: 'Page ' counter(page); } }`, the top-center page box properties can be selected with `$stylesheet.page(:margin-box<top-center>)`.

### method prune

```raku
method prune(LibXML::Element $node? --> LibXML::Element)
```

Removes all XML nodes with CSS property `display:none;`, giving an approximate representation of a CSS rendering tree.

For example, if an HTML document with an XHTML tag-set is pruned the `head` element will be removed because it has the property `display:none;`. Any other elements that have had `display:none;' applied to them via the tag-set, inline CSS, or CSS Selectors are also removed.

By default, this method acts on the root element of the associated $.doc XML document.

Utility Scripts
---------------

  * `css-tidy.raku [--/optimize] [--/terse] [--/warn] [--lax] [--color=names|values|masks] <file> [<output>]`

Rebuild a CSS Style-sheet with various checks and optimizations.

  * `css-inliner.raku input.xml [output.xml] --style=file.css --prune --tags --type=html|pango|pdf --inherit`

Apply internal or external style-sheets to per-element 'style' attributes

See Also
--------

  * [CSS::Stylesheet](https://css-raku.github.io/CSS-Stylesheet-raku/CSS/Stylesheet) - CSS Stylesheet representations

  * [CSS::Module](https://css-raku.github.io/CSS-Module-raku) - CSS Module module

  * [CSS::Properties](https://css-raku.github.io/CSS-Properties-raku/CSS/Properties) - CSS Properties module

  * [CSS::TagSet](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet) - CSS tag-sets (XHTML, Pango, Tagged PDF)

  * [LibXML](https://css-raku.github.io/https://libxml-raku.github.io/LibXML-raku/) - LibXML Raku module

  * [DOM::Tiny](https://github.com/zostay/raku-DOM-Tiny) - A lightweight, self-contained DOM parser/manipulator

Todo
----

- HTML linked style-sheets, e.g. `<LINK REL=StyleSheet HREF="style.css" TYPE="text/css" MEDIA=screen>`

- CSS imported style-sheets, e.g. `@import url("navigation.css")`

- Other At-Rule variants (in addition to `@media` and `@import`) `@document`, `@page`, `@font-face`

