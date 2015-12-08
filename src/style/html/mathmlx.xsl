<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="xs"
                >

<xsl:import href="xmmldiff.xsl"/>

<xsl:output method="xhtml" media-type="application/xhtml+xml" use-character-maps="doe"/>

<xsl:character-map name="doe">
<xsl:output-character character="&#1000;" string="&lt;"/>
<xsl:output-character character="&#1001;" string="&gt;"/>
<xsl:output-character character="&#1002;" string="&amp;"/>
</xsl:character-map>

<xsl:param name="filename.extension" select="'.xml'"/>
<xsl:param name="show.diff.markup" select="'0'"/>
<xsl:param name="dtdpublic" select="''"/>
<xsl:param name="dtdsystem" select="'mathml.dtd'"/>

<xsl:param name="additional.format.note">
          <div id="xhtml-version">
            <p>The presentation of this document has been augmented to
            use XHTML rather than HTML, and to include all MathML
            examples as inlined MathML markup that should be rendered by
            a MathML enabled browser. The MathML examples that have
            been added, and which should be displayed in your browser,
            are marked <span class="mathml-render">like&#160;this</span>.</p>
            <hr/>
          </div>
</xsl:param>

<xsl:param name="additional.title">
    <xsl:text>XHTML + MathML Version</xsl:text>
</xsl:param>

<xsl:template match="eg[@role=('mathml','strict-mathml')]">
<xsl:variable name="t">
<xsl:apply-templates/>
</xsl:variable>
<table>
<tr>
<td>
<pre class="{@role}">
<xsl:copy-of select="$t"/>
</pre>
</td>
<td class="mathml-render" valign="middle">
<math xmlns="http://www.w3.org/1998/Math/MathML">
 <xsl:value-of select="translate(replace($t,'&lt;!--[^>]*-->',''),'&lt;&gt;&amp;','&#1000;&#1001;&#1002;')"/>
</math>
</td>
</tr>
</table>
</xsl:template>


<xsl:template match="eg[@role='mathml-list']">
<table>
<tr>
<td>
<pre>
<xsl:apply-templates/>
</pre>
</td>
<td class="mathml-render" valign="middle">
<math xmlns="http://www.w3.org/1998/Math/MathML">
<mfenced open="" close="">
 <xsl:value-of select="translate(.,'&lt;&gt;&amp;','&#1000;&#1001;&#1002;')"/>
</mfenced>
</math>
</td>
</tr>
</table>
</xsl:template>

<xsl:template match="eg[@role='mathml...']">
<table>
<tr>
<td>
<pre>
<xsl:apply-templates/>
</pre>
</td>
<td class="mathml-render" valign="middle">
<math xmlns="http://www.w3.org/1998/Math/MathML">
 <xsl:value-of select="translate(replace(.,'\.\.\.',''),'&lt;&gt;&amp;','&#1000;&#1001;&#1002;')"/>
</math>
</td>
</tr>
</table>
</xsl:template>


<xsl:template match="MMLexample[not(@role='mathml-fragment')]">
<dt>Example</dt>
<dd><xsl:apply-templates select="description"/>
<table>
<tr>
<td>
<pre>
<xsl:apply-templates select="node()[not(self::description)]"/>
</pre>
</td>
</tr>
<tr>
<td class="mathml-render" valign="middle">
<math xmlns="http://www.w3.org/1998/Math/MathML">
  <xsl:variable name="e">
    <xsl:copy-of select="node()[not(self::description)]"/>
  </xsl:variable>
 <xsl:value-of select="translate($e,'&lt;&gt;&amp;','&#1000;&#1001;&#1002;')"/>
</math>
</td>
</tr>
</table>
</dd>
</xsl:template>


<xsl:template match="property[not(@role='mathml-fragment')]">
<dt>Property</dt>
<dd><xsl:apply-templates select="description"/>
<table>
<tr>
<td>
<pre>
<xsl:apply-templates select="node()[not(self::description)]"/>
</pre>
</td>
</tr>
<tr>
<td class="mathml-render" valign="middle">
<math xmlns="http://www.w3.org/1998/Math/MathML">
  <xsl:variable name="e">
    <xsl:copy-of select="node()[not(self::description)]"/>
  </xsl:variable>
 <xsl:value-of select="translate($e,'&lt;&gt;&amp;','&#1000;&#1001;&#1002;')"/>
</math>
</td>
</tr>
</table>
</dd>
</xsl:template>


<xsl:template match="*[@meta]/text()" priority="4">
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
      <span class="egmeta"><xsl:value-of select="substring(.,2,string-length(.)-2)"/></span>
	  <xsl:value-of select="substring(.,string-length(.))"/>
	</xsl:when>
	<xsl:when test="starts-with(.,'=&quot;')">
	  <xsl:text>=&quot;</xsl:text>
      <span class="egmeta"><xsl:value-of select="translate(.,'=&quot;','')"/></span>
	  <xsl:text>&quot;</xsl:text>
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

</xsl:stylesheet>
