within Absolut.Media.LiBrH2O;
function dewPoint_Kaita_TX
  "Dew point of the LiBr+H2O solution as a function of T and X_LiBr"
  //Proposed equation by Y. Kaita (2001) Thermodynamic proeprties of lithium ...”
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "LiBr mass fraction in the solution";
  output Temperature D "Dew Point of the LiBr solution = Dew Point of water";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[4] A1 = {-9.133128, -4.759724E-1,-5.638171E-2, 1.108418E-3};
  constant Real[4] A2 = {9.439697E-1, -2.882015E-3, -1.345453E-4, 5.852133E-7};
  constant Real[4] A3 = {-7.324352E-5, -1.556533E-5, 1.992657E-6, -3.924205E-8};
  Modelica.Units.NonSI.Temperature_degC Tc[3]={(T - 273.15)^i for i in 0:2}
    "Temperature [C] of the solution";
  Real[4] X = {(X_LiBr*100-40)^j for j in 0:3} "Aux. array = {1, ...}";
algorithm
  D := 273.15 + {A1*X,A2*X,A3*X}*Tc;
  annotation(derivative=Absolut.Media.LiBrH2O.dewPoint_Kaita_TX_der);
end dewPoint_Kaita_TX;
