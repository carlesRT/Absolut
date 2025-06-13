within Absolut.Media.LiBrH2O.Validation;
model MixingOfFluids
  "Mixing of fluid as defined in section 4.1 (Adiabatic mixing chamber) of Herold's book"
  extends Modelica.Icons.Example;
  package Medium_l = Modelica.Media.Water.WaterIF97_R1pT
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT
    "Refrigerant vapour medium";
  package Medium_sol = Absolut.Media.LiBrH2O
    "Solution medium";
  //
  parameter Integer n = 2 "Number of streams";
  parameter Modelica.Units.SI.Temperature T_eval[n]={273.15 + 50,273.15 + 50}
    "Temperature evaluation";
  parameter Modelica.Units.SI.MassFraction X_water[n]={1 - X_LiBr[1],1 - X_LiBr[
      2]} "Ratio of water";
  parameter Modelica.Units.SI.Pressure p_eval=10000 "Pressure in Pascals";
  parameter Modelica.Units.SI.MassFraction X_LiBr[n]={0.5,0.6};
  parameter Modelica.Units.SI.MassFlowRate m_dot[n]={1.5,7.5};
  Real t = time;

  Modelica.Units.SI.SpecificEnthalpy h_SSC[n]
    "Enthalpy entering streams 1 and 2";
  Modelica.Units.SI.MassFraction X_LiBr_out;

  // RESULTS
  Modelica.Units.SI.SpecificEnthalpy h_SSC3 "Enthalpy leaving stream 3";
  Modelica.Units.SI.Temperature T3 "Temperature leaving stream 3";

equation
  h_SSC[1] = Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
    T_eval[1],
    X_water[1],
    p_eval);
  h_SSC[2] = Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
    T_eval[2],
    X_water[2],
    p_eval);

   m_dot[1]*h_SSC[1] + m_dot[2]*h_SSC[2] = (m_dot[1] +  m_dot[2])*h_SSC3;

   m_dot[1]*X_LiBr[1] + m_dot[2]*X_LiBr[2] = (m_dot[1] +  m_dot[2])*X_LiBr_out;

  T3 = Absolut.Media.LiBrH2O.temperature(Absolut.Media.LiBrH2O.setState_phX(
    p_eval,
    h_SSC3,
    {1 - X_LiBr_out}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=16,
      Interval=0.1,
      Tolerance=1e-09),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p>Model based on example 4.1 on adiabatic mixing with water - Lithium bromide from [1]</p>
<p><br>Two streams are mixed: Stream 1 (with T = 50 degC, X_LiBr = 0.5 and a mass flow rate equal to 1.5 kg/s) is mixed with stream 2 (with T=50 degC, X_LiBr = 0.6 and m_2 = 7.5 kg/s). </p>
<p>Expected (reference) results [1],</p>
<ul>
<li>h1 = 107.3 J/g</li>
<li>h2 = 137.27 J/g</li>
<li>m = 9 kg/s</li>
<li>X_LiBr = 0.58333 </li>
<li>h3 = 132.28 J/g</li>
<li>T3=51.4 &deg;C</li>
</ul>
<p><br><b>References:</b></p>
<p>[1] Keith E. Herold, Reinhard Radermacher, Sanford A. Klein. Absorption chillers and heat pumps. ISBN 978-1-4987-1435-8.</p>
</html>"),
    __Dymola_Commands(file="Resources/Media/Validation/MixingOfFluids.mos" "Plot"));
end MixingOfFluids;
