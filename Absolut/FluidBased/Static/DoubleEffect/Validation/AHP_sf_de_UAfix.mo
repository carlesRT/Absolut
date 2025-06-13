within Absolut.FluidBased.Static.DoubleEffect.Validation;
model AHP_sf_de_UAfix
  "Series flow double effect absorption heat pump (High desorber first)"
extends Modelica.Icons.Example;

  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);

  parameter Boolean allowFlowReversal=false
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1";

  // Reference data
  parameter Modelica.Units.SI.HeatFlowRate P = 0.048 "Pump's power";
  parameter Real COP_ref = 1.242 "Coefficient of performance";
  parameter Modelica.Units.NonSI.Temperature_degC T[25]=
  {30.04,30.06,46.98,
  78.32,55.87,49.27,
  66.84,30.45,5.02,5.02,
  89.67,138.35,89.92,68.76,128.68,92.5,30.45,150,141.03,25,
  34.14,25,28.65,12,7.55};

  parameter Modelica.Units.SI.Pressure p_ref[3] = {874,4355,77046} "Pressure at three levels";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow[7] = {
  -372500, 458800, 213800,
  185500, -300000, 35600, 91500}
    "Heat flow rate at evaporator, absorber, condenser 1, condenser 2 / Generator 1, Generator 2, low pressure heat exchanger, high pressure heat exchanger";

  parameter Real Q6 = 0.004 "Vapour quality at point 6";
  parameter Real Q9 = 0.043 "Vapour quality at point 9";
  parameter Real Q16 = 0.016 "Vapour quality at point 16";
  parameter Real Q19 = 0.107 "Vapour quality at point 19";

  parameter Real X_LiBr_s = 0.62276 "X_LiBr concentration at strong solution (low pressure). E.g. point 4";
  parameter Real X_LiBr_w = 0.52537 "X_LiBr concentration at weak solution (low pressure). E.g. point 1";
  parameter Real X_LiBr_m = 0.57044 "X_LiBr concentration at mid solution (low pressure). E.g. point 1";

  parameter Real h[20](each unit="J/g")=
  {68.7303, 68.7324, 102.8, 195.4, 155.3,
  155.3, 2606.8, 124.3, 124.3, 2510.2,
  102.8, 102.8, 221.7, 327.3, 187.3,
  187.3, 2726.6, 369.5, 369.5, 102.8};

  parameter Modelica.Units.SI.MassFlowRate m_s1 = 0.844 "Mass flow rate at strong solution from desorber 1. E.g. point 4";
  parameter Modelica.Units.SI.MassFlowRate m_w = 1 "Mass flow rate at weak solution. E.g. point 1";
  parameter Modelica.Units.SI.MassFlowRate m_s2 = 0.921 "Mass flow rate at strong solution from desorber 2. E.g. point 15";

 // Model

  DoubleEffect.LowGeneratorStatic_serie gen_low(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    p_start(displayUnit="Pa"),
    T_start=351.15,
    UA=10000,
    port_l_b(m_flow(start=-0.844)),
    X_LiBr_start=0.62276) annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Math.Gain              Q_in(k=-1)
    annotation (Placement(transformation(extent={{-40,28},{-20,48}})));
  Absolut.FluidBased.Static.Components.FlashingWater flashingWaterUnder_lowp(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 4167 - 888,
    m_flow_nominal=0.066,
    use_opening=false,
    T_out_start=278.15,
    Q_intern_start=0.043)
    annotation (Placement(transformation(extent={{-90,-46},{-70,-26}})));
  DoubleEffect.CondenserStatic_de_UAfix con_low(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 4355,
    T_start=303.65,
    UA=65000,
    T_15(start=298.15),
    T_16(start=301.8)) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.RealExpression PumpSignal(y=1)
    annotation (Placement(transformation(extent={{-46,-66},{-6,-46}})));
  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBrUnder_lowp(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = 4167 - 888,
    m_flow_nominal=0.849,
    use_opening=false,
    dp(displayUnit="Pa"),
    X_LiBr_start=0.62276,
    T_out_start=322.15,
    p_out_start(displayUnit="Pa") = 874,
    Q_intern_start=0.004)
    annotation (Placement(transformation(extent={{76,-80},{56,-60}})));
  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBrUnder_highp(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 65540 - 4167,
    m_flow_nominal=0.481,
    use_opening=false,
    X_LiBr_start=0.57044,
    T_out_start=342.15,
    p_out_start(displayUnit="Pa") = 4355,
    Q_intern_start=0.016,
    port_a(m_flow(start=0.921)))
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_gen(y=0.57044)
    annotation (Placement(transformation(extent={{120,160},{80,180}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.GeneratorStatic_wHT_UAfix gen_high(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 77046,
    T_start=411.15,
    m_dot_start=0.5,
    X_LiBr_start=0.57044,
    T_11(start=423.15),
    T_12(start=414.15),
    UA=25000) annotation (Placement(transformation(extent={{-8,134},{12,154}})));
  Modelica.Blocks.Sources.RealExpression p(y=77046)
    annotation (Placement(transformation(extent={{120,138},{80,158}})));
  Absolut.FluidBased.Static.Components.FlashingWater flashingWaterUnder_highp(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 65540 - 4167,
    m_flow_nominal=0.086,
    use_opening=false,
    T_out_start=303.65,
    Q_intern_start=0.107)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Absolut.FluidBased.Static.SingleEffect_intern.CondenserStatic con_high(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    p_start(displayUnit="Pa") = 77046,
    T_start=365.65) annotation (Placement(transformation(extent={{-100,132},{-80,152}})));
  Components.HEX.simpleHX HX2(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=1,
    m2_flow_nominal=1,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix(displayUnit="kW/K") = 2000,
    port_a1(p(start=77000))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,110})));

  Components.Pump pump_lowp(redeclare package Medium_l = Medium_sol, T_in_start=abs.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={24,-56})));
  Components.HEX.simpleHX HX1(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=1,
    m2_flow_nominal=1,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix(displayUnit="kW/K") = 1250,
    port_a2(p(start=4355))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={34,-28})));

  Modelica.Blocks.Sources.RealExpression X_LiBr_gen_low(y=0.62276)
    annotation (Placement(transformation(extent={{144,-18},{104,2}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.AbsorberStatic_wHT_UAfix abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 874,
    T_start=303.15,
    X_LiBr_start=0.52537,
    T_13(start=298.15),
    T_14(start=307.15),
    dT_used(start=9.176),
    UA=50000) annotation (Placement(transformation(extent={{20,-96},{40,-76}})));
  Modelica.Blocks.Sources.RealExpression p_abs(y=874)
    annotation (Placement(transformation(extent={{140,-100},{100,-80}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_abs(y=0.52537)
    annotation (Placement(transformation(extent={{140,-120},{100,-100}})));
  Modelica.Blocks.Sources.RealExpression p_in_gen_low(y=4355)
    annotation (Placement(transformation(extent={{146,0},{106,20}})));
  Modelica.Blocks.Sources.RealExpression EER(y=(eva.Hb_flow)/(gen_high.Hb_flow))
    annotation (Placement(transformation(extent={{-100,180},{-60,200}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(con_low.Hb_flow + abs.Hb_flow)/
        (gen_high.Hb_flow))
    annotation (Placement(transformation(extent={{-40,180},{0,200}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_23(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=12,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-110})));
  Modelica.Fluid.Sources.FixedBoundary sink_24(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1) annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (choicesAllMatching=true);
  Modelica.Fluid.Sources.MassFlowSource_T source_25(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=14,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-152,-20})));
  Modelica.Fluid.Sources.FixedBoundary sink_26(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-162,-10},{-142,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_21(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=8,
    T=423.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,190})));
  Modelica.Fluid.Sources.FixedBoundary sink_22(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,140},{40,160}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_27(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=20,
    T=285.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-150})));
  Modelica.Fluid.Sources.FixedBoundary sink_28(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-122,-130},{-102,-110}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.EvaporatorStatic_wHT_UAfix eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_l,
    p_start(displayUnit="Pa") = 874,
    T_start=278.15,
    T_17(start=285.15),
    T_18(start=280.7),
    UA=85000) annotation (Placement(transformation(extent={{-90,-98},{-70,-78}})));

equation
  connect(gen_low.port_l_high, flashingLiBrUnder_highp.port_l_b) annotation (
      Line(points={{35,19},{35,30},{45.2,30},{45.2,51}}, color={0,127,255}));
  connect(gen_low.port_v_high, flashingLiBrUnder_highp.port_v_b) annotation (
      Line(points={{39,19},{39,26},{56,26},{56,51},{55,51}}, color={0,127,255}));
  connect(con_low.port_l, flashingWaterUnder_lowp.port_a) annotation (Line(
        points={{-70,-10},{-70,-12},{-80,-12},{-80,-27}},color={0,127,255}));
  connect(flashingWaterUnder_highp.port_a, con_high.port_l) annotation (Line(
        points={{-90,79},{-90,132}},           color={0,127,255}));
  connect(con_high.port_v, gen_high.port_v)
    annotation (Line(points={{-90,152},{-90,154},{2,154}}, color={0,127,255}));
  connect(con_high.Hb_flow, Q_in.u) annotation (Line(points={{-81,142},{-68,142},
          {-68,38},{-42,38}}, color={0,0,127}));
  connect(gen_high.port_l_b, HX2.port_a2) annotation (Line(points={{9,135},{9,
          130},{34,130},{34,120}},
                              color={0,127,255}));
  connect(HX2.port_b2, flashingLiBrUnder_highp.port_a) annotation (Line(points={{34,100},
          {34,86},{50,86},{50,69}},         color={0,127,255}));
  connect(HX2.port_b1, gen_high.port_l_a) annotation (Line(points={{22,120},{22,
          126},{-5,126},{-5,135}}, color={0,127,255}));
  connect(gen_low.port_l_b, HX1.port_a2)
    annotation (Line(points={{37,1},{40,1},{40,-18}}, color={0,127,255}));
  connect(HX1.port_b2, flashingLiBrUnder_lowp.port_a)
    annotation (Line(points={{40,-38},{66,-38},{66,-61}}, color={0,127,255}));
  connect(pump_lowp.port_l_b, HX1.port_a1) annotation (Line(points={{24,-47},{24,
          -38},{28,-38}},             color={0,127,255}));
  connect(abs.port_l_b, pump_lowp.port_l_a) annotation (Line(points={{25,-95},{
          20,-95},{20,-100},{10,-100},{10,-76},{24,-76},{24,-65}},
                                             color={0,127,255}));
  connect(abs.port_v_a, flashingLiBrUnder_lowp.port_v_b)
    annotation (Line(points={{39,-83},{61,-83},{61,-79}}, color={0,127,255}));
  connect(abs.port_l_a, flashingLiBrUnder_lowp.port_l_b) annotation (Line(
        points={{39,-89},{70.8,-89},{70.8,-79}}, color={0,127,255}));
  connect(con_low.port_a_v, gen_low.port_v)
    annotation (Line(points={{-61,7},{-52,7},{-52,14},{22,14},{22,13},{21,13}},
                                                        color={0,127,255}));
  connect(con_low.port_v, flashingWaterUnder_highp.port_v_b) annotation (Line(
        points={{-70,10},{-70,32},{-85,32},{-85,61}}, color={0,127,255}));
  connect(con_low.port_a_l, flashingWaterUnder_highp.port_l_b) annotation (Line(
        points={{-79,-1.8},{-94.8,-1.8},{-94.8,61}},
                                                   color={0,127,255}));
  connect(PumpSignal.y, pump_lowp.m_dot_in)
    annotation (Line(points={{-4,-56},{14,-56}}, color={0,0,127}));
  connect(source_23.ports[1], abs.port_a_ext) annotation (Line(points={{-20,
          -110},{0,-110},{0,-91},{21,-91}},
                                        color={0,127,255}));
  connect(abs.port_b_ext, sink_24.ports[1]) annotation (Line(points={{21,-93},{
          18,-93},{18,-150},{-20,-150}},                  color={0,127,255}));
  connect(con_low.port_a_ext, source_25.ports[1]) annotation (Line(points={{-61,
          -7},{-46,-7},{-46,-20},{-142,-20}}, color={0,127,255}));
  connect(sink_26.ports[1], con_low.port_b_ext) annotation (Line(points={{-142,
          0},{-104,0},{-104,-14},{-63,-14},{-63,-9}}, color={0,127,255}));
  connect(gen_high.port_a_ext, source_21.ports[1])
    annotation (Line(points={{9,153},{9,190},{20,190}}, color={0,127,255}));
  connect(gen_high.port_b_ext, sink_22.ports[1]) annotation (Line(points={{11,
          151},{12,151},{12,150},{40,150}}, color={0,127,255}));
  connect(HX1.port_b1, HX2.port_a1) annotation (Line(points={{28,-18},{28,-16},{
          -10,-16},{-10,82},{22,82},{22,100}},  color={0,127,255}));
  connect(eva.port_l_a, flashingWaterUnder_lowp.port_l_b) annotation (Line(
        points={{-89,-97},{-94,-97},{-94,-50},{-84.8,-50},{-84.8,-45}}, color={0,
          127,255}));
  connect(eva.port_v_a, flashingWaterUnder_lowp.port_v_b) annotation (Line(
        points={{-80,-78.2},{-80,-50},{-75,-50},{-75,-45}}, color={0,127,255}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-70.8,-88},{16,-88},
          {16,-79},{21,-79}}, color={0,127,255}));
  connect(eva.port_b_ext, sink_28.ports[1]) annotation (Line(points={{-79,-97},{
          -79,-120},{-102,-120}}, color={0,127,255}));
  connect(eva.port_a_ext, source_27.ports[1]) annotation (Line(points={{-75,-97},
          {-75,-150},{-100,-150}}, color={0,127,255}));
  connect(con_high.T_c, gen_low.T_c) annotation (Line(points={{-81,135},{-54,135},
          {-54,92},{80,92},{80,9},{39,9}}, color={0,0,127}));
  connect(Q_in.y, gen_low.Hb_flow_in) annotation (Line(points={{-19,38},{62,38},
          {62,6},{39,6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,180}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            180}})),
    experiment(
      StopTime=6000,
      Interval=5,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>Model of a series flow double effect absorption heat pump with solution going first to the high pressure generator. Model is based on figure 7.3 of [1].</p>
<p>UA values of the main heat exchangers as well as the solution heat exchangers are fixed. The high pressure condenser does not require a UA value.</p>
<p>Main input variables are...</p>
<ul>
<li>External fluids: Mass flow rate and temperature at each vessel.</li>
<li>Mass flow rate of the solution going from absorber to high-pressure generator trough both solution heat exchangers.</li>
</ul>
<p><br><br>The data used to evaluate this circuit is obtained from table 7.5 of [1].</p>
<p><br><br><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
__Dymola_Commands(file="Resources\Static\DoubleEffect\Validation\AHP_de_Table74.mos"
        "Plot",
        file="Resources\Static\DoubleEffect\Validation\AHP_sf_de_UAfix.mos"
        "Simulate and plot"));
end AHP_sf_de_UAfix;
