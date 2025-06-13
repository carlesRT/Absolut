within Absolut.Media.LiBrH2O.References;
function specificHeatCapacity_Rockenfeller_TX_der
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Real der_T "Derivative of temperature [K] of the solution";
  input Real der_X_H2O "Derivative of water mass fraction in the solution";
  output Real der_cp "Specific heat capacity of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O "Derivative of LiBr mass fraction in the solution";
  constant Real[2] A = {3.462023, -2.679895E-2};
  constant Real[2] B = {1.3499E-3, -6.55E-6};
  Real[2] X = {(X_LiBr*100)^i for i in 0:1} "Aux. array";
  Real[2] der_X = {i*(X_LiBr*100)^(i-1)*der_X_LiBr*100 for i in 0:1} "Aux. array";
  Real[2] Tc = {(T-273.15)^i for i in 0:1} "Aux. array";
  Real[2] der_Tc = {i*(T-273.15)^(i-1)*der_T for i in 0:1} "Aux. array";
algorithm
  der_cp := 1000*{A*der_X, B*der_X}*Tc + 1000*{A*X, B*X}*der_Tc;
end specificHeatCapacity_Rockenfeller_TX_der;
