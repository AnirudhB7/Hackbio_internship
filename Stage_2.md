User Guide and Documentation for Wet Lab Calculation Dashboard


## **Overview:**

The Shiny dashboard : <https://anirudhbhatia7.shinyapps.io/app_final_dashboard/> offers three functions to assist with common wet laboratory calculations related to Serial Dilutions, Stock Solution Dilutions, and dPCR Master Mix Preparation. Each calculator takes user inputs and provides both numerical results and visualizations of the dilution or mix preparation steps.


## **A. Serial Dilution Calculator:**

**Aim:** To calculate the final concentration of a solution after a series of dilution steps, where each step involves diluting the solution by a fixed factor.

**Methods**: 

**1.** **Select Serial Dilution**: In the 'Select Calculation Type' dropdown, choose Serial Dilution.

**2. Input Values:** -

a.  Initial Concentration (M): Enter the starting concentration of the solution (in molarity, M).

b. Dilution Factor: Enter the factor by which the solution will be diluted at each step (e.g., 10 for a tenfold dilution).

c.  Number of Dilution Steps: Enter the number of dilution steps.

**3. Output:** The dashboard shall display the final concentration after the specified number of dilution steps. Further, the 'Plots' tab will show a graph of the concentration at each step.


### **Example:**

**Initial Concentration:** 1 M\
**Dilution Factor:** 10\
**Number of Steps:** 3

**Result:** After 3 steps, the final concentration is 0.001 M.


## **B. Stock Solution Dilution Calculator:**

**Aim:** To calculate the amount of stock solution and solvent (e.g., water) required to prepare a solution of a desired concentration and volume from a stock solution.

**Methods**:

1\. **Select Stock Solution Dilution**: In the 'Select Calculation Type' dropdown, choose the function/option of Stock Solution Dilution.

**2. Input Values:**

a. Stock Concentration (M): Enter the concentration of the stock solution.

b. Desired Final Concentration (M): Enter the target concentration for the diluted solution.

c. Final Volume (mL): Enter the final volume you want to prepare (in milliliters).

**3. Output:** The results section of the dashboard shall display the amount of stock solution and the amount of solvent (e.g., water) needed to prepare the solution. Further, the 'Plots' tab displays an interactive bar graph with the volume of stock solution and water required.


### **Example:**

**Stock Concentration:** 10 M\
**Final Concentration:** 1 M\
**Final Volume:** 500 mL

**Result:** Use 50 mL of the stock solution and 450 mL of water.


## **3. dPCR Master Mix Preparation Calculator:**

**Aim**: To calculate the volumes of reagents needed for a digital PCR (dPCR) reaction, based on the number of samples and the reaction volume.

**Methods**:

**1. Select dPCR Master Mix:** In the 'Select Calculation Type' dropdown menu, choose the option of  dPCR Master Mix.

**2. Input Values:**

a. Number of Samples: Enter the number of samples you plan to run.

b. Reaction Volume (µL): Enter the total volume of each reaction.

c. Primer Volume per Reaction (µL): Enter the volume of primer per reaction.

d.  RT Mix per Reaction (µL): Enter the volume of RT mix per reaction.

e. GC Enhancer per Reaction (µL): Enter the volume of GC enhancer per reaction.

f. MM Mix per Reaction (µL): Enter the volume of master mix per reaction.

**3. Output:** The dashboard displays the total volume of each reagent (primer, RT mix, GC enhancer, master mix, water) needed for all the samples. Also, the 'Plots' tab will show a bar plot of the volumes of each reagent required.


### **Example:**

**Number of Samples:** 8\
**Reaction Volume:** 40 µL\
**Primer Volume:** 2 µL\
**RT Mix Volume:** 1 µL\
**GC Enhancer Volume:** 1 µL\
**MM Mix Volume:** 1 µL

**Result:** For 8 samples, the app will calculate the total volume required for each reagent and the water volume needed to complete the reaction.


# **Mathematical Formulas and Logic in R Shiny**

## **1. Serial Dilution Formula:**

The formula for calculating the concentration after multiple dilution steps is:\
C\_final = C\_initial / (Dilution Factor ^ Number of Steps)\
\
\- C\_initial is the starting concentration.\
\- Dilution Factor is how much the concentration is reduced in each step.\
\- Number of Steps is the total number of dilution steps.


### **R Code:**

conc\_after\_dil <- input$init\_conc / (input$dil\_factor ^ input$num\_steps)


## **2. Stock Solution Dilution Formula:**

The formula used is based on the equation:\
C1 \* V1 = C2 \* V2\
\
\- C1 is the concentration of the stock solution.\
\- V1 is the volume of the stock solution.\
\- C2 is the desired final concentration.\
\- V2 is the final volume of the solution.\
\
To solve for V1 (the volume of stock solution needed):\
V1 = (C2 \* V2) / C1\
\
The volume of solvent (e.g., water) required is then:\
V\_water = V2 - V1


### **R Code:**

stock\_vol <- (input$final\_conc \* input$final\_vol) / input$stock\_conc\
water\_vol <- input$final\_vol - stock\_vol


## **3. dPCR Master Mix Preparation Formula:**

For each reagent, the total volume required is calculated as:\
Total Volume = Volume per Reaction \* Number of Samples\
\
For water, the volume is calculated as the difference between the total reaction volume and the sum of the volumes of the other reagents:\
Total Water Volume = (Reaction Volume \* Number of Samples) - (Total Primer + Total RT Mix + Total GC Enhancer + Total MM Mix)


### **R Code:**

total\_primer <- input$num\_samples \* input$primer\_vol\
total\_rtmix <- input$num\_samples \* input$rtmix\_vol\
total\_gcenhancer <- input$num\_samples \* input$gcenhancer\_vol\
total\_mmmix <- input$num\_samples \* input$mmmix\_vol\
total\_water <- (input$reaction\_vol \* input$num\_samples) - (total\_primer + total\_rtmix + total\_gcenhancer + total\_mmmix)
