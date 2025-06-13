within Absolut.Media.LiBrH2O;
function temperature_Xp_funcR2pT
  "Dew point of the LiBr+H2O solution as a function of T and X_LiBr"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    //Based on SSC
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Saturated pressure of the solution";

algorithm
y := Modelica.Media.Water.WaterIF97_R2pT.specificGibbsEnergy(Modelica.Media.Water.WaterIF97_R2pT.setState_pTX(p=p, T=u, X={1})) - chemicalPotential_w_TXp(u,X_H2O,p);

end temperature_Xp_funcR2pT;
