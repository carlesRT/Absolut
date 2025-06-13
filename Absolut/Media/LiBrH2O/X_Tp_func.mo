within Absolut.Media.LiBrH2O;
function X_Tp_func
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    //Based on SSC
input Modelica.Units.SI.Temperature T "Temperature of the solution";
input Modelica.Units.SI.Pressure p "Saturated pressure of the solution";

algorithm
y := Modelica.Media.Water.WaterIF97_ph.specificGibbsEnergy(Modelica.Media.Water.WaterIF97_ph.setState_pTX(p=p, T=T, X={1})) - chemicalPotential_w_TXp(T,u,p);

end X_Tp_func;
