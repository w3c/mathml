<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

<xsl:import href="xmlspec-restyle.xsl"/>

<xsl:template name="href.target">
  <xsl:param name="target" select="."/>

  <xsl:variable name="slice"
                select="($target/ancestor-or-self::div1
                        |$target/ancestor-or-self::inform-div1
                        |$target/ancestor-or-self::spec)[last()]"/>

  <xsl:apply-templates select="$slice" mode="slice-filename"/>

  <xsl:if test="$target != $slice">
    <xsl:text>#</xsl:text>
    <xsl:choose>
      <xsl:when test="$target/@id">
        <xsl:value-of select="$target/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($target)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="spec" mode="slice-filename">
  <xsl:text>index.html</xsl:text>
</xsl:template>

<xsl:template match="body/div1" mode="slice-filename">
  <xsl:variable name="docnumber">
    <xsl:number count="div1" level="multiple" format="1"/>
  </xsl:variable>
  <xsl:text>slice</xsl:text>
  <xsl:value-of select="$docnumber"/>
  <xsl:text>.html</xsl:text>
</xsl:template>

<xsl:template match="back/div1 | inform-div1" mode="slice-filename">
  <xsl:variable name="docnumber">
    <xsl:number count="div1|inform-div1" level="multiple" format="A"/>
  </xsl:variable>
  <xsl:text>slice</xsl:text>
  <xsl:value-of select="$docnumber"/>
  <xsl:text>.html</xsl:text>
</xsl:template>

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
        <head>
          <title><xsl:value-of select="head"/></title>
          <xsl:call-template name="css"/>
        </head>
        <body>
          <xsl:call-template name="navigation.top">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>

          <div class="div1">
            <xsl:apply-templates/>
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
        </head>
        <body>
          <xsl:call-template name="navigation.top">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>

          <div class="div1">
            <xsl:apply-templates/>
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
          <xsl:call-template name="navigation.top">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>

          <div class="div1">
            <xsl:apply-templates/>
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

<xsl:template match="spec">
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
          <title>
            <xsl:apply-templates select="header/title"/>
            <xsl:if test="header/version">
              <xsl:text> </xsl:text>
              <xsl:apply-templates select="header/version"/>
            </xsl:if>
          </title>
          <xsl:call-template name="css"/>
        </head>
        <body>
          <xsl:apply-templates/>
          <xsl:if test="//footnote">
            <hr/>
            <div class="endnotes">
              <h3>
                <a name="endnotes">
                  <xsl:text>End Notes</xsl:text>
                </a>
              </h3>
              <dl>
                <xsl:apply-templates select="//footnote" mode="notes"/>
              </dl>
            </div>
          </xsl:if>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

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
        <a href="index.html#contents">Table of Contents</a>
      </td>
      <td align="left">
        <xsl:choose>
          <xsl:when test="$prev">
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="$prev"/>
<!--                  <xsl:with-param name="just.filename" select="1"/>-->
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
                  <!--<xsl:with-param name="just.filename" select="1"/>-->
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

  <!-- quick table of contents -->
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

<xsl:template name="navigation.bottom">
  <xsl:param name="prev" select="''"/>
  <xsl:param name="next" select="''"/>

  <a name="Bottom"/>
  <xsl:comment> BOTTOM NAVIGATION BAR </xsl:comment>
  <table border="0" width="90%"
         cellpadding="4" cellspacing="0"
         bgcolor="#eeeeff"
         class="navigation"
summary="Navigation">
    <col width="50%"/>
    <col width="50%"/>
    <tr><td>&#xa0;</td><td>&#xa0;</td></tr>
    <tr>
      <td align="left">
        <a href="index.html#contents">Table of Contents</a>
      </td>
      <td align="left">
        <a href="#Top">Top</a>
      </td>
    </tr>
  </table>
</xsl:template>


</xsl:stylesheet>

