---
title: MathJax Test
---



# TeX input

{% raw %}
You can mark up inline math with `$...$` or display with
`\\[...\\]` Some tex constructs, notably `{{` or `{%`, get picked up
by the templating language and so for simple cases it is enough just
to use the above but in general you need to also surround with
`{%` raw `%}`...`{%` endraw `%}`
to protect the TeX markup from the Jekyll templating.
{% endraw %}

1. inline $\frac{a}{b}$ and $\frac{{a}}{{b}}$ inline BAD

2. inline {% raw %}$\frac{a}{b}$ and $\frac{{a}}{{b}}${%endraw %} inline

3. display BAD
   \\[\frac{a}{b} + \frac{{a}}{{b}}\\]
   display

4. display
   {% raw %}
   \\[\frac{a}{b} + \frac{{a}}{{b}}\\]
   {% endraw %}
   display

5. display
   {% raw %}
   \$\$\frac{a}{b} + \frac{{a}}{{b}}\$\$
   {% endraw %}
   display


# MathML input

1. inline <math display="inline"><mfrac><mi>a</mi><mi>b</mi></mfrac></math> inline

2. display <math display="block"><mfrac><mi>a</mi><mi>b</mi></mfrac></math> display