within Absolut.Media.LiBrH2O;
function temperature_hXp
  "Temperature of the LiBr+H2O solution as a function of h, X_H2O and p"
  input Modelica.Units.SI.SpecificEnthalpy h "Enthalpy of the solution";
  input MassFraction X_H2O "LiBr mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Saturated pressure of the solution";
  output Temperature T "Temperature of the LiBr solution";

protected
  Modelica.Units.SI.Temperature Tmin "Minimal temperature based on...";

algorithm

 /* T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function temperature_Kaita_Xp_func(X_H2O=X_H2O,p=p),
    283.15,
    443.15,
    100*Modelica.Constants.eps);
    
    */
 //Tmin := max(273.25,0.000227 * p - 6 + 273.15);
 Tmin:= 273.5;

 T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function temperature_hXp_func(h=h, X_H2O=X_H2O,p=p),
    Tmin,
     600,
    100*Modelica.Constants.eps);

    // assert to check obtained temperature is above cristalitzation temperature might be added!

end temperature_hXp;
