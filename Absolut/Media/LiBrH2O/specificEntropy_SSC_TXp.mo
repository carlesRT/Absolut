within Absolut.Media.LiBrH2O;
function specificEntropy_SSC_TXp
  "Specific entropy of the H2O/LiBr solution as a function of T, X_H2O and p"

  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure";
  output SpecificEntropy s "Specific entropy of the solution";

algorithm
  s:= - specificGibbsEnergy_TXp_derT(
    T,
    X_H2O,
    p);
    annotation(Inline=true, smoothOrder = 10,derivative=Absolut.Media.LiBrH2O.specificEntropy_SSC_TXp_der);
end specificEntropy_SSC_TXp;
