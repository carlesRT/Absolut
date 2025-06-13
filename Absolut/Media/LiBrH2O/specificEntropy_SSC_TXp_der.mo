within Absolut.Media.LiBrH2O;
function specificEntropy_SSC_TXp_der
  "Derivative specific entropy of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure";
  input Real der_T "Derivative temperature of the solution";
  input Real der_X_H2O "Derivative water mass fraction in the solution";
  input Real der_p "Derivative pressure";
  output Real der_s "Derivative specific entropy of the solution";

algorithm
  der_s:= - specificGibbsEnergy_TXp_derT_der(
    T,
    X_H2O,
    p,
    der_T,
    der_X_H2O,
    der_p);

end specificEntropy_SSC_TXp_der;
