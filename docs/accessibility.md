---
title: "Math Accessibility Primer"
layout: cgreport
---

*Authors*: Sam Dooley, Neil Soiffer



## Abstract
[MathML 3](https://www.w3.org/TR/MathML3/) is a W3C recommendation for including mathematical expressions in Web pages. MathML has two parts: Presentation MathML that describes how the math looks and Content MathML that describes the meaning of the math. Presentation is by far the most commonly used part of MathML and is the focus of this document. Assuming they know the subject matter, a person reading math notation typically can understand its meaning. Although it is occasionally ambiguous, context resolves the ambiguity. One goal of MathML 4 is to allow authors provide context as part of the MathML to resolve the ambiguity.

Math accessibility has significant differences from text accessibility because math notation is a shorthand for its meaning. The words spoken for it differ from the braille that would be used for it. Furthermore, the words that are spoken need to differ based on the reader’s disabilities and familiarity of the content. Hence, enough information from MathML should be given to the assistive technology of a user so that it can generate a meaningful presentation of the math to the user. 

<nav id="toc" markdown="1">

# Table of Contents
{:.no_toc}

* toc
{:toc}

</nav>

# Why is math accessibility different from text accessibility?
The following are reasons why math accessibility is different from text accessibility. Details are in the next section:

* **Math Concepts v Text Words** Mathematical expressions encode concepts, not words. The same concept can be spoken or brailled in many different ways, and the same notation may encode different concepts. For text, with the exception of abbreviations and a few words (e.g, “*read*”), words are almost always *read* the same.
* **Spoken Math v Braille Math** For most text, both the speech and braille used to reprsent the text come directly from the words in the text.  For math, most braille systems encode the syntax of the math, which can be quite different from the words used to speak to speak the math.
* **Custom AT Needs for Math** The words that a screen reader should use need to be tailored to the disability of the user. For those who cannot see the math notation, the functional structure of math needs to be explained and/or navigated. A screen reader can communicate this information with words, sounds, or prosody changes (e.g., pitch or rate). For those who can see the math, such unfamiliar sounds or words can make understanding more difficult.
* **Math Notations v Math Instances** The notations and tokens taken together may affect how the math should be spoken. For example, the ‘4’ in $x^4$ might be spoken as a cardinal number (“x to the fourth power”) while the ‘2’ in $x^2$ is spoken as “squared” (“x squared”).
* **Overloaded Math Notations** Depending on context, the same notation may have different meanings. For example, “(1, 5)” could be a point in the plane or it could be the numbers from 1 to 5, exclusive of 1 and 5. Although it could be spoken syntactically (“open paren 1 comma 2 close paren”), listeners tend to prefer to hear the meaning of the math spoken the way a teacher or another person would typically say it.
* **Math Idioms for Expert Users** As one becomes more experienced with a notation, the words used to speak the notation might change to use idioms that are understood by those who are fluent with the underlying concepts. Examples are given below.

For these reasons, tools for accessibility require more information about math content than they do about text content to achieve the same level of support for accessibility.

## What information makes math accessible?

Almost all of the information needed to make text accessible is carried by the words in the text, and knowledge of the spoken language being used.  In the vast majority of cases, this information is enough to provide a vocalization of the text for a screen reader, and a braille encoding of the text for a tactile reader, that can easily be navigated and understood by visually impaired readers.

In contrast, because of the richness of math notation, and the varieties of ways it is used to convey math concepts, the symbols on the printed page used for math are often not enough to provide an accurate spoken reading of a formula, or a precise braille encoding, in a way that can be understood by a reader who uses accessible technology.

To make math content accessible with the same richness as the text that surrounds it, additional information about the semantics, or meaning, of the math must be provided.

## How can this information be provided to AT tools?

Tremendous progress toward math accessibility has been made using markup languages for math such as LaTeX and MathML.  LaTeX can be written by the visually impaired with a plain-text editor and used to create typeset math for sighted users.  MathML in a web page allows Javascript tools to process math markup in ways that go beyond simply adding alternate text for math images.  While these languages do not encode semantic information, they provide a structure within which other tools may infer enough of the math meaning to be properly understood.

In a web browser, Presentation MathML now represents the most accessible alternative for encoding math.  Solutions based on LaTeX are not as fully integrated into the web technology stack, and tools based on Content MathML, while they can provide the necessary semantic information, are more difficult to create, and often less natural for untrained users.

# Background: MathML
[The MathML 3 recommendation](https://www.w3.org/TR/MathML3/) has two subsets: Presentation MathML and Content MathML. Although these subsets can be intermixed, in practice that is very rare. Both subsets can be combined into a [parallel markup](https://www.w3.org/TR/MathML3/chapter5.html), but that is complicated and also rarely done in practice.

## Presentation MathML

Presentation MathML is the subset of MathML that is concerned with the visual appearance of mathematical notations.  It is by far the most commonly used variety of MathML. Presentation MathML is sufficient to provide read-only visual access to static math in a web page, which satisfies many common end user requirements.  Just as with LaTeX, the primary purpose for Presentation MathML is to produce high quality images of technical mathematics for consumption by sighted human readers. In this way, it is similar to how PDF documents produce high quality images of textual materials.

## Content MathML

Content MathML is the subset of MathML that is concerned with the underlying structure of mathematical notations.  It provides a precise way to communicate the order of operations in an expression, and the exact intent of the user who created it.  For example, when a user creates the expression 'a(b + c)', Content MathML provides a way to say whether it means 'a times the quantity b plus c' or 'the function a applied to the quantity b plus c'.  There are many other examples of math expressions that look the same on the printed page, but may mean very different things.  Human beings can usually tell the difference based on context.  Content MathML preserves these differences, independent of context, and so it provides a solid foundation for any task that requires access to the meaning of a mathematical formula. However, how that content is displayed is not specified. For example, a fraction may be displayed in its 2D form, as a "bevelled" fraction, or linearly with parentheses and "/".

# Semantic Markup

## What do we mean by semantic markup?

Since the use of Content MathML, especially in addition to Presentation MathML, involves adding more markup to an encoding that is already verbose, The [MathML 4 refresh community group](https://www.w3.org/community/mathml4/) is working on a way to minimize the amount of additional markup needed to recover the semantic interpretation of a presentational expression.  _Semantic markup_ refers to the proposals of that group to meet this need.

*Note: the CG is still actively debating potential solutions, so the solutions mentioned here are not final and will likely change. What is likely to be true of any solution is that it will entail the addition of attributes to Presentation MathML*

The markup form that has been proposed for semantic markup extends Presentation MathML with a math subject attribute to carry the semantic context, and a math role attribute to carry the semantic information.
`aria-label` can be used to force the words to speak. 

## "mathsubject" attribute

## "mathrole" attribute

# Expectations: From Authors to AT

## Expectations for authoring tools and convertors
MathML is XML-based and is very verbose. Few people author HTML directly; even fewer author MathML directly. Authoring math is typically done either in a WYSIWYG math editor or in a typesetting language such as TeX/LaTeX which was designed to support math notation. For the most part, the focus of both is to make the visual presentation look good.

WYSIWYG math editors have focused immediate feedback of mtematical notation. They typically offer palettes of common notations and characters used in math with keyboard equivalents to simplify authoring. They provide little support to disambiguate the notations except where doing so produces better display. For example, typing "sin" would normally display as "_sin_", but the editors recognize this as a mathematical function; they don't use italics and correctly generate a single `<mi>sin</mi>` rather than three separate `mi`'s, one for each letter as would be appropriate for multiplication of the three letters/variables. In the future, we expect editors will include support to allow (not _require_) users to add additional semantics to the generated MathML via the above tagging. We expect this to happen because such additions are relatively simple and because users will request such features due to their desire and/or requirement to produce accessible material.

TeX (and its extension LaTeX) are used to write entire documents,usually those with a technical focus because of its excellent built-in support for math. In markdown and other authoring systems, the math syntax of TeX is often used for math content. However, TeX is extensible and authors frequently add macros for commonly used notations in math. This means that each system supports similar but differing subsets of TeX for math. Because TeX uses macros for some notations, this can be exploited in TeX to MathML translators. For example, TeX has the macro `\sin` for the mathematical function of the same name.
Conversion tools from TeX to MathML should be able to produce semantic markup in some cases:
* TeX's basic macros are already semantically translated properly as noted with "sin" above. We expect additional support for other macros such as `\binom{n}{m}` (displays as $\binom{n}{m}$) to be added to translators because doing so is relatively easy.
* More general support for the proposed MathML semantics requires the addition of two additional macros/commands. We expect the MathML refresh CG to propose details for those macros. Addition of them to translators will happen if the user community pushes for them. We expect supporting whatever gets proposed to be relatively simple.
* Some authoring systems such as [PreTeXt](https://pretextbook.org/) use many more macros to disambiguate the meaning and improve layout. We expect translators from PreTeXt will produce semantic markup if the authors use the macros because semantics is iey reason to use PreTeXt.

Convertors from Content MathML to Presentation MathML should be able to produce semantic markup all of the time.

## Expectations for authors
 As discussed above, authors do not typically author MathML directly. Their ability to add semantics to resolve ambiguity  mainly be a function of whether the tool they are using supports that. When their tool does support adding semantic markup, some training is likely needed for users to learn to recognize ambiguous notation and use the appropriate means in their authoring tool to resolve it. This is analogous to training users of WYSIWYG word processors to use styles and not to directly create (for example) a header by changing the font size and font weight.

If the tool doesn't support generating semantic markup, then remediation of the resulting MathML will be needed. In many cases, knowing the subject area is enough to disambiguate the MathML. A single webpage is likely concerned with a single subject and the simple addition of a subject area to each `math` tag will likely resolve most ambiguities; this should be trivial to do. We expect publishers and individuals concerned about the accessibility of their web pages will likely do at least this step. There are some common ambiguities that are not resolved by subject area such as function call versus multiplication. Many these ambiguities are listed in the examples in the following section. Fixing these ambiguities is likely considerably more work. However, two potential tools could help out:
* a tool that scans a web page for MathML and flags potential ambiguities, at least more common ones. Ideally the tool would allow the user to easily fix the ambiguity.
* a WYSIWYG math editor that supports semantic markup. Most math editors support import and export of MathML. Even if the original author did use an editor that supported semantic markup, the person doing the remediation could.

## Expectations for AT
Presentation MathML describes how math looks. If all that was needed was to describe what the math looks like, then speech generation is relatively easy. However, most AT users would not be happy hearing "x superscript 2 end superscript" and would much prefer to hear "x squared" because it is both shorter and more familiar. Some more examples are given in the next section. Generating familiar speech is a challenge because of the large number of specialized ways of speaking notations that have become common over the centuries. On top of this, how AT should be speak a notation depends on the user's disability and familiarity with the notation.

Simple AT implementations add a few tens of rules to catch cases such as $x^2$. The most sophisticated implementations have over 1,000 rules and support different styles of speaking math. Adding semantics markup will not reduce the number of rules needed to produce familiar speech because AT will still need to handle MathML without semantic markup. However, when semantic markup is present, it will eliminate the heuristic nature of the rules.

[One proposal for semantic markup might lend itself to a dictionary-based approach to speech. Potentially a common dictionary can be developed and used by multiple AT which might significantly reduce implementation effort.]

# Examples


## Examples of speech
$x^n$ may be spoken as "x raised to the nth power". However, this pattern is not always followed for powers.
There are often special cases that people speak differently.
$x^2$ ("x squared") and $x^3$ ("x cubed") are two such examples.

$\sin^{-1} x$ is also usually specially cased ("inverse sine of x" vs "sine raised to the negative one power of x")

Some small numeric fractions are special cased $\frac{1}{2}$ ("one half") but not this similar numeric fraction $\frac{3}{111}$ ("start fraction 3 over 111 end fraction").


Knowing the audience for the speech is important. If someone is blind, typical speech does not distinguish where 2D structures start and end. E.g., the fraction
\\[ \frac{1}{x+y}\\]
is typically spoken as "one over x plus y". That could also be interpreted as
\\[\frac{1}{x}+y\\]
Pausing can help a little, but at least one study has shown students prefer strong lexical cues such as saying start/end words. So for someone who is blind, "start fraction one over x plus y end fraction" is unambiguous. However, for a student with dyslexia who can see but is aided by audio, those extra words are confusing and add complexity. Hence, the words used for the speech needed to be chosen based on the audience.

Another important factor when speaking is to know the skill level of the audience. For example, $\log_2 x$ is spoken as “the log base 2 of x”, but people who use that term a lot would shorten the speech to “log 2 x”.
$\frac{d}{dx} \sin(x)$ is introduced as “the first derivative with respect to x of sine of x” and would later be spoken as “d by dx of sine x”.

## Examples of ambiguity
The invisible Unicode characters U+2061 (FUNCTION APPLICATION) and U+2062 (INVISIBLE TIMES) can disambiguate some common cases. An exception is "units"
### $(1,5)$

### $M^T$

### Binomial Coefficient: $\binom{n}{k}$

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

### Chemistry
Chemical formulas are often marked up using math editors. The chemical elements are one source of ambiguity, but all the notation around them, including bonds, are other sources of ambiguity
\\[
K= \frac
    {[\mathrm{C}\mathrm{H}_2\mathord{=}\mathrm{C}\mathrm{H}_2][\mathrm{H}\mathrm{Br}]}
    {[\mathrm{C}\mathrm{H}_2\mathrm{Br}\mathord{-}\mathrm{C}\mathrm{H}_3]}
\\]

# Summary 
