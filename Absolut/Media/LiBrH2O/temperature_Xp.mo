within Absolut.Media.LiBrH2O;
function temperature_Xp
  "Dew point of the LiBr+H2O solution as a function of T and X_LiBr"
  input MassFraction X_H2O "LiBr mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Saturated pressure of the solution";
  output Temperature T "Temperature of the LiBr solution";

protected
Modelica.Units.SI.Temperature Tmin "Minimal temperature based on...";

algorithm

T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function temperature_Xp_func(X_H2O=X_H2O,p=p),
    273.5,
    600,
    100*Modelica.Constants.eps);

    // assert to check obtained temperature is above cristalitzation temperature might be added!
    annotation(Inline=true,inverse(p = saturationPressure_TX(T,X_H2O), X_H2O = X_Tp(T,p)));
end temperature_Xp;
