within Absolut.Media.LiBrH2O;
function specificGibbsEnergy_TXp_der
  "specificGibbsEnergy of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Temperature T "Temperature (K) of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  input Real der_T "Temperature difference of the solution";
  input Real der_X_H2O "Water mass fraction in the solution";
  input Real der_p "Pressure";
  output Real der_g "Specific gibbs energy of the solution";
protected
  MassFraction X_LiBr = max(0,1 - X_H2O) "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O;
  Real der_pkPa = der_p/1000;
algorithm
  der_g:= specificGibbsEnergy_TXp_derT(T,X_H2O,p)*der_T
  + specificGibbsEnergy_TXp_derX(T,X_H2O,p)*(der_X_LiBr*100)
  + specificGibbsEnergy_TXp_derp(T,X_H2O,p)*der_pkPa;
   annotation(smoothOrder = 10);
end specificGibbsEnergy_TXp_der;
