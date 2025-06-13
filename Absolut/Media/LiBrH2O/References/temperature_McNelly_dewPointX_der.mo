within Absolut.Media.LiBrH2O.References;
function temperature_McNelly_dewPointX_der
  "Derivative of temperature of the H2O/LiBr solution as a function of dew point and X"
  input Temperature D "Dew Point of the LiBr solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Real der_D "Derivative of dew Point of the LiBr solution";
  input Real der_X_H2O "Derivative of water mass fraction in the solution";
  output Real der_T "Derivative of temperature of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O "Derivative of LiBr mass fraction in the solution";
  constant Real[4] V={-2.00755, 0.16976, -3.13336e-3, 1.97668e-5};
  constant Real[4] W={124.937, -7.7165, 0.152286, -7.9509e-4};
  Modelica.Units.NonSI.Temperature_degC Dc=D - 273.15
    "Dew Point [C] of the solution";
  Real[4] X = {(X_LiBr*100)^i for i in 0:3} "Aux. array";
  Real[4] der_X = {i*(X_LiBr*100)^(i-1)*(100*der_X_LiBr) for i in 0:3} "Aux. array";
algorithm
  der_T := (der_D*(V*X) + Dc*(V*der_X)) + W*der_X;
end temperature_McNelly_dewPointX_der;
