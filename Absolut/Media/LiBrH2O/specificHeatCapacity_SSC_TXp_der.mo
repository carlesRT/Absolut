within Absolut.Media.LiBrH2O;
function specificHeatCapacity_SSC_TXp_der
  "Specific heat capacity of the H2O/LiBr solution as a function of T and X_LiBr"
  // Based on SSC correlation!
  input Temperature T "Temperature in K of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure";
  input Real der_T "Temperature in K of the solution";
  input Real der_X_H2O "Water mass fraction in the solution";
  input Real der_p "Pressure";
  output Real der_cp "Specific heat capacity of the solution";
protected
  MassFraction X_LiBr = max(0,1 - X_H2O) "LiBr mass fraction in the solution";
  Real der_X_LiBr = -der_X_H2O;
  Real pkPa = p/1000 "Pressure in kPa";
  Real der_pkPa = der_p/1000;

algorithm
  der_cp :=
    specificHeatCapacity_SSC_TXp_derX(T,X_H2O,p)*(der_X_LiBr*100)
   +specificHeatCapacity_SSC_TXp_derT(T,X_H2O,p)*der_T
   +specificHeatCapacity_SSC_TXp_derp(T,X_H2O,p)*der_pkPa;

end specificHeatCapacity_SSC_TXp_der;
