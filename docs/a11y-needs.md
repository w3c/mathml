---
title: "What Math Accessibility Needs"
layout: cgreport
---

*Author*: Neil Soiffer

# Why???
In discussion with some members of the CG, it became clear that they wanted to know about what is the minimal information accessibility needs added to MathML to speak math well, especially in the cases where it is not some default interpretation. Hopefully this short document will answer some of the questions. It also introduces some thoughts on what accessibility needs when it has no clue on how to speak an expression with some special (unknown to AT) meaning. These might be items that Deyan identified as [level 3](https://docs.google.com/spreadsheets/d/1EsWou1K5nxBdLPvQapdoA9h-s8lg_qjn8fJH64g9izQ/edit#gid=2052584722).

# The Easy Stuff
For many common linear expression, AT just reads the text and life is good. Some examples
* $a + b$
* $2xy$ -- maybe want to add "times" in some cases such as $2 (x+y)$
* $\sin(x+y)$ -- want to pronounce "sin" as "sine" and may want to add "of"
* $n!$ -- here "!" has the pronunciation "factorial", but it could be "not" if used in a prefix context.

In general, AT wants to read the content in the order it is presented. There are some exceptions such as '\$2' and a level 3 $\lozenge x$ (“x is positive”), but these exceptions are rare.

Some common notations are spoken in different ways depending on the arguments. Assuming superscripts are powers (more on that assumption later), here are some cases and how they might be spoken:
* $x^{m+n}$ -- "x to the m plus n power"
* $x^2$ -- "x squared": a simple special case
* $x^5$ -- "x to the fifth power": "small" numbers are spoken as ordinals
* $(n+1)^x^4+1$ -- "open paren n plus 1 close paren super x super super 4 baseline plus 1" -- MathSpeak style of speech indicating nesting level of an exponent.

These all are powers but have different ways of being spoken, so even if we add `intent`, AT needs to do some pattern matching on the MathML to generate good speech.

An important point these examples make is that there is no "right" way to speak a math expression. What is said depends upon many factors such as disability, familiarity with the subject matter, and what one wants to gain from "reading" the expression. Another important point is that there are no studies showing that a semantic reading is "better" (for some measure of "better") than a syntactic one. However, anecdotal evidence strongly points to students preferring a semantic reading as that more closely follows what they hear in the classroom. However, Braille (and hence, MathSpeak in its pure form) is syntactic.

Although it is tempting to say that "msup" should always be a power, there are some very common cases where it is not:
* $\sin^{-1}x$ -- inverse
* $f \prime(x)$ -- derivative

It is clear (to most readers) that these are not intended to be powers; if they actually are intended to be powers, then `intent` should be used. They are easy to match for AT and a blanket 'superscripts are always powers' would mean a lot of math is misread without specifying author intent. The key thing for AT is that these cases be called as needed special cases.

# Lend AT a Hand
In the CG, we have spent a lot of time discussing a way to allow authors to express their intent. In the above, I am assuming that without any outside guidance, superscripts are interpreted as "power" with some exceptions. But if the author wants to be absolutely clear, they could use the notation we have been developing. For example:
* $x^2$ -- `<msup intent="power(@base,@exp)">...`
* $f \prime(x)$ -- `<msup intent="derivative-implicit-variable(@op,@n)">...` where the n=$'$ has `intent`=1

The only part of this AT really needs is the function name ("power", "derivative-implicit-variable"). As long as those names are documented with their meaning, AT can map those to patterns/words to speak.

We have discussed "transpose" a lot. To give a sense of where the state of the art for AT is at, none of the math-to-speech systems have rules to speak $A^T$ as transpose. For usual cases, it is no harder to match than $x^2$, but should the following be read as "... transpose": $i^T$, $3^T$, $\sqrt{x}^T$. So maybe the base needs to be a matrix or capital letter for the default to kick in. That would exclude something that is probably in every linear algebra book though: $A^T^T = A$.

Transpose is also written as $T(A)$ and $\textrm{Transpose} (A)$. These three forms can be marked up as:
* $A^T$ -- `<msup intent="transpose($base)">...`
* $T(A)$ -- `<mrow intent="transpose($func-arg)">...`
* $Transpose(A)$ -- `<mrow intent="transpose($func-arg)">...`

In discussions, figuring out how to handle integrals, especially those where the variable of integration is not at the end of the integral (e.g., in the numerator of a fraction) has proved challenging. However, for speech, integrals and other large operators are easy to recognize and as long as "d x" is an acceptable form of speech (as opposed to "with respect to x"), then locating/singling out the variable of integration is not important.

Differentiation on the other hand is much more challenging to recognize because the $d$ and the $dx$ can be scattered throughout an expression. Also, there are several different derivative notations including partial derivatives using subscripts (e.g., $\partial_x$), and the speech generated for each form likely differs. An `intent` value that differs for the different notations would be helpful to AT. For example:
* $\frac{d}{dx} \sin x$
```
    <mrow intent="$op($1,x)">
    <mfrac arg="op" intent="Leibnitz-derivative">
        <mo>&#x2146;</mo>
        <mrow>
        <mo>&#x2146;</mo>
        <mi>x</mi>
        </mrow>
    </mfrac>
    ...
```
* $f^{(n)}(e^{ax})$
```
    <mrow>
        <msup intent="derivative-implicit-variable(@op,@n)">
        <mi arg="op">f</mi>
        <mrow>
            <mo>(</mo>
            <mi arg="n">n</mi>
            <mo>)</mo>
        </mrow>
        </msup>
```
and so on. AT really just cares about the values "Leibnitz-derivative" and "derivative-implicit-variable". In the first case, AT needs to indirectly find the value of `intent`, so this iteration of `intent` is more complicated for AT. For example, SRE uses xpath to do the pattern match. Doing the pattern match for "@intent" (and then truncating at the open paren) is relatively easy. I suspect a built in function would be required to deal with the indirect reference to the `intent` value.

An overbar can mean many things in math, so `intent` is needed to resolve ambiguity. Something like $\bar{x}$ might have `intent="mean($var)"` and be easily spoken. The "awkward index" example $\bar{x}_i$ might have the markup:
```
    <msub intent="@op(index(@line,@index))">
        <mover accent="true">
            <mi arg="line">x</mi>
            <mo arg="op" intent="midpoint">¯</mo>
        </mover>
        <mi arg="index">i</mi>
    </msub>
  ```
This is awkward for AT both because finding that it is a midpoint pattern requires indirection, but also because it would expect that the first argument to the element marked as "midpoint" (the `msub`) would be what is spoken after "the midpoint of". If this is the only way "awkward index" can occur for midpoints, then a second pattern for this case is not a significant problem. However, if there are lots of other awkward patterns, this could be a problem.


# Exploring the Vast Unknown
Hopefully we develop a set of known values in level 1 that covers grade 4 - 14 (or whatever) textbooks and hence covers 99.99% (99.9999%?) of math expressions on the web, etc. But there is an even greater number of rarely-used notations that won't be covered. Using `intent` will work in many of the examples in level 3, but not all. Here are some cases where `intent` works if the value of `intent` is what is suppose to be spoken:
* $H \leq G$: read as "H is a subgroup of G" -- $\leq$ can be marked up with `intent`="is a subgroup of"
* $f: X \twoheadrightarrow Y$: read as "f is a surjection from X onto Y" -- the ":" can be marked up with intent="is-a-surjection-from" and the arrow marked up with intent="onto".

Although this works (assuming AT just speaks the name when it doesn't know about the name), this seems very hacky and does nothing for computability. A better solution is to make use the existing ARIA functionality that is meant to override (or provide) speech for (missing) content: [`aria-label`](https://developers.google.com/web/fundamentals/accessibility/semantics-aria/aria-labels-and-relationships). Overriding the default speech is exactly what `aria-label` is suppose to do and our spec should say that this behavior applies to its use in MathML -- this is another way we can align the spec with the rest of HTML. Using `aria-label` also allows for `intent` to be used as designed. Here's a fully marked up example using `aria-label` for another case:
* poisson-bracket: $\{f, g\}$ -- "poisson bracket of f and g"
```
<mrow intent="poisson-bracket($arg1, $arg2">
   <mo aria-label="poisson bracket of">{</mo>
   <mrow>
     <mi arg="arg1">f</mi>
     <mo aria-label="and">,<mo>
     <mi arg="arg2">g</mi>
   </mrow>
   <mo aria-label="">}</mo>
</mrow>
```
AT would not make use of `intent` -- it is included to show that this approach is consistent with the work we have done.

A majority of the level 3 notations (at least those where appropriate speech has been identified) can be handled via the use of `aria-label`. There some that require more markup:
* multiplicative-order: $O_n(a)$ -- "multiplicative order of a modulo n"
* positivity-predicate: $\lozenge x$ -- "x is positive"
* lie-derivative: $\mathcal {L}}_{X}(T)$ -- "lie derivative of T with respect to X"

Both of these examples involve switching the word order from the symbol order and so the approach of tagging some leaf elements with alternative reading cannot work.

For 2D notations like msub or mfrac, there is no content element that can carry an `aria-label` between the connective. This could be solved by putting an aria label on an outer element and adding an empty label to the descendants (`aria-label` does not stop speech for children). For example, $O_n(a)$ can be tagged as 
```
<math>
  <mrow aria-label="multiplicative order of a modulo n">
    <msub> <mi aria-label="">O</mi> <mi aria-label="">n</mi> </msub>
    <mo aria-label="">(</mo>
    <mi aria-label="">a</mi>
    <mo aria-label="">)</mo>
  </mrow>
</math>
```

This approach has significant drawbacks:
* there is no way to control speech, so the "a" in the above may be spoken with a short "a" sound ('aah') or a long "a" sound ('ey') -- the expression might be read as "multiplicative order of ahh modulo n"
* synchronized highlighting can't be supported
* users can't navigate "inside" the label, so the phrase becomes atomic

One difference between `aria-label` and using alt on a math image is that because AT knows how to render MathML to braille, the `aria-label` can be ignored and appropriate braille can be generated.

To provide the required additional info, we can add four new attributes:
* speak-before
* speak-between
* speak-after
* speak-intent

If speak-intent is given (or = "true"), then unlike all the previous examples, `intent` is used to drive the speech. Due to order reversal, the order of the arguments may not be in what is otherwise considered the natural order, but in these cases, the speech order rather than the order of presentation reflects the natural order.

In conjunction with some judiciously-placed `aria-label=""`, the three problematic cases above can be handled:
* multiplicative-order: $O_n(a)$ -- "multiplicative order of a modulo n"
```
    <math>
      <mrow intent="multiplicative-order($a, $n)"
            speak-intent="true"
            speak-before="multiplicative order of"
            speak-between="modulo">
        <msub>
            <mi>O</mi>
            <mi arg="n">n</mi>
        </msub>
        <mo>(</mo>
        <mi arg="a">a</mi>
        <mo>)</mo>
      </mrow>
    </math>
```
* positivity-predicate: $\lozenge x$ -- "x is positive"
```
    <math>
      <mrow intent="positivity-predicate($x)"
            speak-intent="true"
            speak-after="is positive"
        <mo>◊</mo>
        <mi>x</mi>
      </mrow>
    </math>
```
* lie-derivative: $\mathcal{L}}_{X}(T)$ -- "lie derivative of T with respect to X"
```
    <math>
      <mrow intent="lie-derivative($x, $t)"
            speak-intent="true"
            speak-before="lie derivative of"
            speak-between="with respect to">
        <msub>
            <mi>ℒ</mi>
            <mi arg="x">X</mi>
        </msub>
        <mo>(</mo>
        <mi arg="t">T</mi>
        <mo>)</mo>
      </mrow>
    </math>
```
This is basically the same as "multiplicative-order".

To sum up: when dealing with notations that AT doesn't know how to speak, actual words can be provided. This can be done by:
1. Using `aria-label` for many simple cases where a name needs to be provided for some symbol
2. Using `intent` and words to be sprinkled among the arguments to `intent` when `aria-label` isn't sufficient such as when word order needs to be changed.

Both solutions suffer from the long/short "a" problem and other potential pronunciation issues as there is no way to hint to the speech engine how the words should be spoken. They also suffer from potential internationalization issues: although the notations are universal, the words are not. However, at this high level of math, names used are often the same in most languages.

This proposal to use speak-xxx is just a straw man: it may suffer from significant problems or it may not solve all the problems that come up.