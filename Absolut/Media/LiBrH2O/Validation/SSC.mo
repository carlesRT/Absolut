within Absolut.Media.LiBrH2O.Validation;
model SSC
  "Functions are compared with single reference values given by LiBrSSC property routines library.
  Reference values are stored in position 1, calculated values in position 2"
  extends Modelica.Icons.Example;
  Modelica.Units.SI.DynamicViscosity eta[2] "Viscosity";
  Modelica.Units.SI.ThermalConductivity k[2] "Thermal Conductivity";
  Modelica.Units.SI.SpecificEnthalpy h[2] "Enthalpy of Aqueous Lithium Bromide";
  Modelica.Units.SI.SpecificEntropy s[2] "Entropy of Aqueous Lithium Bromide";
  Modelica.Units.SI.SpecificHeatCapacity cp[2]
    "Specific heat capacity of Aqueous Lithium Bromide";
  Modelica.Units.SI.SpecificVolume v[2]
    "Specific volume of Aqueous Lithium Bromide";
  Modelica.Units.SI.SpecificEnergy gw[2];
  Modelica.Units.SI.SpecificEnergy gs[2]
    "Chemical Potential in Aqueous Lithium Bromide";
  Modelica.Units.SI.Pressure psat[2] "Saturation pressure";
  Modelica.Units.SI.SpecificEnergy hw[2];
  Modelica.Units.SI.SpecificEnergy hs[2]
    "Partial Enthalpy in Aqueous Lithium Bromide";
  Real dhdx[2], dhdx_A, dhdx_B;

equation
  // Viscosity
  eta[1] = 3.807 * (1/10^3);
  eta[2] = Absolut.Media.LiBrH2O.dynamicViscosity(
    Absolut.Media.LiBrH2O.setState_pTX(
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5),
    298.15,
    {0.5}));
  // Thermal Conductivity
  k[1] = 0.444;
  k[2] = Absolut.Media.LiBrH2O.thermalConductivity(
    Absolut.Media.LiBrH2O.setState_pTX(
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5),
    298.15,
    {0.5}));
  // Enthalpy of Aqueous Lithium Bromide
  h[1] = 52.92 * 1000;
  h[2] = Absolut.Media.LiBrH2O.specificEnthalpy(
    Absolut.Media.LiBrH2O.setState_pTX(
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5),
    298.15,
    {0.5}));
  // Entropy of Aqueous Lithium Bromide
  s[1] = 0.1853 * 1000;
  s[2] = Absolut.Media.LiBrH2O.specificEntropy(
    Absolut.Media.LiBrH2O.setState_pTX(
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5),
    298.15,
    {0.5}));
  // Specific heat capacity of Aqueous Lithium Bromide
  cp[1] = 2151;
  cp[2] = Absolut.Media.LiBrH2O.specificHeatCapacityCp(
    Absolut.Media.LiBrH2O.setState_pTX(
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5),
    298.15,
    {0.5}));
  // Specific volume of Aqueous Lithium Bromide
  v[1] = 0.0006523;
  v[2] = 1/Absolut.Media.LiBrH2O.density(Absolut.Media.LiBrH2O.setState_pTX(
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5),
    298.15,
    {0.5}));
  // Chemical Potential in Aqueous Lithium Bromide
  gw[1] = -191.6 * 1000;
  gs[1] = 186.9 * 1000;
  gw[2] = Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    298.15,
    0.5,
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5));
  gs[2] = Absolut.Media.LiBrH2O.chemicalPotential_s_TXp(
    298.15,
    0.5,
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5));
  // Partial Enthalpy in Aqueous Lithium Bromide
  hw[1] = -44.25 * 1000;
  hs[1] = 150.1 * 1000;
  dhdx[1] = 1.944;
  dhdx[2] = dhdx_A + dhdx_B;
  dhdx_A = (1/1000)*Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_derX(
    298.15,
    0.5,
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5));
  dhdx_B = -298.15*Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_derT_derX(
    298.15,
    0.5,
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5));

  hw[2] = Absolut.Media.LiBrH2O.specificEnthalpy(
    Absolut.Media.LiBrH2O.setState_pTX(
    Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5),
    298.15,
    {0.5})) - 50*1000*dhdx[2];
  hs[2] = 0;
  // Saturation Properties of Aqueous Lithium Bromide
  psat[1] = 0.8071*1000;
  psat[2] = Absolut.Media.LiBrH2O.saturationPressure_TX(298.15, 0.5);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model for validation purposes. </p>
<p>Comparison with values pusblished in [1] for different properties: Thermal conductivity, dynamic viscosity, specific volume, ...</p>
<p>Variables are vectorized, first element corresponds to the reference value. Second value corresponds to the implementend functions.</p>
<p><br><b>References:</b></p>
<p>[1] LiBrSSC (aquous lithium bromide) Property Routines. <a href=\"https://fchart.com/ees/libr_help/ssclibr.pdf\">https://fchart.com/ees/libr_help/ssclibr.pdf</a></p>
</html>"),
    __Dymola_Commands(file="Resources/Media/Validation/SSC_plot.mos" "Plot"));
end SSC;
