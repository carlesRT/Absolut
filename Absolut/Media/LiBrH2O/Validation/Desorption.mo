within Absolut.Media.LiBrH2O.Validation;
model Desorption
  "Desorption of fluid as defined in section 4.3 (Generation of vapor from condensed phase) following example 4.3 of Herold's book"
  extends Modelica.Icons.Example;
  package Medium_l = Modelica.Media.Water.WaterIF97_R1pT
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT
    "Refrigerant vapour medium";
  package Medium_sol = Absolut.Media.LiBrH2O
    "Solution medium";

  //
  parameter Modelica.Units.SI.Temperature T_eval=273.15 + 50
    "Temperature evaluation";
  parameter Modelica.Units.SI.MassFraction X_water_in=1 - X_LiBr_in
    "Ratio of water";
  parameter Modelica.Units.SI.Pressure p_eval=10000 "Pressure in Pascals";
  parameter Modelica.Units.SI.MassFraction X_LiBr_in=0.55;
  parameter Modelica.Units.SI.MassFraction X_LiBr_out=0.6;
  parameter Modelica.Units.SI.MassFlowRate m_dot_in=1;
  Real t = time;

  Modelica.Units.SI.HeatFlowRate Q_vap "Heat of vaporitzation";
  Modelica.Units.SI.HeatFlowRate Q_sen "Sensible heat";
  Modelica.Units.SI.HeatFlowRate Q "Overall needed heat";

  parameter Integer n = 3 "number of streams";
  Modelica.Units.SI.SpecificEnthalpy h_SSC[n]
    "Entering streams 1. Leaving stream 2 and 3";
  Modelica.Units.SI.MassFraction X_LiBr[n];
  Modelica.Units.SI.Temperature T[n];
  Modelica.Units.SI.Temperature T1s;
  Modelica.Units.SI.SpecificEnthalpy h_SSC_1s "Entering streams 1s";

  Modelica.Units.SI.MassFlowRate m_dot[n];

  Real f = m_dot[1]/m_dot[2] "Mass flow rate ratio";
  Real f_X = ((1-X_LiBr[2])-(1-X_LiBr[3]))/((1-X_LiBr[1]) - (1-X_LiBr[3])) "Mass flow ratio calculated using X_LiBr concentrations";
  Modelica.Units.SI.SpecificEnthalpy h_d = h_SSC[3] - f*(h_SSC[3] - h_SSC[1])
    "Enthalpy d";
equation
// Inflow,
  m_dot[1] = m_dot_in;
  T1s = T_eval;
  T[1] = Absolut.Media.LiBrH2O.temperature_Xp(1 - X_LiBr[1], p_eval);
  T[2] = T[1];
  T[3] = Absolut.Media.LiBrH2O.temperature_Xp(1 - X_LiBr[3], p_eval);
  X_LiBr[1] = X_LiBr_in;
  X_LiBr[2] = 0;
  X_LiBr[3] = X_LiBr_out;
  h_SSC_1s = Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
    T1s,
    X_water_in,
    p_eval);

  h_SSC[1] = Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
    T[1],
    X_water_in,
    p_eval);

  h_SSC[2] = Medium_v.specificEnthalpy_pTX(p_eval,T[1],{1});

  h_SSC[3] = Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
    T[3],
    1 - X_LiBr[3],
    p_eval);

   m_dot[1]*h_SSC[1] + Q_vap = m_dot[2]*h_SSC[2] + m_dot[3]*h_SSC[3];
   m_dot[1] = m_dot[2] + m_dot[3];
   m_dot[1]*X_LiBr[1]  = m_dot[2]*X_LiBr[2] + m_dot[3]*X_LiBr[3];

   Q_sen = m_dot[1]*(h_SSC[1] - h_SSC_1s);

   Q_sen + Q_vap = Q;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=16,
      Interval=0.1,
      Tolerance=1e-09),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p>Model based on example 4.3 on desorption of water from aqueous Lithium bromide from [1]</p>
<p><br>A Liquid stream (1) enters the chamber (desorber) and it is heated up. Vapor (2) and liquid (3) leaves the chamber.</p>
<p>The desorber is operated at 10 kPa. Pressure losses are negligible.</p>
<ul>
<li>Point 1: T = 50 degC, XLiBr = 0.55, m = 1 kg/s</li>
<li>Point 3: Saturated conditions. XLiBr = 0.6.</li>
</ul>
<p>Expected results according to [1],</p>
<ul>
<li>m2 = 0.0833 kg/s</li>
<li>m3 = 0.9167 kg/s</li>
<li>Q = 302.1 kW (from which 63 kW are for sensible heat and 239.1 kW for vaporitzation)</li>
<li>h1 = 117.5 J/g</li>
<li>h2 = 216.9 J/g</li>
<li>h3 = 2650 J/g<br></li>
</ul>
<h4>References:</h4>
<p>[1] Keith E. Herold, Reinhard Radermacher, Sanford A. Klein. Absorption chillers and heat pumps. ISBN 978-1-4987-1435-8.</p>
</html>"),
    __Dymola_Commands(file="Resources/Media/Validation/Desorption.mos" "Plot"));
end Desorption;
