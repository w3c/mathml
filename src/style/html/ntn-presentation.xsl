<?xml version="1.0" encoding="utf-8"?>

<!--
  tiny stylesheet to take care of a display of the notations
  and use the generated stylesheet.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    xmlns:om="http://www.openmath.org/OpenMath"
    version="2.0"
    exclude-result-prefixes="m om">

 
  <xsl:template match="m:notation">
    <table border="1" cellpadding="3"><tr>
      <td>
        <pre>
          <xsl:for-each select="m:prototype">
              <xsl:apply-templates mode="verb"/>
          </xsl:for-each>
        </pre>
      </td>
      <td valign="top">
    <xsl:for-each select="m:presentation">
    <table border="1">
    <tr>
      <td valign="top" style="font-size:70%; background-color:lightgray">
        <xsl:call-template name="read-context"/>
      </td>
    </tr>
    <tr>
      <td align="center">
          <div style="font-size:200%;">
            <img alt="notation-image">
              <xsl:attribute name="src">
                <xsl:text>image/cd-notations-</xsl:text>
                <xsl:number level="multiple" count="m:notation | m:presentation"
                  format="1.1"/>
                <xsl:text>.png</xsl:text>
              </xsl:attribute>
            </img><!-- TODO: TeX alt-tag from MathML?? -->
          </div>
      </td>
    </tr>
    <tr>
    <td valign="bottom" >
    <p style="font-size:70%;">
            precedence: <xsl:value-of select="@precedence"/>
            <xsl:for-each select="m:math//m:arg[@precedence]">
              <xsl:text>, for argument </xsl:text>
              <xsl:value-of select="@name"/>
              <xsl:text>: </xsl:text>
              <xsl:value-of select="@precedence"/>
            </xsl:for-each>
    </p>
    <!-- display precedence (top and each child) -->
    </td></tr></table>
    </xsl:for-each>
  </td></tr></table>
  </xsl:template>
  
  
  <xsl:template name="read-context">
    <xsl:choose>
    <xsl:when test="@xml:lang | @variant">
      <p><b>Context:</b><br/>
      <xsl:for-each select="@*[local-name()!='precedence']">
          <xsl:value-of select="local-name()"/>:<xsl:value-of select="."/><br/>
          <!-- TODO: values in above elements -->
      </xsl:for-each></p>
    </xsl:when>
    <xsl:otherwise><p><b>Context:</b> generic</p></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <xsl:template match="m:arg">
      <xsl:choose>
        <xsl:when test="ancestor::om:OMOBJ">
          <m:mi><xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
          <m:mi mathbackground="lightblue"><xsl:value-of select="@name"/></m:mi>
          <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text></m:mi>
        </xsl:when>
        <xsl:otherwise>
          <m:mi mathbackground="lightblue"><xsl:value-of select="@name"/></m:mi>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
    
  <xsl:template match="*[namespace-uri()='http://www.w3.org/1998/Math/MathML']" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="*[namespace-uri()='http://www.openmath.org/OpenMath']" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>
  
  <xsl:template match="m:nary">
    <m:mtext>nary(</m:mtext>
      <xsl:apply-templates/>
    <m:mtext>)</m:mtext>
  </xsl:template>
  
  
  
  
<xsl:template match="renderedMMLexample">
<dt>Rendered Example</dt>
<dd>
<xsl:apply-templates select="description"/><table border="0" cellpadding="2" width="90%"><tr><td>
<pre><xsl:if test="@diff and $show.diff.markup='1'">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if><xsl:apply-templates select="node()[not(self::description)]"/></pre></td>
<td>
 <img alt="example-image">
  <xsl:attribute name="src">
      <xsl:text>image/cd-examples-</xsl:text>
      <xsl:number level="multiple" count="MMLdefinition | renderedMMLexample"
        format="1.1"/>
      <xsl:text>.png</xsl:text>
  </xsl:attribute>
 </img>
</td></tr></table></dd>
</xsl:template>



<!--   verb mode -->

<!-- Does not really give verbatim copy of the file as that
     information not present in the parsed document, but should
     give something that renders in HTML as a well formed XML
     document that would parse to give same XML tree as the original
-->

<!-- non empty elements and other nodes. -->
<xsl:template mode="verb" match="*[*]|*[text()]|*[comment()]|*[processing-instruction()]">
  <xsl:value-of select="concat('&lt;',name(.))"/>
  <xsl:call-template name="ns"/>
  <xsl:apply-templates mode="verb" select="@*"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:apply-templates mode="verb"/>
  <xsl:value-of select="concat('&lt;/',name(.),'&gt;')"/>
</xsl:template>

<!-- empty elements -->
<xsl:template mode="verb" match="*">
  <xsl:value-of select="concat('&lt;',name(.))"/>
  <xsl:call-template name="ns"/>
  <xsl:apply-templates mode="verb" select="@*"/>
  <xsl:text>/&gt;</xsl:text>
</xsl:template>

<xsl:template name="ns">
<xsl:variable name="a" select="../namespace::*"/>
<xsl:variable name="b" select="namespace::*"/>
<xsl:for-each select="$b[not(name()='xml')]">
<xsl:variable name="n" select="name()"/>
<xsl:variable name="v" select="."/>
<xsl:if test="not($a[name()=$n and . = $v])">
<xsl:text/> xmlns<xsl:if test="$n">:</xsl:if><xsl:value-of
  select="$n"/>="<xsl:value-of select="$v"/>"<xsl:text/>
</xsl:if>
</xsl:for-each>
<!--
 This should work (and does with saxon, but not with xalan) so instead do the above.

  <xsl:for-each select="namespace::*[not(name()='xml')]">
  <xsl:if test="not(../../namespace::*[name()=name(current()) and (. = current())])">
  <xsl:text/> xmlns<xsl:if test="name()">:</xsl:if><xsl:value-of
  select="name()"/>="<xsl:value-of select="."/>"<xsl:text/>
  </xsl:if>
  </xsl:for-each>
-->
</xsl:template>

<!-- attributes
     Output always surrounds attribute value by "
     so we need to make sure no literal " appear in the value  -->
<xsl:template mode="verb" match="@*">
  <xsl:value-of select="concat(' ',name(.),'=')"/>
  <xsl:text>"</xsl:text>
  <xsl:call-template name="string-replace">
    <xsl:with-param name="from" select="'&quot;'"/>
    <xsl:with-param name="to" select="'&amp;quot;'"/> 
    <xsl:with-param name="string" select="."/>
  </xsl:call-template>
  <xsl:text>"</xsl:text>
</xsl:template>


<!-- pis -->
<xsl:template mode="verb" match="processing-instruction()">
  <xsl:value-of select="concat('&lt;?',name(.),' ',.,'?&gt;')"/>
</xsl:template>

<!-- only works if parser passes on comment nodes -->
<xsl:template mode="verb" match="comment()">
  <xsl:value-of select="concat('&lt;!--',.,'--&gt;')"/>
</xsl:template>

<!-- text elements
     need to replace & and < by entity references
     do > as well,  just for balance -->
<xsl:template mode="verb" match="text()">
  <xsl:call-template name="string-replace">
    <xsl:with-param name="to" select="'&amp;gt;'"/>
    <xsl:with-param name="from" select="'&gt;'"/> 
    <xsl:with-param name="string">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to" select="'&amp;lt;'"/>
        <xsl:with-param name="from" select="'&lt;'"/> 
        <xsl:with-param name="string">
          <xsl:call-template name="string-replace">
            <xsl:with-param name="to" select="'&amp;amp;'"/>
            <xsl:with-param name="from" select="'&amp;'"/> 
            <xsl:with-param name="string" select="."/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- end  verb mode -->

<!-- replace all occurences of the character(s) `from'
     by the string `to' in the string `string'.-->
<xsl:template name="string-replace" >
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>
  <xsl:choose>
    <xsl:when test="contains($string,$from)">
      <xsl:value-of select="substring-before($string,$from)"/>
      <xsl:value-of select="$to"/>
      <xsl:call-template name="string-replace">
      <xsl:with-param name="string" select="substring-after($string,$from)"/>
      <xsl:with-param name="from" select="$from"/>
      <xsl:with-param name="to" select="$to"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>






</xsl:stylesheet>
