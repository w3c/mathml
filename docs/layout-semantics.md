---
title: "Layout Patterns for Semantic Annotation"
layout: cgreport
---

*Authors*: Bruce Miller

## Abstract
[MathML 3](https://www.w3.org/TR/MathML3/) is a W3C recommendation for representing
mathematical expressions. It defines two forms:
Presentation MathML describes how the math looks and is the most commonly used;
Content MathML aims to completely describe the math's meaning,
and is consequently difficult to produce.
The purpose of this note is to develop a means of adding
at least minimal semantic information to Presentation MathML to support accessibility.

<nav id="toc" markdown="1">

# Table of Contents
{:.no_toc}

* toc
{:toc}

</nav>

## Motivation
Presentation MathML, of course, specifies the visual rendering of mathematical expressions.
We'll use the term "rendering", here, in a generic sense to indicate the
conversion of Presentation MathML to text, vocalized text, braille or whatever
form is appropriate to the context.  To carry out that conversion, some additional semantic
information is necessary beyond that which Presentation MathML supplies.

To add semantic information to Presentation MathML,
an obvious first step might be to add an annotation encoding the "meaning" of each symbol,
for example as an attribute on its token. That covers a lot of cases in a natural way,
but begins to fail when we encounter the various purposes of sub/superscripts
(eg. powers $x^2$, operator application like $A^T$, indexing,
or even composite symbols like $x^*$) or constructs
representing special notations such as binomial coefficients.
In these cases there may be no (or many) tokens which deserve this meaning attribute,
and it fails to capture the fact that the entire construct (eg. msup, mrow),
albeit with embedded "arguments", is relevant.

It is tempting in such cases to assign the meaning at a higher level
(Say put "transpose" on the msup instead of the T, or "binomial" on the mrow),
but then we must conceive a large dictionary of meanings
(eg. transpose, conjugate, adjoint, ...; binomial, legendre-symbol,...)
along with their corresponding markup patterns.
Each such markup pattern must encode which of the node descendants will also need to be translated.
Moreover, we would have to distinguish different possible markup patterns
associated with the same meaning (eg. transpose as superscript, transpose as function,...;
different notations for binomial coefficients).  


## Proposal
Lets explore the feasibility of abstracting a (hopefully) small set of markup patterns,
disentangling them from the meanings, for distinguishing these cases;
The presentation markup would thus be annotated with 2 attributes,
which (for purposes of discussion) I'll call "meaning" and "composition".
* **meaning** indicates the natural language name of the mathematical object
   on which it resides; the set of meanings is intended to be open-ended;
* **composition** a keyword indicating the markup pattern.

*The names of these attributes are subject to change.*

With this model, the two ```msup``` examples, power and transpose, would be distinguished as
```
<msup composition="power">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
(which, by default, could render as "x to the power of n") versus
```
<msup composition="sup-operator">
  <mi>A</mi>
  <mi meaning="transpose">T</mi>
</msup>
```
(which could render as "transpose of A").
The latter is easily extended to cover conjugate and adjoint,
or even the "Tralfamadorian inverse",
without needing any additional dictionary entries.
In contrast,
```
<msup meaning="frobulator">
  <mi>x</mi>
  <mo>*</mo>
</msup>
```
would be used for a composite symbol $x^*$ which stands for the frobulator;
in this case, neither "x" nor "*" have any particular significance alone.

A binomial would be marked up as:
```
<mrow composition="stacked-fenced" meaning="binomial">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi>n</mi>
    <mi>m</mi>    
  </mfrac>
</mrow>
```
which could be read as "binomial of n and m", but an implementation might
have an entry stacked-fenced+binomial to render as "n choose m".
This pattern covers Eulerian numbers, Jacobi and Legendre symbols.
Conversely, it  still allows alternate notations for binomials while keeping the same
semantics, since we can write:
```
<msubsup composition="base-operation">
  <mi meaning="binomial">C</mi>
  <mi>n</mi>
  <mi>m</mi>
</msubsup>
```
with (presumably) exactly the same rendering as above.

This approach can avoid having to pattern match on the MathML source
and make assumptions about the delimiters and punctuation used
(which can vary between communities).

The set of composition keywords indexes into a dictionary whose entries indicate:
* **arguments** which children (if any) play the role of arguments;
* **template** a rendering template;
* (possibly) where the "meaning" attribute would reside.

In its simplest form, an element with a composition keyword would be rendered by:
looking up the keyword in a dictionary to find an entry; locate the arguments within the element;
and fill in the template with the renderings of the arguments.
For most purposes, the set of possible meanings could be open-ended and the meaning
attribute could simply be read out (or translated) as the rendering.
That doesn't preclude recommending a standard set for common cases,
nor does it preclude an implementation including a meaning dictionary to improve translations.

For broader use, the dictionary could have multiple indexes (or several dictionaries) to
support different languages, braille, context, user profiles and so on.
An implementation may wish to subindex on the meanings, once found in the markup,
Moreover, the template need not be restricted to literal patterns, but may indicate code;
for example to determine whether a given power should be read as "squared" or "cubed".

## Composition Catalog
*The names of these keywords are subject to change; the set is far from complete,
and not all have been completely thought out.*

Composition | pattern | template
----------- | ------- | ---------
power | ```<msup composition="power">#1#2</msup>``` | "ord(#2) power of #1"
indexed | ```<msup composition="indexed">#1#2</msup>``` | "ord(#2) of #1"
base-operator | ```<msup composition="base-operator">#1#2</msup>``` | "#1 of #2"
sup-operator | ```<msup composition="sup-operator">#1#2</msup>``` | "#2 of #1"
fenced | ```<mrow><open/>#1 [<punct/> #i]* <close/></mrow>``` | #0 of #1,...
fenced-indexed | ```<msub><mrow><open/>#2 [<punct/> #i]* <close/></mrow>#1</msub>``` | ord(#1) #0 of #2,...
stacked-fenced | ```<mrow><open/><mfrac>#1#2</mfrac><close/></mrow>``` | #0 of #1 and #2
table-fenced (?) | ```<mrow><open/><mtable>[<mtr>[<a/>*]</mtr>]*<close/></mrow>``` | ?

In the above:
 ```#0``` refers to the meaning attribute of the container element itself;
 ```ord(#1)``` should generate an ordinal form for argument 1.
For brevity, the patterns above should be taken as implicitly defining
the locations (eg. XPath) of the arguments within the expression
(no pattern matching by the user agent should be necessary).

## Examples

### superscripts
see above

### subscripts

### fenced
It may be necessary to distinguish the number of elements within the fence
and the presence, or lack, of punctuation
* **1** norms, determinants
* **2** intervals, inner-products, distributions, row-vectors

Sets, conditional sets?

### stacked-fenced
binomial, Jacobi and Legendre symbols, Eulerian numbers

### fenced-indexed
Pochhammer symbols

### table-fenced
matrices, Clebsch-Gordon coefficients, 3j, 6j, etc symbols,

## Summary
This idea has a lot of detail to be worked out, including at least
* naming conventions;
* the set (or mini-language) for composition templates;
* the set of MathML container elements which give rise to such constructs
  and need corresponding composition keywords;
* defaults
* pattern precedence (eg. when sub-expressions may need to be verbally parenthesized).
