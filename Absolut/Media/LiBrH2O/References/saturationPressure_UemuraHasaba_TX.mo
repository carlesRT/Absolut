within Absolut.Media.LiBrH2O.References;
function saturationPressure_UemuraHasaba_TX "Vapour pressure of the H2O/LiBr solution as a function of T and X_LiBr.
Based on Uemura and Hasaba"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output AbsolutePressure p_v "vapour pressure of the solution in the vessel";

protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[3] A = {3.1934, 1.3292E-1, -1.4278E-3};
  constant Real[3] B = {1.0575E3, -9.4632E1, 9.816E-1};
  constant Real[3] C = {-6.01350E5, 1.9734E4, -2.3701E2};
  Real[3] X = {(X_LiBr*100)^i for i in 0:2} "Aux. array";

algorithm
 p_v := 1000*(10^(A*X + (B*X)/T + (C*X)/T^2));
end saturationPressure_UemuraHasaba_TX;
