within Absolut.Media.LiBrH2O.References;
function saturationPressure_Kaita_TX_der_der "Vapour pressure of the H2O/LiBr solution as a function of T and X_LiBr.
Based on Uemura and Hasaba"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Real der_T "Derivative of temperature of the solution";
  input Real der_X_H2O "Derivative of water mass fraction in the solution";
  input Real der_2_T "Derivative of temperature of the solution";
  input Real der_2_X_H2O "Derivative of water mass fraction in the solution";
  output Real der_2_p_v "vapour pressure of the solution in the vessel";

protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O "Derivative of LiBr mass fraction in the solution";
  Real der_2_X_LiBr = -der_2_X_H2O "Derivative of LiBr mass fraction in the solution";
  constant Real[3] k = {7.05, -1603.54, -104095.5};
  Temperature TD = Absolut.Media.LiBrH2O.dewPoint_Kaita_TX(    T, X_H2O);

algorithm

// derived equation is equalt to = 1000*(10^(k[1] + k[2]/(TD) +k[3]/(TD^2)));

der_2_p_v :=1000*log10(10)*(
(
log10(10)*(10^(k[1] + k[2]/(TD) +k[3]/(TD^2)))*(-(k[2]/TD^2)-(2*k[3]/TD^3)) * (-(k[2]/TD^2)-(2*k[3]/TD^3))
+ ((10^(k[1] + k[2]/(TD) +k[3]/(TD^2)))*(2*k[2]/TD^3)+(6*k[3]/TD^4)))*dewPoint_Kaita_TX_der(T,X_H2O,der_T,der_X_H2O)
+ (10^(k[1] + k[2]/(TD) +k[3]/(TD^2)))*(-(k[2]/TD^2)-(2*k[3]/TD^3))*dewPoint_Kaita_TX_der_der(T,X_H2O,der_T,der_X_H2O,der_2_T,der_2_X_H2O));

end saturationPressure_Kaita_TX_der_der;
