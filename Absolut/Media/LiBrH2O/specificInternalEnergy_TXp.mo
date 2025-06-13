within Absolut.Media.LiBrH2O;
function specificInternalEnergy_TXp
  "specificGibbsEnergy of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  output SpecificEnergy u "Specific gibbs energy of the solution";

protected
  Modelica.Units.SI.Pressure pkPa=p/1000 "Pressure in kPa";

algorithm
  u := Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
    T,
    X_H2O,
    p) - p*Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_derp(
    T,
    X_H2O,
    p);
  annotation(Inline=true,smoothOrder = 10);
end specificInternalEnergy_TXp;
