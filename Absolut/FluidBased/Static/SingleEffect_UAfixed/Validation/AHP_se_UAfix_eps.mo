within Absolut.FluidBased.Static.SingleEffect_UAfixed.Validation;
model AHP_se_UAfix_eps
  "Single stage absorption heat pump model (Fixed UA values at main heat exchangers. Solution heat echanger using effectivenes)"
extends Modelica.Icons.Example;

  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  //replaceable package Medium_sol = Absolut.ModelicaConf.LiBrH2O_pT;
  //replaceable package Medium_sol = Absolut.ModelicaConf.LiBrH2O_noDer;
  //replaceable package Medium_sol =Absolut.ModelicaConf.LiBrH2O_noDer_noInline;
  //
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);

parameter Boolean allowFlowReversal=false
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1";

// Reference data
  parameter Modelica.Units.NonSI.Temperature_degC T[18] = {32.72,32.72,63.61,89.36,53.11,44.96,76.76,40.06,1.39,1.39,
  100,96.51,25,37.03,25,34.65,10,3.64};
  parameter Real Q6 = 0.005 "Vapour quality at point 6";
  parameter Real Q9 = 0.065 "Vapour quality at point 9";
  parameter Real X_LiBr_s = 0.6216 "X_LiBr concentration at strong solution. E.g. point 4";
  parameter Real X_LiBr_w = 0.5648 "X_LiBr concentration at weak solution. E.g. point 1";
  parameter Real h[10](each unit="J/g") = {87.76386,87.76386,149.9,223.3,255,255,2643.1,167.8,167.8,2503.1};
  parameter Modelica.Units.SI.MassFlowRate m_s = 0.05 "Mass flow rate at strong solution. E.g. point 4";
  parameter Modelica.Units.SI.MassFlowRate m_w = 0.04543 "Mass flow rate at weak solution. E.g. point 1";
  parameter Modelica.Units.SI.HeatFlowRate Qcon_ref = 11.31*1000 "Heat flow rate at condenser";
  parameter Modelica.Units.SI.HeatFlowRate Qeva_ref = -10.67*1000 "Heat flow rate at evaporator";
  parameter Modelica.Units.SI.HeatFlowRate Qgen_ref = -14.73*1000 "Heat flow rate at generator";
  parameter Modelica.Units.SI.HeatFlowRate Qabs_ref = 14.09*1000 "Heat flow rate at absorber";
  parameter Modelica.Units.SI.HeatFlowRate Qsol_ref = 3.105*1000 "Heat flow rate at solution heat exchanger";

// Model
  Absolut.FluidBased.Static.Components.FlashingWater flashingWater(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 7406 - 676,
    m_flow_nominal=0.00457,
    use_opening=false,
    T_out_start=274.54,
    Q_intern_start=0.065)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  SingleEffect_UAfixed.CondenserStatic_wHT_UAfix con(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 7406,
    T_start=313.15,
    T_15(start=298.15),
    T_16(start=307.8),
    UA=1200) annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
  SingleEffect_UAfixed.EvaporatorStatic_wHT_UAfix eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 1000,
    T_start=281.15,
    T_18(start=280.15),
    UA=2250) annotation (Placement(transformation(extent={{-70,-58},{-50,-38}})));
  SingleEffect_UAfixed.GeneratorStatic_wHT_UAfix gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 7406,
    T_start=362.15,
    m_dot_start=0.01,
    X_LiBr_start=0.6216,
    X_LiBr(start=0.6216),
    T_11(start=373.15),
    T_12(start=369.66),
    UA=1000,
    port_l_b(m_flow(start=-0.04543))) annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBr(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 7406 - 676,
    m_flow_nominal=0.04543,
    use_opening=false,
    X_LiBr_start=0.6216,
    T_out_start=318.11,
    p_out_start(displayUnit="Pa") = 676,
    Q_intern_start=0.005)
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  Modelica.Blocks.Sources.RealExpression MassFlowRate(y=0.05)
    annotation (Placement(visible = true, transformation(                  extent = {{-40, -30}, {-20, -10}}, rotation = 0)));
  SingleEffect_UAfixed.AbsorberStatic_wHT_UAfix abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = 676,
    T_start=305.85,
    X_LiBr_start=0.5648,
    p(displayUnit="kPa"),
    T_13(start=298.15),
    T_14(start=310.15),
    dT_used(start=9.42),
    UA=1800) annotation (Placement(transformation(extent={{22,-62},{42,-42}})));
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
    eps=0.64)                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={56,18})));
  Modelica.Fluid.Sources.FixedBoundary sink_gen(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 200000,
    nPorts=1) annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_gen(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=1,
    T=373.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,90})));
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
  Modelica.Fluid.Sources.FixedBoundary sink_con(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_abs(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.28,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-8,-76})));
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
        eva.Hb_flow + abs.Hb_flow - pump.W_dh)
    annotation (Placement(transformation(extent={{-80,120},{-40,140}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_con(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.28,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-130,70})));
  Modelica.Fluid.Sources.FixedBoundary sink_abs(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Modelica.Fluid.Sources.FixedBoundary sink_eva(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_eva(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.4,
    T=283.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-100})));

equation

  connect(flashingWater.port_a, con.port_l)
    annotation (Line(points={{-70,19},{-70,40}}, color={0,127,255}));
  connect(flashingWater.port_l_b, eva.port_l_a) annotation (Line(points={{-74.8,1},
          {-74.8,-14},{-86,-14},{-86,-57},{-69,-57}},    color={0,127,255}));
  connect(eva.port_v_a, flashingWater.port_v_b) annotation (Line(points={{-60,
          -38.2},{-65,-38.2},{-65,1}},
                                color={0,127,255}));
  connect(con.port_v, gen.port_v) annotation (Line(points={{-70,60},{-70,68},{
          40,68},{40,60}},
                        color={0,127,255}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-50.8,-48},{-20,-48},
          {-20,-45},{23,-45}}, color={0,127,255}));
  connect(abs.port_v_a, flashingLiBr.port_v_b)
    annotation (Line(points={{41,-49},{65,-49},{65,-39}}, color={0,127,255}));
  connect(abs.port_l_a, flashingLiBr.port_l_b) annotation (Line(points={{41,-55},
          {74.8,-55},{74.8,-39}}, color={0,127,255}));
  connect(hex.port_b1, gen.port_l_a) annotation (Line(points={{50,28},{20,28},{20,
          40},{33,40},{33,41}}, color={0,127,255}));
  connect(hex.port_a2, gen.port_l_b)
    annotation (Line(points={{62,28},{62,41},{47,41}}, color={0,127,255}));
  connect(hex.port_b2, flashingLiBr.port_a) annotation (Line(points={{62,8},{62,
          0},{70,0},{70,-21}},   color={0,127,255}));
  connect(con.port_b_ext, sink_con.ports[1])
    annotation (Line(points={{-77,41},{-78,41},{-78,30},{-120,30}},
                                                           color={0,127,255}));
  connect(source_abs.ports[1], abs.port_a_ext) annotation (Line(points={{2,-76},
          {8,-76},{8,-57},{23,-57}}, color={0,127,255}));
  connect(abs.port_l_b, pump.port_l_a)
    annotation (Line(points={{27,-61},{10,-61},{10,-29}}, color={0,127,255}));
  connect(pump.port_l_b, hex.port_a1) annotation (Line(points={{10,-11},{10,0},
          {50,0},{50,8}},color={0,127,255}));
  connect(pump.m_dot_in, MassFlowRate.y)
    annotation (Line(points={{0,-20},{-19,-20}}, color={0,0,127}));
  connect(abs.port_b_ext, sink_abs.ports[1])
    annotation (Line(points={{23,-59},{23,-110},{0,-110}}, color={0,127,255}));
  connect(source_con.ports[1], con.port_a_ext) annotation (Line(points={{-120,70},
          {-88,70},{-88,43},{-79,43}},     color={0,127,255}));
  connect(source_gen.ports[1], gen.port_a_ext)
    annotation (Line(points={{80,90},{47,90},{47,59}}, color={0,127,255}));
  connect(gen.port_b_ext, sink_gen.ports[1]) annotation (Line(points={{49,57},{
          60,57},{60,50},{80,50}}, color={0,127,255}));
  connect(sink_eva.ports[1], eva.port_b_ext) annotation (Line(points={{-100,-70},
          {-59,-70},{-59,-57}},                     color={0,127,255}));
  connect(source_eva.ports[1], eva.port_a_ext) annotation (Line(points={{-100,
          -100},{-55,-100},{-55,-57}},                 color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},
            {180,140}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,140}})),
    experiment(
      StopTime=360,
      Interval=1,
      Tolerance=1e-07,
      __Dymola_Algorithm="Rkfix4"),
    __Dymola_Commands(file="Resources\Static\SingleEffect_intern\Validation\AHP_se_eps_Table61_plot.mos" "Plot Table 6.1", file=
          "Resources\Static\SingleEffect_UAfixed\Validation\AHP_se_Table63.mos" "Plot Table 6.3"),
    Documentation(info="<html>
<p>Model of a single effect absorption heat pump with external fluids.</p>
<p>Heat exchanger UA values in W/K are fixed. </p>
<p>Main input variables are...</p>
<ul>
<li>External fluids: Mass flow rate and temperature at each vessel.</li>
<li>Mass flow rate of the solution going from absorber to generator</li>
</ul>
<p>The initial values are key for this kind of model (static with non-linear systems of equations) to run. E.g. mass flow rate at generator needed to be explicitely set, otherwise a 0 value is used and the model fails to run. </p>
<p><br><br>The data used to evaluate this circuit is obtained from table 6.3 of [1].</p>
<p><br><br><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"));
end AHP_se_UAfix_eps;
