# Math Accessibility Explainer

## Authors
 * Neil Soiffer
 * Sam Dooley

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


### Content MathML



## Ideas
