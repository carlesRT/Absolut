within Absolut.FluidBased.Dynamic.AHP;
model AHP

  parameter Integer nEle = 4 "discretization of pipe";

  replaceable package Medium_sol = Absolut.Media.LiBrH2O;
  replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph annotation (
     __Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph annotation (
     __Dymola_choicesAllMatching=true);

  Components.EvaporatorDyn_heatport eva(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    p_start(displayUnit="kPa") = eva_p_start,
    T_start(displayUnit="degC") = eva_T_start,
    UA=eva_UA,
    height=eva_h,
    crossArea=eva_S,
    V_l_start=eva_V_l_start)
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Static.Components.FlashingWater flashingWater(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = flashing_w_dp_nominal,
    m_flow_nominal=flashing_w_m_flow_nominal,
    use_opening=true,
    T_out_start=flashing_w_T_out_start,
    Q_intern_start=flashing_w_Q_intern_start)
    annotation (Placement(transformation(extent={{-194,4},{-174,24}})));
  Components.AbsorberDyn_heatport abs(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    p_start(displayUnit="kPa") = abs_p_start,
    T_start=abs_T_start,
    X_LiBr_start=abs_X_LiBr_start,
    height=abs_h,
    crossArea=abs_S,
    V_l_start=abs_V_l_start,
    UA=abs_UA)
    annotation (Placement(transformation(extent={{72,-90},{92,-70}})));
  Static.Components.FlashingLiBr flashingLiBr(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = flashing_LiBr_dp_nominal,
    m_flow_nominal=flashing_LiBr_m_flow_nominal,
    X_LiBr_start=gen.X_LiBr_start,
    T_out_start=flashing_LiBr_T_out_start,
    p_out_start=flashing_LiBr_p_out_start,
    Q_intern_start=flashing_LiBr_Q_intern_start)
    annotation (Placement(transformation(extent={{140,-32},{160,-12}})));
  Static.Components.HEX.simpleHX hex(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    m1_flow_nominal=0.5,
    m2_flow_nominal=0.5,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix(displayUnit="W/K") = simpleHX_UA) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,50})));

  Static.Components.Pump pump_abstogen(redeclare package Medium_l = Medium_sol,
      T_in_start=abs.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,-102})));
  Components.GeneratorDyn_heatport gen(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_sol,
    p_start(displayUnit="kPa") = gen_p_start,
    T_start=gen_T_start,
    X_LiBr_start=gen_X_LiBr_start,
    UA=gen_UA,
    height=gen_h,
    crossArea=gen_S,
    V_l_start=gen_V_l_start)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Components.CondenserDyn_heatport con(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    p_start(displayUnit="Pa") = con_p_start,
    T_start=con_T_start,
    UA=con_UA,
    height=con_h,
    crossArea=con_S,
    V_l_start=con_V_l_start)
    annotation (Placement(transformation(extent={{-100,70},{-120,90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector_eva(m=nEle)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-162,-84})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor_eva[nEle](each C=
        eva_C,each T(start=pipemass_eva_T_start)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-252,-68})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector_abs(m=nEle)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={102,-120})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor_abs[nEle](each C=
        abs_C,
             each T(start=pipemass_abs_T_start))
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={176,-122})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector_gen(m=nEle)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={94,120})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor_gen[nEle](each C=
        gen_C,each T(start=pipemass_gen_T_start)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={144,178})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector_con(m=nEle)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-108,112})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor_con[nEle](each C=
        con_C,each T(start=pipemass_con_T_start)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-122,190})));
  Modelica.Blocks.Interfaces.RealInput flashingWater_opening
    annotation (Placement(transformation(extent={{-318,0},{-278,40}})));
  Modelica.Blocks.Interfaces.RealInput flashingLiBr_opening
    annotation (Placement(transformation(extent={{280,30},{240,70}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_sol
    "mass flow rate of solution pump"
    annotation (Placement(transformation(extent={{280,-50},{240,-10}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_con(
    allowFlowReversal=allowFlowReversal,
    use_HeatTransfer=true,
    redeclare package Medium = Medium_ext,
    length=0.5,
    diameter(displayUnit="m") = 0.2,
    nParallel=1,
    isCircular=true,
    roughness=0,
    height_ab=0,
    nNodes=nEle,
    useLumpedPressure=false,
    useInnerPortProperties=false,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
          dp_nominal(displayUnit="Pa") = 0.001, m_flow_nominal=0.175),
    modelStructure=Modelica.Fluid.Types.ModelStructure.av_vb,
    m_flow_start=0.03047,
    momentumDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_a_start=100000,
    use_T_start=true,
    T_start(displayUnit="degC") = pipemass_con_T_start)
    annotation (Placement(transformation(extent={{-172,220},{-192,200}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_gen(
    allowFlowReversal=allowFlowReversal,
    use_HeatTransfer=true,
    redeclare package Medium = Medium_ext,
    length=0.5,
    diameter(displayUnit="m") = 0.2,
    nParallel=1,
    isCircular=true,
    roughness=0,
    height_ab=0,
    nNodes=nEle,
    useLumpedPressure=false,
    useInnerPortProperties=false,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
          dp_nominal(displayUnit="Pa") = 0.001, m_flow_nominal=0.175),
    modelStructure=Modelica.Fluid.Types.ModelStructure.av_vb,
    m_flow_start=0.03047,
    momentumDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_a_start=100000,
    use_T_start=true,
    T_start(displayUnit="degC") = pipemass_gen_T_start)
    annotation (Placement(transformation(extent={{114,220},{94,200}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_abs(
    allowFlowReversal=allowFlowReversal,
    use_HeatTransfer=true,
    redeclare package Medium = Medium_ext,
    length=0.5,
    diameter(displayUnit="m") = 0.2,
    nParallel=1,
    isCircular=true,
    roughness=0,
    height_ab=0,
    nNodes=nEle,
    useLumpedPressure=false,
    useInnerPortProperties=false,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
          dp_nominal(displayUnit="Pa") = 0.001, m_flow_nominal=0.175),
    modelStructure=Modelica.Fluid.Types.ModelStructure.av_vb,
    m_flow_start=0.172,
    momentumDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_a_start=100000,
    use_T_start=true,
    T_start(displayUnit="degC") = pipemass_abs_T_start)
    annotation (Placement(transformation(extent={{186,-194},{166,-174}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_eva(
    allowFlowReversal=allowFlowReversal,
    use_HeatTransfer=true,
    redeclare package Medium = Medium_ext,
    length=0.5,
    diameter(displayUnit="m") = 0.2,
    nParallel=1,
    isCircular=true,
    roughness=0,
    height_ab=0,
    nNodes=nEle,
    useLumpedPressure=false,
    useInnerPortProperties=false,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
          dp_nominal(displayUnit="Pa") = 0.001, m_flow_nominal=0.175),
    modelStructure=Modelica.Fluid.Types.ModelStructure.av_vb,
    m_flow_start=0.28,
    momentumDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_a_start=100000,
    use_T_start=true,
    T_start(displayUnit="degC") = pipemass_eva_T_start)
    annotation (Placement(transformation(extent={{-200,-196},{-220,-176}})));
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

  parameter Real flashing_LiBr_Q_intern_start=0.065  annotation(Dialog(group="Valve - waterLiBr", tab = "Initialization"));

  parameter Modelica.Units.SI.Pressure flashing_LiBr_p_out_start=abs.p_start  annotation(Dialog(group="Valve - waterLiBr", tab = "Initialization"));

  parameter Modelica.Media.Interfaces.Types.Temperature pipemass_eva_T_start(
      displayUnit="degC") = 321.15 "Start value of temperature"  annotation(Dialog(group="Evaporator", tab = "Initialization"));

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
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_eva_a(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{-180,-200},{-160,-180}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_eva_b(redeclare package Medium =
        Medium_ext)
    annotation (Placement(transformation(extent={{-260,-200},{-240,-180}})));
  parameter Modelica.Media.Interfaces.Types.Temperature pipemass_con_T_start(
      displayUnit="degC") = 336.15 "Start value of temperature"  annotation(Dialog(group="Condenser", tab = "Initialization"));

  parameter Modelica.Media.Interfaces.Types.Temperature pipemass_abs_T_start(
      displayUnit="degC") = 331.65 "Start value of temperature"  annotation(Dialog(group="Absorber", tab = "Initialization"));

  parameter Modelica.Media.Interfaces.Types.Temperature pipemass_gen_T_start(
      displayUnit="degC") = 353.15
    "Start value of temperature"  annotation(Dialog(group="Generator", tab = "Initialization"));

  parameter Modelica.Units.SI.ThermalConductance eva_UA=400
    "UA value of HX in W/K" annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.MassFlowRate m_eva= 0.1 "Nominal mass flow rate at evaporator" annotation(Dialog(group="Evaporator"));
  parameter Real n_eva = 0.6 "Exponent factor UA value - Evaporator" annotation(Dialog(group="Evaporator"));

  parameter Modelica.Units.SI.Height eva_h=0.1 "Height of vessel" annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.Area eva_S=0.5 "Area of vessel" annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.Temperature eva_T_start(displayUnit="degC")=
    Medium_l.saturationTemperature(eva_p_start) "Initial liquid-vapor equilibrium temperature"  annotation(Dialog(group="Evaporator", tab = "Initialization"));

  parameter Modelica.Units.SI.Volume eva_V_l_start=0.5*eva.V
    "Initial volume of the liquid medium"  annotation(Dialog(group="Evaporator", tab = "Initialization"));

  parameter Modelica.Units.SI.AbsolutePressure eva_p_start = Medium_l.saturationPressure(eva_T_start)
    "Initial liquid-vapor equilibrium pressure"  annotation(Dialog(group="Evaporator", tab = "Initialization"));

  parameter Modelica.Units.SI.ThermalConductance con_UA=1000 annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.MassFlowRate m_con = 0.1 "Nominal mass flow rate at condenser" annotation(Dialog(group="Condenser"));
  parameter Real n_con= 0.6 "Exponent factor UA value - condenser" annotation(Dialog(group="Condenser"));

  parameter Modelica.Units.SI.Height con_h=0.1 "Height of vessel" annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.Area con_S=0.5 "Area of vessel" annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.Temperature con_T_start= Medium_l.saturationTemperature(con_p_start) "Initial liquid-vapor equilibrium temperature"  annotation(Dialog(group="Condenser", tab = "Initialization"));

  parameter Modelica.Units.SI.Volume con_V_l_start=0.5*con.V
    "Initial volume of the liquid medium"  annotation(Dialog(group="Condenser", tab = "Initialization"));

  parameter Modelica.Units.SI.AbsolutePressure con_p_start = Medium_l.saturationPressure(con_T_start)
    "Initial liquid-vapor equilibrium pressure"  annotation(Dialog(group="Condenser", tab = "Initialization"));

  parameter Modelica.Units.SI.ThermalConductance gen_UA=800
    "UA value of HX in W/K" annotation(Dialog(group="Generator"));
  parameter Modelica.Units.SI.MassFlowRate m_gen = 0.1 "Nominal mass flow rate at generator" annotation(Dialog(group="Generator"));
  parameter Real n_gen= 0.6 "Exponent factor UA value - Generator" annotation(Dialog(group="Generator"));

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
  parameter Modelica.Units.SI.MassFlowRate m_abs= 0.1 "Nominal mass flow rate at absorber" annotation(Dialog(group="Absorber"));
  parameter Real n_abs= 0.6 "Exponent factor UA value - absorber" annotation(Dialog(group="Absorber"));

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
  parameter Modelica.Units.SI.HeatCapacity eva_C=5000
    "Heat capacity of element (= cp*m)" annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.HeatCapacity abs_C=5000
    "Heat capacity of element (= cp*m)" annotation(Dialog(group="Absorber"));
  parameter Modelica.Units.SI.HeatCapacity gen_C=5000
    "Heat capacity of element (= cp*m)" annotation(Dialog(group="Generator"));
  parameter Modelica.Units.SI.HeatCapacity con_C=5000
    "Heat capacity of element (= cp*m)" annotation(Dialog(group="Condenser"));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_con_ext[nEle]
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-162,168})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_con_int[nEle]
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-88,168})));
  Modelica.Blocks.Routing.Replicator replicator_con(nout=nEle)
    annotation (Placement(transformation(extent={{-258,158},{-238,178}})));
  Modelica.Blocks.Sources.RealExpression UAcon(y=(max(0.1, (port_con_a.m_flow/
        m_con))^n_con)*con_UA/nEle)
    annotation (Placement(transformation(extent={{-298,160},{-278,180}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_gen_ext[nEle]
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={204,162})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_gen_int[nEle]
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={110,158})));
  Modelica.Blocks.Routing.Replicator replicator_gen(nout=nEle)
    annotation (Placement(transformation(extent={{244,128},{224,148}})));
  Modelica.Blocks.Sources.RealExpression UAgen(y=(max(0.1, (port_gen_a.m_flow/
        m_gen))^n_gen)*gen_UA/nEle)
    annotation (Placement(transformation(extent={{296,130},{276,150}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_abs_ext[nEle]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={212,-146})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_abs_int[nEle]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={112,-150})));
  Modelica.Blocks.Routing.Replicator replicator_abs(nout=nEle)
    annotation (Placement(transformation(extent={{106,-236},{126,-216}})));
  Modelica.Blocks.Sources.RealExpression UAabs(y=(max(0.1, (port_abs_a.m_flow/
        m_abs))^n_abs)*abs_UA/nEle)
    annotation (Placement(transformation(extent={{46,-236},{66,-216}})));
  Modelica.Blocks.Sources.RealExpression UAeva(y=(max(0.1, (port_eva_a.m_flow/
        m_eva))^n_eva)*eva_UA/nEle)
    annotation (Placement(transformation(extent={{-358,-148},{-338,-128}})));
  Modelica.Blocks.Routing.Replicator replicator_eva(nout=nEle)
    annotation (Placement(transformation(extent={{-304,-140},{-284,-120}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_eva_int[nEle]
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-202,-96})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_eva_ext[nEle]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-216,-144})));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
equation
  connect(flashingWater.port_a, con.port_l) annotation (Line(points={{-184,23},{
          -184,64},{-110,64},{-110,70}}, color={0,127,255}));
  connect(flashingWater.port_l_b, eva.port_l_a) annotation (Line(points={{-188.8,
          5},{-188.8,-34},{-206,-34},{-206,-59},{-199,-59}}, color={0,127,255}));
  connect(eva.port_v_a, flashingWater.port_v_b) annotation (Line(points={{-190,-40.2},
          {-190,-19.6},{-179,-19.6},{-179,5}}, color={0,127,255}));
  connect(eva.port_v, abs.port_v) annotation (Line(points={{-180.8,-50},{-48,-50},
          {-48,-73},{73,-73}}, color={0,127,255}));
  connect(abs.port_v_a, flashingLiBr.port_v_b) annotation (Line(points={{91,-77},
          {155,-77},{155,-31}}, color={0,127,255}));
  connect(abs.port_l_a, flashingLiBr.port_l_b) annotation (Line(points={{91,-83},
          {145.2,-83},{145.2,-31}}, color={0,127,255}));
  connect(hex.port_b2, flashingLiBr.port_a) annotation (Line(points={{96,40},{
          96,-4},{150,-4},{150,-13}}, color={0,127,255}));
  connect(pump_abstogen.port_l_b, hex.port_a1) annotation (Line(points={{30,-93},
          {30,36},{84,36},{84,40}}, color={0,127,255}));
  connect(pump_abstogen.port_l_a, abs.port_l_b) annotation (Line(points={{30,-111},
          {30,-118},{77,-118},{77,-89}}, color={0,127,255}));
  connect(con.port_v,gen. port_v) annotation (Line(points={{-110,90},{54,90},{54,
          106},{70,106},{70,100}},
                             color={0,127,255}));
  connect(thermalCollector_eva.port_b, eva.heatPort) annotation (Line(points={{-162,
          -74},{-162,-68},{-190,-68},{-190,-50}},                         color=
         {191,0,0}));
  connect(gen.heatPort,thermalCollector_gen. port_b)
    annotation (Line(points={{70,90},{94,90},{94,110}}, color={191,0,0}));
  connect(con.heatPort, thermalCollector_con.port_b) annotation (Line(points={{-110,80},
          {-110,96},{-108,96},{-108,102}},     color={191,0,0}));
  connect(hex.port_b1, gen.port_l_a) annotation (Line(points={{84,60},{84,74},{
          63,74},{63,81}}, color={0,127,255}));
  connect(hex.port_a2, gen.port_l_b)
    annotation (Line(points={{96,60},{96,81},{77,81}}, color={0,127,255}));
  connect(abs.heatPort, thermalCollector_abs.port_b)
    annotation (Line(points={{82,-80},{82,-110},{102,-110}}, color={191,0,0}));
  connect(flashingLiBr.opening, flashingLiBr_opening) annotation (Line(points={{
          140,-22},{130,-22},{130,50},{260,50}}, color={0,0,127}));
  connect(pump_abstogen.m_dot_in, m_flow_sol) annotation (Line(points={{20,-102},
          {14,-102},{14,-104},{0,-104},{0,-58},{214,-58},{214,-30},{260,-30}},
        color={0,0,127}));
  connect(flashingWater_opening, flashingWater.opening) annotation (Line(points
        ={{-298,20},{-206,20},{-206,14},{-194,14}}, color={0,0,127}));
  connect(port_abs_b, pipe_abs.port_b) annotation (Line(points={{110,-190},{140,
          -190},{140,-184},{166,-184}}, color={0,127,255}));
  connect(pipe_abs.port_a, port_abs_a) annotation (Line(points={{186,-184},{206,
          -184},{206,-190},{230,-190}}, color={0,127,255}));
  connect(port_gen_b, pipe_gen.port_b)
    annotation (Line(points={{50,210},{94,210}}, color={0,127,255}));
  connect(pipe_gen.port_a, port_gen_a)
    annotation (Line(points={{114,210},{168,210}}, color={0,127,255}));
  connect(pipe_con.port_a, port_con_a)
    annotation (Line(points={{-172,210},{-150,210}}, color={0,127,255}));
  connect(port_con_b, pipe_con.port_b)
    annotation (Line(points={{-230,210},{-192,210}}, color={0,127,255}));
  connect(port_eva_b, pipe_eva.port_b) annotation (Line(points={{-250,-190},{-226,
          -190},{-226,-186},{-220,-186}}, color={0,127,255}));
  connect(pipe_eva.port_a, port_eva_a) annotation (Line(points={{-200,-186},{-186,
          -186},{-186,-190},{-170,-190}}, color={0,127,255}));
  connect(replicator_con.y, convection_con_ext.Gc) annotation (Line(points={{-237,
          168},{-222,168},{-222,148},{-162,148},{-162,158}}, color={0,0,127}));
  connect(replicator_con.y, convection_con_int.Gc) annotation (Line(points={{-237,
          168},{-222,168},{-222,148},{-88,148},{-88,158}}, color={0,0,127}));
  connect(UAcon.y, replicator_con.u) annotation (Line(points={{-277,170},{-268,170},
          {-268,168},{-260,168}}, color={0,0,127}));
  connect(replicator_gen.y, convection_gen_int.Gc) annotation (Line(points={{223,
          138},{188,138},{188,128},{116,128},{116,148},{110,148}}, color={0,0,127}));
  connect(replicator_gen.y, convection_gen_ext.Gc) annotation (Line(points={{223,
          138},{223,140},{204,140},{204,152}}, color={0,0,127}));
  connect(replicator_gen.u, UAgen.y)
    annotation (Line(points={{246,138},{246,140},{275,140}}, color={0,0,127}));
  connect(replicator_abs.y, convection_abs_int.Gc) annotation (Line(points={{127,
          -226},{142,-226},{142,-122},{116,-122},{116,-140},{112,-140}}, color={
          0,0,127}));
  connect(replicator_abs.y, convection_abs_ext.Gc) annotation (Line(points={{127,
          -226},{144,-226},{144,-214},{252,-214},{252,-126},{212,-126},{212,-136}},
        color={0,0,127}));
  connect(UAabs.y, replicator_abs.u)
    annotation (Line(points={{67,-226},{104,-226}}, color={0,0,127}));
  connect(UAeva.y, replicator_eva.u) annotation (Line(points={{-337,-138},{-322,
          -138},{-322,-130},{-306,-130}}, color={0,0,127}));
  connect(replicator_eva.y, convection_eva_ext.Gc) annotation (Line(points={{-283,
          -130},{-248,-130},{-248,-128},{-216,-128},{-216,-134}}, color={0,0,127}));
  connect(replicator_eva.y, convection_eva_int.Gc) annotation (Line(points={{-283,
          -130},{-283,-132},{-248,-132},{-248,-128},{-202,-128},{-202,-106}},
        color={0,0,127}));
  connect(pipe_con.heatPorts, convection_con_ext.fluid) annotation (Line(points
        ={{-182.1,205.6},{-182.1,168},{-172,168}}, color={127,0,0}));
  connect(convection_con_ext.solid, heatCapacitor_con.port) annotation (Line(
        points={{-152,168},{-146,168},{-146,166},{-122,166},{-122,180}}, color={
          191,0,0}));
  connect(heatCapacitor_con.port, convection_con_int.fluid) annotation (Line(
        points={{-122,180},{-122,162},{-102,162},{-102,168},{-98,168}}, color={191,
          0,0}));
  connect(convection_con_int.solid, thermalCollector_con.port_a) annotation (
      Line(points={{-78,168},{-56,168},{-56,138},{-108,138},{-108,122}}, color={
          191,0,0}));
  connect(convection_gen_int.solid, thermalCollector_gen.port_a)
    annotation (Line(points={{100,158},{94,158},{94,130}}, color={191,0,0}));
  connect(convection_gen_int.fluid, heatCapacitor_gen.port)
    annotation (Line(points={{120,158},{120,168},{144,168}}, color={191,0,0}));
  connect(convection_gen_ext.solid, heatCapacitor_gen.port) annotation (Line(
        points={{194,162},{164,162},{164,160},{144,160},{144,168}}, color={191,0,
          0}));
  connect(convection_gen_ext.fluid, pipe_gen.heatPorts) annotation (Line(points
        ={{214,162},{224,162},{224,232},{32,232},{32,192},{103.9,192},{103.9,205.6}},
        color={191,0,0}));
  connect(convection_abs_int.solid, thermalCollector_abs.port_a) annotation (
      Line(points={{102,-150},{96,-150},{96,-130},{102,-130}}, color={191,0,0}));
  connect(convection_abs_int.fluid, heatCapacitor_abs.port) annotation (Line(
        points={{122,-150},{142,-150},{142,-148},{176,-148},{176,-132}}, color={
          191,0,0}));
  connect(convection_abs_ext.solid, heatCapacitor_abs.port) annotation (Line(
        points={{202,-146},{176,-146},{176,-132}}, color={191,0,0}));
  connect(pipe_abs.heatPorts, convection_abs_ext.fluid) annotation (Line(points
        ={{175.9,-179.6},{175.9,-164},{230,-164},{230,-146},{222,-146}}, color={
          127,0,0}));
  connect(convection_eva_ext.fluid, pipe_eva.heatPorts) annotation (Line(points
        ={{-206,-144},{-206,-181.6},{-210.1,-181.6}}, color={191,0,0}));
  connect(convection_eva_ext.solid, heatCapacitor_eva.port) annotation (Line(
        points={{-226,-144},{-236,-144},{-236,-88},{-252,-88},{-252,-78}},
        color={191,0,0}));
  connect(convection_eva_int.fluid, heatCapacitor_eva.port) annotation (Line(
        points={{-212,-96},{-236,-96},{-236,-88},{-252,-88},{-252,-78}}, color={
          191,0,0}));
  connect(convection_eva_int.solid, thermalCollector_eva.port_a) annotation (
      Line(points={{-192,-96},{-180,-96},{-180,-98},{-162,-98},{-162,-94}},
        color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,-200},
            {260,220}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-300,-200},{260,220}})));
end AHP;
