within Absolut.Media.LiBrH2O;
function saturationPressure_TX "Vapour pressure of the H2O/LiBr solution as a function of T and X_X2O"
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  // outputs
  output AbsolutePressure p_v "vapour pressure of the solution in the vessel";

protected
Modelica.Units.SI.Pressure Pmax "";
algorithm
//Pmax := max(2000,1000*((1891.154584 - 14.442759*T + 0.027554*T^2) - 1));
Pmax := 600000;

  p_v := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function Absolut.Media.LiBrH2O.saturationPressure_TX_func(T=T, X_H2O=X_H2O),
    612,
    Pmax,
    100*Modelica.Constants.eps);

annotation(Inline=true, inverse(T = temperature_Xp(X_H2O,p_v), X_H2O = X_Tp(T,p_v)));
end saturationPressure_TX;
