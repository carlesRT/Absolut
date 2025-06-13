within Absolut.Media.LiBrH2O;
function dynamicViscosity_SSC_TX
  "Dynamic viscosity of the H2O/LiBr solution as a function of T and X_LiBr"
  //Based on SSC, i.e. http://fchart.com/ees/libr_help/ssclibr.pdf
  // Example calculation T = 25 °C, X = 0.5, --> = 3.807 cP = 0.003807 Pa.s.
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output DynamicViscosity eta "Dynamic viscosity";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[2] A = {-2.3212641667148, 3.190587778753};
  constant Real[2] B = {-609.44957160372, 963.16370163469};
  constant Real[2] C = {372994.85578423,  -35211.99698739};
  Real[2] X = {1, X_LiBr^2} "Aux. array";
  Real[3] T_aux = {T^(-i) for i in 0:2} "Aux. array";
algorithm
  eta := 1E-3*exp({A*X, B*X, C*X}*T_aux);
  annotation (Inline=true, smoothOrder = 10, derivative=Absolut.Media.LiBrH2O.dynamicViscosity_SSC_TX_der);
end dynamicViscosity_SSC_TX;
