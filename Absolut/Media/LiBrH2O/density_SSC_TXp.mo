within Absolut.Media.LiBrH2O;
function density_SSC_TXp
  "Return density of the H2O/LiBr solution as a function of T, X_H2O and p"
  input Modelica.Units.SI.Temperature T "Temperature in K of the solution";
  input Modelica.Units.SI.MassFraction X_H2O
    "Water mass fraction in the solution";
  input Modelica.Units.SI.Pressure p "Pressure in pascals";
  output Modelica.Units.SI.Density rho "Density of the solution";

algorithm
  rho:= 1000/specificGibbsEnergy_TXp_derp(T,X_H2O,p);
    annotation(Inline=true, smoothOrder = 10, derivative=density_SSC_TXp_der);
end density_SSC_TXp;
