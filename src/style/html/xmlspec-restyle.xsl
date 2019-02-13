<?xml version="1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="2.0">

<!-- ====================================================================== -->
<!-- xmlspec.xsl: An HTML XSL[1] Stylesheet for XML Spec V2.1[2] markup

     Version: $Id: xmlspec.xsl,v 1.15 2015/06/21 10:53:30 dcarlis Exp $

     URI:     http://dev.w3.org/cvsweb/spec-prod/html/xmlspec.xsl

     Authors: Norman Walsh (norman.walsh@sun.com)
              Chris Maden (crism@lexica.net)
              Ben Trafford (ben@legendary.org)
              Eve Maler (eve.maler@sun.com)
              Henry S. Thompson (ht@cogsci.ed.ac.uk)

     Date:    Created 07 September 1999
              Last updated $Date: 2015/06/21 10:53:30 $ by $Author: dcarlis $

     Copyright (C) 2000, 2001, 2002 Sun Microsystems, Inc. All Rights Reserved.
     This document is governed by the W3C Software License[3] as
     described in the FAQ[4].

       [1] http://www.w3.org/TR/xslt
       [2] http://www.w3.org/XML/1998/06/xmlspec-report-v21.htm
       [3] http://www.w3.org/Consortium/Legal/copyright-software-19980720
       [4] http://www.w3.org/Consortium/Legal/IPR-FAQ-20000620.html#DTD

     Notes:

     This stylesheet attempts to implement the XML Specification V2.1
     DTD.  Documents conforming to earlier DTDs may not be correctly
     transformed.

     ChangeLog: (See also: CVS ChangeLog)

     15 August 2002: Norman Walsh, <Norman.Walsh@Sun.COM>
       - Version 1.3 released at http://www.w3.org/2002/xmlspec/html/1.3/xmlspec.xsl
         There have never been any "official" releases before, so the version number
         is arbitrary.

     15 August 2001: Hugo Haas <hugo@w3.org>
       - Slightly modified the status sentence introducing editors'
         copies.
       - Now using role to distinguish editors' copies: e.g.
         <spec w3c-doctype="wd" role="editors-copy">

     14 August 2001: Hugo Haas <hugo@w3.org>
       - If w3c-doctype is not a W3C TR, do not use a Note style
         sheet, use <http://www.w3.org/StyleSheets/TR/base.css>
         instead.
       - If the other-doctype is "editors-copy", do not use the W3C
         logo and mark the document as such in the status section.

     12 Jun 2001: (Norman.Walsh@Sun.COM)
       - Support non-tabular examples. If tabular.examples is non-zero,
         tables will be used for examples, otherwise nested divs and
         CSS will be used. tabular.examples is *zero* by default.

     06 Jun 2001: (Norman.Walsh@Sun.COM)
       - Support copyright element in header; use the content of that
         element if it is present, otherwise use the auto-generated
         copyright statement.

     15 May 2001: (Norman.Walsh@Sun.COM)
       - Changed copyright link to point to dated IPR statement:
         http://www.w3.org/Consortium/Legal/ipr-notice-20000612

     25 Sep 2000: (Norman.Walsh@East.Sun.COM)
       - Sync'd with Eve's version:
         o Concatenated each inline element's output all on one line
           to avoid spurious spaces in the output. (This is really an
           IE bug, but...) (15 Sep 2000)
         o Updated crism's email address in header (7 Sep 2000)
         o Changed handling of affiliation to use comma instead of
           parentheses (9 Aug 2000)

     14 Aug 2000: (Norman.Walsh@East.Sun.COM)

       - Added additional.title param (for diffspec.xsl to change)
       - Fixed URI of W3C home icon
       - Made CSS stylesheet selection depend on the w3c-doctype attribute
         of spec instead of the w3c-doctype element in the header

     26 Jul 2000: (Norman.Walsh@East.Sun.COM)

       - Improved semantics of specref. Added xsl:message for unsupported
         cases. (I'm by no means confident that I've covered the whole
         list.)
       - Support @role on author.
       - Make lhs/rhs "code" in EBNF.
       - Fixed bug in ID/IDREF linking.
       - More effectively disabled special markup for showing @diffed
         versions

     21 Jul 2000: (Norman.Walsh@East.Sun.COM)

       - Added support for @diff change tracking, primarily through
         the auxiliary stylesheet diffspec.xsl. However, it was
         impractical to handle some constructions, such as DLs and TABLEs,
         in a completely out-of-band manner. So there is some inline
         support for @diff markup.

       - Added $additional.css to allow downstream stylesheets to add
         new markup to the <style> element.

       - Added required "type" attribute to the <style> element.

       - Fixed pervasive problem with nested <a> elements.

       - Added doctype-public to xsl:output.

       - Added $validity.hacks. If "1", then additional disable-output-escaping
         markup may be inserted in some places to attempt to get proper,
         valid HTML. For example, if a <glist> appears inside a <p> in the
         xmlspec source, this creates a nested <dl> inside a <p> in the
         HTML, which is not valid. If $validity.hacks is "1", then an
         extra </p>, <p> pair is inserted around the <dl>.

   5 June 2001, Henry S. Thompson (ht@cogsci.ed.ac.uk)

       - Fixed a link in copyright boilerplate to be dated

  -->
<!-- ====================================================================== -->

  <xsl:preserve-space elements="*"/>

  <xsl:strip-space elements="
   abstract arg attribute authlist author back bibref blist body case col
   colgroup component constant constraint constraintnote copyright def
   definitions descr div div1 div2 div3 div4 div5 ednote enum enumerator
   example exception footnote front gitem glist graphic group header
   htable htbody inform-div1 interface issue item itemizedlist langusage
   listitem member method module note notice ol olist orderedlist orglist
   param parameters prod prodgroup prodrecap proto pubdate pubstmt raises
   reference resolution returns revisiondesc scrap sequence slist
   sourcedesc spec specref status struct table tbody tfoot thead tr
   typedef ul ulist union vc vcnote wfc wfcnote"/>

  <xsl:param name="editors-copy" select="'yes'"/>
  <xsl:param name="validity.hacks">1</xsl:param>
  <xsl:param name="show.diff.markup">0</xsl:param>
  <xsl:param name="additional.css"></xsl:param>
  <xsl:param name="additional.title"></xsl:param>
  <xsl:param name="called.by.diffspec">0</xsl:param>
  <xsl:param name="show.ednotes">1</xsl:param>
  <xsl:param name="show.issues">1</xsl:param>
  <xsl:param name="tabular.examples">0</xsl:param>
  <xsl:param name="toc.level" select="5"/>

  <xsl:key name="ids" match="*[@id]" use="@id"/>
  <xsl:key name="specrefs" match="specref" use="@ref"/>

  <xsl:output method="html"
	      version="5"
       encoding="utf-8"
       indent="no"/>

  <xsl:strip-space elements="author"/>

  <!-- not handled:
    attribute:   unhandled IDL stuff
    case:        unhandled IDL stuff
    component:   unhandled IDL stuff
    constant:    unhandled IDL stuff
    copyright:   boilerplate notice always used instead
    definitions: unhandled IDL stuff
    descr:       unhandled IDL stuff
    enum:        unhandled IDL stuff
    enumerator:  unhandled IDL stuff
    exception:   unhandled IDL stuff
    group:       unhandled IDL stuff
    interface:   unhandled IDL stuff
    method:      unhandled IDL stuff
    module:      unhandled IDL stuff
    param:       unhandled IDL stuff
    parameters:  unhandled IDL stuff
    raises:      unhandled IDL stuff
    reference:   unhandled IDL stuff
    returns:     unhandled IDL stuff
    sequence:    unhandled IDL stuff
    struct:      unhandled IDL stuff
    typedef:     unhandled IDL stuff
    typename:    unhandled IDL stuff
    union:       unhandled IDL stuff

    Warning!
    Only handles statuses of NOTE, WD, and REC.
    -->

  <!-- Output a warning for unhandled elements! -->
  <xsl:template match="*">
    <xsl:message>
      <xsl:text>No template matches </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>.</xsl:text>
    </xsl:message>

    <font color="red">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>&gt;</xsl:text>
    </font>
  </xsl:template>

  <!-- Template for the root node.  Creation of <html> element could
       go here, but that doesn't feel right. -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- abstract: appears only in header -->
  <!-- format as a second-level div -->
  <!-- called in enforced order from header's template -->
  <xsl:template match="abstract">
    <div>
      <xsl:text>&#10;</xsl:text>
      <h2>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'abstract'"/>
        </xsl:call-template>
        <xsl:text>Abstract</xsl:text>
      </h2>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- affiliation: follows a name in author and member -->
  <!-- put it in parens with a leading space -->
  <xsl:template match="affiliation">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- arg: appears only in proto -->
  <!-- argument in function prototype -->
  <!-- output argument type, italicized as placeholder; separate the
       list with commas and spaces -->
  <xsl:template match="arg">
    <xsl:if test="preceding-sibling::arg">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <var>
      <xsl:value-of select="@type"/>
    </var>
    <xsl:if test="@occur = 'opt'">
      <xsl:text>?</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- att: attribute name -->
  <!-- used lots of places -->
  <!-- format as monospaced code -->
  <xsl:template match="att">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <!-- attribute: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- attval: attribute name -->
  <!-- used lots of places -->
  <!-- format as quoted string -->
  <xsl:template match="attval">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <!-- authlist: list of authors (editors, really) -->
  <!-- called in enforced order from header's template, in <dl>
       context -->
  <xsl:template match="authlist">
    <dt>
      <xsl:text>Editor</xsl:text>
      <xsl:if test="count(author) > 1">
        <xsl:text>s</xsl:text>
      </xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- author: an editor of a spec -->
  <!-- only appears in authlist -->
  <!-- called in <dl> context -->
  <xsl:template match="author">
    <dd>
      <xsl:apply-templates/>
      <xsl:if test="@role = '2e'">
        <xsl:text> - Second Edition</xsl:text>
      </xsl:if>
    </dd>
  </xsl:template>

  <!-- back: back matter for the spec -->
  <!-- make a <div> for neatness -->
  <!-- affects numbering of div1 children -->
  <xsl:template match="back">
    <div class="back">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- bibl: bibliographic entry -->
  <!-- only appears in blist -->
  <!-- called with <dl> context -->
  <!-- if there's a key, use it in the <dt>, otherwise use the ID -->
  <!-- if there's an href, add a ref in parens at the end of the text -->
  <xsl:template match="bibl">
   <dt class="label">
    <xsl:copy-of select="@id"/>
      <xsl:choose>
        <xsl:when test="@key">
          <xsl:value-of select="@key"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </dt>
    <dd>
      <xsl:choose>
        <xsl:when test="@href">
          <a href="{@href}">
            <xsl:apply-templates/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@href">
        <xsl:text>  (See </xsl:text>
        <xsl:value-of select="@href"/>
        <xsl:text>.)</xsl:text>
      </xsl:if>
    </dd>
  </xsl:template>

  <!-- bibref: reference to a bibliographic entry -->
  <!-- make a link to the bibl -->
  <!-- if the bibl has a key, put it in square brackets; otherwise use
       the bibl's ID -->
  <xsl:template match="bibref">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="key('ids', @ref)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:choose>
        <xsl:when test="key('ids', @ref)/@key">
          <xsl:value-of select="key('ids', @ref)/@key"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@ref"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </a>
  </xsl:template>

  <!-- blist: list of bibliographic entries -->
  <!-- set up the list and process children -->
  <xsl:template match="blist">
    <dl>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <!-- bnf: un-marked-up BNF productions -->
  <!-- preformatted within a table cell -->
  <!-- scrap provides <table> context -->
  <xsl:template match="bnf">
    <tbody>
      <tr>
        <td>
          <xsl:if test="@diff and $show.diff.markup='1'">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
          </xsl:if>
          <pre>
            <xsl:apply-templates/>
          </pre>
        </td>
      </tr>
    </tbody>
  </xsl:template>

  <!-- body: the meat of the spec -->
  <!-- create a TOC and then go to work -->
  <!-- (don't forget the TOC for the back matter and a pointer to end
       notes) -->
  <xsl:template match="body">
   <xsl:if test="$toc.level &gt; 0">
   <xsl:text>&#10;</xsl:text>
   <nav id="toc">
    <xsl:text>&#10;</xsl:text>
    <h2 id="tochead">
     <xsl:text>Table of Contents</xsl:text>
    </h2>
    <xsl:text>&#10;</xsl:text>
        <ol class="toc">
         <xsl:apply-templates select="div1|../back/inform-div1|../back/div1" mode="toc"/>
        </ol>
	<!--
            <xsl:if test="../back">
          <xsl:text>&#10;</xsl:text>
          <h3>
          <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'appendices'"/>
          </xsl:call-template>
	  
          <xsl:text>Appendi</xsl:text>
          <xsl:choose>
          <xsl:when test="count(../back/div1 | ../back/inform-div1) > 1">
          <xsl:text>ces</xsl:text>
          </xsl:when>
          <xsl:otherwise>
                <xsl:text>x</xsl:text>
		</xsl:otherwise>
            </xsl:choose>
            </h3>

<ol class="toc">
<xsl:apply-templates mode="toc"
                                 select="../back/div1 | ../back/inform-div1"/>
				 </ol>
				 </xsl:if>
	-->        
        <xsl:if test="//footnote[not(ancestor::table)]">
          <ol class="toc">
           <a href="#endnotes">
              <xsl:text>End Notes</xsl:text>
           </a>
          </ol>
        </xsl:if>
	<xsl:text>&#10;</xsl:text>
   </nav>
   <xsl:text>&#10;</xsl:text>
   </xsl:if>
   <xsl:text>&#10;</xsl:text>
   <div class="body">
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
   </div>
   <xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  <!-- caption: see table -->

  <!-- case: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- code: generic computer code -->
  <!-- output as HTML <code> for monospaced formatting -->
  <xsl:template match="code">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <!-- col: see table -->

  <!-- colgroup: see table -->

  <!-- com: formal production comment -->
  <!-- can appear in prod or rhs -->
  <xsl:template match="com">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='rhs']">
        <td>
          <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="ancestor-or-self::*/@diff"/>
            </xsl:attribute>
          </xsl:if>
          <i>
            <xsl:text>/* </xsl:text>
            <xsl:apply-templates/>
            <xsl:text> */</xsl:text>
          </i>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <tr valign="baseline">
          <td/><td/><td/><td/>
          <td>
            <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
              <xsl:attribute name="class">
                <xsl:text>diff-</xsl:text>
                <xsl:value-of select="ancestor-or-self::*/@diff"/>
              </xsl:attribute>
            </xsl:if>
            <i>
              <xsl:text>/* </xsl:text>
              <xsl:apply-templates/>
              <xsl:text> */</xsl:text>
            </i>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- this could probably be handled better, but given that rhs can
       have arbitrary text and com mixed in, I don't feel like
       spending enough time to figure out how -->
  <xsl:template match="rhs/com">
    <i>
      <xsl:text>/* </xsl:text>
      <xsl:apply-templates/>
      <xsl:text> */</xsl:text>
    </i>
  </xsl:template>

  <!-- component: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- constant: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- constraint: a note in a formal production -->
  <!-- refers to a constraint note -->
  <xsl:template match="constraint">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='rhs']">
        <td>
          <xsl:if test="@diff and $show.diff.markup='1'">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @def)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>[Constraint: </xsl:text>
            <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
            <xsl:text>]</xsl:text>
          </a>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <tr valign="baseline">
          <td/><td/><td/><td/>
          <td>
            <xsl:if test="@diff and $show.diff.markup='1'">
              <xsl:attribute name="class">
                <xsl:text>diff-</xsl:text>
                <xsl:value-of select="@diff"/>
              </xsl:attribute>
            </xsl:if>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="key('ids', @def)"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:text>[Constraint: </xsl:text>
              <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
              <xsl:text>]</xsl:text>
            </a>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- constraintnote: note constraining a formal production -->
  <!-- see also constraintnote/head -->
  <xsl:template match="constraintnote">
    <div class="constraint">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- copyright: notice for this document-->
  <!-- right now, a boilerplate copyright notice is inserted by the
       template for header; this may need to be changed -->

  <!-- day: day of month of spec -->
  <!-- only used in pudate; called directly from header template -->
  <xsl:template match="day">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- def: glossary definition -->
  <!-- already in <dl> context from glist -->
  <xsl:template match="def">
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <!-- definitions: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- descr: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- div[n]: structural divisions -->
  <!-- make an HTML div -->
  <!-- see also div[n]/head -->
  <xsl:template match="div1">
    <div class="div1">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="div2">
    <div class="div2">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="div3">
    <div class="div3">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="div4">
    <div class="div4">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="div5">
    <div class="div5">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- ednote: editors' note -->
  <xsl:template match="ednote">
   <xsl:if test="$show.ednotes != 0">
    <div class="issue">
      <table>
        <xsl:attribute name="summary">
          <xsl:text>Editorial note</xsl:text>
          <xsl:if test="name">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="name"/>
          </xsl:if>
        </xsl:attribute>
        <tr>
          <td align="left" valign="top" width="50%">
            <b>
              <xsl:text>Editorial note</xsl:text>
              <xsl:if test="name">
                <xsl:text>: </xsl:text>
                <xsl:apply-templates select="name"/>
              </xsl:if>
            </b>
          </td>
          <td align="right" valign="top" width="50%">
            <xsl:choose>
              <xsl:when test="date">
                <xsl:apply-templates select="date"/>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td colspan="2" align="left" valign="top">
            <xsl:apply-templates select="edtext"/>
          </td>
        </tr>
      </table>
    </div>
   </xsl:if>
  </xsl:template>

  <xsl:template match="date">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="ednote/edtext">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- edtext: text of an editors' note -->
  <!-- ednote is currently hidden -->

  <!-- el: an XML element -->
  <!-- present as preformatted text, no markup -->
  <!-- Chris's personal preference is to put pointy-brackets around
       this, but he seems to be in the minority -->
  <xsl:template match="el">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <!-- email: an email address for an editor -->
  <!-- only occurs in author -->
  <xsl:template match="email">
    <xsl:text> </xsl:text>
    <a href="{@href}">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    </a>
  </xsl:template>

  <!-- emph: in-line emphasis -->
  <!-- equates to HTML <em> -->
  <!-- the role attribute could be used for multiple kinds of
       emphasis, but that would not be kind -->
  <xsl:template match="emph">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <!-- enum: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- enumerator: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- example: what it seems -->
  <!-- block-level with title -->
  <!-- see also example/head -->
  <xsl:template match="example">
    <xsl:variable name="class">
      <xsl:choose>
        <xsl:when test="$tabular.examples = 0">exampleOuter</xsl:when>
        <xsl:otherwise>example</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="{$class}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

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
        <h5>
          <xsl:call-template name="anchor">
            <xsl:with-param name="node" select=".."/>
            <xsl:with-param name="conditional" select="0"/>
          </xsl:call-template>

          <xsl:text>Example: </xsl:text>
          <xsl:apply-templates/>
        </h5>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- eg: a literal example -->
  <!-- present as preformatted text -->
  <xsl:template match="eg">
    <xsl:variable name="content">
      <pre class="example">
        <xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>example diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </pre>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$tabular.examples = 0">
        <div class="exampleInner">
          <xsl:copy-of select="$content"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <table class="eg" cellpadding="5"
               bgcolor="#99ffff" width="100%"
               summary="Example">
          <tr>
            <td>
              <xsl:copy-of select="$content"/>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- exception: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- footnote: format as endnote, actually -->
  <xsl:template match="footnote">
    <xsl:variable name="this-note-id">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <sup>
      <xsl:text>[</xsl:text>
      <a id="FN-ANCH-{$this-note-id}"
         href="#{$this-note-id}">
        <xsl:apply-templates select="." mode="number-simple"/>
      </a>
      <xsl:text>]</xsl:text>
    </sup>
  </xsl:template>

  <!-- front: front matter for the spec -->
  <!-- make a div for cleanliness -->
  <xsl:template match="front">
    <div class="front">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- function: name of a function -->
  <!-- format as HTML <code> for monospaced presentation -->
  <xsl:template match="function">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <!-- gitem: glossary list entry -->
  <!-- just pass children through for <dd>/<dt> formatting -->
  <xsl:template match="gitem">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- glist: glossary list -->
  <!-- create <dl> and handle children -->
  <xsl:template match="glist">
    <xsl:if test="$validity.hacks and local-name(..) = 'p'">
      <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
    </xsl:if>
    <dl>
      <xsl:apply-templates/>
    </dl>
    <xsl:if test="$validity.hacks and local-name(..) = 'p'">
      <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- graphic: external illustration -->
  <!-- reference external graphic file with alt text -->
  <xsl:template match="graphic">
    <img src="{@source}">
      <xsl:if test="@alt">
        <xsl:attribute name="alt">
          <xsl:value-of select="@alt"/>
        </xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>

  <!-- group: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- head: title for a variety of constructs -->

  <!-- constraintnotes have different types, but they're
       non-enumerated; nothing is done with them right now -->
  <xsl:template match="constraintnote/head">
   <p class="prefix">
    <xsl:copy-of select="../@id"/>
      <b><xsl:text>Constraint: </xsl:text><xsl:apply-templates/></b>
    </p>
  </xsl:template>

  <xsl:template match="div1/head">
    <xsl:text>&#10;</xsl:text>
    <h2>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="div2/head">
    <xsl:text>&#10;</xsl:text>
    <h3>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>

  <xsl:template match="div3/head">
    <xsl:text>&#10;</xsl:text>
    <h4>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h4>
  </xsl:template>

  <xsl:template match="div4/head">
    <xsl:text>&#10;</xsl:text>
    <h5>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h5>
  </xsl:template>

  <xsl:template match="div5/head">
    <xsl:text>&#10;</xsl:text>
    <h6>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h6>
  </xsl:template>

  <xsl:template match="inform-div1/head">
    <xsl:text>&#10;</xsl:text>
    <h2>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
      <xsl:text> (Non-Normative)</xsl:text>
    </h2>
  </xsl:template>

  <xsl:template match="scrap/head">
    <xsl:text>&#10;</xsl:text>
    <h5>
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select=".."/>
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>

      <xsl:apply-templates/>
    </h5>
  </xsl:template>

  <xsl:template match="vcnote/head">
    <p class="prefix">
     <xsl:copy-of select="../@id"/>
      <b><xsl:text>Validity constraint: </xsl:text><xsl:apply-templates/></b>
    </p>
  </xsl:template>

  <xsl:template match="wfcnote/head">
    <p class="prefix">
     <xsl:copy-of select="../@id"/>
      <b><xsl:text>Well-formedness constraint: </xsl:text><xsl:apply-templates/></b>
    </p>
  </xsl:template>

  <!-- header: metadata about the spec -->
  <!-- pull out information into standard W3C layout -->
  <xsl:template match="header">
    <div class="head">
      <xsl:if test="true() or not($editors-copy='yes' or /spec/@role='editors-copy')">
        <p>
          <a href="https://www.w3.org/">
            <img src="https://www.w3.org/StyleSheets/TR/2016/logos/W3C"
              alt="W3C" height="48" width="72"/>
          </a>
        </p>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
      <h1>
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select="title[1]"/>
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'title'"/>
        </xsl:call-template>

	<xsl:variable name="t">
	 <xsl:apply-templates select="title"/>
	</xsl:variable>
	<xsl:analyze-string regex="\([^\(\)]*\)" select="$t">
	 <xsl:matching-substring>
	  <xsl:value-of select="replace(.,' ','&#160;')"/>
	 </xsl:matching-substring>
	 <xsl:non-matching-substring>
	  <xsl:value-of select="."/>
	 </xsl:non-matching-substring>
	</xsl:analyze-string>
        <xsl:if test="version">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="version"/>
        </xsl:if>
      </h1>
      <xsl:if test="subtitle">
        <xsl:text>&#10;</xsl:text>
        <h2>
          <xsl:call-template name="anchor">
            <xsl:with-param name="node" select="subtitle[1]"/>
            <xsl:with-param name="conditional" select="0"/>
            <xsl:with-param name="default.id" select="'subtitle'"/>
          </xsl:call-template>
          <xsl:apply-templates select="subtitle"/>
        </h2>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
      <h2>
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select="w3c-doctype[1]"/>
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'w3c-doctype'"/>
        </xsl:call-template>

        <xsl:apply-templates select="w3c-doctype"/>
        <xsl:text> </xsl:text>
        <xsl:if test="pubdate/day">
          <xsl:apply-templates select="pubdate/day"/>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="pubdate/month"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="pubdate/year"/>
      </h2>
      <dl>
        <xsl:apply-templates select="publoc"/>
        <xsl:apply-templates select="latestloc"/>
        <xsl:apply-templates select="prevlocs"/>
        <xsl:apply-templates select="edlocs"/>
        <xsl:apply-templates select="authlist"/>
      </dl>

      <xsl:apply-templates select="errataloc"/>

      <!-- output the altlocs -->
      <xsl:apply-templates select="altlocs"/>

      <xsl:apply-templates select="translationloc"/>

      <xsl:choose>
        <xsl:when test="copyright">
          <xsl:apply-templates select="copyright"/>
        </xsl:when>
        <xsl:otherwise>

<!--<p class="copyright"><a
href="http://www.w3.org/Consortium/Legal/ipr-notice#Copyright">
Copyright</a> &#xa9; 1998-2007 <a href="http://www.w3.org/"><acronym title="World Wide Web Consortium">W3C</acronym></a><sup>&#xae;</sup> (<a href="http://www.lcs.mit.edu/"><acronym title="Massachusetts Institute of Technology">MIT</acronym></a>, <a href="http://www.ercim.eu/"><acronym title="European Research Consortium for Informatics and Mathematics">ERCIM</acronym></a>, <a href="http://www.keio.ac.jp/">Keio</a>), All Rights Reserved. W3C <a href="http://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer">liability</a>, <a href="http://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks">trademark</a>, <a href="http://www.w3.org/Consortium/Legal/copyright-documents">document use</a> and <a href="http://www.w3.org/Consortium/Legal/copyright-software">software licensing</a> rules apply.</p>
-->
<p class="copyright"><a href="https://www.w3.org/Consortium/Legal/ipr-notice#Copyright">Copyright</a> © 1998-2019 <a href="https://www.w3.org/"><abbr title="World Wide Web Consortium">W3C</abbr></a><sup>®</sup> (<a href="https://www.csail.mit.edu/"><abbr title="Massachusetts Institute of Technology">MIT</abbr></a>, <a href="https://www.ercim.eu/"><abbr title="European Research Consortium for Informatics and Mathematics">ERCIM</abbr></a>, <a href="https://www.keio.ac.jp/">Keio</a>, <a href="http://ev.buaa.edu.cn/">Beihang</a>). W3C <a href="https://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer">liability</a>, <a href="https://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks">trademark</a> and <a href="https://www.w3.org/Consortium/Legal/copyright-documents">document use</a> rules apply.</p>
	</xsl:otherwise>
      </xsl:choose>
      <hr title="Separator for header"/>
    </div>
    <xsl:apply-templates select="notice"/>
    <xsl:apply-templates select="abstract"/>
    <xsl:apply-templates select="status"/>
  </xsl:template>

  <xsl:template match="copyright">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="copyright/p">
    <p class="copyright">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- inform-div1: non-normative back matter top-level division -->
  <!-- treat like div1 except add "(Non-Normative)" to title -->
  <xsl:template match="inform-div1">
    <div class="div1">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- interface: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- issue: open issue before the Working Group -->
  <!-- maintain an ID for linking to it -->
  <!-- currently generates boilerplate head plus optional head child
       element; this should probably be cleaned up to only use the
       head if it's present -->
  <xsl:template match="issue">
    <xsl:if test="$show.issues != 0 and @role!='closed'">
<div class="issue">
     <table id="{@id}">
	<tr>
	  <th>Issue</th>
	  <td><tt><xsl:value-of select="@id"/></tt></td>
	</tr>
	<tr><th colspan="2"><xsl:apply-templates select="head"/></th></tr>
	<tr><td colspan="2"><xsl:apply-templates select="*[local-name()!='resolution' and local-name()!='head']"/></td></tr>
	<tr>
	  <th>Resolution</th>
	  <td>
	    <xsl:choose>
	      <xsl:when test="resolution"><xsl:apply-templates select="resolution"/></xsl:when>
	      <xsl:otherwise>None recorded</xsl:otherwise>
	    </xsl:choose>
	  </td>
	</tr>
      </table>
</div>
    </xsl:if>
  </xsl:template>

<xsl:template match="issue/head"><xsl:apply-templates/></xsl:template>

  <!-- item: generic list item -->
  <xsl:template match="item">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- kw: keyword -->
  <!-- make it bold -->
  <xsl:template match="kw">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <!-- label: term for defintion in glossary entry -->
  <!-- already in <dl> context from glist -->
  <xsl:template match="label">
    <dt class="label">
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:call-template name="anchor"/>

      <xsl:apply-templates/>
    </dt>
  </xsl:template>

  <!-- language: -->
  <!-- langusage: -->
  <!-- identify language usage within a spec; not actually formatted -->

  <!-- latestloc: latest location for this spec -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="latestloc">
   <xsl:text>&#10;</xsl:text>
   <dt>Latest version:</dt>
    <dd>
      <xsl:apply-templates select="loc"/>
    </dd>
  </xsl:template>

  <!-- lhs: left-hand side of formal productions -->
  <!-- make a table row with the lhs and the corresponding other
       pieces in this crazy mixed-up content model -->
  <xsl:template match="lhs">
    <tr valign="baseline">
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
	<xsl:copy-of select="../@id"/>
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
        select="following-sibling::*[1][name()='rhs']"/>
    </tr>
  </xsl:template>

  <!-- loc: a Web location -->
  <!-- outside the header, it's a normal cross-reference -->
  <xsl:template match="loc">
   <a href="{@href}">
    <xsl:copy-of select="@id"/>
    <xsl:if test="@role='disclosure'"><xsl:attribute name="rel" select="@role"/></xsl:if>
    <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- member: member of an organization -->
  <!-- appears only in orglist, which creates <ul> context -->
  <xsl:template match="member">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- method: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- module: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- month: month of spec -->
  <!-- only used in pudate; called directly from header template -->
  <xsl:template match="month">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- name: name of an editor or organization member -->
  <!-- only appears in author and member -->
  <!-- just output text -->
  <xsl:template match="name">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- note: a note about the spec -->
  <xsl:template match="note">
    <div class="note">
      <p class="prefix">
        <b>Note:</b>
      </p>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- notice: a front-matter advisory about the spec's status -->
  <!-- make sure people notice it -->
  <xsl:template match="notice">
    <div class="notice">
      <p class="prefix">
        <b>NOTICE:</b>
      </p>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- nt: production non-terminal -->
  <!-- make a link to the non-terminal's definition -->
  <xsl:template match="nt">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="key('ids', @def)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- OrderedList Numeration -->

  <xsl:template name="next.numeration">
    <xsl:param name="numeration" select="'default'"/>
    <xsl:choose>
      <!-- Change this list if you want to change the order of numerations -->
      <xsl:when test="$numeration = 'arabic'">loweralpha</xsl:when>
      <xsl:when test="$numeration = 'loweralpha'">lowerroman</xsl:when>
      <xsl:when test="$numeration = 'lowerroman'">upperalpha</xsl:when>
      <xsl:when test="$numeration = 'upperalpha'">upperroman</xsl:when>
      <xsl:when test="$numeration = 'upperroman'">arabic</xsl:when>
      <xsl:otherwise>arabic</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="list.numeration">
    <xsl:param name="node" select="."/>

    <xsl:choose>
      <xsl:when test="$node/ancestor::olist">
        <xsl:call-template name="next.numeration">
          <xsl:with-param name="numeration">
            <xsl:call-template name="list.numeration">
              <xsl:with-param name="node" select="$node/ancestor::olist[1]"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="next.numeration"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- olist: an ordered list -->
  <xsl:template match="olist">
    <xsl:variable name="numeration">
      <xsl:call-template name="list.numeration"/>
    </xsl:variable>

    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="$numeration='arabic'">1</xsl:when>
        <xsl:when test="$numeration='loweralpha'">a</xsl:when>
        <xsl:when test="$numeration='lowerroman'">i</xsl:when>
        <xsl:when test="$numeration='upperalpha'">A</xsl:when>
        <xsl:when test="$numeration='upperroman'">I</xsl:when>
        <!-- What!? This should never happen -->
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Unexpected numeration: </xsl:text>
            <xsl:value-of select="$numeration"/>
          </xsl:message>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <ol type="{$type}">
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <!-- orglist: a list of an organization's members -->
  <xsl:template match="orglist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <!-- p: a standard paragraph -->
  <xsl:template match="p">
   <xsl:text>&#10;</xsl:text>
   <p>
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@role">
        <xsl:attribute name="class">
          <xsl:value-of select="@role"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- param: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- parameters: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- phrase: semantically meaningless markup hanger -->
  <!-- role attributes may be used to request different formatting,
       which isn't currently handled -->
  <xsl:template match="phrase">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- prevlocs: previous locations for this spec -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="prevlocs">
   <xsl:text>&#10;</xsl:text>
   <dt>
      <xsl:text>Previous version</xsl:text>
      <xsl:if test="count(loc) &gt; 1">s</xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
     <xsl:for-each select="loc">
      <xsl:if test="position()!=1"><br/><xsl:text>&#10;</xsl:text></xsl:if>
      <xsl:apply-templates select="."/>
     </xsl:for-each>
    </dd>
  </xsl:template>

  <!-- prevlocs: previous locations for this spec -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="edlocs">
    <dt>
     <xsl:text>&#10;</xsl:text>
     <xsl:text>Editors' version</xsl:text>
      <xsl:if test="count(loc) &gt; 1">s</xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
     <xsl:for-each select="loc">
      <xsl:if test="position()!=1"><br/><xsl:text>&#10;</xsl:text></xsl:if>
      <xsl:apply-templates select="."/>
     </xsl:for-each>
    </dd>
  </xsl:template>

  <!-- prod: a formal grammar production -->
  <!-- if not in a prodgroup, needs a <tbody> -->
  <!-- has a weird content model; makes a table but there are no
       explicit rules; many different things can start a new row -->
  <!-- process the first child in each row, and it will process the
       others -->
  <xsl:template match="prod">
    <tbody>
      <xsl:apply-templates
        select="lhs |
                rhs[preceding-sibling::*[1][name()!='lhs']] |
                com[preceding-sibling::*[1][name()!='rhs']] |
                constraint[preceding-sibling::*[1][name()!='rhs']] |
                vc[preceding-sibling::*[1][name()!='rhs']] |
                wfc[preceding-sibling::*[1][name()!='rhs']]"/>
    </tbody>
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
    <tbody>
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>

  <!-- prodrecap: reiteration of a prod -->
  <!-- process the prod in another node that will never generate a
       <tbody> or a number, plus links the lhs to the original
       production -->
  <xsl:template match="prodrecap">
    <tbody>
      <xsl:apply-templates select="key('ids', @ref)" mode="ref"/>
    </tbody>
  </xsl:template>

  <!-- proto: function prototype -->
  <!-- type and name of the function, with arguments in parens -->
  <xsl:template match="proto">
    <p>
      <em><xsl:value-of select="@return-type"/></em>
      <xsl:text> </xsl:text>
      <b><xsl:value-of select="@name"/></b>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>)</xsl:text>
    </p>
  </xsl:template>

  <!-- pubdate: date of spec -->
  <!-- called directly from header -->

  <!-- publoc: location of current version of spec -->
  <!-- called from header in <dl> context -->
  <xsl:template match="publoc">
   <xsl:text>&#10;</xsl:text>
   <dt>This version:</dt>
    <dd>
      <xsl:apply-templates select="loc"/>
    </dd>
  </xsl:template>

  <xsl:template match="errataloc">
<p>Please refer to the <a href="{@href}"><strong>errata</strong></a>
for this document, which may include some normative corrections.</p>
  </xsl:template>

  <xsl:template match="translationloc">
   <p>See also <a href="{@href}"><strong>translations</strong></a>.</p>
  </xsl:template>

  <xsl:template match="altlocs">
    <p>
      <xsl:text>This document is also available </xsl:text>
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
  </xsl:template>

  <!-- pubstmt: statement of publication -->
  <!-- not currently output -->

  <!-- quote: a quoted string or phrase -->
  <!-- it would be nice to use HTML <q> elements, but browser support
       is abysmal -->
  <xsl:template match="quote">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <!-- raises: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- revisiondesc: description of spec revision -->
  <!-- used for internal tracking; not formatted -->

  <!-- rhs: right-hand side of a formal production -->
  <!-- make a table cell; if it's not the first after an LHS, make a
       new row, too -->
  <xsl:template match="rhs">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='lhs']">
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
          select="following-sibling::*[1][name()='com' or
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
            select="following-sibling::*[1][name()='com' or
                                            name()='constraint' or
                                            name()='vc' or
                                            name()='wfc']"/>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- role: part played by a member of an organization -->
  <xsl:template match="role">
    <xsl:text> (</xsl:text>
    <i><xsl:apply-templates/></i>
    <xsl:text>) </xsl:text>
  </xsl:template>

  <!-- scrap: series of formal grammar productions -->
  <!-- set up a <table> and handle children -->
  <xsl:template match="scrap">
    <xsl:apply-templates select="head"/>
    <table class="scrap" summary="Scrap">
      <xsl:apply-templates select="bnf | prod | prodgroup"/>
    </table>
  </xsl:template>

  <!-- sequence: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- sitem: simple list item -->
  <!-- just make one paragraph with <br>s between items -->
  <xsl:template match="sitem">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sitem[position() &gt; 1]" priority="2">
    <br/>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- slist: simple list -->
  <!-- using a <blockquote> to indent the list is very wrong, but it works -->
  <xsl:template match="slist">
    <blockquote>
      <p>
        <xsl:apply-templates/>
      </p>
    </blockquote>
  </xsl:template>

  <!-- source: the source of an issue -->
  <xsl:template match="source">
    <p>
      <b>Source</b>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- sourcedesc: description of spec preparation -->
  <!-- used for tracking the source, but not formatted -->

  <!-- spec: the specification itself -->
  <xsl:template match="spec">
    <html lang="en">
      <xsl:if test="header/langusage/language">
        <xsl:attribute name="lang">
          <xsl:value-of select="header/langusage/language/@id"/>
        </xsl:attribute>
      </xsl:if>
      <head>
            <xsl:text>&#10;</xsl:text>
       <meta http-equiv="Content-type" content="text/html;charset=UTF-8"/>
            <xsl:text>&#10;</xsl:text>
       <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
            <xsl:text>&#10;</xsl:text>
<!--        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>-->
        <title>
          <xsl:apply-templates select="header/title"/>
          <xsl:if test="header/version">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="header/version"/>
          </xsl:if>
          <xsl:if test="$additional.title != ''">
            <xsl:text> -- </xsl:text>
            <xsl:value-of select="$additional.title"/>
          </xsl:if>
        </title>
            <xsl:text>&#10;</xsl:text>
<style>
	 

/** Table of Contents *********************************************************/

	.toc a {
		/* More spacing; use padding to make it part of the click target. */
		padding-top: 0.1rem;
		/* Larger, more consistently-sized click target */
		display: block;
		/* Reverse color scheme */
		color: black;
		border-color: #3980B5;
		border-bottom-width: 3px !important;
		margin-bottom: 0px !important;
	}

</style>
	  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
	  <xsl:call-template name="css"/>
          <xsl:text>&#10;</xsl:text>
	  <script src="//www.w3.org/scripts/TR/2016/fixup.js"><xsl:text> </xsl:text></script>
          <xsl:text>&#10;</xsl:text>
	  <xsl:text>&#10;</xsl:text>
      </head>
      <xsl:text>&#10;</xsl:text>
      <body>
       <xsl:text>&#10;</xsl:text>
       <xsl:apply-templates/>
        <xsl:if test="//footnote[not(ancestor::table)]">
	 <xsl:text>&#10;</xsl:text>
         <hr/>
	 <xsl:text>&#10;</xsl:text>
         <div class="endnotes">
            <h3>
              <xsl:call-template name="anchor">
                <xsl:with-param name="conditional" select="0"/>
                <xsl:with-param name="default.id" select="'endnotes'"/>
              </xsl:call-template>
              <xsl:text>End Notes</xsl:text>
            </h3>
            <dl>
              <xsl:apply-templates select="//footnote[not(ancestor::table)]"
                                   mode="notes"/>
            </dl>
          </div>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

  <!-- specref: reference to another part of teh current specification -->
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
          <b>
            <xsl:apply-templates select="key('ids', @ref)" mode="divnum"/>
            <xsl:apply-templates select="key('ids', @ref)/head" mode="text"/>
          </b>
        </a>
      </xsl:when>
      <xsl:when test="starts-with(local-name($target), 'inform-div')">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
          <b>
            <xsl:apply-templates select="key('ids', @ref)" mode="divnum"/>
            <xsl:apply-templates select="key('ids', @ref)/head" mode="text"/>
          </b>
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

  <!-- status: the status of the spec -->
  <xsl:template match="status">
    <div>
      <xsl:text>&#10;</xsl:text>
      <h2>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'status'"/>
        </xsl:call-template>
        <xsl:text>Status of this Document</xsl:text>
      </h2>
      <xsl:if test="$editors-copy='yes' or /spec/@role='editors-copy'">
       <xsl:text>&#10;</xsl:text>
       <p><strong>This document is an editors' copy that has no official standing. (Date: <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>)</strong></p>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- struct: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- sub: subscript -->
  <xsl:template match="sub">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>

  <!-- subtitle: secondary title of spec -->
  <!-- handled directly within header -->
  <xsl:template match="title">
    <xsl:apply-templates/>
  </xsl:template>
  

  <!-- sup: superscript -->
  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>

  <!-- table: the HTML table model adopted wholesale; note however that we -->
  <!-- do this such that the XHTML stylesheet will do the right thing. -->
  <xsl:template match="caption|col|colgroup|td|tfoot|th|thead|tr|tbody">
    <xsl:element name="{local-name(.)}">
      <xsl:for-each select="@*">
        <!-- Wait: some of these aren't HTML attributes after all... -->
        <xsl:if test="local-name(.) != 'diff'">
          <xsl:copy>
<!--            <xsl:apply-templates/> -->
          </xsl:copy>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- but table is special, to handle footnotes -->
  <xsl:template match="table">
    <table>
      <xsl:copy-of select="@* except (@diff,@border)"/>
      <xsl:if test="not(@class) and @border=1">
       <xsl:attribute name="class" select="'data'"/>
      </xsl:if>
      <xsl:apply-templates/>

      <xsl:if test=".//footnote">
        <tbody>
          <tr>
            <td>
              <xsl:apply-templates select=".//footnote" mode="table.notes"/>
            </td>
          </tr>
        </tbody>
      </xsl:if>
    </table>
  </xsl:template>

  <!-- term: the actual mention of a term within a termdef -->
  <xsl:template match="term">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <!-- termdef: sentence or phrase defining a term -->
  <xsl:template match="termdef">
    <xsl:text>[</xsl:text>
    <a id="{@id}" title="{@term}">
      <xsl:text>Definition</xsl:text>
    </a>
    <xsl:text>: </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- termref: reference to a defined term -->
  <xsl:template match="termref">
    <a title="{key('ids', @def)/@term}">
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="key('ids', @def)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- tfoot: see table -->
  <!-- th: see table -->
  <!-- thead: see table -->

  <!-- title: title of the specification -->
  <!-- called directly within header -->

  <!-- titleref: reference to the title of any work -->
  <!-- if a URL is given, link it -->
  <xsl:template match="titleref">
    <xsl:choose>
      <xsl:when test="@href">
        <a href="{@href}">
          <cite>
            <xsl:apply-templates/>
          </cite>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <cite>
          <xsl:apply-templates/>
        </cite>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- tr: see table -->

  <!-- typedef: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- typename: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- ulist: unordered list -->
  <xsl:template match="ulist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <!-- union: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- var: a variable -->
  <xsl:template match="var">
    <var>
      <xsl:apply-templates/>
    </var>
  </xsl:template>

  <!-- vc: validity check reference in a formal production -->
  <xsl:template match="vc">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='rhs']">
        <td>
          <xsl:if test="@diff and $show.diff.markup='1'">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @def)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>[VC: </xsl:text>
            <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
            <xsl:text>]</xsl:text>
          </a>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <tr valign="baseline">
          <td/><td/><td/><td/>
          <td>
            <xsl:if test="@diff and $show.diff.markup='1'">
              <xsl:attribute name="class">
                <xsl:text>diff-</xsl:text>
                <xsl:value-of select="@diff"/>
              </xsl:attribute>
            </xsl:if>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="key('ids', @def)"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:text>[VC: </xsl:text>
              <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
              <xsl:text>]</xsl:text>
            </a>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- vcnote: validity check note after a formal production -->
  <xsl:template match="vcnote">
    <div class="constraint">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- version: version of this spec -->
  <!-- called directly from header -->
  <xsl:template match="version">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- w3c-designation: canonical name for this spec -->
  <!-- not used for formatting -->

  <!-- w3c-doctype: type of document the specification is -->
  <!-- used by header template to select CSS stylesheet for output
       HTML -->
  <xsl:template match="w3c-doctype">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- wfc: well-formedness check reference in a formal production -->
  <xsl:template match="wfc">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='rhs']">
        <td>
          <xsl:if test="@diff and $show.diff.markup='1'">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @def)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>[WFC: </xsl:text>
            <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
            <xsl:text>]</xsl:text>
          </a>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <tr valign="baseline">
          <td/><td/><td/><td/>
          <td>
            <xsl:if test="@diff and $show.diff.markup='1'">
              <xsl:attribute name="class">
                <xsl:text>diff-</xsl:text>
                <xsl:value-of select="@diff"/>
              </xsl:attribute>
            </xsl:if>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="key('ids', @def)"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:text>[WFC: </xsl:text>
              <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
              <xsl:text>]</xsl:text>
            </a>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- wfcnote: well-formedness check note after formal production -->
  <xsl:template match="wfcnote">
    <div class="constraint">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- xnt: external non-terminal -->
  <!-- xspecref: external specification reference -->
  <!-- xtermref: external term reference -->
  <!-- just link to URI provided -->
  <xsl:template match="xnt | xspecref | xtermref">
    <a href="{@href}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- year: year of spec -->
  <!-- only used in pudate; called directly from header template -->
  <xsl:template match="year">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Silly HTML elements used for pasting stuff in; shouldn't ever
       show up in a spec, but they're easy to handle and you just
       never know. -->
  <xsl:template match="a|div|em|h1|h2|h3|h4|h5|h6|li|ol|pre|ul">
    <xsl:element name="{local-name(.)}">
      <xsl:for-each select="@*">
        <xsl:copy>
<!--          <xsl:apply-templates/>-->
        </xsl:copy>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- legacy XML spec stuff -->
  <xsl:template match="htable">
    <table summary="HTML Table">
      <xsl:for-each select="@*">
        <xsl:copy>
<!--          <xsl:apply-templates/>-->
        </xsl:copy>
      </xsl:for-each>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xsl:template match="htbody">
    <tbody>
      <xsl:for-each select="@*">
        <xsl:copy>
<!--          <xsl:apply-templates/>-->
        </xsl:copy>
      </xsl:for-each>
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>
  <xsl:template match="key-term">
    <b><xsl:apply-templates/></b>
  </xsl:template>
  <xsl:template match="statusp">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- legacy DocBook stuff -->
  <xsl:template match="itemizedlist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xsl:template match="listitem">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xsl:template match="orderedlist">
    <ol>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
  <xsl:template match="para">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- mode: divnum -->
  <xsl:template mode="divnum" match="div1">
    <xsl:number format="1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back/div1 | inform-div1">
    <xsl:number count="div1 | inform-div1" format="A "/>
  </xsl:template>

  <xsl:template mode="divnum"
    match="front/div1 | front//div2 | front//div3 | front//div4 | front//div5"/>

  <xsl:template mode="divnum" match="div2">
    <xsl:number level="multiple" count="div1 | div2" format="1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back//div2">
    <xsl:number level="multiple" count="div1 | div2 | inform-div1"
      format="A.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="div3">
    <xsl:number level="multiple" count="div1 | div2 | div3"
      format="1.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back//div3">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | inform-div1" format="A.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="div4">
    <xsl:number level="multiple" count="div1 | div2 | div3 | div4"
      format="1.1.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back//div4">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | div4 | inform-div1"
      format="A.1.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="div5">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | div4 | div5" format="1.1.1.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back//div5">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | div4 | div5 | inform-div1"
      format="A.1.1.1.1 "/>
  </xsl:template>

  <!-- mode: notes -->
  <xsl:template mode="notes" match="footnote">
    <xsl:variable name="this-note-id">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <dt>
      <xsl:text>[</xsl:text>
      <a id="{$this-note-id}" href="#FN-ANCH-{$this-note-id}">
        <xsl:apply-templates select="." mode="number-simple"/>
      </a>
      <xsl:text>]</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <!-- mode: table.notes -->
  <xsl:template match="footnote" mode="table.notes">
    <xsl:apply-templates mode="table.notes"/>
  </xsl:template>

  <xsl:template match="footnote/p[1]" mode="table.notes">
    <xsl:variable name="this-note-id">
      <xsl:choose>
        <xsl:when test="../@id">
          <xsl:value-of select="../@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(parent::*)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p class="table.footnote">
      <sup>
        <a id="{$this-note-id}" href="#FN-ANCH-{$this-note-id}">
          <xsl:apply-templates select="parent::footnote" mode="number-simple"/>
          <xsl:text>.</xsl:text>
        </a>
      </sup>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- mode: number -->
  <xsl:template mode="number" match="prod">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="." mode="number-simple"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template mode="number" match="issue">
    <xsl:number level="single" format="1"/>
  </xsl:template>

  <xsl:template mode="number" match="prod[@diff='add']">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="preceding::prod[not(@diff='add')][1]"
      mode="number-simple"/>
<!--
  Once again, this could be done right here, but XT won't hear of it.
    <xsl:number level="any" count="prod[not(@diff='add')]"/>
  -->
    <xsl:number level="any" count="prod[@diff='add']"
      from="prod[not(@diff='add')]" format="a"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- mode: number-simple -->
  <xsl:template mode="number-simple" match="prod">
    <xsl:number level="any" count="prod[not(@diff='add')]"/>
  </xsl:template>

  <xsl:template mode="number-simple" match="footnote">
    <xsl:number level="any" format="1"/>
  </xsl:template>

  <!-- mode: ref -->
  <xsl:template match="lhs" mode="ref">
    <tr valign="baseline">
      <td/>
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
	<xsl:copy-of select="../@id"/>
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
        select="following-sibling::*[1][name()='rhs']"/>
    </tr>
  </xsl:template>

  <xsl:template mode="ref" match="prod">
    <xsl:apply-templates select="lhs" mode="ref"/>
    <xsl:apply-templates
      select="rhs[preceding-sibling::*[1][name()!='lhs']] |
              com[preceding-sibling::*[1][name()!='rhs']] |
              constraint[preceding-sibling::*[1][name()!='rhs']] |
              vc[preceding-sibling::*[1][name()!='rhs']] |
              wfc[preceding-sibling::*[1][name()!='rhs']]"/>
  </xsl:template>

  <!-- mode: text -->
  <!-- most stuff processes just as text here, but some things should
       be hidden -->
  <xsl:template mode="text" match="ednote | footnote"/>

  <!-- mode: toc -->
  <xsl:template mode="toc" match="div1">
   <xsl:text>&#10;</xsl:text>
   <li>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <span class="secno"><xsl:apply-templates select="." mode="divnum"/></span>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="head" mode="text"/>
    </a>
    <xsl:if test="$toc.level &gt; 1 and div2">
     <xsl:text>&#10;</xsl:text>
     <ol class="toc">
      <xsl:apply-templates select="div2" mode="toc"/>
     </ol>
    </xsl:if>
   </li>
  </xsl:template>

  <xsl:template mode="toc" match="div2">
   <xsl:text>&#10;</xsl:text>
   <li>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <span class="secno"><xsl:apply-templates select="." mode="divnum"/></span>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="head" mode="text"/>
    </a>
    <xsl:if test="$toc.level &gt; 2 and div3">
      <xsl:apply-templates select="div3" mode="toc"/>
    </xsl:if>
   </li>
  </xsl:template>

  <xsl:template mode="toc" match="div3">
    <xsl:apply-templates select="." mode="divnum"/>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="head" mode="text"/>
    </a>
    <xsl:if test="$toc.level &gt; 3">
      <xsl:apply-templates select="div4" mode="toc"/>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="toc" match="div4">
    <xsl:apply-templates select="." mode="divnum"/>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="head" mode="text"/>
    </a>
    <xsl:if test="$toc.level &gt; 4">
      <xsl:apply-templates select="div5" mode="toc"/>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="toc" match="div5">
    <xsl:apply-templates select="." mode="divnum"/>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="head" mode="text"/>
    </a>
  </xsl:template>

  <xsl:template mode="toc" match="inform-div1">
    <xsl:apply-templates select="." mode="divnum"/>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="head" mode="text"/>
    </a>
    <xsl:text> (Non-Normative)</xsl:text>
    <xsl:if test="$toc.level &gt; 2 and div2">
     <xsl:text>&#10;</xsl:text>
     <ol class="toc">
      <xsl:apply-templates select="div2" mode="toc"/>
     </ol>
    </xsl:if>
  </xsl:template>

  <xsl:template name="css">
    <style type="text/css">
      <xsl:text>
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
                   overflow:auto;
                   padding: 4px; margin: 0em }
div.exampleWrapper { margin: 4px }
div.exampleHeader { font-weight: bold;
                    margin: 4px}
</xsl:text>
      </xsl:if>
      <xsl:value-of select="$additional.css"/>
    </style>
    <xsl:text>&#10;</xsl:text>
    <link rel="stylesheet" type="text/css">
      <xsl:attribute name="href">
        <xsl:text>http://www.w3.org/StyleSheets/TR/</xsl:text>
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
<!--        <xsl:text>.css</xsl:text> -->
      </xsl:attribute>
    </link>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="href.target">
    <xsl:param name="target" select="."/>

    <xsl:text>#</xsl:text>

    <xsl:choose>
      <xsl:when test="$target/@id">
        <xsl:value-of select="$target/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($target)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- ================================================================= -->

<xsl:template name="object.id">
  <xsl:param name="node" select="."/>
  <xsl:param name="default.id" select="''"/>

  <xsl:choose>
    <!-- can't use the default ID if it's used somewhere else in the document! -->
    <xsl:when test="$default.id != '' and not(key('ids', $default.id))">
      <xsl:value-of select="$default.id"/>
    </xsl:when>
    <xsl:when test="$node/@id">
      <xsl:value-of select="$node/@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($node)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="anchor">
  <xsl:param name="node" select="."/>
  <xsl:param name="conditional" select="1"/>
  <xsl:param name="default.id" select="''"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="default.id" select="$default.id"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$conditional = 0 or $node/@id">
    <a id="{$id}"/>
  </xsl:if>
</xsl:template>

<!-- ================================================================= -->

</xsl:transform>
