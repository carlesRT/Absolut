within Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.CheckThermalOil;
model PropertiesExport

    package Medium =
      Absolut.FluidBased.Dynamic.LabValidation.ThermalOil;
 Medium.ThermodynamicState state;
 Modelica.Units.SI.SpecificEnthalpy h;
 Modelica.Units.SI.SpecificHeatCapacity cp;
 Modelica.Units.SI.Density rho;

 Modelica.Units.SI.Temperature T = (273.15-20) + 380/380 * time;
 Modelica.Units.SI.ThermalConductivity k;
 Modelica.Units.SI.DynamicViscosity mu, mu_calc;
 Modelica.Units.SI.KinematicViscosity kinematicmu;
 Modelica.Units.SI.KinematicViscosity kinematicmu20, kinematicmu100;

 Real Beta0, Beta100, Beta200;

equation

  state = Medium.setState_pTX(100000,T);
  h = Medium.specificEnthalpy(state);
  cp = Medium.specificHeatCapacityCp(state);
  k = Medium.thermalConductivity(state);
  mu = Medium.dynamicViscosity(state);
  mu_calc = kinematicmu * rho;
  kinematicmu = Medium.kinematicViscosity(T);
  rho = Medium.density(state);

  kinematicmu20 = Medium.kinematicViscosity(293.15);
  kinematicmu100 = Medium.kinematicViscosity(373.15);

  Beta0 = Medium.isobaricExpansionCoefficient(Medium.setState_pTX(100000,273.15));
  Beta100 = Medium.isobaricExpansionCoefficient(Medium.setState_pTX(100000,100 + 273.15));
  Beta200 = Medium.isobaricExpansionCoefficient(Medium.setState_pTX(100000,200 + 273.15));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=380,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end PropertiesExport;
