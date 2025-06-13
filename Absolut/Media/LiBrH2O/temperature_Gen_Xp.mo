within Absolut.Media.LiBrH2O;
function temperature_Gen_Xp
  "Dew point of the LiBr+H2O solution as a function of T and X_LiBr for Generator (i.e. limited minimum temperature)"
  input MassFraction X_H2O "LiBr mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Saturated pressure of the solution";
  output Temperature T "Temperature of the LiBr solution";

algorithm

 T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function temperature_Xp_func(X_H2O=X_H2O,p=p),
    290,
    443.15,
    100*Modelica.Constants.eps);

    // assert to check obtained temperature is above cristalitzation temperature might be added!

end temperature_Gen_Xp;
