within Absolut.FluidBased.Dynamic.Components.Validation;
model AHPse_Dyn_pump_extended
  "Single stage absorption heat pump model (Fixed UA values at main heat exchangers. Solution heat echanger using effectivenes)"
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
    p(displayUnit="bar") = 100000,
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
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_eva(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0.4,
    T=283.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-78,-50})));

  AHP.AHP_pump_hex_extended
                       ahp(
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
    annotation (Placement(transformation(extent={{-22,2},{34,44}})));
  Modelica.Blocks.Sources.RealExpression control_level(y=ahp.gen.level)
    annotation (Placement(transformation(extent={{186,-10},{166,10}})));
  Buildings.Controls.Continuous.LimPID conPID(
    k=10,
    Ti=10,
    yMax=0.08,
    yMin=0.02,
    reverseActing=false)
    annotation (Placement(transformation(extent={{144,16},{124,36}})));
  Modelica.Blocks.Sources.RealExpression level_setpoint(y=0.05)
    annotation (Placement(transformation(extent={{198,16},{178,36}})));
  Buildings.Controls.Continuous.LimPID conPID_w(
    k=10,
    Ti=10,
    reverseActing=false)
    annotation (Placement(transformation(extent={{-120,16},{-100,36}})));
  Modelica.Blocks.Sources.RealExpression level_setpoint_con(y=0.05)
    annotation (Placement(transformation(extent={{-176,16},{-156,36}})));
  Modelica.Blocks.Sources.RealExpression control_level_con(y=ahp.con.level)
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Modelica.Fluid.Sensors.Temperature temperature_con_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Fluid.Sensors.Temperature temperature_gen_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-2,104},{18,124}})));
  Modelica.Fluid.Sensors.Temperature temperature_abs_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-4,-72},{16,-52}})));
  Modelica.Fluid.Sensors.Temperature temperature_eva_out(redeclare package
      Medium = Medium_ext)
    annotation (Placement(transformation(extent={{-110,-24},{-90,-4}})));
equation

  connect(ahp.m_flow_sol, MassFlowRate.y) annotation (Line(points={{34,19},{60,
          19},{60,-12},{65,-12}}, color={0,0,127}));
  connect(source_con.ports[1], ahp.port_con_a)
    annotation (Line(points={{-150,96},{-7,96},{-7,43}}, color={0,127,255}));
  connect(ahp.port_con_b, sink_con.ports[1]) annotation (Line(points={{-15,43},
          {-18,43},{-18,60},{-96,60}}, color={0,127,255}));
  connect(source_eva.ports[1], ahp.port_eva_a) annotation (Line(points={{-68,
          -50},{-12,-50},{-12,3},{-9,3}}, color={0,127,255}));
  connect(sink_eva.ports[1], ahp.port_eva_b) annotation (Line(points={{-60,-10},
          {-20,-10},{-20,3},{-17,3}}, color={0,127,255}));
  connect(source_abs.ports[1], ahp.port_abs_a)
    annotation (Line(points={{76,-40},{31,-40},{31,3}}, color={0,127,255}));
  connect(ahp.port_abs_b, sink_abs.ports[1]) annotation (Line(points={{19,3},{
          18,3},{18,-80},{74,-80}}, color={0,127,255}));
  connect(ahp.port_gen_a, source_gen.ports[1])
    annotation (Line(points={{24.8,43},{24.8,70},{66,70}}, color={0,127,255}));
  connect(ahp.port_gen_b, sink_gen.ports[1])
    annotation (Line(points={{13,43},{13,104},{58,104}}, color={0,127,255}));
  connect(conPID.u_m, control_level.y)
    annotation (Line(points={{134,14},{134,0},{165,0}}, color={0,0,127}));
  connect(conPID.u_s, level_setpoint.y)
    annotation (Line(points={{146,26},{177,26}}, color={0,0,127}));
  connect(ahp.flashingLiBr_opening, conPID.y)
    annotation (Line(points={{34,27},{123,27},{123,26}}, color={0,0,127}));
  connect(conPID_w.u_m, control_level_con.y)
    annotation (Line(points={{-110,14},{-110,0},{-139,0}}, color={0,0,127}));
  connect(conPID_w.u_s, level_setpoint_con.y)
    annotation (Line(points={{-122,26},{-155,26}}, color={0,0,127}));
  connect(conPID_w.y, ahp.flashingWater_opening) annotation (Line(points={{-99,
          26},{-60,26},{-60,24},{-21.8,24}}, color={0,0,127}));
  connect(temperature_con_out.port, ahp.port_con_b) annotation (Line(points={{
          -74,68},{-74,60},{-18,60},{-18,43},{-15,43}}, color={0,127,255}));
  connect(temperature_gen_out.port, ahp.port_gen_b) annotation (Line(points={{8,
          104},{8,50},{13,50},{13,43}}, color={0,127,255}));
  connect(temperature_abs_out.port, ahp.port_abs_b) annotation (Line(points={{6,
          -72},{6,-78},{18,-78},{18,3},{19,3}}, color={0,127,255}));
  connect(temperature_eva_out.port, ahp.port_eva_b) annotation (Line(points={{
          -100,-24},{-100,-30},{-18,-30},{-18,3},{-17,3}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -120},{200,140}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{200,
            140}})),
    experiment(
      StopTime=86400,
      Interval=0.100000224,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>Model of a single effect absorption heat pump with external fluids. </p>
<p>This model is used to evaluate the implementation of the model <a href=\"Absolut.FluidBased.Dynamic.AHP.AHP_pump_hex_extended\">AHP_pump_hex_extended</a> analogously to the validation model <a href=\"Absolut.FluidBased.Static.SingleEffect_intern.Validation.AHP_se_eps\">AHP_se_eps</a>.</p>
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
end AHPse_Dyn_pump_extended;
