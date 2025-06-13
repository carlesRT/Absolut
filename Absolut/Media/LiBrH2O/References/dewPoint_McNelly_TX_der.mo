within Absolut.Media.LiBrH2O.References;
function dewPoint_McNelly_TX_der
  "Derivative of dew point of the H2O/LiBr solution as a function T of and X"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Real der_T "Derivative of temperature [K] of the solution";
  input Real der_X_H2O "Derivative of water mass fraction in the solution";
  output Real der_D "Derivative of dew point of the LiBr solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O "Derivative of LiBr mass fraction in the solution";
  constant Real[4] V = {-2.00755, 0.16976, -3.13336e-3, 1.97668e-5};
  constant Real[4] W = {124.937, -7.7165, 0.152286, -7.9509e-4};
  Modelica.Units.NonSI.Temperature_degC Tc=T - 273.15
    "Temperature [C] of the solution";
  Real der_Tc = der_T "Devivative of temperature [C] of the solution";
  Real[4] X = {(X_LiBr*100)^i for i in 0:3} "Aux. array";
  Real[4] der_X = {i*(X_LiBr*100)^(i-1)*(100*der_X_LiBr) for i in 0:3} "Aux. derivative array";
algorithm
  der_D := ((der_Tc - W*der_X)*(V*X) - (V*der_X)*(Tc - W*X))/(V*X)^2;
end dewPoint_McNelly_TX_der;
