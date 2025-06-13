within Absolut.FluidBased.Static.AHE.Examples;
model AHE_abs_con_serie
  "Absorber and condenser in serie. heat exchanger in parallel."
extends Modelica.Icons.Example;

  Components.FlashingWater flashingWaterUnder(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 7406 - 676,
    m_flow_nominal=0.00457,
    use_opening=false) annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);
  Absolut.FluidBased.Static.SingleEffect_UAfixed.CondenserStatic_wHT_UAfix con(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 7406,
    T_start=348.15,
    UA=1200) annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.EvaporatorStatic_wHT_UAfix eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa"),
    T_start=303.15,
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
    p_out_start=abs.p_start) annotation (Placement(transformation(extent={{70,-32},{50,-12}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(con.Hb_flow + Q_abs_calc.y)/(
        gen.Hb_flow))
    annotation (Placement(transformation(extent={{-80,100},{-40,120}})));
  Modelica.Blocks.Sources.RealExpression Q_abs_calc(y=-(con.Hb_flow + gen.Hb_flow
         + eva.Hb_flow))
    annotation (Placement(transformation(extent={{-80,120},{-40,140}})));
  Modelica.Blocks.Sources.RealExpression EER(y=(eva.Hb_flow)/(gen.Hb_flow))
    annotation (Placement(transformation(extent={{-80,80},{-40,100}})));
  Modelica.Blocks.Sources.RealExpression MassFlowRate(y=0.05)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.AbsorberStatic_wHT_UAfix abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa"),
    T_start=338.15,
    X_LiBr_start=0.5648,
    p(displayUnit="kPa"),
    UA=1700) annotation (Placement(transformation(extent={{20,-56},{40,-36}})));
  Modelica.Blocks.Sources.RealExpression p_gen(y=7406)
    annotation (Placement(transformation(extent={{160,60},{120,80}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_gen(y=0.6216)
    annotation (Placement(transformation(extent={{160,80},{120,100}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_abs(y=0.5648)
    annotation (Placement(transformation(extent={{100,-100},{60,-80}})));
  Modelica.Blocks.Sources.RealExpression p_abs(y=
        Absolut.Media.LiBrH2O.saturationPressure_TX(273.15 + 41, 1 - 0.5648))
    annotation (Placement(transformation(extent={{140,-80},{60,-60}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex_solution(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.04543,
    dp1_nominal=0,
    dp2_nominal=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={54,20})));
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
  Modelica.Fluid.Sources.MassFlowSource_T source3(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=0.5,
    T=318.15,
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
        origin={100,110})));
  Components.Pump pump(redeclare package Medium_l = Medium_sol, T_in_start=abs.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={14,-20})));
  Modelica.Fluid.Sources.MassFlowSource_T source1(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=1,
    T=318.15,
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
        origin={-148,-20})));
  Buildings.Fluid.FixedResistances.LosslessPipe pip(redeclare package Medium =
        Medium_ext, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-160,40},{-180,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium_ext, m_flow_nominal=0.1,
    T_start=318.15)
    annotation (Placement(transformation(extent={{-190,40},{-210,60}})));
  Modelica.Blocks.Sources.RealExpression cp_ratio(y=
        Medium_sol.specificHeatCapacity_SSC_TXp(
        gen.T,
        gen.X_H2O,
        gen.p)/4184)
    annotation (Placement(transformation(extent={{100,-120},{60,-100}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.GeneratorStatic_wHT_UAfix gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_l,
    T_start=373.15,
    m_dot_start=0.05,
    T_11(start=403.15),
    T_12(start=383.15),
    UA=2000) annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Modelica.Blocks.Sources.Constant Tr(k=273.15 + 45)
    annotation (Placement(transformation(extent={{-280,-100},{-262,-82}})));
equation

  connect(flashingWaterUnder.port_a, con.port_l)
    annotation (Line(points={{-70,-1},{-70,40}}, color={0,127,255}));
  connect(flashingWaterUnder.port_l_b, eva.port_l_a) annotation (Line(points={{-74.8,
          -19},{-74.8,-40},{-84,-40},{-84,-59},{-69,-59}},color={0,127,255}));
  connect(eva.port_v_a, flashingWaterUnder.port_v_b) annotation (Line(points={{-60,
          -40.2},{-60,-26},{-65,-26},{-65,-19}},
                                        color={0,127,255}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-50.8,-50},{-20,-50},
          {-20,-39},{21,-39}}, color={0,127,255}));
  connect(abs.port_v_a, flashingLiBrUnder.port_v_b) annotation (Line(points={{39,-43},
          {55,-43},{55,-31}},         color={0,127,255}));
  connect(abs.port_l_a, flashingLiBrUnder.port_l_b) annotation (Line(points={{39,-49},
          {64.8,-49},{64.8,-31}},         color={0,127,255}));
  connect(hex_solution.port_b2, flashingLiBrUnder.port_a)
    annotation (Line(points={{60,10},{60,-13}},color={0,127,255}));
  connect(source3.ports[1], abs.port_a_ext) annotation (Line(points={{-180,-110},
          {10,-110},{10,-51},{21,-51}}, color={0,127,255}));
  connect(abs.port_l_b, pump.port_l_a)
    annotation (Line(points={{25,-55},{14,-55},{14,-29}}, color={0,127,255}));
  connect(pump.port_l_b, hex_solution.port_a1) annotation (Line(points={{14,-11},
          {14,0},{46,0},{46,10},{48,10}}, color={0,127,255}));
  connect(pump.m_dot_in, MassFlowRate.y)
    annotation (Line(points={{4,-20},{-19,-20}}, color={0,0,127}));
  connect(sink_v4.ports[1], eva.port_b_ext) annotation (Line(points={{-102,-80},
          {-59,-80},{-59,-59}}, color={0,127,255}));
  connect(source1.ports[1], hex.port_a2) annotation (Line(points={{-180,-68},{
          -154,-68},{-154,-30}}, color={0,127,255}));
  connect(abs.port_b_ext, con.port_a_ext) annotation (Line(points={{21,-53},{21,-132},{-256,-132},{-256,74},{-92,74},{-92,43},{-79,43}},
                                                                   color={0,127,
          255}));
  connect(hex.port_b2, pip.port_a) annotation (Line(points={{-154,-10},{-154,50},
          {-160,50}}, color={0,127,255}));
  connect(con.port_b_ext, pip.port_a) annotation (Line(points={{-77,41},{-77,30},
          {-110,30},{-110,50},{-160,50}}, color={0,127,255}));
  connect(senTem.port_a, pip.port_b)
    annotation (Line(points={{-190,50},{-180,50}}, color={0,127,255}));
  connect(sink_v3.ports[1], senTem.port_b)
    annotation (Line(points={{-220,50},{-210,50}}, color={0,127,255}));
  connect(hex.port_b1, eva.port_a_ext) annotation (Line(points={{-142,-30},{
          -142,-102},{-55,-102},{-55,-59}},            color={0,127,255}));
  connect(gen.port_l_b, hex_solution.port_a2) annotation (Line(points={{87,51},
          {87,42},{60,42},{60,30}}, color={0,127,255}));
  connect(gen.port_l_a, hex_solution.port_b1) annotation (Line(points={{73,51},
          {50,51},{50,30},{48,30}}, color={0,127,255}));
  connect(con.port_v, gen.port_v) annotation (Line(points={{-70,60},{-72,60},{
          -72,76},{80,76},{80,70}},
                                color={0,127,255}));
  connect(gen.port_a_ext, source4.ports[1]) annotation (Line(points={{87,69},{
          87,94},{84,94},{84,110},{90,110}}, color={0,127,255}));
  connect(hex.port_a1, gen.port_b_ext) annotation (Line(points={{-142,-10},{
          -142,20},{100,20},{100,64},{89,64},{89,67}},              color={0,
          127,255}));
  connect(Tr.y, source3.T_in) annotation (Line(points={{-261.1,-91},{-222,-91},
          {-222,-114},{-202,-114}}, color={0,0,127}));
  connect(Tr.y, source1.T_in) annotation (Line(points={{-261.1,-91},{-222,-91},
          {-222,-72},{-202,-72}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,-180},{160,140}})),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-180},{160,140}})),
    experiment(
      StopTime=61,
      Interval=0.1,
      Tolerance=1e-07),
    __Dymola_Commands(file="Resources\Static\AHE\Examples\AHE temperatures.mos" "Show AHE temperatures"));
end AHE_abs_con_serie;
