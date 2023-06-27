<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fml="http://www.ieee1855.org" version="2.0">
	<xsl:output method="text" version="2.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

<xsl:template match="/">

<xsl:text>
import sys
import numpy as np
import math
import skfuzzy as fuzz
import matplotlib.pyplot as plt
import QFIE.FuzzyEngines as FE

#instantiate the fuzzy inference engine
qfie = FE.QuantumFuzzyEngine()

#variable storing the names of the input variables
list_variable_names =[]
#number of qubits required
nqr=0
#number of qubits required for distributed version
nqrd=0

</xsl:text>

    
  <xsl:call-template name="variablesDefinition"/>
  <xsl:call-template name="rulesDefinition"/>
  
<xsl:text disable-output-escaping="yes"> 
qfie.set_rules(rules)

input_dict={}
index=1
input_string =' '
for v in list_variable_names:
         input_dict[v] =   float(sys.argv[index])
         input_string+= v + ' ' + str(sys.argv[index]) + ','
         index+=1


if len(sys.argv) == len(list_variable_names)+1:
         if nqr > 32:
                  raise Exception("The number of qubits of Qasm simulator are not enough to run the fuzzy controller!")
         qfie.build_inference_qc(input_dict)
         result_execution=qfie.execute(n_shots= 8000)[0]
else:
         IBMQ.enable_account(sys.argv[index+4])
         provider = IBMQ.get_provider(sys.argv[index+1],
              sys.argv[index+2], sys.argv[index+3])
         backend = provider.get_backend(sys.argv[index])
         if nqrd > backend.num_qubits:
                  raise Exception("The number of qubits of quantum processor are not enough to run the fuzzy controller!")
         qfie.build_inference_qc(input_dict, distributed=True)
         result_execution=qfie.execute(n_shots= 8000, 
         backend=backend)[0]
   

print("By considering", input_string, 
"the result of the quantum fuzzy inference is:", 
result_execution)
</xsl:text>
</xsl:template>



<xsl:template name="variablesDefinition" >
  
  
  <xsl:for-each select="fml:fuzzySystem/fml:knowledgeBase/fml:fuzzyVariable">
    <xsl:choose>
	  <xsl:when test="@type='Input'">
range_<xsl:value-of select="@name"/> = np.linspace(<xsl:value-of select="@domainleft"/>, <xsl:value-of select="@domainright"/>, 200)
qfie.input_variable(name='<xsl:value-of select="@name"/>', range=range_<xsl:value-of select="@name"/>)
list_variable_names.append('<xsl:value-of select="@name"/>')
list_terms=[]
sets=[]
		<xsl:for-each select="fml:fuzzyTerm">
list_terms.append('<xsl:value-of select="@name"/>')
		<xsl:variable name="numParam" select="count(node()[1]/@*)"/>
<xsl:if test="$numParam =1">
			<xsl:variable name="nameTag" select="node()[1]/local-name()"/>
<xsl:if test="$nameTag ='singletonShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.trimf( range_<xsl:value-of select="../@name"/>  , [<xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>])
		</xsl:if>
			</xsl:if>
<xsl:if test="$numParam =2">
<xsl:variable name="nameTag" select="node()[1]/local-name()"/>
<xsl:if test="$nameTag ='gaussianShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/>= fuzz.gaussmf(range_<xsl:value-of select="../@name"/>  , <xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>)
		</xsl:if>
		<xsl:if test="$nameTag ='sShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/>= fuzz.smf(range_<xsl:value-of select="../@name"/> , <xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>)
		</xsl:if>
				<xsl:if test="$nameTag ='zShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.zmf(range_<xsl:value-of select="../@name"/>  , <xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>)
		</xsl:if>
			</xsl:if>
		<xsl:if test="$numParam =3">
	<xsl:variable name="nameTag" select="node()[1]/local-name()"/>
<xsl:if test="$nameTag ='triangularShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.trimf(range_<xsl:value-of select="../@name"/>  , [<xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param2"/>,<xsl:value-of select="node()[1]/@param3"/>])
		</xsl:if>
		</xsl:if>
		<xsl:if test="$numParam =4">
<xsl:variable name="nameTag" select="node()[1]/local-name()"/>
<xsl:if test="$nameTag ='trapezoidShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.trapmf(range_<xsl:value-of select="../@name"/>  , [<xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param2"/>,<xsl:value-of select="node()[1]/@param3"/>,<xsl:value-of select="node()[1]/@param4"/>])
</xsl:if>
</xsl:if>
sets.append(term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> )
	</xsl:for-each>

nqr+=math.ceil(math.log(len(sets),2))
nqrd+=math.ceil(math.log(len(sets),2))

qfie.add_input_fuzzysets(var_name='<xsl:value-of select="@name"/>', set_names=list_terms, sets=sets)
</xsl:when>
    <xsl:otherwise>
range_<xsl:value-of select="@name"/> = np.linspace(<xsl:value-of select="@domainleft"/>, <xsl:value-of select="@domainright"/>, 200)
qfie.output_variable(name='<xsl:value-of select="@name"/>', range= range_<xsl:value-of select="@name"/>)
list_terms=[]
sets=[]
		<xsl:for-each select="fml:fuzzyTerm">
list_terms.append('<xsl:value-of select="@name"/>')
		<xsl:variable name="numParam" select="count(node()[1]/@*)"/>
		<xsl:if test="$numParam =1">
		<xsl:variable name="nameTag" select="node()[1]/local-name()"/>
<xsl:if test="$nameTag ='singletonShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.trimf( range_<xsl:value-of select="../@name"/> , [<xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>])
		</xsl:if>
		</xsl:if>
		<xsl:if test="$numParam =2">
<xsl:variable name="nameTag" select="node()[1]/local-name()"/>
<xsl:if test="$nameTag ='gaussianShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.gaussmf(range_<xsl:value-of select="../@name"/> , <xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>)
		</xsl:if>
		<xsl:if test="$nameTag ='sShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.smf(range_<xsl:value-of select="../@name"/> , <xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>)
		</xsl:if>
				<xsl:if test="$nameTag ='zShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.zmf(range_<xsl:value-of select="../@name"/> , <xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param1"/>)
		</xsl:if>
			</xsl:if>
		<xsl:if test="$numParam =3">
	<xsl:variable name="nameTag" select="node()[1]/local-name()"/>
<xsl:if test="$nameTag ='triangularShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/>= fuzz.trimf(range_<xsl:value-of select="../@name"/>  , [<xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param2"/>,<xsl:value-of select="node()[1]/@param3"/>])
		</xsl:if>
		</xsl:if>
		<xsl:if test="$numParam =4">
<xsl:variable name="nameTag" select="node()[1]/local-name()"/>
<xsl:if test="$nameTag ='trapezoidShape' ">
term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> = fuzz.trapmf(range_<xsl:value-of select="../@name"/>  , [<xsl:value-of select="node()[1]/@param1"/>,<xsl:value-of select="node()[1]/@param2"/>,<xsl:value-of select="node()[1]/@param3"/>,<xsl:value-of select="node()[1]/@param4"/>])
</xsl:if>
</xsl:if>
sets.append(term_<xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/> )
</xsl:for-each>

nqr+=len(sets)
nqrd+=1

qfie.add_output_fuzzysets(var_name='<xsl:value-of select="@name"/>', set_names=list_terms, sets=sets)
    </xsl:otherwise>		
   </xsl:choose>
  </xsl:for-each>
</xsl:template>



<xsl:template name="rulesDefinition" >
rules=[]


<xsl:for-each select="fml:fuzzySystem/fml:mamdaniRuleBase/fml:rule">
<xsl:variable name="numA" select="count(fml:antecedent/fml:clause)"/>
<xsl:call-template name="createAntecedent">
   <xsl:with-param name="numClauses" select="$numA"/>
</xsl:call-template>
    <xsl:for-each select="fml:consequent/fml:then/fml:clause">
consequent_<xsl:value-of select="../../../@name"/> = '<xsl:value-of select="fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:term"/>'
   </xsl:for-each>
rule='if ' +  antecedent_<xsl:value-of select="@name"/> + ' then ' + consequent_<xsl:value-of select="@name"/>
rules.append(rule)
</xsl:for-each>

</xsl:template>



<xsl:template name="createAntecedent">

 <xsl:param name="numClauses"/>

 <xsl:if test="$numClauses =1">
antecedent_<xsl:value-of select="@name"/> = '<xsl:value-of select="fml:antecedent/node()[1]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[1]/fml:term"/>'
 </xsl:if> 
 <xsl:if test="$numClauses =2">
   <xsl:choose>
	  <xsl:when test="lower-case(@connector)='or'">
antecedent_<xsl:value-of select="@name"/> ='<xsl:value-of select="fml:antecedent/node()[1]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[1]/fml:term"/>' + ' or ' + '<xsl:value-of select="fml:antecedent/node()[2]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[2]/fml:term"/>' 
	  </xsl:when>
    <xsl:otherwise>
antecedent_<xsl:value-of select="@name"/> ='<xsl:value-of select="fml:antecedent/node()[1]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[1]/fml:term"/>' + ' and ' + '<xsl:value-of select="fml:antecedent/node()[2]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[2]/fml:term"/>'   </xsl:otherwise>		
   </xsl:choose>
 </xsl:if> 
   
  <xsl:if test="$numClauses &gt; 2">
   <xsl:choose>
      <xsl:when test="lower-case(@connector)='or'">
antecedent_<xsl:value-of select="@name"/> ='<xsl:value-of select="fml:antecedent/node()[1]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[1]/fml:term"/>' + ' or ' + '<xsl:value-of select="fml:antecedent/node()[2]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[2]/fml:term"/>' 
		 <xsl:call-template name="loopAntOR">
             <xsl:with-param name="count">2</xsl:with-param>
			 <xsl:with-param name="numC" select="$numClauses"/>
			 <xsl:with-param name="nameRule" select="@name"/>
          </xsl:call-template>
	  </xsl:when>
    <xsl:otherwise>
antecedent_<xsl:value-of select="@name"/> ='<xsl:value-of select="fml:antecedent/node()[1]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[1]/fml:term"/>' + ' and ' + '<xsl:value-of select="fml:antecedent/node()[2]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[2]/fml:term"/>' 
		 <xsl:call-template name="loopAntAND">
             <xsl:with-param name="count">2</xsl:with-param>
			 <xsl:with-param name="numC" select="$numClauses"/>
			 <xsl:with-param name="nameRule" select="@name"/>
          </xsl:call-template>
 </xsl:otherwise>		
   </xsl:choose>
 </xsl:if>
   
   
   
</xsl:template>


<xsl:template name="loopAntOR" >
<xsl:param name="count" />
<xsl:param name="numC" />
<xsl:param name="nameRule"/>
<xsl:if test="$count &lt; $numC">
antecedent_<xsl:value-of select="$nameRule"/> = 	antecedent_<xsl:value-of select="$nameRule"/>   + ' or '  + '<xsl:value-of select="fml:antecedent/node()[$count+1]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[$count+1]/fml:term"/>'
  <xsl:call-template name="loopAntOR" >
          <xsl:with-param name="count" select="$count+1"/>
		  <xsl:with-param name="numC" select="$numC"/>
		  <xsl:with-param name="nameRule" select="$nameRule"/>
        </xsl:call-template>
 </xsl:if>
 
 
 
</xsl:template>


<xsl:template name="loopAntAND" >
<xsl:param name="count" />
<xsl:param name="numC" />
<xsl:param name="nameRule"/>

 <xsl:if test="$count &lt; $numC">
antecedent_<xsl:value-of select="$nameRule"/>  = 	antecedent_<xsl:value-of select="$nameRule"/>   + ' and '  + '<xsl:value-of select="fml:antecedent/node()[$count+1]/fml:variable"/>' + ' is ' + '<xsl:value-of select="fml:antecedent/node()[$count+1]/fml:term"/>'
		 <xsl:call-template name="loopAntAND" >
          <xsl:with-param name="count" select="$count+1"/>
		  <xsl:with-param name="numC" select="$numC"/>
		  <xsl:with-param name="nameRule" select="$nameRule"/>
        </xsl:call-template>
 </xsl:if>
 
 
 
</xsl:template>

</xsl:stylesheet>