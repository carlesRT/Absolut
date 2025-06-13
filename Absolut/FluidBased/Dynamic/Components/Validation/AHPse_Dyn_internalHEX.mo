within Absolut.FluidBased.Dynamic.Components.Validation;
model AHPse_Dyn_internalHEX
  "Absorption heat pump model with internal HEX"
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
    annotation (Placement(transformation(extent={{86,-22},{66,-2}})));
  Modelica.Fluid.Sources.FixedBoundary sink_gen(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 200000,
    nPorts=1) annotation (Placement(transformation(extent={{78,94},{58,114}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_gen(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=1,
    T=373.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,70})));
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
  Modelica.Fluid.Sources.FixedBoundary sink_con(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-116,50},{-96,70}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_abs(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.28,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,-40})));
  Modelica.Fluid.Sources.MassFlowSource_T source_con(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.28,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-160,96})));
  Modelica.Fluid.Sources.FixedBoundary sink_abs(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{94,-90},{74,-70}})));
  Modelica.Blocks.Sources.RealExpression p_gen(y=7406)
    annotation (Placement(transformation(extent={{140,120},{100,140}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_gen(y=0.6216)
    annotation (Placement(transformation(extent={{140,100},{100,120}})));
  Modelica.Fluid.Sources.FixedBoundary sink_eva(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_eva(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.4,
    T=283.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-130,-70})));

  AHP.AHP_internal_hex ahp(
    flashing_w_m_flow_nominal=0.005,
    flashing_w_dp_nominal(displayUnit="Pa") = 7400 - 700,
    flashing_LiBr_m_flow_nominal=0.07,
    flashing_LiBr_dp_nominal(displayUnit="Pa") = 7400 - 700,
    eva_T_in_start=283.15,
    eva_T_out_start=277.15,
    gen_T_in_start=373.15,
    gen_T_out_start=370.15,
    abs_T_in_start=298.15,
    abs_T_out_start=307.15,
    con_T_in_start=298.15,
    con_T_out_start=310.15,
    eva_UA=(2250),
    eva_p_start(displayUnit="Pa") = 676,
    con_UA=(1200),
    con_p_start(displayUnit="Pa") = 7406,
    gen_UA=(1000),
    gen_X_LiBr_start=0.62,
    gen_p_start(displayUnit="Pa") = 7406,
    abs_UA=(1800),
    abs_p_start(displayUnit="Pa") = 676,
    abs_X_LiBr_start=0.5648,
    simpleHX_UA=3105/22.96,
    redeclare
      Absolut.FluidBased.Static.Components.HEX.PlateHeatExchangerEffectivenessNTU
      hex(
      Q_flow_nominal=3105,
      T_a1_nominal=305.87,
      T_a2_nominal=362.51) "Hex with variable UA")
    annotation (Placement(transformation(extent={{-24,4},{32,46}})));
  Modelica.Blocks.Sources.RealExpression control_level(y=ahp.gen.level)
    annotation (Placement(transformation(extent={{142,-6},{122,14}})));
  Buildings.Controls.Continuous.LimPID conPID(
    k=5,
    Ti=10,
    yMin=0.5,
    reverseActing=false)
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Blocks.Sources.RealExpression level_setpoint(y=0.05)
    annotation (Placement(transformation(extent={{154,20},{134,40}})));
  Buildings.Controls.Continuous.LimPID conPID_w(
    k=5,
    Ti=10,
    yMin=0.5,
    reverseActing=false)
    annotation (Placement(transformation(extent={{-120,16},{-100,36}})));
  Modelica.Blocks.Sources.RealExpression level_setpoint_con(y=0.05)
    annotation (Placement(transformation(extent={{-176,16},{-156,36}})));
  Modelica.Blocks.Sources.RealExpression control_level_con(y=ahp.con.level)
    annotation (Placement(transformation(extent={{-188,-10},{-168,10}})));
  Modelica.Fluid.Sensors.Temperature temperature_con_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-46,66},{-26,86}})));
  Modelica.Fluid.Sensors.Temperature temperature_gen_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{0,116},{20,136}})));
  Modelica.Fluid.Sensors.Temperature temperature_eva_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Modelica.Fluid.Sensors.Temperature temperature_abs_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-12,-80},{8,-60}})));
equation

  connect(ahp.m_flow_sol, MassFlowRate.y) annotation (Line(points={{32,21},{60,
          21},{60,-12},{65,-12}}, color={0,0,127}));
  connect(source_con.ports[1], ahp.port_con_a)
    annotation (Line(points={{-150,96},{-9,96},{-9,45}}, color={0,127,255}));
  connect(ahp.port_con_b, sink_con.ports[1]) annotation (Line(points={{-17.2,45},
          {-18,45},{-18,60},{-96,60}}, color={0,127,255}));
  connect(source_eva.ports[1], ahp.port_eva_a) annotation (Line(points={{-120,
          -70},{-18,-70},{-18,-2},{-12,-2},{-12,5},{-11,5}},
                                           color={0,127,255}));
  connect(sink_eva.ports[1], ahp.port_eva_b) annotation (Line(points={{-60,-50},
          {-20,-50},{-20,5},{-19,5}}, color={0,127,255}));
  connect(source_abs.ports[1], ahp.port_abs_a)
    annotation (Line(points={{76,-40},{29,-40},{29,5}}, color={0,127,255}));
  connect(ahp.port_abs_b, sink_abs.ports[1]) annotation (Line(points={{17,5},{
          18,5},{18,-80},{74,-80}}, color={0,127,255}));
  connect(ahp.port_gen_a, source_gen.ports[1])
    annotation (Line(points={{22.8,45},{22.8,70},{66,70}}, color={0,127,255}));
  connect(ahp.port_gen_b, sink_gen.ports[1])
    annotation (Line(points={{11,45},{11,104},{58,104}}, color={0,127,255}));
  connect(conPID.u_m, control_level.y)
    annotation (Line(points={{90,18},{90,4},{121,4}}, color={0,0,127}));
  connect(conPID.u_s, level_setpoint.y)
    annotation (Line(points={{102,30},{133,30}}, color={0,0,127}));
  connect(ahp.flashingLiBr_opening, conPID.y)
    annotation (Line(points={{32,29},{34,30},{79,30}}, color={0,0,127}));
  connect(conPID_w.u_m, control_level_con.y)
    annotation (Line(points={{-110,14},{-110,0},{-167,0}}, color={0,0,127}));
  connect(conPID_w.u_s, level_setpoint_con.y)
    annotation (Line(points={{-122,26},{-155,26}}, color={0,0,127}));
  connect(conPID_w.y, ahp.flashingWater_opening)
    annotation (Line(points={{-99,26},{-23.8,26}}, color={0,0,127}));
  connect(temperature_con_out.port, ahp.port_con_b) annotation (Line(points={{
          -36,66},{-36,60},{-17.2,60},{-17.2,45}}, color={0,127,255}));
  connect(temperature_gen_out.port, ahp.port_gen_b) annotation (Line(points={{
          10,116},{10,104},{11,104},{11,45}}, color={0,127,255}));
  connect(temperature_eva_out.port, ahp.port_eva_b) annotation (Line(points={{
          -130,-30},{-20,-30},{-20,5},{-19,5}}, color={0,127,255}));
  connect(temperature_abs_out.port, ahp.port_abs_b) annotation (Line(points={{
          -2,-80},{-2,-86},{17,-86},{17,5}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -120},{160,140}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-120},{160,
            140}})),
    experiment(
      StopTime=86400,
      Interval=0.100000224,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>Model of a single effect absorption heat pump with external fluids. </p>
<p>This model is used to evaluate the implementation of the model <a href=\"Absolut.FluidBased.Dynamic.AHP.AHP_internal_hex\">AHP_internal_hex</a> analogously to the validation model <a href=\"Absolut.FluidBased.Static.SingleEffect_UAfixed.Validation.AHP_se_UAfix_eps\">AHP_se_UAfix_eps</a>.</p>

<p><br>The data used to evaluate this circuit is obtained from table 6.3 of [1].</p>
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
end AHPse_Dyn_internalHEX;
