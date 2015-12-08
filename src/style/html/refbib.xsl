<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		>

<xsl:param name="q"/>

<xsl:output omit-xml-declaration="yes" indent="yes"/>

<xsl:template name="webref">
 <xsl:param name="q" select="$q"/>
 <blist>
  <xsl:variable name="x" select="unparsed-text(concat('http://webref.herokuapp.com/bibrefs?refs=',$q))"/>
  <xsl:analyze-string select="replace($x,'^[{]|[}]$','')" regex="&quot;([^&quot;]*)&quot;:\{{([^{{}}]*)\}}[, ]*">
   <xsl:matching-substring>
    <bibl id="{regex-group(1)}">
     <xsl:analyze-string select="." regex="&quot;([^&quot;]*)&quot;:(&quot;([^&quot;]*)&quot;|\[([^\[\]]*)\])">
      <xsl:matching-substring>
       <phrase role="{regex-group(1)}">
	<xsl:choose> 
	 <xsl:when test="regex-group(1)='authors'">
	  <xsl:analyze-string select="regex-group(2)" regex="&quot;([^&quot;]*)&quot;[, ]*">
	   <xsl:matching-substring>
	    <phrase role="author"><xsl:value-of select="regex-group(1)"/></phrase>
	   </xsl:matching-substring>
	  </xsl:analyze-string>
	 </xsl:when>
	 <xsl:otherwise>
	  <xsl:value-of select="regex-group(3)"/>
	 </xsl:otherwise>
	</xsl:choose>
       </phrase>
      </xsl:matching-substring>
     </xsl:analyze-string>
    </bibl>
   </xsl:matching-substring>
  </xsl:analyze-string>
 </blist>
</xsl:template>

</xsl:stylesheet>

