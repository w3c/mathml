<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

<xsl:import href="ntn-presentation.xsl"/>

<!-- for the moment, we only use Content Dictionaries at div2-level -->
<xsl:template match="mcd">
  <div class="div2">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template mode="divnum" match="mcd">
  <xsl:number level="multiple" count="div1 | div2 | mcd" format="1.1 "/>
</xsl:template>

  <xsl:template mode="toc" match="mcd">
    <xsl:text>&#xa0;&#xa0;&#xa0;&#xa0;</xsl:text>
    <xsl:apply-templates select="." mode="divnum"/>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:text>Content Dictionary: </xsl:text>
      <xsl:apply-templates select="title" mode="text"/>
    </a>
  </xsl:template>

  <xsl:template match="mcd/title">
    <xsl:text>&#10;</xsl:text>
    <h3>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:text>Content Dictionary: </xsl:text>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>


  <xsl:template mode="divnum" match="MMLdefinition" priority="1">
    <xsl:number level="multiple" count="div1 | div2 | MMLdefinition" format="1.1.1 "/>
  </xsl:template>

<xsl:template match="MMLdefinition" priority="1">
  <xsl:element name="h{5 -$slice.depth}">
    <xsl:call-template name="anchor"/>
    <xsl:number level="multiple" count="div1|div2|MMLdefinition" format="1.1.1 "/>
    MMLdefinition: <code><xsl:text>
    </xsl:text><xsl:value-of select="name"/></code>
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
  <tr><xsl:text>
</xsl:text><xsl:apply-templates/></tr>
  </xsl:for-each>
  </table>
  </dd>
  </xsl:if>

  <xsl:if test="signature">
  <dt>Signature</dt>
  <dd>
  <xsl:apply-templates select="signature"/>
  </dd>
  </xsl:if>
  <xsl:apply-templates select="property|MMLexample"/>
  </dl>

</xsl:template>

<xsl:template match="signature">
    <p><xsl:text>
    </xsl:text><xsl:value-of select="."/></p>
</xsl:template>


<xsl:template match="MMLexample">
  <dt p="{name(..)}">Example</dt>
  <dd>
    <xsl:apply-templates select="description/*"/>
    <pre>
      <xsl:if test="@diff and $show.diff.markup='1'">
	<xsl:attribute name="class">
	  <xsl:text>diff-</xsl:text>
	  <xsl:value-of select="@diff"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()[not(self::description)]"/>
    </pre>
  </dd>
</xsl:template>

<xsl:template match="discussion/MMLexample">
<dl>
  <dt>Example</dt>
  <dd>
    <xsl:apply-templates select="description/*"/>
    <pre>
      <xsl:if test="@diff and $show.diff.markup='1'">
	<xsl:attribute name="class">
	  <xsl:text>diff-</xsl:text>
	  <xsl:value-of select="@diff"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()[not(self::description)]"/>
    </pre>
  </dd>
</dl></xsl:template>

<xsl:template match="classification">
<dt>Classification</dt>
<dd><xsl:text>
</xsl:text><xsl:apply-templates/></dd>
</xsl:template>


<xsl:template match="attvalue|attname|attdefault">
<td><xsl:text>
</xsl:text><xsl:apply-templates/></td>
</xsl:template>


<xsl:template match="property">
  <dt>Property</dt>
  <dd>
    <xsl:apply-templates select="description/*"/>
    <pre>
      <xsl:if test="@diff and $show.diff.markup='1'">
        <xsl:attribute name="class">
          <xsl:text>diff-</xsl:text>
          <xsl:value-of select="@diff"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()[not(self::description)]"/>
    </pre>
  </dd>
</xsl:template>

<xsl:template match="description">
  <dt>Description</dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="discussion">
  <dl>
  <dt>Discussion</dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
  </dl>
</xsl:template>

<xsl:template match="MMLdefinition/discussion">
  <dt>Discussion</dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>


<xsl:template match="MMLdefinition/name"/>


<xsl:template match="MMLdefinition/functorclass"/>


<xsl:template match="rendering">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>


