<?xml version="1.0" encoding="UTF-8"?>
<!--
    Document   : formular.xsl
    Created on : 21. Februar 2016, 18:30
    Author     : juergens
    Description: Transform Schema in Form.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                xml:lang="eng">

  <!-- xmlns:fn="http://www.w3.org/2005/xpath-functions" -->

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <!--xsl:output
          method="xml"
          encoding="ISO-8859-1"
          standalone="yes"
          version="1.0"
          doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
          doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
          indent="yes"/ -->

  <xsl:variable name="ns">xs</xsl:variable> <!-- TODO get NS from source -->

  <xsl:variable name="vLower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="vUpper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:variable name="form-id" select="generate-id()"/>

  <!--<xsl:function name="capitalize">-->
  <!--<xsl:param name="text"/>-->
  <!--<xsl:value-of select="concat(translate(substring($text,1,1), $vLower, $vUpper),substring($text, 2))"/>-->
  <!--</xsl:function>-->

  <xsl:template name="capitalize" match="text()">
    <xsl:value-of select="concat(translate(substring(.,1,1), $vLower, $vUpper),substring(., 2))"/>
  </xsl:template>

  <xsl:attribute-set name="meta-attributes">
    <xsl:attribute name="content">dateTime</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="form-attributes">
    <xsl:attribute name="id">formular</xsl:attribute>
    <!--<xsl:attribute name="onSubmit">console.log(document.getElementById('formular').value)</xsl:attribute>-->
  </xsl:attribute-set>

  <!--     -->
  <xsl:template match="/xs:schema">
    <!-- <!DOCTYPE html> -->

    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:text>href="processing.css" type="text/css"</xsl:text>
    </xsl:processing-instruction>
    <html lang="en">
      <head>
        <xsl:element name="meta"><xsl:attribute name="charset">UTF-8</xsl:attribute></xsl:element>
        <!--<meta charset="UTF-8"/>-->
        <title><xsl:value-of select="string(@targetNamespace)"/></title>

        <xsl:element name="meta" use-attribute-sets="meta-attributes"/>
        <style>
          .element {
            background-color: lightblue;
          }
          .sequence {
            background-color: rgb(255,0,0);
          }

        </style>
      </head>
      <body>
        <xsl:element name="form" use-attribute-sets="form-attributes">
          <xsl:attribute name="id">
            <xsl:value-of select="$form-id"/>
          </xsl:attribute>

          <xsl:for-each select="xs:element">
            <xsl:apply-templates select="current()" />
          </xsl:for-each>
        </xsl:element>
      </body>
    </html>
  </xsl:template>

  <!-- <label for="...">...</label> -->
  <xsl:template name="label">
    <xsl:param name="for-id"/>
    <xsl:param name="text"/>

    <xsl:element name="label">
      <xsl:attribute name="for">
        <xsl:value-of select="$for-id"/>
      </xsl:attribute>
      <xsl:value-of select="concat(translate(substring($text,1,1), $vLower, $vUpper),substring($text, 2))"/>
    </xsl:element>
  </xsl:template>

  <!-- text, password, datetime, datetime-local, date, month, time, week, number, email, url, search, tel, and color-->

  <xsl:template name="formType">
    <xsl:param name="xsdType"/>

    <xsl:choose>
      <xsl:when test="$xsdType='xs:integer'">number</xsl:when>
      <xsl:when test="$xsdType='xs:string'">text</xsl:when>
      <xsl:when test="$xsdType='xs:date'">text</xsl:when>
      <xsl:when test="$xsdType='xs:boolean'">checkbox</xsl:when>
      <xsl:when test="$xsdType='xs:anyURI'">url</xsl:when>
      <xsl:when test="$xsdType='xs:duration'">text</xsl:when>
      <xsl:otherwise>
        <xsl:message><xsl:value-of select="$xsdType"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- <input type="..." class="form-control" id="..." placeholder="...">  -->
  <xsl:template name="input">
    <xsl:param name="input-id"/>
    <xsl:param name="input-type"/>
    <xsl:param name="placeholder"/>

    <xsl:element name="input">
      <xsl:attribute name="type">
        <xsl:call-template name="formType">

          <xsl:with-param name="xsdType">
            <xsl:value-of select="$input-type"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="class">form-control</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="$input-id"/>
      </xsl:attribute>
      <xsl:attribute name="placeholder">
        <xsl:value-of select="$placeholder"/>
      </xsl:attribute>
    </xsl:element>
    <xsl:text>
    </xsl:text>
  </xsl:template>

  <xsl:template match="xs:element" mode="getId">
    <xsl:if test="not(@id)"><xsl:call-template name="name-path"/></xsl:if>
    <xsl:value-of select="@id"/>
  </xsl:template>

  <!-- Venetian Blind (Venezianischer Spiegel) -->
  <xsl:template match="xs:element[@type and not(starts-with(@type, concat($ns,':'))) and not(@ref)]">
    <xsl:param name="input-id"><xsl:apply-templates select="." mode="getId"/></xsl:param>

    <xsl:message>
      <xsl:value-of select="$input-id"/>
    </xsl:message>

    <xsl:if test="not(@name)"><xsl:message>missing name in <xsl:copy-of select="current()"/></xsl:message></xsl:if>
    <xsl:comment>Venetian Blind (type='<xsl:value-of select="@type"/>',name='<xsl:value-of select="@name"/>)</xsl:comment>

    <xsl:variable name="typeName" select="@type"/>

    <xsl:apply-templates select="//xs:simpleType[@name=$typeName] | //xs:complexType[@name=$typeName]">
      <xsl:with-param name="input-id" select="$input-id"/>
      <xsl:with-param name="input-name" select="@name"/>
      <xsl:with-param name="legendText" select="@name"/>
    </xsl:apply-templates>

  </xsl:template>

  <!-- EXPERIMENTAL -->
  <xsl:template match="*[namespace::*[name() = substring-before(../@type, ':') and . = 'http://www.w3.org/2001/XMLSchema']]">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="*[@id]" mode="experimental">
      <xsl:message>*[name() = 'id']<xsl:value-of select="@id"/></xsl:message>
      <xsl:copy-of select="." />
      <xsl:apply-templates/>
  </xsl:template>

  <!-- Primitive/build-in Types -->
  <xsl:template match="xs:element[substring-before(@type,':') = $ns]">
    <xsl:param name="input-id"><xsl:apply-templates select="." mode="getId"/></xsl:param>

    <xsl:if test="not(@name)"><xsl:message>missing name in <xsl:copy-of select="current()"/></xsl:message></xsl:if>
    <xsl:comment>Primitive Type (type='<xsl:value-of select="@type"/>',name='<xsl:value-of select="@name"/>')</xsl:comment>

    <xsl:variable name="typeName"><xsl:value-of select="substring-after(@type,':')"/></xsl:variable>

    <xsl:variable name="xmlSchema" select="document('../../main/resources/XMLSchema.xsd')/xs:schema"/>

    <!--<xsl:variable name="simpleTypeString"><xsl:value-of select="$xmlSchema/xs:simpleType[@name=$typeName]/@id"/></xsl:variable>-->
    <!--<xsl:message><xsl:value-of select="$simpleTypeString"/></xsl:message>-->

    <xsl:message>$typeName:'<xsl:value-of select="$typeName"/>'</xsl:message>


    <xsl:apply-templates select="$xmlSchema/xs:simpleType[@name=$typeName]" />

    <!--xsl:apply-templates select="//xs:simpleType[@name=$typeName]">
      <xsl:with-param name="input-id" select="$input-id"/>
      <xsl:with-param name="id" select="$input-id"/>
      <xsl:with-param name="input-name" select="@name"/>
    </xsl:apply-templates-->

  </xsl:template>

  <!-- Russian Doll (Russische Matroschka) -->
  <xsl:template match="xs:element[not(@type) and not(@ref)]">
    <xsl:param name="input-id"><xsl:apply-templates select="." mode="getId"/></xsl:param>

    <xsl:if test="not(@name)"><xsl:message>missing name in <xsl:copy-of select="current()"/></xsl:message></xsl:if>
    <xsl:comment>Russian Doll (name='<xsl:value-of select="@name"/>')</xsl:comment>

    <xsl:variable name="name">
      <xsl:value-of select="concat(translate(substring(@name,1,1), $vLower, $vUpper),substring(@name, 2))"/>
    </xsl:variable>

    <xsl:apply-templates select="child::node()">
      <xsl:with-param name="input-name" select="$name"/>
      <xsl:with-param name="legendText">
        <xsl:value-of select="concat(translate(substring(@name,1,1), $vLower, $vUpper),substring(@name, 2))"/>
      </xsl:with-param>
    </xsl:apply-templates>

  </xsl:template>

  <!-- Salami Slice (Salamischeiben) -->
  <xsl:template match="xs:element[@ref and not(@type)]">
    <xsl:param name="input-id"><xsl:apply-templates select="." mode="getId"/></xsl:param>

    <xsl:comment>Salami Slice (ref='<xsl:value-of select="@ref"/>')</xsl:comment>

    <xsl:if test="@name"><xsl:message>name in <xsl:copy-of select="current()"/></xsl:message></xsl:if>

    <xsl:comment>ref_<xsl:call-template name="name-path"/></xsl:comment>

    <xsl:variable name="current" select="."/>
    <xsl:apply-templates select="//xs:element[@name=$current/@ref]">
      <xsl:with-param name="input-id">ref_<xsl:call-template name="name-path"/></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <!--
  <all
          id=ID
          maxOccurs=1
          minOccurs=0|1
          any attributes
  >
  (annotation?,element*)
  </all>
   -->
  <xsl:template match="xs:all">
    <xsl:apply-templates select="xs:annotation"/>
    <xsl:apply-templates select="xs:element"/>
  </xsl:template>

  <!--
  The any element enables the author to extend the XML document with elements not specified by the schema.

    <any
    id=ID
    maxOccurs=nonNegativeInteger|unbounded
    minOccurs=nonNegativeInteger
    namespace=namespace
    processContents=lax|skip|strict
    any attributes
    >

    (annotation?)

    </any>
   -->
  <xsl:template match="xs:any">
    <xsl:message><xsl:copy-of select="current()"/></xsl:message>
  </xsl:template>

  <!--
  The anyAttribute element enables the author to extend the XML document with attributes not specified by the schema.

<anyAttribute
id=ID
namespace=namespace
processContents=lax|skip|strict
any attributes
>

(annotation?)

</anyAttribute>

   -->
  <xsl:template match="xs:anyAttribute">
    <xsl:message><xsl:copy-of select="current()"/></xsl:message>
  </xsl:template>

  <!--
  The complexContent element defines extensions or restrictions on a complex type that contains mixed content or elements only.

<complexContent
id=ID
mixed=true|false
any attributes
>

(annotation?,(restriction|extension))

</complexContent>
   -->
  <xsl:template match="xs:complexContent">
    <xsl:message><xsl:copy-of select="current()"/></xsl:message>
    <xsl:apply-templates select="xs:annotation"/>
    <xsl:apply-templates select="xs:restriction | xs:extension"/>
  </xsl:template>

  <!--
  The simpleContent element contains extensions or restrictions on a text-only complex type or on a simple type as content and contains no elements.

<simpleContent
id=ID
any attributes
>

(annotation?,(restriction|extension))

</simpleContent>
   -->
  <xsl:template match="xs:simpleContent">
    <xsl:message><xsl:copy-of select="current()"/></xsl:message>
    <xsl:apply-templates select="xs:annotation"/>
    <xsl:apply-templates select="xs:restriction | xs:extension"/>
  </xsl:template>

  <!-- (annotation?,(simpleType?,(minExclusive|minInclusive|maxExclusive|maxInclusive|totalDigits|fractionDigits|length|minLength|maxLength|enumeration|whiteSpace|pattern)*)?,((attribute|attributeGroup)*,anyAttribute?))-->
  <xsl:template match="xs:simpleContent/xs:restriction">
  </xsl:template>

  <!-- (annotation?,(group|all|choice|sequence)?,((attribute|attributeGroup)*,anyAttribute?)) -->
  <xsl:template match="xs:complexContent/xs:restriction">
  </xsl:template>

  <!--
  <xs:simpleType name="integer" id="integer">
      <xs:annotation>
          <xs:documentation
                  source="http://www.w3.org/TR/xmlschema-2/#integer"/>
      </xs:annotation>
      <xs:restriction base="xs:decimal">
          <xs:fractionDigits value="0" fixed="true" id="integer.fractionDigits"/>
          <xs:pattern value="[\-+]?[0-9]+"/>
      </xs:restriction>
  </xs:simpleType>
  -->

  <!-- (annotation?,(restriction|list|union)) -->
  <xsl:template match="xs:simpleType">
    <xsl:param name="input-id"/>

    <xsl:apply-templates select="xs:annotation"/>

    <xsl:element name="div">
      <xsl:attribute name="class">simpleType</xsl:attribute>
        <xsl:apply-templates select="xs:restriction | xs:list | xs:union">
          <xsl:with-param name="input-id"><xsl:value-of select="$input-id"/></xsl:with-param>
        </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <!-- (annotation?,(simpleType*)) -->
  <xsl:template match="xs:simpleType/xs:union">
    <xsl:param name="input-id"/>

    <xsl:element name="form">
      <xsl:attribute name="id"><xsl:value-of select="$input-id"/></xsl:attribute>
      <xsl:attribute name="onchange">
        <xsl:value-of select="$input-id"/>
        <xsl:text>.value=</xsl:text>
        <xsl:for-each select="xs:simpleType/xs:restriction/@base">
          <xsl:value-of select="$input-id"/><xsl:value-of select="position()"/>
          <xsl:text>.value</xsl:text>
          <xsl:if test="position() != last()">
            <xsl:text> + </xsl:text>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>;</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="xs:simpleType">
        <xsl:variable name="input-id">
          <xsl:value-of select="$input-id"/><xsl:value-of select="position()"/>
        </xsl:variable>

        <xsl:apply-templates select="current()">
          <xsl:with-param name="input-id" select="$input-id"/>
        </xsl:apply-templates>
      </xsl:for-each>

      <xsl:element name="output">
        <xsl:attribute name="name">
          <xsl:value-of select="$input-id"/>
        </xsl:attribute>

        <xsl:attribute name="for">
          <xsl:for-each select="xs:simpleType/xs:restriction/@base">
            <xsl:value-of select="$input-id"/><xsl:value-of select="position()"/>
            <xsl:if test="position() != last()">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- (annotation?,(simpleType?,(minExclusive|minInclusive|maxExclusive|maxInclusive|totalDigits|fractionDigits|length|minLength|maxLength|enumeration|whiteSpace|pattern)*))-->
  <xsl:template match="xs:simpleType/xs:restriction[xs:minInclusive and xs:maxInclusive]">
    <xsl:param name="input-id"/>

    <xsl:element name="input">
      <xsl:attribute name="type">
        <xsl:call-template name="formType">

          <xsl:with-param name="xsdType">
            <xsl:value-of select="@base"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="class">form-control</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="$input-id"/>
      </xsl:attribute>
      <xsl:attribute name="placeholder">
        <xsl:value-of select="@base"/>
      </xsl:attribute>
      <xsl:attribute name="min">
        <xsl:value-of select="xs:minInclusive/@value"/>
      </xsl:attribute>
      <xsl:attribute name="max">
        <xsl:value-of select="xs:maxInclusive/@value"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xs:simpleType/xs:restriction[xs:enumeration]">
    <xsl:param name="input-id"/>

    <xsl:text>

    </xsl:text>

    <xsl:element name="select">
      <xsl:attribute name="type">
        <xsl:call-template name="formType">
          <xsl:with-param name="xsdType">
            <xsl:value-of select="@base"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="class">form-control</xsl:attribute>

      <xsl:attribute name="id">
        <xsl:value-of select="$input-id"/>
      </xsl:attribute>

      <xsl:attribute name="placeholder">
        <xsl:value-of select="@base"/>
      </xsl:attribute>

      <xsl:for-each select="xs:enumeration">

        <xsl:element name="option">

          <xsl:attribute name="value">
            <xsl:value-of select="concat(translate(substring(@value,1,1), $vLower, $vUpper),substring(@value, 2))"/>
          </xsl:attribute>

          <xsl:value-of select="concat(translate(substring(@value,1,1), $vLower, $vUpper),substring(@value, 2))"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xs:simpleType/xs:restriction[attribute::base]">
    <xsl:param name="input-id"><xsl:call-template name="name-path"/></xsl:param>
    <xsl:comment>xs:simpleType/xs:restriction[attribute::base=<xsl:value-of select="@base" /> ]</xsl:comment>
    <xsl:apply-templates select="@base">
      <xsl:with-param name="id">
        <xsl:value-of select="$input-id"/>
      </xsl:with-param>
      <xsl:with-param name="name">
        <xsl:call-template name="name-path"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xs:restriction[@base='xs:anySimpleType']">
    <xsl:param name="input-id"/>
    <!--<xsl:param name="input-id">-->
      <!--<xsl:if test="not(@id)"><xsl:call-template name="name-path"/></xsl:if>-->
      <!--<xsl:value-of select="@id"/>-->
    <!--</xsl:param>-->
    <xsl:param name="name">
      <xsl:call-template name="name-path"/>
    </xsl:param>

    <xsl:comment>xs:restriction[@base='xs:anySimpleType']</xsl:comment>

    <xsl:element name="input">
      <xsl:attribute name="type">text</xsl:attribute>
      <xsl:attribute name="class">form-control</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="$input-id"/></xsl:attribute>
      <xsl:attribute name="placeholder">
        <xsl:value-of select="$name"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xs:simpleType/xs:restriction[not(child::node())]">
    <xsl:param name="input-id"/>

    <xsl:variable name="typeName"><xsl:value-of select="@base"/></xsl:variable>
    <xsl:apply-templates select="//xs:simpleType[@name=$typeName]">
      <xsl:with-param name="input-id" select="$input-id" />
      <!--<xsl:with-param name="input-name" select="@name"/>-->
    </xsl:apply-templates>

    <xsl:message>@base<xsl:value-of select="@base"/></xsl:message>

    <xsl:apply-templates select="@base">
      <xsl:with-param name="id" select="$input-id"/>
      <xsl:with-param name="name" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- (annotation?,(simpleContent|complexContent|((group|all|choice|sequence)?,((attribute|attributeGroup)*,anyAttribute?)))) -->
  <xsl:template match="xs:complexType">
    <xsl:param name="input-id"/>
    <xsl:param name="input-name"/>
    <xsl:param name="legendText" select="$input-name"/>

    <xsl:element name="fieldset">
      <xsl:attribute name="form"><xsl:value-of select="$form-id"/></xsl:attribute>
      <xsl:attribute name="name"><xsl:value-of select="$input-name"/></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="$input-id"/></xsl:attribute>

      <xsl:element name="legend"><xsl:value-of select="$legendText"/></xsl:element>

      <xsl:apply-templates select="xs:group|xs:all|xs:choice|xs:sequence">
        <xsl:with-param name="input-id">
          <xsl:value-of select="$input-id"/>
        </xsl:with-param>
      </xsl:apply-templates>

    </xsl:element>

    <!--<xsl:call-template name="fieldset">-->
    <!--<xsl:with-param name="field-id">-->
    <!--<xsl:value-of select="$input-id"/>-->
    <!--</xsl:with-param>-->
    <!--<xsl:with-param name="legendText">-->
    <!--<xsl:value-of select="$legendText"/>-->
    <!--</xsl:with-param>-->
    <!--</xsl:call-template>-->
  </xsl:template>

  <xsl:template match="xs:complexType/xs:choice">
    <xsl:for-each select="xs:element[@type]">
      <!--<div class="radio">-->

          <xsl:element name="input">

            <xsl:attribute name="type">radio</xsl:attribute>

            <xsl:attribute name="name">
              <xsl:value-of select="ancestor::*/@name"/>
              <!--<xsl:value-of select="./@name"/>-->
            </xsl:attribute>

            <xsl:value-of select="concat(translate(substring(./@name,1,1), $vLower, $vUpper),substring(./@name, 2))"/>
          </xsl:element>

          <xsl:apply-templates select="current()"/>

      <!--</div>-->
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="xs:complexType/xs:sequence">

    <xsl:element name="ul">
      <xsl:if test="@id">
        <xsl:attribute name="id">
          div-<xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:attribute name="class">sequence</xsl:attribute>

      <xsl:for-each select="child::node()">
        <xsl:element name="li">
          <xsl:attribute name="value"><xsl:value-of select="attribute::name"/></xsl:attribute>
          <xsl:apply-templates select="current()"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- field == simpleType -->
  <xsl:template name="field">
    <xsl:param name="input-type"/>
    <xsl:param name="input-id" select="@name"/>

    <xsl:call-template name="input">

      <xsl:with-param name="input-id">
        <xsl:value-of select="@name"/>
      </xsl:with-param>

      <xsl:with-param name="input-type">
        <xsl:value-of select="$input-type"/>
      </xsl:with-param>

      <xsl:with-param name="placeholder">
        <xsl:value-of select="$input-type"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!--
    <annotation
    id=ID
    any attributes
    >

    (appinfo|documentation)*

    </annotation>
  -->
  <xsl:template name="annotation" match="xs:annotation">

    <xsl:element name="div">
      <xsl:attribute name="class">annotation</xsl:attribute>
      <xsl:copy-of select="attribute::*"/>

      <xsl:apply-templates select="xs:appinfo" mode="dd"/>

      <xsl:apply-templates select="xs:documentation"/>
    </xsl:element>
  </xsl:template>

  <!--
    id 	ID 		document-wide unique id
    class 	CDATA 		space-separated list of classes
    style 	CDATA 		associated style info - style sheet data
    title 	CDATA 		advisory title
    lang 	NAME 		language code - a language code, as per [RFC1766]
  -->
  <xsl:attribute-set name="html-universal">
    <xsl:attribute name="id" select="@id"/>
    <xsl:attribute name="class" select="@class"/>
    <xsl:attribute name="style" select="@style"/>
    <xsl:attribute name="title" select="@title" />
    <xsl:attribute name="lang" select="@lang"/>
  </xsl:attribute-set>

  <!--
  The appinfo element specifies information to be used by the application. This element must go within an annotation element.

    <appinfo
    source=anyURL
    >

    Any well-formed XML content

    </appinfo>
   -->
  <xsl:template match="xs:appinfo" mode="dd">

    <xsl:element name="div" use-attribute-sets="html-universal">
      <xsl:copy-of select="attribute::*"/>

      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="attribute::source"/>
        </xsl:attribute>

        <xsl:value-of select="attribute::source"/>
      </xsl:element>

      <code>
        <xsl:copy-of select="*"/>
      </code>

    </xsl:element>
  </xsl:template>

  <!--
  The documentation element is used to enter text comments in a schema.

    <documentation
    source=URI reference
    xml:lang=language>

    Any well-formed XML content

    </documentation>
   -->
  <xsl:template match="xs:documentation">
    <div class="documentation">

      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@source"/>
        </xsl:attribute>

        <xsl:value-of select="@source"/>
      </xsl:element>
      <xsl:if test="current()"><p>
        <xsl:value-of select="."/>
      </p></xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="attribute::source">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="current()"/>
        </xsl:attribute>

        <xsl:value-of select="current()"/>
      </xsl:element>
  </xsl:template>

  <xsl:template name="name-path">
    <xsl:for-each select="ancestor-or-self::*/@name"><xsl:value-of select="concat( '', . )"/></xsl:for-each>
  </xsl:template>

  <xsl:template name="create-id">
    <xsl:if test="not(@id)"><xsl:call-template name="name-path"/></xsl:if>
    <xsl:value-of select="@id"/>
  </xsl:template>

  <!--URI (Uniform Resource Identifier) -->
  <xsl:template match="attribute::type[. = concat($ns,':','anyURI')]">
  </xsl:template>

  <!--Binary content coded as "base64" -->
  <xsl:template match="attribute::type[. = concat($ns,':','base64Binary')]">
  </xsl:template>

  <!--Boolean (true or false) -->
  <xsl:template match="attribute::type[. = concat($ns,':','boolean')]">
    <xsl:param name="id"><xsl:call-template name="create-id"/></xsl:param>
    <xsl:param name="name"><xsl:value-of select="current()"/></xsl:param>

    <xsl:comment><xsl:value-of select="."/></xsl:comment>

    <xsl:element name="input"> <!-- use-attribute-sets="input-attributes"> -->
      <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:attribute name="type">checkbox</xsl:attribute>
      <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
      <xsl:attribute name="value"><xsl:value-of select="$name"/></xsl:attribute>
    </xsl:element>
    <!--
    boolean has the following ·constraining facets·:

    pattern
    whiteSpace
    -->
  </xsl:template>

  <!--Signed value of 8 bits -->
  <xsl:template match="attribute::type[. = concat($ns,':','byte')]">
  </xsl:template>

  <!--Gregorian calendar date -->
  <xsl:template match="attribute::type[. = concat($ns,':','date')]">
    <xsl:param name="id"><xsl:call-template name="create-id"/></xsl:param>
    <xsl:param name="name"><xsl:value-of select="current()"/></xsl:param>
    <xsl:comment><xsl:value-of select="."/></xsl:comment>
    <xsl:element name="input"> <!-- use-attribute-sets="input-attributes"> -->
      <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:attribute name="type">date</xsl:attribute>
      <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
      <xsl:attribute name="value"><xsl:text>enter date</xsl:text></xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!--Instant of time (Gregorian calendar) -->
  <xsl:template match="attribute::type[. = concat($ns,':','dateTime')]">
    <time datetime="2014-12-19">19. Dezember</time>
  </xsl:template>


  <!--Decimal numbers -->
  <xsl:template match="attribute::*[(name()='type' or name()='base') and substring-after(.,':') = 'decimal']">
    <!--
    decimal has the following ·constraining facets·:

    totalDigits
    fractionDigits
    pattern
    whiteSpace
    enumeration
    maxInclusive
    maxExclusive
    minInclusive
    minExclusive
    -->
    <xsl:param name="input-id"/>
    <xsl:param name="name"><xsl:value-of select="current()"/></xsl:param>

    <!--
    <xsl:message><xsl:call-template name="name-path"/></xsl:message>
    <xsl:comment><xsl:value-of select="."/></xsl:comment>
-->
    <xsl:element name="label">
      <xsl:attribute name="for"><xsl:value-of select="$input-id"/></xsl:attribute>
      <xsl:value-of select="$name"/>
      <xsl:element name="input">
        <xsl:attribute name="id" select="$input-id"/>
        <xsl:attribute name="type">number</xsl:attribute>
        <xsl:attribute name="name" select="$name"/>
        <xsl:attribute name="min">100</xsl:attribute>
        <xsl:attribute name="max">200</xsl:attribute>
        <xsl:attribute name="step">1</xsl:attribute>
        <xsl:attribute name="value">@name</xsl:attribute>
      </xsl:element>
    </xsl:element>

  </xsl:template>

  <!--IEEE 64-bit floating-point -->
  <xsl:template match="attribute::type[. = concat($ns,':','double')]">
  </xsl:template>

  <!--Time durations -->
  <xsl:template match="attribute::type[. = concat($ns,':','duration')]">
  </xsl:template>

  <!--Whitespace-separated list of unparsed entity references -->
  <xsl:template match="attribute::type[. = concat($ns,':','ENTITIES')]">
  </xsl:template>

  <!--Reference to an unparsed entity -->
  <xsl:template match="attribute::type[. = concat($ns,':','ENTITY')]">
  </xsl:template>

  <!--IEEE 32-bit floating-point -->
  <xsl:template match="attribute::type[. = concat($ns,':','float')]">
  </xsl:template>

  <!--Recurring period of time: monthly day -->
  <xsl:template match="attribute::type[. = concat($ns,':','gDay')]">
  </xsl:template>

  <!--Recurring period of time: yearly month -->
  <xsl:template match="attribute::type[. = concat($ns,':','gMonth')]">
  </xsl:template>

  <!--Recurring period of time: yearly day -->
  <xsl:template match="attribute::type[. = concat($ns,':','gMonthDay')]">
  </xsl:template>

  <!--Period of one year -->
  <xsl:template match="attribute::type[. = concat($ns,':','gYear')]">
  </xsl:template>

  <!--Period of one month -->
  <xsl:template match="attribute::type[. = concat($ns,':','gYearMonth')]">
  </xsl:template>

  <!--Binary contents coded in hexadecimal -->
  <xsl:template match="attribute::type[. = concat($ns,':','hexBinary')]">
  </xsl:template>

  <!--Definition of unique identifiers -->
  <xsl:template match="attribute::type[. = concat($ns,':','ID')]">
  </xsl:template>

  <!--Definition of references to unique identifiers -->
  <xsl:template match="attribute::type[. = concat($ns,':','IDREF')]">
  </xsl:template>

  <!--Definition of lists of references to unique identifiers -->
  <xsl:template match="attribute::type[. = concat($ns,':','IDREFS')]">
  </xsl:template>

  <!--32-bit signed integers -->
  <xsl:template match="attribute::type[. = concat($ns,':','int')]">
    <input type="number" step="1"/>
  </xsl:template>

  <!--Signed integers of arbitrary length -->
  <xsl:template match="attribute::*[. = concat($ns,':','integer')]">
    <xsl:param name="id"><xsl:call-template name="create-id"/></xsl:param>
    <xsl:param name="name" select="./@name" />

    <xsl:message>#<xsl:call-template name="name-path"/></xsl:message>
    <xsl:comment><xsl:value-of select="."/></xsl:comment>
    <xsl:element name="label">
      <xsl:attribute name="for" select="$id"/>
      <xsl:value-of select="$name"/>
      <xsl:element name="input">
        <xsl:attribute name="id" select="$id"/>
        <xsl:attribute name="type">number</xsl:attribute>
        <xsl:attribute name="name" select="$name"/>
        <xsl:attribute name="min">100</xsl:attribute>
        <xsl:attribute name="max">200</xsl:attribute>
        <xsl:attribute name="step">1</xsl:attribute>
        <xsl:attribute name="value">@name</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!--RFC 1766 language codes -->
  <xsl:template match="attribute::type[. = concat($ns,':','language')]">
  </xsl:template>
  <!--64-bit signed integers -->
  <xsl:template match="attribute::type[. = concat($ns,':','long')]">
  </xsl:template>
  <!--XML 1.O name -->
  <xsl:template match="attribute::type[. = concat($ns,':','Name')]">
  </xsl:template>
  <!--Unqualified names -->
  <xsl:template match="attribute::type[. = concat($ns,':','NCName')]">
  </xsl:template>
  <!--Strictly negative integers of arbitrary length -->
  <xsl:template match="attribute::type[. = concat($ns,':','negativeInteger')]">
  </xsl:template>
  <!--XML 1.0 name token (NMTOKEN) -->
  <xsl:template match="attribute::type[. = concat($ns,':','NMTOKEN')]">
  </xsl:template>
  <!--List of XML 1.0 name tokens (NMTOKEN) -->
  <xsl:template match="attribute::type[. = concat($ns,':','NMTOKENS')]">
  </xsl:template>
  <!--Integers of arbitrary length positive or equal to zero -->
  <xsl:template match="attribute::type[. = concat($ns,':','nonNegativeInteger')]">
  </xsl:template>
  <!--Integers of arbitrary length negative or equal to zero -->
  <xsl:template match="attribute::type[. = concat($ns,':','nonPositiveInteger')]">
  </xsl:template>
  <!--Whitespace-replaced strings -->
  <xsl:template match="attribute::type[. = concat($ns,':','normalizedString')]">
  </xsl:template>
  <!--Emulation of the XML 1.0 feature -->
  <xsl:template match="attribute::type[. = concat($ns,':','NOTATION')]">
  </xsl:template>
  <!--Strictly positive integers of arbitrary length -->
  <xsl:template match="attribute::type[. = concat($ns,':','positiveInteger')]">
  </xsl:template>
  <!--Namespaces in XML-qualified names -->
  <xsl:template match="attribute::type[. = concat($ns,':','QName')]">
  </xsl:template>
  <!--32-bit signed integers -->
  <xsl:template match="attribute::type[. = concat($ns,':','short')]">
  </xsl:template>
  <!--Any string -->
  <xsl:template match="attribute::*[. = concat($ns,':','string')]">
    <!--string has the following ·constraining facets·:
    length
    minLength
    maxLength
    pattern
    enumeration
    whiteSpace   -->
    <xsl:param name="id"><xsl:call-template name="create-id"/></xsl:param>
    <xsl:param name="name"><xsl:value-of select="current()"/></xsl:param>

    <xsl:message><xsl:call-template name="name-path"/></xsl:message>
    <xsl:comment><xsl:value-of select="."/></xsl:comment>
    <xsl:element name="label">
      <xsl:attribute name="for" select="$id"/>
      <xsl:value-of select="$name"/>
      <xsl:element name="input">
        <xsl:attribute name="id" select="$id"/>
        <xsl:attribute name="type">text</xsl:attribute>
        <xsl:attribute name="name" select="$name"/>
        <xsl:attribute name="value" select="$name"/>
        <xsl:attribute name="length">@name</xsl:attribute>
        <xsl:attribute name="minLength">@name</xsl:attribute>
        <xsl:attribute name="maxLength">@name</xsl:attribute>
        <xsl:attribute name="pattern">@name</xsl:attribute>
        <xsl:attribute name="enumeration">@name</xsl:attribute>
        <xsl:attribute name="whiteSpace"><xsl:value-of select="xs:whiteSpace/@value"/></xsl:attribute>
      </xsl:element>
    </xsl:element>

  </xsl:template>
  <!--Point in time recurring each day -->
  <xsl:template match="attribute::type[. = concat($ns,':','time')]">
  </xsl:template>
  <!--Whitespace-replaced and collapsed strings -->
  <xsl:template match="attribute::type[. = concat($ns,':','token')]">
  </xsl:template>
  <!--Unsigned value of 8 bits -->
  <xsl:template match="attribute::type[. = concat($ns,':','unsignedByte')]">
  </xsl:template>
  <!--Unsigned integer of 32 bits -->
  <xsl:template match="attribute::type[. = concat($ns,':','unsignedInt')]">
  </xsl:template>
  <!--Unsigned integer of 64 bits -->
  <xsl:template match="attribute::type[. = concat($ns,':','unsignedLong')]">
  </xsl:template>
  <!--Unsigned integer of 16 bits xsd:anyURI -->
  <xsl:template match="attribute::type|base[. = concat($ns,':','unsignedShort')]">
  </xsl:template>
</xsl:stylesheet>
