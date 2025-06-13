within Absolut.FluidBased.Static.SingleEffect_intern.Validation;
model AHP_se_eps
  "Single effect absorption heat pump with heat exchanger based on effectiveness"
  extends Modelica.Icons.Example;

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

  Modelica.Blocks.Sources.RealExpression OpeningSignal(y=1)
    annotation (Placement(transformation(extent={{-140,0},{-100,20}})));

  Components.FlashingWater flashingWater(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 7406 - 676,
    m_flow_nominal=0.00457, T_out_start = 275.15)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);
  SingleEffect_intern.CondenserStatic con(redeclare package Medium_v = Medium_v, redeclare
      package                                                                                      Medium_l = Medium_l, T_start = 323.15, p_start(displayUnit = "Pa") = 7400) "Condenser" annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  SingleEffect_intern.EvaporatorStatic eva(redeclare package Medium_v = Medium_v, redeclare
      package                                                                                       Medium_l = Medium_l, p_start(displayUnit = "Pa") = 676, T_start = 293.15) "Evaporator" annotation (Placement(transformation(extent={{-70,-62},{-50,-42}})));
  SingleEffect_intern.GeneratorStatic gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    T_start=363.15,
    X_LiBr_start=0.6216) "Generator" annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Components.FlashingLiBr flashingLiBr(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
                                       dp_nominal(displayUnit="Pa") = 7406 -
      676,
      m_flow_nominal=0.04543)
    annotation (Placement(transformation(extent={{70,-34},{50,-14}})));
  Modelica.Blocks.Sources.RealExpression OpeningSignal_LiBr(y=1)
    annotation (Placement(transformation(extent={{120,-34},{80,-14}})));
  Absolut.FluidBased.Static.Components.HEX.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.04543,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    eps=0.64) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={38,10})));
  Components.Pump pump(redeclare package Medium_l = Medium_sol, T_in_start=abs.T_start)
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,-20})));
  Modelica.Blocks.Sources.RealExpression MassFlowRate(y=0.05)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  SingleEffect_intern.AbsorberStatic abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    p_start(displayUnit="Pa") = 676,
    X_LiBr_start=0.5648,
    p(displayUnit="kPa"),
    use_X_LiBr_in=true,
    use_p_in=true) "Absorber" annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Sources.RealExpression X_LiBr_abs(y=0.5648)
    annotation (Placement(transformation(extent={{100,-100},{60,-80}})));
  Modelica.Blocks.Sources.RealExpression p_abs(y=676)
    annotation (Placement(transformation(extent={{106,-80},{66,-60}})));
  Modelica.Blocks.Sources.RealExpression EER(y=(eva.Hb_flow)/(gen.Hb_flow))
    "COP operating as chiller"
    annotation (Placement(transformation(extent={{-80,120},{-40,140}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(con.Hb_flow + abs.Hb_flow)/(
        gen.Hb_flow)) "COP operating as heat pump"
    annotation (Placement(transformation(extent={{-140,120},{-100,140}})));
  Modelica.Blocks.Sources.RealExpression Balance(y(unit="W") = con.Hb_flow +
      gen.Hb_flow + eva.Hb_flow + abs.Hb_flow - pump.W_dh)
    annotation (Placement(transformation(extent={{-110,140},{-70,160}})));
  Modelica.Blocks.Sources.RealExpression COP_wpump(y=-(con.Hb_flow + abs.Hb_flow)
        /(gen.Hb_flow + pump.W_el))
    "COP operating as heat pump including small contribution of pump"
    annotation (Placement(transformation(extent={{-140,100},{-100,120}})));

equation
  connect(OpeningSignal.y, flashingWater.opening)
    annotation (Line(points={{-98,10},{-80,10}},
                                               color={0,0,127}));
  connect(flashingWater.port_a, con.port_l)
    annotation (Line(points={{-70,19},{-70,40}}, color={0,127,255}));
  connect(flashingWater.port_l_b, eva.port_l_a) annotation (Line(points={{-74.8,1},
          {-74.8,-61},{-69,-61}},                         color={0,127,255}));
  connect(eva.port_v_a, flashingWater.port_v_b) annotation (Line(points={{-60,
          -42.2},{-60,-20},{-65,-20},{-65,1}},
                                 color={0,127,255}));
  connect(con.port_v, gen.port_v) annotation (Line(points={{-70,60},{-70,80},{40,
          80},{40,60}}, color={0,127,255}));
  connect(flashingLiBr.opening, OpeningSignal_LiBr.y)
    annotation (Line(points={{70,-24},{78,-24}}, color={0,0,127}));
  connect(hex.port_b1, gen.port_l_a)
    annotation (Line(points={{32,20},{32,41},{33,41}}, color={0,127,255}));
  connect(hex.port_b2, flashingLiBr.port_a) annotation (Line(points={{44,0},{60,
          0},{60,-15}},        color={0,127,255}));
  connect(hex.port_a2, gen.port_l_b)
    annotation (Line(points={{44,20},{44,41},{47,41}}, color={0,127,255}));
  connect(pump.port_l_b, hex.port_a1) annotation (Line(points={{0,-11},{0,0},{32,
          0}},             color={0,127,255}));
  connect(MassFlowRate.y, pump.m_dot_in) annotation (Line(points={{-19,-20},{
          -10,-20}},               color={0,0,127}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-50.8,-52},{-36,-52},
          {-36,-43},{21,-43}}, color={0,127,255}));
  connect(abs.port_l_b, pump.port_l_a) annotation (Line(points={{25,-59},{24,
          -59},{24,-58},{0,-58},{0,-29}},    color={0,127,255}));
  connect(abs.port_v_a, flashingLiBr.port_v_b) annotation (Line(points={{39,-47},
          {55,-47},{55,-33}}, color={0,127,255}));
  connect(abs.port_l_a, flashingLiBr.port_l_b) annotation (Line(points={{39,-53},
          {64.8,-53},{64.8,-33}}, color={0,127,255}));
  connect(abs.p_in, p_abs.y)
    annotation (Line(points={{38,-58},{38,-70},{64,-70}}, color={0,0,127}));
  connect(abs.X_LiBr_in, X_LiBr_abs.y)
    annotation (Line(points={{32,-58},{32,-90},{58,-90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{140,160}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,
            160}})),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of internal circuit of a single effect absorption heat pump with prescribed state at the absorber.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Main input variables are...</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">LiBr mass fraction in the absorber</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Low pressure level of the cycle, i.e. pressure of the absorber and evaporator</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Mass flow rate of the solution going from absorber to generator</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Valve position (opening) of the solution valve</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Valve position (opening) of the water valve</span></li>
</ul>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The data used to evaluate this circuit is obtained from table 6.1 of [1].</span></p>
<h4>References:</h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </span></p>
</html>"),
    experiment(
      StopTime=31536000,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Resources\Static\SingleEffect_intern\Validation\AHP_se_eps_Table61_plot.mos" "Plot",
    file="Resources\Static\SingleEffect_intern\Validation\AHP_se_eps.mos" "Simulate and plot"));
end AHP_se_eps;
