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
Consider the variety of purposes that a superscript is used for.
Most commonly, one writes $x^2$ or $x^n$ for powers;
mathematically, the power operation with 2 arguments.
But superscripts are also used for indexing, such as with tensors or matrices $\Phi^i$;
mathematically the same 2 arguments, but applying a different operation.

Then there are cases where the superscript itself indicates which operator is used:
$z^*$, $A^T$, $A^\dagger$.  Here the operators are conjugate, transpose and adjoint,
respectively; in each case, the base is the single argument.
Of course, sometimes these operations are written in functional notation,
$\mathrm{conj}(z)$, $\mathrm{trans}(A)$, $\mathrm{adj}(A)$,
so we ought not conflate the meaning "transpose of A"
with the specific superscript notation that was used.

But sometimes a cigar is just a cigar. While in some contexts, $x'$ might represent
the derivative of $x$, in other contexts the $x'$ as a whole simply represents "a different x",
or perhaps "the frobulator".

Another notational pattern is seen in the somewhat messy markup
commonly used for a binomial coefficient $\binom{n}{m}$,
having $n$ and $m$ stacked and wrapped in parentheses.
The fact that an almost identical markup, possibly with different fences,
is also used for Eulerian numbers, Legendre and Jacobi symbols, 
and conversely, that other notations, such as $C^n_m$, are used for binomial coefficients,
again suggests a benefit to decoupling the notation and meaning of the expression.

## Proposal
We'll use the term *notation*, or notational category, to refer to
a presentation markup pattern which defines its visual layout
along with a notion of how the pieces of that pattern correspond
to a content oriented representation.
The notation is distinct from the meaning. Indeed, as we have seen,
the same notational pattern can be used to layout expressions with
several distinct meanings, while expressions with the same meaning
can be displayed in several different ways.
Thus, we expect the *meaning* to be encoded separately.

We propose two new attributes (*names subject to change*)
on Presentation MathML elements as follows.
* **notation** a keyword indicating the notational category or markup pattern.
  The notation serves as an index into a dictionary of notations with entries specifying
  where in the subtree (eg. XPath) the meaning (or operator) is to be found,
  along with the arguments,
  effectively defining a mapping to Content MathML (depeding on the precision of the meaning).
* **meaning** indicates the mathematical concept or operation involved.
  This should be either a known keyword or a natural language name for the concept (see below).

The notation dictionary may also be indexed by indicators of context, language, user profile.
It may also provide a default *rendering* (by which we refer
not only to the visual rendering,
but more generally the conversion of Presentation MathML into
text, vocalized text, braille or whatever form desired).
The exact form and location of the rendering information is subject to debate.
Additionally, it may be advantageous to re-index on the meaning, once found,
for more precise rendering.

  
On the one hand, given the range of mathematical concepts,
it is desirable to keep the set of meanings open-ended.
Thus the meaning should be natural language name of the concept so that it
can be rendered as is.  On the other hand, given the need for specialized 
translations, a prescribed set of meaning keywords may be desirable.
Probably the best solution is to recommend a moderate set of common meaning
keywords, but allow any text.


With this model, the two ```msup``` examples, power $x^n$ and transpose $A^T%,
would be distinguished as
```
<msup notation="power">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
~~(which, by default, could render as "x to the power of n")~~
versus
```
<msup notation="sup-operator">
  <mi>A</mi>
  <mi meaning="transpose">T</mi>
</msup>
```
~~(which could render as "transpose of A").~~
The latter is easily extended to cover conjugate and adjoint,
or even the "Tralfamadorian inverse",
without needing any additional dictionary entries.
In contrast,
```
<msup meaning="frobulator">
  <mi>x</mi>
  <mo>'</mo>
</msup>
```
would be used for a composite symbol $x'$ which stands for the frobulator;
in this case, neither "x" nor "'" have any particular significance alone.

A binomial would be marked up as:
```
<mrow notation="stacked-fenced" meaning="binomial">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi>n</mi>
    <mi>m</mi>    
  </mfrac>
</mrow>
```
~~which could be read as "binomial of n and m", but an implementation might
have an entry stacked-fenced+binomial to render as "n choose m".~~
This pattern covers Eulerian numbers, Jacobi and Legendre symbols.
Conversely, it  still allows alternate notations for binomials while keeping the same
semantics, since we can write:
```
<msubsup notation="base-operation">
  <mi meaning="binomial">C</mi>
  <mi>n</mi>
  <mi>m</mi>
</msubsup>
```
with (presumably) exactly the same rendering as above.

This approach can avoid having to pattern match on the MathML source
and make assumptions about the delimiters and punctuation used
(which can vary between communities).

The set of notation keywords indexes into a dictionary whose entries indicate:
* **arguments** which children (if any) play the role of arguments;
* **template** a rendering template;
* (possibly) where the "meaning" attribute would reside.

In its simplest form, an element with a notation keyword would be rendered by:
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

## Notation Catalog
The following table is intended to be illustrative.
*The names of these keywords are subject to change; the set is far from complete,
and not all have been completely thought out.*

Notation | Pattern (informative) | Sample Template
----------- | ------- | ---------
infix | ```<mrow notation="infix">...</mrow>``` | see below
prefix | ```<mrow notation="infix">#1#2</mrow>``` | "#2 of #1"
postfix | ```<mrow notation="infix">#1#2</mrow>``` | "#1 of #2"
power | ```<msup notation="power">#1#2</msup>``` | "ord(#2) power of #1"
indexed | ```<msup notation="indexed">#1#2</msup>``` | "ord(#2) of #1"
base-operator | ```<msup notation="base-operator">#1#2</msup>``` | "#1 of #2"
sup-operator | ```<msup notation="sup-operator">#1#2</msup>``` | "#2 of #1"
fenced | ```<mrow><?/>#1 [<?/> #i]* <?/></mrow>``` | #0 of #1,...
fenced-indexed | ```<msub><mrow><?/>#2 [<?/> #i]* <?/></mrow>#1</msub>``` | ord(#1) #0 of #2,...
stacked-fenced | ```<mrow><?/><mfrac>#1#2</mfrac><?/></mrow>``` | #0 of #1 and #2
table-fenced (?) | ```<mrow><?/><mtable>[<mtr>[<a/>*]</mtr>]*<?/></mrow>``` | ?

In the above:
```<?/>``` refers to an arbitrary subtree, typically open or close fencing or punctuation;
 ```#0``` refers to the meaning attribute of the container element itself;
 ```ord(#1)``` should generate an ordinal form for argument 1.
For brevity, the patterns above should be taken as implicitly defining
the locations (eg. XPath) of the arguments within the expression
(no pattern matching by the user agent should be necessary).

## Examples

### infix
TBD

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
* the set (or mini-language) for notation templates;
* the set of MathML container elements which give rise to such constructs
  and need corresponding notation keywords;
* defaults
* pattern precedence (eg. when sub-expressions may need to be verbally parenthesized).
