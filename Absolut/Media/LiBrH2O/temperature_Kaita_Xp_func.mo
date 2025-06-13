within Absolut.Media.LiBrH2O;
function temperature_Kaita_Xp_func
  "Dew point of the LiBr+H2O solution as a function of T and X_LiBr"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    //Based on SSC
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Saturated pressure of the solution";

algorithm
  y := Absolut.Media.LiBrH2O.References.saturationPressure_Kaita_TX(u, X_H2O)
     - p;

end temperature_Kaita_Xp_func;
