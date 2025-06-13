within Absolut.Media.LiBrH2O.Validation;
model CondensationEvaporation
  "Desorption of fluid as defined in section 4.5. Values of example 4.6 are used. Herold's book"
  extends Modelica.Icons.Example;
  package Medium_l = Modelica.Media.Water.WaterIF97_R1ph
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2ph
    "Refrigerant vapour medium";

//
  parameter Modelica.Units.SI.Pressure p_c=10000
    "Pressure level at condenser in Pascals";
  parameter Modelica.Units.SI.Pressure p_e=1000
    "Pressure at evaporator in Pascals";
  Real t = time;

  parameter Modelica.Units.SI.MassFlowRate m_dot=0.15 "";
  parameter Modelica.Units.SI.Temperature T_in= 50 + 273.15 "";

  Modelica.Units.SI.SpecificEnthalpy h_SCC_7;
  Modelica.Units.SI.SpecificEnthalpy h_SSC_8;
  Modelica.Units.SI.SpecificEnthalpy h_SSC_9;
  Modelica.Units.SI.SpecificEnthalpy h_SSC_10
    "Enthalpy at different positions (states)";
  Modelica.Units.SI.Temperature T_e_in
                                      "";
  Modelica.Units.SI.HeatFlowRate Q_e;
  Modelica.Units.SI.HeatFlowRate Q_c;

  Modelica.Units.SI.Temperature T_sat_c;
  Modelica.Units.SI.Temperature T_sat_e;
equation

   h_SCC_7 = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p_c,T_in,{1}));
   T_sat_c = Modelica.Media.Water.WaterIF97_ph.saturationTemperature(p_c);
   h_SSC_8 = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_c,T_sat_c,{1}));
   Q_c = m_dot*(h_SCC_7 - h_SSC_8);

   h_SSC_9 = h_SSC_8;
   h_SSC_9 = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_e,T_e_in,{1}));

   T_sat_e = Modelica.Media.Water.WaterIF97_ph.saturationTemperature(p_e);
   h_SSC_10 = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p_e,T_sat_e,{1}));

   Q_e = m_dot*(h_SSC_10 - h_SSC_9);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=16,
      Interval=0.1,
      Tolerance=1e-09),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p><br>Model to test main equations that describe a condensation and evaporation of water based on example 4.6 [1].</p>
<p>The high pressure is 10 kPa and the low pressure is 1 kPa. The mass flow rate the condenser is 0.15 kg/s and the inlet temperature is 50 &deg;C.</p>
<p><br>Expected results according to [1]</p>
<ul>
<li>h7 = 2591.8 J/g</li>
<li>h8 = 191.8 J/g (h9 = h8) </li>
<li>Qc = 360 kW </li>
<li>h10 = 2513.3 J/g </li>
<li>Qe = 348.2 kW<br></li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">References:</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Keith E. Herold, Reinhard Radermacher, Sanford A. Klein. Absorption chillers and heat pumps. ISBN 978-1-4987-1435-8.</span></p>
</html>"));
end CondensationEvaporation;
