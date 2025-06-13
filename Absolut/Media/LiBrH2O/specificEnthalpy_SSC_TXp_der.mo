within Absolut.Media.LiBrH2O;
function specificEnthalpy_SSC_TXp_der
  "Specific enthalpy of the H2O/LiBr solution as a function of T and X_LiBr"
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure";
  input Real der_T "Derivative of temperature in the solution";
  input Real der_X_H2O "Derivative of water mass fraction in the solution";
  input Real der_p "Derivative of pressure";
  output Real der_h "Derivative of specific enthalpy of the solution";

algorithm
  der_h:=specificGibbsEnergy_TXp_der(
    T,
    X_H2O,
    p,
    der_T,
    der_X_H2O,
    der_p) - T*specificGibbsEnergy_TXp_derT_der(
    T,
    X_H2O,
    p,
    der_T,
    der_X_H2O,
    der_p)
    - der_T*specificGibbsEnergy_TXp_derT(
    T,
    X_H2O,
    p);
end specificEnthalpy_SSC_TXp_der;
