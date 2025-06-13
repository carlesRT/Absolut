within Absolut.Media.LiBrH2O.References;
function specificHeatCapacity_Patterson_TX
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  //Kaita, Y. 2001. “Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures”
  // Based on Patterson correlation!

  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output SpecificHeatCapacity cp "Specific heat capacity of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[6] Ai1 = {4.124891,-7.643903e-2,2.589577e-3,-9.500522e-5,1.708026e-6,-1.102363e-8};
  constant Real[6] Ai2 = {5.743693e-4,5.870921e-5,-7.375319e-6,3.277592e-7,-6.062304e-9,3.901897e-11};
  Real[6] X = {(X_LiBr*100)^i for i in 0:5} "LiBr mass fraction in [%]";
  Real Tc = (T-273.15) "Aux. array";
algorithm
  cp := 1000*(Ai1*X + 2*Ai2*X*Tc);
  annotation (Documentation(info="<html>
<p>Correlation based on McNelly.</p>
<p>Corellation found in Kaita, Y. 2001. “Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures”</p>

</html>"));
end specificHeatCapacity_Patterson_TX;
