within Absolut.Media.LiBrH2O.References;
function specificHeatCapacity_Rockenfeller_TX
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  //Kaita, Y. 2001. “Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures”
  // Based on Rockenfeller. Laboratory results: solution = LiBr-H2O, properties = P -T - X, heat capacity. Unpiblished data.

  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output SpecificHeatCapacity cp "Specific heat capacity of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[2] A = {3.462023, -2.679895E-2};
  constant Real[2] B = {1.3499E-3, -6.55E-6};
  Real[2] X = {(X_LiBr*100)^i for i in 0:1} "Aux. array";
  Real[2] Tc = {(T-273.15)^i for i in 0:1} "Aux. array";
algorithm
  cp := 1000*{A*X, B*X}*Tc;
  annotation (derivative=Absolut.Media.LiBrH2O.References.specificHeatCapacity_Rockenfeller_TX_der,
      Documentation(info="<html>
<p>Correlation based on Rockenfeler, Laboratory results: solution = LiBr-H2O, properties = P - T - X, heat capacity, Unpublished data.</p>
<p>Corellation found in Kaita, Y. 2001. “Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures”</p>

</html>"));
end specificHeatCapacity_Rockenfeller_TX;
