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
We propose an attribute, tentatively called "intent",
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

literal  ::= [letters|digits|_|-]+
selector ::= argref
argref   ::= '#' NCName
```
<!-- path | idref | ...
path    ::= '@' [digit]+ | path/path
idref   ::= '#' NCName
```
-->
[The syntactic details, and whether alternative selectors are needed, is up for debate.]

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

The group concensus is currently leaning towards the `argref` style of selector. An argref is like
an idref, but unlike `xml:id` which must be globally unique (i.e. within the entire document),
an argument identifier, supplied by the `arg` attribute,
is scoped by elements with the `intent` attribute.
That is, an `arg` attribute is visible only to the nearest ancestor with a `intent`
attribute, and therefore need not be unique to the document, nor even within a given
`m:math` element.  The downside of this method is that when resolving a `intent` attribute,
a bit of special code is needed to find the arguments.  For example to find an argument
with identifier `arg1`, something like the following XPath could be used:
```
.//@arg[.='arg`'] except .//*[@notation]/*//@arg
```

In any case, author supplied annotation has simplified the task by
isolating the operator and arguments of subexpressions, (mostly?) eliminating
the need to pattern match on the presentation tree.

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Some Examples

With this model, the two ```msup``` examples, power $x^n$ and transpose $A^T$,
would be distinguished as follows:
```
<msup intent="power(@base,@exp)">
  <mi arg="base">x</mi>
  <mi arg="exp">n</mi>
</msup>
```

The translation could be of various
forms including "the n-th power of x", or "x squared" for $x^2$.
The transpose example would be marked up as
```
<msup intent="@op(@a)">
  <mi arg="a">A</mi>
  <mi arg="op" intent="transpose">T</mi>
</msup>
```
which is easily extended to cover conjugate and adjoint.
Or even
```
<msup intent="@op(@a)">
  <mi arg="a">A</mi>
  <mi arg="op" intent="Tralfamadorian inverse">T</mi>
</msup>
```
which could be translated as "the Tralfamadorian inverse of A",
without needing any additional dictionary entries.
Likewise,
```
<msup intent="frobulator">
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
<msup intent="transpose(A)">
  <mi>A</mi>
  <mi>T</mi>
</msup>
```
```
<msup intent="transpose(@a)">
  <mi arg="a">A</mi>
  <mi>T</mi>
</msup>
```
```
<msup intent="@mop(@marg)">
  <mi arg="marg">A</mi>
  <mi arg="mop" intent="transpose">T</mi>
</msup>
```
and so on; the latter, fine-grained, form gives the user agent
more leeway for highlighting, navigation, etc.

A binomial would be marked up as:
```
<mrow intent="binomial(@n,@m)">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi arg="n">n</mi>
    <mi arg="m">m</mi>
  </mfrac>
  <mo>)</mo>
</mrow>
```
This pattern covers Eulerian numbers, Jacobi and Legendre symbols.
Conversely, it  still allows alternate notations for binomials while keeping the same
semantics, since we can write:
```
<msubsup intent="@op(@n,@m)">
  <mi arg="op" intent="binomial">C</mi>
  <mi arg="n">n</mi>
  <mi arg="m">m</mi>
</msubsup>
```
Or as some would prefer
```
<msubsup intent="@op(@n,@m)">
  <mi arg="op" intent="binomial">C</mi>
  <mi arg="m">m</mi>
  <mi arg="n">n</mi>
</msubsup>
```
Each of the above binomials have the same semantic content,
and (presumably) would generate the same translation.

A row of infix with multiple operators may seem to be a special case,
depending on how `mrow` is used, but basically it forces the annotator
to specify the exact nesting and precedence of operators:
```
<mrow intent="@p(@a,@b,@m(@c),@d)">
  <mi arg="a">a</mi>
  <mo arg="p" intent="plus">+</mo>
  <mi arg="b">b</mi>
  <mo arg="m" intent="minus">-</mo>
  <mi arg="c">c</mi>
  <mo>+</mo>
  <mi arg="d">d</mi>
</mrow>
```
Such expressions can be annotated whether the presentation
is rich or poor in `mrow`s; one only has to annotate at the appropriate
level in the tree.

A variety of infix operators ($\times$, $\cdot$, etc) are handled by
adding the appropriate meaning to each.

Prefix and Postfix operators, are simple, provided they are contained
within an ```mrow```:
```
<mrow intent="@op(@a)">
  <mi arg="a">n</mi>
  <mo arg="op" intent="factorial">!</mo>
</mrow>
```
A little less simple if they are not
```
<mrow intent="@p(@a,@f(@b))">
  <mi arg="a">a</mi>
  <mo arg="p" intent="plus">+</mo>
  <mi arg="b">b</mi>
  <mo arg="f" intent="factorial">!</mo>
</mrow>
```

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Notation Catalog

In the case of argument selectors being relative paths,
a collection of common shorthands could be collected
as named notations.
With `xml:id`s or even `argid`s, this is not so clearly feasible.

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
<mrow intent="@op1(@arg1,@arg2,@op2(@arg3),@arg4)">
  <mi arg="arg1">a</mi>
  <mo arg="op1" intent="plus">+</mo>
  <mi arg="arg2">b</mi>
  <mo arg="op2" intent="minus">-</mo>
  <mi arg="arg3">c</mi>
  <mo>+</mo>
  <mi arg="arg4">d</mi>
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td>  </td><td> inner product $\mathbf{a}\cdot\mathbf{b}$ </td><td>
{:/nomarkdown}
```
<mrow intent="@op(@arg1,@arg2)">
  <mi arg="arg1" mathvariant="bold">a</mi>
  <mo arg="op" intent="inner-product>&@x22C5;</mo>
  <mi arg="arg2" mathvariant="bold">b</mi>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td/><td colspan="2">Easily extended to other operators and meanings: cross-product, "by", etc.</td></tr>
<!-- ======================================== -->
<tr><td> prefix </td><td> negation $-a$ </td><td>
{:/nomarkdown}
```
<mrow intent="@op(@arg)">
  <mo arg="op" intent="unary-minus">-</mo>
  <mi arg="arg">a</mi>`
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> Laplacian $\nabla^2 f$ </td><td>
{:/nomarkdown}
```
<mrow intent="@op(@arg)">
  <msup arg="op" intent="laplacian">
    <mi>&@x2207;</mi>
    <mn>2</mn>
  </msup>
  <mi arg="arg">f</mi>`
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> postfix </td><td> factorial $n!$ </td><td>
{:/nomarkdown}
```
<mrow intent="@op(@arg)">
  <mi arg="arg">a</mi>
  <mo arg="op" intent="factorial">!</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> sup </td><td> power $x^n$ </td><td>
{:/nomarkdown}
```
<msup intent="power(@base,@exp)">
  <mi arg="base">x</mi>
  <mi arg="exp">n</mi>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> iterated function <br/> $f^n$ ($=f(f(...f))$)</td><td>
{:/nomarkdown}
```
<msup intent="functional-power(@op,$n)">
  <mi arg="op">f</mi>
  <mi arg="n">n</mi>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> inverse $\sin^{-1}$ </td><td>
{:/nomarkdown}
```
<msup intent="functional-power(@op,@n)">
  <mi arg="op">sin</mi>
  <mn arg="n">-1</mn>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> $n$-th derivative $f^{(n)}$ </td><td>
{:/nomarkdown}
```
<msup intent="derivative-implicit-variable(@op,@n)">
  <mi arg="op">f</mi>
  <mrow>
    <mo>(</mo>
    <mi arg="n">n</mi>
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
<msup intent="index(@array,@index)">
  <mi arg="array">a</mi>
  <mi arg="index">i</mi>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> sup-operator </td><td> transpose $A^T$ </td><td>
{:/nomarkdown}
```
<msup intent="@op(@x)">
  <mi arg="x">A</mi>
  <mi arg="op" intent="transpose">T</mn>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td> </td><td> Compare to $\mathrm{trans}(A)$ </td>
<td>
{:/nomarkdown}
```
<mrow intent="@op(@x)">
  <mi arg="op" intent="transpose">trans</mi>
  <!-- optionally &ApplyFunction; -->
  <mi arg="x">A</mn>
</mrow>
```
{::nomarkdown}
</td>
</tr>
<tr><td> </td><td> Or the function $\mathrm{trans}$ </td>
<td>
{:/nomarkdown}
```
<mi intent="transpose">trans</mi>
```
{::nomarkdown}
</td>
</tr>
<tr><td> </td><td> adjoint $A^\dagger$ </td><td>
{:/nomarkdown}
```
<msup intent="@op(@x)">
  <mi arg="x">A</mi>
  <mi arg="op" intent="adjoint">&dagger;</mn>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td> </td><td> $2$-nd derivative $f''$ </td><td>
{:/nomarkdown}
```
<msup intent="derivative-implicit-variable(@op,@n)">
  <mi arg="op">f</mi>
  <mo arg="n" intent="2">''</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td>Awkward nesting</td><td> $x'_i$ </td><td>
{:/nomarkdown}
```
 <msubsup intent="derivative-implicit-variable(index(@array,@index))">
   <mi arg="array">x</mi>
   <mi arg="index">i</mi>
   <mo>'</mo>
  </msubsup>
```
{::nomarkdown}
</td></tr>
<tr><td></td><td> or maybe</td><td>
{:/nomarkdown}
```
 <msubsup intent="index(derivative-implicit-variable(@op),@index)">
   <mi arg="op">x</mi>
   <mi arg="index">i</mi>
   <mo>'</mo>
  </msubsup>
```
{::nomarkdown}
</td></tr>
<tr><td></td><td>  $\overline{x}_i$ being midpoint of $x_i$</td>
<td>
{:/nomarkdown}
```
 <msub intent="@op(index(@line,@index))">
    <mover accent="true">
      <mi arg="line">x</mi>
      <mo arg="op" intent="midpoint">¯</mo>
    </mover>
    <mi arg="index">i</mi>
  </msub>
```
{::nomarkdown}
</td>
</tr>
<tr><td></td><td> Versus: $\overline{x}_i$ being ith element of $\overline{x}$ </td>
<td>
{:/nomarkdown}
```
 <msub intent="index(@arr,@index)">
    <mover arg="arr" accent="true" intent="@op(@line)>
      <mi arg="line">x</mi>
      <mo arg="op" intent="midpoint">¯</mo>
    </mover>
    <mi arg="index">i</mi>
  </msub>
```
{::nomarkdown}
</td>
</tr>

<!-- ======================================== -->
<tr><td> base-operator </td><td> binomail $C^n_m$ </td><td>
{:/nomarkdown}
```
<msubsup intent="@op(@n,@m)">
  <mi arg="op" intent="binomial">C</mi>
  <mi arg="m">m</mi>
  <mi arg="n">n</mi>
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
<mrow intent="absolute-value(@x)">
  <mo>|</mo>
  <mi arg="x">x</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> norm $|\mathbf{x}|$ </td><td>
{:/nomarkdown}
```
<mrow intent="norm(@x)">
  <mo>|</mo>
  <mi arg="x"> mathvariant="bold"x</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> determinant $|\mathbf{X}|$ </td><td>
{:/nomarkdown}
```
<mrow intent="determinant(@x)">
  <mo>|</mo>
  <mi arg="x" mathvariant="bold">X</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> sequence $\lbrace a_n\rbrace$ </td><td>
{:/nomarkdown}
```
<mrow intent="sequence(@arg)">
  <mo>{</mo>
  <msub arg="arg">
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
<mrow intent="open-interval(@a,@b)">
  <mo>(</mo>
  <mi arg="a">a</mi>
  <mo>,</mo>
  <mi arg="b">b</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> open interval $]a,b[$ </td><td>
{:/nomarkdown}
```
<mrow intent="open-interval(@a,@b)">
  <mo>]</mo>
  <mi arg="a">a</mi>
  <mo>,</mo>
  <mi arg="b">b</mi>
  <mo>[</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td/><td colspan="2">closed, open-closed, etc. similarly</td></tr>

<tr><td> </td><td> inner product $\left<\mathbf{a},\mathbf{b}\right>$</td><td>
{:/nomarkdown}
```
<mrow intent="inner-product(@a,@b)">
  <mo>&lt;</mo>
  <mi arg="a" mathvariant="bold">a</mi>
  <mo>,</mo>
  <mi arg="b" mathvariant="bold">b</mi>
  <mo>&gt;</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> Legendre symbol $(n|p)$</td><td>
{:/nomarkdown}
```
<mrow intent="Legendre-symbol(@n,@p)">
  <mo>(</mo>
  <mi arg="n">n</mi>
  <mo>|</mo>
  <mi arg="p">p</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td/><td>Jacobi symbol</td><td>similarly</td></tr>

<tr><td> </td><td> Clebsch-Gordan<br/> $(j_1 m_1 j_2 m_2 | j_1 j_2 j_3 m_3)|$</td><td>
{:/nomarkdown}
```
<mrow intent="Clebsch-Gordan(@a1,@a2,@a3,@a4,@b1,@b2,@b3,@b4)">
  <mo>(</mo>
  <msub arg="a1"><mi>j</mi><mn>1</mn>
  <msub arg="a2"><mi>m</mi><mn>1</mn>
  <msub arg="a3"><mi>j</mi><mn>2</mn>
  <msub arg="a4"><mi>m</mi><mn>2</mn>
  <mo>|</mo>
  <msub arg="b1"><mi>j</mi><mn>1</mn>
  <msub arg="b2"><mi>j</mi><mn>2</mn>
  <msub arg="b3"><mi>j</mi><mn>3</mn>
  <msub arg="b4"><mi>m</mi><mn>3</mn>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>fenced-sub </td><td> Pochhammer $\left(a\right)_n$ </td><td>
{:/nomarkdown}
```
<msup intent="Pochhammer(@a,@n)">
  <mrow>
    <mo>(</mo>
    <mi arg="a">a</mi>
    <mo>)</mo>
  </mrow>
  <mi arg="n">n</mi>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>fenced-stacked </td><td> binomial $\binom{n}{m}$ </td><td>
{:/nomarkdown}
<!-- <mrow intent="binomial(@2/1,@2/2)"> -->
```
<mrow intent="binomial(@n,@m)">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi arg="n">n</mi>
    <mi arg="m">m</mi>
  </mfrac>
  <mo>)</mo>
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> </td><td> multinomial $\binom{n}{m_1,m_2,m_3}$ </td><td>
{:/nomarkdown}
<!-- <mrow intent="multinomial(@2/1,@2/2/1,@2/2/3,@2/2/5)"> -->
```
<mrow intent="multinomial(@n,@m1,@m2,@m3)">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi arg="n">n</mi>
    <mrow>
      <msub arg="m1"><mi>m</mi><mn>1</mn></msup>
      <mo>,</mo>
      <msub arg="m2"><mi>m</mi><mn>2</mn></msup>
      <mo>,</mo>
      <msub arg="m3"><mi>m</mi><mn>3</mn></msup>
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
<mrow intent="Eulerian-numbers(@n,@k)">
  <mo>&lt;</mo>
  <mfrac thickness="0pt">
    <mi arg="n">n</mi>
    <mi arg="k">k</mi>
  </mfrac>
  <mo>&gt;</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>fenced-table</td><td> 3j symbol<br/> $\left(\begin{array}{ccc}j_1& j_2 &j_3 \\ m_1 &m_2 &m_3\end{array}\right)$</td><td>
{:/nomarkdown}
<!-- <mrow intent="3j(@2/1/1,@2/1/2,@2/1/3,@2/2/1,@2/2/2,@2/2/3)">-->
```
<mrow intent="3j(@j1,@j2,@j3,@m1,@m2,@m3)">
  <mo>(</mo>
  <mtable>
    <mtr>
      <mtd arg="j1"><msub><mi>j</mi><mn>1</mn></mtd>
      <mtd arg="j2"><msub><mi>j</mi><mn>2</mn></mtd>
      <mtd arg="j3"><msub><mi>j</mi><mn>3</mn></mtd>
    </mtr>
    <mtr>
      <mtd arg="m1"><msub><mi>m</mi><mn>1</mn></mtd>
      <mtd arg="m2"><msub><mi>m</mi><mn>2</mn></mtd>
      <mtd arg="m3"><msub><mi>m</mi><mn>3</mn></mtd>
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
<mrow intent="@op(@p1,@p2,@a1,@q)">
  <mi arg="op">A</mi>
  <mo>(</mo>
  <mi arg="p1">a</mi>
  <mo>,</mo>
  <mi arg="p2">b</mi>
  <mo>;</mo>
  <mi arg="a1">z</mi>
  <mo>|</mo>
  <mi arg="q">q</mi>
  <mo>(</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td></td><td> Bessel $J_\nu(z)$</td><td>
{:/nomarkdown}
```
<mrow intent="@op(@nu,@z)">
  <msub>
    <mi arg="op" intent="BesselJ">J</mi>
    <mi arg="nu">&@x3BD;</mi>
  </msub>
  <mo>(</mo>
  <mi arg="z">z</mi>
  <mo>(</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td></td><td> curried Bessel $J_\nu(z)$</td><td>
{:/nomarkdown}
```
<mrow intent="@op(@nu)(@z)">
  <msub>
    <mi arg="op" intent="BesselJ">J</mi>
    <mi arg="nu" >&@x3BD;</mi>
  </msub>
  <mo>(</mo>
  <mi arg="z">z</mi>
  <mo>(</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>derivatives</td><td> $\frac{d^2f}{dx^2}$</td><td>
{:/nomarkdown}
<!-- <mfrac intent="Leibnitz-derivative(@1/2,@2/1/2,@1/1/2)"> -->
```
<mfrac intent="Leibnitz-derivative(@func,@var,@deg)">
  <mrow>
    <msup>
      <mo>d</mo>
      <mn>2</mn>
    </msup>
    <mi arg="func">f</mix>
  </mrow>
  <msup>
    <mrow>
      <mo>d</mo>
      <mi arg="var">x</mix>
    </mrow>
    <mn arg="deg">2</mn>
  </msup>
</mfrac>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td>integrals</td><td> $\int\frac{dr}{r}$</td><td>
{:/nomarkdown}
```
<mrow intent="@op(divide(1,@r),@bvar)">
  <mo arg="op" intent="integral">&x222B;</mo>
  <mfrac>
    <mrow>
      <mi>d</mi>
      <mi arg="bvar">r</mi>
    </mrow>
    <mi arg="r">r</mi>
  </mfrac>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td/><td colspan="2">One might be tempted put intent="divide(1,@r)" on the mfrac, but this blocks access to @bvar</td></tr>
<!-- ======================================== -->
<tr><td>continued fractions</td><td> $a_0+\displaystyle\frac{1}{a_1+\displaystyle\frac{1}{a_2+\cdots}}$</td><td>
{:/nomarkdown}
<!--<mrow intent="infinite-continued-fraction(@1,1,@3/1/2/1,1,@3/1/2/3/1/2)">-->
```
<mrow intent="infinite-continued-fraction(@a0,@b1,@a1,@b2,@a2)">
  <msub arg="a0"><mi>a</mi><mn>0</mn></msub>
  <mo>+</mo>
  <mstyle display="true">
    <mfrac>
      <mn arg="b1">1</mn>
      <mrow>
        <msub arg="a1"><mi>a</mi><mn>1</mn></msub>
        <mo>+</mo>
        <mstyle display="true">
          <mfrac>
            <mn arg="b2">1</mn>
            <mrow>
              <msub arg="a2"><mi>a</mi><mn>2</mn></msub>
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
