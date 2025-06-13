within Absolut.Media.LiBrH2O;
function X_Tp "Mass fraction as function of temperature and pressure"
  input MassFraction T "LiBr mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Saturated pressure of the solution";
  output Temperature X_H2O "Temperature of the LiBr solution";

algorithm

  X_H2O := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function Absolut.Media.LiBrH2O.X_Tp_func(T=T, p=p),
    0.01,
    0.9,
    100*Modelica.Constants.eps);

    // assert to check obtained temperature is above cristalitzation temperature might be added!
    annotation(inverse(p = saturationPressure_TX(T,X_H2O), T = temperature_Xp(X_H2O,p)));
end X_Tp;
