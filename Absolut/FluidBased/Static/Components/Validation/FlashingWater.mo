within Absolut.FluidBased.Static.Components.Validation;
model FlashingWater
  extends Modelica.Icons.Example;

  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1pT annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2pT annotation (
     __Dymola_choicesAllMatching=true);

  // Reference values
  parameter Modelica.Units.SI.Temperature T_start_Book[6]=273.15*ones(6) + {45.817,45,35,25,15,5}
    "Inflow temperature";
  parameter Modelica.Units.SI.Temperature T_end_Book[6]= 273.15*ones(6) + {6.97,6.97,6.97,6.97,6.97,5.002} "Outflow temperature";
  parameter Real h_end_Book[6](each unit="J/g")={191.8, 188.4,146.6,104.8,62.9,21} "Outflow specific enthalpy";
  parameter Real Q_Book[6] = {0.065, 0.064, 0.047, 0.03, 0.014, 0} "Fraction of vapor";

  // Model
   Modelica.Blocks.Sources.RealExpression OpeningSignal(y=1)
    annotation (Placement(transformation(extent={{-90,-20},{-50,0}})));

  Absolut.FluidBased.Static.Components.FlashingWater flashingWater(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 9000,
    m_flow_nominal=1)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Fluid.Sources.MassFlowSource_T source(
    redeclare package Medium = Medium_l,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=1,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-22,40})));
  Modelica.Fluid.Sources.FixedBoundary sink_v(
    redeclare package Medium = Medium_v, T = 5+ 273.15,
    nPorts=1,
  p(displayUnit="kPa") = 1000) annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Modelica.Fluid.Sources.FixedBoundary sink_l(
    redeclare package Medium = Medium_l, T = 5+ 273.15,
    nPorts=1,
  p(displayUnit="kPa") = 1000)
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));

  Modelica.Blocks.Sources.CombiTimeTable ReferenceData(table=[0.0,T_start_Book[1],
        T_end_Book[1],h_end_Book[1],Q_Book[1]; 60,T_start_Book[1],T_end_Book[1],
        h_end_Book[1],Q_Book[1]; 60,T_start_Book[2],T_end_Book[2],h_end_Book[2],
        Q_Book[2]; 120,T_start_Book[2],T_end_Book[2],h_end_Book[2],Q_Book[2]; 120,
        T_start_Book[3],T_end_Book[3],h_end_Book[3],Q_Book[3]; 180,T_start_Book[
        3],T_end_Book[3],h_end_Book[3],Q_Book[3]; 180,T_start_Book[4],
        T_end_Book[4],h_end_Book[4],Q_Book[4]; 240,T_start_Book[4],T_end_Book[4],
        h_end_Book[4],Q_Book[4]; 240,T_start_Book[5],T_end_Book[5],h_end_Book[5],
        Q_Book[5]; 300,T_start_Book[5],T_end_Book[5],h_end_Book[5],Q_Book[5]; 300,
        T_start_Book[6],T_end_Book[6],h_end_Book[6],Q_Book[6]; 360,T_start_Book[
        6],T_end_Book[6],h_end_Book[6],Q_Book[6]], smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-100,26},{-80,46}})));
   Modelica.Blocks.Math.Gain h_out_ref(k=1000, y(unit="J/g", displayUnit="J/kg"))
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
   Modelica.Blocks.Math.Gain T_out_ref(k=1, y(unit="K"))
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
equation
  connect(source.ports[1], flashingWater.port_a)
    annotation (Line(points={{-12,40},{10,40},{10,-1}}, color={0,127,255}));
  connect(sink_l.ports[1], flashingWater.port_l_b) annotation (Line(points={{-10,-40},
          {5.2,-40},{5.2,-19}},       color={0,127,255}));
  connect(flashingWater.port_v_b, sink_v.ports[1])
    annotation (Line(points={{15,-19},{15,-40},{30,-40}},
                                                       color={0,127,255}));
  connect(OpeningSignal.y, flashingWater.opening)
    annotation (Line(points={{-48,-10},{0,-10}},
                                               color={0,0,127}));
  connect(ReferenceData.y[1], source.T_in)
    annotation (Line(points={{-79,36},{-34,36}}, color={0,0,127}));
  connect(ReferenceData.y[2], T_out_ref.u) annotation (Line(points={{-79,36},{-79,60},{-62,60}},
                                    color={0,0,127}));
  connect(ReferenceData.y[3], h_out_ref.u) annotation (Line(points={{-79,36},{-78,36},{-78,90},{-62,90}},
                                    color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model validation of trhottling valve for water based on example 4.7 on throttling process with pure fluid of [1]. </p>
<p>Pressure at the valve are fixed to 10 kPa (entrance) and 1 kPa (exit). Inlet temperature range from the saturation temperature (45.817 &deg;C) down to sufficient subcooling to ensure that the outlet state is still subcooled. </p>
<p>A total of five data points are defined. With help of a combitimetable, the data point evaluated is changed every 60 seconds. </p>
<p><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
    experiment(
      StopTime=420,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Resources\Static\Components\Validation\FlashingWater.mos"
        "Simulate and plot"));
end FlashingWater;
