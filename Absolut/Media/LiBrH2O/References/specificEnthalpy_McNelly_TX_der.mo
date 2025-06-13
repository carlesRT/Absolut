within Absolut.Media.LiBrH2O.References;
function specificEnthalpy_McNelly_TX_der
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Real der_T "Derivative of temperature [K] of the solution";
  input Real der_X_H2O "Derivative of water mass fraction in the solution";
  output Real der_h "Derivative of specific enthalpy of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O "Derivative of LiBr mass fraction in the solution";
  constant Real[5] J = {-1015.07, 79.5387, - 2.358016, 0.03031583, -1.400261E-4};
  constant Real[5] K = {4.68108, -3.037766E-1, 8.44845E-3, -1.047721e-4, 4.80097e-7};
  constant Real[5] L = {-4.9107e-3, 3.83184e-4, -1.078963e-5, 1.3152e-7, -5.89e-10};
  Real[5] X = {(X_LiBr*100)^i for i in 0:4} "Aux. array";
  Real[5] der_X = {i*(X_LiBr*100)^(i-1)*(der_X_LiBr*100) for i in 0:4} "Aux. array";
  Real[3] Tc = {(1.8*(T-273.15)+32)^i for i in 0:2} "Aux. array";
  Real[3] der_Tc = {i*(1.8*(T-273.15)+32)^(i-1)*(1.8*der_T) for i in 0:2} "Aux. array";
algorithm
  der_h := 2.326E3*({J*der_X, K*der_X, L*der_X}*Tc + {J*X, K*X, L*X}*der_Tc);
end specificEnthalpy_McNelly_TX_der;
