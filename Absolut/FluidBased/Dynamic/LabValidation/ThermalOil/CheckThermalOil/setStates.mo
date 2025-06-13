within Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.CheckThermalOil;
model setStates

    package Medium =
      Absolut.FluidBased.Dynamic.LabValidation.ThermalOil;
 Medium.ThermodynamicState state;
 Modelica.Units.SI.SpecificEnthalpy h;
 Modelica.Units.SI.SpecificHeatCapacity cp;
 Modelica.Units.SI.Density rho;

 Modelica.Units.SI.Temperature T = (273.15-20) + 380/380 * time;

equation

  state = Medium.setState_pTX(1,T);
  h = Medium.specificEnthalpy(state);
  cp = Medium.specificHeatCapacityCp(state);
  rho = Medium.density(state);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=380,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end setStates;
