<!--

html2xhtml.xsl:  HTML to XHTML  XSL stylesheet converter
========================================================

$Id: html2xhtml.xsl,v 1.11 2013-12-10 15:55:07 dcarlis Exp $

 Copyright 1999 David Carlisle NAG Ltd


The following stylesheet takes as input an XSL stylesheet that writes
HTML, and produces a stylesheet that writes XML that hopefully matches the
XHTML specification. (It does not check that the output matches the DTD.)
It does the following things:

* Adds a DOCTYPE giving FPI and URL for one of the three flavours
  of XHTML1. (Transitional unless the original stylesheet asked for
  Frameset or Strict HTML.)
  If the system-dtd parameter is set then instead of the canonical
  XHTML PUBLIC DTD, a SYSTEM declaration is given to the supplied URL.

* Writes all HTML elements and attributes as lowercase, with 
  elements being written in the XHTML namespace.

* Writes canonically empty elements such as <BR> as
  <br class="html-compat"/> . 
  (Appendix C recommends <br /> rather than <br/> but an XSL stylesheet
  has no control over the concrete syntax of the linearisation, so
  adding an attribute is probably the best that can be done. (No attribute
  is added if the element already has attributes.)

* Changes the output method from html to xml in xsl:output
  (and also in the xt:document extension element).

* Forces a line break after opening tags of non elements which are
  not canonically empty, to ensure that they are never written with XML
  empty syntax, so
  <p>
  </p>
  not
  <p/>

* Copies any elements from XSL or XT namespaces through to the new
  stylesheet.


* Duplicates name attributes to id unless element already has id.

* Adds meta element to head specifying utf-8 encoding.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"  
                xmlns:xt="http://www.jclark.com/xt"
                xmlns="http://www.w3.org/1999/xhtml"
xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:xalanredirect="org.apache.xalan.xslt.extensions.Redirect"
                version="1.0"
                >

<xsl:output method="xml" indent="no"/>

<xsl:param name="system-dtd" />
<xsl:param name="stylesheet.pi" select="''"/>

<xsl:template match="xsl:*|xt:*|saxon:*|lxslt:*|xalanredirect:*">
<xsl:copy>
  <xsl:copy-of select="@*"/>
  <xsl:apply-templates/>
</xsl:copy>
</xsl:template>

<xsl:template match="xsl:attribute[@name='lang']">
<xsl:copy>
  <xsl:copy-of select="@*"/>
  <xsl:attribute name="name">xml:lang</xsl:attribute>
  <xsl:apply-templates/>
</xsl:copy>
</xsl:template>
 
<xsl:template match="xsl:output|xt:document|saxon:output">
<xsl:copy>
  <xsl:attribute name="method">xml</xsl:attribute>
  <xsl:choose>
  <xsl:when test="$system-dtd">
    <xsl:attribute name="doctype-system">
       <xsl:value-of select="$system-dtd"/>
    </xsl:attribute>
  </xsl:when>
  <xsl:when test="contains(@doctype-public,'Frameset')">
    <xsl:attribute name="doctype-public">
     <xsl:text>-//W3C//DTD XHTML 1.0 Frameset//EN</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="doctype-system">
       <xsl:text>http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd</xsl:text>
    </xsl:attribute>
  </xsl:when>
  <xsl:when test="contains(@doctype-public,'Strict')">
    <xsl:attribute name="doctype-public">
     <xsl:text>-//W3C//DTD XHTML 1.0 Strict//EN</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="doctype-system">
       <xsl:text>http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd</xsl:text>
    </xsl:attribute>
  </xsl:when>
  <xsl:otherwise>
    <xsl:attribute name="doctype-public">
     <xsl:text>-//W3C//DTD XHTML 1.0 Transitional//EN</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="doctype-system">
       <xsl:text>http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd</xsl:text>
    </xsl:attribute>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:attribute name="indent">yes</xsl:attribute>
  <xsl:copy-of select="@*[not(
      name(.)='method' or
      name(.)='doctype-public' or
      name(.)='doctype-system' or
      name(.)='indent'
      )  ]"/>
  <xsl:apply-templates/>
</xsl:copy>
</xsl:template>

<xsl:template match="xsl:import|xsl:include">
<xsl:copy>
<xsl:copy-of select="@*"/>
<xsl:attribute name="href">x<xsl:value-of select="@href"/></xsl:attribute>
</xsl:copy>
</xsl:template>

<xsl:template match="xsl:element[contains(@name,'{')]">
<xsl:copy>
 <xsl:attribute name="namespace">http://www.w3.org/1999/xhtml</xsl:attribute>
 <xsl:copy-of select="@*"/>
 <xsl:apply-templates/>
</xsl:copy>
</xsl:template>

<xsl:template match="xsl:variable[@name='relax-schema']" priority="100">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="*|xsl:element">
<xsl:variable name="n">
  <xsl:choose>
  <xsl:when test="self::xsl:element">
    <xsl:value-of  select="translate(@name,
                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
                   'abcdefghijklmnopqrstuvwxyz')"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of  select="translate(local-name(.),
                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
                   'abcdefghijklmnopqrstuvwxyz')"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:if test="$n='html' and string($stylesheet.pi)">
 <xsl:text>&#10;</xsl:text>
 <xsl:element name="xsl:processing-instruction">
   <xsl:attribute name="name">xml-stylesheet</xsl:attribute
     >type="text/xsl" href="<xsl:copy-of 
       select="$stylesheet.pi"/>"</xsl:element>
</xsl:if>
<xsl:element
  name="{$n}"
   namespace="http://www.w3.org/1999/xhtml">
  <xsl:for-each select="self::*[not(self::xsl:element)]/@* |
                       self::xsl:element/@use-attribute-sets">
<xsl:variable name="name" select="translate(local-name(.),
                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
                   'abcdefghijklmnopqrstuvwxyz')"/>
    <xsl:if test="($name != 'name') and ($name != 'align') and ($name != 'lang')">
    <xsl:attribute name="{$name}">
     <xsl:value-of select="."/>
    </xsl:attribute>
    </xsl:if>

  </xsl:for-each>
  <xsl:if test="@lang">
    <xsl:attribute name="xml:lang"><xsl:value-of select="@lang"/></xsl:attribute>   
  </xsl:if>
  <xsl:if test="@align[not(.=('left','right'))] and not(@style)">
    <xsl:attribute name="style">vertical-align:<xsl:value-of select="@align"/></xsl:attribute>   
  </xsl:if>
  <xsl:if test="@name and not(@id)">
    <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>   
  </xsl:if>
  <xsl:if test="@NAME and not(@id)">
    <xsl:attribute name="id"><xsl:value-of select="@NAME"/></xsl:attribute>   
  </xsl:if>
  <xsl:variable name="content">
   <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
  <xsl:when test="$n='br' or $n='hr'
         or $n='link' or $n='img' or $n='base' or $n='meta'">
    <xsl:if test="not(@*) and not(xsl:attribute)">
      <xsl:attribute name="class">html-compat</xsl:attribute>
    </xsl:if>
   <xsl:copy-of select="$content"/>
  </xsl:when>
  <xsl:when test="ancestor::pre">
   <xsl:copy-of select="$content"/>
  </xsl:when>
  <xsl:otherwise>
<!--   <xsl:element name="xsl:text" xml:space='preserve'>&#xA;</xsl:element>-->
   <xsl:copy-of select="$content"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:element>
</xsl:template>


</xsl:stylesheet>


