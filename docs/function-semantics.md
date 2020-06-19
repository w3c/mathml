---
title: "Functional Patterns for Semantic Annotation"
layout: cgreport
---

*Author*: Neil Soiffer



<nav id="toc" markdown="1">

# Table of Contents
{:.no_toc}

* toc
{:toc}

</nav>

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
# Motivation
These ideas were motivated by a comment by Deyan Ginev on the June 18 MathML. He had some reservations about [Bruce Miller's proposal](https://mathml-refresh.github.io/mathml/docs/layout-semantics); maybe he had the following in mind or maybe something different. His concern was that `notation` didn't capture the "tail" of what people do. This proposal is more flexible and I believe simpler in that there is no need to categorize abstractions.

# The Basics
I'll start with two simple examples using transpose and binomial coefficient examples:

* $A^T$:

```
<msup notation="transpose(@matrix)">
  <mi arg="matrix">A</mi>
  <mi>T</mi>
</msup>
```

* $\binom{n}{m}$

```
<mrow notation="binomial(@n, @m">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi arg="n">n</mi>
    <mi arg="m">m</mi>    
  </mfrac>
  <mo>)</mo>
</mrow>
```

The idea is that a `notation` attribute names a function and its arguments. `@xxx` is used to mean "find the argument with `arg` attribute value _xxx_" and replace `@xxx` with it.

Many notations such as the transpose notation are simple, so this proposal has an alternative method of markup that avoids some work: numbered arguments.

* $A^T$:

```
<msup notation="transpose(@0)">
  <mi>A</mi>
  <mi>T</mi>
</msup>
```

Here, the number '0' refers to the first (0-based) child of element with the notation attribute. Finding the ith child can be extended to arbitrary descendants by simply repeating it. For example:

* $\binom{n}{m}$

```
<mrow notation="binomial(@1@0, @1@1">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi>n</mi>
    <mi>m</mi>    
  </mfrac>
  <mo>)</mo>
</mrow>
```

# Pros and Cons
Although the `arg` attribute fills a similar function to `id`, it has a big advantage over using `id` in that it does not need to be globally unique. This makes it easier to generate and easier to reuse in a web page versus `id`.

Note: it is possible that we might be able to reuse an existing HTML attribute instead of creating a new one (`arg`). On the call, David Carlisle suggested that maybe we could use `name`. In this note, I'll use `arg`.

Numbered attribute values avoid the need for adding an `arg` attribute and are therefore less work to manually author. Their disadvantage is that they are fragile -- if a polyfill such as one for `mfenced` for MathML Core changes the document, the location of the children might change. A good polyfill hopefully at least preserves the non-`mfrenced` attributes of the `mfenced` element by transferring them to the corresponding `mrow`, so the named approach would still work.

Conversely, named arguments require more manual markup. Supporting both allows authors to choose what works best for their use case.

# _Some_ Details
This idea is not fully fleshed out, but some things can be clarified:
* The notation attribute can take any value, but it is likely only some values will be listed as known. Typically the value will be either a string representing a constant (e.g., "EulerNumber") or a string representing a function with arguments an in the examples above.

* The arguments to a function have one of the forms:
* `@<digits>+` or `@<letter><alphaChars>+` -- if digits, then then it refers to the ith child (0-based) of the element with the notation attr. If it starts with a letter, then it refers to the value of an `arg` attribute. If there are more than one `@`s present, they refer to the child of the match of the previous `@`.
* `@@<letter><alphaChars>+` -- nary match. All children are searched instead of stopping at the first child.

It is probably possible to extend the nary notation to work with a number also, but I'm less sure of that. E.g, maybe `notation=set("@1,@@2)" could mean match the second child, then continue matching all siblings that are offset by two from that. Maybe a slightly different "@>2" would make more sense. Potentially multiple nary picks could be given and the pattern repeated until the children of the element are exhausted. I don't have a use case for that though.

In the case of a named argument, the children would be searched for using a depth first search. The search stops when:
1. The element has an `arg` attribute. If the value matches, the element is searched for a secondary `@` arg; if there are no more args, the element is returned. If no match, the search continues on the next sibling of the current element.
2. A `notation` attribute is found. The search continues on the next sibling of the current element. Note that the `arg` attribute has already been checked for a match.

In step one, if an nary parameter is being matched, the search would continue on the next sibling instead of stopping.

A few things to note:
* although depth first might needless search deep down the tree, non-matching nodes are very likely to be leaf elements like fences or operators, so very little time will be wasted.
* potentially all the arguments could be searched for at once and a dictionary is returned of the matches.




# Examples of notations
Here are Bruce's example with this new style. I'll do some with numbers and others with names.

<!-- ======================================================================
  Big problems laying out tables. The goal is to embed multi-line quoted code
  within a table cell (ie. must be a parsed block).  I can't achieve this with "pipe" code.
  So I use raw HTML. A blank-line should end raw HTML, but does NOT in Jekyll.
  OTOH, there's a brace-colon-colon directive nomarkdown in kramdown;
  that works in Jekyll (& the github.io site), but not on github's standard .md
  -->

{::nomarkdown}
<table>
<thead><tr><th>Description</th><th>Code</th></tr></thead>
<tbody>
<!-- ======================================== -->
<tr><td> nary (discussed later)<br/> $a+b-c+d$ </td><td>
{:/nomarkdown}
```
<mrow notation="@@all">
  <mi arg="all">a</mi>
  <mo arg="all">+</mo>
  <mi arg="all">b</mi>
  <mo arg="all">-</mo>
  <mi arg="all">c</mi>
  <mo arg="all">+</mo>
  <mi arg="all">d</mi>
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> dot product $\mathbf{a}\cdot\mathbf{b}$ </td><td>
{:/nomarkdown}
```
<mrow notation="inner-product(@0, @2)">
  <mi mathvariant="bold">a</mi>
  <mo meaning="inner-product>&#x22C5;</mo>
  <mi mathvariant="bold">b</mi>
</mrow>
```
{::nomarkdown}
</td></tr>
<tr><td> negation $-a$ </td><td>
{:/nomarkdown}
```
<mrow notation="unary-minus(@operand)">
  <mo>-</mo>
  <mi arg="operand">a</mi>`
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> Laplacian $\nabla^2 f$ </td><td>
{:/nomarkdown}
```
<mrow notation="prefix">
  <msup meaning="laplacian(@1)">
    <mi>&#x2207;</mi>
    <mn>2</mn>
  </msup>
  <mi>f</mi>`
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> factorial $n!$ </td><td>
{:/nomarkdown}
```
<mrow notation="factorial(@0)">
  <mi>a</mi>
  <mo>!</mo>
</mrow>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> power $x^n$ </td><td>
{:/nomarkdown}
```
<msup notation="power(@base,@exp)">
  <mi arg="base">x</mi>
  <mi arg="exp">n</mi>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> repeated application <br/> $f^n$ ($=f(f(...f))$)</td><td>
{:/nomarkdown}
```
<msup notation="applicative-power(@0,@1)">
  <mi>f</mi>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> inverse $\sin^{-1}$ </td><td>
{:/nomarkdown}
```
<msup notation="applicative-power(@0,@1)">
  <mi>sin</mi>
  <mn>-1</mn>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> $n$-th derivative $f^{(n)}$ </td><td>
{:/nomarkdown}
```
<msup notation="nth-derivative-implicit-variable(@function, @n)">
  <mi arg="function">f</mi>
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
<tr><td> indexing $a_i$ </td><td>
{:/nomarkdown}
```
<msup notation="index(@0,@1)">
  <mi>a</mi>
  <mi>i</mi>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> transpose $A^T$ </td><td>
{:/nomarkdown}
```
<msup notation="transpose(@0)">
  <mi>A</mi>
  <mi meaning="transpose">T</mn>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> adjoint $A^\dagger$ </td><td>
{:/nomarkdown}
```
<msup notation="adjoint(@0)">
  <mi>A</mi>
  <mi>&dagger;</mn>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td> $2$-nd derivative $f''$ </td><td>
{:/nomarkdown}
```
<msup notation="2nd-derivative-implicit-variable(@0)">
  <mi>f</mi>
  <mo>''</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<!-- ======================================== -->
<tr><td> binomial $C^n_m$ </td><td>
{:/nomarkdown}
```
<msubsup notation="binomial(@1, @2)">
  <mi>C</mi>
  <mi>m</mi>
  <mi>n</mi>
</msubsup>
```
{::nomarkdown}
</td></tr>
<tr><td> absolute value $|x|$ </td><td>
{:/nomarkdown}
```
<mrow notation="absolute-value(@1)">
  <mo>|</mo>
  <mi>x</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> norm $|\mathbf{x}|$ </td><td>
{:/nomarkdown}
```
<mrow notation="norm(@1)">
  <mo>|</mo>
  <mi> mathvariant="bold"x</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> determinant $|\mathbf{X}|$ </td><td>
{:/nomarkdown}
```
<mrow notation="determinant(@matrix)">
  <mo>|</mo>
  <mi mathvariant="bold" arg="matrix">X</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> sequence $\lbrace a_n\rbrace$ </td><td>
{:/nomarkdown}
```
<mrow notation="sequence(@base, @index)">
  <mo>{</mo>
  <msub>
    <mi arg="base">x</mi>
    <mi arg="index">n</mi>
  </msub>
  <mo>}</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> open interval $(a,b)$ </td><td>
{:/nomarkdown}
```
<mrow notation="open-interval(@start, @end)">
  <mo>(</mo>
  <mi arg="start">a</mi>
  <mo>,</mo>
  <mi arg="end">b</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> open interval $]a,b[$ </td><td>
{:/nomarkdown}
```
<mrow notation="open-interval(@start, @end)">
  <mo>]</mo>
  <mi arg="start">a</mi>
  <mo>,</mo>
  <mi arg="end">b</mi>
  <mo>[</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td/><td colspan="2">closed, open-closed, etc. similarly</td></tr>

<tr><td> inner product $\left<\mathbf{a},\mathbf{b}\right>$</td><td>
{:/nomarkdown}
```
<mrow notation="inner-product(@arg1, @arg2)">
  <mo>&lt;</mo>
  <mi mathvariant="bold" arg="arg1">a</mi>
  <mo>,</mo>
  <mi mathvariant="bold" arg="arg2">b</mi>
  <mo>&gt;</mo>
</msup>
```
{::nomarkdown}
</td></tr>

<tr><td> Legendre symbol $(n|p)$</td><td>
{:/nomarkdown}
```
<mrow notation="Legendre-symbol(@arg1, arg2)">
  <mo>(</mo>
  <mi arg="arg1">n</mi>
  <mo>|</mo>
  <mi arg="arg2">p</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr>acobi symbol</td><td>similarly</td></tr>

<tr><td> Clebsch-Gordan<br/> $(j_1 m_1 j_2 m_2 | j_1 j_2 j_3 m_3)|$</td><td>
{:/nomarkdown}
```
<mrow notation="Clebsch-Gordan([@1,@2,@3,@4], [@6,@7,@8,@9])">
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
<tr><td> Pochhammer $\left(a\right)_n$ </td><td>
{:/nomarkdown}
```
<msup notation="Pochhammer(@x, @n)">
  <mrow>
    <mo>(</mo>
    <mi arg="x">a</mi>
    <mo>)</mo>
  </mrow>
  <mi arg="n">n</mi>
</msup>
```
{::nomarkdown}
</td></tr>
<!-- ======================================== -->
<tr><td> binomial $\binom{n}{m}$ </td><td>
{:/nomarkdown}
```
<mrow notation="binomial(@n, @m)">
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

<tr><td> multinomial $\binom{n}{m_1,m_2,m_3}$ </td><td>
{:/nomarkdown}
```
<mrow notation="multinomial(@n, [@k1, @k2, @k3])">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi arg="n">n</mi>
    <mrow>
      <msub arg="k1"><mi>m</mi><mn>1</mn></msup>
      <mo>,</mo>
      <msub arg="k2"><mi>m</mi><mn>2</mn></msup>
      <mo>,</mo>
      <msub arg="k3"><mi>m</mi><mn>3</mn></msup>
    </mrow>
  </mfrac>
  <mo>)</mo>
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td> Eulerian numbers $\left< n \atop k \right>$ </td><td>
{:/nomarkdown}
```
<mrow notation="Eulerian-numbers(@n, @k)">
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
<tr><td> 3j symbol<br/> $\left(\begin{array}{ccc}j_1& j_2 &j_3 \\ m_1 &m_2 &m_3\end{array}\right)$</td><td>
{:/nomarkdown}
```
<mrow notation="3j([@j1,@j2,@j3][@m1,@m2,@m3])">
  <mo>(</mo>
  <mtable>
    <mtr>
      <mtd><msub arg="j1"><mi>j</mi><mn>1</mn></mtd>
      <mtd><msub arg="j2"><mi>j</mi><mn>2</mn></mtd>
      <mtd><msub arg="j3"><mi>j</mi><mn>3</mn></mtd>
    </mtr>
    <mtr>
      <mtd><msub arg="k1"><mi>m</mi><mn>1</mn></mtd>
      <mtd><msub arg="k2"><mi>m</mi><mn>2</mn></mtd>
      <mtd><msub arg="k3"><mi>m</mi><mn>3</mn></mtd>
    </mtr>
  </mtable>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td></tr>
<tr><td>6j, 9j, ...</td><td>similarly</td></tr>
<!-- ======================================== -->
</tbody>
</table>
{:/nomarkdown}

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
# The Good, the bad, and the lost in the fog
Special cases and various bits not quite worked out.

## Two masters
I think we have all been focused on getting semantics out and figured conversion to Content MathML, Speech, Braille, and anything else would just follow. However, here are two cases where speech doesn't necessarily flow from a function-based version of semantics:
* Transpose can be written as $A^T$ and as $\mathrm{trans}(A)$. Both would have the value `transpose(A)` in the above scheme. But it is likely we would want to speak the first as "A transpose" and the second as "the transpose of A".
* Infix notation seems simple: grab the operands and name the function the name of the operands as in `plus(a,b,c)`. However, "a-b+c" is problematic because there are two operators: `+` and `-`. Computation systems typically solve this by using a unary minus as in `plus(a1, times(-1, b), c)`. The exact same representation would be used for "1+-2+3". Speech needs to distinguish these two forms. Without "good" `mrow` structure, operators tend to be mixed. This isn't a problem for speech or braille, but is one for conversion to Content MathML and computation systems.

This is a problem for Bruce's proposal and this proposal. Potentially the speech problem is solved using the "hack" in the $a+b+c+d$ example above where both the operands and operators are returned. It isn't good for conversion to Content MathML though.

## Nested notations
All the examples were "simple" examples in that "notation" only occurred once. Arguably, the ones with subscripted variables such as Clebsch-Gordan should probably have tagged the `msub`, but I just followed Bruce's example.

Here's an example of nesting $\binom{n^2}{m}$:
```
<mrow notation="binomial(@n, @m">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <msup notation="power(@base,@exp)" arg='n'>
      <mi arg="@base">n</mi>
      <mn arg="@exp">2</mn>
    </msup>
    <mi arg="m">m</mi>    
  </mfrac>
  <mo>)</mo>
</mrow>
```

## infix, prefix, postfix
At least for Content MathML conversion, "good" `mrow` structure is needed for both Bruce and my proposal. For speech, my proposal can get by with flattened `mrow`s.

The details for nary matches need to be worked out so that one can grab the operands in something like $a * b * c *d$. There is some hand waving in [the section that introduces the nary notation](#some-details), but that part of the section is not thought through.

## Other cases Bruce lists:

* powers and defaults
* sub-, super-, over-, under-scripts
* fenced
* fenced-stacked
* Function calls
* Derivatives and Integrals
* Continued Fractions

These don't cause problems in this system. In particular:
* any notation for function call is easily supported
* find the $dx$ in integrals, etc., is not a problem 
* continued functions just work with `notation="ContinuedFraction([@a0, @a1, @a2, @a3])` for a fraction like
\[
  a_0+\cfrac{1}{a_1+\cfrac{1}{a_2+\cfrac{1}{a_3+\cdots}}}
\]

## The Elephant in the Room Everyone Knows Wants To Be Fed
As with `mathrole` and `meaning`, this proposal will only be useful if we end up standardizing "some" names. This was definitely a problem for Content MathML in the past. Hopefully with the passage of time and also the (maybe) reduction in complexity of this proposal, we can create a larger and more useful list more quickly. We should be able to easily create a list equivalent to pragmatic Content MathML easily. 
<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
# Summary
I believe this proposal is an improvement over using `mathrole` because it bundles the meaning with its arguments without addition tables to figure them out. I also feel it is an improvement over trying to extract out patterns of usage and name them as that requires developing (and remembering) to open-ended sets of names and introduces an indirection that doesn't add any power.
<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
