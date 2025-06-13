within Absolut.FluidBased.Static.AHE.Examples;
model AHX_all_parallel "Absorber, condenser and heat exchanger in parallel."
extends Modelica.Icons.Example;

  Components.FlashingWater flashingWaterUnder(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 7406 - 676,
    m_flow_nominal=0.00457,
    use_opening=false,
    T_out_start=313.15) annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);
  Absolut.FluidBased.Static.SingleEffect_UAfixed.CondenserStatic_wHT_UAfix con(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa"),
    T_start=343.15,
    T_15(start=323.15),
    T_16(start=328.15),
    UA=1200) annotation (Placement(transformation(extent={{-60,38},{-80,58}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.EvaporatorStatic_wHT_UAfix eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 7677,
    T_start=315.15,
    T_17(start=353.15),
    T_18(start=333.15),
    UA=1500) annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Components.FlashingLiBr flashingLiBrUnder(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = 7406 - 676,
    m_flow_nominal=0.04543,
    use_opening=false,
    port_a(m_flow(start=0.049)),
    X_LiBr_start=0.5,
    T_out_start=338.15,
    p_out_start(displayUnit="Pa") = 7677) annotation (Placement(transformation(extent={{70,-34},{50,-14}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(con.Hb_flow + Q_abs_calc.y)/(
        gen.Hb_flow))
    annotation (Placement(transformation(extent={{-80,100},{-40,120}})));
  Modelica.Blocks.Sources.RealExpression Q_abs_calc(y=-(con.Hb_flow + gen.Hb_flow
         + eva.Hb_flow))
    annotation (Placement(transformation(extent={{-80,120},{-40,140}})));
  Modelica.Blocks.Sources.RealExpression EER(y=(eva.Hb_flow)/(gen.Hb_flow))
    annotation (Placement(transformation(extent={{-80,80},{-40,100}})));
  Modelica.Blocks.Sources.RealExpression MassFlowRate(y=0.05)
    annotation (Placement(transformation(extent={{-40,-32},{-20,-12}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.AbsorberStatic_wHT_UAfix abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 7677,
    T_start=331.15,
    X_LiBr_start=0.47,
    p(displayUnit="kPa"),
    T_13(start=323.15),
    T_14(start=327.15),
    UA=1700) annotation (Placement(transformation(extent={{20,-58},{40,-38}})));
  Modelica.Blocks.Sources.RealExpression p_gen(y=7406)
    annotation (Placement(transformation(extent={{160,62},{120,82}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_gen(y=0.6216)
    annotation (Placement(transformation(extent={{160,80},{120,100}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_abs(y=0.5648)
    annotation (Placement(transformation(extent={{96,-102},{56,-82}})));
  Modelica.Blocks.Sources.RealExpression p_abs(y=
        Absolut.Media.LiBrH2O.saturationPressure_TX(273.15 + 41, 1 - 0.5648))
    annotation (Placement(transformation(extent={{140,-80},{80,-60}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex_solution(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.04543,
    dp1_nominal=0,
    dp2_nominal=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={54,18})));
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
  Modelica.Fluid.Sources.MassFlowSource_T source3(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=0.3,
    T=323.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-190,-110})));
  Modelica.Fluid.Sources.MassFlowSource_T source4(
    redeclare package Medium = Medium_ext,
    m_flow=0.25,
    T=403.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,100})));
  Components.Pump pump(redeclare package Medium_l = Medium_sol, T_in_start=abs.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={14,-22})));
  Modelica.Fluid.Sources.MassFlowSource_T source1(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=1,
    T=323.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-190,-68})));
  Modelica.Fluid.Sources.FixedBoundary sink_v4(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1) annotation (Placement(transformation(extent={{-122,-90},{-102,-70}})));
  Modelica.Fluid.Sources.FixedBoundary sink_v3(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1) annotation (Placement(transformation(extent={{-240,40},{-220,60}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium_ext,
    redeclare package Medium2 = Medium_ext,
    m1_flow_nominal=1,
    m2_flow_nominal=1,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-146,-42})));
  Buildings.Fluid.FixedResistances.LosslessPipe pip(redeclare package Medium =
        Medium_ext, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-160,40},{-180,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium_ext, m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{-190,40},{-210,60}})));
  Modelica.Blocks.Sources.RealExpression cp_ratio(y=
        Medium_sol.specificHeatCapacity_SSC_TXp(
        gen.T,
        gen.X_H2O,
        gen.p)/4184)
    annotation (Placement(transformation(extent={{-324,-66},{-284,-46}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.GeneratorStatic_wHT_UAfix gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_l,
    p_start(displayUnit="Pa"),
    T_start=373.15,
    X_LiBr_start=0.51,
    T_11(start=403.15),
    T_12(start=393.15),
    UA=2000) annotation (Placement(transformation(extent={{70,48},{90,68}})));
  Modelica.Fluid.Sources.MassFlowSource_T source2(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=0.2,
    T=323.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-190,-32})));
  Modelica.Blocks.Sources.RealExpression T_in(y=273.15 + 45)
    annotation (Placement(transformation(extent={{-308,-90},{-268,-70}})));
  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1";
equation

  connect(flashingWaterUnder.port_a, con.port_l)
    annotation (Line(points={{-70,-1},{-70,38}}, color={0,127,255}));
  connect(flashingWaterUnder.port_l_b, eva.port_l_a) annotation (Line(points={{-74.8,
          -19},{-74.8,-40},{-84,-40},{-84,-59},{-69,-59}},color={0,127,255}));
  connect(eva.port_v_a, flashingWaterUnder.port_v_b) annotation (Line(points={{-60,
          -40.2},{-60,-26},{-65,-26},{-65,-19}},
                                        color={0,127,255}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-50.8,-50},{-20,-50},
          {-20,-41},{21,-41}}, color={0,127,255}));
  connect(abs.port_v_a, flashingLiBrUnder.port_v_b) annotation (Line(points={{39,-45},
          {55,-45},{55,-33}},         color={0,127,255}));
  connect(abs.port_l_a, flashingLiBrUnder.port_l_b) annotation (Line(points={{39,-51},
          {64.8,-51},{64.8,-33}},         color={0,127,255}));
  connect(hex_solution.port_b2, flashingLiBrUnder.port_a)
    annotation (Line(points={{60,8},{60,-15}}, color={0,127,255}));
  connect(source3.ports[1], abs.port_a_ext) annotation (Line(points={{-180,-110},
          {10,-110},{10,-53},{21,-53}}, color={0,127,255}));
  connect(abs.port_l_b, pump.port_l_a)
    annotation (Line(points={{25,-57},{14,-57},{14,-31}}, color={0,127,255}));
  connect(pump.port_l_b, hex_solution.port_a1) annotation (Line(points={{14,-13},
          {14,-2},{46,-2},{46,8},{48,8}}, color={0,127,255}));
  connect(sink_v4.ports[1], eva.port_b_ext) annotation (Line(points={{-102,-80},
          {-59,-80},{-59,-59}}, color={0,127,255}));
  connect(source1.ports[1], hex.port_a2) annotation (Line(points={{-180,-68},{
          -152,-68},{-152,-52}}, color={0,127,255}));
  connect(con.port_b_ext, pip.port_a) annotation (Line(points={{-77,39},{-77,30},
          {-110,30},{-110,50},{-160,50}}, color={0,127,255}));
  connect(senTem.port_a, pip.port_b)
    annotation (Line(points={{-190,50},{-180,50}}, color={0,127,255}));
  connect(sink_v3.ports[1], senTem.port_b)
    annotation (Line(points={{-220,50},{-210,50}}, color={0,127,255}));
  connect(hex.port_b1, eva.port_a_ext) annotation (Line(points={{-140,-52},{
          -140,-96},{-55,-96},{-55,-59}},              color={0,127,255}));
  connect(gen.port_l_b, hex_solution.port_a2) annotation (Line(points={{87,49},
          {87,40},{60,40},{60,28}}, color={0,127,255}));
  connect(gen.port_l_a, hex_solution.port_b1) annotation (Line(points={{73,49},
          {50,49},{50,28},{48,28}}, color={0,127,255}));
  connect(con.port_v, gen.port_v) annotation (Line(points={{-70,58},{-72,58},{
          -72,76},{80,76},{80,68}},
                                color={0,127,255}));
  connect(gen.port_a_ext, source4.ports[1]) annotation (Line(points={{87,67},{
          87,84},{64,84},{64,100},{80,100}}, color={0,127,255}));
  connect(hex.port_a1, gen.port_b_ext) annotation (Line(points={{-140,-32},{-140,
          -22},{-92,-22},{-92,16},{98,16},{98,65},{89,65}},         color={0,
          127,255}));
  connect(hex.port_b2, pip.port_a) annotation (Line(points={{-152,-32},{-152,52},
          {-158,52},{-158,50},{-160,50}}, color={0,127,255}));
  connect(source2.ports[1], con.port_a_ext) annotation (Line(points={{-180,-32},
          {-172,-32},{-172,-2},{-104,-2},{-104,41},{-79,41}}, color={0,127,255}));
  connect(MassFlowRate.y, pump.m_dot_in)
    annotation (Line(points={{-19,-22},{4,-22}}, color={0,0,127}));
  connect(T_in.y, source2.T_in) annotation (Line(points={{-266,-80},{-248,-80},
          {-248,-36},{-202,-36}}, color={0,0,127}));
  connect(T_in.y, source1.T_in) annotation (Line(points={{-266,-80},{-248,-80},
          {-248,-36},{-210,-36},{-210,-72},{-202,-72}}, color={0,0,127}));
  connect(T_in.y, source3.T_in) annotation (Line(points={{-266,-80},{-268,-80},
          {-268,-114},{-202,-114}}, color={0,0,127}));
  connect(abs.port_b_ext, pip.port_a) annotation (Line(points={{21,-55},{21,
          -156},{-232,-156},{-232,-6},{-174,-6},{-174,14},{-160,14},{-160,50}},
        color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-320,-180},{160,140}})),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-320,-180},{160,140}})),
    experiment(
      StopTime=61,
      Interval=0.1,
      Tolerance=1e-07),
      __Dymola_Commands(file="Resources\Static\AHE\Examples\AHE temperatures.mos" "Show AHE temperatures"));
end AHX_all_parallel;
