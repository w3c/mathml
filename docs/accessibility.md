
## Authors
 * Sam Dooley
 * Neil Soiffer

## Abstract
[MathML 3](https://www.w3.org/TR/MathML3/) is a W3C recommendation for including mathematical expressions in Web pages. MathML has two parts: presentation MathML that describes how the math looks and content MathML that describes the meaning of the math. Presentation is by far the most commonly used part of MathML and is the focus of this document. Assuming they know the subject matter, a person reading math notation typically can understand its meaning. Although it is occasionally ambiguous, context resolves the ambiguity. One goal of MathML 4 is to allow authors provide context as part of the MathML to resolve the ambiguity.

Math accessibility has significant differences from text accessibility because math notation is a shorthand for its meaning. The words spoken for it differ from the braille that would be used for it. Furthermore, the words that are spoken need to differ based on the reader’s disabilities and familiarity of the content. Hence, enough information from MathML should be given to the assistive technology of a user so that it can generate a meaningful presentation of the math to the user. 

## Table of Contents

## Why is math accessibility different from text accessibility?
The following are reasons why math accessibility is different from text accessibility. Details are in the next section:

* **Math Concepts v Text Words** Mathematical expressions encode concepts, not words. The same concept can be spoken or brailled in many different ways, and the same notation may encode different concepts. For text, with the exception of abbreviations and a few words (e.g, “*read*”), words are almost always *read* the same.
* **Spoken Math v Braille Math** For most text, both the speech and braille used to reprsent the text come directly from the words in the text.  For math, most braille systems encode the syntax of the math, which can be quite different from the words used to speak to speak the math.
* **Custom AT Needs for Math** The words that a screen reader should use need to be tailored to the disability of the user. For those who cannot see the math notation, the functional structure of math needs to be explained and/or navigated. A screen reader can communicate this information with words, sounds, or prosody changes (e.g., pitch or rate). For those who can see the math, such unfamiliar sounds or words can make understanding more difficult.
* **Math Notations v Math Instances** The notations and tokens taken together may affect how the math should be spoken. For example, the ‘4’ in <img src="/docs/tex/4199db0b0356e8ace7a77ef6b7477bab.svg?invert_in_darkmode&sanitize=true" align=middle width=15.94753544999999pt height=26.76175259999998pt/> might be spoken as a cardinal number (“x to the fourth power”) while the ‘2’ in <img src="/docs/tex/6177db6fc70d94fdb9dbe1907695fce6.svg?invert_in_darkmode&sanitize=true" align=middle width=15.94753544999999pt height=26.76175259999998pt/> is spoken as “squared” (“x squared”).

* **Overloaded Math Notations** Depending on context, the same notation may have different meanings. For example, “(1, 5)” could be a point in the plane or it could be the numbers from 1 to 5, exclusive of 1 and 5. Although it could be spoken syntactically (“open paren 1 comma 2 close paren”), listeners tend to prefer to hear the meaning of the math spoken the way a teacher or another person would typically say it.
* **Math Idioms for Expert Users** As one becomes more experienced with a notation, the words used to speak the notation might change to use idioms that are understood by those who are fluent with the underlying concepts. Examples are given below.

For these reasons, tools for accessibility require more information about math content than they do about text content to achieve the same level of support for accessibility.

## What information makes math accessible?

Almost all of the information needed to make text accessible is carried by the words in the text, and knowledge of the spoken language being used.  In the vast majority of cases, this information is enough to provide a vocalization of the text for a screen reader, and a braille encoding of the text for a tactile reader, that can easily be navigated and understood by visually impaired readers.

In contrast, because of the richness of math notation, and the varieties of ways it is used to convey math concepts, the symbols on the printed page used for math are often not enough to provide an accurate spoken reading of a formula, or a precise braille encoding, in a way that can be understood by a reader who uses accessible technology.

To make math content accessible with the same richness as the text that surrounds it, additional information about the semantics, or meaning, of the math must be provided.

## How can this information be provided to AT tools?

Tremendous progress toward math accessibility has been made by using markup languages for math such as LaTeX and MathML.  While these languages do not encode semantic information, they provide a structure within which other tools may infer enough of the math meaning to be properly understood.

In a web browser, presentation MathML now represents the most accessible alternative for encoding math.  Solutions based on LaTeX are not as fully integrated into the web technology stack, and tools based on content MathML, while they can provide the necessary semantic information, are more difficult to create, and often less natural for untrained users.

## What do we mean by semantic markup?

Since the use of Content MathML, especially in addition to Presentation MathML, involves adding more markup to an encoding that is already verbose, alternatives have been sought to minimize the amount of additional markup needed to recover the semantic interpretation of a presentational expression.  Semantic markup refers to alternative proposals to meet this need.

The markup form that has been proposed for semantic markup extends presentation MathML with a math subject attribute to carry the semantic context, and a math role attribute to carry the semantic information.  The current discussion within the W3C MathML Working Group seeks to set expectations for the use of these attributes.

### "mathsubject" attribute

### "mathrole" attribute

## Expectations for authors

## Expectations for authoring tools

## Expectations for screen readers

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

Knowing the audience for the speech is important. If someone is blind, typical speech does not distinguish where 2D structures start and end. E.g., the fraction
<p align="center"><img src="/docs/tex/1bc7176567a891933d9e60a621e033cf.svg?invert_in_darkmode&sanitize=true" align=middle width=38.1354039pt height=36.1865163pt/></p>
is typically spoken as "one over x plus y". That that could also be interpreted as
<p align="center"><img src="/docs/tex/5e3758943554559c449f298e7209f8bd.svg?invert_in_darkmode&sanitize=true" align=middle width=40.10798055pt height=32.990165999999995pt/></p>
Pausing can help a little, but at least one study has shown students prefer strong lexical cues such as saying start/end words. So for someone who is blind, "start fraction one over x plus y end fraction" is unambiguous. However, for a student with dyslexia who can see but is aided by audio, those extra words are confusing and add complexity. Hence, the words used for the speech needed to be chosen based on the audience.

Another important factor when speaking is to know the skill level of the audience. For example, <img src="/docs/tex/8ff8438149960d1cd56e441e41d4d09d.svg?invert_in_darkmode&sanitize=true" align=middle width=37.80642524999999pt height=22.831056599999986pt/> is spoken as “the log base 2 of x”, but people who use that term a lot would shorten the speech to “log 2 x”.
<img src="/docs/tex/5e7f059f50c438c67a2308c39003bae2.svg?invert_in_darkmode&sanitize=true" align=middle width=61.68602714999999pt height=28.92634470000001pt/> is introduced as “the first derivative with respect to x of sine of x” and would later be spoken as “d by dx of sine x”.

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
