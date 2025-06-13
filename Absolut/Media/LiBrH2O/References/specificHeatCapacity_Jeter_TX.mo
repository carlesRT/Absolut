within Absolut.Media.LiBrH2O.References;
function specificHeatCapacity_Jeter_TX
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  //Kaita, Y. 2001. “Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures”

  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output SpecificHeatCapacity cp "Specific heat capacity of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[2] A = {3.067819, -2.15232E-2};
  constant Real[2] B = {6.018E-3, -7.31E-5};
  Real[2] X = {(X_LiBr*100)^i for i in 0:1} "Aux. array";
  Real Tc = (T-273.15) "Aux. array";
algorithm
  cp := 1000*(A*X + B*X*Tc);
  annotation (Documentation(info="<html>
<p>Correlation based on Rockenfeler, Laboratory results: solution = LiBr-H2O, properties = P - T - X, heat capacity, Unpublished data.</p>
<p>Corellation found in Kaita, Y. 2001. “Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures”</p>

</html>"));
end specificHeatCapacity_Jeter_TX;
