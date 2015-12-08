<?xml version="1.0"?>
<!--
$Id: glyphs.xsl,v 1.2 2003/07/01 12:30:21 davidc Exp $

images.xsl David Carlisle
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"  
                extension-element-prefixes="saxon"
                version="1.0">

<xsl:output method="text" />


<xsl:template match="/">

<saxon:output href="glyphs.tex">
\documentclass{minimal}

\usepackage[pdftex]{graphicx}
\usepackage{times}
\setlength{\hoffset}{-1in}
\setlength{\voffset}{-1in}
\setlength{\pdfpageheight}{32bp}
\setlength{\pdfpagewidth}{32bp}
\setlength{\parindent}{0bp}
\setlength\unitlength{1bp}

\usepackage{amssymb,graphics}
<![CDATA[
\def\doglyph#1{\setbox8\hbox{#1}%
  \ifdim\wd8>30bp \resizebox{30bp}!{\box8}\else \usebox8 \fi}
\def\texteuro{C}
\DeclareFontShape{OT1}{cmr}{m}{n}{<->cmr10}{}
\DeclareFontShape{OMX}{cmex}{m}{n}{<->cmex10}{}
\DeclareFontShape{OMS}{cmsy}{m}{n}{<->cmsy10}{}
\DeclareFontShape{OML}{cmm}{m}{it}{<->cmmi10}{}
\DeclareFontFamily{U}{msa}{}
\DeclareFontFamily{U}{msb}{}
\DeclareFontShape{U}{msa}{m}{n}{<->    msam10 }{}
\DeclareFontShape{U}{msb}{m}{n}{<->    msbm10 }{}
\begin{document}
\hsize32bp
\vsize32bp
\topskip24bp
]]>
\centering
\fontsize{25bp}{27bp}\selectfont


<xsl:for-each
select="/charlist/character[@image='none']/latex[not(contains(.,'cyr')
or contains(.,'Elz'))]">

%
%<xsl:value-of select="../@id"/>
%
\doglyph{<xsl:if test="../@mode='math' or ../@mode='mixed'">$</xsl:if>
<xsl:value-of select="(../mathlatex)|(self::node()[not(../mathlatex)])"/>
<xsl:if test="../@mode='math' or ../@mode='mixed'">$</xsl:if>}
\clearpage

</xsl:for-each>
\end{document}
</saxon:output>

<saxon:output href="glyphs.sh">

pdflatex glyphs.tex
convert -despeckle glyphs.pdf tmp.png

<xsl:for-each
select="/charlist/character[@image='none'][latex[not(contains(.,'cyr')
or contains(.,'Elz'))]]">
mv tmp.png.<xsl:value-of select="position()-1"/><xsl:text> </xsl:text><xsl:value-of select="@id"/>.png<xsl:text/>

</xsl:for-each>

</saxon:output>

<saxon:output method="html" href="glyphs.htm">
<html>

<table>
<xsl:for-each
select="/charlist/character[@image='none'][latex[not(contains(.,'cyr')
or contains(.,'Elz'))]]">
<tr>
<td><xsl:value-of select="@id"/></td>
<td><xsl:value-of select="description"/></td>
<td><img src="{@id}.png"/></td>
</tr>

</xsl:for-each>
</table>
</html>
</saxon:output>

</xsl:template>

</xsl:stylesheet>
