within Absolut.FluidBased.Static.DoubleEffect.Validation;
model AHP_pf_de_UAfix "Parallel flow double effect absorption heat pump"
extends Modelica.Icons.Example;

  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1";

  // Reference data
  parameter Modelica.Units.SI.HeatFlowRate P[2] = {2.1,2.2} "Pumps power";
  parameter Real EER_ref = 1.359 "Coefficient of performance ";
  parameter Modelica.Units.NonSI.Temperature_degC T[28]=
  {29.98,29.98,46.13,75.98,54.79,
  48.16,57.25,29.68,5.24,5.24,
  46.13,46.15,101.32,144.67,71.71,
  71.71,123.48,88.23,29.68,46.13,
  150,142.07,25,33.82,25,28.13,12,7.69};

  parameter Modelica.Units.SI.Pressure p_ref[3] = {888,4167,65540} "Pressure at three levels";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow[7] = {
  -360600,442500,183600,201900,-265400,34100,67400} "Heat flow rate at evaporator, absorber, condenser 1, condenser 2 / Generator 1, Generator 2, low pressure heat exchanger, high pressure heat exchanger";

  parameter Real Q6 = 0.004 "Vapour quality at point 6";
  parameter Real Q9 = 0.041 "Vapour quality at point 9";
  parameter Real Q16 = 0.012 "Vapour quality at point 16";
  parameter Real Q19 = 0.101 "Vapour quality at point 19";

  parameter Real X_LiBr_s = 0.61663 "X_LiBr concentration at strong solution (low pressure). E.g. point 4";
  parameter Real X_LiBr_w = 0.52343 "X_LiBr concentration at weak solution (low pressure). E.g. point 1";
  parameter Real h[20](each unit="J/g")=
  {68.7303, 68.7324, 102.8, 195.4, 155.3,
  155.3, 2606.8, 124.3, 124.3, 2510.2,
  102.8, 102.8, 221.7, 327.3, 187.3,
  187.3, 2726.6, 369.5, 369.5, 102.8};

  parameter Modelica.Units.SI.MassFlowRate m_s = 0.849 "Mass flow rate at strong solution. E.g. point 4";
  parameter Modelica.Units.SI.MassFlowRate m_w = 1 "Mass flow rate at weak solution. E.g. point 1";

 // Model

  DoubleEffect.LowGeneratorStatic gen_low(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    p_start(displayUnit="Pa") = 4167,
    UA=10000,
    X_LiBr_start=0.61663,
    port_l_b(m_flow(start=-0.849))) annotation (Placement(transformation(extent={{18,0},{38,20}})));
  Modelica.Blocks.Math.Gain              Q_in(k=-1)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.EvaporatorStatic_wHT_UAfix eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 888,
    T_17(start=285.15),
    T_18(start=280.85),
    UA=85000) annotation (Placement(transformation(extent={{-70,-102},{-50,-82}})));
  Absolut.FluidBased.Static.Components.FlashingWater flashingWater_lowp(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 4167 - 888,
    m_flow_nominal=0.066,
    use_opening=false,
    T_out_start=278.39,
    Q_intern_start=0.041)
    annotation (Placement(transformation(extent={{-90,-46},{-70,-26}})));
  DoubleEffect.CondenserStatic_de_UAfix con_low(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 4167,
    UA=65000,
    T_15(start=298.15),
    T_16(start=301.15)) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.RealExpression PumpSignal_lowp(y=1)
    annotation (Placement(transformation(extent={{-46,-66},{-6,-46}})));
  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBr_lowp(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = 4167 - 888,
    m_flow_nominal=0.849,
    use_opening=false,
    dp(displayUnit="Pa"),
    X_LiBr_start=0.61663,
    T_out_start=321.15,
    p_out_start(displayUnit="Pa") = 888,
    Q_intern_start=0.004)
    annotation (Placement(transformation(extent={{76,-80},{56,-60}})));
  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBr_highp(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 65540 - 4167,
    m_flow_nominal=0.481,
    use_opening=false,
    X_LiBr_start=0.61663,
    T_out_start=344.15,
    p_out_start(displayUnit="Pa") = 4167,
    Q_intern_start=0.012,
    port_a(m_flow(start=0.481)))
    annotation (Placement(transformation(extent={{40,48},{60,68}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_gen(y=0.61663)
    annotation (Placement(transformation(extent={{120,160},{80,180}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.GeneratorStatic_wHT_UAfix gen_high(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 65540,
    X_LiBr_start=0.61663,
    T_11(start=423.15),
    T_12(start=415.15),
    UA=25000) annotation (Placement(transformation(extent={{-8,134},{12,154}})));
  Modelica.Blocks.Sources.RealExpression p(y=65540)
    annotation (Placement(transformation(extent={{120,138},{80,158}})));
  Absolut.FluidBased.Static.Components.FlashingWater flashingWater_highp(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 65540 - 4167,
    m_flow_nominal=0.086,
    use_opening=false,
    T_out_start=302.83,
    Q_intern_start=0.101)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Absolut.FluidBased.Static.SingleEffect_intern.CondenserStatic con_high(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    p_start(displayUnit="Pa") = 65540) annotation (Placement(transformation(extent={{-98,130},{-78,150}})));
  Components.HEX.simpleHX HX2(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=1,
    m2_flow_nominal=1,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix(displayUnit="kW/K") = 2000,
    port_a1(p(start=65540))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,110})));

  Components.Pump pump_highp(redeclare package Medium_l = Medium_sol, T_in_start=gen_low.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,70})));
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
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix(displayUnit="kW/K") = 1250,
    port_a1(p(start=4167))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={38,-22})));

  Modelica.Blocks.Sources.RealExpression X_LiBr_gen_low(y=0.61663)
    annotation (Placement(transformation(extent={{160,0},{120,20}})));
  Absolut.FluidBased.Static.SingleEffect_UAfixed.AbsorberStatic_wHT_UAfix abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 888,
    X_LiBr_start=0.52343,
    T_13(start=298.15),
    T_14(start=306.97),
    UA=50000) annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Modelica.Blocks.Sources.RealExpression p_abs(y=888)
    annotation (Placement(transformation(extent={{140,-100},{100,-80}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_abs(y=0.52343)
    annotation (Placement(transformation(extent={{140,-120},{100,-100}})));
  Modelica.Blocks.Sources.RealExpression p_in_gen_low(y=4167)
    annotation (Placement(transformation(extent={{160,20},{120,40}})));
  Modelica.Blocks.Sources.RealExpression EER(y=(eva.Hb_flow)/(gen_high.Hb_flow))
    annotation (Placement(transformation(extent={{-100,180},{-60,200}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(con_low.Hb_flow + abs.Hb_flow)/
        (gen_high.Hb_flow))
    annotation (Placement(transformation(extent={{-40,180},{0,200}})));
  Modelica.Blocks.Sources.RealExpression Balance(y=con_low.Hb_flow + gen_high.Hb_flow
         + eva.Hb_flow + abs.Hb_flow - pump_lowp.W_dh - pump_highp.W_dh)
    annotation (Placement(transformation(extent={{-98,206},{-58,226}})));
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
  Modelica.Blocks.Sources.RealExpression PumpSignal_highp(y=0.567)
    annotation (Placement(transformation(extent={{-62,60},{-22,80}})));
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
    nPorts=1) annotation (Placement(transformation(extent={{60,140},{40,160}})));
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
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

equation

  connect(flashingWater_lowp.port_l_b, eva.port_l_a) annotation (Line(points={{-84.8,
          -45},{-84.8,-60},{-100,-60},{-100,-98},{-84,-98},{-84,-101},{-69,-101}},
                                                                 color={0,127,
          255}));
  connect(eva.port_v_a, flashingWater_lowp.port_v_b) annotation (Line(points={{-60,
          -82.2},{-75,-82.2},{-75,-45}},     color={0,127,255}));
  connect(gen_low.port_l_high, flashingLiBr_highp.port_l_b) annotation (Line(
        points={{33,19},{33,30},{45.2,30},{45.2,49}}, color={0,127,255}));
  connect(gen_low.port_v_high, flashingLiBr_highp.port_v_b) annotation (Line(
        points={{37,19},{37,26},{56,26},{56,49},{55,49}}, color={0,127,255}));
  connect(con_low.port_l, flashingWater_lowp.port_a) annotation (Line(points={{
          -70,-10},{-70,-12},{-80,-12},{-80,-27}}, color={0,127,255}));
  connect(flashingWater_highp.port_a, con_high.port_l) annotation (Line(points={{-90,79},
          {-90,130},{-88,130}},           color={0,127,255}));
  connect(con_high.port_v, gen_high.port_v)
    annotation (Line(points={{-88,150},{-88,154},{2,154}}, color={0,127,255}));
  connect(con_high.Hb_flow, Q_in.u) annotation (Line(points={{-79,140},{-68,140},
          {-68,40},{-42,40}}, color={0,0,127}));
  connect(gen_high.port_l_b, HX2.port_a2) annotation (Line(points={{9,135},{9,130},
          {34,130},{34,120}}, color={0,127,255}));
  connect(HX2.port_b2, flashingLiBr_highp.port_a) annotation (Line(points={{34,100},
          {34,86},{50,86},{50,67}},      color={0,127,255}));
  connect(pump_highp.port_l_b, HX2.port_a1) annotation (Line(points={{1.11022e-15,
          79},{1.11022e-15,86},{22,86},{22,100}},            color={0,127,255}));
  connect(HX2.port_b1, gen_high.port_l_a) annotation (Line(points={{22,120},{22,
          126},{-5,126},{-5,135}}, color={0,127,255}));
  connect(gen_low.port_l_b, HX1.port_a2)
    annotation (Line(points={{35,1},{44,1},{44,-12}}, color={0,127,255}));
  connect(HX1.port_b2, flashingLiBr_lowp.port_a)
    annotation (Line(points={{44,-32},{66,-32},{66,-61}}, color={0,127,255}));
  connect(pump_lowp.port_l_b, HX1.port_a1) annotation (Line(points={{24,-47},{24,
          -40},{32,-40},{32,-32}},    color={0,127,255}));
  connect(HX1.port_b1, gen_low.port_l_a)
    annotation (Line(points={{32,-12},{21,-12},{21,1}}, color={0,127,255}));
  connect(HX1.port_b1, pump_highp.port_l_a) annotation (Line(points={{32,-12},{0,
          -12},{0,52},{-8.88178e-16,52},{-8.88178e-16,61}},   color={0,127,255}));
  connect(abs.port_l_b, pump_lowp.port_l_a) annotation (Line(points={{25,-99},{20,
          -99},{20,-100},{14,-100},{14,-76},{24,-76},{24,-65}},
                                             color={0,127,255}));
  connect(abs.port_v, eva.port_v) annotation (Line(points={{21,-83},{-40,-83},{-40,
          -88},{-50.8,-88},{-50.8,-92}}, color={0,127,255}));
  connect(abs.port_v_a, flashingLiBr_lowp.port_v_b)
    annotation (Line(points={{39,-87},{61,-87},{61,-79}}, color={0,127,255}));
  connect(abs.port_l_a, flashingLiBr_lowp.port_l_b) annotation (Line(points={{
          39,-93},{70.8,-93},{70.8,-79}}, color={0,127,255}));
  connect(con_low.port_a_v, gen_low.port_v)
    annotation (Line(points={{-61,7},{-60,7},{-60,20},{14,20},{14,13},{19,13}},
                                                        color={0,127,255}));
  connect(con_low.port_v, flashingWater_highp.port_v_b) annotation (Line(points=
         {{-70,10},{-70,32},{-85,32},{-85,61}}, color={0,127,255}));
  connect(con_low.port_a_l, flashingWater_highp.port_l_b) annotation (Line(
        points={{-79,-1.8},{-94.8,-1.8},{-94.8,61}}, color={0,127,255}));
  connect(PumpSignal_lowp.y, pump_lowp.m_dot_in)
    annotation (Line(points={{-4,-56},{14,-56}}, color={0,0,127}));
  connect(source_23.ports[1], abs.port_a_ext) annotation (Line(points={{-20,-110},
          {12,-110},{12,-95},{21,-95}}, color={0,127,255}));
  connect(abs.port_b_ext, sink_24.ports[1]) annotation (Line(points={{21,-97},{18,
          -97},{18,-150},{-20,-150}},                     color={0,127,255}));
  connect(con_low.port_a_ext, source_25.ports[1]) annotation (Line(points={{-61,
          -7},{-46,-7},{-46,-20},{-142,-20}}, color={0,127,255}));
  connect(sink_26.ports[1], con_low.port_b_ext) annotation (Line(points={{-142,0},
          {-104,0},{-104,-14},{-63,-14},{-63,-9}}, color={0,127,255}));
  connect(gen_high.port_a_ext, source_21.ports[1])
    annotation (Line(points={{9,153},{9,190},{20,190}}, color={0,127,255}));
  connect(gen_high.port_b_ext, sink_22.ports[1]) annotation (Line(points={{11,151},
          {12,151},{12,150},{40,150}}, color={0,127,255}));
  connect(eva.port_a_ext, source_27.ports[1]) annotation (Line(points={{-55,-101},
          {-55,-150},{-100,-150}}, color={0,127,255}));
  connect(sink_28.ports[1], eva.port_b_ext) annotation (Line(points={{-100,-120},
          {-59,-120},{-59,-101}},color={0,127,255}));
  connect(PumpSignal_highp.y, pump_highp.m_dot_in)
    annotation (Line(points={{-20,70},{-10,70}}, color={0,0,127}));
  connect(gen_low.T_c, con_high.T_c) annotation (Line(points={{37,9},{74,9},{74,
          24},{-72,24},{-72,134},{-76,134},{-76,133},{-79,133}}, color={0,0,127}));
  connect(gen_low.Hb_flow_in, Q_in.y) annotation (Line(points={{37,6},{80,6},{80,
          40},{-19,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},
            {180,220}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,220}})),
    experiment(
      StopTime=6000,
      Interval=5,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>Model of a parallel flow double effect absorption heat pump with external fluids. Model is based on figure 7.5 of [1].</p>
<p>UA values of the main heat exchangers as well as the solution heat exchangers are fixed.</p>
<p>Main input variables are...</p>
<ul>
<li>External fluids: Mass flow rate and temperature at each vessel.</li>
<li>Mass flow rate of the solution going from absorber to low-pressure generator, and from the low-pressure generator to the high-pressure generator</li>
</ul>
<p>The initial values are key for this kind of model (static with non-linear systems of equations) to run. E.g. pressure values at heat exchangers needed to be set, otherwise a standard valued of 1 bar is used and the model fails to run. </p>
<p><br><br>The data used to evaluate this circuit is obtained from table 7.4 of [1].</p>
<p><br><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
    __Dymola_Commands(file="Resources\Static\DoubleEffect\Validation\AHP_de_Table74.mos"
        "Plot",
        file="Resources\Static\DoubleEffect\Validation\AHP_pf_de_UAfix.mos"
        "Simulate and plot"));
end AHP_pf_de_UAfix;
