within Absolut.FluidBased.Static.Resorption.Validation;
model Resorption
extends Modelica.Icons.Example;

  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);

  parameter Boolean allowFlowReversal=false
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1";

  // Reference data

 Modelica.Units.SI.HeatFlowRate P[2] = {0.37,0.46} "Pumps power, Ws1: solution 1 and Ws2: solution 2";
  Real COP_ref = 0.562 "Coefficient of performance, defined as Heat flow rate at desorber 2 / heat flow rate at desorber 1";
  Modelica.Units.NonSI.Temperature_degC T[22]=
  {38.44, 38.44,
  75.29, 97.33,
  54.69, 48.73,
  86.52, 14.62,
  14.62, 40.87,
  57.24, 33.97,
  13.71, 14.62,
  120, 116.9,
  25, 28.01,
  25, 26.9,
  20, 18.23} "Temperature at state points";

  Modelica.Units.SI.Pressure p_ref[2] = {1137, 13071} "Pressure at two levels";
  Modelica.Units.SI.HeatFlowRate Q_flow[6] = {
  -13170, -7400, 12610, 7960, 3800, 3560} "Heat flow rate at Desober 1, Desorber 2, Absorber 1, Absorber 2, Solution HX1 and HX2";

  Real Q6 = 0.004  "Vapour quality at point 6";
  Real Q13 = 0.023 "Vapour quality at point 13";

  Real X_LiBr1 = 0.55 "X_LiBr of at point 1, leaving absorber 1";
  Real X_LiBr8 = 0.33284 "X_LiBr of at point 8, leaving desorber 2";
  Real X_LiBr11 = 0.3071 "X_LiBr of at point 11, leaving absorber 2";
  Real X_LiBr4 = 0.60033 "X_LiBr of at point 4, leaving desorber 1";

 // Model

  Modelica.Fluid.Sources.FixedBoundary sink_24(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{38,-132},{58,-112}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_23(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=1,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={50,-76})));
  Modelica.Fluid.Sources.MassFlowSource_T source_21(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=1,
    T=393.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,120})));
  Modelica.Fluid.Sources.FixedBoundary sink_22(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{154,60},{134,80}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(abs2.Hb_flow)/(gen2.Hb_flow))
    annotation (Placement(transformation(extent={{-18,60},{22,80}})));

  Absolut.FluidBased.Static.SingleEffect_UAfixed.AbsorberStatic_wHT_UAfix abs1(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa"),
    T_start=311.15,
    X_LiBr_start=0.55,
    p(displayUnit="kPa"),
    T_13(start=298.15),
    T_14(start=301.15),
    UA=750) annotation (Placement(transformation(extent={{98,-58},{118,-38}})));
  Components.Pump pump1(redeclare package Medium_l = Medium_sol, T_in_start=abs1.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,20})));
  Modelica.Blocks.Sources.RealExpression m1(y=0.05)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBr1(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = 7406 - 676,
    m_flow_nominal=0.05,
    use_opening=false,
    X_LiBr_start=0.60,
    T_out_start=321.85,
    p_out_start(displayUnit="Pa") = 1137,
    Q_intern_start=0.005)
    annotation (Placement(transformation(extent={{122,8},{102,28}})));
  Absolut.FluidBased.Static.Components.HEX.simpleHX HX1(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.04543,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix=200) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={108,60})));

  Absolut.FluidBased.Static.SingleEffect_UAfixed.GeneratorStatic_wHT_UAfix gen1(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 13071,
    T_start=370.15,
    X_LiBr_start=0.60,
    T_11(start=393.15),
    T_12(start=389.15),
    UA=500,
    port_l_b(m_flow(start=-0.0458))) annotation (Placement(transformation(extent={{82,82},{102,102}})));

  Absolut.FluidBased.Static.Resorption.AbsorberStatic_wHT_UAfix_Resorption_ext abs2(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 13071,
    T_start=330.15,
    X_LiBr_start=0.307,
    p(displayUnit="kPa"),
    dT_used(start=18.44),
    UA=250,
    port_l_b(m_flow(start=-0.054)),
    T_13(start=273.15 + 25),
    T_14(start=273.15 + 26.9)) annotation (Placement(transformation(extent={{-74,66},{-54,86}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_25(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=1,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-52,130})));
  Modelica.Fluid.Sources.FixedBoundary sink_26(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1) annotation (Placement(transformation(extent={{-150,46},{-130,66}})));
  Components.HEX.simpleHX HX2(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.04543,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix=200) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,30})));

  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBr2(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = 1000*(105.328 - 15.766),
    m_flow_nominal=0.05,
    use_opening=false,
    X_LiBr_start=0.307,
    T_out_start=286.85,
    p_out_start(displayUnit="Pa") = 1137,
    Q_intern_start=0.023)
    annotation (Placement(transformation(extent={{-124,-18},{-104,2}})));
  Components.Pump pump2(redeclare package Medium_l = Medium_sol, T_in_start=gen2.T_start) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-60,-10})));
  Absolut.FluidBased.Static.TypeII.GeneratorStatic_wHT_UAfix_TypeII gen2(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 1137,
    T_start=287.75,
    X_LiBr_start=0.333,
    T_14(start=291.38),
    UA=1500,
    T_13(start=273.15 + 20)) annotation (Placement(transformation(extent={{-94,-96},{-74,-76}})));
  Modelica.Blocks.Sources.RealExpression m2(y=0.05)
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_27(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=1,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={18,-38})));
  Modelica.Fluid.Sources.FixedBoundary sink_28(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-6,-90},{-26,-70}})));
equation
  abs1.X_LiBr = 0.55;

  connect(abs1.port_l_b, pump1.port_l_a) annotation (Line(points={{103,-57},{
          104,-57},{104,-60},{98,-60},{98,0},{70,0},{70,11}}, color={0,127,255}));
  connect(pump1.m_dot_in, m1.y)
    annotation (Line(points={{60,20},{41,20}}, color={0,0,127}));
  connect(abs1.port_v_a, flashingLiBr1.port_v_b) annotation (Line(points={{117,
          -45},{126,-45},{126,-30},{107,-30},{107,9}}, color={0,127,255}));
  connect(abs1.port_l_a, flashingLiBr1.port_l_b) annotation (Line(points={{117,
          -51},{130,-51},{130,2},{116.8,2},{116.8,9}}, color={0,127,255}));
  connect(pump1.port_l_b, HX1.port_a1) annotation (Line(points={{70,29},{70,42},
          {102,42},{102,50}}, color={0,127,255}));
  connect(HX1.port_b2, flashingLiBr1.port_a) annotation (Line(points={{114,50},
          {114,38},{112,38},{112,27}},color={0,127,255}));
  connect(HX1.port_b1, gen1.port_l_a) annotation (Line(points={{102,70},{72,70},
          {72,82},{85,82},{85,83}}, color={0,127,255}));
  connect(HX1.port_a2, gen1.port_l_b)
    annotation (Line(points={{114,70},{114,83},{99,83}}, color={0,127,255}));
  connect(gen1.port_a_ext, source_21.ports[1])
    annotation (Line(points={{99,101},{99,120},{120,120}}, color={0,127,255}));
  connect(gen1.port_b_ext, sink_22.ports[1]) annotation (Line(points={{101,99},
          {128,99},{128,70},{134,70}}, color={0,127,255}));
  connect(source_23.ports[1], abs1.port_a_ext) annotation (Line(points={{60,-76},
          {70,-76},{70,-53},{99,-53}}, color={0,127,255}));
  connect(abs1.port_b_ext, sink_24.ports[1]) annotation (Line(points={{99,-55},
          {72,-55},{72,-122},{58,-122}}, color={0,127,255}));
  connect(source_25.ports[1],abs2. port_a_ext) annotation (Line(points={{-62,130},
          {-82,130},{-82,71},{-73,71}}, color={0,127,255}));
  connect(abs2.port_b_ext,sink_26. ports[1])
    annotation (Line(points={{-73,69},{-124,69},{-124,56},{-130,56}},
                                                           color={0,127,255}));
  connect(HX2.port_a2,abs2. port_l_b) annotation (Line(points={{-86,40},{-86,62},
          {-69,62},{-69,67}}, color={0,127,255}));
  connect(HX2.port_b1,abs2. port_l_a) annotation (Line(points={{-74,40},{-74,60},
          {-48,60},{-48,73},{-55,73}}, color={0,127,255}));
  connect(flashingLiBr2.port_a,HX2. port_b2) annotation (Line(points={{-114,1},{
          -114,14},{-86,14},{-86,20}},                   color={0,127,255}));
  connect(HX2.port_a1,pump2. port_l_b) annotation (Line(points={{-74,20},{-74,6},
          {-60,6},{-60,-1}},                  color={0,127,255}));
  connect(flashingLiBr2.port_v_b,gen2. port_v_a) annotation (Line(points={{-109,
          -17},{-110,-17},{-110,-87.2},{-94,-87.2}},    color={0,127,255}));
  connect(flashingLiBr2.port_l_b,gen2. port_l_a) annotation (Line(points={{-118.8,
          -17},{-118.8,-102},{-91,-102},{-91,-95}},          color={0,127,255}));
  connect(gen2.port_l_b,pump2. port_l_a) annotation (Line(points={{-77,-95},{-78,
          -95},{-78,-98},{-72,-98},{-72,-26},{-60,-26},{-60,-19}},
                                    color={0,127,255}));
  connect(pump2.m_dot_in,m2. y)
    annotation (Line(points={{-50,-10},{-41,-10}},
                                                 color={0,0,127}));
  connect(gen2.port_a_ext,source_27. ports[1]) annotation (Line(points={{-77,-77},
          {-78,-77},{-78,-38},{8,-38}},  color={0,127,255}));
  connect(gen2.port_b_ext,sink_28. ports[1]) annotation (Line(points={{-75,-79},
          {-74,-79},{-74,-80},{-26,-80}},   color={0,127,255}));
  connect(gen2.port_v, abs1.port_v) annotation (Line(points={{-84,-76},{-108,
          -76},{-108,-58},{52,-58},{52,-41},{99,-41}}, color={0,127,255}));
  connect(gen1.port_v, abs2.port_v) annotation (Line(points={{92,102},{92,108},
          {-73,108},{-73,83}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -140},{160,140}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,
            140}})),
    experiment(
      StopTime=600,
      Interval=0.1,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>Model of a resoprtion cycle with external fluids. Model is based on Figure 8.3 from [1]. </p>
<p>Key parameters are, </p>
<ul>
<li>UA values of the main heat exchangers and solution heat exchangers.</li>
</ul>
<p>Main input variables are...</p>
<ul>
<li>Mass flow rate and temperatures of the external fluids enterig each vessel.<br></li>
</ul>
<p>The data used to evaluate this circuit is obtained from Table 8.6 of [1].</p>
<p><br><br><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
    __Dymola_Commands(file="Resources\Static\Resorption\Validation\Table8.6.mos"
        "Plot"));
end Resorption;
