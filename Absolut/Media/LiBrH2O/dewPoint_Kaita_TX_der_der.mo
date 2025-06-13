within Absolut.Media.LiBrH2O;
function dewPoint_Kaita_TX_der_der
  "Dew point of the LiBr+H2O solution as a function of T and X_LiBr"
  //Proposed equation by Y. Kaita (2001) Thermodynamic proeprties of lithium ...”
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "LiBr mass fraction in the solution";
  input Real der_T "Temperature [K] of the solution";
  input Real der_X_H2O "LiBr mass fraction in the solution";
  input Real der_2_T "Temperature [K] of the solution";
  input Real der_2_X_H2O "LiBr mass fraction in the solution";
  output Real der_2_D "Dew Point of the LiBr solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = - der_X_H2O "LiBr mass fraction in the solution";
  Real der_2_X_LiBr = - der_2_X_H2O "LiBr mass fraction in the solution";
  constant Real[4] A1 = {-9.133128, -4.759724E-1,-5.638171E-2, 1.108418E-3};
  constant Real[4] A2 = {9.439697E-1, -2.882015E-3, -1.345453E-4, 5.852133E-7};
  constant Real[4] A3 = {-7.324352E-5, -1.556533E-5, 1.992657E-6, -3.924205E-8};
  Modelica.Units.NonSI.Temperature_degC Tc[3]={(T - 273.15)^i for i in 0:2}
    "Temperature [C] of the solution";
  Real[4] X = {(X_LiBr*100-40)^j for j in 0:3} "Aux. array";

  Real[4] b_ = {0,1,2,3};
  Real[4] X_ = {b_[j+1]*(X_LiBr*100-40)^(j-1) for j in 0:3} "Aux. array";
  Modelica.Units.NonSI.Temperature_degC Tc_[3]={(T - 273.15)^(i) for i in 0:2}
    "Temperature [C] of the solution";

algorithm
  der_2_D := ((2*A1[3] + 2*A1[4]*X[2] + 2*A2[3]*Tc_[2] + 2*A2[4]*X[2]*Tc_[2] + 2*A3[3]*Tc_[3] + 2*A3[4]*X[2]*Tc_[3])*(der_X_LiBr*100)
  + (A2[2]+2*A2[3]*X[2] + 3*A2[4]*X[3] + 2*A3[2]*Tc_[2] + 4*A3[3]*X[2]*Tc_[2] + 6*A3[4]*X[3]*Tc_[2])*der_T)
  *(der_X_LiBr*100)
  + (A1[2] + 2*A1[3]*X[2] + 3*A1[4]*X[3] + A2[2]*Tc_[2] + 2*A2[3]*Tc_[2]*X[2] + 3*A2[4]*Tc_[2]*X[3]
  +  A3[2]*Tc_[3] + 2*A3[3]*X[2]*Tc_[3] + 3*A3[4]*X[3]*Tc_[3])*(der_2_X_LiBr*100)
  + ((A2[2]+2*A2[3]*X[2] + 3*A2[4]*X[3] + 2*A3[2]*Tc_[2]+4*A3[3]*X[2]*Tc_[2]+6*A3[4]*X[3]*Tc_[2])*(der_X_LiBr*100)
  + (2*A3[1] + 2*A3[2]*X[2] + 2*A3[3]*X[3] + 2*A3[4]*X[4])*der_T)*der_T
  + (A2[1] +A2[2]*X[2] + A2[3]*X[3] +A2[4]*X[4] + 2*A3[1]*Tc_[2] +2*A3[2]*X[2]*Tc_[2] + 2* A3[3]*X[3]*Tc_[2] + 2*A3[4]*X[4]*Tc_[2])*der_2_T;

end dewPoint_Kaita_TX_der_der;
