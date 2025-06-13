within Absolut.FluidBased.Dynamic.LabValidation;
model Test_AHX_wcp_extended_wheatloss_pump_controlled
  extends Absolut.FluidBased.Dynamic.LabValidation.Data.sBSc_1m_Cfg0_20220804;

  Absolut.FluidBased.Dynamic.AHP.AHP_pump_hex_extended AHP(
    nEle=4,
    redeclare package Medium_sol = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    flashing_w_m_flow_nominal=0.01,
    flashing_w_dp_nominal=10000,
    flashing_LiBr_m_flow_nominal=0.05,
    flashing_LiBr_dp_nominal=14000,
    pipemass_eva_T_start=(T_WT_HT_OUT_pt138_start + T_WRG_in_pt79_start)/2,
    pipemass_con_T_start=(T_MT_ABS_Out_pt102_start + T_KuehlRL_Wegra120_start)/
        2,
    pipemass_abs_T_start=(T_MT_return_wmz59_start + T_MT_ABS_Out_pt102_start)/2,
    pipemass_gen_T_start=T_Loesungsmittel_Wegra121_start + 5,
    eva_UA=1200,
    m_eva=0.045,
    eva_h=0.7,
    eva_S=0.1,
    eva_T_start=T_VER_Kreis_pt103_start,
    eva_V_l_start(displayUnit="l") = 0.01,
    con_UA=3900,
    m_con=0.35,
    con_h=0.7,
    con_S=0.1,
    con_T_start=T_KuehlRL_Wegra120_start,
    con_V_l_start(displayUnit="l") = 0.01,
    gen_UA=1500,
    m_gen=0.045,
    gen_h=0.7,
    gen_S=0.1,
    gen_X_LiBr_start=0.545,
    gen_T_start=T_Loesungsmittel_Wegra121_start,
    gen_V_l_start(displayUnit="l") = 0.02,
    abs_UA=3900,
    m_abs=0.35,
    abs_h=0.7,
    abs_S=0.1,
    abs_T_start=T_ABS_Out_pt101_start,
    abs_X_LiBr_start=0.535,
    abs_V_l_start(displayUnit="l") = 0.02,
    simpleHX_UA=350,
    UA_amb=3,
    UA_fix_gen=100,
    UA_fix_abs=400)
    annotation (Placement(transformation(extent={{-58,-6},{-2,36}})));

  Modelica.Blocks.Sources.RealExpression Q_absorberT59(y=-msek_AWP.y*cp_w_abs.y*
        (T_MT_ABS_Out_pt102 - T_MT_return_wmz59))
    annotation (Placement(transformation(extent={{284,-112},{304,-92}})));
  Modelica.Blocks.Sources.RealExpression cp_w_abs(y=
        Medium_l.specificHeatCapacityCp(Medium_l.setState_pT(200000, (
        T_WT_MT_OUT_pt140 + T_WT_MT_IN_pt139)/2)))
    annotation (Placement(transformation(extent={{244,-142},{264,-122}})));
  Modelica.Blocks.Sources.RealExpression Q_absorberT74(y=-msek_AWP.y*cp_w_abs.y*
        (T_MT_ABS_Out_pt102 - T_PU_MT_out_pt74))
    annotation (Placement(transformation(extent={{284,-172},{304,-152}})));
  Modelica.Blocks.Math.Product mHEXprim
    annotation (Placement(transformation(extent={{202,66},{182,86}})));
  Modelica.Blocks.Math.Division          cp_ratio1
    annotation (Placement(transformation(extent={{212,-12},{192,8}})));
  Modelica.Blocks.Sources.RealExpression cp_oil(y=
        Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.specificHeatCapacityCp(
        Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.setState_pTX(
        200000, T_prim_avg.y)))
    annotation (Placement(transformation(extent={{252,8},{232,28}})));
  Modelica.Blocks.Sources.RealExpression T_prim_avg(y=(T_HT_VL_pt83 +
        T_HT_RL_pt84)/2)
    annotation (Placement(transformation(extent={{272,-12},{252,8}})));
  Modelica.Blocks.Sources.RealExpression T_prim_dichte_T84(y=T_HT_RL_pt84)
    annotation (Placement(transformation(extent={{290,20},{270,40}})));
  Modelica.Blocks.Sources.RealExpression Dichte_prim(y=
        Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.density(
        Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.setState_pTX(
        200000, T83.y)))
    annotation (Placement(transformation(extent={{252,28},{232,48}})));
  Modelica.Blocks.Sources.RealExpression Dichte_primT84(y=
        Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.density(
        Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.setState_pTX(
        200000, T_prim_dichte_T84.y)))
    annotation (Placement(transformation(extent={{300,50},{280,70}})));
  Modelica.Blocks.Sources.RealExpression
                                   Vm3sHEXprim(y=Vd_HT_clamp85)
    annotation (Placement(transformation(extent={{278,116},{258,136}})));
  Modelica.Blocks.Sources.RealExpression cp_w(y=Medium_l.specificHeatCapacityCp(
         Medium_l.setState_pT(200000, T_prim_avg.y)))
    annotation (Placement(transformation(extent={{276,-40},{256,-20}})));
  Modelica.Blocks.Math.Product moil_to_water
    annotation (Placement(transformation(extent={{144,44},{124,64}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_ext1(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=true,
    use_T_in=true,
    use_X_in=false,
    m_flow=0.03047,
    T=397.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,72})));
  Modelica.Blocks.Sources.RealExpression
                                   T83(y=T_HT_VL_pt83)
    annotation (Placement(transformation(extent={{140,98},{120,118}})));
  Modelica.Blocks.Sources.RealExpression
                                   T115(y=T_HeizVL_Wegra115)
    annotation (Placement(transformation(extent={{140,120},{120,140}})));
  Modelica.Blocks.Math.Feedback msek_WT
    annotation (Placement(transformation(extent={{-238,-126},{-218,-106}})));
  Modelica.Blocks.Math.Product msek
    annotation (Placement(transformation(extent={{-292,-144},{-272,-124}})));
  Modelica.Blocks.Math.Product msek_AWP
    annotation (Placement(transformation(extent={{-216,-196},{-196,-176}})));
  Modelica.Blocks.Sources.RealExpression
                                   Vsek1(y=1/(1 + SSV))
    annotation (Placement(transformation(extent={{-324,-200},{-304,-180}})));
  Modelica.Blocks.Sources.RealExpression Dichte_sek(y=Medium_ext.density_pT(200000,
        T_MT_return_wmz59))
    annotation (Placement(transformation(extent={{-338,-158},{-318,-138}})));
  Modelica.Blocks.Sources.RealExpression
                                   Vsek(y=Vprim.k*GSV1)
    annotation (Placement(transformation(extent={{-338,-126},{-318,-106}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_ext(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=0.172,
    T=323.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-94,-78})));
  Modelica.Blocks.Sources.RealExpression
                                   Tsek(y(unit="K") = T_MT_return_wmz59)
    annotation (Placement(transformation(extent={{-380,-68},{-360,-48}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_WT(
    redeclare package Medium = Medium_ext,
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=0.8,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-240,92})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU
                                                       hex(
    redeclare package Medium1 = Medium_ext,
    redeclare package Medium2 = Medium_ext,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=0.09853,
    m2_flow_nominal=0.1,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=100,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal(displayUnit="kW") = 20980,
    T_a1_nominal=373.15,
    T_a2_nominal=319.15)
                   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-180,142})));

  Buildings.Fluid.FixedResistances.LosslessPipe pip(redeclare package Medium =
        Medium_ext, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-208,188},{-228,208}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium_ext,
    allowFlowReversal=false,
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{-250,188},{-270,208}})));
  Modelica.Fluid.Sources.FixedBoundary sink_v3(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 400000,
    nPorts=1) annotation (Placement(transformation(extent={{-312,188},{-292,208}})));
  Modelica.Fluid.Sources.FixedBoundary sink_ext(
    redeclare package Medium = Medium_ext,
    p(displayUnit="bar") = 400000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-144,-46},{-124,-26}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem_eva_out(
    redeclare package Medium = Medium_ext,
    allowFlowReversal=false,
    m_flow_nominal=0.01,
    T_start=T_WRG_in_pt79_start)
    annotation (Placement(transformation(extent={{-64,-34},{-84,-14}})));
  replaceable package Medium_sol = Media.LiBrH2O     annotation (
      choicesAllMatching=true);
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (choicesAllMatching=true);
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph
    annotation (choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph
    annotation (choicesAllMatching=true);

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem_gen_out(
    redeclare package Medium = Medium_ext,
    allowFlowReversal=false,
    m_flow_nominal=0.01,
    T_start=T_HeizRL_Wegra118_start)
    annotation (Placement(transformation(extent={{-82,164},{-102,184}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem_abs_out(
    redeclare package Medium = Medium_ext,
    allowFlowReversal=false,
    m_flow_nominal=0.01,
    T_start=T_MT_ABS_Out_pt102_start)
    annotation (Placement(transformation(extent={{30,160},{10,180}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem_con_out(
    redeclare package Medium = Medium_ext,
    allowFlowReversal=false,
    m_flow_nominal=0.01,
    T_start=T_KuehlRL_Wegra120_start)
    annotation (Placement(transformation(extent={{-86,204},{-106,224}})));
  Buildings.Controls.Continuous.LimPID conPID_con_level(
    k=100,
    Ti=30,
    yMax=1,
    yMin=0,
    reverseActing=false)
    annotation (Placement(transformation(extent={{-148,46},{-128,66}})));
  Modelica.Blocks.Sources.RealExpression con_level_soll(y=0.1)
    annotation (Placement(transformation(extent={{-212,46},{-192,66}})));
  Modelica.Blocks.Sources.RealExpression con_level_ist(y=AHP.con.level)
    annotation (Placement(transformation(extent={{-188,22},{-168,42}})));

    Modelica.Units.SI.SpecificEnthalpy h1=Medium_sol.specificEnthalpy(
      Medium_sol.setState_pTX(
      p_KondensatorGenerator_Wegra125,
      T_GEN_In_pt98,
      {1-X_LiBr_abs}));
  Modelica.Units.SI.SpecificEnthalpy h2;
  Modelica.Units.SI.Temperature T1and2;
  Modelica.Units.SI.SpecificEnthalpy h3=Medium_sol.specificEnthalpy(
      Medium_sol.setState_pTX(
      p_KondensatorGenerator_Wegra125,
      T_Loesungsmittel_Wegra121,
      {1-X_LiBr_genT121}));

  Modelica.Units.SI.MassFlowRate m1, m2, m3;

  Modelica.Blocks.Sources.RealExpression gen_level_soll(y=0.2)
    annotation (Placement(transformation(extent={{-70,-118},{-50,-98}})));
  Modelica.Blocks.Sources.RealExpression gen_level_ist(y=AHP.gen.level)
    annotation (Placement(transformation(extent={{-70,-148},{-50,-128}})));
  Buildings.Controls.Continuous.LimPID conPID_m_dot(
    k=100,
    Ti=30,
    yMax=0.16,
    yMin=0.02)
    annotation (Placement(transformation(extent={{-18,-118},{2,-98}})));
  Modelica.Blocks.Logical.Hysteresis eva_level_hys(uLow=0.3, uHigh=0.5)
    annotation (Placement(transformation(extent={{-180,-6},{-160,14}})));
  Modelica.Blocks.Logical.Switch         gen_level2
    annotation (Placement(transformation(extent={{-124,14},{-104,-6}})));
  Modelica.Blocks.Sources.RealExpression eva_level_soll(y=0)
    annotation (Placement(transformation(extent={{-218,-44},{-198,-24}})));
  Modelica.Blocks.Sources.RealExpression eva_level_ist(y=AHP.eva.level)
    annotation (Placement(transformation(extent={{-228,-6},{-208,14}})));
  Modelica.Blocks.Sources.RealExpression fitted1(y=max(0.05, 0.1943 - 0.00167*(
        T_MT_return_wmz59 - 273.15)))
    annotation (Placement(transformation(extent={{86,-26},{66,-6}})));

  Modelica.Blocks.Sources.RealExpression Unterkuehlung(y=T_MT_return_wmz59 -
        senTem_eva_out.T)
    annotation (Placement(transformation(extent={{-80,-60},{-100,-40}})));
  Modelica.Blocks.Sources.RealExpression Unterkuehlung_measured(y=
        T_MT_return_wmz59 - T_WRG_in_pt79)
    annotation (Placement(transformation(extent={{-40,-60},{-60,-40}})));
  Modelica.Blocks.Sources.RealExpression Abweichung_gen(y=T_HeizRL_Wegra118 -
        senTem_gen_out.T)
    annotation (Placement(transformation(extent={{-88,134},{-108,154}})));
  Modelica.Blocks.Sources.RealExpression Abweichung_con(y=T_KuehlRL_Wegra120 -
        senTem_con_out.T)
    annotation (Placement(transformation(extent={{-96,238},{-116,258}})));
  Modelica.Blocks.Sources.RealExpression Abweichung(y=T_Misch_MT_pt142 - senTem.T)
    annotation (Placement(transformation(extent={{-228,222},{-248,242}})));
  Modelica.Blocks.Sources.RealExpression con_level_soll8(y=T_Misch_MT_pt142)
    annotation (Placement(transformation(extent={{302,190},{282,210}})));
  Buildings.Controls.Continuous.LimPID conPID_source(
    k=100,
    Ti=30,
    yMax=1.2,
    yMin=0.8)
    annotation (Placement(transformation(extent={{238,192},{218,212}})));
  Modelica.Blocks.Math.Product moil_to_water1
    annotation (Placement(transformation(extent={{172,148},{152,168}})));
  Modelica.Blocks.Sources.RealExpression fitted_constant(y=0.12)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Modelica.Blocks.Sources.Constant Vprim(k=250/3600*(1/1000))
    annotation (Placement(transformation(extent={{184,-50},{164,-30}})));
equation

 //p_VerdampferAbsorber_Wegra126 = level*Modelica.Constants.g_n*AHP.eva.medium_l.d + AHP.eva.p;

 //AHP.eva.T = T_VER_Kreis_pt103;
 //AHP.gen.T = T_Loesungsmittel_Wegra121;
 //AHP.gen.p = p_KondensatorGenerator_Wegra125;
 //AHP.eva.p = p_VerdampferAbsorber_Wegra126;

  m1 + m2 + m3 = 0;
  //port_v.m_flow + port_l_b.m_flow + port_l_a.m_flow = 0;

  m2 + (1-X_LiBr_abs)*m1 + m3*(1-X_LiBr_genT121) = 0;
  //mXi_flow_l_a = port_l_a.m_flow * inStream(port_l_a.Xi_outflow);
  //mXi_flow_l_b = port_l_b.m_flow*{X_H2O};
  //port_v.m_flow*{1} + mXi_flow_l_a + mXi_flow_l_b = zeros(Medium_l.nXi);

  //Q_generatorT115.y = m3*h3 + m1*h1 + m2*h2;
  Q_genT83 = m3*h3 + m1*h1 + m2*h2;
  // Hb_flow = port_l_b.m_flow*actualStream(port_l_b.h_outflow) + port_v.m_flow*actualStream(port_v.h_outflow) + port_l_a.m_flow*actualStream(port_l_a.h_outflow);

  //T1and2 = Medium_sol.temperature_Gen_Xp(X_H2O_abs,p_sat_measGen.y);
  T1and2 = Medium_sol.temperature_Gen_Xp(1-X_LiBr_genT121,p_KondensatorGenerator_Wegra125);
  //T1and2 = Medium_l.temperature_Gen_Xp(inStream(port_l_a.Xi_outflow)*{1},p);

  h2 = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p_KondensatorGenerator_Wegra125,T1and2,{1}));
  //port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T1and2,{1}));

  connect(moil_to_water.u1,mHEXprim. y) annotation (Line(points={{146,60},{176,60},
          {176,76},{181,76}}, color={0,0,127}));
  connect(moil_to_water.u2,cp_ratio1. y) annotation (Line(points={{146,48},{186,
          48},{186,-2},{191,-2}},   color={0,0,127}));
  connect(cp_ratio1.u2,cp_w. y) annotation (Line(points={{214,-8},{230,-8},{230,
          -30},{255,-30}}, color={0,0,127}));
  connect(cp_ratio1.u1,cp_oil. y) annotation (Line(points={{214,4},{226,4},{226,
          18},{231,18}},   color={0,0,127}));
  connect(mHEXprim.u2,Dichte_primT84. y) annotation (Line(points={{204,70},{220,
          70},{220,60},{279,60}}, color={0,0,127}));
  connect(source_ext1.T_in,T83. y) annotation (Line(points={{82,68},{114,68},{
          114,108},{119,108}},
                           color={0,0,127}));
  connect(AHP.port_gen_a, source_ext1.ports[1])
    annotation (Line(points={{-11.2,35},{-11.2,48},{54,48},{54,72},{60,72}},
                                                           color={0,127,255}));
  connect(msek.y,msek_WT. u1) annotation (Line(points={{-271,-134},{-271,-136},
          {-248,-136},{-248,-116},{-236,-116}},
                                 color={0,0,127}));
  connect(msek.y,msek_AWP. u1) annotation (Line(points={{-271,-134},{-271,-136},
          {-228,-136},{-228,-180},{-218,-180}},
                                    color={0,0,127}));
  connect(Vsek1.y,msek_AWP. u2)
    annotation (Line(points={{-303,-190},{-303,-192},{-218,-192}},
                                                       color={0,0,127}));
  connect(Dichte_sek.y,msek. u2) annotation (Line(points={{-317,-148},{-304,
          -148},{-304,-140},{-294,-140}},
                                    color={0,0,127}));
  connect(Vsek.y,msek. u1) annotation (Line(points={{-317,-116},{-302,-116},{
          -302,-128},{-294,-128}},
                              color={0,0,127}));
  connect(msek_AWP.y,msek_WT. u2) annotation (Line(points={{-195,-186},{-195,
          -188},{-188,-188},{-188,-136},{-228,-136},{-228,-124}},
                       color={0,0,127}));
  connect(msek_WT.y,source_WT. m_flow_in) annotation (Line(points={{-219,-116},
          {-212,-116},{-212,-60},{-250,-60},{-250,84}}, color={0,0,127}));
  connect(source_ext.T_in,Tsek. y) annotation (Line(points={{-106,-82},{-352,
          -82},{-352,-58},{-359,-58}},
                                  color={0,0,127}));
  connect(source_WT.T_in,Tsek. y) annotation (Line(points={{-252,88},{-352,88},
          {-352,-58},{-359,-58}},
                        color={0,0,127}));
  connect(source_WT.ports[1],hex. port_a2) annotation (Line(points={{-230,92},{-186,
          92},{-186,132}},       color={0,127,255}));
  connect(pip.port_a,hex. port_b2) annotation (Line(points={{-208,198},{-186,198},
          {-186,152}},        color={0,127,255}));
  connect(senTem.port_a,pip. port_b)
    annotation (Line(points={{-250,198},{-228,198}},
                                                   color={0,127,255}));
  connect(sink_v3.ports[1],senTem. port_b)
    annotation (Line(points={{-292,198},{-270,198}},
                                                   color={0,127,255}));
  connect(hex.port_b1, AHP.port_eva_a) annotation (Line(points={{-174,132},{
          -174,112},{-50,112},{-50,-14},{-45,-14},{-45,-5}},
                                                        color={0,127,255}));
  connect(source_ext.ports[1], AHP.port_abs_a) annotation (Line(points={{-84,-78},
          {-10,-78},{-10,-42},{-5,-42},{-5,-5}}, color={0,127,255}));
  connect(sink_ext.ports[1], senTem_eva_out.port_b) annotation (Line(points={{
          -124,-36},{-90,-36},{-90,-24},{-84,-24}}, color={0,127,255}));
  connect(AHP.port_eva_b, senTem_eva_out.port_a) annotation (Line(points={{-53,-5},
          {-53,-24},{-64,-24}}, color={0,127,255}));
  connect(AHP.port_gen_b, senTem_gen_out.port_a) annotation (Line(points={{-23,35},
          {-18,35},{-18,66},{-64,66},{-64,174},{-82,174}},   color={0,127,255}));
  connect(senTem_gen_out.port_b, hex.port_a1) annotation (Line(points={{-102,
          174},{-174,174},{-174,152}}, color={0,127,255}));
  connect(AHP.port_abs_b, senTem_abs_out.port_a) annotation (Line(points={{-17,-5},
          {-17,-26},{40,-26},{40,170},{30,170}},     color={0,127,255}));
  connect(AHP.port_con_a, senTem_abs_out.port_b)
    annotation (Line(points={{-43,35},{-43,170},{10,170}}, color={0,127,255}));
  connect(AHP.port_con_b, senTem_con_out.port_a) annotation (Line(points={{-51,35},
          {-51,214},{-86,214}},     color={0,127,255}));
  connect(senTem_con_out.port_b, pip.port_a) annotation (Line(points={{-106,214},
          {-200,214},{-200,198},{-208,198}}, color={0,127,255}));
  connect(con_level_soll.y, conPID_con_level.u_s)
    annotation (Line(points={{-191,56},{-150,56}}, color={0,0,127}));
  connect(con_level_ist.y, conPID_con_level.u_m)
    annotation (Line(points={{-167,32},{-138,32},{-138,44}}, color={0,0,127}));
  connect(source_ext1.m_flow_in, moil_to_water.y) annotation (Line(points={{80,64},
          {80,54},{123,54}},           color={0,0,127}));
  connect(msek_AWP.y, source_ext.m_flow_in) annotation (Line(points={{-195,-186},
          {-195,-188},{-188,-188},{-188,-96},{-104,-96},{-104,-86}},
                                                           color={0,0,127}));
  connect(gen_level_ist.y, conPID_m_dot.u_m) annotation (Line(points={{-49,-138},
          {-49,-140},{-8,-140},{-8,-120}}, color={0,0,127}));
  connect(gen_level_soll.y, conPID_m_dot.u_s)
    annotation (Line(points={{-49,-108},{-20,-108}}, color={0,0,127}));
  connect(eva_level_hys.y, gen_level2.u2)
    annotation (Line(points={{-159,4},{-126,4}}, color={255,0,255}));
  connect(eva_level_soll.y, gen_level2.u1) annotation (Line(points={{-197,-34},
          {-197,-36},{-156,-36},{-156,-4},{-126,-4}}, color={0,0,127}));
  connect(eva_level_ist.y, eva_level_hys.u)
    annotation (Line(points={{-207,4},{-182,4}}, color={0,0,127}));
  connect(conPID_con_level.y, gen_level2.u3) annotation (Line(points={{-127,56},
          {-122,56},{-122,24},{-134,24},{-134,12},{-126,12}}, color={0,0,127}));
  connect(gen_level2.y, AHP.flashingWater_opening) annotation (Line(points={{-103,4},
          {-60,4},{-60,16},{-57.8,16}},                    color={0,0,127}));
  connect(con_level_soll8.y, conPID_source.u_s) annotation (Line(points={{281,
          200},{276,200},{276,202},{240,202}}, color={0,0,127}));
  connect(senTem.T, conPID_source.u_m) annotation (Line(points={{-260,209},{
          -260,212},{-204,212},{-204,228},{-116,228},{-116,232},{204,232},{204,
          180},{228,180},{228,190}}, color={0,0,127}));
  connect(moil_to_water1.u1, conPID_source.y) annotation (Line(points={{174,164},
          {192,164},{192,202},{217,202}}, color={0,0,127}));
  connect(moil_to_water1.u2, Vm3sHEXprim.y) annotation (Line(points={{174,152},
          {210,152},{210,126},{257,126}}, color={0,0,127}));
  connect(moil_to_water1.y, mHEXprim.u1) annotation (Line(points={{151,158},{
          146,158},{146,108},{216,108},{216,82},{204,82}}, color={0,0,127}));
  connect(conPID_m_dot.y, AHP.m_flow_sol) annotation (Line(points={{3,-108},{26,
          -108},{26,11},{-2,11}}, color={0,0,127}));
  connect(AHP.flashingLiBr_opening, fitted_constant.y) annotation (Line(points=
          {{-2,19},{14,19},{14,20},{28,20},{28,30},{59,30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-380,
            -200},{320,260}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-380,-200},{320,
            260}})),
    experiment(
      StopTime=64800,
      Interval=60,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Test_command_log.mos" "Test_command_log"));
end Test_AHX_wcp_extended_wheatloss_pump_controlled;
