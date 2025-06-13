within Absolut.Media.LiBrH2O;
function dynamicViscosity_SSC_TX_der
  "Derivative of dynamic viscosity"
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "LiBr mass fraction in the solution";
  input Real der_T "Derivative of temperature in K of the solution";
  input Real der_X_H2O "Derivative of LiBr mass fraction in the solution";
  output Real der_eta "Dynamic viscosity";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O "Derivative of LiBr mass fraction in the solution";
  constant Real[2] A = {-2.3212641667148, 3.190587778753};
  constant Real[2] B = {-609.44957160372, 963.16370163469};
  constant Real[2] C = {372994.85578423,  -35211.99698739};
  Real[2] X = {1, X_LiBr^2} "Aux. array";
  Real[2] der_X = {0*der_X_LiBr, 2*X_LiBr*der_X_LiBr} "Aux. array";
  Real[3] T_aux = {T^(-i) for i in 0:2} "Aux. array";
  Real[3] der_T_aux = {(-i)*T^(-i-1)*der_T for i in 0:2} "Aux. array";
algorithm
  der_eta := 1E-3*exp({A*X, B*X, C*X}*T_aux) * ({A*der_X, B*der_X, C*der_X}*T_aux + {A*X, B*X, C*X}*der_T_aux);
end dynamicViscosity_SSC_TX_der;
