<xsl:stylesheet version="2.0" 
 xmlns="http://www.w3.org/1999/xhtml"
 xpath-default-namespace="http://www.w3.org/1999/xhtml"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 

 <xsl:output method="xhtml" indent="no" encoding="US-ASCII" omit-xml-declaration="yes" include-content-type="no" use-character-maps="amplt"/>

<xsl:character-map name="amplt">
 <xsl:output-character character="&#1001;" string="&amp;"/>
 <xsl:output-character character="&#1002;" string="&lt;"/>
 <xsl:output-character character="&#1003;" string="&gt;"/>
</xsl:character-map>

<xsl:variable name="chaps" select="'chapter1',
'chapter2',
'chapter3',
'chapter4',
'chapter5',
'chapter6',
'chapter7',
'appendixa',
'appendixb',
'appendixc',
'appendixd',
'appendixe',
'appendixf',
'appendixg',
'appendixh',
'appendixi'"/>


<xsl:template match="@*|node()">
<xsl:copy copy-namespaces="no">
<xsl:apply-templates select="@*,node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="acronym">
<abbr>
<xsl:apply-templates select="@*,node()"/>
</abbr>
</xsl:template>

<xsl:template match="@xml:space"/>

<xsl:template match="@class[.='html-compat']"/>
<xsl:template match="table/@width"/>
<xsl:template match="table/@border"/>
<xsl:template match="table/@valign"/>
<xsl:template match="td/@valign"/>
<xsl:template match="td/@width"/>
<xsl:template match="td/@summary"/>
<xsl:template match="table/@summary"/>
<xsl:template match="table/@valign"/>
<xsl:template match="th/@abbr"/>
<xsl:template match="@colspan[.=1]"/>
<xsl:template match="@rowspan[.=1]"/>
<xsl:template match="head/title">
 <xsl:text>&#10;</xsl:text>
 <title>
  <xsl:value-of select="substring-before(.,'--')"/>
  <xsl:text> -- single page HTML + MathML Version</xsl:text>
 </title>
 <xsl:text>&#10;</xsl:text>
</xsl:template>



<xsl:template match="body/div[@class=('minitoc','head') or @id='xhtml-version']" priority="222"/>


<xsl:template name="main">
<xsl:text>&#1002;!DOCTYPE html&#1003;</xsl:text>
<xsl:text>&#10;</xsl:text>
<html>
<xsl:text>&#10;</xsl:text>
<head>
<xsl:text>&#10;</xsl:text>
<xsl:text>&#10;</xsl:text>
<xsl:apply-templates select="doc('Overview.xml')/html/head/node()">
<xsl:with-param name="file" select="'Overview'" tunnel="yes"/>
</xsl:apply-templates>
<xsl:text>&#10;</xsl:text>
<script type="text/javascript" src="sorttable.js"></script>
<xsl:text>&#10;</xsl:text>
<xsl:text>&#10;</xsl:text>
<script src="doctop.js"></script>
<xsl:text>&#10;</xsl:text>
<script>
  function showlink (e) {
  e.childNodes[0].textContent='\u00a7\u00a0';
  }
  function hidelink (e) {
  e.childNodes[0].textContent='';
  }
function entcheck(att) {
    var spn = document.getElementsByTagName('span');
	for (var i = 0; i &#1002; spn.length;i++){
	    if(spn[i].hasAttribute(att)) {
//            spn[i].innerHTML=spn[i].getAttribute(att);
spn[i].removeChild(spn[i].firstChild);
spn[i].appendChild(document.createTextNode(spn[i].getAttribute(att)));
}
}
}
</script>
<xsl:text>&#10;</xsl:text>
<style>
  html{
  background-color: #EEEEEE;
  }
  body{
   max-width: 70em;
   margin-left:auto;
   margin-right:auto;
   padding:1em;
   background-color:white;
   }
   div.mathml-example-render-1 {
   display:inline-block;
   vertical-align:middle;
   }
   .mathml-example-render-2 {
   display:inline-block;
   vertical-align:middle;
   }
   .mathml-render {
   font-family: serif;
   font-size: 130%;
   border: solid 4px green;
   padding: 1em;
   }

   a.selflink {
   float:left; text-decoration:none; white-space:nowrap; width:0pt;margin-left:-.6em;
   }

</style>
<xsl:text>&#10;</xsl:text>
</head>
<xsl:text>&#10;</xsl:text>
<body>
  <xsl:text>&#10;</xsl:text>

  <div data-id="w">
    <xsl:copy-of select="doc('Overview.xml')/html/body/div[@class='head']/@*"/>

    <xsl:apply-templates select="doc('Overview.xml')/html/body/div[@class='head']/node()">
     <xsl:with-param name="file" select="'Overview'" tunnel="yes"/>
    </xsl:apply-templates>
  </div>

  <xsl:text>&#10;</xsl:text>
  <div style="position:fixed; top: {if(doc('Overview.xml')/html/head/link/@href/contains(.,'W3C')) then '25' else '5'}em; left: 0.25em; width: 4em; background-color: yellow;"><a href="#Overview_contents" style="font-size:75%;">Table of Contents</a></div>
  <xsl:text>&#10;</xsl:text>
  <div>
    <xsl:text>&#10;</xsl:text>
    <hr />
    <p>The presentation of this document has been augmented to
    use HTML5 rather than HTML4, and to include all MathML
    examples as inlined MathML markup that should be rendered by
    a MathML enabled browser. The MathML examples that have
    been added, and which should be displayed in your browser,
    are marked <span class="mathml-render" style="padding:0">like&#160;this</span>.
    </p>
    <p><b>Note:</b><br/>
    <xsl:text>Most symbol characters in examples may be shown in one of three forms:</xsl:text>
    <br/>
    <xsl:text>&#10;Entity reference (</xsl:text>
    <code>&amp;sum;</code>
    <xsl:text>),&#10;Numeric character reference (</xsl:text>
    <code>&amp;#x2211;</code>
    <xsl:text>)&#10; or as the character data directly (</xsl:text>
    <code>&#1001;#x2211;</code>
    <xsl:text>).</xsl:text>
    <br/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>By default, numeric references are used but you may alter the display by selecting an appropriate button below:</xsl:text><br/>
    <xsl:text>&#10;</xsl:text>
    <input type="radio" name="showent" value="title" onclick="entcheck('title')" id="entent"/>
    <xsl:text>&#10;</xsl:text>
    <label for="entent">Entity Reference </label>
    <xsl:text>&#10;</xsl:text>
    <input type="radio" name="showent" value="data-ncr" checked="checked" onclick="entcheck('data-ncr')" id="entncr"/>
    <xsl:text>&#10;</xsl:text>
    <label for="entncr">Numeric Character Reference </label>
    <xsl:text>&#10;</xsl:text>
    <input type="radio" name="showent" value="data-char" onclick="entcheck('data-char')" id="entchar"/>
    <xsl:text>&#10;</xsl:text>
    <label for="entchar">Character </label>
    <xsl:text>&#10;</xsl:text>
    </p>
    <xsl:text>&#10;</xsl:text>
    <p><b>Note:</b><br/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>Your browser may be able to display Presentation MathML but not Content MathML.</xsl:text>
    <br/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>You may convert the inline Content MathML to a Presentation MathML rendering using an XSLT transfomation.</xsl:text>
    <br/>
    <xsl:text>&#10;</xsl:text>
    <input id="ctobbutton" type="button" onclick="doctop(0)" value="Convert Content MathML to Presentation MathML?"/><br/>
    <xsl:text>&#10;</xsl:text>
    <input id="ctobbuttonmj" type="button" onclick="doctopmj()" value="Convert Content MathML to Presentation MathML and display with MathJax?" />
    </p>
    <xsl:text>&#10;</xsl:text>
  </div>
  <xsl:text>&#10;</xsl:text>
  <div id="Overview_">
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="doc('Overview.xml')/html/body/node()">
      <xsl:with-param name="file" select="'Overview'" tunnel="yes"/>
    </xsl:apply-templates>
  </div>
  <xsl:for-each select="$chaps">
    <xsl:message select="."/>
    <div id="{.}_">
      <xsl:apply-templates select="doc(concat(.,'.xml'))/html/body/node()">
	<xsl:with-param name="file" select="." tunnel="yes"/>
      </xsl:apply-templates>
    </div>
  </xsl:for-each>
</body>
</html>
</xsl:template>

<xsl:template match="a[matches(@href,'^(chapter[0-9]|appendix[a-z]|Overview)\.xml#?')]" priority="3">
<a>
<xsl:copy-of select="@* except (@href,@shape)"/>
<xsl:attribute name="href" select="concat('#',replace(@href,'^([^#]*)\.xml#?','$1_'))"/>
<xsl:apply-templates/>
</a>
</xsl:template>

<xsl:template match="a[matches(@href,'^#')]" priority="2">
<xsl:param name="file" tunnel="yes"/>
<a>
<xsl:copy-of select="@* except (@href,@shape)"/>
<xsl:attribute name="href" select="concat('#',$file,'_',substring(@href,2))"/>
<xsl:apply-templates/>
</a>
</xsl:template>

<xsl:template match="a[@href]" priority="1">
<xsl:param name="file" tunnel="yes"/>
<a>
<xsl:copy-of select="@* except (@shape)"/>
<xsl:apply-templates/>
</a>
</xsl:template>


<xsl:template match="*[@id]" priority="2">
<xsl:param name="file" tunnel="yes"/>
<xsl:copy copy-namespaces="no">
<xsl:apply-templates select="@* except (@id,@name,@shape,@border)"/>
<xsl:attribute name="id" select="concat($file,'_',@id)"/>
<xsl:apply-templates/>
</xsl:copy>
</xsl:template>


<xsl:template match="table[@class='sortable']//tr">
<xsl:text>&#10;</xsl:text>
<xsl:next-match/>
</xsl:template>

<xsl:template match="table[@class='sortable']//th">
<th>
<xsl:apply-templates select="@*"/>
<xsl:text> </xsl:text>
<xsl:apply-templates/>
<xsl:text> </xsl:text>
</th>
</xsl:template>

<!-- temporary kludge to keep spec valid for testing
     once we know it is valid apart from thsi we may
     want to undo this and either extend the schema
     or document why the extended examples make it invalid
-->
     
<!--
<xsl:template match="om:*" xmlns:om="http://www.openmath.org/OpenMath" priority="5">
 <xsl:element name="mi" namespace="http://www.w3.org/1998/Math/MathML">OpenMath</xsl:element>
</xsl:template>

-->

<!-- instead just remove the namespace change -->
<!--
<xsl:template match="om:*" xmlns:om="http://www.openmath.org/OpenMath" priority="5">
 <xsl:element name="{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
  <xsl:apply-templates/>
 </xsl:element>
</xsl:template>
-->

<xsl:template match="*:annotation-xml/@encoding[.='application/openmath+xml']" priority="5">
 <xsl:attribute name="encoding" select="'MathML-Content'"/>
</xsl:template>

<xsl:template match="om:*" xmlns:om="http://www.openmath.org/OpenMath" priority="5">
 <xsl:element name="cs" namespace="http://www.w3.org/1998/Math/MathML">
  <xsl:apply-templates select="." mode="verb"/>
 </xsl:element>
</xsl:template>

<xsl:template mode="verb" match="*" xmlns:om="http://www.openmath.org/OpenMath" priority="5">
 <xsl:text>&lt;</xsl:text>
 <xsl:value-of select="local-name()"/>
 <xsl:if test="empty(../namespace::om:*)"> xmlns="http://www.openmath.org/OpenMath"</xsl:if>
 <xsl:for-each select="@*">
  <xsl:text> </xsl:text>
  <xsl:value-of select="name()"/>
  <xsl:text>="</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>"</xsl:text>
 </xsl:for-each>
 <xsl:choose>
  <xsl:when test="node()">
   <xsl:apply-templates mode="verb"/>
   <xsl:text>&lt;/</xsl:text>
   <xsl:value-of select="local-name()"/>
   <xsl:text>&gt;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
   <xsl:text>/&gt;</xsl:text>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- and same for Mathml3 and Content MathmL features-->
<!--
<xsl:template match="m:mlongdiv|m:mstack" xmlns:m="http://www.w3.org/1998/Math/MathML" priority="5">
 <xsl:element name="mi" namespace="http://www.w3.org/1998/Math/MathML">
  <xsl:value-of select="'mathml3',local-name()"/>
 </xsl:element>
</xsl:template>
<xsl:template match="m:bind|m:share|m:cs|m:cerror" xmlns:m="http://www.w3.org/1998/Math/MathML" priority="5">
 <xsl:element name="ci"  namespace="http://www.w3.org/1998/Math/MathML">
  <xsl:value-of select="'mathml3',local-name()"/>
 </xsl:element>
</xsl:template>
<xsl:template match="m:ci[@other:att]" xmlns:m="http://www.w3.org/1998/Math/MathML" xmlns:other="http://example.com" priority="5">
 <xsl:element name="ci"  namespace="http://www.w3.org/1998/Math/MathML">
  <xsl:apply-templates/>
 </xsl:element>
</xsl:template>

<xsl:template match="m:*/@cd|
m:*/@encoding[.=('MathML-Presentation','application/openmath+xml','MathML-Content')]|
m:*/@linebreak|m:*/@linebreakstyle|
m:*/@indentalignlast|m:*/@indenttarget|m:*/@indentalign"
 xmlns:m="http://www.w3.org/1998/Math/MathML"/>
-->

<xsl:template match="m:ci[@other:att]" xmlns:m="http://www.w3.org/1998/Math/MathML" xmlns:other="http://example.com" priority="5">
 <xsl:element name="ci" namespace="http://www.w3.org/1998/Math/MathML">
  <xsl:attribute name="other" select="concat('att=''',@other:att,'''')" />
  <xsl:apply-templates/>
 </xsl:element>
</xsl:template>

<xsl:template match="pre/span[@title]">
  <span title="&amp;{@title};" data-ncr="{.}" data-char="{replace(.,'&amp;','&#1001;')}">
    <xsl:value-of select="."/>
  </span>
</xsl:template>

<xsl:template match="table[not(tr[2])][tr[
		     td/pre/@class='mathml' and td/@class='mathml-render']]">
 <div class="mathml-example-render">
  <div class="mathml-example-render-1">
   <xsl:apply-templates select="tr/td[1]/pre"/>
  </div>
  <span class="mathml-example-render-2 mathml-render">
   <xsl:apply-templates select="tr/td[2]/*"/>
  </span>
 </div>
</xsl:template>

<xsl:template match="
		     h1[a[@id][not(node())]]|
		     h2[a[@id][not(node())]]|
		     h3[a[@id][not(node())]]|
		     h4[a[@id][not(node())]]|
		     h5[a[@id][not(node())]]|
		     h6[a[@id][not(node())]]
		     ">
 <xsl:param name="file" tunnel="yes"/>
 <xsl:copy copy-namespaces="no">
  <xsl:attribute name="onmouseover">showlink(this)</xsl:attribute>
  <xsl:attribute name="onmouseout">hidelink(this)</xsl:attribute>
  <xsl:attribute name="id" select="concat($file,'_',a[1]/@id)"/>
  <a class="selflink" href="#{$file}_{a[1]/@id}"></a>
  <xsl:apply-templates select="node() except a[1]"/>
 </xsl:copy>
</xsl:template>

<!-- trim arabic example comments-->
<xsl:template match="span[@class='uname']
		     [contains(.,'ARABIC-INDIC DIGIT')]
		     [preceding-sibling::node()[2][@class='uname'][contains(.,'ARABIC')]]
		     "/>
 
 
</xsl:stylesheet>
