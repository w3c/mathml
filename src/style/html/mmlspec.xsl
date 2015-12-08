<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:m="http://www.w3.org/1998/Math/MathML"
		xmlns:ocd="http://www.openmath.org/OpenMathCD"
		exclude-result-prefixes="xs m ocd"
                version="2.0">


<xsl:import href="slices.xsl"/>
<xsl:import href="mcd.xsl"/>
<xsl:output method="html"
       encoding="utf-8"
       doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
       doctype-system="http://www.w3.org/TR/html4/loose.dtd"
       indent="no"
       use-character-maps="doe"/>

<xsl:param name="toc.level" select="3"/>
<!--
<xsl:param name="cduriprefix" select="'http://svn.openmath.org/OpenMath3/cd/MathML'"/>
-->
<xsl:param name="cduriprefix" select="'http://www.openmath.org/cd'"/>
<xsl:param name="cduriprefix2" select="'http://monet.nag.co.uk/~dpc/cdfiles2/cd'"/>

<xsl:character-map name="doe">
  <xsl:output-character character="&#1001;" string="&lt;"/>
  <xsl:output-character character="&#1002;" string="&gt;"/>
</xsl:character-map>

<!-- Extensions and parameterisation of xmlspec 
     These templates produce the same output as the standard xmlspec
     templates (and could be incorporated into later versions of
     xmlspec.xsl) but include extra parameterisation possibilities.
-->

<!-- for parameters, xmlspec defaults are commented out, mmlspec choices
are used, if these parameters were in xmlspec/slices, then only these
parameters would be needed here and the templates wouldnt need to be
copied -->


<!--
<xsl:param name="body.filename.base" select="'slice'"/>
<xsl:param name="back.filename.base" select="'slice'"/>
<xsl:param name="back.filename.format" select="'A'"/>
<xsl:param name="front.filename.base" select="'index'"/>
<xsl:param name="filename.extension" select="'.html'"/>


<xsl:param name="slice.depth" select="0"/>

<xsl:param name="title.before.navigation" select="0"/>

<xsl:param name="css.base.uri" select="'http://www.w3.org/StyleSheets/TR/'"/>
-->
<xsl:param name="body.filename.base" select="'chapter'"/>
<xsl:param name="back.filename.base" select="'appendix'"/>
<xsl:param name="back.filename.format" select="'a'"/>
<xsl:param name="front.filename.base" select="'Overview'"/>
<xsl:param name="filename.extension" select="'.html'"/>
<xsl:param name="validity.hacks" select="0"/><!--!!!!!!-->

<xsl:param name="slice.depth" select="1"/>

<xsl:param name="title.before.navigation" select="1"/>

<xsl:param name="css.base.uri" select="'http://www.w3.org/StyleSheets/TR/'"/>

<xsl:variable name="relax-schema">
<xsl:for-each select="('mathml3','mathml3-common','mathml3-presentation','mathml3-strict-content','mathml3-content')">
<div3 id="parsing_{.}">
<head><xsl:value-of select="."/></head>
<eg>
<xsl:for-each select="tokenize(unparsed-text(concat('../../../RelaxNG/mathml3/',.,'.rnc','-diff'[$show.diff.markup='1'])),'&#13;?&#10;')
[$show.diff.markup='0' or position()&gt;5][not(starts-with(.,'diff --ifdef'))]">
<xsl:analyze-string select="." regex="(^ *#(ednote\((.*?)\))?(.*)$|pattern =.*$|(element|attribute) *([\*\\a-zA-Z_\-]+|\([^\)]*\))|(([_A-Za-z.0-9\-:/]+)([/\\()=right]*&quot;| *=)?))">
<xsl:matching-substring>
  <xsl:choose>
    <xsl:when test=".='$Id:'"/>
    <xsl:when test="starts-with(.,'#ifdef diff')">
      <xsl:text>&#1001;span class="diff-add"&#1002;</xsl:text>
    </xsl:when>
    <xsl:when test="starts-with(.,'#ifndef diff')">
      <xsl:text>&#1001;span class="diff-del"&#1002;</xsl:text>
    </xsl:when>
    <xsl:when test="starts-with(.,'#else /* diff */')">
      <xsl:text>&#1001;/span&#1002;</xsl:text>
      <xsl:text>&#1001;span class="diff-add"&#1002;</xsl:text>
    </xsl:when>
    <xsl:when test="starts-with(.,'#endif')">
      <xsl:text>&#1001;/span&#1002;</xsl:text>
    </xsl:when>
    <xsl:when test="starts-with(.,'pattern =')">
      <xsl:value-of select="."/>
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
  <xsl:value-of select="."/>
  </xsl:non-matching-substring>
</xsl:analyze-string>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</eg>
</div3>
</xsl:for-each>
</xsl:variable>

<xsl:key name="parsing_def" match="kw[@role='parsing_def']" use="."/>

<xsl:template match="kw[@role='parsing_def'][key('parsing_def',.)[1] is .]" priority="2">
<b id="parsing_{.}"><xsl:value-of select="."/></b>
</xsl:template>
<xsl:template match="kw[@role='parsing_def']">
<b><xsl:value-of select="."/></b>
</xsl:template>

<xsl:template match="kw[@role='parsing_ref']">
<a>
  <xsl:attribute name="href">
    <xsl:call-template name="href.target">
      <xsl:with-param name="target" select="key('ids', 'parsing')"/>
    </xsl:call-template>
    <xsl:text>#parsing_</xsl:text>
    <xsl:value-of select="."/>
  </xsl:attribute>
  <xsl:value-of select="."/>
</a>
</xsl:template>

<xsl:template match="kw[@role='parsing_ref'][.=('definitionURL','encoding')]" priority="2">
<a>
  <xsl:attribute name="href">
    <xsl:call-template name="href.target">
      <xsl:with-param name="target" select="key('ids', 'parsing')"/>
    </xsl:call-template>
    <xsl:text>#parsing_DefEncAtt</xsl:text>
  </xsl:attribute>
  <xsl:value-of select="."/>
</a>
</xsl:template>

<xsl:template match="kw[@role='parsing_ref'][.=('scope','occurrence')]" priority="2">
<a>
  <xsl:attribute name="href">
    <xsl:call-template name="href.target">
      <xsl:with-param name="target" select="key('ids', 'parsing')"/>
    </xsl:call-template>
    <xsl:text>#parsing_declare</xsl:text>
  </xsl:attribute>
  <xsl:value-of select="."/>
</a>
</xsl:template>

<xsl:template match="div3[@id='parsing_rnc_pres']/eg" priority="111">
<pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-presentation']/eg/(node() except issue)"/>
</pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-presentation']/eg/issue"/>
</xsl:template>

<!--
<xsl:template match="div3[@id='parsing_rnc_deprecated']/eg" priority="111">
<pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-deprecated']/eg/(node() except issue)"/>
</pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-deprecated']/eg/issue"/>
</xsl:template>
-->

<xsl:template match="div3[@id='parsing_rnc_full']/eg" priority="111">
<pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3']/eg/(node() except issue)"/>
</pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3']/eg/issue"/>
</xsl:template>


<xsl:template match="div3[@id='parsing_rnc_common']/eg" priority="111">
<pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-common']/eg/(node() except issue)"/>
</pre>
</xsl:template>

<xsl:template match="div3[@id='parsing_rnc_strict']/eg" priority="111">
<pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-strict-content']/eg/(node() except issue)"/>
</pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-strict-content']/eg/issue"/>
</xsl:template>


<xsl:template match="div3[@id='parsing_rnc_content']/eg[1]" priority="111">
<pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-content']/eg/(node() except issue)"/>
</pre>
<xsl:apply-templates select="$relax-schema/div3[@id='parsing_mathml3-content']/eg/issue"/>
</xsl:template>



<!-- FILENAMES -->

<xsl:template match="body/div1" mode="slice-filename">
  <xsl:variable name="docnumber">
    <xsl:number count="div1" level="multiple" format="1"/>
  </xsl:variable>
  <xsl:value-of select="$body.filename.base"/>
  <xsl:value-of select="$docnumber"/>
  <xsl:value-of select="$filename.extension"/>
</xsl:template>

<xsl:template match="back/div1 | inform-div1" mode="slice-filename">
  <xsl:variable name="docnumber">
    <xsl:number count="div1|inform-div1" level="multiple" format="{$back.filename.format}"/>
  </xsl:variable>
  <xsl:value-of select="$back.filename.base"/>
  <xsl:value-of select="$docnumber"/>
  <xsl:value-of select="$filename.extension"/>
</xsl:template>



<xsl:template match="spec" mode="slice-filename">
  <xsl:value-of select="$front.filename.base"/>
  <xsl:value-of select="$filename.extension"/>
</xsl:template>


<!-- mmlspec customisation later 

<xsl:template name="navigation.top">
  <xsl:param name="prev" select="''"/>
  <xsl:param name="next" select="''"/>

  <a name="Top"/>
  <xsl:comment> TOP NAVIGATION BAR </xsl:comment>
  <table border="0" width="90%"
         cellpadding="4" cellspacing="0"
         bgcolor="#eeeeff"
         class="navigation"
summary="Navigation Bar">
    <col width="25%"/>
    <col width="25%"/>
    <col width="25%"/>
    <col width="25%"/>
    <tr>
      <td>&#xa0;</td>
      <td>&#xa0;</td>
      <td>&#xa0;</td>
      <td>&#xa0;</td>
    </tr>
    <tr>
      <td align="left">
        <a href="{$front.filename.base}{$filename.extension}#contents">Table of Contents</a>
      </td>
      <td align="left">
        <xsl:choose>
          <xsl:when test="$prev">
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="$prev"/>
                  <xsl:with-param name="just.filename" select="1"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:text>Prev</xsl:text>
            </a>
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td align="left">
        <xsl:choose>
          <xsl:when test="$next">
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="$next"/>
                  <xsl:with-param name="just.filename" select="1"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:text>Next</xsl:text>
            </a>
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td align="left">
        <a href="#Bottom">Bottom</a>
      </td>
    </tr>
  </table>

  !- - quick table of contents - ->
  <table border="0" width="90%"
         cellpadding="4" cellspacing="0" 
         bgcolor="#eeeeff"
         class="navigation-toc"
summary="Navigation TOC"
>
    <col width="100%"/>
    <tr align="left"><th><hr/>Quick Table of Contents<hr/></th></tr>
    <tr>
      <td>
        <xsl:apply-templates mode="toc" select=".">
          <xsl:with-param name="just.filename" select="'0'"/>
        </xsl:apply-templates>
      </td>
    </tr>
  </table>
</xsl:template>

-->

<!-- END OF FILENAMES -->



<!-- HTML HEADING DEPTH -->

  <xsl:template match="example/head">
    <xsl:text>&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="$tabular.examples = 0">
        <div class="exampleHead">
          <xsl:text>Example: </xsl:text>
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
    <xsl:variable name="depth"  select="count(ancestor::*[contains(name(),'div')])"/>
    <xsl:variable name="h">
     <xsl:choose>
      <xsl:when test="$depth &gt; $slice.depth">
        <xsl:value-of select="1 + $depth  - $slice.depth"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1 + $depth"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
        <xsl:element name="h{$h+1}">
          <xsl:call-template name="anchor">
            <xsl:with-param name="node" select=".."/>
            <xsl:with-param name="conditional" select="0"/>
          </xsl:call-template>

          <xsl:text>Example: </xsl:text>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(name(),'div')]/head">
    <xsl:text>&#10;</xsl:text>
    <xsl:variable name="depth"
    select="if (parent::div) then 5 else count(ancestor::*[contains(name(),'div')][head])"/>
    <xsl:variable name="num">
      <xsl:apply-templates select=".." mode="divnum"/>
    </xsl:variable>
    <xsl:variable name="h">
     <xsl:choose>
      <xsl:when test="$depth &gt; $slice.depth">
        <xsl:value-of select="1+ $depth  - $slice.depth"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    <xsl:element name="h{$h}">
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
        <xsl:with-param name="default.id" select="translate(concat('id.',$num),' ','')"/>
      </xsl:call-template>
      <xsl:copy-of select="$num"/>
      <xsl:apply-templates/>
      <xsl:if test="parent::inform-div1"> (Non-Normative)</xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="div" mode="toc" priority="10"/>

<!-- Combined toc template for all the div elements.
     This has toc.level as a _local_ parameter rather than global
     so main document toc and per-chapter tocs can be different
     depths.
-->
  <xsl:template match="*[contains(name(),'div')][head]|MMLdefinition" mode="toc">
    <xsl:param name="indent" select="''"/>
    <xsl:param name="toc.level" select="$toc.level"/>
    <xsl:variable name="depth"
    select="if(parent::div) then 5 else count(ancestor::*[contains(name(),'div')][head])"/>
    <xsl:variable name="num">
      <xsl:apply-templates select="." mode="divnum"/>
    </xsl:variable>
    <xsl:value-of select="$indent"/>
    <xsl:copy-of select="$num"/>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
          <xsl:with-param name="default.id"  select="translate(concat('id.',$num),' ','')"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="head|name" mode="text"/>
      <xsl:if test="self::inform-div1"> (Non-Normative)</xsl:if>
    </a>
    <br/>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="$depth +1 &lt; $toc.level">
      <xsl:apply-templates select="*[contains(name(),'div')][head]|MMLdefinition" mode="toc">
       <xsl:with-param name="indent" select="concat($indent,'&#160;&#160;&#160;&#160;')"/>
       <xsl:with-param name="toc.level" select="$toc.level"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>


<!-- END OF HTML HEADING DEPTH -->


<!-- OBJECT ID -->
<!-- use @id in preference to default.id and use this to generate 
     references as well as anchors so as to get #id.1.2 rather than
     #lscdkalc
-->
<xsl:template name="object.id">
  <xsl:param name="node" select="."/>
  <xsl:param name="default.id" select="''"/>

  <xsl:choose>
    <xsl:when test="$node/@id">
      <xsl:value-of select="translate($node/@id,'_','.')"/>
    </xsl:when>
    <!-- can't use the default ID if it's used somewhere else in the document! -->
    <xsl:when test="$default.id != '' and not(key('ids', $default.id))">
      <xsl:value-of select="$default.id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($node[1])"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- END OF OBJECT ID -->


<!-- QUICK TOC LOCATION -->

<xsl:template match="body/div1">
  <xsl:variable name="prev"
                select="(preceding::div1|preceding::inform-div1)[last()]"/>
  <xsl:variable name="next"
                select="(following::div1|following::inform-div1)[1]"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename">
      <xsl:apply-templates select="." mode="slice-filename"/>
    </xsl:with-param>
    <xsl:with-param name="content">
      <html>
      <xsl:if test="header/langusage/language">
        <xsl:attribute name="lang">
          <xsl:value-of select="header/langusage/language/@id"/>
        </xsl:attribute>
      </xsl:if>
       <head>
          <title><xsl:value-of select="head"/></title>
          <xsl:call-template name="css"/>
        </head>
        <body>
<xsl:if test="/spec/@role='editors-copy'">
<div style="position:fixed; top: 0; left: 0.25em; width: 4em; background-color: red; color: white;">
<b>Editors'<br/> Draft</b>
</div>
</xsl:if>
          <xsl:apply-templates select="head[$title.before.navigation]"/>
          <xsl:call-template name="navigation.top">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>

          <div class="div1">
            <xsl:apply-templates select="node()[not(self::head[$title.before.navigation])]"/>
          </div>

          <xsl:call-template name="navigation.bottom">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="back/div1 | back/inform-div1">
  <xsl:variable name="prev"
                select="(preceding::div1|preceding::inform-div1)[last()]"/>
  <xsl:variable name="next"
                select="(following::div1|following::inform-div1)[1]"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename">
      <xsl:apply-templates select="." mode="slice-filename"/>
    </xsl:with-param>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="head"/></title>
          <xsl:call-template name="css"/>
<xsl:if test="@id='oper-dict'">
<script type='text/javascript' src='sorttable.js'></script>
</xsl:if>
        </head>
        <body>
<xsl:if test="/spec/@role='editors-copy'">
<div style="position:fixed; top: 0; left: 0.25em; width: 4em; background-color: red; color: white;">
<b>Editors'<br/> Draft</b>
</div>
</xsl:if>
          <xsl:apply-templates select="head[$title.before.navigation]"/>
          <xsl:call-template name="navigation.top">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>

          <div class="div1">
            <xsl:apply-templates select="node()[not(self::head[$title.before.navigation])]"/>
          </div>

          <xsl:call-template name="navigation.bottom">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="inform-div1">
  <xsl:variable name="prev"
                select="(preceding::div1|preceding::inform-div1)[last()]"/>
  <xsl:variable name="next"
                select="(following::div1|following::inform-div1)[1]"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename">
      <xsl:apply-templates select="." mode="slice-filename"/>
    </xsl:with-param>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="head"/></title>
          <xsl:call-template name="css"/>
        </head>
        <body>
<xsl:if test="/spec/@role='editors-copy'">
<div style="position:fixed; top: 0; left: 0.25em; width: 4em; background-color: red; color: white;">
<b>Editors'<br/> Draft</b>
</div>
</xsl:if>
          <xsl:apply-templates select="head[$title.before.navigation]"/>
          <xsl:call-template name="navigation.top">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>

          <div class="div1">
            <xsl:apply-templates select="node()[not(self::head[$title.before.navigation])]"/>
          </div>

          <xsl:call-template name="navigation.bottom">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- END OF QUICK TOC LOCATION -->







<!-- SLIST -->
 <xsl:template match="slist">
    <ul>
        <xsl:apply-templates/>
    </ul>
  </xsl:template>

<xsl:template match="sitem">
    <li class="sitem"><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="item">
   <xsl:if test="string($show.diff.markup)='1' or not(@diff='del')">
    <li>
         <xsl:if test="@diff and $show.diff.markup='1'">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
     </xsl:if>
        <xsl:if test="@id">
         <xsl:attribute name="id" select="translate(@id,'_','.')"/>
        </xsl:if>
      <xsl:apply-templates/>
         <xsl:if test="@diff and $show.diff.markup='1'">
        <xsl:call-template name="diff-back-link"/>
         </xsl:if>
    </li>
   </xsl:if>
  </xsl:template>

<!-- NESTED PARAGRAPHAS -->

<!-- xmlspec, like most document formats other than html, allows
    block level elements in paragraphs. For hTML need to
    separately wrap each conecutive run of inline elements in <p>
    and leave block level elements outside the p.

   xmlspec.xsl has some code using disable-output-escaping to
   attempt to do this, but it doesn't really work, evn with processors
   taht support d-o-e. The original mathml stylesheet as used for
   mathml 1.01 had code to deal with this, but this is a more
   efficient implementation using the grouping technique using keys.
-->


<xsl:key name="pnodes" match="p/node()" 
                  use="generate-id((..|
                     (preceding-sibling::*|.)[
          self::eg
       or self::glist
       or self::olist
       or self::ulist
       or self::slist
       or self::orglist
       or self::table
       or self::issue
       or self::ednote
       or self::note
       or self::processing-instruction()
       or self::graphic[not(@role='inline')]
        ])[last()])"/>

<xsl:template match="p">
<xsl:variable name="p1">
<p>
        <xsl:if test="@id">
         <xsl:attribute name="id"><xsl:value-of
  select="translate(@id,'_','.')"/></xsl:attribute>
        </xsl:if>
 <xsl:if test="@role">
   <xsl:attribute name="class">
      <xsl:value-of select="@role"/>
   </xsl:attribute>
 </xsl:if>
 <xsl:apply-templates select="key('pnodes',generate-id(.))"/>
</p>
</xsl:variable>
<xsl:if test="key('pnodes',generate-id(.))/self::* or normalize-space($p1)">
  <xsl:copy-of select="$p1"/>
</xsl:if>
<xsl:for-each select="eg|glist|olist|ulist|slist|orglist|
                       table|issue|ednote|note|processing-instruction()|
                       graphic[not(@role='inline')]">
<xsl:apply-templates select="."/>
<xsl:variable name="p" select="key('pnodes',generate-id(.))[position() &gt; 1]"/>
 <xsl:if test="$p[self::* or normalize-space(.)]">
<p>
<xsl:apply-templates select="$p"/>
</p>
</xsl:if>
</xsl:for-each>
</xsl:template>


<!-- END OF NESTED PARAGRAPHAS -->


<!-- RHS DIFF MARKUP (del) -->
  <xsl:template mode="number" match="prod">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="." mode="number-simple"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template mode="number-simple" match="prod">
    <xsl:number level="any" count="prod[not(@diff='del' or ../@diff='del')]"/>
  </xsl:template>

  <xsl:template mode="number" match="prod[@diff='del'or ../@diff='del']">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="preceding::prod[not(@diff='del' or ../@diff='del')][1]"
      mode="number-simple"/>
<!--
  Once again, this could be done right here, but XT won't hear of it.
    <xsl:number level="any" count="prod[not(@diff='del' or ../@diff='del')]"/>
  -->
    <xsl:number level="any" count="prod[@diff='del' or ../@diff='del']"
      from="prod[not(@diff= 'del' or ../@diff='del')]" format="a"/>
    <xsl:text>]</xsl:text>
  </xsl:template>


  <xsl:template match="prod">
    <tbody>
      <xsl:apply-templates
        select="lhs[not(@diff='del' and $show.diff.markup='0')][not(@diff='del' and $show.diff.markup='0')] |
                rhs[not(@diff='del' and $show.diff.markup='0')][preceding-sibling::*[not(@diff='del' and $show.diff.markup='0')][1][name()!='lhs']] |
                com[not(@diff='del' and $show.diff.markup='0')][preceding-sibling::*[not(@diff='del' and $show.diff.markup='0')][1][name()!='rhs']] |
                constraint[not(@diff='del' and $show.diff.markup='0')][preceding-sibling::*[not(@diff='del' and $show.diff.markup='0')][1][name()!='rhs']] |
                vc[not(@diff='del' and $show.diff.markup='0')][preceding-sibling::*[not(@diff='del' and $show.diff.markup='0')][1][name()!='rhs']] |
                wfc[preceding-sibling::*[1][name()!='rhs']]"/>
    </tbody>
  </xsl:template>

  <xsl:template match="lhs">
    <tr valign="baseline">
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="../@id">
          <a name="{../@id}" id="{../@id}"/>
        </xsl:if>
        <xsl:apply-templates select="ancestor::prod" mode="number"/>
<!--
  This could be done right here, but XT goes into deep space when the
  node to be numbered isn't the current node and level="any":
          <xsl:number count="prod" level="any" from="spec"
            format="[1]"/>
  -->
        <xsl:text>&#xa0;&#xa0;&#xa0;</xsl:text>
      </td>
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <code><xsl:apply-templates/></code>
      </td>
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:text>&#xa0;&#xa0;&#xa0;::=&#xa0;&#xa0;&#xa0;</xsl:text>
      </td>
      <xsl:apply-templates
        select="following-sibling::*[not(@diff='del' and $show.diff.markup='0')][1][name()='rhs']"/>
    </tr>
  </xsl:template>


 <xsl:template match="rhs">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[not(@diff='del' and $show.diff.markup='0')][1][name()='lhs']">
        <td>
          <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="ancestor-or-self::*[1]/@diff"/>
            </xsl:attribute>
          </xsl:if>
          <code><xsl:apply-templates/></code>
        </td>
        <xsl:apply-templates
          select="following-sibling::*[not(@diff='del' and $show.diff.markup='0')][1][name()='com' or
                                          name()='constraint' or
                                          name()='vc' or
                                          name()='wfc']"/>
      </xsl:when>
      <xsl:otherwise>
        <tr valign="baseline">
          <td/><td/><td/>
          <td>
            <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
              <xsl:attribute name="class">
                <xsl:text>diff-</xsl:text>
                <xsl:value-of select="ancestor-or-self::*/@diff"/>
              </xsl:attribute>
            </xsl:if>
            <code><xsl:apply-templates/></code>
          </td>
          <xsl:apply-templates
            select="following-sibling::*[not(@diff='del' and $show.diff.markup='0')][1][name()='com' or
                                            name()='constraint' or
                                            name()='vc' or
                                            name()='wfc']"/>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
<!-- END OF RHS DIFF MARKUP (del) -->

<!-- SLICE CHECKING -->
<!--
  slices-common has
  <xsl:if test="$target != $slice">
  which repeatedly produces the string value of an entire chapter, or the entire
  spec for every internal reference. saxon produces the mathml spec in
  a third of the time on my machine  if this is changed to
  <xsl:if test="generate-id($target) != generate-id($slice)">

  In addition  add the test for "this slice" so references in chapter 3 
  to other parts of the same file are of the form #foo rather than
  chapter3.html#foo (don't do this if target = . as in that case
  you have travelled to the target first (as in toc processing).
-->

<xsl:template name="href.target">
  <xsl:param name="target" select="."/>
  <xsl:param name="default.id" select="''"/>

  <xsl:variable name="slice"
                select="($target/ancestor-or-self::div1
                        |$target/ancestor-or-self::inform-div1
                        |$target/ancestor-or-self::spec)[last()]"/>


  <xsl:variable name="thisslice"
                select="(ancestor-or-self::div1
                        |ancestor-or-self::inform-div1
                        |ancestor-or-self::spec)[last()]"/>

  <xsl:if test="(generate-id($slice) != generate-id($thisslice)) or 
                (generate-id($target) = generate-id(.))">
    <xsl:apply-templates select="$slice" mode="slice-filename"/>
  </xsl:if>
  <xsl:if test="generate-id($target[1]) != generate-id($slice)">
    <xsl:text>#</xsl:text>
      <xsl:call-template name="object.id">
      <xsl:with-param name="node" select="$target"/>
      <xsl:with-param name="default.id" select="$default.id"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- END OF SLICE CHECKING -->


<xsl:template match="intref">
    <xsl:variable name="target" select="key('ids', @ref)[1]"/>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
         <xsl:apply-templates/>
       </a>
</xsl:template>


<!--  Add MMLDefinition to target types and special case ref="status"
      prefix reference with Chapter Section or Appendix for div*
      targets (and make it not bold)
-->
  <!-- specref: reference to another part of the current specification -->

<xsl:template match="specref[@ref='mmlcss']">
 <span>Layout engines that lack native MathML support</span>
</xsl:template>

<xsl:template match="specref[@ref='authors']">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
        <b>Editors and Authors</b>
       </a>
</xsl:template>

<xsl:template match="specref[@ref='status']">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
        <b>Status</b>
       </a>
</xsl:template>

<xsl:template match="specref[@ref='abstract']">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
        <b>Abstract</b>
       </a>
</xsl:template>

  <xsl:template match="specref" name="specref">
    <xsl:param name="ref" select="@ref"/>
    <xsl:variable name="target" select="key('ids', $ref)[1]"/>

    <xsl:choose>
      <xsl:when test="local-name($target)='issue'">
        <xsl:text>[</xsl:text>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', $ref)"/>
            </xsl:call-template>
          </xsl:attribute>
          <b>
            <xsl:text>Issue </xsl:text>
            <xsl:apply-templates select="key('ids', $ref)" mode="number"/>
            <xsl:text>: </xsl:text>
            <xsl:for-each select="key('ids', $ref)/head">
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
              <xsl:with-param name="target" select="key('ids', $ref)"/>
            </xsl:call-template>
          </xsl:attribute>
<xsl:for-each select="$target">
          <xsl:choose>
    <xsl:when test="self::div"></xsl:when>
    <xsl:when test="(self::div1) and parent::body">Chapter&#160;</xsl:when>
    <xsl:when test="(self::div1 or self::inform-div1) and
      parent::back">Appendix&#160;</xsl:when>
       <xsl:otherwise>Section&#160;</xsl:otherwise>
          </xsl:choose>
</xsl:for-each>
            <xsl:apply-templates select="key('ids', $ref)" mode="divnum"/>
            <xsl:apply-templates select="key('ids', $ref)/head" mode="text"/>
        </a>
      </xsl:when>
      <xsl:when test="starts-with(local-name($target), 'inform-div')">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', $ref)"/>
            </xsl:call-template>
          </xsl:attribute>
             <xsl:text>Appendix&#160;</xsl:text>
            <xsl:apply-templates select="key('ids', $ref)" mode="divnum"/>
            <xsl:apply-templates select="key('ids', $ref)/head" mode="text"/>
        </a>
      </xsl:when>
      <xsl:when test="local-name($target) = 'vcnote'">
        <b>
          <xsl:text>[VC: </xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', $ref)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates select="key('ids', $ref)/head" mode="text"/>
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
                <xsl:with-param name="target" select="key('ids', $ref)"/>
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
                <xsl:with-param name="target" select="key('ids', $ref)"/>
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
              <xsl:with-param name="target" select="key('ids', $ref)"/>
            </xsl:call-template>
          </xsl:attribute>
          <b>
            <xsl:value-of select="key('ids', $ref)/name"/>
          </b>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unsupported specref to </xsl:text>
          <xsl:value-of select="local-name($target)"/>
          <xsl:text> [</xsl:text>
          <xsl:value-of select="$ref"/>
          <xsl:text>] </xsl:text>
          <xsl:text> (Contact stylesheet maintainer).</xsl:text>
        </xsl:message>
        <b>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', $ref)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>???</xsl:text>
          </a>
        </b>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



 <xsl:template match="graphic[@role='inline']">
   <img src="{@source}" alt="{@alt}" align="{(@align,'middle')[1]}"/>
 </xsl:template>

 <xsl:template match="graphic">
   <blockquote>
     <p><img src="{@source}" alt="{@alt}"/></p>
   </blockquote>
 </xsl:template>


<!-- CSS STYLESHEET LOCATION -->
<!-- W3C publication rules insist of absolute URI to these CSS
     files. This is an annoyance to users, but is a major pain while
     developing drafts of the spec. Make the base URI for the CSS
     directory a parameter so it only needs to be
     http://www.w3.org/StyleSheets/TR/
     for the final version to be published in TR space.
-->

  <xsl:template name="css">
    <style type="text/css">
      <xsl:text>

.egmeta {
color:#5555AA;font-style:italic;font-family:serif;font-weight:bold;
}

table.syntax {
font-size: 75%;
background-color: #DDDDDD;
border: thin  solid;
}
table.syntax td {
border: solid thin;
}
table.syntax th {
text-align: left;
}

table.attributes td { padding-left:0.5em; padding-right:0.5em; border: solid thin; }
table.attributes td.attname { white-space:nowrap; vertical-align:top;}
table.attributes td.attdesc { background-color:#F0F0FF; padding-left:2em; padding-right:2em}

th.uname {font-size: 50%; text-align:left;}
code           { font-family: monospace; }

div.constraint,
div.issue,
div.note,
div.notice     { margin-left: 2em; }

li p           { margin-top: 0.3em;
                 margin-bottom: 0.3em; }
</xsl:text>
      <xsl:if test="$tabular.examples = 0">
        <xsl:text>
div.exampleInner pre { margin-left: 1em;
                       margin-top: 0em; margin-bottom: 0em}
div.exampleOuter {border: 4px double gray;
                  margin: 0em; padding: 0em}
div.exampleInner { background-color: #d5dee3;
                   border-top-width: 4px;
                   border-top-style: double;
                   border-top-color: #d3d3d3;
                   border-bottom-width: 4px;
                   border-bottom-style: double;
                   border-bottom-color: #d3d3d3;
                   padding: 4px; margin: 0em }
div.exampleWrapper { margin: 4px }
div.exampleHeader { font-weight: bold;
                    margin: 4px}
a.mainindex {font-weight: bold;}
li.sitem {list-style-type: none;}
</xsl:text>
      </xsl:if>
      <xsl:value-of select="$additional.css"/>
    </style>
    <link rel="stylesheet" type="text/css">
      <xsl:attribute name="href">
        <xsl:copy-of select="$css.base.uri"/>
        <xsl:choose>
          <xsl:when test="/spec/@role='editors-copy'">base</xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="/spec/@w3c-doctype='wd'">W3C-WD</xsl:when>
              <xsl:when test="/spec/@w3c-doctype='rec'">W3C-REC</xsl:when>
              <xsl:when test="/spec/@w3c-doctype='pr'">W3C-PR</xsl:when>
              <xsl:when test="/spec/@w3c-doctype='per'">W3C-PER</xsl:when>
              <xsl:when test="/spec/@w3c-doctype='cr'">W3C-CR</xsl:when>
              <xsl:when test="/spec/@w3c-doctype='note'">W3C-NOTE</xsl:when>
              <xsl:otherwise>base</xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>.css</xsl:text>
      </xsl:attribute>
    </link>
  </xsl:template>

<!-- END CSS STYLESHEET LOCATION -->





<!-- local locs get multiple extensions -->
  <xsl:template match="loc">
    <a href="{@href}">
      <xsl:if test="contains(@href,'.html') and not(contains(@href,'/')) and not(contains(@href,'-d.html'))">
       <xsl:attribute name="href">
         <xsl:value-of select="substring-before(@href,'.html')"/>
         <xsl:value-of select="$filename.extension"/>
       </xsl:attribute>
      </xsl:if>
      <xsl:if test="@role='disclosure'">
	<xsl:attribute name="rel">disclosure</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </a>
  </xsl:template>





<!-- Templates for DOM-style interface definitions  -->
<xsl:template match="interface">
  <xsl:element name="h{5 -$slice.depth}">
  <xsl:call-template name="anchor"/>
  Interface <xsl:value-of select="@name"/>
  </xsl:element>
  <xsl:if test="normalize-space(@inherits)">
  <p><b>Extends: 
    <xsl:call-template name="dom-type-inherits">
	  <xsl:with-param name="typestring" select="@inherits"/>
    </xsl:call-template>
  </b></p>
  </xsl:if>
  <xsl:apply-templates select="descr"/>
  <xsl:if test="count(attribute) > 0">
    <p><b>Attributes</b></p>
    <dl>
      <xsl:apply-templates select="attribute"/>
    </dl>
  </xsl:if>
  <xsl:if test="count(method) > 0">
    <p><b>Methods</b></p>
    <dl>
      <xsl:apply-templates select="method"/>
    </dl>
  </xsl:if>
</xsl:template>

<xsl:template match="attribute">
   <xsl:if test="not(@diff='del' and $show.diff.markup='0')">
   <dt>
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
<code class="attribute-Name"><xsl:value-of
     select="@name"/></code> of type
    <xsl:call-template name="dom-type"/>
    <xsl:if test="@readonly='yes'">
      <xsl:text>, readonly</xsl:text>
    </xsl:if>
  </dt>
  <dd><xsl:apply-templates select="descr"/>
    <xsl:apply-templates select="setraises"/>
    <xsl:apply-templates select="getraises"/>
</dd>
  </xsl:if>
</xsl:template>

<xsl:template match="descr">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="definitions">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="exception">
   <xsl:if test="not(@diff='del' and $show.diff.markup='0')">
  <dt>
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
<code><xsl:value-of select="@name"/></code></dt>
  <dd>
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
<xsl:apply-templates/></dd>
</xsl:if>
</xsl:template>

<xsl:template match="method">
  <dt><code class="method-Name"><xsl:value-of
         select="@name"/></code></dt>
  <dd><xsl:apply-templates select="descr"/>
  <xsl:if test="count(parameters/param) > 0">
    <p><b>Parameters</b></p>
    <table>
      <xsl:apply-templates select="parameters/param"/>
    </table>
  </xsl:if>
  <xsl:apply-templates select="returns"/>
  <xsl:apply-templates select="raises"/>
  </dd>
</xsl:template>


<xsl:template match="param">
  <xsl:if test="not(@diff='del' and $show.diff.markup='0')">
  <tr>
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
  <td class="baseline"><xsl:call-template name="dom-type"/></td>
  <td class="baseline"><code><xsl:value-of select="@name"/></code></td>
  <td class="baseline"><xsl:apply-templates select="descr"/></td>
  </tr>
</xsl:if>
</xsl:template>

<xsl:template match="returns">
  <p><b>Return value</b></p>
   <table>
   <tr>
    <td class="baseline"><xsl:call-template name="dom-type"/></td>
    <td class="baseline"><xsl:apply-templates select="descr"/></td>
  </tr>
  </table>
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
 <code>
 <xsl:choose>
 <xsl:when test="not($type = 'void' or $type = 'long' or $type = 'unsigned long' or $type = 'short' or $type = 'unsigned short')">
 <a>
 <xsl:attribute name="href">
 <xsl:choose>
 <xsl:when test="starts-with($type, 'MathML')">
  <xsl:if test="ancestor::div1|inform-div1[not(@id='mathml-dom')]">
     <xsl:value-of select="id('mathml-dom')/@role"/>
  <xsl:value-of select="$filename.extension"/>
  </xsl:if
   >#dom.<xsl:value-of select="substring-after($type, 'MathML')"/>
 </xsl:when>
 <xsl:when test="$type = 'DOMString'"
 >http://www.w3.org/TR/DOM-Level-2-Core/core.html#DOMString</xsl:when>
<xsl:when test="$type = 'Document'"
 >http://www.w3.org/TR/DOM-Level-2-Core/core.html#i-Document</xsl:when>
 <xsl:otherwise>http://www.w3.org/TR/DOM-Level-2-Core/core.html</xsl:otherwise>
 </xsl:choose>
 </xsl:attribute>
 <xsl:value-of select="$type"/>
 </a>
 </xsl:when>
 <xsl:otherwise>
 <xsl:value-of select="$type"/>
 </xsl:otherwise>
 </xsl:choose>
 </code>
</xsl:template>

<xsl:template match="setraises">
   <xsl:choose>
   <xsl:when test="count(exception)>0">
     <p><b>Exceptions on Setting</b></p>
     <dl>
       <xsl:apply-templates select="exception"/>
     </dl>
   </xsl:when>
   </xsl:choose>
</xsl:template>

<xsl:template match="getraises">
   <xsl:choose>
   <xsl:when test="count(exception)>0">
     <p><b>Exceptions on Getting</b></p>
     <dl>
       <xsl:apply-templates select="exception"/>
     </dl>
   </xsl:when>
   </xsl:choose>
</xsl:template>

<xsl:template match="raises">
  <xsl:choose>
  <xsl:when test="count(exception) > 0">
    <p><b>Exceptions</b></p>
    <dl>
      <xsl:apply-templates select="exception"/>
    </dl>
  </xsl:when>
  <xsl:otherwise>
  <p>This method raises no exceptions.</p>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:key name="elem" match="el[not(@namespace) or @namespace='mathml']" use="."/>
<xsl:key name="att" match="att[not(@namespace) or @namespace='mathml']" use="."/>
<xsl:key name="att" match="td[@role='attname']" use="."/>

<xsl:template match="processing-instruction()">
  <xsl:choose>
    <xsl:when test="name(.)='generate-idl'">
      <p><b>IDL Definition</b></p>
      <div class="IDL-definition"><pre>
      <xsl:apply-templates select="ancestor::interface"           mode="idl"/>
      <xsl:apply-templates select="ancestor::interface/attribute" mode="idl"/>
      <xsl:apply-templates select="ancestor::interface/method"    mode="idl"/>
      <xsl:text>};</xsl:text>
      </pre></div>
    </xsl:when>
    <xsl:when test="name(.)='include-dtd'">
      <xsl:processing-instruction name="include">mathml.dtd.html</xsl:processing-instruction>
    </xsl:when>
    <xsl:when test="name(.)='generate-binding'">
      <xsl:choose>
        <xsl:when test="parent::div2/@id='dom-bindings_IDLBinding'">
          <xsl:apply-templates select="id('mathml-dom')" mode="IDLInterfaces"/>
        </xsl:when>
        <xsl:when test="parent::div2/@id='dom-bindings_JavaBindings'">
          <xsl:apply-templates select="id('mathml-dom')" mode="javaInterfaces"/>
        </xsl:when>
        <xsl:when test="parent::div2/@id='dom-bindings_ECMABinding'">
          <xsl:apply-templates select="id('mathml-dom')" mode="ecmaInterfaces"/>
        </xsl:when>
        <xsl:otherwise>
          <p class="error">generate-binding processing instruction for unrecognized ID 
          <xsl:value-of select="parent::div2/@id"/></p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name(.)='generate-domInheritance'">
      <dl>
      <xsl:apply-templates select="id('mathml-dom')//interface[not(starts-with(normalize-space(@inherits),'MathML'))]" mode="showInheritance"/> 
      </dl>
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
    <p class="error">Unrecognised processing instruction
      <xsl:value-of select="name(.)"/></p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="index">
<xsl:param name="a"/>
<xsl:param name="key"/>
<xsl:text>&#10;</xsl:text>
<dl>
<xsl:for-each select="$a">
<xsl:sort select="."/>
<xsl:variable name="this" select="."/>
<xsl:text>&#10;</xsl:text>
<dt><xsl:value-of select="."/></dt>
<xsl:text>&#10;</xsl:text>
<dd>
<xsl:text>&#10;</xsl:text>
<xsl:for-each select="key($key,.)[not(ancestor::*/@diff='del')]/ancestor::*[self::div1 or
self::div2 or self::div3 or self::div4 or self::MMLdefinition][1]">
    <xsl:variable name="num">
      <xsl:apply-templates select="." mode="divnum"/>
    </xsl:variable>
<a>
<xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
          <xsl:with-param name="default.id" select="translate(concat('id.',$num),' ','')"/>
        </xsl:call-template>
</xsl:attribute>
<!--
<xsl:if test="head/el=$this
   or  self::div4[@id='contm_trig']/p[1]/table/tbody/tr/td/el=$this
   or  ($num='3.4.7.1 ' and ($this='none' or $this='mprescripts'))">
-->
<xsl:if test="head//el[contains(@role,'defn')]=$this">
 <xsl:attribute name="class">mainindex</xsl:attribute>
</xsl:if>
<xsl:variable name="n">
<xsl:apply-templates mode="divnum" select="."/>
</xsl:variable>
<xsl:value-of select="normalize-space($n)"/>
</a>
<xsl:if test="position() != last()"><xsl:text>,&#10;</xsl:text></xsl:if>
</xsl:for-each>
<xsl:text>&#10;</xsl:text>
</dd>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</dl>
<xsl:text>&#10;</xsl:text>
</xsl:template>


<xsl:template match="interface" mode="idl">
<xsl:text>interface </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:if test="@inherits">: <xsl:value-of select="@inherits"/></xsl:if>
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
  <xsl:if test="position() > 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
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


<!-- IDL, Java, ECMAScript Bindings for DOM -->

<!-- Constant and Indentation String variables: -->

<xsl:variable name="lowerCaseString"><xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text></xsl:variable>
<xsl:variable name="upperCaseString"><xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text></xsl:variable>

<xsl:variable name="IDLindent0"><xsl:text xml:space="preserve">
</xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent1"><xsl:text xml:space="preserve">
  </xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent2"><xsl:text xml:space="preserve">
    </xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent3"><xsl:text xml:space="preserve">
      </xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent4"><xsl:text xml:space="preserve">
        </xsl:text>
</xsl:variable>

<xsl:variable name="IDLindent5"><xsl:text xml:space="preserve">
        </xsl:text>
</xsl:variable>

<xsl:variable name="raisesIndent"><xsl:text xml:space="preserve">
                                               </xsl:text>
</xsl:variable>

<xsl:variable name="javaRaisesIndent"><xsl:text xml:space="preserve">
                                                         </xsl:text>
</xsl:variable>

<xsl:variable name="javaPackageDeclaration"><xsl:text xml:space="preserve">
package org.w3c.dom.mathml;
</xsl:text>
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
  <xsl:text xml:space="preserve">
};

#endif
</xsl:text>
</xsl:variable>  

<!-- IDL Binding -->

<xsl:template match="div1[@id='mathml-dom']" mode="IDLInterfaces">
  <div class="IDL-definition"><pre>
  <xsl:value-of select="$idlFileHeader"/>
  <xsl:apply-templates mode="IDLgetForwardDeclarations"/> 
  <xsl:value-of select="$IDLindent1"/>
  <xsl:apply-templates mode="IDLInterfaces"/>
  <xsl:value-of select="$idlFileFooter"/>
  </pre></div>
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
  <xsl:if test="normalize-space(@inherits)">
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
  <xsl:for-each select="param[not(@diff='del')]">
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
  <xsl:if test="normalize-space($theEntity) and normalize-space($theSource)">
    <xsl:text xml:space="preserve">
import org.w3c.</xsl:text><xsl:value-of select="$theSource"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$theEntity"/>
    <xsl:text>;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- javaInterfaces Templates -->

<xsl:template match="interface" mode="javaInterfaces">
  <h3><a name="{generate-id()}" id="{generate-id()}"/>
  <xsl:text>org/w3c/dom/mathml/</xsl:text><xsl:value-of select="@name"/><xsl:text>.java</xsl:text>
  </h3>
  <div class="IDL-definition"><pre>
    <xsl:call-template name="javaFileHeader" />
    <xsl:value-of select="$IDLindent0"/>
    <xsl:value-of select="$IDLindent0"/>
    <xsl:text xml:space="preserve">public interface </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:if test="normalize-space(@inherits)">
      <xsl:text xml:space="preserve"> extends </xsl:text>
      <xsl:value-of select="@inherits"/>
    </xsl:if>
    <xsl:value-of select="$IDLindent0"/>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates mode="javaInterfaces"/>
    <xsl:value-of select="$IDLindent0"/>
    <xsl:text xml:space="preserve">};
    </xsl:text>
  </pre></div>
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
  <xsl:if test="count(exception[normalize-space(@name)])">
    <xsl:value-of select="$javaRaisesIndent"/><xsl:text xml:space="preserve">throws </xsl:text>
    <xsl:for-each select="exception">
      <xsl:variable name="localExceptionName" select="normalize-space(@name)"/>
      <xsl:if test="$localExceptionName and not(preceding-sibling::exception[normalize-space(@name)=$localExceptionName])">
        <xsl:if test="preceding-sibling::exception[not(normalize-space(@name)=$localExceptionName)]">
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
  <xsl:for-each select="param[not(@diff='del')]">
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
  <div class="IDL-definition">
  <xsl:apply-templates mode="ecmaInterfaces" select=".//interface"/>
  </div>
</xsl:template>

<xsl:template match="interface" mode="ecmaInterfaces">
  <xsl:if test="count(constant) > 0">
    <dl>
    <dt class="h3style"><!--<h3>--><strong> 
    <xsl:text xml:space="preserve">Class </xsl:text>
    <xsl:value-of select="@name"/>
    </strong><!--</h3>--></dt>
    <dd><xsl:text xml:space="preserve">The </xsl:text>
    <strong><xsl:value-of select="@name"/></strong>
    <xsl:text xml:space="preserve"> class has the following constants:</xsl:text>
    <dl>
    <xsl:apply-templates select="constant" mode="ecmaInterfaces"/>
    </dl></dd>
    </dl>
  </xsl:if>
  <dl><dt class="h3style">
  <xsl:text xml:space="preserve">Object </xsl:text>
  <xsl:value-of select="@name"/>
  </dt>
  <xsl:if test="normalize-space(@inherits)">
    <dd>
    <strong>
    <xsl:value-of select="@name"/></strong>
    <xsl:text xml:space="preserve"> has all the properties and methods of </xsl:text>
    <strong><xsl:value-of select="@inherits"/></strong>
    <xsl:text xml:space="preserve"> as well as the properties and methods defined below.</xsl:text>
    </dd>
  </xsl:if>
  <xsl:if test="count(attribute) > 0">
    <dd>
    <dl><dt>
    <xsl:text xml:space="preserve">The </xsl:text>
    <strong><xsl:value-of select="@name"/></strong>
    <xsl:text xml:space="preserve"> object has the following properties:</xsl:text></dt>
    <xsl:apply-templates select="attribute" mode="ecmaInterfaces"/>
    </dl>
    </dd>
  </xsl:if>
  <xsl:if test="count(method) > 0">
    <dd>
    <dl><dt>
    <xsl:text xml:space="preserve">The </xsl:text>
    <strong><xsl:value-of select="@name"/></strong>
    <xsl:text xml:space="preserve"> object has the following methods:</xsl:text>
    </dt>
    <xsl:apply-templates select="method" mode="ecmaInterfaces"/>
    </dl>
    </dd>
  </xsl:if>
  </dl>
</xsl:template>

<xsl:template match="constant" mode="ecmaInterfaces">
  <dd>
  <dl><dt>
  <strong><xsl:value-of select="parent::interface/@name"/>
  <xsl:text>.</xsl:text>
  <xsl:value-of select="@name"/></strong></dt>
  <dd>
  <xsl:text xml:space="preserve">This constant is of type </xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:text xml:space="preserve"> and its value is </xsl:text>
  <xsl:value-of select="@value"/>
  <xsl:text>.</xsl:text>
  </dd>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="attribute" mode="ecmaInterfaces">
   <xsl:if test="not(@diff='del' and $show.diff.markup='0')">
  <dd>
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
  <dl><dt>
  <strong><xsl:value-of select="@name"/></strong></dt>
  <dd>
  <xsl:text xml:space="preserve">This property is of type </xsl:text>
  <strong><xsl:value-of select="@type"/></strong>
  <xsl:text>.</xsl:text>
  </dd>
  </dl></dd>
</xsl:if>
</xsl:template>

<xsl:template match="method" mode="ecmaInterfaces">
  <dd>
  <dl><dt>
  <strong><xsl:value-of select="@name"/><xsl:text>(</xsl:text>
  <xsl:for-each select="parameters/param">
    <xsl:if test="count(preceding-sibling::param) > 0">
      <xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:value-of select="@name"/>
  </xsl:for-each>
  <xsl:text>)</xsl:text></strong>
  </dt>
  <dd>
  <xsl:variable name="returnType" select="normalize-space(returns/@type)"/>
  <xsl:choose>
    <xsl:when test="not($returnType)">
      <xsl:text xml:space="preserve">This method returns a </xsl:text>
      <strong><xsl:text>void</xsl:text></strong>
    </xsl:when>
    <xsl:when test="contains('aeiou',substring($returnType,1,1))">
      <xsl:text xml:space="preserve">This method returns an </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text xml:space="preserve">This method returns a </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <strong><xsl:value-of select="$returnType"/><xsl:text>.</xsl:text></strong>
  <xsl:apply-templates select="parameters" mode="ecmaInterfaces"/>
  </dd></dl>
  </dd>
</xsl:template>

<xsl:template match="parameters" mode="ecmaInterfaces">
  <xsl:for-each select="param">
    <xsl:text xml:space="preserve"> The </xsl:text>
    <strong><xsl:value-of select="./@name"/></strong>
    <xsl:text xml:space="preserve"> parameter is of type </xsl:text>
    <strong><xsl:value-of select="./@type"/></strong><xsl:text>.</xsl:text>
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
  <dd>
  <xsl:variable name="theReference">
    <xsl:choose> 
    <xsl:when test="starts-with($thisName,'MathML')">
      <a>
      <xsl:attribute name="href">
	    <xsl:if test="ancestor::div1|inform-div1[not(@id='mathml-dom')]">
		  <xsl:value-of select="id('mathml-dom')/@role"/>
                  <xsl:value-of select="$filename.extension"/>
            </xsl:if>
		<xsl:text>#dom.</xsl:text>
        <xsl:value-of select="substring-after($thisName,'MathML')"/>
      </xsl:attribute>
      <xsl:value-of select="$thisName"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$thisName"/>
    </xsl:otherwise>
    </xsl:choose>
	<xsl:if test="contains(@inherits,',')">
      <xsl:text xml:space="preserve"> [also inherits from: </xsl:text>
      <xsl:call-template name="dom-type-inherits">
        <xsl:with-param name="typestring" select="normalize-space(substring-after(@inherits,','))" />
	  </xsl:call-template>
	  <xsl:text>]</xsl:text>
	</xsl:if>
  </xsl:variable>
  <xsl:choose>
  <xsl:when test="count(ancestor::div1//interface[normalize-space(@inherits)=$thisName or (contains(normalize-space(@inherits),',') and substring-before(normalize-space(@inherits),',')=$thisName)]) > 0">
    <dl><dt><xsl:text>---</xsl:text>
<!--     <xsl:call-template name="dom-type"> -->
<!--       <xsl:with-param name="type" select="$thisName"/> -->
<!--     </xsl:call-template> -->
    <xsl:copy-of select="$theReference"/>
    </dt>
      <xsl:apply-templates select="ancestor::div1//interface[normalize-space(@inherits)=$thisName or (contains(normalize-space(@inherits),',') and substring-before(normalize-space(@inherits),',')=$thisName)]" mode="showInheritance"/>
    </dl>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>---</xsl:text>
    <xsl:copy-of select="$theReference"/>
<!--     <xsl:call-template name="dom-type"> -->
<!--       <xsl:with-param name="type" select="$thisName"/> -->
<!--     </xsl:call-template> -->
  </xsl:otherwise>
  </xsl:choose>
  </dd>
</xsl:template>

<xsl:template match="*" mode="showInheritance">
</xsl:template>

<xsl:template match="text()" mode="showInheritance">
</xsl:template>


<!-- appendix c -->

  <xsl:template mode="divnum" match="MMLdefinition">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | div4 | MMLdefinition |inform-div1"
      format="A.1.1.1 "/>
  </xsl:template>

<xsl:template match="MMLdefinition">
  <xsl:element name="h{3 -$slice.depth}">
     <xsl:call-template name="anchor"/>
      <xsl:number level="multiple" count="inform-div1|div1|div2|div3|div4|MMLdefinition" format="A.1.1.1 "/>
  MMLdefinition: <code><xsl:value-of select="name"/></code> <xsl:if test="@role!=''">(role: <xsl:value-of select="@role"/>)</xsl:if>
  </xsl:element>
   <dl>
  <xsl:apply-templates select="description"/>
  <xsl:apply-templates select="discussion"/>

  <xsl:apply-templates select="classification"/>

  <xsl:if test="MMLattribute">
  <dt>MMLattribute</dt>
  <dd><table border="1">
  <tr><th>Name</th><th>Value</th><th>Default</th></tr>
  <xsl:for-each select="MMLattribute">
  <tr><xsl:apply-templates/></tr>
  </xsl:for-each>
  </table>
  </dd>
  </xsl:if>

  <xsl:if test="m:notation">
    <dt>Notations</dt>
    <dd>
    <xsl:apply-templates select="m:notation"/>
    </dd>
  </xsl:if>

  <xsl:if test="signature">
  <dt>Signature</dt>
  <dd>
  <xsl:apply-templates select="signature"/>
  </dd>
  </xsl:if>
  <xsl:apply-templates select="property|MMLexample|renderedMMLexample"/>
  </dl>
</xsl:template>


<xsl:template match="MMLdefinition/rendering/head"/>
<xsl:template match="MMLdefinition/rendering">
<dt>Rendering</dt>
<dd>
  <xsl:apply-templates/>
</dd>
</xsl:template>


<xsl:template match="signature">
    <p><xsl:value-of select="."/></p>
</xsl:template>


<xsl:template match="MMLexample">
<dt>Example</dt>
<dd><xsl:apply-templates select="description"/><pre>
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
<xsl:apply-templates select="node()[not(self::description)]"/>
</pre></dd>
</xsl:template>



<xsl:template match="discussion/MMLexample">
<dl>
<dt>Example</dt>
<dd><xsl:apply-templates select="description"/><pre>
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
<xsl:apply-templates select="node()[not(self::description)]"/>
</pre></dd>
</dl>
</xsl:template>

<xsl:template match="classification">
<dt>Classification</dt>
<dd><xsl:apply-templates/></dd>
</xsl:template>


<xsl:template match="attvalue|attname|attdefault">
<td><xsl:apply-templates/></td>
</xsl:template>


<xsl:template match="property">
<dt>Property</dt>
<dd>
<xsl:apply-templates select="description"/>
<pre>
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
<xsl:apply-templates select="node()[not(self::description)]"/>
</pre></dd>
</xsl:template>

<xsl:template match="description">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="MMLdefinition/name"/>


<xsl:template match="MMLdefinition/functorclass"/>



<xsl:template match="MMLdefinition/description">
  <dt>Description</dt>
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="MMLdefinition/discussion">
  <dt>Discussion</dt>
  <dd><xsl:apply-templates/></dd>
</xsl:template>


<!--
MathML Customistations

templates below this point are handle specific features or stylistic
requirements of the MathMl specification.
-->


<!-- handle both authors and editors (marked up in the same authlist,
but distinguished by role="editor" attribute -->
<!-- as requested by Patrick, list editors twice, as they are also authors -->

<xsl:template match="authlist">
  <dt>
  <xsl:text>Editor</xsl:text>
  <xsl:if test="count(author[@role='editor']) > 1">s</xsl:if>:<xsl:text/>
  </dt>
  <xsl:apply-templates mode= "editor" select="author[@role='editor']"/>
  <xsl:if test="author[not(@role='editor')]">
  <dt id="authors">
  <xsl:text>Principal Authors:</xsl:text>
  </dt>
  <!--<dd><xsl:apply-templates select="author[not(@role='editor')]"/></dd>-->
  <dd><xsl:apply-templates select="author"/></dd>
  </xsl:if>
</xsl:template>

<xsl:template  mode= "editor" match="author[@role='editor']">
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="author">
  <xsl:value-of select="name"/>
  <xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

  <xsl:template match="author[@diff]" priority="1">
    <xsl:choose>
      <xsl:when test="@diff and $show.diff.markup='1'">
	  <span class="diff-{ancestor-or-self::*/@diff}">
	      <xsl:value-of select="name"/>
  <xsl:if test="position() != last()">, </xsl:if>
	  </span>
      </xsl:when>
      <xsl:when test="@diff='del' and $show.diff.markup='0'">
	<!-- suppressed -->
      </xsl:when>
      <xsl:otherwise>
	    <xsl:value-of select="name"/>
  <xsl:if test="position() != last()">, </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="latestloc[@role='rec']">
    <dt>Latest MathML Recommendation:</dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <xsl:template match="latestloc">
    <dt>Latest MathML 3 version:</dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

<!-- errata linking -->
<!-- add the apply-templates errataloc here rather than  the main
header template as it's smaller... -->

  <xsl:template match="altlocs">
    <xsl:apply-templates select="../errataloc"/>
    <p>
      <xsl:text>In addition to the </xsl:text>
       <a href="{$front.filename.base}.html">HTML</a>
      <xsl:text> version, </xsl:text>
      <xsl:text>this document is also available </xsl:text>
      <xsl:text>in these non-normative formats: </xsl:text>
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
        <a href="{@href}"><xsl:apply-templates/></a>
      </xsl:for-each>
      <xsl:text>.</xsl:text>
    </p>
    <xsl:apply-templates select="../translationloc"/>
  </xsl:template>



  <xsl:template match="errataloc">
  <p>Please refer to the <a href="{@href}"><strong>errata</strong></a>
for this document, which may include some normative corrections.</p>
  </xsl:template>

  <xsl:template match="translationloc">
  <p>See also <a href="{@href}"><strong>translations</strong></a>.</p>
  </xsl:template>

<!-- convert tr in table head to th -->
<xsl:template match="thead/tr/td">
  <th>
    <xsl:copy-of select="@* except (@diff,@role,@rowspan[.=1],@colspan[.=1])"/>
        <xsl:if test="@role">
	  <xsl:attribute name="class" select="@role"/>
	</xsl:if>
  <xsl:choose>
    <xsl:when test="normalize-space(.)=''">&#160;</xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  </th>
</xsl:template>

<!-- zap _ in ids -->
 <!-- table: the HTML table model adopted wholesale; note however that we -->
  <!-- do this such that the XHTML stylesheet will do the right thing. -->
  <xsl:template match="caption|col|colgroup|td|tfoot|th|thead|tr|tbody">
    <xsl:element name="{local-name(.)}">
        <xsl:copy-of select="@* except (@diff,@role,@rowspan[.=1],@colspan[.=1])"/>
        <xsl:if test="@id">
         <xsl:attribute name="id" select="translate(@id,'_','.')"/>
        </xsl:if>
        <xsl:if test="@role">
         <xsl:attribute name="class" select="@role"/>
        </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

 
  <xsl:template match="table">
    <xsl:text>&#10;</xsl:text>
    <table>
        <!-- Wait: some of these aren't HTML attributes after all... -->
        <xsl:copy-of select="@* except (@diff,@role,@rowspan[.=1],@colspan[.=1],@border[../@role='attributes'])"/>
        <xsl:if test="@id">
         <xsl:attribute name="id" select="translate(@id,'_','.')"/>
        </xsl:if>
        <xsl:if test="@role">
         <xsl:attribute name="class" select="@role"/>
        </xsl:if>
      <xsl:apply-templates/>

      <xsl:if test=".//footnote">
	<xsl:text>&#10;</xsl:text>
        <tbody>
	  <xsl:text>&#10;</xsl:text>
          <tr>
            <td>
              <xsl:apply-templates select=".//footnote" mode="table.notes"/>
            </td>
          </tr>
	  <xsl:text>&#10;</xsl:text>
        </tbody>
	<xsl:text>&#10;</xsl:text>
      </xsl:if>
    </table>
    <xsl:text>&#10;</xsl:text>
</xsl:template>


<!-- restore the navigation bars to more like the old style -->


<xsl:template name="navigation.top">
  <xsl:param name="prev" select="''"/>
  <xsl:param name="next" select="''"/>

<xsl:text>&#10;</xsl:text>
  <xsl:comment> TOP NAVIGATION BAR </xsl:comment>
<xsl:text>&#10;</xsl:text>
  <div class="minitoc">

  Overview: <a href="{$front.filename.base}{$filename.extension}"><xsl:value-of select="/spec/header/title"/></a><br/>
  <xsl:if test="$prev">
  Previous: <xsl:apply-templates mode="divnum" select="$prev"/>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="$prev"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:apply-templates select="$prev/head/node()"/>
            </a>
    <br/>
  </xsl:if>
 <xsl:if test="$next">
  Next: <xsl:apply-templates mode="divnum" select="$next"/>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="$next"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:apply-templates select="$next/head/node()"/>
            </a>
   <br/>
  </xsl:if>
   <br/>
   <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates mode="toc" select=".">
          <xsl:with-param name="just.filename" select="'0'"/>
          <xsl:with-param name="toc.level" select="4"/>
        </xsl:apply-templates>
</div>
<xsl:text>&#10;</xsl:text>
</xsl:template>


<xsl:template name="navigation.bottom">
  <xsl:param name="prev" select="''"/>
  <xsl:param name="next" select="''"/>

  <div class="minitoc">

  Overview: <a href="{$front.filename.base}{$filename.extension}"><xsl:value-of select="/spec/header/title"/></a><br/>
  <xsl:for-each select="$prev">
  Previous:     <xsl:choose>
      <xsl:when test="ancestor::body">
        <xsl:number format="1.1 " level="multiple" count="div1|div2|div3|div4|div5"/>
      </xsl:when>
      <xsl:when test="ancestor::back">
        <xsl:number format="A.1 " level="multiple" count="div1|inform-div1|div2|div3|div4|div5"/>
      </xsl:when>
    </xsl:choose>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="."/>
<!--                  <xsl:with-param name="just.filename" select="1"/>-->
                </xsl:call-template>
              </xsl:attribute>
              <xsl:apply-templates select="head/node()"/>
            </a>
    <br/>
  </xsl:for-each>
 <xsl:for-each select="$next">
  Next:     <xsl:choose>
      <xsl:when test="ancestor::body">
        <xsl:number format="1.1 " level="multiple" count="div1|div2|div3|div4|div5"/>
      </xsl:when>
      <xsl:when test="ancestor::back">
        <xsl:number format="A.1 " level="multiple" count="div1|inform-div1|div2|div3|div4|div5"/>
      </xsl:when>
    </xsl:choose>

            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="."/>
<!--                  <xsl:with-param name="just.filename" select="1"/>-->
                </xsl:call-template>
              </xsl:attribute>
              <xsl:apply-templates select="head/node()"/>
            </a>
 </xsl:for-each>
</div>
</xsl:template>

<!-- eg roles -->

  <xsl:template match="code[@role]">
    <code class="{@role}"><xsl:apply-templates/></code>
  </xsl:template>

<xsl:template match="eg">
  <xsl:choose>
    <xsl:when test="@role">
      <xsl:choose>
        <xsl:when test="@role='mathml-error'">
          <pre class='error'>
	    <xsl:if test="@id">
	      <xsl:attribute name="id" select="translate(@id,'_','.')"/>
	    </xsl:if>
          <xsl:apply-templates/>
          </pre>
        </xsl:when>
        <xsl:when test="@role='text'">
          <blockquote>
	    <xsl:if test="@id">
	      <xsl:attribute name="id" select="translate(@id,'_','.')"/>
	    </xsl:if>
          <p><xsl:apply-templates/></p>
          </blockquote>
        </xsl:when>
        <xsl:otherwise>
          <pre class="{@role}">
	    <xsl:if test="@id">
	      <xsl:attribute name="id" select="translate(@id,'_','.')"/>
	    </xsl:if>
	    <xsl:if test="@role='generated-strict'">
	      <xsl:attribute name="style" select="'background-color:#DDDDFF'"/>
	    </xsl:if>
          <xsl:apply-templates/>
          </pre>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <pre>
	    <xsl:if test="@id">
	      <xsl:attribute name="id" select="translate(@id,'_','.')"/>
	    </xsl:if>
      <xsl:apply-templates/>
      </pre>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="eg/text()">
  <xsl:analyze-string select="." regex="&amp;(#x)?([a-zA-Z0-9]+);(&quot;>)?">
    <xsl:matching-substring>
      <xsl:choose>
	<xsl:when test="regex-group(2)=('lt','gt','amp','quot','apos')">
	  <xsl:value-of select="."/>
	</xsl:when>
	<xsl:when test="regex-group(1)=''">
	  <xsl:variable name="c" select="key('entity',regex-group(2),doc('../../xml/unicode.xml'))[1]"/>
	  <span title="{regex-group(2)}">
	    <xsl:text>&amp;#x</xsl:text>
	    <xsl:value-of select="replace(replace($c/@id,'U0*',''),'-0*',';&amp;#x')"/>
	    <xsl:text>;</xsl:text>
	  </span>
	  <xsl:value-of select="regex-group(3)"/>
	  <span class="uname">
	    <xsl:text>&lt;!--</xsl:text>
	    <xsl:value-of select="$c/description"/>
	    <xsl:text>--&gt;</xsl:text>
	  </span>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="c" select="key('id',replace(upper-case(regex-group(2)),'^0+',''),doc('../../xml/unicode.xml'))[1]"/>
	  <span title="#x{regex-group(2)}">
	   <xsl:value-of select="'&amp;',regex-group(1),regex-group(2),';'" separator=""/>
	  </span>
	  <xsl:value-of select="regex-group(3)"/>
	  <span class="uname">
	    <xsl:text>&lt;!--</xsl:text>
	    <xsl:value-of select="$c/description"/>
	    <xsl:text>--&gt;</xsl:text>
	  </span>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
<xsl:choose>
<xsl:when test="contains(.,'pattern =') and matches(.,'.{80}\|')">
<xsl:text>&#10;# wrapped for display&#10;</xsl:text>
<xsl:value-of select="replace(.,'.{80}\|','$0&#10;         ')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="replace(.,'.{80}\|','$0&#10;         ')"/>
</xsl:otherwise>
</xsl:choose>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:template>
    
<xsl:key name="entity" match="character" use="entity/@id"/>
<xsl:key name="id" match="character" use="replace(@id,'^U0*','')"/>

<!-- kw role -->

<xsl:template match="kw">
  <xsl:choose>
    <xsl:when test="@role">
      <xsl:choose>
        <xsl:when test="@role='entity'">
          <code>&amp;<xsl:apply-templates/>;</code>
        </xsl:when>
        <xsl:otherwise>
           <xsl:message>unkown role <xsl:value-of select="@role"/> on kw</xsl:message>
          <code class="error"><xsl:apply-templates/></code>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <b><xsl:apply-templates/></b>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


  <xsl:template match="el" mode="#default toc text">
  <xsl:choose>
    <xsl:when test="@role">
      <xsl:choose>
        <xsl:when test="contains(@role,'starttag')">
          <code>&lt;<xsl:apply-templates/>&gt;</code>
        </xsl:when>
        <xsl:when test="contains(@role,'endtag')">
          <code>&lt;/<xsl:apply-templates/>&gt;</code>
        </xsl:when>
        <xsl:when test="contains(@role,'emptytag')">
          <code>&lt;<xsl:apply-templates/>/&gt;</code>
        </xsl:when>
        <xsl:otherwise>
           <xsl:message>unkown role <xsl:value-of select="@role"/> on el</xsl:message>
          <code class="error"><xsl:apply-templates/></code>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
    <code><xsl:apply-templates/></code>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

<xsl:template match="tr[@diff]|td[@diff]" priority="662">
<xsl:if test="not(@diff='del' and $show.diff.markup='0')">
<xsl:text>&#10;</xsl:text>
<xsl:element name="{local-name()}">
        <xsl:copy-of select="@* except (@diff,@role,@rowspan[.=1],@colspan[.=1])"/>
        <xsl:if test="@id">
         <xsl:attribute name="id" select="translate(@id,'_','.')"/>
        </xsl:if>
        <xsl:if test="@role">
         <xsl:attribute name="class" select="@role"/>
        </xsl:if>
 <xsl:if test="string($show.diff.markup)='1'">
  <xsl:attribute name="class">diff-<xsl:value-of select="@diff"/></xsl:attribute>
 </xsl:if>
<xsl:apply-templates/>
        <xsl:call-template name="diff-back-link"/>
</xsl:element>
<xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>

<!-- don't put [Definition ... ] around termdef elements-->
<xsl:template match="termdef">
  <a name="{@id}" id="{@id}"></a>
  <xsl:apply-templates/>
</xsl:template>

  <xsl:template match="termref">
    <a class="termref" title="{key('ids', @def)/@term}">
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="key('ids', @def)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>


<!-- anchor phrases if they have an id (used in appendix a) -->
  <xsl:template match="phrase">
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </xsl:template>

<!-- don't copy the p inside def if single -->
<xsl:template match="def[not(*[2])]/p">
 <xsl:apply-templates/>
</xsl:template>

  
<!-- mathml CSS -->

<xsl:variable  name="additional.css">
  .error { color: red }
  pre.mathml {padding: 0.5em;
              background-color: #FFFFDD;}
  pre.mathml-fragment {padding: 0.5em;
              background-color: #FFFFDD;}
  pre.strict-mathml {padding: 0.5em;
              background-color: #FFFFDD;}
  .minitoc { border-style: solid;
             border-color: #0050B2; 
             border-width: 1px ;
             padding: 0.3em; }
  .attention { border-style: solid; 
               border-width: 1px ; 
               color: #5D0091;
               background: #F9F5DE; 
               border-color: red;
               margin-left: 1em;
               margin-right: 1em;
               margin-top: 0.25em;
               margin-bottom: 0.25em; }

  .attribute-Name { background: #F9F5C0; }
  .method-Name { background: #C0C0F9; }
  .IDL-definition { border-style: solid; 
               border-width: 1px ; 
               color: #001000;
               background: #E0FFE0; 
               border-color: #206020;
               margin-left: 1em;
               margin-right: 1em;
               margin-top: 0.25em;
               margin-bottom: 0.25em; }
  .baseline {vertical-align: baseline}

  #eqnoc1 {width: 10%}
  #eqnoc2 {width: 80%; text-align: center; }
  #eqnoc3 {width: 10%; text-align: right; }

div.div1 {margin-bottom: 1em;}
          
.h3style {
  text-align: left;
  font-family: sans-serif;
  font-weight: normal;
  color: #0050B2; 
  font-size: 125%;
}

  h4 { text-align: left;
       font-family: sans-serif;
       font-weight: normal;
       color: #0050B2; }
  h5 { text-align: left;
       font-family: sans-serif;
       font-weight: bold;
       color: #0050B2; } 

  th {background:  #E0FFE0;}

  p, blockquote, h4 { font-family: sans-serif; }
  dt, dd, dl, ul, li { font-family: sans-serif; }
  pre, code { font-family: monospace }


td.mathml-render {
font-family: serif;
font-size: 130%;
border: solid 4px green;
padding-left: 1em;
padding-right: 1em;
}

</xsl:variable>

<xsl:template match="blist">
  <dl>
  <xsl:apply-templates>
    <xsl:sort select="@id"/>
  </xsl:apply-templates>
  </dl>
</xsl:template>


 <xsl:template match="issue">
    <xsl:if test="$show.issues != 0 and @role!='closed'">
      <xsl:text>&#10;</xsl:text>
      <table border="1" id="{translate(@id,'_','.')}">
	<tr>
	  <th>Issue <xsl:value-of select="@id"/></th>
	  <td><tt><a href="http://www.w3.org/Math/Group/wiki/Issue_{@id}">wiki (member only)</a></tt>
         <xsl:if test="@tracker">
	<xsl:text>&#160;&#160;&#160;</xsl:text>
<a href="http://www.w3.org/2005/06/tracker/math/issues/{@tracker}">ISSUE-<xsl:value-of select="@tracker"/> (member only)</a>
</xsl:if>
</td>
	</tr>
	<tr><th colspan="2"><xsl:apply-templates select="head"/></th></tr>
	<tr><td colspan="2"><xsl:apply-templates select="*[local-name()!='resolution' and local-name()!='head']"/></td></tr>
	<tr>
	  <th>Resolution</th>
	  <td>
	    <xsl:choose>
	      <xsl:when test="resolution"><xsl:apply-templates select="resolution/node()"/></xsl:when>
	      <xsl:otherwise>None recorded</xsl:otherwise>
	    </xsl:choose>
	  </td>
	</tr>
      </table>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>


<xsl:template match="symbolref">
  <xsl:variable name="cduri" select="concat($cduriprefix,'/',@cd,'.xhtml')"/>
  <a href="{$cduri}#{@name}"><xsl:value-of select="@name"/></a>
</xsl:template>
<!--
<xsl:template match="symbolref[@cd=('interval1','calculus1','fns1','fns2','nums1','mathmlattr','mathmlkeys')]" priority="2">
  <xsl:variable name="cduri" select="concat($cduriprefix2,'/',@cd,'.xhtml')"/>
  <a href="{$cduri}#{@name}"><xsl:value-of select="@name"/></a>
</xsl:template>
-->
<xsl:template match="cdref">
  <xsl:variable name="cduri" select="concat($cduriprefix,'/',@cd,'.xhtml')"/>
  <a href="{$cduri}"><xsl:value-of select="@cd"/></a>
</xsl:template>
<!--
<xsl:template match="cdref[@cd=('interval1','calculus1','fns1','fns2','nums1','mathmlattr','mathmlkeys')]" priority="2">
  <xsl:variable name="cduri" select="concat($cduriprefix2,'/',@cd,'.xhtml')"/>
  <a href="{$cduri}#{@name}"><xsl:value-of select="@cd"/></a>
</xsl:template>
-->
<xsl:template match="importexamples">
  <xsl:variable name="cduri" select="concat($cduriprefix,'/',@ocd,'.ocd')"/>
  <xsl:variable name="symbol" select="@symbol"/>
  <xsl:variable name="examples" 
		select="document($cduri)//ocd:CDDefinition[normalize-space(ocd:Name) eq normalize-space($symbol)]
			                 /ocd:MMLexample[@speclevel=1]"/>
  <xsl:choose>
    <xsl:when test="$examples">
      <xsl:message>importing <xsl:value-of select="count($examples)"/> examples from <xsl:value-of select="$cduri"/></xsl:message>
      <xsl:apply-templates select="$examples"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Warning: no examples for symbol <xsl:value-of select="$symbol"/> in <xsl:value-of select="$cduri"/></xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- since we are working on CD stuff here we need templates in the right namespace -->
<xsl:template match="ocd:MMLexample">
  <dl>
    <dt>Example</dt>
    <dd>
      <xsl:apply-templates select="ocd:description"/>
      <pre>
	<xsl:if test="@diff and $show.diff.markup='1'">
	  <xsl:attribute name="class">
	    <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
	</xsl:if>
	<xsl:apply-templates select="node()[not(self::ocd:description)]"/>
      </pre>
    </dd>
  </dl>
</xsl:template>

<xsl:template match="ocd:description">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="ocd:var">
  <var><xsl:apply-templates/></var>
</xsl:template>

  <xsl:template match="ocd:p">
    <p>
      <xsl:copy-of select="@id"/>
      <xsl:if test="@role">
        <xsl:attribute name="class">
          <xsl:value-of select="@role"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

<xsl:template match="div[@role]">
<div class="{@role}">
 <xsl:if test="@id and not(head)">
  <xsl:attribute name="id" select="translate(@id,'_','.')"/>
 </xsl:if>
  <xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="eg/sub">
  <span style="vertical-align: sub; font-size: 70%;">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- hack for TeX logo -->
<xsl:template match="sub[.='E' and starts-with(following-sibling::text()[1],'X')]">
  <span style="vertical-align:-.4ex; margin-left:-.15ex; margin-right:-.15ex">E</span>
</xsl:template>

<xsl:template match="var[@role]">
  <var class="{@role}"><xsl:apply-templates/></var>
</xsl:template>

<xsl:template match="div2[@id='oper-dict_entries-table']/table">
 <xsl:variable  name="c" select="'priority','lspace','rspace'"/>
 <xsl:variable  name="p" select="'fence','stretchy','separator','accent','largeop','movablelimits', 'symmetric'"/>
 <xsl:variable name="v" select="'linebreakstyle','minsize'"/>
<xsl:text>&#10;</xsl:text>
 <table class="sortable">
<xsl:text>&#10;</xsl:text>
   <thead>
<xsl:text>&#10;</xsl:text>
     <tr>
<xsl:text>&#10;</xsl:text>
       <xsl:for-each select="'Character','Glyph','Name','form',$c,'Properties'">
	 <th><xsl:value-of select="."/></th>
       </xsl:for-each>
     </tr>
<xsl:text>&#10;</xsl:text>
   </thead>
<xsl:text>&#10;</xsl:text>
   <tbody>
<xsl:text>&#10;</xsl:text>
     <xsl:for-each select="doc('../../xml/unicode.xml')/unicode/charlist/character/operator-dictionary">
       <xsl:sort select="xs:integer(@priority)"/>
       <xsl:text>&#10;</xsl:text>
       <tr>
	<xsl:if test="$show.diff.markup='1'  and doc-available('../../xml/unicode-pr.xml')">
	  <xsl:if test="@linebreakstyle
          or
           not( key('opdict',concat(../@id,@form),doc('../../xml/unicode-pr.xml')))
           or
         (some $a in key('opdict',concat(../@id,@form),doc('../../xml/unicode-pr.xml'))/@*
	   satisfies $a != @*[name()=name($a)])">
          <xsl:attribute name="class" select="'diff-chg'"/>
	  </xsl:if>
	</xsl:if>
	<xsl:if test="../@id='U02ADC'">
          <xsl:attribute name="class" select="'diff-chg'"/>
	</xsl:if>
	 <xsl:variable name="od" select="."/>
	 <xsl:variable name="d" select="for $i in tokenize(../@dec,'-') return xs:integer($i)"/>
	 <xsl:text>&#10;</xsl:text>
	 <th>
	  <xsl:attribute name="abbr" select="$d[1]"/>
	   <xsl:choose>
	     <xsl:when test="empty($d[. &gt;127])">
	     <xsl:value-of select="replace(replace(codepoints-to-string($d),'&amp;','&amp;amp;'),'&lt;','&amp;lt;')"/>
	     </xsl:when>
	     <xsl:otherwise>
	       <xsl:value-of select="replace(../@id,'[U-]0*([0-9A-F]*)','&amp;#x$1;')"/>
	     </xsl:otherwise>
	   </xsl:choose>
	 </th>
	 <th>
	     <xsl:value-of select="codepoints-to-string($d)"/>
	 </th>
	 <th class="uname">
<!--
	 <xsl:if test="string-length(../description) &gt; 50">
	   <xsl:attribute name="style">
	     <xsl:text>font-size: </xsl:text>
	     <xsl:value-of select="5000 idiv string-length(../description)"/>
	     <xsl:text>%;</xsl:text>
	   </xsl:attribute>
	 </xsl:if>
-->
	 <xsl:value-of select="lower-case(../description)"/></th>
	 <th><xsl:value-of select="@form"/></th>
	 <xsl:for-each select="$c">
	   <td><xsl:value-of select="$od/@*[name()=current()]"/></td>
	 </xsl:for-each>
	 <td>
	   <xsl:value-of select="
				 $p[$od/@*[.='true']/name()=.],
				 $od/@*[name()=$v]/concat(name(),'=',.)
            " separator=", "/>
	 </td>
<xsl:text>&#10;</xsl:text>
       </tr>
<xsl:text>&#10;</xsl:text>
     </xsl:for-each>
   </tbody>
<xsl:text>&#10;</xsl:text>
 </table>
<xsl:text>&#10;</xsl:text>
</xsl:template>


<xsl:key name="opdict" match="operator-dictionary" use="concat(../@id,@form)"/>


<xsl:template match="*[@meta]/text()" priority="5">
  <xsl:variable name="r">
    <xsl:for-each select="tokenize(../@meta,'\s+')">
      <xsl:choose>
	<xsl:when test="matches(.,'^[cm]i$')">
	  <xsl:value-of select="'&lt;',.,'.*?','&lt;/',.,'>'" separator=""/>
	</xsl:when>
	<xsl:when test="matches(.,'^[a-z]+$')">
<!-- old version using apply f x
	  <xsl:value-of select="'&lt;',.,'/>|'" separator=""/>
	  <xsl:value-of select="'&lt;',.,'.*?','&lt;/',.,'>'" separator=""/>
-->
	  <xsl:value-of select="'&lt;/?',.,'/?>'" separator=""/>
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
      <span class="egmeta"><xsl:value-of select="substring(.,2,string-length(.)-2)"/></span>
	  <xsl:value-of select="substring(.,string-length(.))"/>
	</xsl:when>
	<xsl:when test="starts-with(.,'=&quot;')">
	  <xsl:text>=&quot;</xsl:text>
      <span class="egmeta"><xsl:value-of select="translate(.,'=&quot;','')"/></span>
	  <xsl:text>&quot;</xsl:text>
	</xsl:when>
	<xsl:when test="starts-with(.,'&lt;ci&gt;') or starts-with(.,'&lt;mi&gt;')">
	  <xsl:text> </xsl:text>
      <span class="egmeta"><xsl:value-of select="substring(.,5,string-length(.)-9)"/></span>
	  <xsl:text> </xsl:text>
	</xsl:when>
      <xsl:otherwise>
      <span class="egmeta"><xsl:value-of select="."/></span>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:value-of select="."/>
    </xsl:non-matching-substring>
</xsl:analyze-string>
</xsl:template>

  <xsl:template mode="divnum" match="div"/>

<!--
  <xsl:template match="phrase" mode="text">
  </xsl:template>
-->

</xsl:stylesheet>
