within Absolut.Media.LiBrH2O.References;
function specificEnthalpy_Kayta_TX_der
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  //Y. Kaita, 2001, Thermodynamic properties of lithium bromide-water solutions at high temperatures”
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Real der_T "Derivative of temperature [K] of the solution";
  input Real der_X_H2O "Derivative of water mass fraction in the solution";
  output Real der_h "Specific enthalpy of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O "Derivative of LiBr mass fraction in the solution";
  constant Real[2] A = {3.462023, -2.679895E-2};
  constant Real[2] B = {1.3499E-3, -6.55E-6};
  constant Real[4] D = {162.81, -6.0418, 4.5348E-3, 1.2053E-3};

  Real[4] X = {(X_LiBr*100)^i for i in 0:3} "Aux. array";
  Real[2] Tc = {(T-273.15)^i for i in 0:1} "Aux. array";

algorithm
  der_h:= (A[2]*Tc[2]+0.5*B[2]*Tc[2]^2 + D[2] + 2*D[3]*X[2] + 3*D[4]*X[3])*(der_X_LiBr*100) + (A[1]+A[2]*X[2] + (B[1]+B[2]*X[2])*Tc[2])*der_T;

end specificEnthalpy_Kayta_TX_der;
