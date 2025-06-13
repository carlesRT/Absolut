within Absolut.FluidBased.Static.SingleEffect_UAfixed.Examples;
model AHP_wHT_UAfix_ConAbsSerie
extends Modelica.Icons.Example;

  Components.FlashingWater flashingWaterUnder(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 7406 - 676,
    m_flow_nominal=0.00457,
    use_opening=false) annotation (Placement(transformation(extent={{-80,4},{-60,24}})));
  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1pT annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2pT annotation (
     __Dymola_choicesAllMatching=true);
  CondenserStatic_wHT_UAfix con(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa"),
    T_start=343.15,
    UA=1200) annotation (Placement(transformation(extent={{-60,42},{-80,62}})));
  EvaporatorStatic_wHT_UAfix
    eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
        redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa"),
    T_start=303.15,
    UA=2250)
           annotation (Placement(transformation(extent={{-70,-56},{-50,-36}})));
  GeneratorStatic_wHT_UAfix
    gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_l,
        p_start(displayUnit="Pa") = 7406,
    T_start=363.15,
    m_dot_start=0.05,                     UA=1000)
    annotation (Placement(transformation(extent={{30,42},{50,62}})));
  Components.FlashingLiBr flashingLiBrUnder(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = 7406 - 676,
    m_flow_nominal=0.04543,
    use_opening=false,
    X_LiBr_start=0.626) annotation (Placement(transformation(extent={{70,-32},{50,-12}})));
  Modelica.Blocks.Sources.RealExpression MassFlowRate(y=0.05)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  AbsorberStatic_wHT_UAfix abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_l,
    p_start(displayUnit="Pa"),
    T_start=343.15,
    X_LiBr_start=0.56,
    p(displayUnit="kPa"),
    UA=1696) annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Sources.RealExpression p_gen(y=7406)
    annotation (Placement(transformation(extent={{160,62},{120,82}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_gen(y=0.6216)
    annotation (Placement(transformation(extent={{160,80},{120,100}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_abs(y=0.5648)
    annotation (Placement(transformation(extent={{160,-100},{120,-80}})));
  Modelica.Blocks.Sources.RealExpression p_abs(y=676)
    annotation (Placement(transformation(extent={{160,-80},{120,-60}})));
  Components.HEX.simpleHX simpleHX(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.04543,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix(displayUnit="kW/K") = 200) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={54,20})));

  Modelica.Fluid.Sources.FixedBoundary sink_v(
    redeclare package Medium = Medium_ext,
    p=400000,
    nPorts=1) annotation (Placement(transformation(extent={{-120,-78},{-100,-58}})));
  Modelica.Fluid.Sources.MassFlowSource_T source1(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.4,
    T=314.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-100})));
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1pT
    annotation (__Dymola_choicesAllMatching=true);
  Modelica.Fluid.Sources.FixedBoundary sink_v1(
    redeclare package Medium = Medium_ext,
    p=400000,
    nPorts=1) annotation (Placement(transformation(extent={{-130,16},{-110,36}})));
  Modelica.Fluid.Sources.MassFlowSource_T source3(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.4,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-8,-76})));
  Modelica.Fluid.Sources.MassFlowSource_T source4(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=1,
    T=378.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,100})));
  Modelica.Fluid.Sources.FixedBoundary sink_v3(
    redeclare package Medium = Medium_ext,
    p=400000,
    nPorts=1) annotation (Placement(transformation(extent={{100,42},{80,62}})));
  Components.Pump pump(redeclare package Medium_l = Medium_sol, T_in_start=abs.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={10,-20})));
  Modelica.Blocks.Sources.RealExpression EER(y=(eva.Hb_flow)/(gen.Hb_flow))
    annotation (Placement(transformation(extent={{-80,80},{-40,100}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(con.Hb_flow + abs.Hb_flow)/(
        gen.Hb_flow))
    annotation (Placement(transformation(extent={{-80,100},{-40,120}})));
  Modelica.Blocks.Sources.RealExpression Balance(y=con.Hb_flow + gen.Hb_flow +
        eva.Hb_flow + abs.Hb_flow + pump.W_dh)
    annotation (Placement(transformation(extent={{-80,120},{-40,140}})));
  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1";
equation
  connect(flashingWaterUnder.port_a, con.port_l)
    annotation (Line(points={{-70,23},{-70,42}}, color={0,127,255}));
  connect(flashingWaterUnder.port_l_b, eva.port_l_a) annotation (Line(points={{-74.8,5},
          {-74.8,-18},{-80,-18},{-80,-55},{-69,-55}},     color={0,127,255}));
  connect(eva.port_v_a, flashingWaterUnder.port_v_b) annotation (Line(points={{-60,
          -36.2},{-65,-36.2},{-65,5}},  color={0,127,255}));
  connect(con.port_v, gen.port_v) annotation (Line(points={{-70,62},{-70,70},{
          40,70},{40,62}},
                        color={0,127,255}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-50.8,-46},{-20,-46},
          {-20,-43},{21,-43}}, color={0,127,255}));
  connect(abs.port_v_a, flashingLiBrUnder.port_v_b) annotation (Line(points={{39,-47},
          {55,-47},{55,-31}},         color={0,127,255}));
  connect(abs.port_l_a, flashingLiBrUnder.port_l_b) annotation (Line(points={{39,-53},
          {64.8,-53},{64.8,-31}},         color={0,127,255}));
  connect(simpleHX.port_b1, gen.port_l_a) annotation (Line(points={{48,30},{20,
          30},{20,42},{33,42},{33,43}}, color={0,127,255}));
  connect(simpleHX.port_a2, gen.port_l_b)
    annotation (Line(points={{60,30},{60,43},{47,43}}, color={0,127,255}));
  connect(simpleHX.port_b2, flashingLiBrUnder.port_a)
    annotation (Line(points={{60,10},{60,-13}}, color={0,127,255}));
  connect(eva.port_a_ext, source1.ports[1]) annotation (Line(points={{-55,-55},
          {-55,-100},{-100,-100}},               color={0,127,255}));
  connect(eva.port_b_ext, sink_v.ports[1]) annotation (Line(points={{-59,-55},{
          -59,-68},{-100,-68}}, color={0,127,255}));
  connect(con.port_b_ext, sink_v1.ports[1])
    annotation (Line(points={{-77,43},{-77,26},{-110,26}}, color={0,127,255}));
  connect(source3.ports[1], abs.port_a_ext) annotation (Line(points={{2,-76},{8,
          -76},{8,-55},{21,-55}}, color={0,127,255}));
  connect(gen.port_a_ext, source4.ports[1])
    annotation (Line(points={{47,61},{47,100},{80,100}}, color={0,127,255}));
  connect(gen.port_b_ext, sink_v3.ports[1]) annotation (Line(points={{49,59},{
          70,59},{70,52},{80,52}}, color={0,127,255}));
  connect(abs.port_l_b, pump.port_l_a)
    annotation (Line(points={{25,-59},{10,-59},{10,-29}}, color={0,127,255}));
  connect(pump.port_l_b, simpleHX.port_a1) annotation (Line(points={{10,-11},{
          10,2},{48,2},{48,10}}, color={0,127,255}));
  connect(pump.m_dot_in, MassFlowRate.y)
    annotation (Line(points={{0,-20},{-19,-20}}, color={0,0,127}));
  connect(abs.port_b_ext, con.port_a_ext) annotation (Line(points={{21,-57},{21,
          -124},{-148,-124},{-148,45},{-79,45}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
            {160,140}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{160,140}})),
    experiment(
      StopTime=61,
      Interval=0.1,
      Tolerance=1e-07));
end AHP_wHT_UAfix_ConAbsSerie;
