within Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.CheckThermalOil;
model Pr

Real Pr_w "Prandtl number for water";
Real Pr_oil "Prandtl number for oil";

Real Re_w "Prandtl number for water";
Real Re_oil "Prandtl number for oil";

  Modelica.Units.SI.SpecificHeatCapacity cp_w, cp_oil;
  Modelica.Units.SI.ThermalConductivity k_w, k_oil;
  Modelica.Units.SI.Density rho_w, rho_oil;
  Modelica.Units.SI.KinematicViscosity nu_w, nu_oil;
  Modelica.Units.SI.DynamicViscosity eta_w, eta_oil;

  Modelica.Units.SI.Temperature T = 273.15 + 5 + 1*time;
  Modelica.Units.SI.Pressure p = 400000;

 package Medium =
      Absolut.FluidBased.Dynamic.LabValidation.ThermalOil;
 Medium.ThermodynamicState state_oil;

package Medium_w = Modelica.Media.Water.WaterIF97_pT;
Medium_w.ThermodynamicState state_w;

Real cp_ratio = cp_oil/cp_w;

Modelica.Units.SI.MassFlowRate m_oil = 1;
Modelica.Units.SI.MassFlowRate m_w = m_oil*cp_ratio;
Modelica.Units.SI.Area A = 1;

Modelica.Units.SI.Velocity v_w, v_oil;

equation
  state_oil = Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.setState_pTX(
    p, T);
  state_w = Modelica.Media.Water.WaterIF97_pT.setState_pTX(p,T);

  v_w = m_w/rho_w/A;
  v_oil = m_oil/rho_oil/A;

  Pr_w = cp_w * eta_w / k_w;
  Pr_oil = cp_oil * eta_oil / k_oil;

  Re_w = rho_w * v_w * A / eta_w;
  Re_oil = rho_oil * v_oil * A / eta_oil;

  nu_w = eta_w/rho_w;
  nu_oil =
    Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.kinematicViscosity(T);

  eta_w = Modelica.Media.Water.WaterIF97_pT.dynamicViscosity(state_w);
  eta_oil =
    Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.dynamicViscosity(
    state_oil);

  k_w = Modelica.Media.Water.WaterIF97_pT.thermalConductivity(state_w);
  k_oil =
    Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.thermalConductivity(
    state_oil);

  rho_w = Modelica.Media.Water.WaterIF97_pT.density(state_w);
  rho_oil = Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.density(
    state_oil);

  cp_w = Modelica.Media.Water.WaterIF97_pT.specificHeatCapacityCp(state_w);
  cp_oil =
    Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.specificHeatCapacityCp(
    state_oil);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=100,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end Pr;
