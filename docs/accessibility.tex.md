# Math Accessibility Explainer

## Authors
 * Sam Dooley
 * Neil Soiffer

## Abstract
[MathML 3](https://www.w3.org/TR/MathML3/) is a W3C recommendation for including mathematical expressions in Web pages. MathML has two parts: presentation MathML that describes how the math looks and content MathML that describes the meaning of the math. Presentation is by far the most commonly used part of MathML and is the focus of this document. Assuming they know the subject matter, a person reading math notation typically can understand its meaning. Although it is occasionally ambiguous, context resolves the ambiguity. One goal of MathML 4 is to allow authors provide context as part of the MathML to resolve the ambiguity.

Math accessibility has significant differences from text accessibility because math notation is a shorthand for its meaning. The words spoken for it differ from the braille that would be used for it. Furthermore, the words that are spoken need to differ based on the reader’s disabilities and familiarity of the content. Hence, enough information from MathML should be given to the assistive technology of a user so that it can generate a meaningful presentation of the math to the user. 

## Table of Contents

## Math Accessibility Background
The following are reasons why math accessibility is different from text accessibility. Details are in the next section:

* Mathematical expressions encode concepts, not words. The same concept can be spoken in many different ways. With the exception of abbreviations and a few words (e.g, “read”), words are always read the same.

* The words that should be used need to be tailored to the disability. For people who cannot see the mathematical expression, the 2D structure of math needs to be disambiguated. This can be done with words, sounds, or prosody changes (e.g., pitch or rate). For those who can see the math, such unfamiliar sounds or words make understanding more difficult.  
* Most braille systems encode the syntax of math, not the words used to speak to speak math.
* The notations and tokens taken together determine how the math is spoken. For example, the ‘4’ in $x^4$ might be spoken as a cardinal number (“x to the fourth power”) but the ‘2’ in $x^2$ is spoken as “squared” (“x squared”).
* Depending on context, the same notation may have different meanings. For example, “(1, 5)” could be a point in the plane or it could be the numbers from 1 to 5, exclusive of 1 and 5. Although it could be spoken syntactically (“open paren 1 comma 2 close paren”), people don’t typically say those words when speaking it. Instead they speak the meaning and listeners tend to prefer to hear math spoken by AT the way a teacher or other people typically say it.
* As one becomes more experienced with a notation, the words used to speak the notation might change. Examples are given below.


## Goals

## Non-Goals


## Background: MathML

### Presentation MathML
Brief explanation of presentation MathML.
Show an example.


### Content MathML
Brief explanation of content MathML and parallel markup.
Show an example.

Not used much.


### Examples of speech
$x^n$, special cases for $x^2$ and $x^3$ are common

$sin^{-1} x$ -- also usually specially cased

$\frac{1}{2}$ -- special cased?

$\frac{3}{111}$

### Examples of ambiguity
$(1,5)$

$M^T$

Binomial Coefficient: $\binom{n}{k}$

The MathML spec suggests using a fraction with `linethickness="0"` for encoding the binomial coefficient (this is what TeX does). Here is the MathML for that:
```
<mrow>
    <mo>(</mo>
      <mfrac linethickness="0">
        <mi>r</mi>
        <mi>k</mi>
      </mfrac>
    <mo>)</mo>
</mrow>
```
However, many WYSIWYG editors don't have this construct and so a 2x1 matrix is often used instead. This is encoded as:
```
<mrow>
    <mtable>
        <mtr>
            <mtd><mi>n</mi></mtd>
        </mtr>
        <mtr>
            <mtd><mi>k</mi></mtd>
        </mtr>
    </mtable>
</mrow>
```
Visually, there is a slight different in their display, but the difference is small enough that most people probably would not notice it.

The later encoding is ambiguous in that it can also be a 2x1 matrix/vector.

In addition to be two ways to encode this, the binomial coefficient is also sometimes represented as $C_k^n$.


## Ideas

### "subject" attribute

### "mathrole" attribute
