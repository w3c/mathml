
## Authors
 * Sam Dooley
 * Neil Soiffer

## Abstract
[MathML 3](https://www.w3.org/TR/MathML3/) is a W3C recommendation for including mathematical expressions in Web pages. MathML has two parts: presentation MathML that describes how the math looks and content MathML that describes the meaning of the math. Presentation is by far the most commonly used part of MathML and is the focus of this document. Assuming they know the subject matter, a person reading math notation typically can understand its meaning. Although it is occasionally ambiguous, context resolves the ambiguity. One goal of MathML 4 is to allow authors provide context as part of the MathML to resolve the ambiguity.

Math accessibility has significant differences from text accessibility because math notation is a shorthand for its meaning. The words spoken for it differ from the braille that would be used for it. Furthermore, the words that are spoken need to differ based on the reader’s disabilities and familiarity of the content. Hence, enough information from MathML should be given to the assistive technology of a user so that it can generate a meaningful presentation of the math to the user. 

## Table of Contents

## Math Accessibility Background
The following are reasons why math accessibility is different from text accessibility. Details are in the next section:

* Mathematical expressions encode concepts, not words. The same concept can be spoken in many different ways. With the exception of abbreviations and a few words (e.g, “*read*”), words are always *read* the same.

* The words that should be used need to be tailored to the disability. For people who cannot see the mathematical expression, the 2D structure of math needs to be disambiguated. This can be done with words, sounds, or prosody changes (e.g., pitch or rate). For those who can see the math, such unfamiliar sounds or words make understanding more difficult.  
* Most braille systems encode the syntax of math, not the words used to speak to speak math.
* The notations and tokens taken together determine how the math is spoken. For example, the ‘4’ in <img src="/docs/tex/4199db0b0356e8ace7a77ef6b7477bab.svg?invert_in_darkmode&sanitize=true" align=middle width=15.94753544999999pt height=26.76175259999998pt/> might be spoken as a cardinal number (“x to the fourth power”) but the ‘2’ in <img src="/docs/tex/6177db6fc70d94fdb9dbe1907695fce6.svg?invert_in_darkmode&sanitize=true" align=middle width=15.94753544999999pt height=26.76175259999998pt/> is spoken as “squared” (“x squared”).
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
<img src="/docs/tex/ef4740140c8741b5abffcf442f79c1c7.svg?invert_in_darkmode&sanitize=true" align=middle width=17.521011749999992pt height=21.839370299999988pt/> may be spoken as "x raised to the nth power". However, this pattern is not always followed for powers.
There are often special cases that people speak differently.
<img src="/docs/tex/6177db6fc70d94fdb9dbe1907695fce6.svg?invert_in_darkmode&sanitize=true" align=middle width=15.94753544999999pt height=26.76175259999998pt/> ("x squared") and <img src="/docs/tex/3c63d4517a41fc372162eaa29bc7d970.svg?invert_in_darkmode&sanitize=true" align=middle width=15.94753544999999pt height=26.76175259999998pt/> ("x cubed") are two such examples.

<img src="/docs/tex/863019f4cc45632fc74617cee3eff54f.svg?invert_in_darkmode&sanitize=true" align=middle width=50.279027699999986pt height=26.76175259999998pt/> is also usually specially cased ("inverse sine of x" vs "sine raised to the negative one power of x")

Some small numeric fractions are special cased <img src="/docs/tex/47d54de4e337a06266c0e1d22c9b417b.svg?invert_in_darkmode&sanitize=true" align=middle width=6.552545999999997pt height=27.77565449999998pt/> ("one half") but not this similar numeric fraction <img src="/docs/tex/a9e181dc572cb3ed023e845d7844e89e.svg?invert_in_darkmode&sanitize=true" align=middle width=19.657639649999997pt height=27.77565449999998pt/> ("start fraction 3 over 111 end fraction").

### Examples of ambiguity
#### <img src="/docs/tex/117d5fafc41a6d9edd6fdbfec19eb2a7.svg?invert_in_darkmode&sanitize=true" align=middle width=36.52973609999999pt height=24.65753399999998pt/>

#### <img src="/docs/tex/aa6187664247ff6929af116a80a61803.svg?invert_in_darkmode&sanitize=true" align=middle width=27.27343409999999pt height=27.6567522pt/>

#### Binomial Coefficient: <img src="/docs/tex/8afda0bcf2f9f7e7008eadbe487e90f6.svg?invert_in_darkmode&sanitize=true" align=middle width=23.194596149999988pt height=27.94539330000001pt/>

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

In addition to be two ways to encode this, the binomial coefficient is also sometimes represented as <img src="/docs/tex/2a6f37b6b81ea5c439d6f551a63ec936.svg?invert_in_darkmode&sanitize=true" align=middle width=21.05066039999999pt height=22.465723500000017pt/>.

#### Chemistry
Chemical formulas are often marked up using math editors. The chemical elements are one source of ambiguity, but all the notation around them, including bonds, are other sources of ambiguity
<p align="center"><img src="/docs/tex/c7e6aa29086880ef36e9c468938d8411.svg?invert_in_darkmode&sanitize=true" align=middle width=163.6394661pt height=38.83491479999999pt/></p>
## Ideas for Resolving Ambiguity

### "subject" attribute

### "mathrole" attribute
