within Absolut.Media.LiBrH2O;
function temperature_hXp_func
  "Function to calculate the temperature of the LiBr+H2O solution as a function of h, X_H2O and p."
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    //Based on SSC
  input Modelica.Units.SI.SpecificEnthalpy h "Enthalpy of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Saturated pressure of the solution";

algorithm
  y := h - specificEnthalpy_SSC_TXp(T=u, X_H2O=X_H2O, p=p);

end temperature_hXp_func;
