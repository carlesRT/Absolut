within Absolut.Media.LiBrH2O.Validation;
model cp
  "cp values to be compared with data from \"Specific Heat Measurements on Aqueous Lithium Bromide\""
  extends Modelica.Icons.Example;
  package Medium_v = Modelica.Media.Water.WaterIF97_R2ph;

  Modelica.Units.SI.SpecificHeatCapacity cp0;
  Modelica.Units.SI.SpecificHeatCapacity cp5;
  Modelica.Units.SI.SpecificHeatCapacity cp10;
  Modelica.Units.SI.SpecificHeatCapacity cp20;
  Modelica.Units.SI.SpecificHeatCapacity cp30;
  Modelica.Units.SI.SpecificHeatCapacity cp40;
  Modelica.Units.SI.SpecificHeatCapacity cp50;
  Modelica.Units.SI.SpecificHeatCapacity cp60;
  Modelica.Units.SI.SpecificHeatCapacity cp65;
  Modelica.Units.SI.SpecificHeatCapacity cp70;
  Modelica.Units.SI.SpecificHeatCapacity cp748;
  Modelica.Units.SI.Pressure p0;
  Modelica.Units.SI.Pressure p5;
  Modelica.Units.SI.Pressure p10;
  Modelica.Units.SI.Pressure p20;
  Modelica.Units.SI.Pressure p30;
  Modelica.Units.SI.Pressure p40;
  Modelica.Units.SI.Pressure p50;
  Modelica.Units.SI.Pressure p60;
  Modelica.Units.SI.Pressure p65;
  Modelica.Units.SI.Pressure p70;
  Modelica.Units.SI.Pressure p748;
  Modelica.Units.SI.Temperature T;
  Real T_degC;

equation
  T = min(10 + 273.15 + time*1, 260+273.15);
  T_degC = T - 273.15;

// Pressure.
// Medium R2ph is used instead of _ph (used in Absolut.Media.LiBrH2O_inv.saturationPressure_TX) due to limits on temperature values.
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p0,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1,
    p0);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p5,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.05,
    p5);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p10,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.1,
    p10);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p20,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.2,
    p20);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p30,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.3,
    p30);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p40,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.4,
    p40);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p50,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.5,
    p50);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p60,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.6,
    p60);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p65,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.65,
    p65);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p70,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.7,
    p70);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(
    p=p748,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    1 - 0.748,
    p748);

// Specific heat capacity
  cp0 = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1,
    p0);
  cp5 = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.05,
    p5);
  cp10 = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.1,
    p10);
  cp20 = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.2,
    p20);
  cp30 = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.3,
    p30);
  cp40 = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.4,
    p40);
  cp50 = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.5,
    p50);
  cp60 = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.6,
    p60);
  cp65 = if T >= 273.15 + 40 then
    Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.65,
    p65) else 0;
  cp70 = if T >= 273.15 + 130 then
    Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.7,
    p70) else 0;
  cp748 = if T >= 273.15 + 170 then
    Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
    T,
    1 - 0.748,
    p748) else 0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=250,
      Interval=1,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),__Dymola_Commands(file="modelica://Absolut/Resources/Media/Validation/cp/cp.mos"
        "Simulate and export cp values for validation purposes", file="Resources/Media/Validation/cp/cp_plot.mos" "Plot"),
    Documentation(info="<html>
<p>This model is used to calculate the specific heat capacity for different mass fractions of LiBr at equilibrium for different temperatures. </p>
<p>The points calculated correspond (to be compared with) to the ones published by Yuan Z. and Herold K.E. in [1], see Table 1. </p>
<p><br><b>References:</b></p>
<p>[1] Z. Yuan &amp; K.E. Herold (2005) Specific Heat Measurements on Aqueous Lithium Bromide, HVAC&amp;R Research, 11:3, 361-375. </p>
</html>"));
end cp;
