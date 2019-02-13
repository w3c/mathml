<?xml version="1.0" encoding="ISO-8859-1" ?>

<!--
$Id: mathmlspec.xsl,v 1.152 2015/04/03 14:26:55 dcarlis Exp $
This style-sheet creates the LaTeX version of the MathML Recommendation,
which is used to create a PDF document. 
It is maintained by David Carlisle for the Math WG.
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="3.0"
>
<!--
<xsl:param name="cduriprefix" select="'http://svn.openmath.org/OpenMath3/cd/MathML'"/>
-->
<xsl:param name="cduriprefix" select="'http://www.openmath.org/cd'"/>

<xsl:key name="id" match="*[@id]" use="@id"/>

<xsl:output method="text"
	    use-character-maps="tex"
            encoding="iso-8859-1"/>

<xsl:character-map name="tex">
  <xsl:output-character character="&#8230;" string="£ldots££"/>
  <xsl:output-character character="&#8482;" string="£texttrademark££"/>
  <xsl:output-character character="&#8216;" string="`"/>
  <xsl:output-character character="&#8217;" string="'"/>
  <xsl:output-character character="&#233;" string="£'{e}"/>
  <xsl:output-character character="&#160;" string=" "/>
  <xsl:output-character character="&#824;" string="£ensuremath{£not{}}"/>
  <xsl:output-character character="&#949;" string="£ensuremath£epsilon££"/>
  <xsl:output-character character="&#937;" string="£ensuremath£Omega££"/>
  <xsl:output-character character="&#945;" string="£ensuremath£alpha££"/>
  <xsl:output-character character="&#955;" string="£ensuremath£lambda££"/>
  <xsl:output-character character="&#957;" string="£ensuremath£nu££"/>
  <xsl:output-character character="&#960;" string="£ensuremath£pi££"/>
  <xsl:output-character character="&#963;" string="£ensuremath£sigma££"/>
  <xsl:output-character character="&#8734;" string="£ensuremath£infty££"/>
  <xsl:output-character character="&#8924;" string="£ensuremath£leqslant££"/>
  <xsl:output-character character="&#8211;" string="£textendash££"/>
  <xsl:output-character character="&#8212;" string="£textemdash££"/>
  <xsl:output-character character="&#1576;" string="[ARABIC LETTER BEH]"/>
  <xsl:output-character character="&#1585;" string="[ARABIC LETTER REH]"/>
  <xsl:output-character character="&#1590;" string="[ARABIC LETTER DAD]"/>
  <xsl:output-character character="&#1605;" string="[ARABIC LETTER MEEM]"/>
  <xsl:output-character character="&#1608;" string="[ARABIC LETTER WAW]"/>
  <xsl:output-character character="&#8220;" string="``"/>
  <xsl:output-character character="&#8221;" string="''"/>
</xsl:character-map>

<!--
The following parameters determine
- the type of document
- copyright dates
All parameters can be overridden by the user.
-->

<xsl:param name="status" select="/spec/@w3c-doctype"/>
<xsl:param name="copyright">1998--2019</xsl:param>

<!-- Main output document -->
<xsl:template match="/">
 <!--
  <xsl:result-document href="{substring-before(/spec/header/altlocs/loc
     [contains(@href,'s.pdf')]/@href,'pdf')}tex">
<xsl:text>
\documentclass[oneside,fleqn,12pt,oldtoc]{rapport3}
  \usepackage{ae,pslatex,longtable}
  \usepackage{verbatim,amssymb,url}
  \usepackage[latin1]{inputenc}
  \DeclareInputMath{215}{\ensuremath\times}

\makeatletter


\def\£{}

\newenvironment{htable}
  {\par\def\@captype{table}}{\par}


\def\DomMethodName#1{\colorbox[RGB]{"F9, "F5, "C0}{#1}}
\def\DomAttName#1{\colorbox[RGB]{"C0, "C0, "F9}{#1}}

\usepackage[pdftex]{color,graphicx}


\hoffset-1in
\voffset-1in

\newcount\vcount
\def\verbatim@processline{%
 \ifcat$\the\verbatim@line$%
 \ifnum\vcount=\z@\verbatim@line{\@gobble}\fi
 \penalty0 \fi
 \advance\vcount\@ne
 \ifnum\vcount>25 \penalty0 \fi
 \the\verbatim@line\par}

\HeadingFonts
  {\leavevmode\color[RGB]{"0,"50,"B2}\sffamily}
  {\leavevmode\color[RGB]{"0,"50,"B2}\sffamily}
  {\leavevmode\color[RGB]{"0,"50,"B2}\sffamily}
  {\leavevmode\color[RGB]{"0,"50,"B2}\sffamily}
  {\leavevmode\color[RGB]{"0,"50,"B2}\sffamily}
  {\leavevmode\color[RGB]{"0,"50,"B2}\sffamily}
  {\leavevmode\color[RGB]{"0,"50,"B2}\sffamily}
  {\leavevmode\color[RGB]{"0,"50,"B2}\sffamily}

\def\@oddhead{\hfill \thepage}



\setlength\textheight{22cm}
\setlength\textwidth{25cm}

\paperheight\textheight
\paperwidth\textwidth

\oddsidemargin30pt
\topmargin10pt

\advance\textwidth-2\oddsidemargin
\advance\textheight-6\topmargin
\hbadness10000
\interlinepenalty\@M
\interdisplaylinepenalty\@M

\raggedbottom


\def\familydefault{phv}
\def\ttdefault{aett}

\newenvironment{landscape}
  {\par}{}

\usepackage{tabularx,hyperref}


\def\titlecode{%
\color[RGB]{"0,"50,"B2}

\hspace*{-1cm}\rotatebox[origin=bl]{90}{\normalsize\colorbox[RGB]{"0,"50,"B2}{\color
 {white}W3C </xsl:text>
  <xsl:choose>
    <xsl:when test="$status='REC' or $status='rec'">
    <xsl:text>Recommendation</xsl:text>
    </xsl:when>
    <xsl:when test="$status='CR' or $status='cr'">
    <xsl:text>Candidiate Recommendation</xsl:text>
    </xsl:when>
    <xsl:when test="$status='PR' or $status='pr'">
    <xsl:text>Proposed Recommendation</xsl:text>
    </xsl:when>
    <xsl:when test="$status='PER' or $status='per'">
    <xsl:text>Proposed Edited Recommendation</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    <xsl:text>Working Draft</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
<xsl:text>\qquad}\hspace{-2cm}}\hspace{1cm}
\href{http://www.w3.org}{\includegraphics{image/w3c_home.png}}\par

\bigskip
}

\def\opdict{\let\verbatim\oldv\tiny}
\def\endopdict{\par}

\input{mathml-spec.tex}
</xsl:text>


</xsl:result-document>
-->
  <xsl:result-document href="{substring-before(/spec/header/altlocs/loc
     [contains(@href,'l.pdf')]/@href,'pdf')}tex">
<xsl:text>
\documentclass[twoside,fleqn,11pt,oldtoc]{rapport3}
  \hoffset-1in
  \addtolength\textwidth{1in}
  \oddsidemargin=\paperwidth
  \advance\oddsidemargin-\textwidth
  \divide\oddsidemargin by 2
  \evensidemargin=\oddsidemargin

  \addtolength\topmargin{-3\baselineskip}
  \addtolength\textheight{6\baselineskip}
  \usepackage{ae}
  \usepackage{verbatim,amssymb,longtable,url}
  \usepackage[latin1]{inputenc}
  \DeclareInputMath{215}{\ensuremath\times}

  \usepackage[pdftex]{graphicx,color}
  \usepackage{pslatex,tabularx,lscape}
  \renewcommand\ttdefault{aett}
  \usepackage{hyperref}

   \raggedbottom

\usepackage{pmml-new}

\definecolor{Blue}{rgb}{0,0,.3}
\hypersetup{
  linkcolor=Blue,
  anchorcolor=black,
  citecolor=Blue,
  filecolor=Blue,
  urlcolor=Blue,
  menucolor=Blue,
  }

\def\titlecode{}
\makeatletter


\showboxdepth10
\showboxdepth10

\def\protected@file@percent{}

   \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{{\PageFont\thepage}\hfil\MarkFont\leftmark}%
      \def\@oddhead{{\MarkFont\rightmark}\hfil\PageFont\thepage}%
      \let\@mkboth\markboth
      \def\chaptermark##1{%
        \markboth {{\ifnum \c@secnumdepth >\m@ne
              \@chapapp\ \thechapter. \ %
            \fi
            ##1}}{}}%
      \def\sectionmark##1{%
        \markright {{\ifnum \c@secnumdepth >\z@
            \thesection. \ \fi
            ##1}}}}

  \pagestyle{headings}

\def\sub\£#1\£{\sb{#1}}
\def\sup\£#1\£{\sp{#1}}
\def\egmeta\£#1\£{\textit{#1}}
\def\£{}
\def\dpcbreak.{\hfil\hskip-3em\penalty\z@\hfilneg\hbox{}\hskip3em }

\newenvironment{htable}
  {\par\def\@captype{table}}{\par}

\def\DomMethodName#1{\fcolorbox[RGB]{"F9, "F5, "C0}{"FF, "FF, "FF}{#1}}
\def\DomAttName#1{\fcolorbox[RGB]{"C0, "C0, "F9}{"FF, "FF, "FF}{#1}}

\def\opdict{\begin{landscape}\hfuzz=70pt\vbadness\maxdimen\small}
\def\endopdict{\end{landscape}}

\hfuzz=20pt \newdimen\hfuzz
\vfuzz=20pt \newdimen\vfuzz
\hbadness=2000
\vbadness=\maxdimen

\input{mathml-spec.tex}

</xsl:text>
  </xsl:result-document>

<xsl:variable name="x">
<xsl:apply-templates mode="diff"/>
</xsl:variable>
  <xsl:result-document href="mathml-spec.tex">
  <xsl:apply-templates select="$x/node()"/>
  </xsl:result-document>
</xsl:template>

<xsl:template match="*[@diff='del']" mode="diff" priority="10"/>
<xsl:template match="node()" mode="diff">
<xsl:copy>
<xsl:copy-of select="@*"/>
<xsl:apply-templates mode="diff"/>
</xsl:copy>
</xsl:template>


<!-- Basic framework for the MathML specification (as in the XML spec) -->
<xsl:template match="spec">
  <xsl:text>
\righthyphenmin=2
\hyphenation{new-dec-laration val-ue}

\setlength{\unitindent}{15pt}
\setlength{\leftmargini}{15pt}

\DeclareGraphicsExtensions{.pdf,.png}


\def\egemph#1\relax{\emph{#1}}
\newcounter{dtdlink}
\newcounter{prod}
\def\eglabel*#1*{\refstepcounter{dtdlink}\label{#1}}
\def\eghyperref[#1]*#2*{\hyperref[#1]{#2}}

\hypersetup{colorlinks,pdftitle={MathML 3.0},
  pdfsubject={MathML},
  pdfauthor={Math WG},
  pdfkeywords={pdf, LaTeX, MathML},
  bookmarks=true,
  pdfpagemode=UseOutlines,
  }

\def\HyPsd@CatcodeWarning#1{}
\newcolumntype{L}{>{\raggedright\let\\\tabularnewline}X}

\def\strc[#1]#2{\texttt{\leavevmode\penalty\z@\hskip 0pt plus #1\penalty1000\hskip 0pt plus -#1\relax#2}}

\def\1{\ \hfil\penalty1000\hfilneg}

\renewenvironment{thebibliography}[1]
     {\list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \itemsep.25\baselineskip plus.25\baselineskip
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand*\theenumiv{\@arabic\c@enumiv}}%
      \sloppy\clubpenalty4000\widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}


\let\oldv\verbatim
{\catcode`\-\active\gdef\verbatim{\oldv\@makeother\-\catcode`\£0 }}

  \begin{document}
  \let\tablecell&amp;
  \def\resetcodes{%
    \catcode`\\=0
    \catcode`\&amp;=4
    \catcode`\^=7
    \catcode`\_=8
  }
 \setcounter{secnumdepth}{3}
 \renewcommand*\paragraph{%
  \@startsection{subsubsection}{4}{\z@}%
    {-1\baselineskip plus -.5\baselineskip minus -.25\baselineskip}%
    {.01\baselineskip}%
    {\normalfont\normalsize\ParaFont}}

  \def\gobbleTX T#1X{#1}
  \expandafter\def\expandafter\TTeX\expandafter{\expandafter\gobbleTX \TeX}
  \let\oldmath\(
  \def\({\oldmath\resetcodes }
  \let\olddmath\[
  \def\[{\olddmath\resetcodes }
  \renewcommand{\int}{\intop}
  \newcommand{\true}{{\small\texttt{true}}}
  \newcommand{\false}{{\small\texttt{false}}}
  \newcommand{\Y}{$\surd$}
  \newcommand{\N}{--}
  \newcommand{\xor}{\mathbin{\mathrm{xor}}}
%  \newcommand{\mod}{\mathbin{\mathrm{mod}}}
  \newcommand{\diffd}{\mathrm{d}}
  \newcommand{\eulere}{\mathrm{e}}
  \newcommand{\ii}{\mathrm{i}}
  \newcommand{\OR}{$\;\mid\;$}
  \newcommand{\versus}{\quad\mathrm{vs}\quad}
  \newdimen\boxwd
  \newcommand{\widearrow}[1]{%
    \setbox0=\hbox{$\mathsurround0pt \scriptstyle\;\;#1\;\;$}\boxwd=\wd0%
    \mathrel{\mathop{\hbox to\boxwd{\rightarrowfill}}\limits_{#1}}}
  \def\backepsilon{\ni}
  \catcode`\&amp;=12
  \catcode`\%=12
  \catcode`\#=12
  \catcode`\_=12 \lccode`\_`\_ \hyphenation{complex-_polar-_type}
  \catcode`\^^M=10
  \catcode`\^^a3=0
  \catcode`\^^a1=\active
  \catcode`\^^a2=\active
  \catcode`\^^a4=\active
  \def^^a1{-\linebreak[0]}
  \def^^a2{=\linebreak[0]}
  \def^^a4{/\linebreak[0]}
  \catcode`\^=12
  \catcode`\\=12
  £thispagestyle{empty}
  </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£catcode`£\=0 £catcode`£_=8
  \end{document}</xsl:text>
</xsl:template>

<!-- Prologue -->

<xsl:template match="header">
  <!-- document title -->
  <xsl:text>{£Large£bfseries£titlecode&#xA;</xsl:text>
  <xsl:value-of select="title"/>
  <!-- document subtitle -->
  <xsl:text>£par&#xA;&#xA;</xsl:text>
  <xsl:text>£bigskip&#xA;</xsl:text>
  <xsl:text>£currentpdfbookmark{Mathematical Markup Language Specification}{}&#xA;</xsl:text>
  <xsl:text>£large </xsl:text>
  <xsl:value-of select="w3c-doctype"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="pubdate/day"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="pubdate/month"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="pubdate/year"/>
  <xsl:text>£par&#xA;£smallskip}&#xA;</xsl:text>
  <xsl:text>£begin{description}&#xA;</xsl:text>
  <xsl:apply-templates select="publoc"/>
  <xsl:apply-templates select="latestloc"/>
  <xsl:apply-templates select="prevlocs"/>
  <xsl:apply-templates select="edlocs"/>
  <xsl:apply-templates select="authlist"/>
  <xsl:text>£end{description}&#xA;</xsl:text>
  <xsl:apply-templates select="errataloc"/>
  <xsl:apply-templates select="altlocs"/>
  <xsl:apply-templates select="translationloc"/>
  <xsl:call-template name="copyright"/>
  <xsl:apply-templates select="abstract"/>
  <xsl:apply-templates select="status"/>

</xsl:template>

<xsl:template match="publoc">
  <xsl:text>&#xA;£item[This version:]</xsl:text>
  <xsl:apply-templates select="loc[not(@role='available-format')]"/>
  <xsl:apply-templates select="loc[@role='available-format']"/>
</xsl:template>


<xsl:template match="loc[@role='available-format']" priority="3">
 <xsl:if test="position()=1">
  <xsl:text>£\&#xA;Also available as: </xsl:text>
 </xsl:if>
  <xsl:text>£href{</xsl:text>
  <xsl:value-of select="@href"/>
  <xsl:text>}{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
 <xsl:if test="position() != last()">
   <xsl:text>, </xsl:text>
 </xsl:if>
</xsl:template>

<xsl:template match="latestloc">
  <xsl:text>&#xA;£item[Latest MathML 3 version:]</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="latestloc[@role='rec']">
  <xsl:text>&#xA;£item[Latest MathML Recommendation:]</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="prevlocs">
  <xsl:text>&#xA;£item[Previous version</xsl:text><xsl:if 
   test="count(loc) > 1">s</xsl:if><xsl:text>:]£mbox{}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="publoc/loc|latestloc/loc|prevlocs/loc">
  <xsl:text>£par£href{</xsl:text>
  <xsl:value-of select="@href"/>
  <xsl:text>}{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="edlocs">
  <xsl:text>&#xA;£item[Editors' version</xsl:text><xsl:if 
   test="count(loc) > 1">s</xsl:if><xsl:text>:]£mbox{}</xsl:text>
      <xsl:for-each select="loc">
        <xsl:if test="position() &gt; 1">, </xsl:if>
	<xsl:apply-templates select="."/>
      </xsl:for-each>
</xsl:template>

  <xsl:template match="errataloc">
    £par Please refer to the errata for this document, 
      <xsl:call-template name="loc"/>
     which may include some normative corrections.£par
  </xsl:template>

  <xsl:template match="translationloc">
    £par See also <xsl:call-template name="loc"/>
     for £textbf{translations} of this document.£par
  </xsl:template>

<xsl:template match="altlocs">
  <xsl:text>&#xA;£par
In addition to the £href{overview.html}{HTML} version,
this document is also available 
in these non-normative formats: </xsl:text>
      <xsl:for-each select="loc">
        <xsl:if test="position() &gt; 1">
          <xsl:if test="last() &gt; 2">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:if test="last() = 2">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:if>
        <xsl:if test="position() = last() and position() &gt; 1">and&#160;</xsl:if>
        <xsl:text/>£href{<xsl:value-of select="@href"/>}{<xsl:apply-templates/>}<xsl:text/>
      </xsl:for-each>
      <xsl:text>.£par
</xsl:text>
</xsl:template>

<xsl:template match="authlist">
  <xsl:text>&#xA;£item[£label{authors}Editor</xsl:text>
  <xsl:if test="count(author[@role='editor']) > 1">s</xsl:if>
  <xsl:text>:]</xsl:text>
  <xsl:apply-templates select="author[@role='editor']" mode="editor"/>
  <xsl:if test="author[not(@role='@editor')]">
    <xsl:text>&#xA;£item[Principal Authors:]</xsl:text>
    {£raggedright <xsl:apply-templates select="author"/>£par}
  </xsl:if>
</xsl:template>

<xsl:template match="author[@role='editor']" mode="editor">
  <xsl:apply-templates/>
  <xsl:if test="position() != last()">£\</xsl:if>
</xsl:template>

<xsl:template match="author">
 <xsl:text>£mbox{</xsl:text>
 <xsl:value-of select="translate(normalize-space(name),' ','~')"/>
 <xsl:text>}</xsl:text>
 <xsl:if test="position() != last()">, <!-- £nobreak£hskip 0pt plus £textwidth£penalty£z@ --></xsl:if>
</xsl:template>

<xsl:template match="name">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="author/affiliation">
  <xsl:text> (</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="author/email">
  <xsl:text>£(£langle£)</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£(£rangle$))</xsl:text>
</xsl:template>

<xsl:template match="abstract">
  <xsl:text>£paragraph*{Abstract}£label{abstract}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="status">
  <xsl:text>£paragraph*{Status of this document}£label{status}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="w3c-designation">
</xsl:template>

<xsl:template match="w3c-doctype">
</xsl:template>

<xsl:template match="header/pubdate">
</xsl:template>

<xsl:template match="spec/header/title">
</xsl:template>

<xsl:template match="revisiondesc">
</xsl:template>

<xsl:template match="pubstmt">
</xsl:template>

<xsl:template match="sourcedesc">
</xsl:template>

<xsl:template match="langusage">
</xsl:template>

<xsl:template match="version">
</xsl:template>

<!-- Body -->

<xsl:template match="front">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="body">
  <xsl:text>{£catcode`\=0 £tableofcontents}</xsl:text>
<!--
  <xsl:text>&#10;£section*{Open Issues}£label{openissues}</xsl:text>
  <xsl:for-each select="(/*/*/div1|/*/*/inform-div1)[.//issue[not(@role='closed')]]">
    <xsl:value-of select="@id"/>
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="head/node()"/>
    <xsl:if test="position()!=last()">, </xsl:if>
  </xsl:for-each>
-->
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="back">
  <xsl:text>£appendix </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div1|inform-div1">
  <xsl:text>£chapter{</xsl:text>
  <xsl:apply-templates select="head" mode="header"/>
  <xsl:if test="name(.)='inform-div1'"> (Non-Normative)</xsl:if>
  <xsl:call-template name="makeanchor"/>
  <xsl:text>}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div2">
  <xsl:text>£section{</xsl:text>
  <xsl:apply-templates select="head" mode="header"/>
  <xsl:call-template name="makeanchor"/>
  <xsl:text>}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div2[@id='oper-dict_entries']">
  <xsl:text>£section{</xsl:text>
  <xsl:apply-templates select="head" mode="header"/>
  <xsl:call-template name="makeanchor"/>
  <xsl:text>}</xsl:text>
  <xsl:text>£begin{opdict}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;£end{opdict}&#10;</xsl:text>
</xsl:template>

<xsl:template match="div3">
  <xsl:text>£subsection{</xsl:text>
  <xsl:apply-templates select="head" mode="header"/>
  <xsl:call-template name="makeanchor"/>
  <xsl:text>}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div4">
  <xsl:text>£subsubsection{</xsl:text>
  <xsl:apply-templates select="head" mode="header"/>
  <xsl:call-template name="makeanchor"/>
  <xsl:text>}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="div5">
  <xsl:text>£paragraph{</xsl:text>
  <xsl:apply-templates select="head" mode="header"/>
  <xsl:call-template name="makeanchor"/>
  <xsl:text>}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="head" priority="1">
</xsl:template>

<xsl:template match="head" mode="header">
  <xsl:apply-templates/>
</xsl:template>

<!-- Blocks -->
<xsl:template match="item/p" priority="1">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="def/p" priority="1">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="descr/p" priority="1">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="p">
  <xsl:if test="@id">£label{<xsl:value-of select="@id"/>}</xsl:if>
  <xsl:apply-templates/>
  <xsl:text>£par </xsl:text>
</xsl:template>

<!-- 
NP: the match expression in the following template needs refining. 
When an 'eg' contains exactly one node and this node is a PI, 
do not generate any environment, but just process the child.
-->
<xsl:template match="eg[count(processing-instruction()) = 1]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="eg">
  <xsl:choose>
  <xsl:when test="@role">
    <xsl:choose>
      <xsl:when test="@role='mathml-error'">
       <xsl:text>£begin{verbatim}</xsl:text>
       <xsl:comment>error</xsl:comment>
       <xsl:apply-templates/>
       <xsl:text>\end{verbatim}
</xsl:text>
      </xsl:when>
      <xsl:when test="@role='text'">
        <xsl:text>£begin{flushleft}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>£end{flushleft}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>£begin{verbatim}</xsl:text>
     <xsl:variable name="t">
    <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="replace($t,'^\s+|\s+$','')"/>

       <xsl:text>\end{verbatim}
</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>£begin{verbatim}</xsl:text>
    <xsl:variable name="t">
    <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="replace($t,'^ *[\n\r]+|\s+$','')"/>
    <xsl:text>\end{verbatim}
</xsl:text>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="ednote">
  <xsl:text>£begin{flushleft}</xsl:text>
  <xsl:text>£textbf{Editor's note:}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{flushleft}</xsl:text>
</xsl:template>

<xsl:template match="ednote/date">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)£\</xsl:text>
</xsl:template>

<xsl:template match="edtext">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="issue[@role='closed']" priority="10"/>
<xsl:template match="issue">
  <xsl:text>£begin{flushleft}</xsl:text>
  <xsl:text>£textbf{Issue (</xsl:text>
  <xsl:value-of select="substring-after(@id,'-')"/>
  <xsl:text>):}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{flushleft}</xsl:text>
</xsl:template>

<xsl:template match="resolution">
  <xsl:text>£begin{flushleft}£textbf{Resolution: }</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{flushleft}</xsl:text>
</xsl:template>

<xsl:template match="note">
  <xsl:text>£begin{flushleft}</xsl:text>
  <xsl:text>£textbf{Note:}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{flushleft}</xsl:text>
</xsl:template>

<xsl:template match="ednote/p|issue/p|note/p">
  <xsl:apply-templates/>
</xsl:template>

<!-- Tables -->
<xsl:template match="table">
  <xsl:text>£begin{htable}</xsl:text>
  <xsl:apply-templates select="caption"/>
  <xsl:if test="@id">£label{<xsl:value-of select="@id"/>}</xsl:if>
  <xsl:text>£begin{tabularx}{£linewidth}
   {@{£extracolsep{£fill}}</xsl:text>
   <xsl:apply-templates mode="table-preamble" select="."/>
  <xsl:text>@{£extracolsep{£fill}}}
  </xsl:text>
  <xsl:apply-templates select="thead|tbody"/>
  <xsl:text>£end{tabularx}</xsl:text>
  <xsl:text>£end{htable}</xsl:text>
</xsl:template>

<xsl:template match="table[tbody/tr/td/table]">
<xsl:apply-templates select="tbody/tr/td/*"/>
<xsl:text>&#10;£par </xsl:text>
</xsl:template>

<xsl:template match="key('id','dom_elementTable')/table" priority="10">
  <xsl:text>£begin{longtable}[c]{ll}</xsl:text>
  <xsl:apply-templates select="thead"/>
  <xsl:text>£endhead</xsl:text>
  <xsl:apply-templates select="tbody"/>
  <xsl:text>£end{longtable}</xsl:text>
</xsl:template>

<xsl:template match="key('id','presm_mtable_attrs')/table|key('id','interf_toplevel_atts')/table" priority="10">
  <xsl:text>£begin{longtable}[c]{|l|p{0.6£textwidth}|l|}</xsl:text>
  <xsl:apply-templates select="thead"/>
  <xsl:text>£endhead</xsl:text>
  <xsl:apply-templates select="tbody"/>
  <xsl:text>£end{longtable}</xsl:text>
</xsl:template>

<xsl:template match="key('id','presm_mlongdiv_ex')/table" priority="10">
£par£scalebox{0.70}{£linewidth=1.4£linewidth <xsl:next-match/>}£par
</xsl:template>
<xsl:template match="key('id','presm_mlongdiv_ex')/table/thead/td/attval" priority="10">
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="table" mode="table-preamble">
  <xsl:value-of
   select="tbody/tr[1]/(td|th)/(for $l in (1 to (@colspan/xs:integer(.),1)[1]) return 'l')"/>
</xsl:template>

<xsl:template match="table[@role='attributes']" mode="table-preamble">
|l|X|l|
</xsl:template>

<xsl:template match="table[@role='attributes']/tbody/tr[td[@role='attdesc']]" priority="2">
  <xsl:text>&#10;£cline{2-3}</xsl:text>
  <xsl:text>£multicolumn{3}{|>{£leftskip=2em }p{0.9£linewidth}|}{</xsl:text>
  <xsl:apply-templates select="td[@role='attdesc']/node()"/>
  <xsl:text>}</xsl:text>
  <xsl:text>£\£hline&#xA;</xsl:text>
</xsl:template>


<xsl:template match="key('id','fund_table_notn')" mode="table-preamble">
  lX
</xsl:template>

<xsl:template match="key('id','contm_share_table')" mode="table-preamble">
  XX
</xsl:template>

<xsl:template match="key('id','contm_qualifiertable')" mode="table-preamble">
  lX
</xsl:template>

<xsl:template match="key('id','world-int-encoding-names')" mode="table-preamble">
  lXX
</xsl:template>

<xsl:template match="key('id','fund_table-attval')" mode="table-preamble">
  lX
</xsl:template>
<xsl:template match="key('id','fund_table-overflow')" mode="table-preamble">
  lX
</xsl:template>

<xsl:template match="key('id','table-flavor-a')|key('id','table-flavor-b')|key('id','table-flavor-c')|key('id','table-flavor-d')" mode="table-preamble">
  l>{£scriptsize}X
</xsl:template>

<xsl:template match="key('id','table-flavor-a')/thead/tr/td/text()|key('id','table-flavor-b')/thead/tr/td/text()|key('id','table-flavor-c')/thead/tr/td/text()|key('id','table-flavor-d')/thead/tr/td/text()" priority="2">
 <xsl:text>£normalsize </xsl:text>
 <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="key('id','presm_table-indentalign')" mode="table-preamble">
  lX
</xsl:template>

<xsl:template match="key('id','contm_table-funopqual')" mode="table-preamble">
  lX
</xsl:template>

<xsl:template match="key('id','mixing_table-annotation-attributes')" mode="table-preamble">
  lXl
</xsl:template>

<xsl:template match="key('id','contm_table-pragnum')" mode="table-preamble">
  >{£raggedright£hsize=.6£hsize}X>{£raggedright£hsize=1.6£hsize}Xl>{£raggedright£hsize=.8£hsize£arraybackslash}X
</xsl:template>

<xsl:template match="key('id','presm_table-mpadded')" mode="table-preamble" >
  lXl
</xsl:template>


<xsl:template match="key('id','presm_table-mo')" mode="table-preamble" priority="2">
  llX
</xsl:template>

<xsl:template match="key('id','presm_table-reqarg')" mode="table-preamble" >
  @{£extracolsep{£fill}}ll>{£raggedright£let£\£tabularnewline}X@{£extracolsep{£fill}}
</xsl:template>


<xsl:template match="key('id','contm_container')/p[1]/table" mode="table-preamble">
  lL
</xsl:template>
<xsl:template match="key('id','contm_opwithqual')/p[1]/table" mode="table-preamble">
  lL
</xsl:template>

<xsl:template match="key('id','chars_table-white')" mode="table-preamble" >
  llX
</xsl:template>

<xsl:template match="key('id','chars_table-unicode-block')" mode="table-preamble" >
  lX
</xsl:template>

<xsl:template match="key('id','presm_table_indent')" mode="table-preamble" >
  lL
</xsl:template>

<xsl:template match="key('id','presm_table_notation')" mode="table-preamble" >
  lLl
</xsl:template>

<xsl:template match="key('id','cn_attribs_table')" mode="table-preamble" >
  lLl
</xsl:template>

<xsl:template match="key('id','contm_cn_syntax')" mode="table-preamble" priority="222">
  lLlLl
</xsl:template>




<xsl:template match="table[@role='syntax']"  mode="table-preamble">
lLl
</xsl:template>

<xsl:template match="table[@role='syntax'][thead/tr/th/@colspan]"  mode="table-preamble" priority="22">
lLlLl
</xsl:template>


<xsl:template match="thead">
  <xsl:apply-templates select="tr"/>
   <xsl:text>£hline&#xA;</xsl:text>
</xsl:template>

<xsl:template match="table[@role='attributes']/thead">
   <xsl:text>£hline&#xA;</xsl:text>
  <xsl:apply-templates select="tr"/>
   <xsl:text>£hline£hline&#xA;</xsl:text>
</xsl:template>

<xsl:template match="tbody">
  <tbody>
  <xsl:apply-templates select="tr"/>
  </tbody>
</xsl:template>

<xsl:template match="tr">
  <xsl:apply-templates select="td|th"/>
  <xsl:if test="parent::thead or (position() != last())">
  <xsl:text>£\&#xA;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="td|th">
  <xsl:text>£relax </xsl:text>
  <xsl:if test="@id">£label{<xsl:value-of select="@id"/>}</xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="position() != last()">
  <xsl:text>£tablecell </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="td/text()[not(contains(.,'£'))]">
 <xsl:value-of select="replace(.,'([{}])','£$1')"/>
</xsl:template>

<xsl:template match="td[@colspan!=1]|th[@colspan!=1]">
  <xsl:text>£multicolumn{</xsl:text>
  <xsl:value-of select="@colspan"/>
  <xsl:text>}{l}{</xsl:text>
  <xsl:if test="@id">£label{<xsl:value-of select="@id"/>}</xsl:if>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
  <xsl:if test="position() != last()">
  <xsl:text>£tablecell </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="caption">
  <xsl:text>£caption{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- References -->
<xsl:template match="loc" name="loc">
  <xsl:text>£href{</xsl:text>
  <xsl:value-of select="@href"/>
  <xsl:text>}{</xsl:text>
  <xsl:if test="not(node())"><xsl:value-of select="@href"/></xsl:if>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="loc//text()">
  <xsl:value-of select="replace(.,'/+','$0£linebreak[0]')"/>
</xsl:template>

<xsl:template match="div2//loc[@href=.]" priority="10">
  <xsl:text>£url{</xsl:text>
  <xsl:value-of select="@href"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="bibl/loc[@href=.]" priority="10">
  <xsl:text>£url{</xsl:text>
  <xsl:value-of select="@href"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!--
<xsl:template match="loc">
  <xsl:text>£href{</xsl:text>
  <xsl:apply-templates/>
  <xsl:value-of select="@href"/>
  <xsl:text>}{</xsl:text>
  <xsl:text>}£\</xsl:text>
</xsl:template>
-->

<xsl:template match="titleref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="bibref">
  <xsl:text>£cite{</xsl:text>
  <xsl:value-of select="@ref"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="specref">
  <xsl:for-each select="key('id',@ref)">
    <xsl:call-template name="makeref"/>
  </xsl:for-each>
</xsl:template>


<xsl:template match="specref[@ref='status']">
       <xsl:text>£hyperref[status]{Status}</xsl:text>
</xsl:template>

<!--
  <xsl:template match="specref">
    <xsl:variable name="target" select="key('ids', @ref)[1]"/>
    <xsl:choose>
      <xsl:when test="local-name($target)='issue'">
        <xsl:text>[</xsl:text>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
          <b>
            <xsl:text>Issue </xsl:text>
            <xsl:apply-templates select="key('ids', @ref)" mode="number"/>
            <xsl:text>: </xsl:text>
            <xsl:for-each select="key('ids', @ref)/head">
              <xsl:apply-templates/>
            </xsl:for-each>
          </b>
        </a>
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(local-name($target), 'div')">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
<xsl:for-each select="$target">
          <xsl:choose>
    <xsl:when test="(self::div1) and parent::body">Chapter&#160;</xsl:when>
    <xsl:when test="(self::div1 or self::inform-div1) and
      parent::back">Appendix&#160;</xsl:when>
       <xsl:otherwise>Section&#160;</xsl:otherwise>
          </xsl:choose>
</xsl:for-each>
            <xsl:apply-templates select="key('ids', @ref)" mode="divnum"/>
            <xsl:apply-templates select="key('ids', @ref)/head" mode="text"/>
        </a>
      </xsl:when>
      <xsl:when test="starts-with(local-name($target), 'inform-div')">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
             <xsl:text>Appendix&#160;</xsl:text>
            <xsl:apply-templates select="key('ids', @ref)" mode="divnum"/>
            <xsl:apply-templates select="key('ids', @ref)/head" mode="text"/>
        </a>
      </xsl:when>
      <xsl:when test="local-name($target) = 'vcnote'">
        <b>
          <xsl:text>[VC: </xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @ref)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates select="key('ids', @ref)/head" mode="text"/>
          </a>
          <xsl:text>]</xsl:text>
        </b>
      </xsl:when>
      <xsl:when test="local-name($target) = 'prod'">
        <b>
          <xsl:text>[PROD: </xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @ref)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates select="$target" mode="number-simple"/>
          </a>
          <xsl:text>]</xsl:text>
        </b>
      </xsl:when>
      <xsl:when test="local-name($target) = 'label'">
        <b>
          <xsl:text>[</xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @ref)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:value-of select="$target"/>
          </a>
          <xsl:text>]</xsl:text>
        </b>
      </xsl:when>
      <xsl:when test="local-name($target)='MMLdefinition'">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
          <b>
            <xsl:value-of select="key('ids', @ref)/name"/>
          </b>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unsupported specref to </xsl:text>
          <xsl:value-of select="local-name($target)"/>
          <xsl:text> [</xsl:text>
          <xsl:value-of select="@ref"/>
          <xsl:text>] </xsl:text>
          <xsl:text> (Contact stylesheet maintainer).</xsl:text>
        </xsl:message>
        <b>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @ref)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>???</xsl:text>
          </a>
        </b>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
-->
<xsl:template match="intref">
  <xsl:text>£hyperref[</xsl:text>
  <xsl:value-of select="@ref"/>
  <xsl:text>]{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="xspecref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="termref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="vcnote">
  <xsl:call-template name="makeanchor"/>
  <xsl:text>£textbf{Validity Constraint: </xsl:text>
  <xsl:value-of select="head"/>
  <xsl:text>}£par </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="wfcnote">
  <xsl:call-template name="makeanchor"/>
  <xsl:text>£textbf{Well-formedness Constraint: </xsl:text>
  <xsl:value-of select="head"/>
  <xsl:text>}£par </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="xtermref">
  <xsl:apply-templates/>
</xsl:template>

<!-- Inlines -->
<xsl:template match="termdef">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="term">
  <xsl:text>£textbf{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="code">
  <xsl:text/>£strc[<xsl:value-of select="string-length(.) div 2.5"/>em]{<xsl:text/>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!--
<xsl:template match="code/text()">
  <xsl:value-of select="translate(.,'-=/','&#xA1;&#xA2;&#xA4;')"/>
</xsl:template>
-->

<xsl:template match="emph">
  <xsl:if test="starts-with(.,' ')"><xsl:text> </xsl:text></xsl:if>
  <xsl:text>£emph{£ignorespaces££</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="eg/emph">
<!--  <xsl:call-template name="makeanchor"/>-->
  <xsl:text>£egemph </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£relax </xsl:text>
</xsl:template>


<xsl:template match="key('id','parsing_dtd')/eg/phrase" priority="10">
  <xsl:if test="@id">£eglabel*<xsl:value-of select="@id"/>*</xsl:if>
</xsl:template>

<xsl:template match="key('id','parsing_dtd')/eg/intref" priority="10">
  <xsl:text>£eghyperref[</xsl:text>
  <xsl:value-of select="@ref"/>
  <xsl:text>]*</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>*</xsl:text>
</xsl:template>

<xsl:template match="phrase">
 <xsl:if test="@id">£label{<xsl:value-of select="@id"/>}</xsl:if>
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="phrase[.='application-specific']">
 <xsl:text>application£hspace{0pt}-specific</xsl:text>
</xsl:template>


 <xsl:template match="*[@diff='del']" priority="1001"/>


<xsl:template match="att">
  <xsl:text/>£strc[<xsl:value-of select="string-length(.) div 2.5"/>em]{<xsl:text/>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
</xsl:template>

  <xsl:template match="attval">
    <xsl:text/>£strc[<xsl:value-of select="string-length(.) div 2.5"/>em]{"<xsl:text/>
    <xsl:apply-templates/>
    <xsl:text>"}</xsl:text>
  </xsl:template>

<xsl:template match="el">
  <xsl:text/>£strc[<xsl:value-of select="string-length(.) div 2.5"/>em]{<xsl:text/>
  <xsl:choose>
  <xsl:when test="contains(@role,'starttag')">
    <xsl:text>£textless </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>£textgreater </xsl:text>
  </xsl:when>
  <xsl:when test="contains(@role,'endtag')">
    <xsl:text>£textless/</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>£textgreater </xsl:text>
  </xsl:when>
  <xsl:when test="contains(@role,'emptytag')">
    <xsl:text>£textless </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>/£textgreater </xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- hack for OT encoding -->
<xsl:template match="kw">
  <xsl:text/>£strc[<xsl:value-of select="string-length(.) div 2.5"/>em]{<xsl:text/>
  <xsl:choose>
  <xsl:when test="@role='entity'">
    <xsl:text>&amp;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>;</xsl:text>
  </xsl:when>
  <xsl:when test="@role='mchar'">
    <xsl:text>£textless mchar name=£linebreak[0]"</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>" /£textgreater </xsl:text>
  </xsl:when>
  <xsl:when test="@role">
    <xsl:text>Error: </xsl:text>
    <xsl:apply-templates/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="eg/kw">
  <xsl:value-of select="."/>
</xsl:template>


<xsl:template match="kw[@role='parsing_ref']" priority="10">
  <xsl:value-of select="replace(.,'[\.\-]','$0£linebreak[0]')"/>
</xsl:template>


<xsl:template match="var">
  <xsl:text>£(</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£)</xsl:text>
</xsl:template>

<xsl:template match="sub/var">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sup/var">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sub">
  <xsl:text>£(£sub££</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£££)</xsl:text>
</xsl:template>

<xsl:template match="sup">
  <xsl:text>£(£sup££</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£££)</xsl:text>
</xsl:template>

<!-- hack for TeX logo -->
<xsl:template match="sub[.='E' and starts-with(following-sibling::text()[1],'X')]">
  <xsl:text>£TTeX{}</xsl:text>
</xsl:template>

<!-- Lists -->

<xsl:template match="blist">
  <xsl:text>£begin{thebibliography}{99}</xsl:text>
  <xsl:apply-templates>
   <xsl:sort select="@id"/>
  </xsl:apply-templates>
  <xsl:text>£end{thebibliography}</xsl:text>
</xsl:template>

<xsl:template match="slist">
  <xsl:text>&#xA;£begin{itemize}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{itemize}&#xA;</xsl:text>
</xsl:template>

<xsl:template match="sitem">
  <xsl:text>&#xA;£item </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="blist/bibl">
  <xsl:choose>
    <xsl:when test="@key">
      <xsl:text>£bibitem[</xsl:text>
      <xsl:value-of select="@key"/>
      <xsl:text>]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>£bibitem[</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>]</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>{</xsl:text>
    <xsl:value-of select="@id"/>
  <xsl:text>}</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="orglist">
  <xsl:text>£begin{itemize}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{itemize}</xsl:text>
</xsl:template>

<xsl:template match="member">
  <xsl:text>£item </xsl:text>
  <xsl:apply-templates select="name"/>
  <xsl:if test="role">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="role"/>
    <xsl:text>) </xsl:text>
  </xsl:if>
  <xsl:if test="affiliation">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates select="affiliation"/>
  </xsl:if>
</xsl:template>

<xsl:template match="member/affiliation">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="member/role">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="olist">
  <xsl:text>£begin{enumerate}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{enumerate}</xsl:text>
</xsl:template>

<xsl:template match="ulist">
  <xsl:text>£begin{itemize}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{itemize}</xsl:text>
</xsl:template>

<xsl:template match="glist">
  <xsl:text>£begin{description}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£end{description}</xsl:text>
</xsl:template>

<xsl:template match="item">
  <xsl:text>£item </xsl:text>
  <xsl:if test="@id">
   <xsl:text>£label{</xsl:text>
   <xsl:value-of select="@id"/>
   <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="label">
  <xsl:text>£item[{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}] </xsl:text>
  <xsl:if test="@id">£label{<xsl:value-of select="@id"/>}</xsl:if>
  <xsl:if test="ancestor::div1/@id='media-types-reg'">£raggedright </xsl:if>
</xsl:template>

<xsl:template match="def">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="gitem">
  <xsl:apply-templates/>
</xsl:template>

<!-- Named templates -->

<xsl:template name="copyright">
  <xsl:text>Copyright £copyright£ </xsl:text>
  <xsl:value-of select="$copyright"/>
  <xsl:text>~W3C£textsuperscript{£textregistered}£ (MIT, ERCIM, Keio, Beihang),
  All Rights Reserved.</xsl:text>
  <xsl:text>£href{http://www.w3.org/Consortium/Legal/ipr-notice.html#Legal_Disclaimer}
   {W3C liability},
    £href{http://www.w3.org/Consortium/Legal/ipr-notice.html#W3C_Trademarks}{trademark},
    £href{http://www.w3.org/Consortium/Legal/copyright-documents.html}{document use}
    and
    £href{http://www.w3.org/Consortium/Legal/copyright-software.html}
     {software licensing}
     rules apply.£par
  </xsl:text>
</xsl:template>

<!-- produce a cross-reference target for the current element -->
<xsl:template name="makeanchor">
  <xsl:text>£label{</xsl:text>
  <xsl:choose>
    <xsl:when test="@id">
      <xsl:value-of select="@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id(.)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- produce a cross-reference to the current element -->
<xsl:template name="makeref">
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="generate-id(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="self::div[head]">
      <xsl:apply-templates select="head/node()"/>
    </xsl:when>
    <xsl:when test="self::div1 and ancestor::body">
      <xsl:text>Chapter~£ref{</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:when test="contains(name(.), 'div1') and ancestor::back">
      <xsl:text>Appendix~£ref{</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:when test="contains(name(.), 'div')">
      <xsl:text>Section~£ref{</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:when test="name(.) = 'interface'">
      <xsl:text>[£texttt{</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>} interface]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>£ref{</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="nt">
  <xsl:text>£hyperref[</xsl:text>
  <xsl:value-of select="@def"/>
  <xsl:text>]{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="xnt">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="quote">
  <xsl:text>`</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>'</xsl:text>
</xsl:template>

<xsl:template match="graphic">
  <xsl:choose>
    <xsl:when test="@role='inline'">
      <xsl:if test="@valign='bottom'">£leavevmode£setbox0£hbox{</xsl:if>
      <xsl:text>£( </xsl:text>
      <xsl:value-of select="@alt"/>
       <xsl:text> £)</xsl:text>
      <xsl:if test="@valign='bottom'">}£raise£dp0£box0£relax </xsl:if>
    </xsl:when>
    <xsl:when test="contains(@source,'.png') and not(contains(@alt,'\'))">
      <xsl:text>&#10;£par£includegraphics</xsl:text>
<xsl:if test="starts-with(@source,'image/mpadded-')">[scale=0.6]</xsl:if>
      <xsl:text>{</xsl:text>
      <xsl:value-of select="substring-before(@source,'.png')"/>
      <xsl:text>}£par&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>{£large£[ </xsl:text>
      <xsl:value-of select="@alt"/>
       <xsl:text> £]£par}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Templates for DOM-style interface definitions  -->
<xsl:template match="interface">
  <xsl:text>£subsection*{Interface </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>}</xsl:text>
  <xsl:call-template name="makeanchor"/>
  <xsl:if test="string-length(normalize-space(@inherits))&gt;0">
    <xsl:text>
    £textbf{Extends:}
    </xsl:text>
    <xsl:call-template name="dom-type-inherits">
      <xsl:with-param name="typestring" select="@inherits"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:text>
  £par
  </xsl:text>
  <xsl:apply-templates select="descr"/>
  <xsl:if test="count(attribute) > 0">
    <xsl:text>£paragraph{Attributes}</xsl:text>
    <xsl:text>£begin{description}</xsl:text>
      <xsl:apply-templates select="attribute"/>
    <xsl:text>£end{description}</xsl:text>
  </xsl:if>
  <xsl:if test="count(method) > 0">
    <xsl:text>£paragraph{Methods}</xsl:text>
    <xsl:text>£begin{description}</xsl:text>
      <xsl:apply-templates select="method"/>
    <xsl:text>£end{description}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="attribute">
  <xsl:text>£item[£DomAttName{</xsl:text>
    <xsl:value-of  select="@name"/>
  <xsl:text>} of type </xsl:text>
    <xsl:call-template name="dom-type"/>
    <xsl:if test="@readonly='yes'">
      <xsl:text>, readonly</xsl:text>
    </xsl:if>
  <xsl:text>]</xsl:text>
  <xsl:apply-templates select="descr"/>
  <xsl:apply-templates select="setraises"/>
  <xsl:apply-templates select="getraises"/>
</xsl:template>


<xsl:template match="setraises[exception]">
  <xsl:text>£begin{description}</xsl:text>
  <xsl:apply-templates select="exception"/>
  <xsl:text>£end{description}</xsl:text>
</xsl:template>

<xsl:template match="exception">
  <xsl:text>£item[</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>]</xsl:text>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="descr">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="definitions">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="method">
  <xsl:text>£item[£DomMethodName{</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>}]£mbox{}£\</xsl:text>
  <xsl:apply-templates select="descr"/>
  <xsl:if test="count(parameters/param) > 0">
  <xsl:text>£par£textbf{Parameters}£par </xsl:text>
    <xsl:text>£begin{tabularx}{£linewidth}{llX}</xsl:text>
    <xsl:apply-templates select="parameters/param"/>
    <xsl:text>£end{tabularx}</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="returns"/>
  <xsl:apply-templates select="raises"/>
</xsl:template>

<xsl:template match="param">
  <xsl:call-template name="dom-type"/>
   <xsl:text>£tablecell £texttt{</xsl:text>
   <xsl:value-of select="@name"/>
   <xsl:text>}£tablecell </xsl:text>
  <xsl:apply-templates select="descr"/>
  <xsl:text>£tabularnewline</xsl:text>
</xsl:template>

<xsl:template match="returns">
  <xsl:text>£par£textbf{Return value}£par </xsl:text>
    <xsl:text>£begin{tabularx}{£linewidth}{lX}</xsl:text>
    <xsl:call-template name="dom-type"/>
    <xsl:text>£tablecell </xsl:text>
    <xsl:apply-templates select="descr"/>
    <xsl:text>£end{tabularx}£par </xsl:text>
</xsl:template>

<xsl:template name="dom-type-inherits">
 <xsl:param name="typestring"/>
 <xsl:choose>
  <xsl:when test="contains($typestring,',')">
   <xsl:call-template name="dom-type">
    <xsl:with-param name="type" select="normalize-space(substring-before($typestring,','))"/>
   </xsl:call-template>
   <xsl:text xml:space="preserve">, </xsl:text>
   <xsl:call-template name="dom-type-inherits">
    <xsl:with-param name="typestring" select="normalize-space(substring-after($typestring,','))"/>
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:call-template name="dom-type">
    <xsl:with-param name="type" select="$typestring"/>
   </xsl:call-template>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="dom-type">
 <xsl:param name="type" select="@type"/>
 <xsl:text>£texttt{</xsl:text>
 <xsl:choose>
 <xsl:when test="starts-with($type, 'MathML')">
 <xsl:text>£hyperref[</xsl:text
   >dom_<xsl:value-of select="substring-after($type, 'MathML')"/>
 <xsl:text>]</xsl:text>
 </xsl:when>
 <xsl:when test="$type = 'DOMString'">
 <xsl:text>£href{</xsl:text
 >http://www.w3.org/TR/DOM-Level-2-Core/core.html#DOMString<xsl:text
  >}</xsl:text>
 </xsl:when>
<xsl:when test="$type = 'Document'">
 <xsl:text>£href{</xsl:text
 >http://www.w3.org/TR/DOM-Level-2-Core/core.html#i-Document<xsl:text
  >}</xsl:text>
</xsl:when>
 <xsl:otherwise>
 <xsl:text>£href{</xsl:text
  >http://www.w3.org/TR/DOM-Level-2-Core/core.html<xsl:text
  >}</xsl:text>
 </xsl:otherwise>
 </xsl:choose>
 <xsl:text>{</xsl:text>
  <xsl:value-of select="$type"/>
 <xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="raises">
  <xsl:choose>
    <xsl:when test="count(exception) > 0">
      <xsl:text>£par£textbf{Exceptions}£par </xsl:text>
      <xsl:text>£begin{description}</xsl:text>
      <xsl:apply-templates select="exception"/>
      <xsl:text>£end{description}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>This method raises no exceptions.£par </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="processing-instruction()">
  <xsl:choose>
    <xsl:when test="name(.)='generate-idl'">
      <xsl:text>£paragraph{IDL Definition}</xsl:text>
      <xsl:text>£begin{verbatim}£let £1</xsl:text>
      <xsl:apply-templates select="ancestor::interface"           mode="idl"/>
      <xsl:apply-templates select="ancestor::interface/attribute" mode="idl"/>
      <xsl:apply-templates select="ancestor::interface/method"    mode="idl"/>
      <xsl:text>};</xsl:text>
      <xsl:text>\end{verbatim}
</xsl:text>
    </xsl:when>
    <xsl:when test="name(.)='include-dtd'">
      <xsl:text>£verbatiminput{../pubtext/mathml.dtd}</xsl:text>
    </xsl:when>
    <xsl:when test="name(.)='generate-binding'">
      <xsl:choose>
        <xsl:when test="parent::div2/@id='dom-bindings_IDLBinding'">
          <xsl:apply-templates select="key('id','mathml-dom')" mode="IDLInterfaces"/>
<!-- UNCOMMENT NEXT LINE TO GENERATE IDL FILE IN THIS DIRECTORY -->
<!--           <xsl:apply-templates select="key('id','mathml-dom')" mode="extFileIDLInterfaces"/> -->
        </xsl:when>
        <xsl:when test="parent::div2/@id='dom-bindings_JavaBindings'">
          <xsl:apply-templates select="key('id','mathml-dom')" mode="javaInterfaces"/>
<!-- UNCOMMENT NEXT LINE TO GENERATE JAVA FILES IN DIRECTORY java/org/w3c/mathmldom -->
<!--           <xsl:apply-templates select="key('id','mathml-dom')" mode="extFileJavaInterfaces"/> -->
        </xsl:when>
        <xsl:when test="parent::div2/@id='dom-bindings_ECMABinding'">
          <xsl:apply-templates select="key('id','mathml-dom')" mode="ecmaInterfaces"/>
<!-- UNCOMMENT NEXT LINE TO GENERATE SEPARATE ECMASCRIPT BINDING FILE (HTML) -->
<!--           <xsl:apply-templates select="key('id','mathml-dom')" mode="extFileEcmaInterfaces"/> -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>£fbox{generate-binding processing instruction for unrecognized ID </xsl:text>
          <xsl:value-of select="parent::div2/@id"/>
          <xsl:text>}</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='generate-domInheritance'">
<!--       <dl> -->
      <xsl:text>£begin{itemize}&#xA;</xsl:text>
      <xsl:apply-templates select="key('id','mathml-dom')//interface[not(starts-with(normalize-space(@inherits),'MathML'))]" mode="showInheritance"/> 
<!--       </dl> -->
      <xsl:text>£end{itemize}&#xA;</xsl:text>
    </xsl:when>
    <xsl:when test="name(.)='generate-elements-index'">
<xsl:call-template name="index">
  <xsl:with-param name="a"
  select="//el[generate-id()=generate-id(key('elem',.)[1])]"/>
  <xsl:with-param name="key" select="'elem'"/>
 </xsl:call-template>
    </xsl:when>
    <xsl:when test="name(.)='generate-attributes-index'">
<xsl:call-template name="index">
  <xsl:with-param name="a"
  select="(//att|//td[@role='attname'])[generate-id()=generate-id(key('att',.)[1])]"/>
  <xsl:with-param name="key" select="'att'"/>
 </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>£fbox{Unrecognised processing instruction </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:key name="elem" match="el[not(@namespace) or @namespace='mathml']" use="."/>
<xsl:key name="att" match="att[not(@namespace) or @namespace='mathml']" use="."/>
<xsl:key name="att" match="td[@role='attname']" use="."/>

<xsl:template name="index">
<xsl:param name="a"/>
<xsl:param name="key"/>
£begin{description}
<xsl:for-each select="$a">
<xsl:sort select="."/>
<xsl:variable name="this" select="."/>
£item[<xsl:value-of select="."/>]
<xsl:for-each select="key($key,.)[not(ancestor::*/@diff='del')]/ancestor::*[self::div1 or
self::div2 or self::div3 or self::div4 or self::MMLdefinition][1]">
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="generate-id(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
<!--
<xsl:if test="head/el=$this
   or  self::div4[@id='contm_trig']/p[1]/table/tbody/tr/td/el=$this
   or  (head='Description' and ($this='none' or $this='mprescripts'))">
-->
<xsl:if test="head//el[contains(@role,'defn')]=$this">
  <xsl:text>£textbf</xsl:text>
</xsl:if>
    <xsl:text/>{£ref{<xsl:value-of select="$id"/>}}<xsl:text/>
<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
</xsl:for-each>

</xsl:for-each>
£end{description}
</xsl:template>



<xsl:template match="interface" mode="idl">
  <xsl:text>interface </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:if test="string-length(normalize-space(@inherits))&gt;0">
    <xsl:text>: </xsl:text>
    <xsl:value-of select="@inherits"/>
  </xsl:if>
  <xsl:text> {
</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="idl">
  <xsl:text xml:space="preserve">  </xsl:text>
  <xsl:if test="@readonly='yes'">
    <xsl:text>readonly </xsl:text>
  </xsl:if>
  <xsl:text>attribute </xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:text xml:space="preserve"> </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>;
</xsl:text>
</xsl:template>

<xsl:template match="method" mode="idl">
  <xsl:text xml:space="preserve">  </xsl:text>
  <xsl:value-of select="returns/@type"/>
  <xsl:text xml:space="preserve"> </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>(</xsl:text>
  <xsl:apply-templates select="parameters/param" mode="idl"/>
  <xsl:text>);
</xsl:text>
</xsl:template>

<xsl:template match="param" mode="idl">
  <xsl:if test="position() > 1">, </xsl:if>
  <xsl:choose>
    <xsl:when test="@attr">
      <xsl:value-of select="@attr"/>
      <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>inout </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="@type"/>
  <xsl:text xml:space="preserve"> </xsl:text>
  <xsl:value-of select="@name"/>
</xsl:template>

<!-- Default template (primarily for debugging purposes) -->
<xsl:template match="*">
  <xsl:message>
   unknown element <xsl:value-of select="name()"/>
   <xsl:for-each select="@*">[<xsl:value-of select="name()"/>="<xsl:value-of select="."/>"]</xsl:for-each>
  </xsl:message>
  <xsl:text>£fbox{&lt;</xsl:text>
  <xsl:value-of select="name(.)"/>
  <xsl:text>&gt;}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£fbox{&lt;/</xsl:text>
  <xsl:value-of select="name(.)"/>
  <xsl:text>&gt;}</xsl:text>
</xsl:template>



<xsl:template match="key('id','presm_maction')//gitem/label" priority="2">
  <xsl:text>£item[{£parbox[t]{£textwidth}{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}}] </xsl:text>
</xsl:template>



<!--
<xsl:template match="key('id','parsing:dtd')/eg" priority="2">
  <xsl:text>£begin{verbatim}£catcode123=1£catcode125=2£relax</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>£catcode123=12£catcode125=12£relax
\end{verbatim}</xsl:text>
</xsl:template>
-->



<!-- appendix c -->


<xsl:template match="MMLdefinition">
  <xsl:text>£subsubsection{MMLdefinition:
  £texttt{</xsl:text><xsl:value-of select="name"/>
  <xsl:text>}</xsl:text>
  <xsl:call-template name="makeanchor"/>
  <xsl:text>}
  £begin{description}
  </xsl:text>

  <xsl:apply-templates select="description"/>

  <xsl:apply-templates select="classification"/>

  <xsl:if test="MMLattribute">
  <xsl:text>£item[MMLattribute]£mbox{}£\
   £begin{tabularx}{£linewidth}{lXl}
   Name£tablecell Value£tablecell Default£\
   £hline
   </xsl:text>
  <xsl:for-each select="MMLattribute">
  <xsl:apply-templates/><xsl:text>£\</xsl:text>
  </xsl:for-each>
  <xsl:text>£end{tabularx}
  </xsl:text>
  </xsl:if>

  <xsl:if test="signature">
  <xsl:text>£item[Signature]</xsl:text>
  <xsl:for-each select="signature">
  <xsl:value-of select="."/><xsl:text>£par </xsl:text>
  </xsl:for-each>
  </xsl:if>


  <xsl:apply-templates select="property|MMLexample"/>

<xsl:text>£end{description}</xsl:text>

</xsl:template>



<xsl:template match="MMLexample">
<xsl:text>£item[Example]</xsl:text>
<xsl:apply-templates select="description"/>
<xsl:text>£begin{verbatim}</xsl:text>
<xsl:apply-templates select="text()"/>
<xsl:text>\end{verbatim}
</xsl:text>
</xsl:template>

<xsl:template match="classification">
<xsl:text>£item[Classification]</xsl:text>
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="attvalue|attname">
<xsl:apply-templates/><xsl:text>£tablecell</xsl:text>
</xsl:template>
<xsl:template match="attdefault">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="property">
<xsl:text>£item[Property]</xsl:text>
<xsl:apply-templates select="description"/>
<xsl:text>£begin{verbatim}</xsl:text>
<xsl:apply-templates select="text()"/>
<xsl:text>\end{verbatim}
</xsl:text>
</xsl:template>

<xsl:template match="description">
<xsl:text>£item[Description]</xsl:text>
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="MMLdefinition/name"/>


<xsl:template match="MMLdefinition/functorclass"/>


<xsl:template match="MMLdefinition/signature"/>



<xsl:template match="MMLdefinition/description">
<xsl:text>£item[Description]</xsl:text>
 <xsl:apply-templates/>
<xsl:text>£par See also </xsl:text>
   <xsl:variable name="x" 
     select="key('id',concat('contm_',normalize-space(preceding-sibling::name)))"/>
   <xsl:for-each select="$x|key('id','contm_trig')[not($x)]">
     <xsl:call-template name="makeref"/>
   </xsl:for-each><xsl:text>.£par</xsl:text>
</xsl:template>

<!-- IDL, Java, ECMAScript Bindings for DOM -->

<!-- Constant and Indentation String variables: -->

<xsl:variable name="lowerCaseString"><xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text></xsl:variable>
<xsl:variable name="upperCaseString"><xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text></xsl:variable>

<xsl:variable name="IDLindent0"><xsl:text>&#xA;</xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent1"><xsl:text xml:space="preserve">&#xA;  </xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent2"><xsl:text xml:space="preserve">&#xA;    </xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent3"><xsl:text xml:space="preserve">&#xA;      </xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent4"><xsl:text xml:space="preserve">&#xA;        </xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent5"><xsl:text xml:space="preserve">&#xA;        </xsl:text>
</xsl:variable>

<xsl:variable name="raisesIndent"><xsl:text xml:space="preserve">&#xA;                                               </xsl:text>
</xsl:variable>

<xsl:variable name="javaRaisesIndent"><xsl:text xml:space="preserve">&#xA;                                                         </xsl:text>
</xsl:variable>

<xsl:variable name="javaPackageDeclaration"><xsl:text xml:space="preserve">
package org.w3c.dom.mathml;&#xA;</xsl:text>
</xsl:variable>

<xsl:variable name="idlFileHeader">
  <xsl:text xml:space="preserve">

// File: mathml-dom.idl
#ifndef _MATHMLDOM_IDL_
#define _MATHMLDOM_IDL_

#include "dom.idl"

#pragma prefix "w3c.org"

module mathml_dom
{</xsl:text>
</xsl:variable>

<xsl:variable name="idlFileFooter">
  <xsl:text xml:space="preserve">&#xA;};&#xA;&#xA;#endif</xsl:text>
</xsl:variable>  

<!-- IDL Binding -->

<xsl:template match="div1[@id='mathml-dom']" mode="IDLInterfaces">
  <xsl:text>£begin{verbatim}</xsl:text>
  <xsl:value-of select="$idlFileHeader"/>
  <xsl:apply-templates mode="IDLgetForwardDeclarations"/> 
  <xsl:value-of select="$IDLindent1"/>
  <xsl:apply-templates mode="IDLInterfaces"/>
  <xsl:value-of select="$idlFileFooter"/>
  <xsl:text>\end{verbatim}</xsl:text>
</xsl:template>

<!-- IDL GetForwardDeclarations templates -->

<xsl:template mode="IDLgetForwardDeclarations" match="interface|constant[not(ancestor::interface)]">
  <xsl:variable name="thisInterface" select="@name"/>
  <xsl:if test="count(ancestor-or-self::*[ancestor::div1[@id='mathml-dom']]/preceding-sibling::*/descendant-or-self::*[(interface[normalize-space(@inherits)=$thisInterface]) or (param|attribute|returns)[normalize-space(@type)=$thisInterface]])>0">
    <xsl:value-of select="$IDLindent1"/>
    <xsl:text xml:space="preserve">interface </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template mode="IDLgetForwardDeclarations" match="*">
  <xsl:apply-templates mode="IDLgetForwardDeclarations"/>
</xsl:template>

<xsl:template mode="IDLgetForwardDeclarations" match="text()">
</xsl:template>


<!-- IDLInterfaces templates -->

<xsl:template match="interface" mode="IDLInterfaces">
  <xsl:value-of select="$IDLindent1"/>
  <xsl:text xml:space="preserve">interface </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:if test="string-length(normalize-space(@inherits))>0">
    <xsl:text xml:space="preserve"> : </xsl:text>
    <xsl:value-of select="@inherits"/>
  </xsl:if>
  <xsl:value-of select="$IDLindent1"/>
  <xsl:text>{</xsl:text>
  <xsl:apply-templates mode="IDLInterfaces"/>
  <xsl:value-of select="$IDLindent1"/>
  <xsl:text xml:space="preserve">};
  </xsl:text>
</xsl:template>

<xsl:template match="constant" mode="IDLInterfaces">
  <xsl:value-of select="$IDLindent2"/>const <xsl:value-of select="@type"/>
  <xsl:value-of select="substring('                    ',string-length(@type)+1)"/>
  <xsl:value-of select="@name"/>
  <xsl:value-of select="substring('                               ',string-length(@name)+1)"/>
  <xsl:text xml:space="preserve">= </xsl:text><xsl:value-of select="@value"/><xsl:text>;</xsl:text>     
</xsl:template>

<xsl:template match="attribute" mode="IDLInterfaces">
  <xsl:value-of select="$IDLindent2"/>
  <xsl:choose>
    <xsl:when test="normalize-space(@readonly)='yes'"><xsl:text xml:space="preserve">readonly </xsl:text></xsl:when>
    <xsl:otherwise><xsl:text xml:space="preserve">         </xsl:text></xsl:otherwise>
  </xsl:choose>
  <xsl:text xml:space="preserve">attribute </xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:value-of select="substring('                 ',string-length(@type)+1)"/>
  <xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@name"/><xsl:text>;</xsl:text>
  <xsl:apply-templates select="raises|setraises|getraises" mode="IDLInterfaces"/>
</xsl:template>

<xsl:template match="method" mode="IDLInterfaces">
  <xsl:value-of select="$IDLindent2"/>
  <xsl:value-of select="returns/@type"/>
  <xsl:value-of select="substring('                         ',string-length(returns/@type)+1)"/>
  <xsl:text xml:space="preserve"> </xsl:text>
  <xsl:value-of select="@name"/><xsl:text>(</xsl:text>
  <xsl:apply-templates select="parameters" mode="IDLInterfaces"/>
  <xsl:text>)</xsl:text>
  <xsl:apply-templates select="raises" mode="IDLInterfaces"/>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="parameters" mode="IDLInterfaces">
  <xsl:variable name="localParent"><xsl:value-of select="ancestor::method/@name"/></xsl:variable>
  <xsl:variable name="localParamIndent"><xsl:value-of select="$IDLindent2"/>
    <xsl:text xml:space="preserve">                         </xsl:text>
    <xsl:value-of select="substring('                                                                                   ',1,string-length($localParent)+2)"/>
  </xsl:variable>
  <xsl:for-each select="param">
    <xsl:if test="count(preceding-sibling::param)>0">
      <xsl:text>,</xsl:text>
      <xsl:value-of select="$localParamIndent"/>
    </xsl:if>
    <xsl:value-of select="./@attr"/><xsl:text xml:space="preserve"> </xsl:text>
    <xsl:value-of select="./@type"/><xsl:text xml:space="preserve"> </xsl:text>
    <xsl:value-of select="./@name"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="raises" mode="IDLInterfaces">
  <xsl:if test="count(exception)>0">
    <xsl:value-of select="$raisesIndent"/><xsl:text xml:space="preserve">raises(</xsl:text>
    <xsl:for-each select="exception">
      <xsl:variable name="localExceptionName" select="@name"/>
      <xsl:if test="count(preceding-sibling::exception[normalize-space(@name)=$localExceptionName])=0">
        <xsl:if test="count(preceding-sibling::exception[not(normalize-space(@name)=$localExceptionName)])!=0">
          <xsl:text>,</xsl:text>
          <xsl:value-of select="$raisesIndent"/>
        </xsl:if>
        <xsl:value-of select="$localExceptionName"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="setraises" mode="IDLInterfaces">
  <xsl:for-each select="exception">
    <xsl:variable name="localExceptionName" select="@name"/>
    <xsl:if test="count(preceding-sibling::exception[normalize-space(@name)=$localExceptionName])=0">
      <xsl:value-of select="$raisesIndent"/><xsl:text xml:space="preserve">// raises(</xsl:text>
      <xsl:value-of select="$localExceptionName"/><xsl:text xml:space="preserve">) on setting</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template match="getraises" mode="IDLInterfaces">
  <xsl:for-each select="exception">
    <xsl:variable name="localExceptionName" select="@name"/>
    <xsl:if test="count(preceding-sibling::exception[normalize-space(@name)=$localExceptionName])=0">
      <xsl:value-of select="$raisesIndent"/><xsl:text xml:space="preserve">// raises(</xsl:text>
      <xsl:value-of select="$localExceptionName"/><xsl:text xml:space="preserve">) on retrieval</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template match="text()" mode="IDLInterfaces">
</xsl:template>

<xsl:template match="*" mode="IDLInterfaces">
  <xsl:apply-templates mode="IDLInterfaces"/>
</xsl:template>


<!-- Java Binding -->

<xsl:template match="div1[@id='mathml-dom']" mode="javaInterfaces">
  <xsl:apply-templates mode="javaInterfaces" select=".//interface"/>
</xsl:template>

<xsl:template match="div1[@id='mathml-dom']" mode="extFileJavaInterfaces">
  <xsl:apply-templates mode="extFileJavaInterfaces" select=".//interface"/>
</xsl:template>

<!-- JavaFileHeader -->

<xsl:template name="javaFileHeader">
  <xsl:value-of select="$javaPackageDeclaration"/>
  <xsl:for-each select=".//attribute/@type|.//param/@type|.//returns/@type|@inherits|.//exception/@name">
    <xsl:apply-templates mode="javaGetExternalDeclarations" select="."/>
  </xsl:for-each>
</xsl:template>

<xsl:template mode="javaGetExternalDeclarations" match="text()">
</xsl:template>

<xsl:template mode="javaGetExternalDeclarations" match="@*">
  <xsl:variable name="targetType" select="normalize-space(.)"/>
  <xsl:if test="not(starts-with($targetType,'MathML') or $targetType='void' or $targetType='long' or $targetType='unsigned long' or $targetType='short' or $targetType='unsigned short' or $targetType='DOMString' or $targetType='boolean')">
    <xsl:variable name="localInterfaceParent" select="normalize-space(ancestor::interface/@name)"/>
    <xsl:variable name="firstCount" select="count(ancestor-or-self::*[ancestor::interface[normalize-space(@name)=$localInterfaceParent]]/preceding-sibling::*/descendant-or-self::*[self::attribute|self::returns|self::constant|self::param][normalize-space(@type)=$targetType])"/>
    <xsl:variable name="secondCount" select="count(ancestor-or-self::*[ancestor::interface[normalize-space(@name)=$localInterfaceParent]]/preceding-sibling::*/descendant-or-self::exception[normalize-space(@name)=$targetType])"/>
    <xsl:if test="not(normalize-space(ancestor::interface[@inherits])=$targetType) and $firstCount=0 and $secondCount=0">
      <xsl:call-template name="javaImportExternal">
        <xsl:with-param name="theSource">dom</xsl:with-param>
        <xsl:with-param name="theEntity" select="$targetType"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="javaImportExternal">
  <xsl:param name="theSource"/>
  <xsl:param name="theEntity"/>
  <xsl:if test="string-length(normalize-space($theEntity))>0 and string-length(normalize-space($theSource))>0">
    <xsl:text xml:space="preserve">&#xA;import org.w3c.</xsl:text><xsl:value-of select="$theSource"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$theEntity"/>
    <xsl:text>;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- javaInterfaces Templates -->

<xsl:template match="interface" mode="javaInterfaces">
  <xsl:text>£subsection{org/w3c/mathmldom/</xsl:text>
  <xsl:value-of select="@name"/><xsl:text>.java}</xsl:text>
  <xsl:text>£begin{verbatim}£let £1&#xA;</xsl:text>
    <xsl:call-template name="javaFileHeader" />
    <xsl:value-of select="$IDLindent0"/>
    <xsl:value-of select="$IDLindent0"/>
    <xsl:text xml:space="preserve">public interface </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:if test="string-length(normalize-space(@inherits))>0">
      <xsl:text xml:space="preserve"> extends </xsl:text>
      <xsl:value-of select="@inherits"/>
    </xsl:if>
    <xsl:value-of select="$IDLindent0"/>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates mode="javaInterfaces"/>
    <xsl:value-of select="$IDLindent0"/>
    <xsl:text xml:space="preserve">};&#xA;\end{verbatim}&#xA;</xsl:text>
</xsl:template>

<xsl:template name="javaTranslateTypeName">
  <xsl:param name="targetType" select="normalize-space(@type)"/>
  <xsl:choose>
    <xsl:when test="$targetType='DOMString'">
      <xsl:text>String</xsl:text>
    </xsl:when>
    <xsl:when test="$targetType='unsigned long' or $targetType='long'">
      <xsl:text>int</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$targetType"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="javaTranslateProcName">
  <xsl:param name="whichMode" select="get"/>
  <xsl:param name="attribName" select="normalize-space(@name)"/>
  <xsl:choose>
    <xsl:when test="$whichMode='set'">
      <xsl:text>set</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>get</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="translate(substring($attribName,1,1),$lowerCaseString,$upperCaseString)"/>
  <xsl:value-of select="substring($attribName,2)"/>
</xsl:template>

<xsl:template match="constant" mode="javaInterfaces">
  <xsl:value-of select="$IDLindent2"/><xsl:text xml:space="preserve">public static final </xsl:text>
  <xsl:variable name="javaTypeName">
    <xsl:call-template name="javaTranslateTypeName">
      <xsl:with-param name="targetType" select="@type"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$javaTypeName"/>
  <xsl:value-of select="substring('                      ',string-length($javaTypeName)+1)"/>
  <xsl:value-of select="@name"/>
  <xsl:value-of select="substring('                          ',string-length(@name)+1)"/>
  <xsl:text xml:space="preserve">= </xsl:text><xsl:value-of select="@value"/><xsl:text>;</xsl:text>     
</xsl:template>

<xsl:template match="attribute" mode="javaInterfaces">
  <xsl:value-of select="$IDLindent2"/><xsl:text xml:space="preserve">public </xsl:text>
  <xsl:variable name="javaTypeName">
    <xsl:call-template name="javaTranslateTypeName">
      <xsl:with-param name="targetType" select="@type"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$javaTypeName"/>
  <xsl:value-of select="substring('                      ',string-length($javaTypeName)+1)"/>
  <xsl:text xml:space="preserve"> </xsl:text>
  <xsl:call-template name="javaTranslateProcName">
    <xsl:with-param name="attribName" select="@name"/>
    <xsl:with-param name="whichMode" select="get"/>
  </xsl:call-template>
  <xsl:text>()</xsl:text>
  <xsl:for-each select="getraises">
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  <xsl:text>;</xsl:text>
  <xsl:if test="not(normalize-space(@readonly)='yes')">
    <xsl:value-of select="$IDLindent2"/><xsl:text>public void</xsl:text>
    <xsl:value-of select="substring('                      ',string-length('void')+1)"/>
    <xsl:text xml:space="preserve"> </xsl:text>
    <xsl:call-template name="javaTranslateProcName">
      <xsl:with-param name="attribName" select="@name"/>
      <xsl:with-param name="whichMode">set</xsl:with-param>
    </xsl:call-template>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$javaTypeName"/>
    <xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="normalize-space(@name)"/>
    <xsl:text>)</xsl:text>
    <xsl:for-each select="setraises">
      <xsl:apply-templates select="." mode="javaInterfaces"/>
    </xsl:for-each>
    <xsl:text>;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="setraises|getraises|raises" mode="javaInterfaces">
  <xsl:if test="count(exception[string-length(normalize-space(@name))>0])">
    <xsl:value-of select="$javaRaisesIndent"/><xsl:text xml:space="preserve">throws </xsl:text>
    <xsl:for-each select="exception">
      <xsl:variable name="localExceptionName" select="normalize-space(@name)"/>
      <xsl:if test="string-length($localExceptionName)>0 and count(preceding-sibling::exception[normalize-space(@name)=$localExceptionName])=0">
        <xsl:if test="count(preceding-sibling::exception[not(normalize-space(@name)=$localExceptionName)])>0">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="$localExceptionName"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template match="method" mode="javaInterfaces">
  <xsl:value-of select="$IDLindent2"/><xsl:text xml:space="preserve">public </xsl:text>
  <xsl:variable name="javaTypeName">
    <xsl:call-template name="javaTranslateTypeName">
      <xsl:with-param name="targetType" select="returns/@type"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$javaTypeName"/>
  <xsl:value-of select="substring('                      ',string-length($javaTypeName)+1)"/>
  <xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@name"/><xsl:text>(</xsl:text>
  <xsl:apply-templates select="parameters" mode="javaInterfaces"/>
  <xsl:text>)</xsl:text>
  <xsl:apply-templates select="raises" mode="javaInterfaces"/>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="parameters" mode="javaInterfaces">
  <xsl:variable name="localParent"><xsl:value-of select="parent::method/@name"/></xsl:variable>
  <xsl:variable name="localParamIndent"><xsl:value-of select="$IDLindent2"/>
    <xsl:text xml:space="preserve">                      </xsl:text>
    <xsl:value-of select="substring('                                                                                   ',1,string-length($localParent) + string-length('public ( '))"/>
  </xsl:variable>
  <xsl:for-each select="param">
    <xsl:if test="count(preceding-sibling::param)>0">
      <xsl:text>,</xsl:text>
      <xsl:value-of select="$localParamIndent"/>
    </xsl:if>
    <xsl:call-template name="javaTranslateTypeName"/>
    <xsl:text xml:space="preserve"> </xsl:text>
    <xsl:value-of select="./@name"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="text()" mode="javaInterfaces">
</xsl:template>

<xsl:template match="*" mode="javaInterfaces">
<!--   <xsl:apply-templates mode="javaInterfaces"/> -->
</xsl:template>


<!-- ECMAScript Binding -->

<xsl:template match="div1[@id='mathml-dom']" mode="ecmaInterfaces">
  <xsl:apply-templates mode="ecmaInterfaces" select=".//interface"/>
</xsl:template>


<xsl:template match="interface" mode="ecmaInterfaces">
  <xsl:if test="count(constant) > 0">
    <xsl:text xml:space="preserve">£subsection{Class </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>}&#xA;The £textbf{</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text xml:space="preserve">} class has the following constants:&#xA;&#xA;</xsl:text>
    <xsl:text>£begin{description}&#xA;</xsl:text>
    <xsl:apply-templates select="constant" mode="ecmaInterfaces"/>
    <xsl:text>&#xA;£end{description}&#xA;</xsl:text>
  </xsl:if>
  <xsl:text xml:space="preserve">£subsection{Object </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>}</xsl:text>
  <xsl:if test="string-length(normalize-space(@inherits))>0">
    <xsl:text>£textbf{</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text xml:space="preserve">} has all the properties and methods of </xsl:text>
    <xsl:text>£textbf{</xsl:text>
    <xsl:value-of select="@inherits"/>
    <xsl:text xml:space="preserve">} as well as the properties and methods defined below.&#xA;</xsl:text>
  </xsl:if>
  <xsl:if test="count(attribute) > 0 or count(method) > 0">
<!--     <xsl:text>£begin{itemize}&#xA;</xsl:text> -->
    <xsl:text>£begin{description}&#xA;</xsl:text>
    <xsl:if test="count(attribute) > 0">
      <xsl:text xml:space="preserve">£item The £textbf{</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text xml:space="preserve">} object has the following properties:</xsl:text>
      <xsl:text>&#xA;£begin{description}&#xA;</xsl:text>
      <xsl:apply-templates select="attribute" mode="ecmaInterfaces"/>
      <xsl:text>£end{description}&#xA;</xsl:text>
    </xsl:if>
    <xsl:if test="count(method) > 0">
      <xsl:text xml:space="preserve">£item The £textbf{</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text xml:space="preserve">} object has the following methods:</xsl:text>
      <xsl:text>&#xA;£begin{description}&#xA;</xsl:text>
      <xsl:apply-templates select="method" mode="ecmaInterfaces"/>
      <xsl:text>£end{description}&#xA;</xsl:text>
    </xsl:if>
<!--     <xsl:text>£end{itemize}&#xA;</xsl:text> -->
    <xsl:text>£end{description}&#xA;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="constant" mode="ecmaInterfaces">
  <xsl:text>£item[£textbf{</xsl:text>
  <xsl:value-of select="parent::interface/@name"/>
  <xsl:text>.</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text xml:space="preserve">}]This constant is of type £textbf{</xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:text xml:space="preserve">} and its value is </xsl:text>
  <xsl:value-of select="@value"/>
  <xsl:text>.&#xA;</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="ecmaInterfaces">
  <xsl:text>£item[£textbf{</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text xml:space="preserve">}]This property is of type £textbf{</xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:text>}.&#xA;</xsl:text>
</xsl:template>

<xsl:template match="method" mode="ecmaInterfaces">
  <xsl:text>£item[£textbf{</xsl:text>
  <xsl:value-of select="@name"/><xsl:text>(</xsl:text>
  <xsl:for-each select="parameters/param">
    <xsl:if test="count(preceding-sibling::param) > 0">
      <xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:value-of select="@name"/>
  </xsl:for-each>
  <xsl:text>)}]</xsl:text>
  <xsl:variable name="returnType" select="normalize-space(returns/@type)"/>
  <xsl:choose>
    <xsl:when test="string-length($returnType) = 0">
      <xsl:text xml:space="preserve">This method returns a £textbf{void}</xsl:text>
    </xsl:when>
    <xsl:when test="contains('aeiou',substring($returnType,1,1))">
      <xsl:text xml:space="preserve">This method returns an £textbf{</xsl:text>
    <xsl:value-of select="$returnType"/><xsl:text>}.</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text xml:space="preserve">This method returns a £textbf{</xsl:text>
      <xsl:value-of select="$returnType"/><xsl:text>}.</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="parameters" mode="ecmaInterfaces"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="parameters" mode="ecmaInterfaces">
  <xsl:for-each select="param">
    <xsl:text xml:space="preserve"> The £textbf{</xsl:text>
    <xsl:value-of select="./@name"/>
    <xsl:text xml:space="preserve">} parameter is of type £textbf{</xsl:text>
    <xsl:value-of select="./@type"/><xsl:text>}.</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="raises|setraises|getraises" mode="ecmaInterfaces">
</xsl:template>

<xsl:template match="text()" mode="ecmaInterfaces">
</xsl:template>

<xsl:template match="*" mode="ecmaInterfaces">
  <xsl:apply-templates mode="ecmaInterfaces"/>
</xsl:template>


<!-- Generating DOM Inheritance Chart -->
<xsl:template match="interface" mode="showInheritance">
  <xsl:variable name="thisName" select="normalize-space(@name)"/>
  <xsl:variable name="theReference">
    <xsl:choose> 
    <xsl:when test="starts-with($thisName,'MathML')">

      <xsl:text>£hyperref[</xsl:text
      >dom_<xsl:value-of select="substring-after($thisName, 'MathML')"/>
      <xsl:text>]{</xsl:text>
      <xsl:value-of select="$thisName"/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$thisName"/>
    </xsl:otherwise>
    </xsl:choose> 
  </xsl:variable>
  <xsl:choose>
  <xsl:when test="count(ancestor::div1//interface[normalize-space(@inherits)=$thisName]) > 0">
    <xsl:text>£item </xsl:text>
    <xsl:copy-of select="$theReference"/>
    <xsl:text>&#xA;£begin{itemize}&#xA;</xsl:text>
      <xsl:apply-templates select="ancestor::div1//interface[normalize-space(@inherits)=$thisName]" mode="showInheritance"/>
    <xsl:text>&#xA;£end{itemize}&#xA;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>£item </xsl:text>
    <xsl:copy-of select="$theReference"/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="showInheritance">
</xsl:template>

<xsl:template match="text()" mode="showInheritance">
</xsl:template>







<xsl:template match="prod">
      <xsl:apply-templates
        select="lhs |
                rhs[preceding-sibling::*[1][name()!='lhs']] |
                com[preceding-sibling::*[1][name()!='rhs']] |
                constraint[preceding-sibling::*[1][name()!='rhs']] |
                vc[preceding-sibling::*[1][name()!='rhs']] |
                wfc[preceding-sibling::*[1][name()!='rhs']]"/>
</xsl:template>

  <xsl:template match="prodgroup/prod">
    <xsl:apply-templates
      select="lhs |
              rhs[preceding-sibling::*[1][name()!='lhs']] |
              com[preceding-sibling::*[1][name()!='rhs']] |
              constraint[preceding-sibling::*[1][name()!='rhs']] |
              vc[preceding-sibling::*[1][name()!='rhs']] |
              wfc[preceding-sibling::*[1][name()!='rhs']]"/>
  </xsl:template>

  <!-- prodgroup: group of formal productions -->
  <!-- create one <tbody> for each group -->

<xsl:template match="prodgroup">
      <xsl:apply-templates/>
</xsl:template>



 <!-- lhs: left-hand side of formal productions -->
  <!-- make a table row with the lhs and the corresponding other
       pieces in this crazy mixed-up content model -->
  <xsl:template match="lhs">
          <xsl:text>{}£refstepcounter{prod}[£theprod]£label{</xsl:text>
          <xsl:value-of select="parent::prod/@id"/>
          <xsl:text>}</xsl:text>
        <xsl:text>&#xa0;&#xa0;&#xa0;</xsl:text>
  <xsl:text>£tablecell </xsl:text>
        <code><xsl:apply-templates/></code>
  <xsl:text>£tablecell </xsl:text>
        <xsl:text>&#xa0;&#xa0;&#xa0;::=&#xa0;&#xa0;&#xa0;</xsl:text>
  <xsl:text>£tablecell </xsl:text>
      <xsl:apply-templates
        select="following-sibling::*[1][name()='rhs']"/>
  </xsl:template>

  <xsl:template match="rhs">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='lhs']">
<!-- td -->
          <code><xsl:apply-templates/></code>
  <xsl:text>£tablecell </xsl:text>
        <xsl:apply-templates
          select="following-sibling::*[1][name()='com' or
                                          name()='constraint' or
                                          name()='vc' or
                                          name()='wfc']"/>
      </xsl:when>
      <xsl:otherwise>
  <xsl:text>£tablecell£tablecell£tablecell </xsl:text>
            <code><xsl:apply-templates/></code>
  <xsl:text>£tablecell </xsl:text>
          <xsl:apply-templates
            select="following-sibling::*[1][name()='com' or
                                            name()='constraint' or
                                            name()='vc' or
                                            name()='wfc']"/>
      </xsl:otherwise>
    </xsl:choose>
£tabularnewline
  </xsl:template>


  <xsl:template match="com">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='rhs']">
          £textit{/*
            <xsl:apply-templates/>
            <xsl:text> */}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
  <xsl:text>£tablecell£tablecell£tablecell </xsl:text>
              <xsl:text>£small£textit{/* </xsl:text>
              <xsl:apply-templates/>
              <xsl:text> */}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="scrap">
    <xsl:apply-templates select="head"/>
£par£noindent£begin{tabularx}{£linewidth}{@{}l@{}l@{}l>{£raggedright}Xllll@{}}
      <xsl:apply-templates select="bnf | prod | prodgroup"/>
£end{tabularx}£par£filbreak£par
</xsl:template>

  <xsl:template match="scrap/head" priority="10">
    <xsl:text>&#10;£paragraph{</xsl:text>
      <xsl:apply-templates/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>


<xsl:template match="table//eg" priority="10000">
  <xsl:text>&#10;£begin{tt}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;£end{tt}&#10;</xsl:text>
</xsl:template>

<xsl:template match="table//eg//text()" priority="10000">
  <xsl:value-of select="replace(replace(replace(.,'&#10;','£linebreak&#10;'),
			'^\s*£linebreak',''),' ','£mbox{ }')"/>
</xsl:template>

<xsl:variable name="relax-schema">
<xsl:for-each select="('mathml3','mathml3-common','mathml3-presentation','mathml3-strict-content','mathml3-content')">
<div3 id="parsing_{.}">
<head><xsl:value-of select="."/></head>
<eg>
<xsl:for-each select="tokenize(unparsed-text(concat('../../../RelaxNG/mathml3/',.,'.rnc')),'&#13;?&#10;')">
<xsl:analyze-string select="." regex="(^ *#(ednote\((.*?)\))?(.*)$|pattern =.*$|(element|attribute) *([a-zA-Z_]+|\([^\)]*\))|(([_A-Za-z.0-9\-:/]+)([/\\()=right]*&quot;| *=)?))">
<xsl:matching-substring>
  <xsl:choose>
    <xsl:when test=".='$Id:'"/>
    <xsl:when test="starts-with(.,'pattern =')">
      <xsl:value-of select="replace(.,'(\||,)','$1£dpcbreak.')"/>
    </xsl:when>
    <xsl:when test="matches(.,'^ *#ednote')">
      <issue role="open" id="{replace(regex-group(2),'[():]','_')}">
	<p>
	<xsl:value-of select="regex-group(3)"/>
	</p>
      </issue>
    </xsl:when>
    <xsl:when test="matches(.,'^ *#')">
      <phrase role="comment"><xsl:value-of select="replace(.,'\$Id:','')"/></phrase>
    </xsl:when>
    <xsl:when test="starts-with(.,'element (')">
      <kw>element</kw><xsl:text> </xsl:text><xsl:value-of select="substring-after(.,'element ')"/>
    </xsl:when>
    <xsl:when test="starts-with(.,'element ')">
      <kw>element</kw><xsl:text> </xsl:text><el><xsl:value-of select="substring-after(.,'element ')"/></el>
    </xsl:when>
    <xsl:when test="starts-with(.,'attribute ')">
      <kw>attribute</kw><xsl:text> </xsl:text><el><xsl:value-of select="substring-after(.,'attribute ')"/></el>
    </xsl:when>
    <xsl:when test="ends-with(.,'&quot;') or starts-with(.,'xsd:') or (.=('empty','text','notAllowed'))">
       <xsl:value-of select="."/>
    </xsl:when>
    <xsl:when test=".=('default','namespace','include')">
      <kw><xsl:value-of select="."/></kw>
    </xsl:when>
    <xsl:when test="ends-with(.,' =')">
      <kw role="parsing_def"><xsl:value-of select="substring-before(.,' =')"/></kw>
      <xsl:text> =</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <kw role="parsing_ref"><xsl:value-of select="."/></kw>
    </xsl:otherwise>
  </xsl:choose>
</xsl:matching-substring>
<xsl:non-matching-substring>
 <xsl:value-of select="replace(.,'(\||,)','$1£dpcbreak.')"/>
</xsl:non-matching-substring>
</xsl:analyze-string>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</eg>
</div3>
</xsl:for-each>
</xsl:variable>

<xsl:template match="div3[@id='parsing_rnc_pres']/eg" priority="111">
  <xsl:text>&#10;£begin{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-presentation']/eg/(node() except issue)"/>
  <xsl:text>&#10;\end{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-presentation']/eg/x-issue"/>
</xsl:template>

<!--
<xsl:template match="div3[@id='parsing_rnc_deprecated']/eg" priority="111">
  <xsl:text>&#10;£begin{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-deprecated']/eg/(node() except issue)"/>
  <xsl:text>&#10;\end{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-deprecated']/eg/x-issue"/>
</xsl:template>
-->

<xsl:template match="div3[@id='parsing_rnc_full']/eg" priority="111">
  <xsl:text>&#10;£begin{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3']/eg/(node() except issue)"/>
  <xsl:text>&#10;\end{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3']/eg/x-issue"/>
</xsl:template>

<xsl:template match="div3[@id='parsing_rnc_strict']/eg" priority="111">
  <xsl:text>&#10;£begin{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-strict-content']/eg/(node() except issue)"/>
  <xsl:text>&#10;\end{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-strict-content']/eg/x-issue"/>
</xsl:template>


<xsl:template match="div3[@id='parsing_rnc_content']/eg[1]" priority="111">
  <xsl:text>&#10;£begin{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-content']/eg/(node() except issue)"/>
  <xsl:text>&#10;\end{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-content']/eg/x-issue"/>
</xsl:template>

<!--
<xsl:template match="div3[@id='parsing_rnc_pragmatic']/eg[2]" priority="111">
  <xsl:text>&#10;£begin{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-cds-pragmatic']/eg/(node() except issue)"/>
  <xsl:text>&#10;\end{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-cds-pragmatic']/eg/x-issue"/>
</xsl:template>
-->


<xsl:template match="div3[@id='parsing_rnc_common']/eg" priority="111">
  <xsl:text>&#10;£begin{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-common']/eg/(node() except issue)"/>
  <xsl:text>&#10;\end{verbatim}&#10;</xsl:text>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-common']/eg/x-issue"/>
</xsl:template>

<xsl:template match="p/text()">
  <xsl:value-of select="replace(.,'([\\_^])','£verb|$1|')"/>
</xsl:template>


<xsl:template match="symbolref">
  <xsl:variable name="cduri" select="concat($cduriprefix,'/',@cd,'.xhtml')"/>
  <xsl:text>£href{</xsl:text>
  <xsl:value-of select="$cduri"/>
  <xsl:text>#</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>}{</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="cdref">
  <xsl:variable name="cduri" select="concat($cduriprefix,'/',@cd,'.xhtml')"/>
  <xsl:text>£href{</xsl:text>
  <xsl:value-of select="$cduri"/>
  <xsl:text>}{</xsl:text>
  <xsl:value-of select="@cd"/>
  <xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="ltable[@id=('table-flavor-a','table-flavor-b','table-flavor-c','table-flavor-d')]">
  <xsl:text>£begin{htable}</xsl:text>
  <xsl:apply-templates select="caption"/>
  <xsl:text>£begin{tabularx}{£linewidth}</xsl:text>
  <xsl:text>{l>£small X}</xsl:text>
  <xsl:apply-templates select="thead|tbody"/>
  <xsl:text>£end{tabularx}</xsl:text>
  <xsl:text>£end{htable}</xsl:text>
</xsl:template>

<xsl:template match="div">
 <xsl:text>£par </xsl:text>
 <xsl:if test="@role and @id and not(head)">
  <xsl:text>£label{</xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>}</xsl:text>
 </xsl:if>
 <xsl:apply-templates/>
 <xsl:text>£par </xsl:text>
</xsl:template>



<xsl:template match="div2[@id='oper-dict_entries-table']/table">
 <xsl:variable  name="c" select="'priority','lspace','rspace'"/>
 <xsl:variable  name="p" select="'fence','stretchy','separator','accent','largeop','movablelimits', 'symmetric'"/>
 <xsl:variable name="v" select="'linebreakstyle','minsize'"/>
<xsl:variable name="t">
 <table class="sortable">
   <thead>
     <tr>
       <xsl:for-each select="'Character','form',$c,'Properties'">
	 <td><xsl:value-of select="."/></td>
       </xsl:for-each>
     </tr>
   </thead>
   <tbody>
     <xsl:for-each select="doc('../../xml/unicode.xml')/unicode/charlist/character/operator-dictionary">
       <xsl:sort select="xs:integer(@priority)"/>
       <tr>
	 <xsl:variable name="od" select="."/>
	 <xsl:variable name="d" select="for $i in tokenize(../@dec,'-') return xs:integer($i)"/>
	 <td>£leavevmode
	   <xsl:choose>
	     <xsl:when test="$d[1]=123">£{</xsl:when>
	     <xsl:when test="$d[1]=125">£}</xsl:when>
	     <xsl:when test="$d[1]=163">£pounds </xsl:when>
	     <xsl:when test="empty($d[. &gt;127])">
	     <xsl:value-of select="replace(replace(codepoints-to-string($d),'&amp;','&amp;amp;'),'&lt;','&amp;lt;')"/>
	     </xsl:when>
	     <xsl:otherwise>
	       <xsl:value-of select="replace(../@id,'[U-]0*([0-9A-F]*)','&amp;#x$1;')"/>
	     </xsl:otherwise>
	   </xsl:choose>
	   <xsl:text>£newline £raisebox{4pt}[0pt]{£makebox[0pt][l]{£tiny </xsl:text>
	   <xsl:value-of select="lower-case(../description)"/>
	   <xsl:text>}}</xsl:text>
	 </td>
	 <td><xsl:value-of select="@form"/></td>
	 <xsl:for-each select="$c">
	   <td><xsl:value-of select="$od/@*[name()=current()]"/></td>
	 </xsl:for-each>
	 <td>
	   <xsl:value-of select="$p[$od/@*[.='true']/name()=.],
				 $od/@*[name()=$v]/concat(name(),'=',.)
				 " separator=", "/>
	 </td>
       </tr>
     </xsl:for-each>
   </tbody>
 </table>
</xsl:variable>
  {£footnotesize£par
  <xsl:text>£begin{longtable}[c]{p{3.2cm}lllllp{4.5cm}}</xsl:text>
  <xsl:apply-templates select="$t/table/thead"/>
  <xsl:text>£endhead</xsl:text>
  <xsl:apply-templates select="$t/table/tbody"/>
  <xsl:text>£end{longtable}</xsl:text>
  £par}
</xsl:template>


<xsl:template match="div4[@id='presm_mo_linebreaks']/eg" priority="10">
  {£par£footnotesize 
  <xsl:next-match/>
  £par}
</xsl:template>

<xsl:template match="div[@role=('strict-mathml-example','mathml-example')]
  [not(@id='quant1.forall.ex2')]">
<xsl:text>£begin{lrbox}{0}£begin{minipage}{£linewidth}</xsl:text>
 <xsl:if test="head">
   £textit{
  <xsl:apply-templates select="head" mode="header"/>
  <xsl:call-template name="makeanchor"/>
   }£par
 </xsl:if>
<xsl:next-match/>
<xsl:text>£end{minipage}£end{lrbox}£begin{center}£fboxsep=5pt £fbox{£box0}£end{center}£par£medskip£par&#10;</xsl:text>
</xsl:template>

<xsl:template match="*[@meta]/text()" priority="5">
  <xsl:variable name="r">
    <xsl:for-each select="tokenize(../@meta,'\s+')">
      <xsl:choose>
	<xsl:when test="matches(.,'^[a-z]+$')">
	  <xsl:value-of select="'&lt;',.,'/>|'" separator=""/>
	  <xsl:value-of select="'&lt;',.,'.*?','&lt;/',.,'>'" separator=""/>
	</xsl:when>
	<xsl:when test="starts-with(.,'#-')">
	  <xsl:value-of select="'[&gt; ]',substring(.,3),'[ &lt;]'" separator=""/>
	</xsl:when>
	<xsl:when test="starts-with(.,'@-')">
	  <xsl:value-of select="'=&quot;',substring(.,3),'&quot;'" separator=""/>
	</xsl:when>
	<xsl:otherwise>lost!!</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="position()!=last()">|</xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:analyze-string select="." regex="{$r}">
    <xsl:matching-substring>
      <xsl:choose>
	<xsl:when test="matches(.,'^[ &gt;]')">
	  <xsl:value-of select="substring(.,1,1)"/>
	  <xsl:text>£egmeta££</xsl:text>
	  <xsl:value-of select="substring(.,2,string-length(.)-2)"/>
	  <xsl:text>££</xsl:text>
	  <xsl:value-of select="substring(.,string-length(.))"/>
	</xsl:when>
	<xsl:when test="starts-with(.,'=&quot;')">
	  <xsl:text>=&quot;</xsl:text>
	  <xsl:text>£egmeta££</xsl:text>
	  <xsl:value-of select="translate(.,'=&quot;','')"/>
	  <xsl:text>££</xsl:text>
	  <xsl:text>&quot;</xsl:text>
	</xsl:when>
	<xsl:when test="starts-with(.,'&lt;ci&gt;') or starts-with(.,'&lt;mi&gt;')">
	  <xsl:text> </xsl:text>
      	<xsl:text>£egmeta££</xsl:text>
	<xsl:value-of select="substring(.,5,string-length(.)-9)"/>
	  <xsl:text>££</xsl:text>
	  <xsl:text> </xsl:text>
	</xsl:when>
      <xsl:otherwise>
	<xsl:text>£egmeta££</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>££</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:value-of select="."/>
    </xsl:non-matching-substring>
</xsl:analyze-string>
</xsl:template>

<xsl:template match="div1[@id='media-types-reg']//text()" priority="2">
<xsl:value-of select="replace(
  replace(.,'([\\_^])','£verb|$1|')
    ,'[\-\+/]','$0{£penalty0}')"/>
</xsl:template>

 </xsl:stylesheet>
