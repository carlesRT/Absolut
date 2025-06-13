within Absolut.Media.LiBrH2O;
function pressure_dTX
  "Pressure of the LiBr+H2O solution as a function of density, Temperature and X_H2O"
  input Modelica.Units.SI.Density d "Density of the solution";
  input Temperature T "Temperature of the LiBr solution";
  input MassFraction X_H2O "LiBr mass fraction in the solution";

  output Modelica.Units.SI.Pressure p "Saturated pressure of the solution";

algorithm
 p :=Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function pressure_dTX_func(
      d=d,
      T=T,
      X_H2O=X_H2O),
    612,
    100000,
    100*Modelica.Constants.eps);

end pressure_dTX;
