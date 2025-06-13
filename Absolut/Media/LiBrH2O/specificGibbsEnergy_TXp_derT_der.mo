within Absolut.Media.LiBrH2O;
function specificGibbsEnergy_TXp_derT_der
  "specificGibbsEnergy of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  input Real der_T "Temperature [K] of the solution";
  input Real der_X_H2O "Water mass fraction in the solution";
  input Real der_p "Pressure";

  output Real der_gderT "Derivative of temperature of specific gibbs energy";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O;
  Real pkPa = p/1000 "Pressure in kPa";
  Real der_pkPa = der_p/1000;

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

  Real[5] X = {0,1,2*(X_LiBr*100),3*(X_LiBr*100)^2,1.1*(X_LiBr*100)^0.1} "LiBr mass fraction in [%] = {0,1,2*X_LiBr,3*X_LiBr^0,2 ,1,1*X_LiBr^0,1}";

  Real[5] c_ = {0,1,2,3,1.1} "Exponent coef. for A, B and C";
  Real[5] X_ = {1,(X_LiBr*100),(X_LiBr*100)^2,(X_LiBr*100)^3,(X_LiBr*100)^1.1} "LiBr mass fraction in [%] = {1,X_LiBr,X_LiBr^2, ...}";

algorithm
  der_gderT:= 1000*(B*X + 2*T*C*X + 3*(T^2)*D*X + 4*E[2]*T^3 -F[2]/(T-T0)^2
  + pkPa*(V[5] + V[6]*X[3] + 2*V[8]*T)
  + (1/T)*L*X + (log(T)+1)*M*X)*(der_X_LiBr*100)
  + (specificGibbsEnergy_TXp_derT_derT(T,X_H2O,p))*der_T
  +1000*((V[4] + V[5]*X_[2] + V[6]*X_[3] + 2*V[7]*T + 2*V[8]*X_[2]*T))*der_pkPa;
  annotation(smoothOrder = 10);
end specificGibbsEnergy_TXp_derT_der;
