---
title: "Intent Annotation Comparison"
---

<style>
.container-lg {max-width:100%;  font-size:100%;}
/* th:nth-child(3), td:nth-child(3) { display: none; } */
/* th:nth-child(5), td:nth-child(5) { display: none; } */
</style>

*Authors*:  Neil Soiffer, Bruce Miller, Deyan Ginev, Sam Dooley

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
## Side-by-Side Comparison Between Proposals
This table extracts the examples from the various proposals.
The proposals have many similarities.
Putting them side by side hopefully makes it easier to compare the differences.
 

{::nomarkdown}
<table>
<thead><tr><th>Notation</th><th>Description</th><th>Bruce/Deyan</th><th>Neil arg</th><th>Neil position</th><th>Sam</th></tr></thead>
<tbody>

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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="plus-minus(@arg1,@arg2,@op2,@arg3,@arg4,@arg5)">
  <mi arg="arg1">a</mi>
  <mo arg="op1">+</mo>
  <mi arg="arg2">b</mi>
  <mo arg="op2">-</mo>
  <mi arg="arg3">c</mi>
  <mo arg="arg4">+</mo>
  <mi arg="arg5">d</mi>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="plus-minus(@*)">
  <mi>a</mi>
  <mo>+</mo>
  <mi>b</mi>
  <mo>-</mo>
  <mi>c</mi>
  <mo>+</mo>
  <mi>d</mi>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="plus">
  <mi arg="1">a</mi>
  <mo arg="0">+</mo>
  <mrow intent="minus" arg="2">
    <mi arg="1">b</mi>
    <mo arg="0">-</mo>
    <mi arg="2">c</mi>
  </mrow>
  <mo arg="0">+</mo>
  <mi arg="3">d</mi>
</mrow>
```
{::nomarkdown}
</td></tr>

<tr><td>  </td><td> inner product $\mathbf{a}\cdot\mathbf{b}$ </td>
<td>
{:/nomarkdown}
```
<mrow intent="@op(@arg1,@arg2)">
  <mi arg="arg1" mathvariant="bold">a</mi>
  <mo arg="op" intent="inner-product>&@x22C5;</mo>
  <mi arg="arg2" mathvariant="bold">b</mi>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="inner-product(@arg1,@op,@arg2)">
  <mi arg="arg1" mathvariant="bold">a</mi>
  <mo arg="op">&@x22C5;</mo>
  <mi arg="arg2" mathvariant="bold">b</mi>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="inner-product(@*)">
  <mi mathvariant="bold">a</mi>
  <mo>&@x22C5;</mo>
  <mi mathvariant="bold">b</mi>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="inner-product">
  <mi arg="1" mathvariant="bold">a</mi>
  <mo arg="0">&@x22c5;</mo>
  <mi arg="2" mathvariant="bold">b</mi>
</mrow>
```
{::nomarkdown}
</td>
</tr>

<tr><td> prefix </td><td> negation $-a$ </td>
<td>
{:/nomarkdown}
```
<mrow intent="@op(@arg)">
  <mo arg="op" intent="unary-minus">-</mo>
  <mi arg="arg">a</mi>`
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="unary-minus(@op, @arg)">
  <mo arg="op">-</mo>
  <mi arg="arg">a</mi>`
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="unary-minus(@*)">
  <mo>-</mo>
  <mi>a</mi>`
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="minus">
  <mo arg="0">-</mo>
  <mi arg="1">a</mi>
</mrow>
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> Laplacian $\nabla^2 f$ </td>
<td>
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="laplacian(@op, @arg)">
  <msup arg="op">
    <mi>&@x2207;</mi>
    <mn>2</mn>
  </msup>
  <mi arg="arg">f</mi>`
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="laplacian(@*)">
  <msup>
    <mi>&@x2207;</mi>
    <mn>2</mn>
  </msup>
  <mi>f</mi>`
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="laplacian">
  <msup arg="0">
    <mi>&@x2207;</mi>
    <mn>2</mn>
  </msup>
  <mo>&@x2061;</mo>
  <mi arg="1">f</mi>
</mrow>
```
{::nomarkdown}
</td>
</tr>

<tr><td> postfix </td><td> factorial $n!$ </td>
<td>
{:/nomarkdown}
```
<mrow intent="@op(@arg)">
  <mi arg="arg">a</mi>
  <mo arg="op" intent="factorial">!</mo>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="factorial(@arg, @op)">
  <mi arg="arg">a</mi>
  <mo arg="op" intent="factorial">!</mo>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="factorial(@*)">
  <mi>a</mi>
  <mo>!</mo>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="factorial">
  <mi arg="1">n</mi>
  <mo arg="0">!</mo>
</mrow>
```
{::nomarkdown}
</td>
</tr>

<tr><td> sup </td><td> power $x^n$ </td>
<td>
{:/nomarkdown}
```
<msup intent="power(@base,@exp)">
  <mi arg="base">x</mi>
  <mi arg="exp">n</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="power(@base,@exp)">
  <mi arg="base">x</mi>
  <mi arg="exp">n</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="power(@*)">
  <mi>x</mi>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="power">
  <mi arg="1">x</mi>
  <mi arg="2">n</mi>
</msup>
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> repeated application <br/> $f^n$ ($=f(f(...f))$)</td>
<td>
{:/nomarkdown}
```
<msup intent="applicative-power(@op,$n)">
  <mi arg="op">f</mi>
  <mi arg="n">n</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="applicative-power(@op,@n)">
  <mi arg="op">f</mi>
  <mi arg="n">n</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="applicative-power(@*)">
  <mi>f</mi>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="applicative-power">
  <mi arg="1">f</mi>
  <mi arg="2">n</mi>
</msup>
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> inverse $\sin^{-1}$ </td>
<td>
{:/nomarkdown}
```
<msup intent="applicative-power(@op,@n)">
  <mi arg="op">sin</mi>
  <mn arg="n">-1</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="applicative-power(@op,@n)">
  <mi arg="op">sin</mi>
  <mn arg="n">-1</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="applicative-power(@*)">
  <mi>sin</mi>
  <mn>-1</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="arcsin">
  <msup arg="0">
    <mi>sin</mi>
    <mrow>
      <mo>-</mo>
      <mn>1</mn>
    </mrow>
  </msup>
  <mo>&@x2061;</mo>
  <mi arg="1">x</mi>
</mrow>
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> $n$-th derivative $f^{(n)}$ </td>
<td>
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
</td>
<td>
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
</td>
<td>
{:/nomarkdown}
```
<msup intent="derivative-implicit-variable(@1,@2@1)">
  <mi>f</mi>
  <mrow>
    <mo>(</mo>
    <mi>n</mi>
    <mo>)</mo>
  </mrow>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="derivative-implicit-variable">
  <mi arg="1">f</mi>
  <mrow>
    <mo>(</mo>
    <mi arg="2">n</mi>
    <mo>)</mo>
  </mrow>
</msup>
```
{::nomarkdown}
</td>
</tr>

<tr><td> sub </td><td> indexing $a_i$ </td>
<td>
{:/nomarkdown}
```
<msup intent="index(@array,@index)">
  <mi arg="array">a</mi>
  <mi arg="index">i</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="index(@array,@index)">
  <mi arg="array">a</mi>
  <mi arg="index">i</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="index(@*)">
  <mi>a</mi>
  <mi>i</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msub intent="index">
  <mi arg="1">a</mi>
  <mi arg="2">i</mi>
</msub>
```
{::nomarkdown}
</td>
</tr>

<tr><td> sup-operator </td><td> transpose $A^T$ </td>
<td>
{:/nomarkdown}
```
<msup intent="@op(@x)">
  <mi arg="x">A</mi>
  <mi arg="op" intent="transpose">T</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
For speech, we need two different transpose functions ("A transpose" vs "transpose of A for T(A)") or the speech needs to find the "operator" and deduce the form from that.
```
<msup intent="transpose(@x, @op)">
  <mi arg="x">A</mi>
  <mi arg="op">T</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="transpose(@*)">
  <mi>A</mi>
  <mi>T</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

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
<td>
</td>
<td>
</td>
<td>
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
<td>
</td>
<td>
</td>
<td>
</td>
</tr>


<tr><td> </td><td> adjoint $A^\dagger$ </td>
<td>
{:/nomarkdown}
```
<msup intent="@op(@x)">
  <mi arg="x">A</mi>
  <mi arg="op" intent="adjoint">&dagger;</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
Note: 'adjoint' needs to know the second arg is the operand. It could just as easily be the first arg if we _define_ it that way.
```
<msup intent="adjoint(@op, @x)">
  <mi arg="x">A</mi>
  <mi arg="op">&dagger;</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="adjoint(@2, @1)">
  <mi>A</mi>
  <mi>&dagger;</mn>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> $2$-nd derivative $f''$ </td>
<td>
{:/nomarkdown}
```
<msup intent="derivative-implicit-variable(@op,@n)">
  <mi arg="op">f</mi>
  <mo arg="n" intent="2">''</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="derivative-implicit-variable(@op,@n)">
  <mi arg="op">f</mi>
  <mo arg="n">''</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msup intent="derivative-implicit-variable(@*)">
  <mi>f</mi>
  <mo>''</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td>Awkward nesting</td><td> $x'_i$ </td>
<td>
{:/nomarkdown}
```
 <msubsup intent="derivative-implicit-variable(index(@array,@index))">
   <mi arg="array">x</mi>
   <mi arg="index">i</mi>
   <mo>'</mo>
  </msubsup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
 <msubsup intent="derivative-implicit-variable(index(@array,@index), @deg)">
   <mi arg="array">x</mi>
   <mi arg="index">i</mi>
   <mo arg="deg">'</mo>
  </msubsup>
```
or could be
```
 <msubsup intent="derivative-implicit-variable(index(@array,@index), '2')">
   <mi arg="array">x</mi>
   <mi arg="index">i</mi>
   <mo>'</mo>
  </msubsup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
 <msubsup intent="derivative-implicit-variable(index(@1,@2), @3)">
   <mi>x</mi>
   <mi>i</mi>
   <mo>'</mo>
  </msubsup>
```
or as above with '2'

{::nomarkdown}
</td>
</tr>

<tr><td></td><td> or maybe</td>
<td>
{:/nomarkdown}
```
 <msubsup intent="index(derivative-implicit-variable(@op),@index)">
   <mi arg="op">x</mi>
   <mi arg="index">i</mi>
   <mo>'</mo>
  </msubsup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
 <msubsup intent="index(derivative-implicit-variable(@op,@deg), @index)">
   <mi arg="op">x</mi>
   <mi arg="index">i</mi>
   <mo arg="deg">'</mo>
  </msubsup>
```
or with "@deg" being "1"

{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
 <msubsup intent="index(derivative-implicit-variable(@o1,@3), @2)">
   <mi>x</mi>
   <mi>i</mi>
   <mo>'</mo>
  </msubsup>
```
or with "@3" being "1"

{::nomarkdown}
</td>
</tr>

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
<td>
{:/nomarkdown}
```
 <msub intent="midpoint(index(@line,@index))">
    <mover accent="true">
      <mi arg="line">x</mi>
      <mo arg="op">¯</mo>
    </mover>
    <mi arg="index">i</mi>
  </msub>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
 <msub intent="midpoint(index(@1@,@2),@1@2)">
    <mover accent="true">
      <mi arg="line">x</mi>
      <mo arg="op">¯</mo>
    </mover>
    <mi arg="index">i</mi>
  </msub>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
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
<td>
</td>
<td>
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> base-operator </td><td> binomial $C^n_m$ </td>
<td>
{:/nomarkdown}
```
<msubsup intent="@op(@n,@m)">
  <mi arg="op" intent="binomial">C</mi>
  <mi arg="m">m</mi>
  <mi arg="n">n</mi>
</msubsup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msubsup intent="binomial(@n,@m)">
  <mi arg="op">C</mi>
  <mi arg="m">m</mi>
  <mi arg="n">n</mi>
</msubsup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<msubsup intent="binomial(#3,#2)">
  <mi arg="op">C</mi>
  <mi arg="m">m</mi>
  <mi arg="n">n</mi>
</msubsup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

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
<tr><td> fenced </td><td> absolute value $|x|$ </td>
<td>
{:/nomarkdown}
```
<mrow intent="absolute-value(@x)">
  <mo>|</mo>
  <mi arg="x">x</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
```
<mrow intent="absolute-value(@open, @x, @close)">
  <mo arg="open">|</mo>
  <mi arg="x">x</mi>
  <mo arg="close">|</mo>
</msup>
```
{::nomarkdown}
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
```
<mrow intent="absolute-value(@*)">
  <mo>|</mo>
  <mix</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> norm $|\mathbf{x}|$ </td>
<td>
{:/nomarkdown}
```
<mrow intent="norm(@x)">
  <mo>|</mo>
  <mi arg="x"> mathvariant="bold"x</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
```
<mrow intent="norm(@open, @x, @close)">
  <mo arg="open">|</mo>
  <mi arg="x">x</mi>
  <mo arg="close">|</mo>
</msup>
```
{::nomarkdown}
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
```
<mrow intent="norm(@*)">
  <mo>|</mo>
  <mix</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> determinant $|\mathbf{X}|$ </td>
<td>
{:/nomarkdown}
```
<mrow intent="determinant(@x)">
  <mo>|</mo>
  <mi arg="x" mathvariant="bold">X</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
```
<mrow intent="determinant(@open, @x, @close)">
  <mo arg="open">|</mo>
  <mi arg="x">x</mi>
  <mo arg="close">|</mo>
</msup>
```
{::nomarkdown}
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
```
<mrow intent="determinant(@*)">
  <mo>|</mo>
  <mix</mi>
  <mo>|</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> sequence $\lbrace a_n\rbrace$ </td>
<td>
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
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
```
<mrow intent="sequence(@open,@arg,@close)">
  <mo arg="open">{</mo>
  <msub intent="index(@base,@index)" arg="arg">
    <mi arg="base">x</mi>
    <mi arg="index">n</mi>
  </msub>
  <mo arg="close">}</mo>
</msup>
```
{::nomarkdown}
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
```
<mrow intent="sequence(@*)">
  <mo arg="open">{</mo>
  <msub intent="index(@*)" arg="arg">
    <mi arg="base">x</mi>
    <mi arg="index">n</mi>
  </msub>
  <mo arg="close">}</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> open interval $(a,b)$ </td>
<td>
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="open-interval(@open,@a,@sep,@b,@close)">
  <mo arg="open">(</mo>
  <mi arg="a">a</mi>
  <mo arg="sep">,</mo>
  <mi arg="b">b</mi>
  <mo arg="close">)</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="open-interval(@*)">
  <mo>(</mo>
  <mi>a</mi>
  <mo>,</mo>
  <mi>b</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> open interval $]a,b[$ </td>
<td>
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="open-interval(@open,@a,@sep,@b,@close)">
  <mo arg="open">(</mo>
  <mi arg="a">a</mi>
  <mo arg="sep">,</mo>
  <mi arg="b">b</mi>
  <mo arg="close">)</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="open-interval(@*)">
  <mo>(</mo>
  <mi>a</mi>
  <mo>,</mo>
  <mi>b</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td/><td colspan="2">closed, open-closed, etc. similarly</td></tr>

<tr><td> </td><td> inner product $\left<\mathbf{a},\mathbf{b}\right>$</td>
<td>
{:/nomarkdown}
```
<mrow intent="inner-product(@a,@b)">
  <mo>&lt;</mo>
  <mi arg="a" mathvariant="bold">a</mi>
  <mo>,</mo>
  <mi arg="b" mathvariant="bold">b</mi>
  <mo>&lt;</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="inner-product(@open,@a,@sep,@b,@close)">
  <mo arg="open">&lt;</mo>
  <mi arg="a">a</mi>
  <mo arg="sep">,</mo>
  <mi arg="b">b</mi>
  <mo arg="close">&lt;</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="inner-product(@*)">
  <mo>&lt;</mo>
  <mi>a</mi>
  <mo>,</mo>
  <mi>b</mi>
  <mo>&lt;</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> Legendre symbol $(n|p)$</td>
<td>
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="Legendre-symbol(@open,@a,@sep,@b,@close)">
  <mo arg="open">(</mo>
  <mi arg="a">a</mi>
  <mo arg="sep">  <mo>|</mo>
</mo>
  <mi arg="b">b</mi>
  <mo arg="close">)</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="Legendre-symbol(@*)">
  <mo>(</mo>
  <mi>a</mi>
  <mo>|</mo>
  <mi>b</mi>
  <mo>)</mo>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

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
</td>
<td>
<p>Looking at the Wikipedia page on these, I think you need to know where the "|" is, so that 'intent' doesn't seem right. On the other hand, all I know about Clebsch-Gordan is from two minutes of reading that page...</p>
</td>
<td></td>
</tr>

<tr><td>fenced-sub </td><td> Pochhammer $\left(a\right)_n$ </td>
<td>
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
</td>
<td>
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
</td>
<td>
{:/nomarkdown}
```
<msup intent="Pochhammer(@1@2,@2)">
  <mrow>
    <mo>(</mo>
    <mi>a</mi>
    <mo>)</mo>
  </mrow>
  <mi>n</mi>
</msup>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td>fenced-stacked </td><td> binomial $\binom{n}{m}$ </td>
<td>
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
</td>
<td>
{:/nomarkdown}
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="binomial(@2@1,@2@2)">
  <mo>(</mo>
  <mfrac thickness="0pt">
    <mi>n</mi>
    <mi>m</mi>
  </mfrac>
  <mo>)</mo>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td> </td><td> multinomial $\binom{n}{m_1,m_2,m_3}$ </td>
<td>
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
</td>
<td>
{:/nomarkdown}
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="multinomial(@2@1,@2@2@1,@2@2@2,@2@2@3)">
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
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td/><td/><td>??? punctuation separates the several arguments?</td></tr>

<tr><td> </td><td> Eulerian numbers $\left< n \atop k \right>$ </td>
<td>
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
</td>
<td>
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="Eulerian-numbers(@2@1,@2@1)">
  <mo>&lt;</mo>
  <mfrac thickness="0pt">
    <mi arg="n">n</mi>
    <mi arg="k">k</mi>
  </mfrac>
  <mo>&gt;</mo>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

<tr><td>fenced-table</td><td> 3j symbol<br/> $\left(\begin{array}{ccc}j_1& j_2 &j_3 \\ m_1 &m_2 &m_3\end{array}\right)$</td>
<td>
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
</td>
<td>
{:/nomarkdown}
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="3j(@2/@1/@1,@2/@1/@2,@2/@1/@3,@2/@2/@1,@2/@2/@2,@2/@2/@3)">
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
</td>
</tr>

<tr><td/><td>6j, 9j, ...</td><td>similarly</td></tr>

<tr><td>functions</td><td> function $A(a,b;z|q)$</td>
<td>
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
  <mo>)</mo>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="function(@open,@p1,@comma,@p2,@semi,@a1,@bar,@q,@close)">
  <mi arg="op">A</mi>
  <mo arg="open">(</mo>
  <mi arg="p1">a</mi>
  <mo arg="comma">,</mo>
  <mi arg="p2">b</mi>
  <mo arg="semi">;</mo>
  <mi arg="a1">z</mi>
  <mo arg="bar">|</mo>
  <mi arg="q">q</mi>
  <mo arg="close">)</mo>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
<mrow intent="function(@*)">
  <mi>A</mi>
  <mo>(</mo>
  <mi>a</mi>
  <mo>,</mo>
  <mi>b</mi>
  <mo>;</mo>
  <mi>z</mi>
  <mo>|</mo>
  <mi>q</mi>
  <mo>)</mo>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
```
```
{::nomarkdown}
</td>
</tr>

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

<tr><td>derivatives</td><td> $\frac{d^2f}{dx^2}$</td>
<td>
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
</td>
<td style="background-color: lightyellow;">
{:/nomarkdown}
Need to distinguish between $\frac{d^2f}{dx^2}$ and $\frac{d^2}{dx^2}f$ in speech ("d squared f, d x squared" vs "d squared, d x squared, [of?] f").

Note also that $dx^2$ might be marked up as `{dx}^2` which is technically correct, but will more likely be marked up as `d x^2` (i.e, `d {x^2}`)

This solution goes back to the basics of Liebnitz's notation: $\frac{d}{dx}$. This is an operator and a second degree derivative is $\frac{d}{dx} (\frac{d}{dx})$, also an operator. From these we get shorthands $\frac{df}{dx}$ and $\frac{d^2}{dx^2}$. Without the shorthand, we have `function( power(deriv(dNum, dDenom(var)), degree), func)`. This doesn't extend well to partial derivatives where the degree is potentially spread among different variables. That leads to associating the power with each $d$ to get `function( deriv(power(dNum, degree), power(dDenom(var), degree)), func)`. Although power is not technically correct, it corresponds to the way it is spoken. To handle the shorthand where the function is part of the numerator, I add a three argument version of `Leibnitz-derivative`. Also, rather than having `diffD-numerator` and `diffD-denominator`, I have two and three arg versions of just `diffD`.

With that rationale, here are two markups.
The first has the function in the numerator and the denominator shows MathML for $dx^2$:
```
<mfrac intent="Leibnitz-derivative(@diff-op,@diff-var,@func)">
    <msup arg="diff-op" notation="diffD(@d, @deg)">
      <mo arg="d">d</mo>
      <mn arg="deg">2</mn>
    </msup>
    <mi arg="func">f</mix>
  </mrow>
  <mrow arg="diff-var" intent="diffD(@d, @deg, @var)">
    <mo arg="d">d</mo>
    <msup>
      <mi arg="var">x</mix>
      <mn arg="deg">2</mn>
    </msup>
  </mrow>
</mfrac>
```
The second expr has the $f$ outside the fraction and the denominator shows MathML for $(dx)^2$:
```
<mrow intent="function(@diff-op, @func)">
  <mfrac arg="diff-op" intent="Leibnitz-derivative(@diff-op,@diff-var)">
    <msup arg="diff-op" intent="diffD(@d, @deg)">
      <mo arg="d">d</mo>
      <mn arg="deg">2</mn>
    </msup>
    <msup arg="diff-var" intent="diffD(@d, @deg, @var)">
      <mrow>
        <mo arg="d">d</mo>
        <mi arg="var">x</mix>
      </mrow>
      <mn arg="deg">2</mn>
    </msup>
  </mfrac>
  <mi arg="func">f</mix>
</mrow>
```
These forms are unambiguous and relatively easy to convert to Content MathML and to speech that distinguishes the two forms.

{::nomarkdown}
</td>
</tr>

<tr><td>integrals</td><td> $\int\frac{dr}{r}$</td>
<td>
{:/nomarkdown}
One might be tempted put intent="divide(1,@r)" on the mfrac, but this blocks access to @bvar
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
</td>
<td>
{:/nomarkdown}
This requires converters that want to find the bound variable to look for intent="diffD(...)",
replace that by '1', and take the second arg of the 'diffD' as the bound variable.
Another option would be to have intent="integral(@op, @integrand, @bvar)" or maybe point to the 'diffD' to make the bound var obvious.
```
<mrow intent="integral(@op, @integrand)">
  <mo arg="op"</mo>
  <mfrac arg="integrand" intent="divide">
    <mrow intent="diffD(@d, "1", @bvar)">
      <mi arg="d">d</mi>
      <mi arg="bvar">r</mi>
    </mrow>
    <mi arg="r">r</mi>
  </mfrac>
</mrow>
```
{::nomarkdown}
</td>
</tr>

<tr><td>continued fractions</td><td> $a_0+\displaystyle\frac{1}{a_1+\displaystyle\frac{1}{a_2+\cdots}}$</td>
<td>
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
</td>
<td>
{:/nomarkdown}
```
<mrow intent="infinite-continued-fraction(@a0,@p0,@b0,@a1,@p1,@b2,@a2,@p2,@ddd)">
  <msub notation="index(@b, @i)" arg="a0">
    <mi arg="b">a</mi>
    <mn arg="i">0</mn>
  </msub>
  <mo arg="p0">+</mo>
  <mstyle display="true">
    <mfrac>
      <mn arg="b1">1</mn>
      <mrow>
        <msub notation="index(@b, @i)" arg="a1">
          <mi arg="b">a</mi>
          <mn arg="i">1</mn>
        </msub>
        <mo arg="p1">+</mo>
        <mstyle display="true">
          <mfrac>
            <mn arg="b2">1</mn>
            <mrow>
              <msub notation="index(@b, @i)" arg="a2">
                <mi arg="b">a</mi>
                <mn arg="i">2</mn>
              </msub>
              <mo arg="p2">+</mo>
              <mo arg="ddd">&#22EF;</mo>
            </mrow>
          </mfrac>
        </mstyle>
      </mrow>
    </mfrac>
  </mstyle>
</mrow>
```
{::nomarkdown}
</td>
<td>
{:/nomarkdown}
Need to decide if mstyle/mpadded/singleton mrow are ignored. Assuming yes...
```
<mrow intent="infinite-continued-fraction(@1,@2,@3@1,@3@2@1,@3@2@2,@3@2@3@1,@3@2@3@2@1,@3@2@3@2@2,@3@2@3@2@3)">
  <msub><mi>a</mi><mn>0</mn></msub>
  <mo>+</mo>
  <mstyle display="true">
    <mfrac>
      <mn>1</mn>
      <mrow>
        <msub><mi>a</mi><mn>1</mn></msub>
        <mo>+</mo>
        <mstyle display="true">
          <mfrac>
            <mn>1</mn>
            <mrow>
              <msub><mi>a</mi><mn>2</mn></msub>
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
</td>
</tr>

</tbody>
</table>
{:/nomarkdown}

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->

## Summary
The main differences appear to be:
* the location of the name of the function
* more substantively, the first proposal abstracts away the presentation, the second one preserves it and requires converters to know the syntax of the function (e.g, "factorial" is a postfix function, therefore the operand they care about is the first argument)

Abstracting away the presentation means speech can't use intent alone because it matters. E.g, $a/b$, $a \div b$, and $\frac{a}{b}$ want to be spoken differently, but they would all have the same intent value. This happens in many other cases.

<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
