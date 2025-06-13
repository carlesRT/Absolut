within Absolut.FluidBased.Dynamic.AHP;
model AHP_internal_hex

  parameter Integer nEle = 4 "discretization of pipe";

  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealInput flashingWater_opening
    annotation (Placement(transformation(extent={{-318,0},{-278,40}})));
  Modelica.Blocks.Interfaces.RealInput flashingLiBr_opening
    annotation (Placement(transformation(extent={{280,30},{240,70}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_sol
    "mass flow rate of solution pump"
    annotation (Placement(transformation(extent={{280,-50},{240,-10}})));
  parameter Modelica.Units.SI.MassFlowRate flashing_w_m_flow_nominal=0.0007
    "Nominal mass flowrate at full opening" annotation(Dialog(group="Valve - water"));
  parameter Modelica.Units.SI.Temperature flashing_w_T_out_start=327.15  annotation(Dialog(group="Valve - water", tab = "Initialization"));

  parameter Real flashing_w_Q_intern_start=0.065  annotation(Dialog(group="Valve - water", tab = "Initialization"));

  parameter Modelica.Units.SI.AbsolutePressure flashing_w_dp_nominal(
      displayUnit="kPa") = 10000 "Nominal pressure drop at full opening" annotation(Dialog(group="Valve - water"));
  parameter Modelica.Units.SI.MassFlowRate flashing_LiBr_m_flow_nominal=0.03
    "Nominal mass flowrate at full opening" annotation(Dialog(group="Valve - waterLiBr"));
  parameter Modelica.Units.SI.AbsolutePressure flashing_LiBr_dp_nominal(
      displayUnit="kPa") = 18000 "Nominal pressure drop at full opening" annotation(Dialog(group="Valve - waterLiBr"));
  parameter Modelica.Units.SI.Temperature flashing_LiBr_T_out_start=343.15  annotation(Dialog(group="Valve - waterLiBr", tab = "Initialization"));


  parameter Modelica.Units.SI.Temperature eva_T_in_start = 343.15  annotation(Dialog(group="External", tab = "Initialization"));
  parameter Modelica.Units.SI.Temperature eva_T_out_start = 343.15  annotation(Dialog(group="External", tab = "Initialization"));
  parameter Modelica.Units.SI.Temperature gen_T_in_start = 343.15  annotation(Dialog(group="External", tab = "Initialization"));
  parameter Modelica.Units.SI.Temperature gen_T_out_start = 343.15  annotation(Dialog(group="External", tab = "Initialization"));
  parameter Modelica.Units.SI.Temperature abs_T_in_start = 343.15  annotation(Dialog(group="External", tab = "Initialization"));
  parameter Modelica.Units.SI.Temperature abs_T_out_start = 343.15  annotation(Dialog(group="External", tab = "Initialization"));
  parameter Modelica.Units.SI.Temperature con_T_in_start = 343.15  annotation(Dialog(group="External", tab = "Initialization"));
  parameter Modelica.Units.SI.Temperature con_T_out_start = 343.15  annotation(Dialog(group="External", tab = "Initialization"));


  parameter Real flashing_LiBr_Q_intern_start=0.065  annotation(Dialog(group="Valve - waterLiBr", tab = "Initialization"));

  parameter Modelica.Units.SI.Pressure flashing_LiBr_p_out_start=abs_p_start  annotation(Dialog(group="Valve - waterLiBr", tab = "Initialization"));

  Modelica.Fluid.Interfaces.FluidPort_a port_abs_a(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{220,-200},{240,-180}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_abs_b(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_gen_a(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{158,200},{178,220}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_gen_b(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{40,200},{60,220}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_con_a(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_con_b(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{-242,200},{-222,220}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_eva_a(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{-180,-200},{-160,-180}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_eva_b(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{-260,-200},{-240,-180}})));


  parameter Modelica.Units.SI.ThermalConductance eva_UA=400
    "UA value of HX in W/K" annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.Height eva_h=0.1 "Height of vessel" annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.Area eva_S=0.5 "Area of vessel" annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.Temperature eva_T_start(displayUnit="degC")=
    Medium_l.saturationTemperature(eva_p_start) "Initial liquid-vapor equilibrium temperature"  annotation(Dialog(group="Evaporator", tab = "Initialization"));

  parameter Modelica.Units.SI.Volume eva_V_l_start=0.5*eva.V
    "Initial volume of the liquid medium"  annotation(Dialog(group="Evaporator", tab = "Initialization"));

  parameter Modelica.Units.SI.AbsolutePressure eva_p_start = Medium_l.saturationPressure(eva_T_start)
    "Initial liquid-vapor equilibrium pressure"  annotation(Dialog(group="Evaporator", tab = "Initialization"));

  parameter Modelica.Units.SI.ThermalConductance con_UA=1000 annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.Height con_h=0.1 "Height of vessel" annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.Area con_S=0.5 "Area of vessel" annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.Temperature con_T_start= Medium_l.saturationTemperature(con_p_start) "Initial liquid-vapor equilibrium temperature"  annotation(Dialog(group="Condenser", tab = "Initialization"));

  parameter Modelica.Units.SI.Volume con_V_l_start=0.5*con.V
    "Initial volume of the liquid medium"  annotation(Dialog(group="Condenser", tab = "Initialization"));

  parameter Modelica.Units.SI.AbsolutePressure con_p_start = Medium_l.saturationPressure(con_T_start)
    "Initial liquid-vapor equilibrium pressure"  annotation(Dialog(group="Condenser", tab = "Initialization"));

  parameter Modelica.Units.SI.ThermalConductance gen_UA=800
    "UA value of HX in W/K" annotation(Dialog(group="Generator"));
  parameter Modelica.Units.SI.Height gen_h=0.1 "Height of vessel" annotation(Dialog(group="Generator"));
  parameter Modelica.Units.SI.Area gen_S=0.5 "Area of vessel" annotation(Dialog(group="Generator"));
  parameter Modelica.Units.SI.MassFraction gen_X_LiBr_start=0.48  annotation(Dialog(group="Generator", tab = "Initialization"));

  parameter Modelica.Units.SI.Temperature gen_T_start= Medium_sol.temperature_Xp(1 -
      gen_X_LiBr_start, gen_p_start)
    "Initial liquid-vapor equilibrium temperature"  annotation(Dialog(group="Generator", tab = "Initialization"));

  parameter Modelica.Units.SI.Volume gen_V_l_start=0.5*gen.V
    "Initial volume of the liquid medium" annotation(Dialog(group="Generator",tab = "Initialization"));
  parameter Modelica.Units.SI.AbsolutePressure gen_p_start = Medium_sol.saturationPressure_TX(gen_T_start,gen_X_LiBr_start)
    "Initial liquid-vapor equilibrium pressure"  annotation(Dialog(group="Generator",tab = "Initialization"));

  parameter Modelica.Units.SI.ThermalConductance abs_UA=1000 "in W/K" annotation(Dialog(group="Absorber"));
  parameter Modelica.Units.SI.Height abs_h= 0.1 "Height of vessel" annotation(Dialog(group="Absorber"));
  parameter Modelica.Units.SI.Area abs_S= 0.5 "Area of vessel" annotation(Dialog(group="Absorber"));

  parameter Modelica.Units.SI.Temperature abs_T_start= Medium_sol.temperature_Xp(1 -
      abs_X_LiBr_start, abs_p_start)
    "Initial liquid-vapor equilibrium temperature"  annotation(Dialog(group="Absorber", tab = "Initialization"));

  parameter Modelica.Units.SI.AbsolutePressure abs_p_start = Medium_sol.saturationPressure_TX(abs_T_start,abs_X_LiBr_start)
    "Initial liquid-vapor equilibrium pressure"  annotation(Dialog(group="Absorber", tab = "Initialization"));

  parameter Modelica.Units.SI.MassFraction abs_X_LiBr_start = 0.458
    "Water content in solution"  annotation(Dialog(group="Absorber", tab = "Initialization"));

  parameter Modelica.Units.SI.Volume abs_V_l_start=0.5*abs.V
    "Initial volume of the liquid medium"  annotation(Dialog(group="Absorber", tab = "Initialization"));

  parameter Modelica.Units.SI.ThermalConductance simpleHX_UA(displayUnit="W/K")=
       600 "ThermalConductance" annotation(Dialog(group="Heat exchanger"));
  Static.Components.FlashingWater                    flashingWater(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = flashing_w_dp_nominal,
    m_flow_nominal=flashing_w_m_flow_nominal,
    use_opening=true,
    T_out_start=flashing_w_T_out_start,
    Q_intern_start=flashing_w_Q_intern_start)
    annotation (Placement(transformation(extent={{-204,10},{-184,30}})));
  Components.CondenserDyn_internalHEX con(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = con_p_start,
    T_start=con_T_start,
    UA=con_UA,
    height=con_h,
    crossArea=con_S,
    V_l_start=con_V_l_start,
    T_15(start=con_T_in_start),
    T_16(start=con_T_out_start))
    annotation (Placement(transformation(extent={{-64,94},{-84,114}})));
  Components.EvaporatorDyn_internalHEX eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = eva_p_start,
    T_start=eva_T_start,
    UA=eva_UA,
    height=eva_h,
    crossArea=eva_S,
    V_l_start=eva_V_l_start,
    T_17(start=eva_T_in_start),
    T_18(start=eva_T_out_start))
    annotation (Placement(transformation(extent={{-114,-84},{-94,-64}})));
  Components.GeneratorDyn_internalHEX gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = gen_p_start,
    T_start=gen_T_start,
    X_LiBr_start=gen_X_LiBr_start,
    X_LiBr(start=0.6216),
    UA=gen_UA,
    port_l_b(m_flow(start=-hex.m2_flow_nominal)),
    height=gen_h,
    crossArea=gen_S,
    V_l_start=gen_V_l_start,
    dT1(start=5),
    dT2(start=5),
    T_11(start=gen_T_in_start),
    T_12(start=gen_T_out_start))
    annotation (Placement(transformation(extent={{24,96},{44,116}})));
  Static.Components.FlashingLiBr                    flashingLiBr(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = flashing_LiBr_dp_nominal,
    m_flow_nominal=flashing_LiBr_m_flow_nominal,
    use_opening=true,
    X_LiBr_start=gen.X_LiBr_start,
    T_out_start=318.11,
    p_out_start=abs_p_start,
    Q_intern_start=0.005)
    annotation (Placement(transformation(extent={{118,30},{98,50}})));
  Components.AbsorberDyn_internalHEX abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_ext = Medium_ext,
    p_start(displayUnit="Pa") = abs_p_start,
    T_start=abs_T_start,
    X_LiBr_start=abs_X_LiBr_start,
    height=abs_h,
    crossArea=abs_S,
    V_l_start=abs_V_l_start,
    p(displayUnit="kPa"),
    UA=abs_UA,
    T_13(start=abs_T_in_start),
    T_14(start=abs_T_out_start))
    annotation (Placement(transformation(extent={{90,-118},{110,-98}})));
  replaceable Absolut.FluidBased.Static.Components.HEX.simpleHX hex(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=0.05,
    m2_flow_nominal=0.05,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix=simpleHX_UA) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={34,58})), choices(
      choice(redeclare
          Absolut.FluidBased.Static.Components.HEX.PlateHeatExchangerEffectivenessNTU hex
          "Hex with variable UA"),
      choice(redeclare Absolut.FluidBased.Static.Components.HEX.ConstantEffectiveness hex
          "Hex with constant effectiveness"),
      choice(redeclare Absolut.FluidBased.Static.Components.HEX.simpleHX hex
          "Default: Constant UA value")));

  Static.Components.Pump pump_abstogen(redeclare package Medium_l = Medium_sol,
      T_in_start=abs.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={2,-4})));
  Modelica.Blocks.Sources.RealExpression EER(y=(eva.Hb_flow)/(gen.Hb_flow))
    annotation (Placement(transformation(extent={{-94,160},{-54,180}})));
  Modelica.Blocks.Sources.RealExpression COP(y=-(con.Hb_flow + abs.Hb_flow)/(
        gen.Hb_flow))
    annotation (Placement(transformation(extent={{-94,180},{-54,200}})));
  Modelica.Blocks.Sources.RealExpression Balance(y=con.Hb_flow + gen.Hb_flow +
        eva.Hb_flow + abs.Hb_flow - pump_abstogen.W_dh)
    annotation (Placement(transformation(extent={{-94,200},{-54,220}})));
  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for mediums";
equation
  connect(flashingWater.port_a,con. port_l)
    annotation (Line(points={{-194,29},{-194,88},{-74,88},{-74,94}},
                                                 color={0,127,255}));
  connect(flashingWater.port_l_b,eva. port_l_a) annotation (Line(points={{-198.8,
          11},{-198.8,-83},{-113,-83}},                  color={0,127,255}));
  connect(eva.port_v_a,flashingWater. port_v_b) annotation (Line(points={{-104,-64.2},
          {-104,-46},{-190,-46},{-190,11},{-189,11}},
                                color={0,127,255}));
  connect(con.port_v,gen. port_v) annotation (Line(points={{-74,114},{-74,122},{
          34,122},{34,116}},
                        color={0,127,255}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-94.8,-74},{80,-74},
          {80,-101},{91,-101}}, color={0,127,255}));
  connect(abs.port_v_a, flashingLiBr.port_v_b) annotation (Line(points={{109,-105},
          {112,-105},{112,24},{103,24},{103,31}}, color={0,127,255}));
  connect(abs.port_l_a, flashingLiBr.port_l_b) annotation (Line(points={{109,-111},
          {116,-111},{116,24},{112.8,24},{112.8,31}}, color={0,127,255}));
  connect(hex.port_b1, gen.port_l_a) annotation (Line(points={{28,68},{27,68},{27,
          97}},                    color={0,127,255}));
  connect(hex.port_a2, gen.port_l_b)
    annotation (Line(points={{40,68},{40,90},{41,90},{41,97}},
                                                       color={0,127,255}));
  connect(hex.port_b2, flashingLiBr.port_a) annotation (Line(points={{40,48},{40,
          40},{92,40},{92,56},{108,56},{108,49}},
                                     color={0,127,255}));
  connect(abs.port_l_b, pump_abstogen.port_l_a) annotation (Line(points={{95,-117},
          {96,-117},{96,-124},{62,-124},{62,-22},{2,-22},{2,-13}},
                                                color={0,127,255}));
  connect(pump_abstogen.port_l_b, hex.port_a1) annotation (Line(points={{2,5},{2,
          40},{28,40},{28,48}},    color={0,127,255}));
  connect(flashingWater_opening, flashingWater.opening)
    annotation (Line(points={{-298,20},{-204,20}}, color={0,0,127}));
  connect(flashingLiBr.opening, flashingLiBr_opening) annotation (Line(points={{
          118,40},{182,40},{182,50},{260,50}}, color={0,0,127}));
  connect(m_flow_sol, pump_abstogen.m_dot_in) annotation (Line(points={{260,-30},
          {-18,-30},{-18,-4},{-8,-4}}, color={0,0,127}));
  connect(gen.port_a_ext, port_gen_a) annotation (Line(points={{41,115},{41,156},
          {168,156},{168,210}}, color={0,127,255}));
  connect(con.port_a_ext, port_con_a) annotation (Line(points={{-83,97},{-150,97},
          {-150,210}}, color={0,127,255}));
  connect(con.port_b_ext, port_con_b) annotation (Line(points={{-81,95},{-232,95},
          {-232,210}}, color={0,127,255}));
  connect(port_abs_a, abs.port_a_ext) annotation (Line(points={{230,-190},{232,
          -190},{232,-134},{64,-134},{64,-112},{91,-112},{91,-113}}, color={0,
          127,255}));
  connect(abs.port_b_ext, port_abs_b) annotation (Line(points={{91,-115},{74,-115},
          {74,-170},{114,-170},{114,-190},{110,-190}}, color={0,127,255}));
  connect(port_eva_a, eva.port_a_ext) annotation (Line(points={{-170,-190},{-99,
          -190},{-99,-83}}, color={0,127,255}));
  connect(eva.port_b_ext, port_eva_b) annotation (Line(points={{-103,-83},{-103,
          -158},{-250,-158},{-250,-190}}, color={0,127,255}));
  connect(gen.port_b_ext, port_gen_b) annotation (Line(points={{43,113},{64,113},
          {64,186},{50,186},{50,210}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,-200},
            {260,220}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-300,-200},{260,220}})));
end AHP_internal_hex;
