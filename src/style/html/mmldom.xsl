<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"                
                extension-element-prefixes="saxon"
                version="1.0">

<xsl:import href="mmlspec.xsl"/>

<xsl:template match="/">

  <!-- GENERATE IDL FILE IN THIS DIRECTORY -->
  <xsl:apply-templates select="id('mathml-dom')"
       mode="extFileIDLInterfaces"/>

  <!-- GENERATE JAVA FILES IN DIRECTORY java/org/w3c/dom/mathml -->
  <xsl:apply-templates select="id('mathml-dom')"
       mode="extFileJavaInterfaces"/>

  <!-- GENERATE SEPARATE ECMASCRIPT BINDING FILE (HTML) -->
  <xsl:apply-templates select="id('mathml-dom')"
       mode="extFileEcmaInterfaces"/>

</xsl:template>

<xsl:template match="div1[@id='mathml-dom']" mode="extFileIDLInterfaces">
<!--  <xt:document method="text"
        href="mathml-dom.idl">-->
  <saxon:output method="text" href="mathml-dom.idl">
    <xsl:value-of select="$idlFileHeader"/>
    <xsl:apply-templates mode="IDLgetForwardDeclarations"/> 
    <xsl:value-of select="$IDLindent1"/>
    <xsl:apply-templates mode="IDLInterfaces"/>
    <xsl:value-of select="$idlFileFooter"/>
  </saxon:output>
<!--  </xt:document>-->
</xsl:template>

<xsl:template match="div1[@id='mathml-dom']" mode="extFileJavaInterfaces">
  <xsl:apply-templates mode="extFileJavaInterfaces" select=".//interface"/>
</xsl:template>

<xsl:template match="interface" mode="extFileJavaInterfaces">
<!--  <xt:document method="text"
        href="java/org/w3c/dom/mathml/{@name}.java">-->
  <saxon:output method="text"
        href="java/org/w3c/dom/mathml/{@name}.java">
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
  </saxon:output>
<!--  </xt:document>-->
</xsl:template>

<xsl:template match="*" mode="extFileJavaInterfaces">
</xsl:template>

<xsl:template match="div1[@id='mathml-dom']" mode="extFileEcmaInterfaces">
  <!--<xt:document method="html"
        href="mathml-dom_ecma.html">-->
  <saxon:output method="html" href="mathml-dom_ecma.html"
        indent="yes" encoding="utf-8"
       doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
       doctype-system="http://www.w3.org/TR/html4/loose.dtd"
  >
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
<!--  </xt:document>-->
  </saxon:output>
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
    <xsl:when test="/spec/@w3c-doctype='rec'">W3C-REC
      <link rel="stylesheet" type="text/css" href="{$css.base.uri}/W3C-REC"></link>
    </xsl:when>
    <xsl:when test="/spec/@w3c-doctype='pr'">W3C-PR
    <link rel="stylesheet" type="text/css" href="{$css.base.uri}/W3C-PR"></link>
    </xsl:when>
    <xsl:when test="/spec/@w3c-doctype='cr'">W3C-CR
    <link rel="stylesheet" type="text/css" href="{$css.base.uri}/W3C-CR"></link>
    </xsl:when>
    <xsl:otherwise>
    <link rel="stylesheet" type="text/css" href="{$css.base.uri}/W3C-WD"></link>
    </xsl:otherwise>
  </xsl:choose>
  </head>
</xsl:template>



</xsl:stylesheet>