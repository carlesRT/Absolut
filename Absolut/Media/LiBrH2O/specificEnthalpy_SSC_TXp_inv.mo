within Absolut.Media.LiBrH2O;
function specificEnthalpy_SSC_TXp_inv
  "Inverse function for specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  input SpecificEnthalpy h "Specific enthalpy of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure";
  output Temperature T "Temperature in K of the solution";

algorithm
  T:=temperature(setState_phX(
    p,h,{X_H2O}));

end specificEnthalpy_SSC_TXp_inv;
