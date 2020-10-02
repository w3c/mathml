---
title: "Math Accessibility Primer"
layout: cgreport
---

*Authors*: Sam Dooley, Neil Soiffer



## Abstract
[MathML 3](https://www.w3.org/TR/MathML3/) is a W3C recommendation for including mathematical expressions in Web pages. MathML has two parts: Presentation MathML that describes how the math looks and Content MathML that describes the meaning of the math. Presentation is by far the most commonly used part of MathML and is the focus of this document. Assuming a reader knows the subject matter, the math notation typically communicates the math meaning. Although math notation is occasionally ambiguous, context usually resolves the ambiguity. One goal of MathML 4 is to allow authors to provide context as part of the MathML to resolve any ambiguity.

Math accessibility has significant differences from text accessibility because math notation is a shorthand for its meaning. The words spoken for it differ from the braille that would be used for it. Furthermore, the words that are spoken need to differ based on the reader’s disabilities and familiarity of the content. Hence, enough information from MathML should be given to the assistive technology (AT) of a user so that it can generate a meaningful presentation of the math to the user.

Although this document uses the word "math", the notations described here are used in science, engineering, and in other fields. These include notations used in Chemistry that make use of standard mathematical notations (e.g., $\mathrm{Al}^{+3}\mathrm{O}^{-2} \rightarrow \mathrm{Al}_2 \mathrm{O}_3$).
"Math" accessibility applies to not just documents about mathematical topics, but is relevant to almost all technical documents.

<nav id="toc" markdown="1">

# Table of Contents
{:.no_toc}

* toc
{:toc}

</nav>

# Why Is Math Accessibility Different From Text Accessibility?
The following are reasons why math accessibility is different from text accessibility. Details are in the next section:

* **Math Concepts vs Text Words** Mathematical expressions encode concepts, not words. The same concept can be spoken or brailled in many different ways, and the same notation may encode different concepts. For text, with the exception of abbreviations and a few words (e.g, “*read*”), words are almost always *read* the same.
* **Spoken Math vs Braille Math** For most text, both the speech and braille used to represent the text come directly from the words in the text.  For math, most braille systems encode the syntax of the math, which can be quite different from the words used to speak the math.
* **Spoken Math vs Spoken Text** Speech engines are tuned to speak text, not math formulas. This tuning results in strange or missing prosody when math is spoken as if it were common text. In math, the long version of vowels should always be used; speech engines usually use the short 'a' sound when speaking math which can be confusing. 
Because speech cues can't be part of `aria-label`, using `aria-label` as the text to speak for math results in inferior speech for math. This same problem affects `aria-live` regions. These regions are used for interactive math such as an accessible math editor. AT currently ignores MathML in such regions. Placing plain text in the region results in poor readings for the reasons mentioned.
* **Custom AT Needs for Math** The words that a screen reader should use need to be tailored to the disability of the user. For those who cannot see the math notation, the functional structure of math needs to be explained and/or navigated. A screen reader can communicate this information with words, sounds, or prosody changes (e.g., pitch or rate). For those who can see the math, such unfamiliar sounds or words can make understanding more difficult.
* **Math Notations vs Math Instances** The notations and tokens taken together may affect how the math should be spoken. For example, the ‘4’ in $x^4$ might be spoken as a cardinal number (“x to the fourth power”) while the ‘2’ in $x^2$ is spoken as “squared” (“x squared”).
* **Overloaded Math Notations** Depending on context, the same notation may have different meanings. For example, “(1, 5)” could be a point in the plane or it could be the numbers from 1 to 5, exclusive of 1 and 5. Although it could be spoken syntactically (“open paren 1 comma 2 close paren”), listeners tend to prefer to hear the meaning of the math spoken the way a teacher or another person would typically say it.
* **Math Idioms for Expert Users** As one becomes more experienced with a notation, the words used to speak the notation might change to use idioms that are understood by those who are fluent with the underlying concepts. Examples are given below.

For these reasons, tools for accessibility require more information about math content than they do about text content to achieve the same level of support for accessibility.

There are two other important requirements for math accessibility that are similar in some ways to text accessibility:

<ul>
<li> <b>Navigation</b> Navigation for text often means moving the focus to different areas; maybe even just to the next word. For larger math expressions, navigation to help understand structure is important. For example, the two-point formula for a line is:
<math xmlns='http://www.w3.org/1998/Math/MathML' display='block'>
    <mrow>
        <mi>y</mi>
        <mo>−</mo>
        <msub>
            <mi>y</mi>
            <mn>1</mn>
        </msub>
        <mo>=</mo>
        <mfrac>
            <mrow>
                <msub>
                    <mi>y</mi>
                    <mn>2</mn>
                </msub>
                <mo>−</mo>
                <msub>
                    <mi>y</mi>
                    <mn>1</mn>
                </msub>
            </mrow>
            <mrow>
                <msub>
                    <mi>x</mi>
                    <mn>2</mn>
                </msub>
                <mo>−</mo>
                <msub>
                    <mi>x</mi>
                    <mn>1</mn>
                </msub>
            </mrow>
        </mfrac>
        <mrow>
            <mo>(</mo>
            <mi>x</mi>
            <mo>−</mo>
            <msub>
                <mi>x</mi>
                <mn>1</mn>
            </msub>
            <mo>)</mo>
        </mrow>
    </mrow>
</math>
 Many people find this too large to understand if read uninterrupted from start to finish. Techniques for navigation are supported by many screen readers, but techniques differ and features such as outlines and ellison are under active investigation. If this content were in a button (e.g, "Click on the correct solution"), does navigability of the math become not possible/illegal?
 </li>
<li>
<b>Synchronized highlighting of text/math with speech</b> Tools such as TextHELP! and ZoomText both support highlighting of text as it is spoken. The same features should work with math, and are currently supported in <a src="https://mathshare.benetech.org">Mathshare</a>.
</li>
</ul>

## What information makes math accessible?

Almost all of the information needed to make text accessible is carried by the words in the text and knowledge of the spoken language of the text.  In the vast majority of cases, this information is enough to provide a vocalization of the text for a screen reader. It is also enough to generate a braille encoding of the text for a tactile reader that can be navigated.

In contrast, because of the richness of math notation, the symbols on the printed page used for math are often not enough to provide an accurate spoken reading of a formula, or a precise braille encoding, in a way that can be understood by a reader who uses accessible technology.

To make math content accessible with the same richness as the text that surrounds it, additional information about the semantics, or meaning, of the math must be provided.

## How can this information be provided to AT tools?

Tremendous progress toward math accessibility has been made using markup languages for math such as LaTeX and MathML.  LaTeX can be written by the visually impaired with a plain-text editor and used to create typeset math for sighted users.  MathML in a web page allows tools to process math markup in ways that go beyond simply adding alternate text for math images.  While these languages do not encode semantic information, they provide a structure within which other tools may infer enough of the math meaning to be properly understood.

In a web browser, Presentation MathML now represents the most accessible alternative for encoding math.  JAWS, NVDA, VoiceOver, and Orca all have some support for reading MathML. Solutions based on LaTeX are not as fully integrated into the web technology stack. Tools based on Content MathML, while they can provide the necessary semantic information, are rare probably due to the very limited amount of Content MathML on the web.

# Background: MathML
[The MathML 3 recommendation](https://www.w3.org/TR/MathML3/) has two subsets: Presentation MathML and Content MathML. Although these subsets can be intermixed, in practice that is very rare. Both subsets can be combined into a [parallel markup](https://www.w3.org/TR/MathML3/chapter5.html), but that markup is complicated and also rarely done in practice.

## Presentation MathML

Presentation MathML is the subset of MathML that is concerned with the visual appearance of mathematical notations.  It is by far the most commonly used variety of MathML. Presentation MathML is sufficient to provide visual access to math in a web page, which satisfies many common end user requirements.  Just as with LaTeX, the primary purpose for Presentation MathML is to produce high quality images of technical mathematics for consumption by sighted human readers. In this way, it is similar to how PDF documents produce high quality images of textual materials.

## Content MathML

Content MathML is the subset of MathML that is concerned with the underlying structure of mathematical notations.  It provides a precise way to communicate the order of operations in an expression, and the exact intent of the user who created it.  For example, when a user creates the expression $h(l+w)$, Content MathML provides a way to say whether it means 'h times the quantity l plus w' or 'the function 'h' applied to the quantity 'l plus w'.  There are many other examples of math expressions that look the same on the printed page, but may mean very different things.  Human beings can usually tell the difference based on context.  Content MathML preserves these differences, independent of context, and so it provides a solid foundation for any task that requires access to the meaning of a mathematical formula. However, how that content is displayed is not specified. For example, a fraction may be displayed in its 2D form, as a "bevelled" fraction, or linearly with parentheses and "/".
Most authors are concerned how their math looks. Most authoring tools have focused on supporting this to the detriment of Content MathML usage.

## Semantic Markup

Since the use of Content MathML, especially in addition to Presentation MathML, involves adding more markup to an encoding that is already verbose, The [MathML 4 refresh community group](https://www.w3.org/community/mathml4/) is working on a way to minimize the amount of additional markup needed to recover the semantic interpretation of a presentational expression.  _Semantic markup_ refers to the proposals of that group to meet this need.

*Note: the CG is still actively discussing potential solutions, so the solutions mentioned here are not final and will likely change. What is likely to be true of any solution is that it will entail the addition of attributes to Presentation MathML*.

The markup form that has been proposed for semantic markup extends Presentation MathML with a math `subject` attribute to carry the semantic context and a `notation` attribute to indicate the functionality and location of arguments, and an `arg` attribute to identify the location of the function's arguments. The functionality and rationale for the proposal/choices are described elsewhere; the MathML CG has not discussed names for the semantics functions yet.
`aria-label` can be used to force the words to speak (pronunciation of those words can't be controlled though).

The table below shows a few semantically marked up examples:

{::nomarkdown}
<table>
    <tr>
        <td>Open Interval: $(0, \pi)$</td>
        <td>
            <details markdown="1">
                <summary>MathML for open interval</summary>
{:/nomarkdown}
```
<mrow intent="open-interval(@start, @end)">
    <mo>(</mo>
    <mrow>
        <mi arg="start">0</mi>
        <mo>,</mo>
        <mi arg="end">π</mi>
    </mrow>
    <mo>)</mo>
</mrow>
```
{::nomarkdown}
           </details>
        </td>
    </tr>
    <tr>
        <td>Cartesian Point: $(0, \pi)$</td>
        <td>
            <details markdown="1">
                <summary>MathML for point in a plane</summary>
{:/nomarkdown}
```
<mrow intent="point(@x,@y)">
    <mo>(</mo>
    <mrow>
        <mi arg="x">0</mi>
        <mo>,</mo>
        <mi arg="y">π</mi>
    </mrow>
    <mo>)</mo>
</mrow>
```
{::nomarkdown}
            </details>
        </td>
    </tr>
    <tr>
        <td>Transpose: $A^T$</td>
        <td>
            <details markdown="1">
                <summary>MathML for transpose</summary>
{:/nomarkdown}
```
<msup intent="transpose(@matrix)">
  <mi arg="matrix">A</mi>
  <mi>T</mn>
</msup>
```
{::nomarkdown}
            </details>
        </td>
    </tr>
    <tr>
        <td>Dot Product: $\mathbf{a}\cdot\mathbf{b}$</td>
        <td>
            <details markdown="1">
                <summary>MathML for dot product</summary>
{:/nomarkdown}
```
<mrow intent="inner-product(@arg1, @arg2)">
  <mi mathvariant="bold" arg="arg1">a</mi>
  <mo>&#x22C5;</mo>
  <mi mathvariant="bold arg="arg2">b</mi>
</mrow>
```
{::nomarkdown}
            </details>
        </td>
    </tr>
</table>
{:/nomarkdown}

The mappings from the semantic markup using notation/meaning to a semantic tree are not part of MathML. It is likely that a group note will give a mapping from MathML to a defined semantics. Mathematical semantics is open-ended, so the note will give a known set of semantics that developers and target/implement. A dictionary that maps that semantic tree to speech (given inputs such as user disability, speech style, expertise, ...) may also be included as a means to allow AT to more easily incorporate base level functionality.

# Expectations: From Authors to AT

## Expectations for authoring tools and convertors
MathML is XML-based and is very verbose. Few people author HTML directly; even fewer author MathML directly. Authoring math is typically done either in a WYSIWYG math editor or in a typesetting language such as TeX/LaTeX which was designed to support math notation. For the most part, the focus of both is to make the visual presentation look good.

WYSIWYG math editors have focused on immediate feedback of mathematical notation. They typically offer palettes of common notations and characters used in math with keyboard equivalents to simplify authoring. They provide little support to disambiguate the notations except where doing so produces better display. For example, typing "sin" would normally display as "_sin_", but the editors recognize this as a mathematical function; they don't use italics and correctly generate a single `<mi>sin</mi>` rather than three separate `mi`'s, one for each letter as would be appropriate for multiplication of the three letters/variables. In the future, we hope editors will include support to allow (not _require_) users to add additional semantics to the generated MathML via [the above tagging](#semantic-markup). We hope this will happen because such additions are relatively simple and because we hope users will request such features due to their desire and/or requirement to produce accessible material.

TeX and LaTeX are used to write entire documents, usually those with a technical focus because of its excellent built-in support for math. In markdown and other authoring systems, the math syntax of TeX is often used for math content. However, TeX is extensible and authors frequently add macros for commonly used notations in math. This means that each system supports similar but differing extensions of TeX's builtin commands for math. Because TeX uses macros for some notations, this can be exploited in TeX to MathML translators. For example, TeX has the macro `\sin` for the mathematical function of the same name.
Conversion tools from TeX to MathML should be able to produce semantic markup in some cases:
* TeX's basic macros are already semantically translated properly as noted with "sin" above. We expect additional support for other macros such as `\binom{n}{m}` (displays as $\binom{n}{m}$) to be added to translators because doing so is relatively easy.
* More general support for the proposed MathML semantics requires the addition of two additional macros/commands. We expect the MathML Refresh CG to propose details for those macros. Addition of them to translators will happen if the user community pushes for them. We expect supporting whatever gets proposed to be relatively simple.
* Some authoring systems such as [PreTeXt](https://pretextbook.org/) use many more macros to disambiguate the meaning and improve layout. We expect translators from PreTeXt will produce semantic markup because semantics is a key reason to use PreTeXt.

Convertors from Content MathML to Presentation MathML should be able to produce semantic markup all of the time.

## Expectations for authors
As discussed above, authors do not typically author MathML directly. Their ability to add semantics to resolve ambiguity  may be a function of whether the tool they are using supports it. When their tool does support adding semantic markup, some training is likely needed for users to learn to recognize ambiguous notation and use the appropriate means in their authoring tool to resolve it. This is analogous to training users of WYSIWYG word processors to use styles and not to directly create (for example) a header by changing the font size and font weight.

If the tool doesn't support generating semantic markup, then remediation of the resulting MathML will be needed. In many cases, knowing the subject area is enough to disambiguate the MathML. A single webpage is usually concerned with a single subject and the simple addition of a subject area to each `math` tag will likely resolve most ambiguities; this should be trivial to do. We expect publishers and individuals concerned about the accessibility of their web pages will do at least this step. There are some common ambiguities that are not resolved by subject area such as function call versus multiplication. Some other ambiguities are listed in the [examples in the following section](#examples-of-ambiguity). Fixing these ambiguities is likely considerably more work. However, two potential tools could help out:
* a tool that scans a web page for MathML and flags potential ambiguities, at least more common ones. Ideally the tool would allow the user to easily fix the ambiguity.
* a WYSIWYG math editor that supports semantic markup. Most math editors support import and export of MathML. Even if the original author did not use an editor that supported semantic markup, the person doing the remediation could by copy/pasting the MathML into the tool, fixing it, and then copy/pasting it back into the document.

## Expectations for AT
Presentation MathML describes how math looks. If all that was needed was to describe what the math looks like, then speech generation would be relatively easy. However, most AT users would not be happy hearing "x superscript 2 end superscript" and would much prefer to hear "x squared" because it is both shorter and more familiar. More examples are given in the [next section](#examples). Generating familiar speech is a challenge because of the large number of specialized ways of speaking notations that have become common over the centuries. On top of this, how AT should speak a notation depends on the user's disability and familiarity with the notation.

Simple AT implementations add a few tens of rules to catch cases such as $x^2$. The most sophisticated implementations have over 1,000 rules and support different styles of speaking math. Adding semantics markup will not reduce the complexity needed to produce familiar speech because AT will still need to handle MathML without semantic markup. However, when semantic markup is present, it will eliminate the heuristic nature of the rules.

Two potential tools/libraries could simplify AT implementations for math:
* a library that uses heuristics to add `notation` and `arg` to all notations that aren't already semantically marked up;
* code/tables that given the semantics, user preferences, and a target speech engine embedded markup language, returns the string to be passed to the speech engine used by the AT.

The MathML CG may produce prototypes of both of these tools

# Examples
This section demonstrates some of the complexities of math accessibility via examples.

## Special cases
Even when the semantics are clear, there are often many special cases that need to handled to make the speech reflect how humans read the math. Here are some examples for superscripts (`msup`):

{::nomarkdown}
<table>
<thead><tr><th>Notation</th><th>Speech</th></tr></thead>
<tbody>

<tr><td> $x^{n+1}$ </td><td>
“x raised to the n plus one power”
</td></tr>
<tr><td> $x^3$ </td><td>
“x cubed”
</td></tr>
<tr><td> $sin^{-1}(x)$ </td><td>
“the inverse sine of x”
</td></tr>
<tr><td> $f'(x)$ </td><td>
“f prime of x”
</td></tr>
</tbody>
</table>
{:/nomarkdown}

## Know Your Audience
Knowing the audience for the speech is important. If someone is blind, typical speech does not distinguish where 2D structures start and end. E.g., the fraction
\\[ \frac{1}{x+y}\\]
is typically spoken as "one over x plus y". That could also be interpreted as
\\[\frac{1}{x}+y\\]
Pausing can help a little after the $x$ can help, but at least one study has shown students prefer strong lexical cues such as saying start/end words. For someone who is blind, "fraction one over x plus y end fraction" is unambiguous. However, for a student with dyslexia who can see but is aided by audio, those extra words are confusing and add complexity. Hence, the words used for the speech needed to be chosen based on the audience.

Another important factor when speaking is to know the skill level of the audience. For example, $\log_2 x$ is spoken as “the log base 2 of x”, but people who use that term a lot would shorten the speech to “log 2 x”.
Another example is $\frac{d}{dx} \sin(x).$ When it is first introduced, it is often spoken as “the first derivative with respect to x of sine of x”. Later on, it gets shortened to “d by dx of sine x”.

## Examples of ambiguity
Probably the most common ambiguity happens because multiplication signs are often elided. Without context, it is not possible to distinguish between multiplication and function application.
For example, $a(x+y)$ might be a variable $a$ times $x+y$, or it might be a function $a$ (e.g, "area") with argument $x+y$. The invisible Unicode characters U+2061 (FUNCTION APPLICATION) and U+2062 (INVISIBLE TIMES) can disambiguate these cases, but they are not always used so AT has to guess what is the best way to speak it.

Mathematical notation is reused in different subject areas. Typically, speaking what something looks like is hard to understand. As an example, saying "x with a line over it" for $\bar x$ would make most people stop to try and understand what is meant. Putting a bar over a variable or expressions has many meanings, most of which are resolved based on knowing the subject area. Here are some ways that notation might be spoken:

{::nomarkdown}
<table>
<thead><tr><th>Notation</th><th>Speech</th><th>Subject Area</th></tr></thead>
<tbody>
<tr><td>  $\overline{a+bi}$ </td><td>
“the conjugate of a plus b i”
</td><td>
Algebra 2
</td></tr>
<tr><td>  $\overline{AB}$ </td><td>
“the line segment A B”
</td><td>
Geometry
</td></tr>
<tr><td> $\bar{x}$ </td><td>
“x bar”
</td><td>
Statistics (mean of $\mathbf{x}$)
</td></tr>
<tr><td> $\bar{x}$ </td><td>
“not x”
</td><td>
Logic
</td></tr>
</tbody>
</table>
{:/nomarkdown}

Without semantic markup or context given by a subject area, some meanings are guessable:
* if the expression under the bar has an $i$ in it, then it is probably a (complex) conjugate
* if there are two capital letters under the bar, then it is probably a line segment.

These patterns can be detected, but doing so for hundreds of cases imposes a large burden on AT. An (open source) library like the one contemplated being developed by the MathML CG to add semantic markup could substantially decrease the work required by AT to produce good speech.

## Different Markup, Same Meaning
In MathML, there are multiple ways to markup the same expression. A number of these are [equivalent characters in MathML](https://www.w3.org/TR/MathML3/chapter7.html#chars.anomalous) and include characters as common as U+002D [HYPHEN-MINUS] and U+2212 [MINUS SIGN].

In addition to character equivalents, some notations can be marked up in different ways. A common issue is that MathML says that [an `mrow` is not required for some elements that take one or more children](https://www.w3.org/TR/MathML3/chapter3.html#presm.inferredmrow). For example $\sqrt{-1}$ can be written in either of these two forms:

{::nomarkdown}

<table>
<thead><tr><th>Type of Markup</th><th>MathML</th></tr></thead>
<tbody>

<tr><td> Inferred `mrow` </td><td>
<details markdown="1">
<summary>Click to show MathML</summary>

{:/nomarkdown}

```
<msqrt>
  <mo> - </mo>
  <mn> 1 </mn>
</msqrt>
```
{::nomarkdown}
</details>
</td></tr>
<tr><td> Explicit `mrow` </td><td>
<details markdown="1">
<summary>Click to show MathML</summary>
{:/nomarkdown}
```
<msqrt>
  <mrow>
    <mo> - </mo>
    <mn> 1 </mn>
  </mrow>
</msqrt>
```
{::nomarkdown}
</details>
</td></tr>
</tbody>
</table>
{:/nomarkdown}

When trying to guess heuristics, these multiple forms make it much harder to check whether the MathML matches a desired pattern.

Outside of specified MathML equivalents, some notations can be written in different ways that look similar. For example, binomial coefficient $\binom{n}{k}$ can be written in these two ways:

{::nomarkdown}
<table>
<thead><tr><th>Type of Markup</th><th>MathML</th></tr></thead>
<tbody>

<tr><td>  Using a fraction with linethickness="0" </td><td>
<details markdown="1">
<summary>Click to show MathML</summary>
{:/nomarkdown}
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
{::nomarkdown}
</details>
</td></tr>
<tr><td> Using a 2x1 matrix </td><td>
<details markdown="1">
<summary>Click to show MathML</summary>
{:/nomarkdown}
```
<mrow>
    <mo>(</mo>
    <mtable>
        <mtr>
            <mtd><mi>n</mi></mtd>
        </mtr>
        <mtr>
            <mtd><mi>k</mi></mtd>
        </mtr>
    </mtable>
    <mo>)</mo>
</mrow>
```
{::nomarkdown}
</details>
</td></tr>
</tbody>
</table>
{:/nomarkdown}

Visually, there is a slight difference in their display, but the difference is small enough that most people probably would not notice it.

The later encoding is ambiguous in that it can also be a 2x1 matrix/vector.

In addition to the two ways to encode a binomial coefficient, it is also sometimes represented as ${}_nC_k$, $C(n,r)$, or $C_k^n$; they are all read the same.

In contrast, transpose can be written as $A^T$ and $T(A)$. The former is most commonly read as "A transpose" and the later as "the transpose of A".

## Chemistry
Chemical formulas and chemical equations are often marked up using math editors because they share similar notation constructs. However the speech is different. For example,
$\mathrm{H}_2 \mathrm{O}$
is read as "H 2 O", not "H sub 2, O"; or it might be read simply as "water". Similarly, ${}^{235}\mathrm{U}$ is read differently in Chemistry: "Uranium 235".

Chemistry makes use of "" for single bonds and "$=$" for double bonds. These can occur inside chemical equations such as:

\\[
K_\mathrm{eq}= \frac
    {[\mathrm{C}\mathrm{H}_2\mathord{=}\mathrm{C}\mathrm{H}_2][\mathrm{H}\mathrm{Br}]}
    {[\mathrm{C}\mathrm{H}_2\mathrm{Br}\mathord{-}\mathrm{C}\mathrm{H}_3]}
\\]

Knowing the subject area (which changes _inside_ the `math` element), allows for proper semantic markup so that AT reads this well. 
# Summary
Math accessibility is different from text accessibility. It has its own unique challenges. If you are using AT to read this primer, you may have encountered some of the challenges your AT has yet to tackle.

Two key points from the above discussion are:
* authors are responsible for ensuring that the semantic meaning of the math is correct;
* the words use to speak the math can only be generated once the target audience/user is known.

Full access to MathML, including the proposed semantic attributes, can provide the information that allows AT to deliver an experience for math that is on par with the experience provided for text and to the experience afforded to sighted readers.

<!--
[aria-braillelabel property](https://w3c.github.io/aria/#aria-braillelabel)

Because speech cues can’t be part of aria-label, using aria-label as the text to speak for math results in inferior speech for math.
author can't generate words for speech (know your audience)
in most cases speech must be generated by AT

Navigation inside active content

MathML or SSML tagged text in aria-live regions; sone means to get braille out.
-->
