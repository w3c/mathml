<?xml version="1.0" encoding="ISO-8859-1" ?>

<!--
$Id: mathmlspec.xsl,v 1.95 2013-12-09 11:52:07 dcarlis Exp $
This style-sheet creates the HTML version of the MathML Recommendation.
It is based on work by Eduardo Gutentag (Sun) and James Clark, and
presently maintained by Nico Poppelier, David Carlisle for the Math WG.
-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY copy  "&#169;">
<!ENTITY reg   "&#174;">
<!ENTITY nbsp  "&#160;">
]>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:xt="http://www.jclark.com/xt"
  extension-element-prefixes="xt">

<xsl:strip-space elements="head"/>

<!--
The following parameters determine
- the type of CSS style-sheet that is used
- the location of the CSS style-sheets
- the location of W3C icons
- copyright dates
All parameters can be overridden by the user.
-->

<xsl:param name="status">WD</xsl:param>
<xsl:param name="css">http://www.w3.org/StyleSheets/TR</xsl:param>
<xsl:param name="icon">http://www.w3.org/Icons</xsl:param>
<xsl:param name="copyright">1998-2001</xsl:param>


<!-- Main output document -->
<xsl:template match="/">
  <xt:document method="html" 
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     href="Overview.html">
  <xsl:apply-templates/>
  </xt:document>
</xsl:template>

<!-- Basic framework for the MathML specification (as in the XML spec) -->
<xsl:template match="spec">
  <html>
  <xsl:call-template name="html-head"/>
  <body>
  <xsl:apply-templates/>
  </body>
  </html>
</xsl:template>

<xsl:template name="html-head">
  <xsl:param name="title" select="header/title"/>
  <head>
  <title>
  <xsl:value-of select="$title"/>
  </title>
  <style type="text/css">
  .error { color: red }
  .minitoc { border-style: solid;
             border-color: #0050B2; 
             border-width: 1px ; }
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
  </style>
  <xsl:choose>
    <xsl:when test="$status='REC' or $status='rec'">
    <link rel="stylesheet" type="text/css" href="{$css}/W3C-REC"></link>
    </xsl:when>
    <xsl:when test="$status='PR' or $status='pr'">
    <link rel="stylesheet" type="text/css" href="{$css}/W3C-PR"></link>
    </xsl:when>
    <xsl:when test="$status='CR' or $status='cr'">
    <link rel="stylesheet" type="text/css" href="{$css}/W3C-CR"></link>
    </xsl:when>
    <xsl:otherwise>
    <link rel="stylesheet" type="text/css" href="{$css}/W3C-WD"></link>
    </xsl:otherwise>
  </xsl:choose>
  </head>
</xsl:template>

<!-- Prologue -->

<xsl:template match="header">
  <div class="head">
  <a href="http://www.w3.org/">
  <img src="{$icon}/w3c_home" alt="W3C" height="48" width="72"></img>
  </a>
  <h1><xsl:value-of select="title"/></h1>
  <h2>
  <xsl:value-of select="w3c-doctype"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="pubdate/day"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="pubdate/month"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="pubdate/year"/>
  </h2>
  <dl>
  <xsl:apply-templates select="publoc"/>
  <xsl:apply-templates select="latestloc"/>
  <xsl:apply-templates select="prevlocs"/>
  <xsl:apply-templates select="edlocs"/>
  <xsl:apply-templates select="authlist"/>
  </dl>
  <xsl:call-template name="copyright"/>
  <hr></hr>
  </div>
  <xsl:apply-templates select="abstract"/>
  <xsl:apply-templates select="status"/>
</xsl:template>

<xsl:template match="publoc">
  <dt>This version:</dt>
  <dd>
    <xsl:apply-templates select="loc[not(@role='available-format')]"/>
    <xsl:apply-templates select="loc[@role='available-format']"/>
  </dd>
</xsl:template>

<xsl:template match="loc[@role='available-format']" priority="3">
 <xsl:if test="position()=1">
  <xsl:text>Also available as: </xsl:text>
 </xsl:if>
 <a href="{@href}"><xsl:apply-templates/></a>
 <xsl:if test="position() != last()">
   <xsl:text>, </xsl:text>
 </xsl:if>
</xsl:template>

<xsl:template match="latestloc">
  <dt>Latest version:</dt>
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="prevlocs">
  <dt>Previous version<xsl:if 
   test="count(loc) > 1">s</xsl:if>:</dt>
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<!-- |prevlocs/loc-->
<xsl:template match="publoc/loc|latestloc/loc">
  <a href="{@href}"><xsl:apply-templates/></a>
  <br></br>
</xsl:template>

<xsl:template match="edlocs">
  <dt>Editors' version<xsl:if 
   test="count(loc) > 1">s</xsl:if>:</dt>
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="authlist">
  <dt>
  <xsl:text>Editor</xsl:text>
  <xsl:if test="count(author[@role='editor']) > 1">s</xsl:if>:<xsl:text/>
  </dt>
  <dd><xsl:apply-templates select="author[@role='editor']"/></dd>
  <xsl:if test="author[not(@role='@editor')]">
  <dt>
  <xsl:text>Principal Authors:</xsl:text>
  </dt>
  <dd><xsl:apply-templates select="author[not(@role='editor')]"/></dd>
  </xsl:if>
</xsl:template>

<xsl:template match="author[@role='editor']">
  <xsl:apply-templates/><br></br>
</xsl:template>

<xsl:template match="author[not(@role='editor')]">
  <xsl:value-of select="name"/>
  <xsl:if test="position() != last()">, </xsl:if>
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
  <a href="{@href}">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&gt;</xsl:text>
  </a>
</xsl:template>

<xsl:template match="abstract">
  <h2><a name="abstract">Abstract</a></h2>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="status">
  <h2><a name="status">Status of this document</a></h2>
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
  <hr></hr>
  <xsl:apply-templates/>
  <hr></hr>
</xsl:template>

<xsl:template match="body">
  <h2><a name="contents">Table of contents</a></h2>
  <xsl:call-template name="toc"/>
  <hr></hr>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="back">
  <xsl:apply-templates/>
</xsl:template>

<!-- EG:
This is a rather perverse way of dealing with the divs (should
apply-templates in the div, then have a template rule for each
div/head) but it's a good way of playing with modes...
-->

<xsl:template match="div1|inform-div1">
  <xsl:variable name="divfile">
  <xsl:choose>
    <xsl:when test="ancestor::back">
      <xsl:text>appendix</xsl:text>
      <xsl:number format="a" count="div1|inform-div1"/>
    </xsl:when>
    <xsl:when test="ancestor::body">
      <xsl:text>chapter</xsl:text>
      <xsl:number format="1"/>
    </xsl:when>
  </xsl:choose>
  </xsl:variable>
  <xt:document method="html"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
              href="{$divfile}.html">
  <html>
  <xsl:call-template name="html-head">
    <xsl:with-param name="title" select="head"/>
  </xsl:call-template>  
  <body>
  <h1>
  <xsl:call-template name="makeanchor"/>
  <xsl:choose>
    <xsl:when test="ancestor::back/.">
      <xsl:number format="A " count="div1|inform-div1"/>
    </xsl:when>
    <xsl:when test="ancestor::body/.">
      <xsl:number format="1 "/>
    </xsl:when>
  </xsl:choose>
  <xsl:apply-templates select="head" mode="header"/>
  <xsl:if test="self::inform-div1">
    <xsl:text> (Non-Normative)</xsl:text>
  </xsl:if>
  </h1>
  <xsl:variable name="nav">
  Overview: <a href="Overview.html"><xsl:value-of select="/spec/header/title"/></a><br/>
  <xsl:for-each select="preceding::*[self::div1 or self::inform-div1][1]">
  Previous:     <xsl:choose>
      <xsl:when test="ancestor::body">
        <xsl:number format="1.1 " level="multiple" count="div1|div2|div3|div4|div5"/>
      </xsl:when>
      <xsl:when test="ancestor::back">
        <xsl:number format="A.1 " level="multiple" count="div1|inform-div1|div2|div3|div4|div5"/>
      </xsl:when>
    </xsl:choose>
    <xsl:call-template name="tocentry"/><br/>
  </xsl:for-each>
 <xsl:for-each select="following::*[self::div1 or self::inform-div1][1]">
  Next:     <xsl:choose>
      <xsl:when test="ancestor::body">
        <xsl:number format="1.1 " level="multiple" count="div1|div2|div3|div4|div5"/>
      </xsl:when>
      <xsl:when test="ancestor::back">
        <xsl:number format="A.1 " level="multiple" count="div1|inform-div1|div2|div3|div4|div5"/>
      </xsl:when>
    </xsl:choose>
    <xsl:call-template name="tocentry"/><br/>
  </xsl:for-each>
  </xsl:variable>
  <p class="minitoc">
  <xsl:copy-of select="$nav"/>
  &nbsp;<br/>
  <xsl:choose>
    <xsl:when test="@id='mathml-dom'">
      <xsl:for-each select=".|div2|div2/div3|div2//div4|div2//interface">
        <xsl:if test="ancestor-or-self::div3">
          <xsl:text>&nbsp;&nbsp;&nbsp;</xsl:text>
          <xsl:if test="ancestor-or-self::div4">
            <xsl:text>&nbsp;&nbsp;&nbsp;</xsl:text>
          </xsl:if>
          <xsl:if test="self::interface">
            <xsl:text>&nbsp;&nbsp;&nbsp;</xsl:text>
          </xsl:if>
        </xsl:if>
        <xsl:number format="A.1 " level="multiple" count="div1|inform-div1|div2|div3|div4|div5|interface"/>
        <xsl:call-template name="tocentry"/><br/>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
    <xsl:for-each select=".|div2|div2/div3">
    <xsl:if test="self::div3">&nbsp;&nbsp;&nbsp;</xsl:if>
    <xsl:choose>
      <xsl:when test="ancestor::body">
        <xsl:number format="1.1 " level="multiple" count="div1|div2|div3|div4|div5"/>
      </xsl:when>
      <xsl:when test="ancestor::back">
        <xsl:number format="A.1 " level="multiple" count="div1|inform-div1|div2|div3|div4|div5"/>
      </xsl:when>
    </xsl:choose>
    <xsl:call-template name="tocentry"/><br/>
  </xsl:for-each>
  </xsl:otherwise>
  </xsl:choose>
  </p>
  <xsl:apply-templates/>
<!--   <xsl:if test="@id='mathml-dom'"> -->
<!--     <xsl:call-template name="generateDOMBindings"/> -->
<!--   </xsl:if> -->
  <p class="minitoc">
  <xsl:copy-of select="$nav"/>
  </p>
  </body>
  </html>
  </xt:document>
</xsl:template>

<xsl:template match="div2">
  <h2>
  <xsl:call-template name="makeanchor"/>
  <xsl:choose>
    <xsl:when test="ancestor::back/.">
      <xsl:number level="multiple" count="inform-div1|div1|div2" format="A.1 "/>
    </xsl:when>
    <xsl:when test="ancestor::body/.">
      <xsl:number level="multiple" count="div1|div2" format="1.1 "/>
    </xsl:when>
  </xsl:choose>
  <xsl:apply-templates select="head" mode="header"/>
  </h2>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div3">
  <h3>
  <xsl:call-template name="makeanchor"/>
  <xsl:choose>
    <xsl:when test="ancestor::back/.">
      <xsl:number level="multiple" count="inform-div1|div1|div2|div3" format="A.1.1 "/>
    </xsl:when>
    <xsl:when test="ancestor::body/.">
      <xsl:number level="multiple" count="div1|div2|div3" format="1.1.1 "/>
    </xsl:when>
  </xsl:choose>
  <xsl:apply-templates select="head" mode="header"/>
  </h3>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div4">
  <h4>
  <xsl:call-template name="makeanchor"/>
  <xsl:choose>
    <xsl:when test="ancestor::back/.">
      <xsl:number level="multiple" count="inform-div1|div1|div2|div3|div4" format="A.1.1.1 "/>
    </xsl:when>
    <xsl:when test="ancestor::body/.">
      <xsl:number level="multiple" count="div1|div2|div3|div4" format="1.1.1.1 "/>
    </xsl:when>
  </xsl:choose>
  <xsl:apply-templates select="head" mode="header"/>
  </h4>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div5">
  <h5>
  <xsl:call-template name="makeanchor"/>
  <xsl:apply-templates select="head" mode="header"/>
  </h5>
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


<xsl:template match="p">
  <xsl:apply-templates select="." mode="p">
    <xsl:with-param name="x" 
         select="count(eg|glist|olist|ulist|slist|orglist|
                       table|issue|ednote|note|processing-instruction()|
                       graphic[not(@role='inline')])" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="p" match="p">
<xsl:param name="x"/>
  <p>
  <xsl:apply-templates 
    select="node()[not(self::eg or self::glist or self::olist or
                       self::ulist or self::slist or self::orglist or
                       self::table or self::issue or self::ednote or self::note or
                       self::processing-instruction() or
                       self::graphic[not(@role='inline')]) and
    count(following-sibling::*[self::eg or self::glist or self::olist or
                               self::ulist or self::slist or self::orglist or
                               self::table or self::issue or self::note or
                               self::processing-instruction() or
                               self::graphic[not(@role='inline')] ])
         = $x]" />
  </p>
  <xsl:apply-templates
       select="(eg|glist|olist|ulist|slist|orglist|
                table|issue|note|processing-instruction()|
                graphic[not(@role='inline')])
                  [position() = last() - $x + 1]"/>
  <xsl:if test="$x &gt; 0">
    <xsl:apply-templates select="." mode="p">
      <xsl:with-param name="x" select="$x - 1" />
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="eg">
  <xsl:choose>
    <xsl:when test="@role">
      <xsl:choose>
        <xsl:when test="@role='mathml-error'">
          <pre class='error'>
          <xsl:apply-templates/>
          </pre>
        </xsl:when>
        <xsl:when test="@role='text'">
          <blockquote>
          <p><xsl:apply-templates/></p>
          </blockquote>
        </xsl:when>
        <xsl:otherwise>
          <pre>
          <xsl:apply-templates/>
          </pre>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <pre>
      <xsl:apply-templates/>
      </pre>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ednote">
  <blockquote>
  <p><b>Editor's note:</b>
  <xsl:apply-templates/></p></blockquote>
</xsl:template>

<xsl:template match="ednote/date">
  (<xsl:apply-templates/>)<br></br>
</xsl:template>

<xsl:template match="edtext">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="issue">
  <div class="attention">
  <blockquote>
  <p>
  <b><xsl:call-template name="makeanchor"
     />Issue (<xsl:value-of select="substring-after(@id,'-')"/>): </b>
  </p>
  <xsl:apply-templates/>
  </blockquote>
  </div>
</xsl:template>

<xsl:template match="note">
  <blockquote>
  <p><b>Note: </b></p><xsl:apply-templates/>
  </blockquote>
</xsl:template>

<!--
<xsl:template match="ednote/p|issue/p|note/p">
  <xsl:apply-templates/>
  <xsl:if test="position() != last()"><br/><br/></xsl:if>
</xsl:template>
-->

<!-- Tables -->
<xsl:template match="table">
  <table>
  <xsl:copy-of select="@*"/>
  <xsl:if test="not(@cellpadding)">
    <xsl:attribute name="cellpadding">3</xsl:attribute>
  </xsl:if>
  <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="thead">
  <thead>
  <xsl:apply-templates/>
  </thead>
</xsl:template>

<xsl:template match="tbody">
  <tbody>
  <xsl:apply-templates/>
  </tbody>
</xsl:template>

<xsl:template match="tr">
  <tr>
  <xsl:copy-of select="@bgcolor|@rowspan|@colspan|@align|@valign"/>
  <xsl:apply-templates/>
  </tr>
</xsl:template>

<xsl:template match="td">
  <td>
  <xsl:copy-of select="@bgcolor|@rowspan|@colspan|@align|@valign"/>
  <xsl:choose>
    <xsl:when test="not(*) and normalize-space(.)=''">&nbsp;</xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  </td>
</xsl:template>

<xsl:template match="thead/tr/td">
  <th>
  <xsl:copy-of select="@bgcolor|@rowspan|@colspan|@align|@valign"/>
  <xsl:choose>
    <xsl:when test="normalize-space(.)=''">&nbsp;</xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  </th>
</xsl:template>

<xsl:template match="caption">
  <caption><xsl:apply-templates/></caption>
</xsl:template>

<!-- References -->

<!-- why the br ? (dpc)
<xsl:template match="p/loc|bibl/loc" priority="1">
  <a href="{@href}"><xsl:apply-templates/></a>
</xsl:template>


<xsl:template match="loc">
  <a href="{@href}"><xsl:apply-templates/></a><br></br>
</xsl:template>
-->

<xsl:template match="loc">
  <a href="{@href}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="loc[@role='dead']" priority="3">
  <xsl:apply-templates/>
</xsl:template>



<xsl:template match="titleref">
  <a href="{@href}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="bibref">
  <xsl:for-each select="id(@ref)">
    <xsl:call-template name="makeref"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="specref">
  <xsl:for-each select="id(@ref)">
    <xsl:call-template name="makeref"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="intref">
  <a href="{id(@ref)/ancestor-or-self::*[(self::div1 or self::inform-div1)
     and @role]/@role}.html#{@ref}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="xspecref">
  <a href="{@href}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="termref">
  <a href="{ancestor::*[@role]/@role}.html#{@ref}">
  <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="vcnote">
  <a name="{@id}"></a>
  <p><b>Validity Constraint: <xsl:value-of select="head"/></b></p>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="wfcnote">
  <a name="{@id}"></a>
  <p><b>Well-formedness Constraint: <xsl:value-of select="head"/></b></p>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="xtermref">
  <a href="{@href}"><xsl:apply-templates/></a>
</xsl:template>

<!-- Inlines -->
<xsl:template match="termdef">
  <a name="{@id}"></a>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="term">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="code">
  <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="emph">
  <xsl:call-template name="makeanchor"/>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="kw">
  <xsl:choose>
    <xsl:when test="@role">
      <xsl:choose>
        <xsl:when test="@role='element' or @role='attrib' or @role='attval'
                        or @role='charname'">
          <code><xsl:apply-templates/></code>
        </xsl:when>
        <xsl:when test="@role='starttag'">
          <code>&lt;<xsl:apply-templates/>&gt;</code>
        </xsl:when>
        <xsl:when test="@role='endtag'">
          <code>&lt;/<xsl:apply-templates/>&gt;</code>
        </xsl:when>
        <xsl:when test="@role='emptytag'">
          <code>&lt;<xsl:apply-templates/>/&gt;</code>
        </xsl:when>
        <xsl:when test="@role='entity'">
          <code>&amp;<xsl:apply-templates/>;</code>
        </xsl:when>
        <xsl:when test="@role='mchar'">
          <code>&lt;mchar name="<xsl:apply-templates/>" /&gt;</code>
        </xsl:when>
        <xsl:otherwise>
          <code class="error"><xsl:apply-templates/></code>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <code><xsl:apply-templates/></code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="mi">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="sub">
  <sub><xsl:apply-templates/></sub>
</xsl:template>

<xsl:template match="sup">
  <sup><xsl:apply-templates/></sup>
</xsl:template>

<!-- Lists -->
<xsl:template match="blist">
  <dl>
  <xsl:apply-templates>
    <xsl:sort select="@id"/>
  </xsl:apply-templates>
  </dl>
</xsl:template>

<xsl:template match="slist">
  <ul>
  <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="sitem">
  <li>
  <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="blist/bibl">
  <dt><a name="{@id}"></a>
    <xsl:choose>
      <xsl:when test="@key">
        <xsl:value-of select="@key"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </dt>
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="orglist">
  <ul>
  <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="member">
  <li>
  <xsl:apply-templates select="name"/>
  <xsl:if test="role">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="role"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:if test="affiliation">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="affiliation"/>
  </xsl:if>
  </li>
</xsl:template>

<xsl:template match="member/affiliation">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="member/role">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="olist">
  <ol>
  <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match="ulist">
  <ul>
  <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="glist">
  <dl>
  <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="item">
  <li>
  <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="label">
  <dt><xsl:if test="@id"><a name="{@id}"/></xsl:if>
   <b><xsl:apply-templates/></b>
 </dt>
</xsl:template>

<xsl:template match="def">
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="gitem">
  <xsl:apply-templates/>
</xsl:template>

<!-- Named templates -->

<xsl:template name="copyright">
<p class="copyright"><a href="http://www.w3.org/Consortium/Legal/ipr-notice#Copyright">  Copyright</a> &#xa9;2003 <a href="http://www.w3.org/"><acronym title="World Wide Web Consortium">W3C</acronym></a><sup>&#xae;</sup>  (<a href="http://www.lcs.mit.edu/"><acronym title="Massachusetts Institute of Technology">MIT</acronym></a>, <a href="http://www.ercim.eu/"><acronym title="European Research Consortium for Informatics and Mathematics">ERCIM</acronym></a>, <a href="http://www.keio.ac.jp/">Keio</a>), All Rights Reserved. W3C <a href="http://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer">liability</a>, <a href="http://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks">trademark</a>, <a href="http://www.w3.org/Consortium/Legal/copyright-documents">document use</a> and <a href="http://www.w3.org/Consortium/Legal/copyright-software">software licensing</a> rules apply.</p>
</xsl:template>

<xsl:template name="toc">
  <!-- none of the front-matter sections -->
  <p>
  <!-- body sections, numbered 1, 2, 3, ... -->
  <xsl:for-each select="/spec/body/div1">
    <xsl:number format="1 "/>
    <xsl:call-template name="tocentry"/>
    <br/>
    <xsl:for-each select="div2">
      <xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
      <xsl:number level="multiple" count="div1|div2" format="1.1 "/>
      <xsl:call-template name="tocentry"/>
      <br></br>
    </xsl:for-each>
  </xsl:for-each>
  </p>

  <!-- appendices, numbered A, B, C, ... 
   test on 9 to make I. take more space -->
  <h3>Appendices</h3>
  <p>
  <xsl:for-each select="/spec/back/div1 | /spec/back/inform-div1">
    <xsl:number format="A " count="div1|inform-div1"/>
    <xsl:if test="position()=9"><xsl:text>&nbsp;</xsl:text></xsl:if>
    <xsl:call-template name="tocentry"/>
    <br></br>
    <xsl:for-each select="div2">
      <xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
      <xsl:number level="multiple" count="div1|div2|inform-div1" format="A.1 "/>
      <xsl:call-template name="tocentry"/>
      <br></br>
    </xsl:for-each>
  </xsl:for-each>
  </p>
</xsl:template>

<!-- produce a cross-reference target for the current element 
  (this is called "insertID" in James Clarke's version)
  In head case just use generate-id and get a name that is guaranteed
  to be valid, if unintelligible, efforts to use the head text
  and not use invalid id characters, and stay unique produced
 "{generate-id(.)}-{translate(normalize-space(head),' ,./','-')}"
 but that still failed on some cases, so give up and just use generate-id.
 By now most if not all relevant elements have an explict id anyway.
-->
<xsl:template name="makeanchor">
  <xsl:choose>
    <xsl:when test="@id">
      <a name="{@id}"/>
    </xsl:when>
    <xsl:when test="head">
     <a name="{generate-id(.)}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- produce a TOC entry for the current div* element -->
<xsl:template name="tocentry">
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
    <xsl:when test="@role">
      <a href="{@role}.html">
      <xsl:apply-templates select="head" mode="toc"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <a href="{ancestor::*[@role]/@role}.html#{$id}">
      <xsl:choose>
        <xsl:when test="head">
          <xsl:apply-templates select="head" mode="toc"/>
        </xsl:when>
        <xsl:when test="self::interface">
          <xsl:value-of select="@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$id"/>
        </xsl:otherwise>
      </xsl:choose>
      </a>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="name(.)='inform-div1'">
    <xsl:text> (Non-normative)</xsl:text>
  </xsl:if>
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
    <xsl:when test="(self::div1 or self::inform-div1) and ancestor::body">
      <a href="{@role}.html">
      <xsl:text>Chapter&nbsp;</xsl:text>
      <xsl:number format="1 " level="single" count="div1"/>
      <xsl:text>[</xsl:text>
      <xsl:apply-templates select="head" mode="toc"/>
      <xsl:text>]</xsl:text>
      </a>
    </xsl:when>
    <xsl:when test="(self::div1 or self::inform-div1) and ancestor::back">
      <a href="{@role}.html">
      <xsl:text>Appendix&nbsp;</xsl:text>
      <xsl:number format="A " level="single" count="div1|inform-div1"/>
      <xsl:text>[</xsl:text>
      <xsl:apply-templates select="head" mode="toc"/>
      <xsl:text>]</xsl:text>
      </a>
    </xsl:when>
    <xsl:when test="contains(name(.), 'div')">
      <a href="{ancestor::*[@role]/@role}.html#{$id}">
      <xsl:text>Section&nbsp;</xsl:text>
      <xsl:choose>
        <xsl:when test="ancestor::body">
          <xsl:number format="1.1 " level="multiple" count="div1|div2|div3|div4|div5"/>
        </xsl:when>
        <xsl:when test="ancestor::back">
          <xsl:number format="A.1 " level="multiple" count="div1|inform-div1|div2|div3|div4|div5"/>
        </xsl:when>
      </xsl:choose>
      <xsl:text>[</xsl:text>
      <xsl:apply-templates select="head" mode="toc"/>
      <xsl:text>]</xsl:text>
      </a>
    </xsl:when>
    <xsl:when test="self::interface">
      <a href="{ancestor::*[@role]/@role}.html#{@id}">
      <xsl:text>[</xsl:text>
      <code><xsl:value-of select="@name"/></code>
      <xsl:text> interface]</xsl:text>
      </a>
    </xsl:when>
    <xsl:when test="self::bibl">
      <xsl:text>[</xsl:text>
      <xsl:choose>
        <xsl:when test="@key">
          <a href="{ancestor::*[@role]/@role}.html#{@key}">
          <xsl:value-of select="@key"/>
          </a>
        </xsl:when>
        <xsl:when test="@id">
          <a href="{ancestor::*[@role]/@role}.html#{@id}">
          <xsl:value-of select="@id"/>
          </a>
        </xsl:when>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <a href="{ancestor::*[@role]/@role}.html#{@id}">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates select="head" mode="toc"/>
      <xsl:text>]</xsl:text>
      </a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="nt">
  <a href="{ancestor::*[@role]/@role}.html#{@def}">
  <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="xnt">
  <a href="{ancestor::*[@role]/@role}.html#{@href}">
  <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="quote">
  <xsl:text>`</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>'</xsl:text>
</xsl:template>

<xsl:template match="graphic">
  <xsl:choose>
    <xsl:when test="@role='inline'">
      <xsl:choose>
        <xsl:when test="@valign='bottom'">
          <img src="{@source}" alt="{@alt}" align="bottom"></img>
        </xsl:when>
        <xsl:otherwise>
          <img src="{@source}" alt="{@alt}" align="middle"></img>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <blockquote>
      <p><img src="{@source}" alt="{@alt}"></img></p>
      </blockquote>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="head" mode="toc">
  <xsl:apply-templates/>
</xsl:template>

<!-- Templates for DOM-style interface definitions  -->
<xsl:template match="interface">
  <h3><xsl:call-template name="makeanchor"/>
  Interface <xsl:value-of select="@name"/></h3>
  <xsl:if test="string-length(normalize-space(@inherits))&gt;0">
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
   <dt><code class="attribute-Name"><xsl:value-of
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
</xsl:template>

<xsl:template match="descr">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="definitions">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="exception">
  <dt><code><xsl:value-of select="@name"/></code></dt>
  <dd><xsl:apply-templates/></dd>
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
  <tr>
  <td class="baseline"><xsl:call-template name="dom-type"/></td>
  <td class="baseline"><code><xsl:value-of select="@name"/></code></td>
  <td class="baseline"><xsl:apply-templates select="descr"/></td>
  </tr>
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
     <xsl:value-of select="id('mathml-dom')/@role"/><xsl:text>.html</xsl:text>
  </xsl:if
   >#dom_<xsl:value-of select="substring-after($type, 'MathML')"/>
 </xsl:when>
 <xsl:when test="$type = 'DOMString'"
 >http://www.w3.org/TR/DOM-Level-2-Core/core.html#DOMString</xsl:when>
<xsl:when test="$type = 'Document'"
 >http://www.w3.org/TR/DOM-Level-2-Core/core.html#i-Document</xsl:when>
 <xsl:otherwise>
  http://www.w3.org/TR/DOM-Level-2-Core/core.html
 </xsl:otherwise>
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
<!-- UNCOMMENT NEXT LINE TO GENERATE IDL FILE IN THIS DIRECTORY -->
<!--       <xsl:apply-templates select="id('mathml-dom')" mode="extFileIDLInterfaces"/> -->
        </xsl:when>
        <xsl:when test="parent::div2/@id='dom-bindings_JavaBindings'">
          <xsl:apply-templates select="id('mathml-dom')" mode="javaInterfaces"/>
<!-- UNCOMMENT NEXT LINE TO GENERATE JAVA FILES IN DIRECTORY java/org/w3c/dom/mathml -->
<!--        <xsl:apply-templates select="id('mathml-dom')" mode="extFileJavaInterfaces"/> -->
        </xsl:when>
        <xsl:when test="parent::div2/@id='dom-bindings_ECMABinding'">
          <xsl:apply-templates select="id('mathml-dom')" mode="ecmaInterfaces"/>
<!-- UNCOMMENT NEXT LINE TO GENERATE SEPARATE ECMASCRIPT BINDING FILE (HTML) -->
<!--       <xsl:apply-templates select="id('mathml-dom')" mode="extFileEcmaInterfaces"/> -->
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
    <xsl:otherwise>
    <p class="error">Unrecognised processing instruction
      <xsl:value-of select="name(.)"/></p>
    </xsl:otherwise>
  </xsl:choose>
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

<!-- <xsl:template name="generateDOMBindings"> -->
<!--   <xt:document method="html" -->
<!--      doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" -->
<!--      doctype-system="http://www.w3.org/TR/html4/loose.dtd" -->
<!--      href="mathml-dom_bindings.html"> -->
<!--     <html> -->
<!--     <xsl:variable name="domBindingsTitle">MathML Document Object Model Bindings</xsl:variable> -->
<!--     <xsl:call-template name="html-head"> -->
<!--       <xsl:with-param name="title" select="$domBindingsTitle"/> -->
<!--     </xsl:call-template> -->
<!--     <body> -->
<!--     <h1><a name="DOMBindings"/><xsl:text xml:space="preserve">1. </xsl:text><xsl:value-of select="$domBindingsTitle"/></h1> -->
<!--     <h2><a name="IDLBinding"/>MathML Document Object Model IDL Binding</h2> -->
<!--     <xsl:apply-templates select="." mode="IDLInterfaces"/> -->
<!--     <h2><a name="JavaBindings"/>2. MathML Document Object Model Java Binding</h2> -->
<!--     <xsl:apply-templates select="." mode="javaInterfaces"/> -->
<!--     <h2><a name="ECMABinding"/>3. MathML Document Object Model ECMAScript Binding</h2> -->
<!--     <xsl:apply-templates select="." mode="ecmaInterfaces"/> -->
<!--     </body></html> -->
<!--   </xt:document> -->
<!-- </xsl:template> -->

<!-- Productions -->
<xsl:template match="scrap">
  <table cellpadding='5' border='1' bgcolor='#f5dcb3' width="100%">
  <tbody>
  <tr align="left">
  <td><strong><xsl:value-of select="head"/></strong></td>
  </tr>
  <tr><td>
  <table border='0' bgcolor='#f5dcb3'>
  <tbody>
  <xsl:apply-templates/>
  </tbody>
  </table>
  </td></tr>
  </tbody>
  </table>
</xsl:template>

<xsl:template match="prod">
  <!-- select elements that start a row -->
  <xsl:apply-templates select="
    *[self::lhs or
      ( (self::vc or self::wfc or self::com) and
        not(preceding-sibling::*[1][self::rhs]) or
        (self::rhs and not(preceding-sibling::*[1][self::lhs]))
      )]"/>
</xsl:template>

<xsl:template match="lhs">
  <tr valign="baseline">
  <td><a name="{../@id}"></a>
  <code>
  <xsl:number from="body" level="any" format="[1]&nbsp;&nbsp;&nbsp;"/>
  </code>
  </td>
  <td align="right"><code><xsl:apply-templates/></code></td>
  <td>
  <code><xsl:text>&nbsp;::=&nbsp;</xsl:text></code>
  </td>
  <xsl:for-each select="following-sibling::*[1]">
    <td><xsl:apply-templates mode="cell" select="."/></td>
    <td><xsl:apply-templates mode="cell" select="following-sibling::*[1][self::vc or self::wfc or self::com]"/></td>
  </xsl:for-each>
  </tr>
</xsl:template>

<xsl:template match="rhs">
  <tr valign="baseline">
  <td></td>
  <td></td>
  <td></td>
  <td><xsl:apply-templates mode="cell" select="."/></td>
  <td><xsl:apply-templates mode="cell" select="following-sibling::*[1][self::vc or self::wfc or self::com]"/></td>
  </tr>
</xsl:template>

<xsl:template match="vc|wfc|com">
  <tr valign="baseline">
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td><xsl:apply-templates mode="cell" select="."/></td>
  </tr>
</xsl:template>

<xsl:template match="prodgroup">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="com" mode="cell">
  <xsl:text>/*</xsl:text>
  <code><xsl:apply-templates/></code>
  <xsl:text>*/</xsl:text>
</xsl:template>

<xsl:template match="rhs" mode="cell">
  <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="vc" mode="cell">
  <code>
  <xsl:text>[VC:&nbsp;</xsl:text>
  <a href="#{@def}">
  <xsl:value-of select="id(@def)/head"/>
  </a>
  <xsl:text>]</xsl:text>
  <xsl:apply-templates/>
  </code>
</xsl:template>

<xsl:template match="wfc" mode="cell">
  <code>
  <xsl:text>[WFC:&nbsp;</xsl:text>
  <a href="#{@def}">
  <xsl:value-of select="id(@def)/head"/>
  </a>
  <xsl:text>]</xsl:text>
  <xsl:apply-templates/>
  </code>
</xsl:template>

<!-- Default template (primarily for debugging purposes) -->
<xsl:template match="*">
  <font color="red">&lt;<xsl:value-of select="name(.)"/>&gt;</font>
  <xsl:apply-templates/>
  <font color="red">&lt;/<xsl:value-of select="name(.)"/>&gt;</font>
  <xsl:message> BAD element: <xsl:value-of select="name(.)"/></xsl:message>
</xsl:template>


<!-- appendix c 


<xsl:template match="MMLdefinition">
  <h4><xsl:call-template name="makeanchor"/>
      <xsl:number level="multiple" count="inform-div1|div1|div2|div3|div4|MMLdefinition" format="A.1.1.1 "/>
  MMLdefinition: <code><xsl:value-of select="name"/></code>
  </h4>
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

  <xsl:if test="signature">
  <dt>Signature</dt>
  <dd>
  <xsl:for-each select="signature">
    <p><xsl:value-of select="."/></p>
  </xsl:for-each>
  </dd>
  </xsl:if>


  <xsl:apply-templates select="property|example"/>

  </dl>

</xsl:template>-->


<xsl:template match="example">
<dt>Example</dt>
<dd><xsl:apply-templates select="description"/><pre>
<xsl:apply-templates select="text()"/>
</pre></dd>
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
  <xsl:apply-templates select="text()"/>
</pre></dd>
</xsl:template>

<xsl:template match="description">
  <xsl:apply-templates/>
</xsl:template>

<!--<xsl:template match="discussion">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="MMLdefinition/name"/>
<xsl:template match="MMLdefinition/functorclass"/>
<xsl:template match="MMLdefinition/signature"/>
 <xsl:template match="MMLdefinition/description">
<dt>Description</dt>
<dd><xsl:apply-templates/>
   <p>See also
   <xsl:variable name="x" 
     select="id(concat('contm_',normalize-space(preceding-sibling::name)))"/>
   <xsl:choose>
   <xsl:when test="$x">
   <xsl:for-each select="$x">
     <xsl:call-template name="makeref"/>
   </xsl:for-each>
   </xsl:when>
   <xsl:otherwise>
   <xsl:for-each select="id('contm_trig')">
     <xsl:call-template name="makeref"/>
   </xsl:for-each>
   </xsl:otherwise>
   </xsl:choose>.</p>
</dd>
</xsl:template>-->

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

<xsl:template match="div1[@id='mathml-dom']" mode="extFileIDLInterfaces">
  <xt:document method="text"
        href="mathml-dom.idl">
    <xsl:value-of select="$idlFileHeader"/>
    <xsl:apply-templates mode="IDLgetForwardDeclarations"/> 
    <xsl:value-of select="$IDLindent1"/>
    <xsl:apply-templates mode="IDLInterfaces"/>
    <xsl:value-of select="$idlFileFooter"/>
  </xt:document>
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
    <xsl:text xml:space="preserve">
import org.w3c.</xsl:text><xsl:value-of select="$theSource"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$theEntity"/>
    <xsl:text>;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- javaInterfaces Templates -->

<xsl:template match="interface" mode="javaInterfaces">
  <h3>
  <xsl:text>org/w3c/dom/mathml/</xsl:text><xsl:value-of select="@name"/><xsl:text>.java</xsl:text>
  </h3>
  <div class="IDL-definition"><pre>
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
    <xsl:text xml:space="preserve">};
    </xsl:text>
  </pre></div>
</xsl:template>

<xsl:template match="interface" mode="extFileJavaInterfaces">
  <xt:document method="text"
        href="java/org/w3c/dom/mathml/{@name}.java">
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
    <xsl:text xml:space="preserve">};
  </xsl:text>
  </xt:document>
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

<!-- <xsl:template match="*" mode="extFileJavaInterfaces"> -->
<!-- </xsl:template> -->

<!-- ECMAScript Binding -->

<xsl:template match="div1[@id='mathml-dom']" mode="ecmaInterfaces">
  <div class="IDL-definition">
  <xsl:apply-templates mode="ecmaInterfaces" select=".//interface"/>
  </div>
</xsl:template>

<xsl:template match="div1[@id='mathml-dom']" mode="extFileEcmaInterfaces">
  <xt:document method="html"
        href="mathml-dom_ecma.html">
  <html>
  <xsl:call-template name="html-head">
    <xsl:with-param name="title">
	  <xsl:text>MathML Document Object Model ECMAScript Binding</xsl:text>
	</xsl:with-param>
  </xsl:call-template>
  <body>
  <h2>MathML Document Object Model ECMAScript Binding</h2>
  <xsl:apply-templates mode="ecmaInterfaces" select=".//interface"/>
  </body></html>
  </xt:document>
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
  <xsl:if test="string-length(normalize-space(@inherits))>0">
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
  <dd>
  <dl><dt>
  <strong><xsl:value-of select="@name"/></strong></dt>
  <dd>
  <xsl:text xml:space="preserve">This property is of type </xsl:text>
  <strong><xsl:value-of select="@type"/></strong>
  <xsl:text>.</xsl:text>
  </dd>
  </dl></dd>
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
    <xsl:when test="string-length($returnType) = 0">
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
          <xsl:text>.html</xsl:text>
		</xsl:if>
		<xsl:text>#dom_</xsl:text>
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


</xsl:stylesheet>

