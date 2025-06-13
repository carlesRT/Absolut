within Absolut.FluidBased.Static.SingleEffect_intern.Validation;
model AHP_se_eps_p_XLiBr
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

  // Model

  Components.FlashingWater flashingWater(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 7406 - 676,
    m_flow_nominal=0.00457,
    use_opening=false)
    annotation (Placement(transformation(extent={{-72,46},{-52,66}})));
  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);
  SingleEffect_intern.CondenserStatic con(redeclare package Medium_v = Medium_v, redeclare
      package                                                                                      Medium_l = Medium_l) "Condenser" annotation (Placement(transformation(extent={{-72,86},{-52,106}})));
  SingleEffect_intern.EvaporatorStatic eva(redeclare package Medium_v = Medium_v, redeclare
      package                                                                                       Medium_l = Medium_l) "Evaporator" annotation (Placement(transformation(extent={{-62,-16},{-42,4}})));
  SingleEffect_intern.GeneratorStatic gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    p_start(displayUnit="Pa") = p_gen.k,
    X_LiBr_start=X_LiBr_gen.k,
    use_X_LiBr_in=true,
    use_p_in=true) "Generator" annotation (Placement(transformation(extent={{38,86},{58,106}})));
  Components.FlashingLiBr flashingLiBr(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
                                       dp_nominal(displayUnit="Pa") = 7406 -
      676,
      m_flow_nominal=0.04543,
    use_opening=false)
    annotation (Placement(transformation(extent={{78,12},{58,32}})));
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
        origin={48,62})));
  Components.Pump pump(redeclare package Medium_l = Medium_sol, T_in_start=abs.T_start)
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={8,26})));
  Modelica.Blocks.Sources.Constant       MassFlowRate(k=0.05)
    annotation (Placement(transformation(extent={{-32,16},{-12,36}})));
  SingleEffect_intern.AbsorberStatic abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    p_start(displayUnit="Pa") = p_abs.k,
    X_LiBr_start=X_LiBr_abs.k,
    p(displayUnit="kPa"),
    use_X_LiBr_in=true,
    use_p_in=true) "Absorber" annotation (Placement(transformation(extent={{28,-12},{48,8}})));
  Modelica.Blocks.Sources.Constant       X_LiBr_abs(k=0.5648)
    annotation (Placement(transformation(extent={{88,-74},{68,-54}})));
  Modelica.Blocks.Sources.Constant       p_abs(k=676)
    annotation (Placement(transformation(extent={{88,-34},{68,-14}})));
  Modelica.Blocks.Sources.Constant       X_LiBr_gen(k=0.6216)
    annotation (Placement(transformation(extent={{108,116},{88,136}})));
  Modelica.Blocks.Sources.Constant       p_gen(k=7406)
    annotation (Placement(transformation(extent={{108,76},{88,96}})));

  Modelica.Blocks.Sources.RealExpression COP_wpump(y=-(con.Hb_flow + abs.Hb_flow)
        /(gen.Hb_flow + pump.W_el))
    "COP operating as heat pump including small contribution of pump"
    annotation (Placement(transformation(extent={{-140,100},{-100,120}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(con.Hb_flow + abs.Hb_flow)/(
        gen.Hb_flow)) "COP operating as heat pump"
    annotation (Placement(transformation(extent={{-140,120},{-100,140}})));
  Modelica.Blocks.Sources.RealExpression EER(y=(eva.Hb_flow)/(gen.Hb_flow))
    "COP operating as chiller"
    annotation (Placement(transformation(extent={{-80,120},{-40,140}})));
  Modelica.Blocks.Sources.RealExpression Balance(y(unit="W") = con.Hb_flow +
      gen.Hb_flow + eva.Hb_flow + abs.Hb_flow - pump.W_dh)
    annotation (Placement(transformation(extent={{-110,140},{-70,160}})));
equation
  connect(flashingWater.port_a, con.port_l)
    annotation (Line(points={{-62,65},{-62,86}}, color={0,127,255}));
  connect(flashingWater.port_l_b, eva.port_l_a) annotation (Line(points={{-66.8,
          47},{-66.8,-15},{-61,-15}},                     color={0,127,255}));
  connect(eva.port_v_a, flashingWater.port_v_b) annotation (Line(points={{-52,3.8},
          {-52,42},{-57,42},{-57,47}},
                                 color={0,127,255}));
  connect(con.port_v, gen.port_v) annotation (Line(points={{-62,106},{48,106}},
                        color={0,127,255}));
  connect(hex.port_b1, gen.port_l_a)
    annotation (Line(points={{42,72},{42,79.5},{41,79.5},{41,87}},
                                                       color={0,127,255}));
  connect(hex.port_b2, flashingLiBr.port_a) annotation (Line(points={{54,52},{
          54,31},{68,31}},     color={0,127,255}));
  connect(hex.port_a2, gen.port_l_b)
    annotation (Line(points={{54,72},{54,80},{55,80},{55,87}},
                                                       color={0,127,255}));
  connect(pump.port_l_b, hex.port_a1) annotation (Line(points={{8,35},{8,46},{
          42,46},{42,52}}, color={0,127,255}));
  connect(MassFlowRate.y, pump.m_dot_in) annotation (Line(points={{-11,26},{-2,
          26}},                    color={0,0,127}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-42.8,-6},{22,-6},{
          22,5},{29,5}},       color={0,127,255}));
  connect(abs.port_l_b, pump.port_l_a) annotation (Line(points={{33,-11},{33,
          -16},{8,-16},{8,17}},              color={0,127,255}));
  connect(abs.port_v_a, flashingLiBr.port_v_b) annotation (Line(points={{47,1},{
          63,1},{63,13}},     color={0,127,255}));
  connect(abs.port_l_a, flashingLiBr.port_l_b) annotation (Line(points={{47,-5},
          {72.8,-5},{72.8,13}},   color={0,127,255}));
  connect(abs.p_in, p_abs.y)
    annotation (Line(points={{46,-10},{46,-24},{67,-24}}, color={0,0,127}));
  connect(abs.X_LiBr_in, X_LiBr_abs.y)
    annotation (Line(points={{40,-10},{40,-64},{67,-64}}, color={0,0,127}));
  connect(gen.p_in, p_gen.y) annotation (Line(points={{58,101},{84,101},{84,86},
          {87,86}}, color={0,0,127}));
  connect(gen.X_LiBr_in, X_LiBr_gen.y)
    annotation (Line(points={{58,105},{58,126},{87,126}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{140,160}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,
            160}})),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of internal circuit of a single effect absorption heat pump.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Main input variables are...</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">LiBr mass fraction in the absorber</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Low pressure level of the cycle, i.e. pressure of the absorber and evaporator</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Mass flow rate of the solution going from absorber to generator</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Valve position (opening) of the solution valve</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Valve position (opening) of the water valve</span></li>
</ul>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The data used to evaluate this circuit is obtained from table 6.1 of [1].</span></p>
<p><b>References:</b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </span></p>
</html>"),
    experiment(
      StopTime=600,
      Interval=60,
      Tolerance=1e-08,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Resources\Static\SingleEffect_intern\Validation\AHP_se_eps_Table61_plot.mos" "Plot",
    file="Resources\Static\SingleEffect_intern\Validation\AHP_se_eps_p_XLiBr.mos" "Simulate and plot"));
end AHP_se_eps_p_XLiBr;
