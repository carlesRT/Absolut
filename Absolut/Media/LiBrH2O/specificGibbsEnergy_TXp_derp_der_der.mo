within Absolut.Media.LiBrH2O;
function specificGibbsEnergy_TXp_derp_der_der
  "Derivative of pressure for specificGibbsEnergy of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  input Real der_T "Temperature [K] of the solution";
  input Real der_X_H2O "Water mass fraction in the solution";
  input Real der_p "der p";
  input Real der_2_T "Temperature [K] of the solution";
  input Real der_2_X_H2O "Water mass fraction in the solution";
  input Real der_2_p "der2 p";
  output Real der_2_gderp "Specific gibbs energy of the solution";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O "LiBr mass fraction in the solution";
  Real der_2_X_LiBr = -der_2_X_H2O "LiBr mass fraction in the solution";
  Real pkPa = p/1000 "Pressure in kPa";
  constant Real[5] A = {5.506219979e3, 5.213228937e2, 7.774930356, -4.575233382e-2, -5.792935726e2};
  constant Real[5] B = {1.452749674e2, -4.984840771e-1, 8.83691918e-2, -4.870995781e-4, -2.905161205};
  constant Real[5] C = {2.648364473E-2, -2.311041091E-3, 7.559736620E-6, -3.763934193E-8, 1.176240649E-3};
  constant Real[5] D = {-8.526516950e-6, 1.320154794e-6, 2.791995438e-11, 0, -8.511514931e-7};
  constant Real[2] E = {-3.840447174e-11, 2.625469387e-11};
  constant Real[2] F = {-5.159906276e1, 1.114573398};
  constant Real[5] L = {-2.183429482e3,-1.266985094e2,-2.364551372,1.389414858e-2,1.583405426e2};
  constant Real[5] M = {-2.267095847e1,2.983764494e-1,-1.259393234e-2,6.849632068e-5,2.767986853e-1};
  constant Real[8] V = {1.176741611e-3,-1.002511661e-5,-1.695735875e-8,-1.497186905e-6,2.538176345e-8,5.815811591e-11,3.057997846e-9,-5.129589007e-11};
  constant Temperature T0 = 220.0 "Reference temperature";

  Real[5] c = {0,1,2,3,1.1} "Exponent coef. for A, B and C";
  //Real[5] X = {(X_LiBr*100)^c[i] for i in 1:5} "LiBr mass fraction in [%]";
  Real[5] X = {1,(X_LiBr*100),(X_LiBr*100)^2,(X_LiBr*100)^3,(X_LiBr*100)^1.1} "LiBr mass fraction in [%]";

algorithm
  der_2_gderp:=
  ((2*V[3] + 2*V[6]*T)*(der_X_LiBr*100)
  +(V[5] + 2*V[6]*X[2] + 2*V[8]*T)*der_T)*1000*(der_X_LiBr*100)
  + specificGibbsEnergy_TXp_derp_derX(T,X_H2O,p)*(der_2_X_LiBr*100)
  +((V[5] + 2*V[6]*X[2] + 2*V[8]*T)*(der_X_LiBr*100)
  + (2*V[7] + 2*V[8]*X[2])*der_T)*1000*der_T
  +specificGibbsEnergy_TXp_derp_derT(T,X_H2O,p)*der_2_T;
  annotation(smoothOrder = 10);
end specificGibbsEnergy_TXp_derp_der_der;
