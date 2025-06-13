within Absolut.Media.LiBrH2O;
function density_SSC_TXp_der
  "Derivative of density function for H2O/LiBr solution as a function of T, X_H2O and p"
  input Modelica.Units.SI.Temperature T "Temperature in K of the solution";
  input Modelica.Units.SI.MassFraction X_H2O
    "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  input Real der_T "Derivative temperature in K of the solution";
  input Real der_X_H2O "Derivative water mass fraction in the solution";
  input Real der_p "Derivative pressure";
  output Real der_rho "Derivative density of the solution";

algorithm
  der_rho:= -1000*(1/specificGibbsEnergy_TXp_derp(T,X_H2O,p)^2)*specificGibbsEnergy_TXp_derp_der(T,X_H2O,p,der_T,der_X_H2O,der_p);
end density_SSC_TXp_der;
