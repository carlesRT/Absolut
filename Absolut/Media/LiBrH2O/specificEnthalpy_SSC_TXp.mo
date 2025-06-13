within Absolut.Media.LiBrH2O;
function specificEnthalpy_SSC_TXp
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure";
  output SpecificEnthalpy h "Specific enthalpy of the solution";

algorithm
  // Temperature is limited to 1100 K. Otherwise inverse will not work and find very high temperatures as solution!
  // E.g. h with T=1238 degC = h with T = 52.8 degC
  // inverse(T = specificEnthalpy_SSC_TXp_inv(h,X_H2O,p)

  h:=specificGibbsEnergy_TXp(
    min(1100,T),
    X_H2O,
    p) - min(1100,T)*specificGibbsEnergy_TXp_derT(
    min(1100,T),
    X_H2O,
    p);
    annotation(Inline=true, smoothOrder = 10, derivative=Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp_der, inverse(T = specificEnthalpy_SSC_TXp_inv(h,X_H2O,p)));
end specificEnthalpy_SSC_TXp;
