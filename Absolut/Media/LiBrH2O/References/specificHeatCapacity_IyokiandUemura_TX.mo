within Absolut.Media.LiBrH2O.References;
function specificHeatCapacity_IyokiandUemura_TX
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  //Kaita, Y. 2001. “Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures”
  // Based on Iyoki and Uemura correlation!

  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output SpecificHeatCapacity cp "Specific heat capacity of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[7] A = {5.62514, 1.40395E-1,-1.06479E-3,-9.97880E-4,4.59723E-5,-7.61618E-7,4.37013E-9};
  constant Real[7] B = {-8.96356E-3,-8.19462E-4,-2.72788E-5,7.56136E-6,-3.12107E-7,4.98885E-9,-2.81480E-11};
  constant Real[7] C = {1.38744E-5,8.86288E-7,7.06171E-8,-1.21807E-8,4.74146E-10,-7.39772E-12,4.11735E-14};
  Real[7] X = {(X_LiBr*100)^i for i in 0:6} "LiBr mass fraction in [%]";
algorithm
  cp := 1000*(A*X + B*X*(T) + C*X*(T)^2);
  annotation (Documentation(info="<html>
<p>Correlation based on Iyoki and Uemura.</p>
<p>Corellation found in Kaita, Y. 2001. “Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures”</p>

</html>"));
end specificHeatCapacity_IyokiandUemura_TX;
