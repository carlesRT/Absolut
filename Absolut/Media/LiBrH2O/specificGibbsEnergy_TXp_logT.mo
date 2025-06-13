within Absolut.Media.LiBrH2O;
function specificGibbsEnergy_TXp_logT
  "specificGibbsEnergy of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Temperature T "Temperature (K) of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  output SpecificEnergy g "Specific gibbs energy of the solution";
protected
  MassFraction X_LiBr = max(0,1 - X_H2O) "LiBr mass fraction in the solution. Add max?";
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

 constant Real[4] coef = {5.494778053649050e-9,-9.87875764371065e-6,7.764896463836370e-3,4.114734407705330};
 Real[4] Tapprox = {T^3, T^2, T, 1};

 Real[5] X = {1,(X_LiBr*100),(X_LiBr*100)^2,(X_LiBr*100)^3,(X_LiBr*100)^1.1} "LiBr mass fraction in [%]";

algorithm
  g:= 1000 * (A*X + B*X*T + C*X*T^2 + D*X*T^3 + E*{1,X[2]}*T^4 + F*{1,X[2]}/(T-T0)
  + pkPa*(V[1] + V[2]*X[2] + V[3]*X[3] + V[4]*T + V[5]*X[2]*T + V[6]*X[3]*T + V[7]*T^2 + V[8]*X[2]*T^2)
  + coef*Tapprox*L*X + T*coef*Tapprox*M*X);
  annotation(smoothOrder = 10, derivative=Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_der);
end specificGibbsEnergy_TXp_logT;
