---
title: "Layout Patterns for Semantic Annotation"
layout: cgreport
---

*Authors*: Bruce Miller

## OBSOLETE
This proposal should be considered obsolete;
it has been superceded by [Semantics Mini](semantics-mini).
(although the list of samples that need effective annotation is useful)

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
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

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Motivation
Consider the variety of purposes for which a superscript is employed.
Most commonly, one writes $x^2$ or $x^n$ for powers;
abstractly, power is applied to 2 arguments.
But superscripts are also used for indexing, such as with tensors or matrices $\Phi^i$.
Abstractly,  a different operation is applied the same 2 arguments,
but in neither case is the implied operator obviously associated with either
the base or superscript.

Then there are cases where the superscript itself indicates which operator is used:
$z^*$, $A^T$, $A^\dagger$.  Here the operators are conjugate, transpose and adjoint,
respectively; in each case, the base is the single argument
while the operator is implied by the superscript.
Of course, sometimes these operations are written in functional notation,
$\mathrm{conj}(z)$, $\mathrm{trans}(A)$, $\mathrm{adj}(A)$,
so we ought not conflate the meaning "transpose of A"
with the specific superscript notation that was used.

But sometimes a cigar is just a cigar. While in some contexts, $x'$ might represent
the derivative of $x$, in other contexts the $x'$ as a whole simply represents "a different x",
or perhaps "the frobulator".

Another notational pattern is seen in the somewhat messy markup
commonly used for a binomial coefficient $\binom{n}{m}$,
having the arguments $n$ and $m$ are buried in the markup, stacked and wrapped in parentheses.
The fact that an almost identical markup, possibly with different fences,
is also used for Eulerian numbers, Legendre and Jacobi symbols, 
and conversely, that other notations, such as $C^n_m$, are used for binomial coefficients,
again suggests a benefit to decoupling the notation and meaning of the expression.

The common theme is that there are a collection of notational structures
that are essential for understanding the meanings of mathematical expressions,
but do not determine it alone.

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Proposal
We'll use the term *notation*, or notational category, to refer to
a presentation markup pattern which defines its visual layout
along with a notion of how the pieces of that pattern correspond
to an operator and arguments to imply a content oriented representation.
The notation is distinct from the meaning. Indeed, as we have seen,
the same notational pattern can be used to layout expressions using
several distinct operators, while conversely, expressions with the same meaning
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

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Some Examples
With this model, the two ```msup``` examples, power $x^n$ and transpose $A^T$,
would be distinguished as follows:
```
<msup notation="sup" meaning="power">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
The translation could be of various
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
  <mo>)</mo>
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

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Notation Catalog
The following table is intended to be illustrative.
*The names of these keywords are subject to change; the set is far from complete,
and not all have been completely thought out.*

Notation | Description
----------- | -------
infix | `<mrow notation="infix"> #arg [#op #arg]* </mrow>`
 | row of alternating terms and infix operators; the operators would typically have a meaning assigned.
prefix | `<mrow notation="prefix"> #op #arg </mrow>`
 | operator preceding its argument
postfix | `<mrow notation="postfix"> #arg #op </mrow>`
 | operator following its argument
sup | `<msup notation="sup"> #arg1 #arg2 </msup>`
 | the meaning (defaults to power?) applied to the base and superscript.
sub | `<msup notation="sub"> #arg1 #arg2 </msub>`
 | the meaning applied to the base and subscript.
base-operator | `<msup notation="base-operator"> #op #arg </msup>`
 | the base is an operator applied to the superscript
sup-operator | `<msup notation="sup-operator"> #arg #op </msup>`
 | the superscript is an operator applied to the base
fenced | `<mrow notation="fenced" meaning="#meaning"> #fence #arg [#punct #arg]* #fence </mrow>`
 | a fenced sequence of items with a semantic significance
fenced-sub | `<msub><mrow> #fence #arg [#punct #arg]* #fence </mrow> #arg </msub>`
 | like fenced, but with the subscript being an additional argument
stacked-fenced | `<mrow> #fence <mfrac> #1 #2 </mfrac> #fence </mrow>`
 | a fenced fraction (often with linethickness=0) with a semantic significance
table | `<mtable> [<mtr> [<mtd> #arg </mtd>]* </mtr>]* </mtable>`
 | the table represents some mathematical object; presumably the rows and columns specify the arguments.
table-fenced | `<mrow> #fence <mtable> [<mtr> [<mtd> #arg </mtd>]* </mtr>]* </mtable> #fence </mrow>`
 | like table, but fenced.

The patterns are currently informative, primarily to serve as a shorthand for the
locations of operators (```#op```) (which would normally have a meaning attribute)
and arguments (```#arg```).   These locations will be more precisely defined in
any eventual specification.

Fences and punctuation (```#fence```, ```#punct```) indicate the positions
of fences and punctuation.
### Speculation on ignorable fences, punctuation
Since the notation has been explicitly given by the author,
fences and punctuation are ignorable from the point of view of
determining the operator and arguments. Perhaps they deserve
a special attribution (eg. meaning="ignorable" or notation="ignorable"?).
This would collapse the number of notation keywords, but perhaps at
the cost of increasing the burden of authoring tools, and user agents?

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Examples of notations
Note that often the same meaning will appear within different notations.

<!-- ======================================================================
  Big problems laying out tables. The goal is to embed multi-line quoted code
  within a table cell (ie. must be a parsed block).  I can't achieve this with "pipe" code.
  So I use raw HTML. A blank-line should end raw HTML, but does NOT in Jekyll.
  OTOH, there's a brace-colon-colon directive nomarkdown in kramdown;
  that works in Jekyll (& the github.io site), but not on github's standard .md
  -->

{::nomarkdown}
<table>
<thead><tr><th>Notation</th><th>Description</th><th>Code</th></tr></thead>
<tbody>
<!-- ======================================== -->
<tr><td> infix </td><td> arithmetic<br/> $a+b-c+d$ </td><td>
{:/nomarkdown}
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
{::nomarkdown}
</td></tr>

<tr><td>  </td><td> inner product $\mathbf{a}\cdot\mathbf{b}$ </td><td>
{:/nomarkdown}
```
<mrow notation="infix">
  <mi mathvariant="bold">a</mi>
  <mo meaning="inner-product>&#x22C5;</mo>
  <mi mathvariant="bold">b</mi>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td/><td colspan="2">Easily extended to other operators and meanings: cross-product, "by", etc.</td></tr>
<!-- ======================================== -->
<tr><td> prefix </td><td> negation $-a$ </td><td>
{:/nomarkdown}
```
<mrow notation="prefix">
  <mo meaning="unary-minus">-</mo>
  <mi>a</mi>`
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> Laplacian $\nabla^2 f$ </td><td>
{:/nomarkdown}
```
<mrow notation="prefix">
  <msup meaning="laplacian">
    <mi>&#x2207;</mi>
    <mn>2</mn>
  </msup>
  <mi>f</mi>`
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> postfix </td><td> factorial $n!$ </td><td>
{:/nomarkdown}
```
<mrow notation="postfix">
  <mi>a</mi>
  <mo meaning="factorial">!</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> sup </td><td> power $x^n$ </td><td>
{:/nomarkdown}
```
<msup notation="sup" meaning="power">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> repeated application <br/> $f^n$ ($=f(f(...f))$)</td><td>
{:/nomarkdown}
```
<msup notation="sup" meaning="applicative-power">
  <mi>f</mi>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> inverse $\sin^{-1}$ </td><td>
{:/nomarkdown}
```
<msup notation="sup" meaning="applicative-power">
  <mi>sin</mi>
  <mn>-1</mn>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> $n$-th derivative $f^{(n)}$ </td><td>
{:/nomarkdown}
```
<msup notation="sup" meaning="nth-derivative-implicit-variable">
  <mi>f</mi>
  <mrow>
    <mo>(</mo>
    <mi>n</mi>
    <mo>)</mo>
  </mrow>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> sub </td><td> indexing $a_i$ </td><td>
{:/nomarkdown}
```
<msup notation="sub" meaning="index">
  <mi>a</mi>
  <mi>i</mi>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> sup-operator </td><td> transpose $A^T$ </td><td>
{:/nomarkdown}
```
<msup notation="sup-operator">
  <mi>A</mi>
  <mi meaning="transpose">T</mn>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> adjoint $A^\dagger$ </td><td>
{:/nomarkdown}
```
<msup notation="sup-operator">
  <mi>A</mi>
  <mi meaning="adjoint">&dagger;</mn>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td> </td><td> $2$-nd derivative $f''$ </td><td>
{:/nomarkdown}
```
<msup notation="sup" meaning="2nd-derivative-implicit-variable">
  <mi>f</mi>
  <mo>''</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<!-- ======================================== -->
<tr><td> base-operator </td><td> binomail $C^n_m$ </td><td>
{:/nomarkdown}
```
<msubsup notation="base-operation">
  <mi meaning="binomial">C</mi>
  <mi>m</mi>
  <mi>n</mi>
</msubsup>
```
{::nomarkdown}
</td></tr>
<tr><td/><td colspan="2">Note the argument order is reversed</td></tr>
<!-- ======================================== -->
<!--
<tr><td> fenced </td><td> grouping $(a+b)$ </td><td>
{:/nomarkdown}
```
<mrow>
  <mo>(</mo>
  <mi>a</mi>
  <mo>+</mo>
  <mi>b</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
-->
<tr><td> fenced </td><td> absolute value $|x|$ </td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="absolute-value">
  <mo>|</mo>
  <mi>x</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> norm $|\mathbf{x}|$ </td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="norm">
  <mo>|</mo>
  <mi> mathvariant="bold"x</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> determinant $|\mathbf{X}|$ </td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="determinant">
  <mo>|</mo>
  <mi mathvariant="bold">X</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> sequence $\lbrace a_n\rbrace$ </td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="sequence">
  <mo>{</mo>
  <msub>
    <mi>x</mi>
    <mi>n</mi>
  </msub>
  <mo>}</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> open interval $(a,b)$ </td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="open-interval">
  <mo>(</mo>
  <mi>a</mi>
  <mo>,</mo>
  <mi>b</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> open interval $]a,b[$ </td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="open-interval">
  <mo>]</mo>
  <mi>a</mi>
  <mo>,</mo>
  <mi>b</mi>
  <mo>[</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td/><td colspan="2">closed, open-closed, etc. similarly</td></tr>

<tr><td> </td><td> inner product $\left<\mathbf{a},\mathbf{b}\right>$</td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="inner-product">
  <mo>&lt;</mo>
  <mi mathvariant="bold">a</mi>
  <mo>,</mo>
  <mi mathvariant="bold">b</mi>
  <mo>&gt;</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> Legendre symbol $(n|p)$</td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="Legendre symbol">
  <mo>(</mo>
  <mi>n</mi>
  <mo>|</mo>
  <mi>p</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td/><td>Jacobi symbol</td><td>similarly</td></tr>

<tr><td> </td><td> Clebsch-Gordan<br/> $(j_1 m_1 j_2 m_2 | j_1 j_2 j_3 m_3)|$</td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="Clebsch-Gordan">
  <mo>(</mo>
  <msub><mi>j</mi><mn>1</mn>
  <msub><mi>m</mi><mn>1</mn>
  <msub><mi>j</mi><mn>2</mn>
  <msub><mi>m</mi><mn>2</mn>
  <mo>|</mo>
  <msub><mi>j</mi><mn>1</mn>
  <msub><mi>j</mi><mn>2</mn>
  <msub><mi>j</mi><mn>3</mn>
  <msub><mi>m</mi><mn>3</mn>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>fenced-sub </td><td> Pochhammer $\left(a\right)_n$ </td><td>
{:/nomarkdown}
```
<msup notation="fenced-sub" meaning="Pochhammer">
  <mrow>
    <mo>(</mo>
    <mi>a</mi>
    <mo>)</mo>
  </mrow>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>fenced-stacked </td><td> binomial $\binom{n}{m}$ </td><td>
{:/nomarkdown}
```
<mrow notation="stacked-fenced" meaning="binomial">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi>n</mi>
    <mi>m</mi>    
  </mfrac>
  <mo>)</mo>
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> multinomial $\binom{n}{m_1,m_2,m_3}$ </td><td>
{:/nomarkdown}
```
<mrow notation="stacked-fenced" meaning="multinomial">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi>n</mi>
    <mrow>
      <msub><mi>m</mi><mn>1</mn></msup>
      <mo>,</mo>
      <msub><mi>m</mi><mn>2</mn></msup>
      <mo>,</mo>
      <msub><mi>m</mi><mn>3</mn></msup>
    </mrow>
  </mfrac>
  <mo>)</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td/><td/><td>??? puntuation separates the several arguments?</td></tr>

<tr><td> </td><td> Eulerian numbers $\left< n \atop k \right>$ </td><td>
{:/nomarkdown}
```
<mrow notation="stacked-fenced" meaning="Eulerian-numbers">
  <mo>&lt;</mo>
  <mfrac thickness="0pt">
    <mi>n</mi>
    <mi>k</mi>    
  </mfrac>
  <mo>&gt;</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>fenced-table</td><td> 3j symbol<br/> $\left(\begin{array}{ccc}j_1& j_2 &j_3 \\ m_1 &m_2 &m_3\end{array}\right)$</td><td>
{:/nomarkdown}
```
<mrow notation="fenced" meaning="3j">
  <mo>(</mo>
  <mtable>
    <mtr>
      <mtd><msub><mi>j</mi><mn>1</mn></mtd>
      <mtd><msub><mi>j</mi><mn>2</mn></mtd>
      <mtd><msub><mi>j</mi><mn>3</mn></mtd>
    </mtr>
    <mtr>
      <mtd><msub><mi>m</mi><mn>1</mn></mtd>
      <mtd><msub><mi>m</mi><mn>2</mn></mtd>
      <mtd><msub><mi>m</mi><mn>3</mn></mtd>
    </mtr>
  </mtable>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td/><td>6j, 9j, ...</td><td>similarly</td></tr>
<!-- ======================================== -->
</tbody>
</table>
{:/nomarkdown}

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## The Bad and the Ugly
Special cases and various bits not quite worked out.

### infix, prefix, postfix
Infix may be a bit of a special case, depending on how `mrow` is used,
and depending on what is required.  For a row with multiple operators
with the same precedence, it may be sufficient to simply "read" across al
the children (alternating terms and operators).  When prefix, postfix
or function calls are involved, those groups probably will need to be
grouped in their own `mrow`.

### powers and defaults
Given that powers are probably the most common markup for superscripts,
defaults would be nice.  Omitting the notation attribute, but providing
```meaning="power"``` would suggest that the entire ```msup``` has meaning "power",
which is wrong.  However, perhaps power could be the default meaning for notation sup?

Note that, for $A^T$, one might be tempted to place ```meaning="transpose"``` on the ```msup```,
but that would imply that transpose is being applied to both $A$ and $T$.

### sub-, super-, over-, under-scripts
For any single script, the pattern is essentially the same,
with cases where the operator is the script, the base(?) or neither
(in which case the meaning would appear on the ```msup```, eg).
However, it is common for both sub- and superscripts to be used,
with different purposes. Or even combinations of regular and over- and underscripts.
Not to mention, prescripts.

Even worse, the nesting that is preferred for aesthetics is often
the opposite of the semantic nesting.
For example, David Farmer's example $\overline{x}_i$ which
was taken to mean the mean of the i-th interval. Presumably $x_i$ is the
i-th interval, but the line (from the inner ```mover```) only covers the $x$.

How should the different operators be indicated, and reversing the nesting?

### fenced
In many cases, eg. conditional sets $\lbrace x \in \Re | x > 0 \rbrace$,
different punctuation may collect arguments into different groups.
It may be necessary to distinguish the number of elements within the fence
and the presence, or lack, of punctuation

### fenced-stacked
In multinomial coeefficients, the bottom row is punctuated;
is it appropriate to generalize fenced-stacked to deal with punctuation?

### Function calls
The notations used for functions varies widely; with $f(x)$ and without $\sin x$ parentheses;
various punctuations $A(a,b;z|q)$; distinguishing "parameters" from "arguments" including
some in subscripts and some conventional $J_\nu(z)$.
Additionally, the MathML markup may or may not include an explicit `&ApplyFunction;`.
Without care, this could lead to an endless list of very specialized notations,
or alternatively would require complex matching to determine the arguments.

An alternative might be that if the relevant fences and punctuation is recognized
(or appropriately marked), they would be ignorable (other than possibly affecting grouping),
so that
```
<mrow notation="funcall">
  <mi>A</mi>
  <mo notation="open">(</mo>
  <mi>a</mi>
  <mo notation="punct">,</mo>
  <mi>b</mi>
  <mo notation="punct">;</mo>
  <mi>z</mi>
  <mo notation="punct">|</mo>
  <mi>q</mi>
  <mo notation="close">(</mo>
</mrow>
```
would be "easily" recognized as $f$ applied to $a,b,z$ and $q$.

Perhaps some notion of currying could be used to deal with $J_\nu(z)$:
```
<mrow notation="funcall">
  <msub notation="base-operator">
    <mi meaning="BesselJ">J</mi>
    <mi>&#x3BD;</mi>
  </msub>
  <mo notation="open">(</mo>
  <mi>z</mi>
  <mo notation="close">(</mo>
</mrow>
```

## Derivatives and Integrals
Although Leibnitz' notation for differentiation is nicely suggestive,
it is perhaps not useful to rely on implied limits to annotate the
range of expressions encountered.
$\frac{df}{dx}$, $\frac{d^2f}{dx^2}$, $\frac{d^2f}{dx dy}$
(in the second case: the `msup` *should* contain "dx", not just "x"!)
The best solution would avoid an explosion of special-case notations,
the need for complicated matching, and still keep the markup manageable.
Probably explicitly marking the differentials would be a first step.
Then perhaps something like the following could be worked out:
```
<mfrac notation="Leibnitz-derivative">
  <mrow>
    <msup>
      <mo notation="differential">d</mo>
      <mn>2</mn>
    </msup>
    <mi>f</mix>
  </mrow>
  <mrow>
    <mo notation="differential">d</mo>
    <mi>x</mix>
    <mo notation="differential">d</mo>
    <mi>y</mix>
  </mrow>
</mfrac>
```
Or perhaps not.

Integration is a bit different, but perhaps also benefits from explicitly
marking the differentials, since they may appear in several locations:
$\int f(x) dx$, but also $\int dx f(x)$, and even $\int \frac{dr}{r}$.
Perhaps searching for those differentials (that are not part of a derivative)
is workable.

## Continued Fractions
Several notations.  Not really thought through.


<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Summary
This idea has a lot of detail to be worked out, including at least
* naming conventions;
* the set of MathML container elements which give rise to such constructs
  and need corresponding notation keywords;
* defaults

## An Alternative
An alternative may be to define some small language for listing the locations of arguments
in the subtree; presumably something more concise than XPath.

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
