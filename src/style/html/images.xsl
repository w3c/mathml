<?xml version="1.0"?>
<!--
$Id: images.xsl,v 1.8 2012-01-26 20:38:31 dcarlis Exp $

images.xsl David Carlisle
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">

<xsl:output method="text" />


<xsl:template match="/">
\batchmode
\documentclass{article}
\usepackage{amstext,amsfonts,amssymb,color,graphicx,pmml-new}
\usepackage[T1]{fontenc} 
\pagestyle{empty}
\let\normalshape\upshape
\makeatletter
\definecolor{background}{rgb}{1.0,1.0,1.0}
%\pagecolor{background}
\let\ImageFontsize\large
\def\ImagePadding{1pt}
\def\ImageWidth{120mm}
\newsavebox{\FragmentBox}
\def\PaddedImage#1{%
  \bgroup\ImageFontsize \savebox{\FragmentBox}{$#1$}%
  \@tempdima\ht\FragmentBox \@tempdimb\dp\FragmentBox
  \ifdim\@tempdima>\@tempdimb
    \dp\FragmentBox\@tempdima
  \else
    \ht\FragmentBox\@tempdimb
  \fi
  \color{background}\fboxsep\ImagePadding%
  \fbox{\color[rgb]{0.0,0.0,0.0}\box\FragmentBox}\egroup
  \newpage}
\def\UnpaddedImage#1{%
  \bgroup\ImageFontsize \savebox{\FragmentBox}{$#1$}%
  %%%DOES THIS CAUSE PROBLEMS? \dp\FragmentBox\z@
  \color{background}\fboxsep\ImagePadding%
  \fbox{\color[rgb]{0.0,0.0,0.0}\box\FragmentBox}\egroup
  \newpage}
\def\FDImage#1{%
  \UnpaddedImage{\displaystyle #1}}
\makeatother
\renewcommand{\int}{\intop}
\newcommand{\Nset}{\mathbb{N}}
\newcommand{\Zset}{\mathbb{Z}}
\newcommand{\Qset}{\mathbb{Q}}
\newcommand{\Rset}{\mathbb{R}}
\newcommand{\Cset}{\mathbb{C}}
\newcommand{\xor}{\mathbin{\mathrm{xor}}}
%\newcommand{\mod}{\mathbin{\mathrm{mod}}}
\newcommand{\diffd}{\mathrm{d}}
\newcommand{\eulere}{\mathrm{e}}
\newcommand{\ii}{\mathrm{i}}
\newdimen\boxwd
\newcommand{\widearrow}[1]{%
  \setbox0=\hbox{$\mathsurround0pt \scriptstyle\;\;#1\;\;$}\boxwd=\wd0%
  \mathrel{\mathop{\hbox to\boxwd{\rightarrowfill}}\limits_{#1}}}
\newwrite\img
\immediate\openout\img=images.sh
\newcount\n
\n=0
\begin{document}

\immediate\write\img{^^J%
dvips -Ppdf -j -E -i -S 1 images}

<xsl:for-each select="//graphic[@diff='add' or @diff='chg']">

\advance\n1
\immediate\write\img{^^J%
echo <xsl:value-of select="@source"/>^^J%
%convert -crop 0x0 -density 110x110  -transparent white eps:images.%
convert -crop 0x0 -density 110x110  eps:images.%
\ifnum \n &lt;100 0\fi
\ifnum \n &lt;10 0\fi
\the\n\space <xsl:value-of select="@source"/>}
  <xsl:choose>
    <xsl:when test="@role='inline' and @align='bottom'">
  \UnpaddedImage{<xsl:value-of select="@alt"/>}
    </xsl:when>
    <xsl:when test="@role='inline'">
  \PaddedImage{<xsl:value-of select="@alt"/>}
    </xsl:when>
    <xsl:otherwise>
  \FDImage{<xsl:value-of select="@alt"/>}
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>

\end{document}
</xsl:template>

</xsl:stylesheet>
