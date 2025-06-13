within Absolut.FluidBased.Dynamic.Components.Validation;
model AHPse_Dyn_heatport_nocp
  "Absorption heat pump model with external HEX (use of heat port)."
extends Modelica.Icons.Example;

  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);

parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1";
    parameter Integer nEle = 10
    "discretization of pipe";

  // Reference data
    extends Absolut.FluidBased.Dynamic.Components.BaseClasses.ReferenceData;
  // Model

  Modelica.Blocks.Sources.RealExpression MassFlowRate(y=0.05)
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));
  Modelica.Fluid.Sources.FixedBoundary sink_gen(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 200000,
    nPorts=1) annotation (Placement(transformation(extent={{60,100},{40,120}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_gen(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=1,
    T=373.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,70})));
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
  Modelica.Fluid.Sources.FixedBoundary sink_con(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_abs(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.28,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-30})));
  Modelica.Fluid.Sources.MassFlowSource_T source_con(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.28,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,110})));
  Modelica.Fluid.Sources.FixedBoundary sink_abs(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{80,-80},{60,-60}})));
  Modelica.Blocks.Sources.RealExpression p_gen(y=7406)
    annotation (Placement(transformation(extent={{140,120},{100,140}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_gen(y=0.6216)
    annotation (Placement(transformation(extent={{140,100},{100,120}})));
  Modelica.Fluid.Sources.FixedBoundary sink_eva(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_eva(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.4,
    T=283.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-50})));

  AHP.AHP_nocp ahp(
    flashing_w_m_flow_nominal=0.005,
    flashing_w_dp_nominal(displayUnit="Pa") = 7400 - 700,
    flashing_LiBr_m_flow_nominal=0.07,
    flashing_LiBr_dp_nominal(displayUnit="Pa") = 7400 - 700,
    pipemass_eva_T_start=283.15,
    pipemass_con_T_start=298.15,
    pipemass_abs_T_start=298.15,
    pipemass_gen_T_start=373.15,
    eva_UA=(2250),
    m_eva=0.4,
    eva_p_start(displayUnit="Pa") = 676,
    con_UA=(1200),
    m_con=0.28,
    con_p_start(displayUnit="Pa") = 7406,
    gen_UA=(1000),
    m_gen=1,
    gen_X_LiBr_start=0.62,
    gen_p_start(displayUnit="Pa") = 7406,
    abs_UA=(1800),
    m_abs=0.28,
    abs_p_start(displayUnit="Pa") = 676,
    abs_X_LiBr_start=0.5648,
    simpleHX_UA=3105/22.96)
    annotation (Placement(transformation(extent={{-26,8},{30,50}})));
  Modelica.Blocks.Sources.RealExpression control_level(y=ahp.gen.level)
    annotation (Placement(transformation(extent={{140,-10},{120,10}})));
  Buildings.Controls.Continuous.LimPID conPID(
    k=10,
    Ti=10,
    reverseActing=false)
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Blocks.Sources.RealExpression level_setpoint(y=0.05)
    annotation (Placement(transformation(extent={{140,20},{120,40}})));
  Buildings.Controls.Continuous.LimPID conPID_w(
    k=10,
    Ti=10,
    reverseActing=false)
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Sources.RealExpression level_setpoint_con(y=0.05)
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Modelica.Blocks.Sources.RealExpression control_level_con(y=ahp.con.level)
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Modelica.Fluid.Sensors.Temperature temperature_eva_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-68,2},{-48,22}})));
  Modelica.Fluid.Sensors.Temperature temperature_abs_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-18,-94},{2,-74}})));
  Modelica.Fluid.Sensors.Temperature temperature_con_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-52,76},{-32,96}})));
  Modelica.Fluid.Sensors.Temperature temperature_gen_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{12,78},{32,98}})));
equation

  connect(ahp.m_flow_sol, MassFlowRate.y) annotation (Line(points={{30,25},{40,
          25},{40,-10},{59,-10}}, color={0,0,127}));
  connect(source_con.ports[1], ahp.port_con_a) annotation (Line(points={{-60,
          110},{-11,110},{-11,49}}, color={0,127,255}));
  connect(ahp.port_con_b, sink_con.ports[1]) annotation (Line(points={{-19,49},
          {-20,49},{-20,70},{-60,70}}, color={0,127,255}));
  connect(source_eva.ports[1], ahp.port_eva_a) annotation (Line(points={{-60,
          -50},{-12,-50},{-12,9},{-13,9}}, color={0,127,255}));
  connect(sink_eva.ports[1], ahp.port_eva_b) annotation (Line(points={{-70,-12},
          {-22,-12},{-22,9},{-21,9}}, color={0,127,255}));
  connect(source_abs.ports[1], ahp.port_abs_a)
    annotation (Line(points={{60,-30},{27,-30},{27,9}}, color={0,127,255}));
  connect(ahp.port_abs_b, sink_abs.ports[1]) annotation (Line(points={{15,9},{
          16,9},{16,-70},{60,-70}}, color={0,127,255}));
  connect(ahp.port_gen_a, source_gen.ports[1])
    annotation (Line(points={{20.8,49},{20.8,70},{40,70}}, color={0,127,255}));
  connect(ahp.port_gen_b, sink_gen.ports[1])
    annotation (Line(points={{9,49},{9,110},{40,110}}, color={0,127,255}));
  connect(conPID.u_m, control_level.y)
    annotation (Line(points={{90,18},{90,0},{119,0}}, color={0,0,127}));
  connect(conPID.u_s, level_setpoint.y)
    annotation (Line(points={{102,30},{119,30}}, color={0,0,127}));
  connect(ahp.flashingLiBr_opening, conPID.y)
    annotation (Line(points={{30,33},{30,30},{79,30}}, color={0,0,127}));
  connect(conPID_w.u_m, control_level_con.y) annotation (Line(points={{-110,18},
          {-110,-10},{-139,-10}}, color={0,0,127}));
  connect(conPID_w.u_s, level_setpoint_con.y)
    annotation (Line(points={{-122,30},{-139,30}}, color={0,0,127}));
  connect(conPID_w.y, ahp.flashingWater_opening)
    annotation (Line(points={{-99,30},{-25.8,30}}, color={0,0,127}));
  connect(temperature_eva_out.port, ahp.port_eva_b)
    annotation (Line(points={{-58,2},{-58,9},{-21,9}}, color={0,127,255}));
  connect(temperature_abs_out.port, ahp.port_abs_b)
    annotation (Line(points={{-8,-94},{15,-94},{15,9}}, color={0,127,255}));
  connect(temperature_con_out.port, ahp.port_con_b) annotation (Line(points={{
          -42,76},{-44,76},{-44,49},{-19,49}}, color={0,127,255}));
  connect(temperature_gen_out.port, ahp.port_gen_b) annotation (Line(points={{
          22,78},{4,78},{4,49},{9,49}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -120},{140,140}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{140,
            140}})),
    experiment(
      StopTime=86400,
      Interval=0.1,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>Model of a single effect absorption heat pump with external fluids. </p>
<p>This model is used to evaluate the implementation of the model <a href=\"Absolut.FluidBased.Dynamic.AHP.AHP_nocp\">AHP_nocp</a> analogously to the validation model <a href=\"Absolut.FluidBased.Static.SingleEffect_intern.Validation.AHP_se_eps\">AHP_se_eps</a>.</p>
<p><br>The data used to evaluate this circuit is obtained from table 6.1 of [1]. </p>
<p>Heat exchanger UA values in W/K are fixed. </p>
<p>Main input variables are...</p>
<ul>
<li>External fluids: Mass flow rate and temperature at each vessel.</li>
<li>Mass flow rate of the solution going from absorber to generator</li>
</ul>
<p><br><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
    __Dymola_Commands(file="Resources/Dynamic/Validation/AHP_se_dynamic_Table61_plot.mos" "AHP_se_dyn_Table61", file="Resources/Dynamic/Validation/AHP_se_dynamic_Table63.mos"
        "AHP_se_dynamic_Table63"));
end AHPse_Dyn_heatport_nocp;
