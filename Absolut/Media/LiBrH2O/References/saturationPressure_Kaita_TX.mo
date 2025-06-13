within Absolut.Media.LiBrH2O.References;
function saturationPressure_Kaita_TX "Vapour pressure of the H2O/LiBr solution as a function of T and X_LiBr.
Based on Uemura and Hasaba"
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output AbsolutePressure p_v "vapour pressure of the solution in the vessel";

protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[3] k = {7.05, -1603.54, -104095.5};
  Temperature TD = Absolut.Media.LiBrH2O.dewPoint_Kaita_TX(    T, X_H2O);

algorithm

 p_v := 1000*(10^(k[1] + k[2]/(TD) +k[3]/(TD^2)));

 annotation (derivative=Absolut.Media.LiBrH2O.References.saturationPressure_Kaita_TX_der);
end saturationPressure_Kaita_TX;
