﻿within Absolut.Media.LiBrH2O.References;
function density_Chua_TX
  "Return density from T, and X or XiDensity of the H2O/LiBr solution as a function of T and X_LiBr"
  //Chua, H. T. et. al. 2000. “Improved Thermodynamic Property Fields of LiBr-H2O Solution"
  input Modelica.Units.SI.Temperature T "Temperature [K] of the solution";
  input Modelica.Units.SI.MassFraction X_H2O
    "Water mass fraction in the solution";
  output Modelica.Units.SI.Density rho "Density of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[5] A = {9.991e2, 7.74931e0, 5.36509e-3, 1.34988e-3, -3.08671e-6};
  constant Real[5] B = {-2.39865e-2, -1.28346e-2, 2.07323e-4, -9.08213e-6, 9.94788e-8};
  constant Real[5] C = {-3.90453e-3, -5.55855e-5, 1.09879e-5, -2.39834e-7, 1.53514e-9};
  Real[5] X = {(X_LiBr*100)^i for i in 0:4} "Aux. array";
  Real[3] Tc = {(T-273.15)^i for i in 0:2} "Aux. array";
algorithm
  rho:= {A*X, B*X, C*X}*Tc;
  annotation (derivative=Absolut.Media.LiBrH2O.References.density_Chua_TX_der);
end density_Chua_TX;
