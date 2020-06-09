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
Consider the variety of purposes for which a superscript is employed.
Most commonly, one writes $x^2$ or $x^n$ for powers;
abstractly, power is applied to 2 arguments.
But superscripts are also used for indexing, such as with tensors or matrices $\Phi^i$;
abstractly,  a different operation is applied the same 2 arguments.

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

The common theme is that there are a collection of notational structures
that are essential for understanding the meanings of mathematical expressions,
but do not determine it alone.

## Proposal
We'll use the term *notation*, or notational category, to refer to
a presentation markup pattern which defines its visual layout
along with a notion of how the pieces of that pattern correspond
to an operator and arguments to imply a content oriented representation.
The notation is distinct from the meaning. Indeed, as we have seen,
the same notational pattern can be used to layout expressions using
several distinct operators, while expressions with the same meaning
can be displayed in several different ways.
Thus, we expect the *meaning* to be encoded separately.

We propose two new attributes (*names subject to change*)
on Presentation MathML elements as follows.
* **notation** a keyword indicating the notational category or markup pattern.
  The notation serves as an index into a dictionary of notations with entries specifying
  the location in the subtree (eg. XPath) the operator, or its default, as well as the arguments.
* **meaning** indicates the mathematical concept or operation involved.
  This should be either a known keyword or a natural language name for the concept (see below).

The presence of one or both of these attributes on a Presentation MathML node
effectively defines a mapping from that presentation tree
to an equivalent, potentially less ambiguous, content oriented tree
(or even Content MathML, depending on the precision of the meaning).
Given a notation attribute, an operation is either implied by the notation
or the notation indicates the location of an operator node in the subtree;
that operator node's meaning attribute is the operation.
The equivalent content tree is then simply the application
of that operation to the arguments.
When no notation keyword is given on a node, the meaning attribute simply
gives the meaning of the entire node; effectively the equivalent is simply
a content token.

Ultimately, the goal is to *translate* this virtual content tree into
text or speech (in different languages), braille or some other form.
The preferred translation may also depend on context and user profile.
On the one hand, the most natural translation of a given expression
will depend on the operator.  It is thus desirable to have a set of
known meanings with translation rules.
On the other hand, mathematics encompasses an endless set of concepts,
arguing that the set of meanings should be open-ended.
We propose that there should be a small set of recommended meaning keywords
whose translation can be specialized, while allowing any value for the meaning
(an implementation is free to recognize more meaning keywords).
In the case where a meaning is *not* known, support for multiple languages
or user profiles would likely be lost;
the translation of content token should simply be the value of the meaning attribute,
or in general a template like "the [meaning] of [arg1], [arg2] and [argn] ...".

In any case, author supplied annotation of the notations has simplified the task by
isolating the operator and arguments of subexpressions, (mostly?) eliminating
the need to pattern match on the presentation tree.

## Some Examples
With this model, the two ```msup``` examples, power $x^n$ and transpose $A^T$,
would be distinguished as follows:
```
<msup notation="power">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
Here, the meaning defaults to "power". The translation could be of various
forms including "the n-th power of x", or "x squared" for $x^2$.
The transpose example would be marked up as
```
<msup notation="sup-operator">
  <mi>A</mi>
  <mi meaning="transpose">T</mi>
</msup>
```
which is easily extended to cover conjugate and adjoint.
Or even
```
<msup notation="sup-operator">
  <mi>A</mi>
  <mi meaning="Tralfamadorian inverse">T</mi>
</msup>
```
which could be translated as "the Tralfamadorian inverse of A",
without needing any additional dictionary entries.
Likewise,
```
<msup meaning="frobulator">
  <mi>x</mi>
  <mo>'</mo>
</msup>
```
would be used for a composite symbol $x'$ which stands for the frobulator;
the translation would simply be "frobulator".

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
with (presumably) exactly the same translation as above.

Infix may be a bit of a special case, depending on how ```mrow``` is used,
since there may be multiple operators involved.
For example,
```
<mrow notation="infix">
  <mi>a</mi>
  <mo meaning="plus">+</mo>
  <mi>b</mi>
  <mo meaning="minus">-</mo>
  <mi>c</mi>
  <mo meaning="plus">+</mo>
  <mi>d</mi>
</mrow>
```
The translation might be driven more by the notation than the meaning,
such as the concatenation of the translation of the children: "a plus b minus c plus d".
A variety of infix operators ($\times$, $\cdot$, etc) are handled by
adding the appropriate meaning attribute to each.

Prefix and Postfix operators, are simple, provided they are contained
within an ```mrow```:
```
<mrow notation="postfix">
  <mi>n</mi>
  <mo meaning="factorial">!</mo>
</mrow>
```
It is tempting to think of functional notations $f(x)$ or $g(x,y)$ as special
cases of a prefix notation (where we would presumably need to make provision
for marking and ignoring fences and punctuation), or whether these deserve
their own notations (possibly several, in order to cope with said fences and punctuation).

## Notation Catalog
The following table is intended to be illustrative.
*The names of these keywords are subject to change; the set is far from complete,
and not all have been completely thought out.*

Notation | Description
----------- | -------
infix | ```<mrow notation="infix"> #arg [#op #arg]* </mrow>```
 | row of alternating terms and infix operators; the operators would typically have a meaning assigned.
 | Example: arithmetic $a+b-c+d$; cross-product $\mathbf{a} \times \mathbf{b}$; area $n\times m$.
prefix | ```<mrow notation="prefix"> #op #arg </mrow>```
 | operator preceding its argument
 | Example: negative $-a$.
postfix | ```<mrow notation="postfix"> #arg #op </mrow>```
 | operator following its argument
 | Example: factorial $n!$.
power | ```<msup notation="power"> #arg1 #arg2 </msup>```
 | base raised to the power of the superscript
 | Example: $x^n$, $x^2$.
applicative-power | ```<msup notation="applicative-power"> #arg1 #arg2 </msup>```
 | base applied the superscript number of times
 | Example: inverse $\sin^{-1}$.
indexed | ```<msup notation="indexed"> #arg1 #arg2 </msup>```
 | array-like base indexed by the superscript
base-operator | ```<msup notation="base-operator"> #op #arg </msup>```
 | the base is an operator applied to the superscript
sup-operator | ```<msup notation="sup-operator"> #arg #op </msup>```
 | the superscript is an operator applied to the base
 | Example: transpose $A^T$; adjoint $A^\dagger$
fenced | ```<mrow notation="fenced" meaning="#meaning"> #fence #arg [#punct #arg]* #fence </mrow>```
 | a fenced sequence of items with a semantic significance
 | Examples: interval $(a,b$)$.
fenced-indexed | ```<msub><mrow> #fence #arg [#punct #arg]* #fence </mrow> #arg </msub>```
 | like fenced, but also indexed
stacked-fenced | ```<mrow> #fence <mfrac> #1 #2 </mfrac> #fence </mrow>```
 | a fenced fraction (often with linethickness=0) with a semantic significance
 | Examples: binomial $\binom{n}{m}$.
table-fenced (?) | ```<mrow> #fence <mtable> [<mtr> [<mtd> #arg </mtd>]* </mtr>]* </mtable> #fence </mrow>```
 | ?

The patterns are informative, primarily to serve as a shorthand for the
locations of operators (```#op```) and arguments (```#arg```).

Fences and punctuation (```#fence```, ```#punct```) indicate the positions
of fences and punctuation.
### Speculation on ignorable fences, punctuation
Since the notation has been explicitly given by the author,
fences and punctuation are ignorable from the point of view of
determining the operator and arguments. Perhaps they deserve
a special attribution (eg. meaning="ignorable" or notation="ignorable"?).
This would collapse the number of notation keywords, but perhaps at
the cost of increasing the burden of authoring tools, and user agents?

## Table Tests
I'm trying to embed a marked-down block within a table cell.
According to the "spec", this should work, but doesn't in Jekyll

<table>
<tr><td>
<pre>
**not really bold**,

**really bold**.

</pre>
</td></tr>
</table>



This uses a nomarkdown special directive, which does work in Jekyll

{::nomarkdown}
<table>
<tr><td>
<pre>
**not really bold**,
{:/nomarkdown}
**really bold**.
{::nomarkdown}
</pre>
</td></tr>
</table>
{:/nomarkdown}


## Examples of notations

Notation | Description | Code
-------  | ----------- | ----
infix | $a+b-c+d$ | `<mrow notation="infix">`<br>`<mi>a</mi>`<br>`<mo meaning="plus">+</mo>`<br>`<mi>b</mi>`<br>`<mo meaning="minus">-</mo>`<br>`<mi>c</mi>`<br>`<mo meaning="plus">+</mo>`<br>`<mi>d</mi>`<br>`</mrow>`
prefix | $-a$ | `<mrow notation="prefix">`
|~ | `<mo meaning="unary-minus">-</mo>`
|~ | `<mi>a</mi>`
|~ | `</mrow>`

{::nomarkdown}
<table>
<tr><td>
<pre  markdown="1">
**not really bold**,
{:/nomarkdown}

**really bold**.

{::nomarkdown}
</pre>
</td></tr>
</table>
{:/nomarkdown}

{::nomarkdown}
<table>
<thead><tr><th>Notation</th><th>Description</th><th>Code</th></tr></thead><tbody>
<tr><td>postfix</td>
<td>$n!$</td>
<td>
{:/nomarkdown}
```
<mrow notation="postfix">
  <mi>a</mi>
  <mo meaning="factorial">!</mo>
</mrow>
```
{::nomarkdown}
</td>  
</tr>
</tbody>
</table>
{:/nomarkdown}


======================================================================
```
<msup notation="power">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
Here, the meaning defaults to "power". The translation could be of various
forms including "the n-th power of x", or "x squared" for $x^2$.
The transpose example would be marked up as
```
<msup notation="sup-operator">
  <mi>A</mi>
  <mi meaning="transpose">T</mi>
</msup>
```
which is easily extended to cover conjugate and adjoint.
Or even
```
<msup notation="sup-operator">
  <mi>A</mi>
  <mi meaning="Tralfamadorian inverse">T</mi>
</msup>
```
which could be translated as "the Tralfamadorian inverse of A",
without needing any additional dictionary entries.
Likewise,
```
<msup meaning="frobulator">
  <mi>x</mi>
  <mo>'</mo>
</msup>
```
would be used for a composite symbol $x'$ which stands for the frobulator;
the translation would simply be "frobulator".

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
with (presumably) exactly the same translation as above.

Infix may be a bit of a special case, depending on how ```mrow``` is used,
since there may be multiple operators involved.
For example,
======================================================================
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
