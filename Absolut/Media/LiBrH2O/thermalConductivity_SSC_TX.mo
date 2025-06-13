within Absolut.Media.LiBrH2O;
function thermalConductivity_SSC_TX
  "Thermal conductivity of the H2O/LiBr solution as a function of T and X_H2O"
  //http://fchart.com/ees/libr_help/ssclibr.pdf
  // Example calculation T = 25 °C, X = 0.5, --> lambda = 0.444 W/(m.K).
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output ThermalConductivity  lambda "Thermal conductivity";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[2] A = {-0.880453887702949, 0.883985046484968};
  constant Real[2] B = {0.00898659269884302, -0.007666522227789178};
  constant Real[2] C = {-1.55427759660091e-5, 1.38873506415764e-5};
  constant Real[2] D = {7.3203107999836e-9, -6.31953452062666e-9};

algorithm
  lambda := A[1] + A[2]*X_LiBr + B[1]*T + B[2]*T*X_LiBr + C[1]*T^2 + C[2]*T^2*X_LiBr + D[1]*T^3 + D[2]*T^3*X_LiBr;
  annotation(smoothOrder=10);
end thermalConductivity_SSC_TX;
