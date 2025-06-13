within Absolut.Media.LiBrH2O.References;
function specificEnthalpy_Kayta_TX
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  //Y. Kaita, 2001, Thermodynamic properties of lithium bromide-water solutions at high temperatures”
  // There is but apparently a problem with its values! ...
  // Values do not match published values... see table 6 of reference!...
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output SpecificEnthalpy h "Specific enthalpy of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[2] A = {3.462023, -2.679895E-2};
  constant Real[2] B = {1.3499E-3, -6.55E-6};
  constant Real[4] D = {162.81, -6.0418, 4.5348E-3, 1.2053E-3};

  Real[4] X = {(X_LiBr*100)^i for i in 0:3} "LiBr mass fraction in [%]";
  Real[2] Tc = {(T-273.15)^i for i in 0:1} "Aux. array  = {1,T in degC}";
algorithm
  h:=  1000*(A*{X[1],X[2]}*Tc[2] + 0.5*B*{X[1],X[2]}*Tc[2]^2 + D*X);
  annotation (derivative=Absolut.Media.LiBrH2O.References.specificEnthalpy_Kayta_TX_der);
end specificEnthalpy_Kayta_TX;
