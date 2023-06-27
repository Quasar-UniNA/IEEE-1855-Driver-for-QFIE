
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


range_temperature = np.linspace(-5.0, 55.0, 200)
qfie.input_variable(name='temperature', range=range_temperature)
list_variable_names.append('temperature')
list_terms=[]
sets=[]
		
list_terms.append('very_cold')
		
term_temperature_very_cold = fuzz.trimf(range_temperature  , [-5.0,-5.0,10.0])
		
sets.append(term_temperature_very_cold )
	
list_terms.append('cold')
		
term_temperature_cold = fuzz.trimf(range_temperature  , [-5.0,10.0,25.0])
		
sets.append(term_temperature_cold )
	
list_terms.append('warm')
		
term_temperature_warm = fuzz.trimf(range_temperature  , [10.0,25.0,40.0])
		
sets.append(term_temperature_warm )
	
list_terms.append('hot')
		
term_temperature_hot = fuzz.trimf(range_temperature  , [25.0,40.0,55.0])
		
sets.append(term_temperature_hot )
	
list_terms.append('very_hot')
		
term_temperature_very_hot = fuzz.trimf(range_temperature  , [40.0,55.0,55.0])
		
sets.append(term_temperature_very_hot )
	

nqr+=math.ceil(math.log(len(sets),2))
nqrd+=math.ceil(math.log(len(sets),2))

qfie.add_input_fuzzysets(var_name='temperature', set_names=list_terms, sets=sets)

range_humidity = np.linspace(0.0, 100.0, 200)
qfie.input_variable(name='humidity', range=range_humidity)
list_variable_names.append('humidity')
list_terms=[]
sets=[]
		
list_terms.append('very_dry')
		
term_humidity_very_dry = fuzz.trimf(range_humidity  , [0.0,0.0,25.0])
		
sets.append(term_humidity_very_dry )
	
list_terms.append('dry')
		
term_humidity_dry = fuzz.trimf(range_humidity  , [0.0,25.0,50.0])
		
sets.append(term_humidity_dry )
	
list_terms.append('normal')
		
term_humidity_normal = fuzz.trimf(range_humidity  , [25.0,50.0,75.0])
		
sets.append(term_humidity_normal )
	
list_terms.append('wet')
		
term_humidity_wet = fuzz.trimf(range_humidity  , [50.0,75.0,100.0])
		
sets.append(term_humidity_wet )
	
list_terms.append('very_wet')
		
term_humidity_very_wet = fuzz.trimf(range_humidity  , [75.0,100.0,100.0])
		
sets.append(term_humidity_very_wet )
	

nqr+=math.ceil(math.log(len(sets),2))
nqrd+=math.ceil(math.log(len(sets),2))

qfie.add_input_fuzzysets(var_name='humidity', set_names=list_terms, sets=sets)

range_power = np.linspace(0.0, 250.0, 200)
qfie.output_variable(name='power', range= range_power)
list_terms=[]
sets=[]
		
list_terms.append('very_low')
		
term_power_very_low= fuzz.trimf(range_power  , [0.0,0.0,62.5])
		
sets.append(term_power_very_low )

list_terms.append('low')
		
term_power_low= fuzz.trimf(range_power  , [0.0,62.5,125.0])
		
sets.append(term_power_low )

list_terms.append('normal')
		
term_power_normal= fuzz.trimf(range_power  , [62.5,125.0,187.5])
		
sets.append(term_power_normal )

list_terms.append('high')
		
term_power_high= fuzz.trimf(range_power  , [125.0,187.5,250.0])
		
sets.append(term_power_high )

list_terms.append('very_high')
		
term_power_very_high= fuzz.trimf(range_power  , [187.5,250.0,250.0])
		
sets.append(term_power_very_high )


nqr+=len(sets)
nqrd+=1

qfie.add_output_fuzzysets(var_name='power', set_names=list_terms, sets=sets)
    
rules=[]



antecedent_RULE1 ='temperature' + ' is ' + 'very_cold' + ' and ' + 'humidity' + ' is ' + 'very_dry'   
consequent_RULE1 = 'power' + ' is ' + 'high'
   
rule='if ' +  antecedent_RULE1 + ' then ' + consequent_RULE1
rules.append(rule)

antecedent_RULE2 ='temperature' + ' is ' + 'very_cold' + ' and ' + 'humidity' + ' is ' + 'dry'   
consequent_RULE2 = 'power' + ' is ' + 'high'
   
rule='if ' +  antecedent_RULE2 + ' then ' + consequent_RULE2
rules.append(rule)

antecedent_RULE3 ='temperature' + ' is ' + 'very_cold' + ' and ' + 'humidity' + ' is ' + 'normal'   
consequent_RULE3 = 'power' + ' is ' + 'very_high'
   
rule='if ' +  antecedent_RULE3 + ' then ' + consequent_RULE3
rules.append(rule)

antecedent_RULE4 ='temperature' + ' is ' + 'very_cold' + ' and ' + 'humidity' + ' is ' + 'wet'   
consequent_RULE4 = 'power' + ' is ' + 'very_high'
   
rule='if ' +  antecedent_RULE4 + ' then ' + consequent_RULE4
rules.append(rule)

antecedent_RULE5 ='temperature' + ' is ' + 'very_cold' + ' and ' + 'humidity' + ' is ' + 'very_wet'   
consequent_RULE5 = 'power' + ' is ' + 'very_high'
   
rule='if ' +  antecedent_RULE5 + ' then ' + consequent_RULE5
rules.append(rule)

antecedent_RULE6 ='temperature' + ' is ' + 'cold' + ' and ' + 'humidity' + ' is ' + 'very_dry'   
consequent_RULE6 = 'power' + ' is ' + 'normal'
   
rule='if ' +  antecedent_RULE6 + ' then ' + consequent_RULE6
rules.append(rule)

antecedent_RULE7 ='temperature' + ' is ' + 'cold' + ' and ' + 'humidity' + ' is ' + 'dry'   
consequent_RULE7 = 'power' + ' is ' + 'high'
   
rule='if ' +  antecedent_RULE7 + ' then ' + consequent_RULE7
rules.append(rule)

antecedent_RULE8 ='temperature' + ' is ' + 'cold' + ' and ' + 'humidity' + ' is ' + 'normal'   
consequent_RULE8 = 'power' + ' is ' + 'high'
   
rule='if ' +  antecedent_RULE8 + ' then ' + consequent_RULE8
rules.append(rule)

antecedent_RULE9 ='temperature' + ' is ' + 'cold' + ' and ' + 'humidity' + ' is ' + 'wet'   
consequent_RULE9 = 'power' + ' is ' + 'very_high'
   
rule='if ' +  antecedent_RULE9 + ' then ' + consequent_RULE9
rules.append(rule)

antecedent_RULE10 ='temperature' + ' is ' + 'cold' + ' and ' + 'humidity' + ' is ' + 'very_wet'   
consequent_RULE10 = 'power' + ' is ' + 'very_high'
   
rule='if ' +  antecedent_RULE10 + ' then ' + consequent_RULE10
rules.append(rule)

antecedent_RULE11 ='temperature' + ' is ' + 'warm' + ' and ' + 'humidity' + ' is ' + 'very_dry'   
consequent_RULE11 = 'power' + ' is ' + 'very_low'
   
rule='if ' +  antecedent_RULE11 + ' then ' + consequent_RULE11
rules.append(rule)

antecedent_RULE12 ='temperature' + ' is ' + 'warm' + ' and ' + 'humidity' + ' is ' + 'dry'   
consequent_RULE12 = 'power' + ' is ' + 'very_low'
   
rule='if ' +  antecedent_RULE12 + ' then ' + consequent_RULE12
rules.append(rule)

antecedent_RULE13 ='temperature' + ' is ' + 'warm' + ' and ' + 'humidity' + ' is ' + 'normal'   
consequent_RULE13 = 'power' + ' is ' + 'very_low'
   
rule='if ' +  antecedent_RULE13 + ' then ' + consequent_RULE13
rules.append(rule)

antecedent_RULE14 ='temperature' + ' is ' + 'warm' + ' and ' + 'humidity' + ' is ' + 'wet'   
consequent_RULE14 = 'power' + ' is ' + 'low'
   
rule='if ' +  antecedent_RULE14 + ' then ' + consequent_RULE14
rules.append(rule)

antecedent_RULE15 ='temperature' + ' is ' + 'warm' + ' and ' + 'humidity' + ' is ' + 'very_wet'   
consequent_RULE15 = 'power' + ' is ' + 'normal'
   
rule='if ' +  antecedent_RULE15 + ' then ' + consequent_RULE15
rules.append(rule)

antecedent_RULE16 ='temperature' + ' is ' + 'hot' + ' and ' + 'humidity' + ' is ' + 'very_dry'   
consequent_RULE16 = 'power' + ' is ' + 'normal'
   
rule='if ' +  antecedent_RULE16 + ' then ' + consequent_RULE16
rules.append(rule)

antecedent_RULE17 ='temperature' + ' is ' + 'hot' + ' and ' + 'humidity' + ' is ' + 'dry'   
consequent_RULE17 = 'power' + ' is ' + 'normal'
   
rule='if ' +  antecedent_RULE17 + ' then ' + consequent_RULE17
rules.append(rule)

antecedent_RULE18 ='temperature' + ' is ' + 'hot' + ' and ' + 'humidity' + ' is ' + 'normal'   
consequent_RULE18 = 'power' + ' is ' + 'high'
   
rule='if ' +  antecedent_RULE18 + ' then ' + consequent_RULE18
rules.append(rule)

antecedent_RULE19 ='temperature' + ' is ' + 'hot' + ' and ' + 'humidity' + ' is ' + 'wet'   
consequent_RULE19 = 'power' + ' is ' + 'high'
   
rule='if ' +  antecedent_RULE19 + ' then ' + consequent_RULE19
rules.append(rule)

antecedent_RULE20 ='temperature' + ' is ' + 'hot' + ' and ' + 'humidity' + ' is ' + 'very_wet'   
consequent_RULE20 = 'power' + ' is ' + 'very_high'
   
rule='if ' +  antecedent_RULE20 + ' then ' + consequent_RULE20
rules.append(rule)

antecedent_RULE21 ='temperature' + ' is ' + 'very_hot' + ' and ' + 'humidity' + ' is ' + 'very_dry'   
consequent_RULE21 = 'power' + ' is ' + 'low'
   
rule='if ' +  antecedent_RULE21 + ' then ' + consequent_RULE21
rules.append(rule)

antecedent_RULE22 ='temperature' + ' is ' + 'very_hot' + ' and ' + 'humidity' + ' is ' + 'dry'   
consequent_RULE22 = 'power' + ' is ' + 'normal'
   
rule='if ' +  antecedent_RULE22 + ' then ' + consequent_RULE22
rules.append(rule)

antecedent_RULE23 ='temperature' + ' is ' + 'very_hot' + ' and ' + 'humidity' + ' is ' + 'normal'   
consequent_RULE23 = 'power' + ' is ' + 'high'
   
rule='if ' +  antecedent_RULE23 + ' then ' + consequent_RULE23
rules.append(rule)

antecedent_RULE24 ='temperature' + ' is ' + 'very_hot' + ' and ' + 'humidity' + ' is ' + 'wet'   
consequent_RULE24 = 'power' + ' is ' + 'very_high'
   
rule='if ' +  antecedent_RULE24 + ' then ' + consequent_RULE24
rules.append(rule)

antecedent_RULE25 ='temperature' + ' is ' + 'very_hot' + ' and ' + 'humidity' + ' is ' + 'very_wet'   
consequent_RULE25 = 'power' + ' is ' + 'very_high'
   
rule='if ' +  antecedent_RULE25 + ' then ' + consequent_RULE25
rules.append(rule)
 
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
   

print("By considering", input_string, "the result of the quantum fuzzy inference is:", result_execution)
