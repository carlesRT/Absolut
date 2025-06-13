within Absolut.FluidBased.Static.TypeII.Validation;
model AHPTypeII_UAfix_HXeps "Single effect Type II"
extends Modelica.Icons.Example;

  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1";

 // Reference data

 Modelica.Units.SI.HeatFlowRate P[2] = {7,51.3} "Pumps power, Wr: water/refrigerant and Ws: solution";
  Real COP_ref = 0.495 "Coefficient of performance";
  Modelica.Units.NonSI.Temperature_degC T[20]=
  {102.41, 120.93, 153.90, 149.67, 111.63, 111.6,
  102.41, 55.02, 55.02, 101.09, 135, 146.02, 120,
  108.92, 120, 108.8, 30, 41.26, 101.09, 164.01};

  Modelica.Units.SI.Pressure p_ref[2] = {15766, 105328} "Pressure";
  Modelica.Units.SI.HeatFlowRate Q_flow[5] = {
  -185400, 184400, 188300, -187300, 70800} "Heat flow rate at Desober, Absorber, Condenser, Evaporator and Solution HX";

  Real Q1 = 0.014 "Vapour quality at point 1";

  Real X_LiBr_w = 0.5944 "X_LiBr of weak solution at e.g. point 1";
  Real X_LiBr_s = 0.6399 "X_LiBr of strong solution at e.g. point 4";

 // Model

  Modelica.Blocks.Sources.RealExpression m_s(y=1)
    annotation (Placement(transformation(extent={{160,-10},{140,10}})));
  TypeII.AbsorberStatic_wHT_UAfix_TypeII_ext abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="kPa") = 105328,
    T_start(displayUnit="K") = 426.9,
    X_LiBr_start=0.5944,
    p(displayUnit="kPa"),
    dT_used(start=18.44),
    UA=10000,
    port_l_b(m_flow(start=-1.077))) annotation (Placement(transformation(extent={{58,76},{78,96}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness
                      hex(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.04543,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    eps=0.9)                          annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={52,42})));
  Modelica.Fluid.Sources.FixedBoundary sink_14(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{120,-100},{100,-80}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_13(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=4,
    T=393.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={150,-30})));
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
  Modelica.Fluid.Sources.MassFlowSource_T source_11(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=4,
    T=408.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,120})));
  Components.Pump pump(redeclare package Medium_l = Medium_sol, T_in_start=gen.T_start) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={120,0})));
  Modelica.Fluid.Sources.FixedBoundary sink_12(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1) annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Modelica.Blocks.Sources.RealExpression p_gen(y=7406)
    annotation (Placement(transformation(extent={{198,88},{158,108}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_gen(y=0.6216)
    annotation (Placement(transformation(extent={{202,64},{162,84}})));
  TypeII.GeneratorStatic_wHT_UAfix_TypeII gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="kPa") = 15766,
    T_start(displayUnit="K") = 384.7,
    X_LiBr_start=0.6399,
    T_14(start=382.15),
    UA=25000) annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBr(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = 1000*(105.328 - 15.766),
    m_flow_nominal=1.077,
    use_opening=false,
    X_LiBr_start=0.5944,
    T_out_start=375.15,
    Q_intern_start=0.014)
    annotation (Placement(transformation(extent={{30,-8},{50,12}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.CondenserStatic_wHT_UAfix con(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="kPa") = 15766,
    T_15(start=303.15),
    T_16(start=314.41),
    UA=10000) annotation (Placement(transformation(extent={{-40,-60},{-60,-40}})));
  Modelica.Fluid.Sources.FixedBoundary sink_18(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_17(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=4,
    T=303.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-40})));
  Components.PumpW pumpW(redeclare package Medium_l = Medium_l) annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  TypeII.EvaporatorStatic_wHT_UAfix_TypeII eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 105328,
    T_17(start=393.15),
    T_18(start=382.15),
    UA=15000) annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_15(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=4,
    T=393.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,120})));
  Modelica.Fluid.Sources.FixedBoundary sink_16(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(abs.Hb_flow)/(eva.Hb_flow +
        gen.Hb_flow))
    annotation (Placement(transformation(extent={{152,112},{192,132}})));

equation

  connect(source_11.ports[1], abs.port_a_ext) annotation (Line(points={{80,120},
          {28,120},{28,81},{59,81}}, color={0,127,255}));
  connect(pump.m_dot_in, m_s.y) annotation (Line(points={{130,-1.11022e-15},{
          134.5,-1.11022e-15},{134.5,0},{139,0}}, color={0,0,127}));
  connect(abs.port_b_ext, sink_12.ports[1])
    annotation (Line(points={{59,79},{20,79},{20,130}}, color={0,127,255}));
  connect(gen.port_l_b, pump.port_l_a)
    annotation (Line(points={{57,-59},{120,-59},{120,-9}}, color={0,127,255}));
  connect(hex.port_a1, pump.port_l_b) annotation (Line(points={{58,32},{58,20},
          {120,20},{120,9}}, color={0,127,255}));
  connect(hex.port_b2, flashingLiBr.port_a)
    annotation (Line(points={{46,32},{46,20},{40,20},{40,11}},
                                              color={0,127,255}));
  connect(flashingLiBr.port_l_b, gen.port_l_a) annotation (Line(points={{35.2,-7},
          {35.2,-20},{18,-20},{18,-59},{43,-59}},     color={0,127,255}));
  connect(flashingLiBr.port_v_b, gen.port_v_a) annotation (Line(points={{45,-7},
          {45,-24},{22,-24},{22,-51.2},{40,-51.2}}, color={0,127,255}));
  connect(hex.port_a2, abs.port_l_b) annotation (Line(points={{46,52},{46,66},{
          63,66},{63,77}},
                        color={0,127,255}));
  connect(hex.port_b1, abs.port_l_a) annotation (Line(points={{58,52},{58,58},{
          78,58},{78,83},{77,83}},
                                color={0,127,255}));
  connect(gen.port_a_ext, source_13.ports[1]) annotation (Line(points={{57,-41},
          {60,-41},{60,-30},{140,-30}}, color={0,127,255}));
  connect(gen.port_b_ext, sink_14.ports[1]) annotation (Line(points={{59,-43},{
          80,-43},{80,-90},{100,-90}}, color={0,127,255}));
  connect(con.port_v, gen.port_v) annotation (Line(points={{-50,-40},{-50,-32},
          {50,-32},{50,-40}}, color={0,127,255}));
  connect(source_17.ports[1], con.port_a_ext) annotation (Line(points={{-80,-40},
          {-70,-40},{-70,-57},{-59,-57}}, color={0,127,255}));
  connect(sink_18.ports[1], con.port_b_ext) annotation (Line(points={{-80,-90},
          {-57,-90},{-57,-59}}, color={0,127,255}));
  connect(con.port_l, pumpW.port_l_a) annotation (Line(points={{-50,-60},{-50,
          -62},{-30,-62},{-30,1}}, color={0,127,255}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-40.8,70},{-12,70},
          {-12,93},{59,93}}, color={0,127,255}));
  connect(eva.port_l_a, pumpW.port_l_b) annotation (Line(points={{-59,61},{-59,
          24},{-30,24},{-30,19}}, color={0,127,255}));
  connect(eva.port_a_ext, source_15.ports[1]) annotation (Line(points={{-45,61},
          {-45,46},{-104,46},{-104,120},{-80,120}}, color={0,127,255}));
  connect(eva.port_b_ext, sink_16.ports[1]) annotation (Line(points={{-49,61},{
          -49,56},{-128,56},{-128,120},{-140,120}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {280,140}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{280,140}})),
    experiment(
      StopTime=600,
      Interval=0.1,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>Model of a parallel flow double effect absorption heat pump with external fluids.</p>
<p>Model is based on figure 6.23 of [1].</p>
<p>UA values of the main heat exchangers are fixed. Solution heat exchanger uses effectiveness = 0.9</p>
<p>Main input variables are...</p>
<ul>
<li>External fluids: Mass flow rate and temperature at each vessel.</li>
<li>Mass flow rate of the solution going from generator to absorber.</li>
</ul>
<p><br><br>The data used to evaluate this circuit is obtained from table 6.6 of [1].</p>
<p><br><br><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
    __Dymola_Commands(file="Resources\Static\TypeII\Validation\Table6.6.mos" "Plot"));
end AHPTypeII_UAfix_HXeps;
