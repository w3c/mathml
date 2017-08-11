<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
<xsl:output method="text"/>

<xsl:key name="id" match="*[@id]" use="@id"/>

<xsl:template match="/div1[@id='contm']">
<xsl:call-template name="content-preliminaries"/>
<xsl:for-each-group select=".//table[not(@diff='del')][@role='syntax'][not(ancestor::*/@id=('contm_bind','contm_piecewise','contm_bvar','contm_semantics','contm_cn','contm_ci','contm_csymbol','contm_apply','contm_share','contm_cerror','contm_cbytes','contm_cs','contm_domainofapplication_qualifier','contm_deprecated','contm_degree'))]" group-by="tbody/tr[th='Class']/td[1]/(intref|kw)">
  <xsl:text>&#10;&#10;</xsl:text>
  <xsl:value-of select="current-grouping-key()"/>
 <xsl:text>.class = </xsl:text>
  <xsl:variable name="el" select="if(current-grouping-key()='unary-elementary')
then
(:special case so mathml3 2nd edn schema same aas 1st edn:)
('sin','cos','tan','sec','csc','cot','sinh','cosh','tanh','sech','csch','coth','arcsin','arccos','arctan','arccosh','arccot','arccoth','arccsc','arccsch','arcsec','arcsech','arcsinh','arctanh')
else
current-group()/distinct-values((
(thead/tr[1]/th[1]/el,
../head/el)[1],
..[head[not(el)]]/table[not(@diff='del')][2]//el
  ))"/>
  <xsl:if test="empty($el)">
    <xsl:message select="'no element name',."/>
  </xsl:if>
  <xsl:variable name="t" select="tbody"/>
  <xsl:value-of select="for $e in $el return 
    if($e=('list')) then '\list' else $e" separator=" | "/>
  <xsl:text>&#10;ContExp |= </xsl:text>
  <xsl:value-of select="current-grouping-key()"/>
<xsl:text>.class&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>
  <xsl:for-each select="$el[not(.=('minus','root') and current-grouping-key()='unary-arith')]"> <!--.class-->
    <xsl:text>&#10;</xsl:text>
    <xsl:if test=".=('list')">\</xsl:if>
    <xsl:value-of select="."/>
    <xsl:text> = element </xsl:text>
    <xsl:if test=".=('list')">\</xsl:if>
    <xsl:value-of select="."/>
    <xsl:text> { </xsl:text>
    <xsl:choose>
      <xsl:when test=".='tendsto'">CommonAtt, DefEncAtt, type?, </xsl:when>
      <xsl:when test=".='list'">CommonAtt, DefEncAtt, order?, BvarQ*, DomainQ*, </xsl:when>
      <xsl:when test=".='set'">CommonAtt, DefEncAtt, type?, BvarQ*, DomainQ*, </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$t/tr[th='Attributes']/td[last()]"/>
	<xsl:if test="normalize-space($t/tr[th='Attributes']/td[last()])">, </xsl:if>
      </xsl:otherwise>

    </xsl:choose>
    <xsl:choose>
      <xsl:when test="current-grouping-key()='nary-constructor'">
	<xsl:value-of select="$t/tr[th='Qualifiers']/td[last()]/normalize-space(.)"/>
	<xsl:text>, </xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$t/tr[th='Content']/td[last()]/(if(.='Empty')then 'empty' else replace(normalize-space(.),'^.*\|.*$','($0)'))"/>
    <xsl:text>}</xsl:text>
  </xsl:for-each>
    

</xsl:for-each-group>
</xsl:template>

<xsl:template name="content-preliminaries">
#     This is the Mathematical Markup Language (MathML) 3.0, an XML
#     application for describing mathematical notation and capturing
#     both its structure and content.
#
#     Copyright 1998-2014 W3C (MIT, ERCIM, Keio, Beihang)
# 
#     Use and distribution of this code are permitted under the terms
#     W3C Software Notice and License
#     http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231

include "mathml3-strict-content.rnc"{
  cn.content = (text | mglyph | sep | PresentationExpression)* 
  cn.attributes = CommonAtt, DefEncAtt, attribute type {text}?, base?

  ci.attributes = CommonAtt, DefEncAtt, ci.type?
  ci.type = attribute type {text}
  ci.content = (text | mglyph | PresentationExpression)* 

  csymbol.attributes = CommonAtt, DefEncAtt, attribute type {text}?,cd?
  csymbol.content = (text | mglyph | PresentationExpression)* 

  bvar = element bvar {CommonAtt, ((ci | semantics-ci) &amp; degree?)}

  cbytes.attributes = CommonAtt, DefEncAtt

  cs.attributes = CommonAtt, DefEncAtt

  apply.content = ContExp+ | (ContExp, BvarQ, Qualifier*, ContExp*)

  bind.content = apply.content
}

base = attribute base {text}


sep = element sep {empty}
PresentationExpression |= notAllowed


DomainQ = (domainofapplication|condition|interval|(lowlimit,uplimit?))*
domainofapplication = element domainofapplication {ContExp}
condition = element condition {ContExp}
uplimit = element uplimit {ContExp}
lowlimit = element lowlimit {ContExp}

Qualifier = DomainQ|degree|momentabout|logbase
degree = element degree {ContExp}
momentabout = element momentabout {ContExp}
logbase = element logbase {ContExp}

type = attribute type {text}
order = attribute order {"numeric" | "lexicographic"}
closure = attribute closure {text}


ContExp |= piecewise


piecewise = element piecewise {CommonAtt, DefEncAtt,(piece* &amp; otherwise?)}

piece = element piece {CommonAtt, DefEncAtt, ContExp, ContExp}

otherwise = element otherwise {CommonAtt, DefEncAtt, ContExp}


DeprecatedContExp = reln | fn | declare
ContExp |= DeprecatedContExp

reln = element reln {ContExp*}
fn = element fn {ContExp}
declare = element declare {attribute type {xsd:string}?,
                           attribute scope {xsd:string}?,
                           attribute nargs {xsd:nonNegativeInteger}?,
                           attribute occurrence {"prefix"|"infix"|"function-model"}?,
                           DefEncAtt, 
                           ContExp+}
</xsl:template>


<xsl:template name="attribute-table">
<xsl:param name="e"/>
<xsl:param name="n" select="1"/>
<xsl:param name="omit" select="()"/>
 <xsl:variable name="a" select="$r/key('id',concat('presm_',$e))/descendant::table[@role='attributes'][$n]"/>
 <xsl:for-each select="$a/tbody/tr[td[1]/@role='attname']
		                  [not($e='mglyph' and td[1]='fontfamily')]
				  [not(normalize-space(td[1])=$omit)]">
   <xsl:if test="position()!=1">,</xsl:if>
   <xsl:text>&#10;  </xsl:text>
   <att e="{$e}">
     <xsl:text>attribute </xsl:text>
   <n><xsl:value-of select="normalize-space(td[1])"/></n>
   <xsl:text> {</xsl:text>
   <xsl:choose>
     <xsl:when test="false()"/>
     <xsl:when test="(normalize-space(td[1])=('columnwidth') and $e='mtable')
                   or normalize-space(td[1])=('crossout','alignmentscope', 'framespacing','columnspacing','rowspacing')
                  ">
       <xsl:text>list {</xsl:text>
       <xsl:value-of select="normalize-space(td[2])"/>
       <xsl:text>}</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('separators') and $e='mfenced'">
       <xsl:text>text</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('columnlines', 'rowlines') and $e='mtable'">
       <xsl:text>list {linestyle +}</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('src')">
       <xsl:text>xsd:anyURI</xsl:text>
     </xsl:when>     
     <xsl:when test="normalize-space(td[1])=('scriptlevel')">
       <xsl:text>integer</xsl:text>
     </xsl:when>     
     <xsl:when test="normalize-space(td[2])=('string')">
       <xsl:text>text</xsl:text>
     </xsl:when>     
     <xsl:when test="normalize-space(td[1])=('linebreak') and $e='mspace'">
       <xsl:value-of select="normalize-space(td[2])"/>
       <xsl:text> | "indentingnewline"</xsl:text>
     </xsl:when> 
     <xsl:otherwise>
       <xsl:value-of select="td[2]/replace(normalize-space(.),
			     '\( &quot;\+&quot; \| &quot;-&quot; \)\?, unsigned-',
			     '')"/>
     </xsl:otherwise>
   </xsl:choose>
   <xsl:text>}</xsl:text>
   </att>
   <xsl:text>?</xsl:text>
 </xsl:for-each>
</xsl:template>

<xsl:variable name="r" select="/"/>

<xsl:template match="/div1[@id='presm']">
<xsl:variable name="pres">
<xsl:call-template name="presentation-preliminaries"/>

<xsl:text>&#10;&#10;TokenExpression = mi|mn|mo|mtext|mspace|ms</xsl:text>

<xsl:text>&#10;&#10;token.content = mglyph|malignmark|text</xsl:text>

<xsl:for-each select="'mi','mn','mo','mtext','mspace','ms'">
<xsl:text>&#10;&#10;</xsl:text>
<xsl:value-of select="."/>
<xsl:text> = element </xsl:text>
<xsl:value-of select="."/>
<xsl:text> {</xsl:text>
<xsl:value-of select="."/>
<xsl:text>.attributes, </xsl:text>
<xsl:choose>
  <xsl:when test=".='mspace'">empty</xsl:when>
  <xsl:otherwise>token.content*</xsl:otherwise>
</xsl:choose>
<xsl:text>}&#10;</xsl:text>
<xsl:value-of select="."/>
<xsl:text>.attributes = &#10;</xsl:text>
<xsl:text>  CommonAtt,&#10;</xsl:text>
<xsl:text>  CommonPresAtt,&#10;</xsl:text>
<xsl:text>  TokenAtt</xsl:text>
<xsl:variable name="a">
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="."/>
</xsl:call-template>
</xsl:variable>
<xsl:if test="string($a) and not(.='mi')">
  <xsl:text>,</xsl:text>
  <xsl:copy-of select="$a"/>
</xsl:if>
<xsl:if test=".='mo'">
  <xsl:text>,</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="."/>
  <xsl:with-param name="n" select="2"/>
</xsl:call-template>
  <xsl:text>,</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="."/>
  <xsl:with-param name="n" select="3"/>
</xsl:call-template>
</xsl:if>
<xsl:if test=".='mspace'">
  <xsl:text>,</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'lbindent_attrs'"/>
  <xsl:with-param name="n" select="1"/>
</xsl:call-template>
</xsl:if>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>



<xsl:text>&#10;&#10;mglyph = element mglyph {mglyph.attributes,mglyph.deprecatedattributes,empty}&#10;</xsl:text>
<xsl:text>mglyph.attributes = &#10;  CommonAtt,</xsl:text>
<xsl:text>  CommonPresAtt,</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'mglyph'"/>
</xsl:call-template>
<xsl:text>&#10;</xsl:text>
<xsl:text>mglyph.deprecatedattributes =</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'mglyph'"/>
  <xsl:with-param name="n" select="2"/>
</xsl:call-template>
 <xsl:text>,</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'commatt'"/>
  <xsl:with-param name="omit" select="'dir'"/>
</xsl:call-template>
 <xsl:text>,&#10;  DeprecatedTokenAtt</xsl:text>

<xsl:text>&#10;&#10;msline = element msline {msline.attributes,empty}&#10;</xsl:text>
<xsl:text>msline.attributes = &#10;  CommonAtt,</xsl:text>
<xsl:text>  CommonPresAtt,</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'msline'"/>
</xsl:call-template>
<xsl:text>&#10;</xsl:text>

<xsl:text>
none = element none {none.attributes,empty}
none.attributes = 
  CommonAtt,
  CommonPresAtt

mprescripts = element mprescripts {mprescripts.attributes,empty}
mprescripts.attributes = 
  CommonAtt,
  CommonPresAtt
</xsl:text>


<xsl:text>&#10;&#10;CommonPresAtt = </xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'presatt'"/>
</xsl:call-template>

<xsl:text>&#10;&#10;TokenAtt = </xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'commatt'"/>
</xsl:call-template>
 <xsl:text>,&#10;  DeprecatedTokenAtt</xsl:text>

<xsl:text>&#10;&#10;DeprecatedTokenAtt = </xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'commatt'"/>
  <xsl:with-param name="n" select="2"/>
</xsl:call-template>


<xsl:text>&#10;&#10;MalignExpression = maligngroup|malignmark</xsl:text>
<xsl:for-each select="'malignmark','maligngroup'">
<xsl:text>&#10;&#10;</xsl:text>
<xsl:value-of select="."/>
<xsl:text> = element </xsl:text>
<xsl:value-of select="."/>
<xsl:text> {</xsl:text>
<xsl:value-of select="."/>
<xsl:text>.attributes, empty}</xsl:text>
<xsl:text>&#10;</xsl:text>
<xsl:value-of select="."/>
<xsl:text>.attributes = &#10;  CommonAtt, CommonPresAtt,</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="'malign'"/>
  <xsl:with-param name="n" select="position()"/>
</xsl:call-template>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>


<xsl:text>&#10;&#10;</xsl:text>
 <xsl:value-of select="replace(string-join((
  'PresentationExpression = TokenExpression|MalignExpression',
  key('id','presm_table-reqarg')/tbody/tr/td[1]/(intref|kw)/el[not(.=('math','mtr','mlabeledtr','mtd','msgroup','mscarry','mscarries','msrow'))])
    ,'|'),'.{50}\|','$0&#10;                         ')"/>
<xsl:text>&#10;&#10;</xsl:text>
<xsl:for-each select="key('id','presm_table-reqarg')/tbody/tr/td[1][(intref|kw)/el[not(.='math')]]"><xsl:variable name="e" select="(intref|kw)/el"/>
<xsl:text>&#10;&#10;</xsl:text>
<xsl:value-of select="$e"/>
<xsl:text> = element </xsl:text>
<xsl:value-of select="$e"/>
<xsl:text> {</xsl:text>
<xsl:value-of select="$e"/>
<xsl:text>.attributes, </xsl:text>
<xsl:variable name="c" select="normalize-space(../td[2])"/>
 <xsl:choose>
   <xsl:when test="$e=('mstack','msgroup')">MstackExpression*</xsl:when>
   <xsl:when test="$e=('mlongdiv')">MstackExpression,MstackExpression,MstackExpression+</xsl:when>
   <xsl:when test="$e='mmultiscripts'">MathExpression,MultiScriptExpression*,(mprescripts,MultiScriptExpression*)?</xsl:when>
   <xsl:when test="$e='mtable'">TableRowExpression*</xsl:when>
   <xsl:when test="$e=('mtr')">TableCellExpression*</xsl:when>
   <xsl:when test="$e=('mlabeledtr')">TableCellExpression+</xsl:when>
   <xsl:when test="$e=('msrow','mscarry')">MsrowExpression*</xsl:when>
   <xsl:when test="$e=('mscarries')">(MsrowExpression|mscarry)*</xsl:when>
   <xsl:when test="$e=''">TableCellExpression*</xsl:when>
   <xsl:when test="$c='1'">MathExpression</xsl:when>
   <xsl:when test="$c='2'">MathExpression, MathExpression</xsl:when>
   <xsl:when test="$c='3'">MathExpression, MathExpression, MathExpression</xsl:when>
   <xsl:when test="$c='1*'">ImpliedMrow</xsl:when>
   <xsl:when test="$c='0 or more'">MathExpression*</xsl:when>
   <xsl:when test="$c='1 or more'">MathExpression+</xsl:when>
   <xsl:otherwise>
     <xsl:message select="'unknown content', $c"/>
   </xsl:otherwise>
 </xsl:choose>
<xsl:text>}&#10;</xsl:text>
<xsl:value-of select="$e"/>
<xsl:text>.attributes = </xsl:text>
 <xsl:choose>
 <xsl:when  test="$e=('mlongdiv')">&#10;  msgroup.attributes</xsl:when>
 <xsl:when  test="$e=('mlabeledtr')">&#10;  mtr.attributes</xsl:when>
 <xsl:when  test="$e=('mmultiscripts')">&#10;  msubsup.attributes</xsl:when>
 <xsl:when  test="$e=('mstyle')">
 <xsl:text>&#10;  CommonAtt, CommonPresAtt,&#10;</xsl:text>
 <xsl:text>  mstyle.specificattributes,&#10;</xsl:text>
 <xsl:text>  mstyle.generalattributes,&#10;</xsl:text>
 <xsl:text>  mstyle.deprecatedattributes&#10;</xsl:text>
 <xsl:text>&#10;mstyle.specificattributes =</xsl:text>
</xsl:when>
 <xsl:otherwise>&#10;  CommonAtt, CommonPresAtt</xsl:otherwise>
 </xsl:choose>
 <xsl:variable name="a" select="key('id',concat('presm_',$e))/descendant::table[@role='attributes'][1]"/>
 <xsl:for-each select="$a/tbody/tr[td[1]/@role='attname']">
   <xsl:if test="position()!=1 or $e!=('mstyle')">,</xsl:if>
   <xsl:text>&#10;  </xsl:text>
   <att e="{$e}">
     <xsl:text>attribute </xsl:text>
   <n><xsl:value-of select="normalize-space(td[1])"/></n>
   <xsl:text> {</xsl:text>
   <xsl:choose>
     <xsl:when test="normalize-space(td[1])='notation'">
       <xsl:text>text</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('height','depth','voffset','width','lspace') and $e='mpadded'">
       <xsl:text>mpadded-length</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('align') and $e=('mtable','mstack')">
       <xsl:text>xsd:string {&#10;    </xsl:text>
       <xsl:text>pattern ='\s*(top|bottom|center|baseline|axis)(\s+-?[0-9]+)?\s*'}</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('rowalign') and $e='mtable'">
       <xsl:text>list {verticalalign+} </xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('columnalign') and $e=('mtable','mtr')">
       <xsl:text>list {columnalignstyle+} </xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('columnalign') and $e='mtd'">
       <xsl:text>columnalignstyle</xsl:text>
     </xsl:when>
     <xsl:when test="(normalize-space(td[1])=('columnwidth') and $e='mtable')
                   or normalize-space(td[1])=('crossout','alignmentscope', 'framespacing','columnspacing','rowspacing')
                  ">
       <xsl:text>list {</xsl:text>
       <xsl:value-of select="normalize-space(td[2])"/>
       <xsl:text>}</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('separators') and $e='mfenced'">
       <xsl:text>text</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('frame') and $e='mtable'">
       <xsl:text>linestyle</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('columnlines', 'rowlines') and $e='mtable'">
       <xsl:text>list {linestyle +}</xsl:text>
     </xsl:when>
     <xsl:when test="normalize-space(td[1])=('src')">
       <xsl:text>xsd:anyURI</xsl:text>
     </xsl:when>     
     <xsl:when test="normalize-space(td[1])=('scriptlevel')">
       <xsl:text>integer</xsl:text>
     </xsl:when>     
     <xsl:when test="normalize-space(td[2])=('string')">
       <xsl:text>text</xsl:text>
     </xsl:when>
     <xsl:otherwise>
       <xsl:value-of select="td[2]/replace(normalize-space(.),
			     '\( &quot;\+&quot; \| &quot;-&quot; \)\?, unsigned-',
			     '')"/>
     </xsl:otherwise>
   </xsl:choose>
   <xsl:text>}</xsl:text>
   </att>
      <xsl:if test="not($e='maction' and normalize-space(td[1])='actiontype')"><xsl:text>?</xsl:text></xsl:if>
 </xsl:for-each>

<xsl:if test="$e='mstyle'">

mstyle.generalattributes =<mstyle/>

mstyle.deprecatedattributes =
  DeprecatedTokenAtt<xsl:text>,</xsl:text>
<xsl:call-template name="attribute-table">
  <xsl:with-param name="e" select="$e"/>
  <xsl:with-param name="n" select="2"/>
</xsl:call-template>

math.attributes &amp;= CommonPresAtt
math.attributes &amp;= mstyle.specificattributes
math.attributes &amp;= mstyle.generalattributes

</xsl:if>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</xsl:variable>
<xsl:value-of select="string-join($pres/mstyle/preceding-sibling::node(),'')"/>
<xsl:for-each-group select="$pres/att[not(n=(
'scriptlevel','displaystyle','scriptsizemultiplier','scriptminsize','infixlinebreakstyle','decimalseparator','decimalpoint',
'src',
'actiontype',
'mathcolor','mathbackground',
'alt','index',
'voffset',
'fontfamily','fontweight','fontstyle','fontsize','color','background'
))]
[not(ends-with(n,'mathspace'))]
" group-by="n">
<xsl:sort select="."/>
<xsl:text>&#10;  </xsl:text>
<xsl:choose>
  <xsl:when  test="n='groupalign'">
    <xsl:value-of select="current-group()[@e='mtable']"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="."/>
  </xsl:otherwise>
</xsl:choose>
<xsl:text>?</xsl:text>
<xsl:if test="position()!=last()">,</xsl:if>
</xsl:for-each-group>
<xsl:value-of select="string-join($pres/mstyle/following-sibling::node(),'')"/>
</xsl:template>

<xsl:template name="presentation-preliminaries">
#     This is the Mathematical Markup Language (MathML) 3.0, an XML
#     application for describing mathematical notation and capturing
#     both its structure and content.
#
#     Copyright 1998-2014 W3C (MIT, ERCIM, Keio, Beihang)
# 
#     Use and distribution of this code are permitted under the terms
#     W3C Software Notice and License
#     http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231

default namespace m = "http://www.w3.org/1998/Math/MathML"

MathExpression |= PresentationExpression

ImpliedMrow = MathExpression*

TableRowExpression = mtr|mlabeledtr

TableCellExpression = mtd

MstackExpression = MathExpression|mscarries|msline|msrow|msgroup

MsrowExpression = MathExpression|none

MultiScriptExpression = (MathExpression|none),(MathExpression|none)

mpadded-length = xsd:string {
  pattern = '\s*([\+\-]?[0-9]*([0-9]\.?|\.[0-9])[0-9]*\s*((%?\s*(height|depth|width)?)|e[mx]|in|cm|mm|p[xtc]|((negative)?((very){0,2}thi(n|ck)|medium)mathspace))?)\s*' }

linestyle = "none" | "solid" | "dashed"

verticalalign =
      "top" |
      "bottom" |
      "center" |
      "baseline" |
      "axis"

columnalignstyle = "left" | "center" | "right"

notationstyle =
     "longdiv" |
     "actuarial" |
     "radical" |
     "box" |
     "roundedbox" |
     "circle" |
     "left" |
     "right" |
     "top" |
     "bottom" |
     "updiagonalstrike" |
     "downdiagonalstrike" |
     "verticalstrike" |
     "horizontalstrike" |
     "madruwb"

idref = text
unsigned-integer = xsd:unsignedLong
integer = xsd:integer
number = xsd:decimal

character = xsd:string {
  pattern = '\s*\S\s*'}

color =  xsd:string {
  pattern = '\s*((#[0-9a-fA-F]{3}([0-9a-fA-F]{3})?)|[aA][qQ][uU][aA]|[bB][lL][aA][cC][kK]|[bB][lL][uU][eE]|[fF][uU][cC][hH][sS][iI][aA]|[gG][rR][aA][yY]|[gG][rR][eE][eE][nN]|[lL][iI][mM][eE]|[mM][aA][rR][oO][oO][nN]|[nN][aA][vV][yY]|[oO][lL][iI][vV][eE]|[pP][uU][rR][pP][lL][eE]|[rR][eE][dD]|[sS][iI][lL][vV][eE][rR]|[tT][eE][aA][lL]|[wW][hH][iI][tT][eE]|[yY][eE][lL][lL][oO][wW])\s*'}


group-alignment = "left" | "center" | "right" | "decimalpoint"
group-alignment-list = list {group-alignment+}
group-alignment-list-list = xsd:string {
  pattern = '(\s*\{\s*(left|center|right|decimalpoint)(\s+(left|center|right|decimalpoint))*\})*\s*' }
positive-integer = xsd:positiveInteger
</xsl:template>



</xsl:stylesheet>

<!--
 pattern = '(#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]([0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])?)|aqua|black|blue|fuchsia|gray|green|lime|maroon|navy|olive|purple|red|silver|teal|white|yellow'}

-->
