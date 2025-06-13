within Absolut.Media.LiBrH2O.Validation;
model Pumping "Desorption of fluid as defined in section 4.7 of Herold's book"
  extends Modelica.Icons.Example;
  package Medium_l = Modelica.Media.Water.WaterIF97_R1pT
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT
    "Refrigerant vapour medium";
  package Medium_sol = Absolut.Media.LiBrH2O
    "Solution medium";

  //
  parameter Modelica.Units.SI.Pressure p_low=676 "Pressure in Pascals";
  parameter Modelica.Units.SI.Pressure p_high=7406 "Pressure in Pascals";
  parameter Real etha = 0.75 "Efficiency of the pump";
  parameter Modelica.Units.SI.MassFraction X_LiBr=0.5648;
  parameter Modelica.Units.SI.Temperature T=32.72 + 273.15;

  Modelica.Units.SI.MassFlowRate m_dot=0.05;
  Modelica.Units.SI.SpecificVolume v_low;
  Modelica.Units.SI.SpecificVolume v_high;
  Modelica.Units.SI.SpecificEnthalpy h;
  Modelica.Units.SI.EnergyFlowRate W "Electrical work, i.e. efficiency is considered";
  Modelica.Units.SI.EnergyFlowRate W_p
    "Pump work to the fluid based on pressure difference";

equation
  h = Absolut.Media.LiBrH2O.specificEnthalpy(Absolut.Media.LiBrH2O.setState_pTX(
    p_low,
    T,
    {1 - X_LiBr}));
  v_low = 1/Absolut.Media.LiBrH2O.density(Absolut.Media.LiBrH2O.setState_pTX(
    p_low,
    T,
    {1 - X_LiBr}));
  v_high = 1/Absolut.Media.LiBrH2O.density(Absolut.Media.LiBrH2O.setState_pTX(
    p_high,
    T,
    {1 - X_LiBr}));
  W = W_p/etha;
  W_p =(p_high - p_low)*v_high*m_dot;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=16,
      Interval=0.1,
      Tolerance=1e-09),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p>Model to test main equations that describe a solution pump. Equations based on section 4.7 [1]. Data for comparison based on table 6.1 [1].</p>
<p>The high pressure is 7.406 kPa and the low pressure is 0.676 kPa. The mass flow rate trough the pump is 0.05 kg/s. The inlet conditions are T = 32.72 &deg;C, X_LiBr = 0.5648.</p>
<p><br>Expected results according to [1],</p>
<ul>
<li>Pump power equal to 0.205 W</li>
</ul>
<p><br><b>References:</b></p>
<p>[1] Keith E. Herold, Reinhard Radermacher, Sanford A. Klein. Absorption chillers and heat pumps. ISBN 978-1-4987-1435-8.</p>
</html>"));
end Pumping;
