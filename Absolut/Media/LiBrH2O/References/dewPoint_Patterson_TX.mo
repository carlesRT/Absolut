within Absolut.Media.LiBrH2O.References;
function dewPoint_Patterson_TX
  "Dew point of the LiBr+H2O solution as a function of T and X_LiBr"
  //Proposed equation by Y. Kaita (2001) Thermodynamic proeprties of lithium ...”
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output Temperature D "Dew Point of the LiBr solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[6] B1 = {-1.313448E-1, 1.820914E-1, -5.177356E-2, 2.827426E-3, -6.380541E-5, 4.340498E-7};
  constant Real[6] B2 = {9.967944E-1, 1.778069E-3, -2.215597E-4, 5.913618E-6, -7.308556E-8, 2.788472E-6};
  constant Real[6] B3 = {1.978788E-5, -1.779481E-5, 2.002427E-6, -7.667546E-8, 1.201525E-9, -6.641716E-12};
  Modelica.Units.NonSI.Temperature_degC Tc[3]={(T*(5/9) - 459.67)^i for i in 0:
      2} "Temperature [C] of the solution";
  Real[6] X = {(X_LiBr)^i for i in 0:5} "Aux. array";
algorithm
  D := (459.67 + {B1*X,B2*X,B3*X}*Tc)*(9/5);

end dewPoint_Patterson_TX;
