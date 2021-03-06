<!-- Q1  (2.0/2.0 points)
Return all countries with population between 9 and 10 million. Retain the structure of country elements from the original data. 
Note: You do not need to use "doc(..)" in your solution. It will be executed on countries.xml. -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='country[@population &gt; 9000000 and @population &lt; 10000000]'>
    <xsl:copy-of select='.'/>
  </xsl:template>

  <xsl:template match='text()' />
</xsl:stylesheet>

<!-- Q2  (2.0/2.0 points)
Find all country names containing the string "stan"; return each one within a "Stan" element. (Note: To specify quotes within an already-quoted XPath expression, use quot;.) 
Note: You do not need to use "doc(..)" in your solution. It will be executed on countries.xml. -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='country[contains(@name, "stan")]'>
    <Stan>
      <xsl:value-of select='data(@name)'/>
    </Stan>
  </xsl:template>

  <xsl:template match='text()' />
</xsl:stylesheet>
