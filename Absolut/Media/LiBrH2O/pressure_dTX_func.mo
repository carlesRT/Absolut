within Absolut.Media.LiBrH2O;
function pressure_dTX_func
  "Function to calculate the pressure of the LiBr+H2O solution as a function of density, T and X_H2O"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    //Based on SSC
  input Modelica.Units.SI.Density d "Density of the solution";
  input Modelica.Units.SI.Temperature T "Saturated pressure of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";

algorithm
  y := d - density_SSC_TXp(T=T, X_H2O=X_H2O, p=u);

end pressure_dTX_func;
