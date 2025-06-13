within Absolut.Media.LiBrH2O;
function chemicalPotential_s_TXp
  "Chemical potential for s of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  output SpecificEnergy m_s "Chemical potential of LiBr";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";

algorithm
  m_s:= specificGibbsEnergy_TXp(T,X_H2O,p) +(1-X_LiBr)*100*specificGibbsEnergy_TXp_derX(T,X_H2O,p);

  annotation (smoothOrder=10);
end chemicalPotential_s_TXp;
