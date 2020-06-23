---
title: "Semantic Annotation Mini-Language"
layout: cgreport
---

*Authors*: Bruce Miller, Deyan Ginev (cribbing ideas from Neil Soiffer, Sam Dooley, David Carlisle)

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
We propose an attribute, tentatively called "semantic",
which describes the semantic tree of a Presentation MathML fragment
using a simple prefix notation. This mechanism provides for recursively
describing the operator and arguments, as well as ascribing a fixed semantics
to entire subtrees.  The main components are literals, for giving an explicit fixed
"meaning", and selectors for referring to the semantic of a child node.
The mini-language is specified as follows:

```
semantic ::=
             selector
           | literal
           | semantic '(' semantic [ ',' semantic ]* ')'

literal ::= [letters|digits|_|-]+
selector ::= path | idref | ...
path    ::= '@' [digit]+ | path/path
idref   ::= '#' NCName
```
[The syntactic details, and whether all options are needed, is up for debate.]

The literals are intended to correspond to some mathematical concept
or operator, or some application specific quantity or operation;
that is it represents some "meaning".
Ultimately, the goal is to *translate* this virtual content tree into
text or speech (in different languages), braille or some other form.
The preferred translation may also depend on context and user profile.
On the one hand, the most natural translation of a given expression
will depend on the operator.  It is thus desirable to have a set of
known meaning with translation rules.
On the other hand, mathematics encompasses an endless set of concepts,
arguing that the set of meanings should be open-ended.
We propose that there should be a small set of recommended meaning keywords
whose translation can be specialized, while allowing any value for the meaning
(an implementation is free to recognize more keywords).
In the case where a meaning is *not* known, support for multiple languages
or user profiles would likely be lost;
the translation of content token should simply be the literal itself,
or in general a template like "the [meaning] of [arg1], [arg2] and [argn] ...".

A variety of mechanisms are available for selectors, each with
significant strengths and weaknesses:
* path: a relative path to a child; often concise, but requires accounting for
  every element between the parent and descendent inluding mrows, mstyle, etc;
  it is thus brittle to small changes in markup.
* id: clearer and easier to read, but must be globally unique in the document

A softer form of id might be considered, similar to HTML's `name` attribute,
or perhaps class,
not required to be globally unique: The argument would be the first descendant with
that nama (not masked by another `semantic` attribute?).
Other forms of selector, such as XPath or CSS selectors, are probably more powerful
than is needed, and are quite verbose.

In any case, author supplied annotation has simplified the task by
isolating the operator and arguments of subexpressions, (mostly?) eliminating
the need to pattern match on the presentation tree.

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Some Examples

With this model, the two ```msup``` examples, power $x^n$ and transpose $A^T$,
would be distinguished as follows:
```
<msup semantic="power(@1,@2)">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
which could be expressed using ids, as:
```
<msup semantic="power(#m1.base,#m1.exp)">
  <mi id="m1.base">x</mi>
  <mi id="m1.exp">n</mi>
</msup>
```

The translation could be of various
forms including "the n-th power of x", or "x squared" for $x^2$.
The transpose example would be marked up as
```
<msup semantic="@2(@1)">
  <mi>A</mi>
  <mi semantic="transpose">T</mi>
</msup>
```
which is easily extended to cover conjugate and adjoint.
Or even
```
<msup semantic="@2(@1)">
  <mi>A</mi>
  <mi semantic="Tralfamadorian inverse">T</mi>
</msup>
```
which could be translated as "the Tralfamadorian inverse of A",
without needing any additional dictionary entries.
Likewise,
```
<msup semantic="frobulator">
  <mi>x</mi>
  <mo>'</mo>
</msup>
```
would be used for a composite symbol $x'$ which stands for the frobulator;
the translation would simply be "frobulator".

Given that notations can use literals, paths and ids to specify
the semantics of the operator and arguments,
there are several ways that a given expression could be annotated.
The transpose could be
```
<msup semantic="transpose(A)">
  <mi>A</mi>
  <mi>T</mi>
</msup>
```
```
<msup semantic="transpose(@1)">
  <mi>A</mi>
  <mi>T</mi>
</msup>
```
```
<msup semantic="#mop(#marg)">
  <mi id="marg">A</mi>
  <mi id="mop" semantic="transpose">T</mi>
</msup>
```
and so on.


A binomial would be marked up as:
```
<mrow semantic="binomial(@2/1,@2/2)">
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
<msubsup semantic="@1(@2,@3)">
  <mi semantic="binomial">C</mi>
  <mi>n</mi>
  <mi>m</mi>
</msubsup>
```
[Or did you mean
```
<msubsup semantic="@1(@3,@2)">
  <mi semantic="binomial">C</mi>
  <mi>m</mi>
  <mi>n</mi>
</msubsup>
```
?]
with (presumably) exactly the same translation as above.

Infix may be a bit of a special case, depending on how ```mrow``` is used,
since there may be multiple operators involved.
For example, dending on how you want to nest operators:
```
<mrow semantic="@2(@1,@3,@4(@5),@7)">
  <mi>a</mi>
  <mo semantic="plus">+</mo>
  <mi>b</mi>
  <mo semantic="minus">-</mo>
  <mi>c</mi>
  <mo>+</mo>
  <mi>d</mi>
</mrow>
```
A variety of infix operators ($\times$, $\cdot$, etc) are handled by
adding the appropriate meaning to each.

Prefix and Postfix operators, are simple, provided they are contained
within an ```mrow```:
```
<mrow semantic="@2(@1)">
  <mi>n</mi>
  <mo semantic="factorial">!</mo>
</mrow>
```
A little less simple if they are not
```
<mrow semantic="@2(@1,@4(@3))">
  <mi>a</mi>
  <mo semantic="plus">+</mo>
  <mi>b</mi>
  <mo semantic="factorial">!</mo>
</mrow>
```

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Notation Catalog

Conceivably, a collection of common shorthands could be collected
as named notations. To be reusable, they must be expressed in relative
terms, so they would use the path form of selector, rather than ids.
They would thus be appropriate only for the simpler, common forms.
Some of the most common patterns appear to be prefix: `@1(@2)`, postfix: `@2(@1)`.

We defer this, for now.

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
<mrow semantic="@2(@1,@3,@4(@5),@7)">
  <mi>a</mi>
  <mo semantic="plus">+</mo>
  <mi>b</mi>
  <mo semantic="minus">-</mo>
  <mi>c</mi>
  <mo semantic="plus">+</mo>
  <mi>d</mi>
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td>  </td><td> inner product $\mathbf{a}\cdot\mathbf{b}$ </td><td>
{:/nomarkdown}
```
<mrow semantic="@2(@1,@3)">
  <mi mathvariant="bold">a</mi>
  <mo semantic="inner-product>&#x22C5;</mo>
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
<mrow semantic="@1(@2)">
  <mo semantic="unary-minus">-</mo>
  <mi>a</mi>`
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> Laplacian $\nabla^2 f$ </td><td>
{:/nomarkdown}
```
<mrow semantic="@1(@2)">
  <msup semantic="laplacian">
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
<mrow semantic="@2(@1)">
  <mi>a</mi>
  <mo semantic="factorial">!</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> sup </td><td> power $x^n$ </td><td>
{:/nomarkdown}
```
<msup semantic="power(@1,@2)">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> repeated application <br/> $f^n$ ($=f(f(...f))$)</td><td>
{:/nomarkdown}
```
<msup semantic="applicative-power(@1,@2)">
  <mi>f</mi>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> inverse $\sin^{-1}$ </td><td>
{:/nomarkdown}
```
<msup semantic="applicative-power(@1,@2)">
  <mi>sin</mi>
  <mn>-1</mn>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> $n$-th derivative $f^{(n)}$ </td><td>
{:/nomarkdown}
```
<msup semantic="derivative-implicit-variable(@1,@2/2)">
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
<msup semantic="index(@1,@2)">
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
<msup semantic="@2(@1)">
  <mi>A</mi>
  <mi semantic="transpose">T</mn>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> adjoint $A^\dagger$ </td><td>
{:/nomarkdown}
```
<msup semantic="@2(@1)">
  <mi>A</mi>
  <mi semantic="adjoint">&dagger;</mn>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td> </td><td> $2$-nd derivative $f''$ </td><td>
{:/nomarkdown}
```
<msup semantic="sup" semantic="derivative-implicit-variable(@1,2)">
  <mi>f</mi>
  <mo>''</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td>Awkward nesting</td><td> $x'_i$ </td><td>
{:/nomarkdown}
```
 <msubsup semantic="derivative-implicit-variable(index(@1,@2))">
   <mi>x</mi>
   <mi>i</mi>
   <mo>'</mo>
  </msubsup>
```
{::nomarkdown}
</td></tr>
<tr><td></td><td> or maybe</td><td>
{:/nomarkdown}
```
 <msubsup semantic="index(derivative-implicit-variable(@1),@2)">
   <mi>x</mi>
   <mi>i</mi>
   <mo>'</mo>
  </msubsup>
```
{::nomarkdown}
</td></tr>
<tr><td></td><td> midpoint $\overline{x}_i$ </td><td>
{:/nomarkdown}
```
 <msub semantic="midpoint(index(@1/2,@2))">
    <mover accent="true">
      <mi>x</mi>
      <mo>¯</mo>
    </mover>
    <mi>i</mi>
  </msub>
```
{::nomarkdown}
</td></tr>

<!-- ======================================== -->
<tr><td> base-operator </td><td> binomail $C^n_m$ </td><td>
{:/nomarkdown}
```
<msubsup semantic="@1(@3,@2)">
  <mi semantic="binomial">C</mi>
  <mi>m</mi>
  <mi>n</mi>
</msubsup>
```
{::nomarkdown}
</td></tr>
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
<mrow semantic="absolute-value(@2)">
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
<mrow semantic="norm(@2)">
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
<mrow semantic="determinant(@2)">
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
<mrow semantic="sequence(@2)">
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
<mrow semantic="open-interval(@2,@4)">
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
<mrow semantic="open-interval(@2,@4)">
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
<mrow semantic="inner-product(@2,@4)">
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
<mrow semantic="Legendre-symbol(@2,@4)">
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
<mrow semantic="Clebsch-Gordan(@2,@3,@4,@5,@7,@8,@9,@10)">
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
<msup semantic="Pochhammer(@1/2,@2)">
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
<!-- <mrow semantic="binomial(@2/1,@2/2)"> -->
```
<mrow semantic="binomial(#m5.n,#m5.m)">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi id="m5.n">n</mi>
    <mi id="m5.m">m</mi>
  </mfrac>
  <mo>)</mo>
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> multinomial $\binom{n}{m_1,m_2,m_3}$ </td><td>
{:/nomarkdown}
<!-- <mrow semantic="multinomial(@2/1,@2/2/1,@2/2/3,@2/2/5)"> -->
```
<mrow semantic="multinomial(#m6.n,#m6.m1,#m6.m2,#m6.m3)">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi id="m6.n">n</mi>
    <mrow>
      <msub id="m6.m1"><mi>m</mi><mn>1</mn></msup>
      <mo>,</mo>
      <msub id="m6.m2"><mi>m</mi><mn>2</mn></msup>
      <mo>,</mo>
      <msub id="m6.m3"><mi>m</mi><mn>3</mn></msup>
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
<mrow semantic="Eulerian-numbers(@2/1,@2/2)">
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
<!-- <mrow semantic="3j(@2/1/1,@2/1/2,@2/1/3,@2/2/1,@2/2/2,@2/2/3)">-->
```
<mrow semantic="3j(#m7.j1,#m7.j2,#m7.j3,#m7.m1,#m7.m2,#m7.m3)">
  <mo>(</mo>
  <mtable>
    <mtr>
      <mtd id="m7.j1"><msub><mi>j</mi><mn>1</mn></mtd>
      <mtd id="m7.j2"><msub><mi>j</mi><mn>2</mn></mtd>
      <mtd id="m7.j3"><msub><mi>j</mi><mn>3</mn></mtd>
    </mtr>
    <mtr>
      <mtd id="m7.m1"><msub><mi>m</mi><mn>1</mn></mtd>
      <mtd id="m7.m2"><msub><mi>m</mi><mn>2</mn></mtd>
      <mtd id="m7.m3"><msub><mi>m</mi><mn>3</mn></mtd>
    </mtr>
  </mtable>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td/><td>6j, 9j, ...</td><td>similarly</td></tr>
<!-- ======================================== -->
<tr><td>functions</td><td> function $A(a,b;z|q)$</td><td>
{:/nomarkdown}
```
<mrow semantic="@1(@3,@5,@7,@9)">
  <mi>A</mi>
  <mo>(</mo>
  <mi>a</mi>
  <mo>,</mo>
  <mi>b</mi>
  <mo>;</mo>
  <mi>z</mi>
  <mo>|</mo>
  <mi>q</mi>
  <mo>(</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td></td><td> Bessel $J_\nu(z)$</td><td>
{:/nomarkdown}
```
<mrow semantic="@1/1(@1/2,@3)">
  <msub>
    <mi semantic="BesselJ">J</mi>
    <mi>&#x3BD;</mi>
  </msub>
  <mo>(</mo>
  <mi>z</mi>
  <mo>(</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td></td><td> curried Bessel $J_\nu(z)$</td><td>
{:/nomarkdown}
```
<mrow semantic="@1/1(@1/2)(@3)">
  <msub>
    <mi semantic="BesselJ">J</mi>
    <mi>&#x3BD;</mi>
  </msub>
  <mo>(</mo>
  <mi>z</mi>
  <mo>(</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>derivatives</td><td> $\frac{d^2f}{dx^2}$</td><td>
{:/nomarkdown}
<!-- <mfrac semantic="Leibnitz-derivative(@1/2,@2/1/2,@1/1/2)"> -->
```
<mfrac semantic="Leibnitz-derivative(#m8.func,#m8.var,#m8.deg)">
  <mrow>
    <msup>
      <mo>d</mo>
      <mn>2</mn>
    </msup>
    <mi id="m8.func">f</mix>
  </mrow>
  <msup>
    <mrow>
      <mo>d</mo>
      <mi id="m8.var">x</mix>
    </mrow>
    <mn id="m8.deg">2</mn>
  </msup>
</mfrac>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>integrals</td><td> $\int\frac{dr}{r}$</td><td>
{:/nomarkdown}
```
<mrow semantic="integral(divide(1,@2/2),@2/1/2)">
  <mo>&x222B;</mo>
  <mfrac>
    <mrow>
      <mi>d</mi>
      <mi>r</mi>
    </mrow>
    <mi>r</mi>
  </mfrac>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>continued fractions</td><td> $a_0+\displaystyle\frac{1}{a_1+\displaystyle\frac{1}{a_2+\cdots}}$</td><td>
{:/nomarkdown}
<!--<mrow semantic="infinite-continued-fraction(@1,1,@3/1/2/1,1,@3/1/2/3/1/2)">-->
```
<mrow semantic="infinite-continued-fraction(#m9.a0,#m9.b1,#m9.a1,#m9.b2,#m9.a2)">
  <msub id="m9.a0"><mi>a</mi><mn>0</mn></msub>
  <mo>+</mo>
  <mstyle display="true">
    <mfrac>
      <mn id="m9.b1">1</mn>
      <mrow>
        <msub id="m9.a1"><mi>a</mi><mn>1</mn></msub>
        <mo>+</mo>
        <mstyle display="true">
          <mfrac>
            <mn id="m9.b2">1</mn>
            <mrow>
              <msub id="m9.a2"><mi>a</mi><mn>2</mn></msub>
              <mo>+</mo>
              <mo>&#22EF;</mo>
            </mrow>
          </mfrac>
        </mstyle>
      </mrow>
    </mfrac>
  </mstyle>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
</tbody>
</table>
{:/nomarkdown}

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## The Bad and the Ugly
It would seem that quite complex notations can be marked up,
but the paths to components can be difficult to write by hand;
presumably not difficult by machine.

Note that this proposal generally avoids the need for wrapping
subexpressions in `mrow`s: the paths to arguments become longer if they are
used; more opaque if they are not.

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Summary
This idea has a lot of detail to be worked out, including at least
* syntax;
* awkwardness of long paths versus global character of ids
* defaults

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
