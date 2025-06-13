within Absolut.Media.LiBrH2O;
function saturationPressure_TX_func
  "Function that iterates over p to find saturation pressure"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    //Based on SSC
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";

algorithm
  y := Modelica.Media.Water.WaterIF97_ph.specificGibbsEnergy(Modelica.Media.Water.WaterIF97_ph.setState_pTX(p=u, T=T, X={1})) - chemicalPotential_w_TXp(T,X_H2O,u);
end saturationPressure_TX_func;
