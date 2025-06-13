within Absolut.Media.LiBrH2O;
function chemicalPotential_w_TXp
  "Chemical potential for w of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  output SpecificEnergy m_w "Chemical potential water";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
algorithm
  m_w:= specificGibbsEnergy_TXp(T,X_H2O,p) - X_LiBr*100*specificGibbsEnergy_TXp_derX(T,X_H2O,p);

  annotation (Inline=true,smoothOrder=10, derivative=Absolut.Media.LiBrH2O.chemicalPotential_w_TXp_der);
end chemicalPotential_w_TXp;
