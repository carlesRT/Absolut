within Absolut.FluidBased.Dynamic.AHP;
model AHP_pump_hex_extended_compressorLowP

  parameter Integer nEle = 4 "discretization of pipe";
  Real t = time;
  Real A_rad = 1.2 "0.985";

  //parameter Real n = 1                      "                      ";

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
    T_out_start=flashing_w_T_out_start,
    Q_intern_start=flashing_w_Q_intern_start)
    annotation (Placement(transformation(extent={{-212,10},{-192,30}})));
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
    annotation (Placement(transformation(extent={{74,-92},{94,-72}})));
  Static.Components.FlashingLiBr flashingLiBr(
    redeclare package Medium_l = Medium_sol,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="kPa") = flashing_LiBr_dp_nominal,
    m_flow_nominal=flashing_LiBr_m_flow_nominal,
    use_opening=true,
    X_LiBr_start=gen.X_LiBr_start,
    T_out_start=flashing_LiBr_T_out_start,
    p_out_start=flashing_LiBr_p_out_start,
    Q_intern_start=flashing_LiBr_Q_intern_start)
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness
                             hex(
    redeclare package Medium1 = Medium_sol,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=0.5,
    m2_flow_nominal=0.5,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    eps=0.9)                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={36,-16})));

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
    annotation (Placement(transformation(extent={{80,84},{100,104}})));
  Components.CondenserDyn_heatport con(
    redeclare package Medium_v = Medium_v,
    redeclare package Medium_l = Medium_l,
    p_start(displayUnit="Pa") = con_p_start,
    T_start=con_T_start,
    UA=con_UA,
    height=con_h,
    crossArea=con_S,
    V_l_start=con_V_l_start)
    annotation (Placement(transformation(extent={{-156,76},{-176,96}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector_eva(m=nEle)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-160,-88})));
  Modelica.Thermal.HeatTransfer.Components.Convection       convection5             [nEle]
                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-194,-96})));
  Modelica.Thermal.HeatTransfer.Components.Convection       convection4             [nEle]
                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-196,-150})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor_eva[nEle](each C=
        eva_C/nEle,
              each T(start=pipemass_eva_T_start)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-226,-78})));
  Modelica.Thermal.HeatTransfer.Components.Convection       convection              [nEle]
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-148})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector_abs(m=nEle)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={66,-138})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor_abs[nEle](each C=
        abs_C/nEle,
             each T(start=pipemass_abs_T_start))
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={170,-130})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector_gen(m=nEle)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={128,138})));
  Modelica.Thermal.HeatTransfer.Components.Convection       convection7             [nEle]
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={148,176})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor_gen[nEle](each C=
        gen_C/nEle,
              each T(start=pipemass_gen_T_start)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={168,136})));
  Modelica.Thermal.HeatTransfer.Components.Convection       convection6             [nEle]
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={206,172})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector_con(m=nEle)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,140})));
  Modelica.Thermal.HeatTransfer.Components.Convection       convection3             [nEle]
                     annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-88,168})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor_con[nEle](each C=
        con_C/nEle,
              each T(start=pipemass_con_T_start)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-122,190})));
  Modelica.Thermal.HeatTransfer.Components.Convection       convection2             [nEle]
                     annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-172,170})));
  Modelica.Blocks.Interfaces.RealInput flashingWater_opening
    annotation (Placement(transformation(extent={{-318,0},{-278,40}})));
  Modelica.Blocks.Interfaces.RealInput flashingLiBr_opening
    annotation (Placement(transformation(extent={{280,30},{240,70}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_sol
    "mass flow rate of solution pump"
    annotation (Placement(transformation(extent={{280,-50},{240,-10}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_con(
    allowFlowReversal=false,
    redeclare package Medium = Medium_ext,
    length=0.2,
    diameter(displayUnit="m") = 0.1,
    roughness=0,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
          dp_nominal(displayUnit="Pa") = 1000, m_flow_nominal=1.4),
    p_a_start=100000,
    T_start(displayUnit="degC") = pipemass_con_T_start,
    m_flow_start=m_flow_start_pipe_con,
    nNodes=nEle,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer)
    annotation (Placement(transformation(extent={{-178,232},{-198,252}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_gen(
    allowFlowReversal=false,
    use_HeatTransfer=true,
    redeclare package Medium = Medium_ext,
    length(displayUnit="m") = 0.2,
    diameter(displayUnit="m") = 0.1,
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
    m_flow_start=m_flow_start_pipe_gen,
    momentumDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_a_start=100000,
    use_T_start=true,
    T_start(displayUnit="degC") = pipemass_gen_T_start)
    annotation (Placement(transformation(extent={{114,220},{94,200}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_abs(
    allowFlowReversal=false,
    redeclare package Medium = Medium_ext,
    length=0.2,
    diameter(displayUnit="m") = 0.1,
    roughness=0,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
          dp_nominal(displayUnit="Pa") = 1000, m_flow_nominal=1.4),
    p_a_start=100000,
    T_start(displayUnit="degC") = pipemass_abs_T_start,
    m_flow_start=m_flow_start_pipe_abs,
    nNodes=nEle,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer)
    annotation (Placement(transformation(extent={{186,-174},{166,-194}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe_eva(
    allowFlowReversal=false,
    use_HeatTransfer=true,
    redeclare package Medium = Medium_ext,
    length=0.2,
    diameter(displayUnit="m") = 0.1,
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
    m_flow_start=m_flow_start_pipe_eva,
    momentumDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_a_start=100000,
    use_T_start=true,
    T_start(displayUnit="degC") = pipemass_eva_T_start)
    annotation (Placement(transformation(extent={{-202,-196},{-222,-176}})));
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

  parameter Modelica.Units.SI.ThermalConductance eva_UA= 1000
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

  parameter Modelica.Units.SI.ThermalConductance gen_UA=1000
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

  parameter Modelica.Units.SI.ThermalConductance abs_UA= 1000 "in W/K" annotation(Dialog(group="Absorber"));
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

 parameter Modelica.Units.SI.ThermalConductance UA_amb=0
    "UA value for convective heat losses";

  Static.Components.HEX.simpleHX hex_abs(
    redeclare package Medium1 = Medium_ext,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=6,
    m2_flow_nominal=6,
    show_T=true,
    dp1_nominal(displayUnit="bar") = 0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix(displayUnit="W/K") = 50000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={178,-92})));

  Static.Components.HEX.simpleHX hex_gen(
    redeclare package Medium1 = Medium_ext,
    redeclare package Medium2 = Medium_sol,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=6,
    m2_flow_nominal=6,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    UA_fix(displayUnit="W/K") = 50000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={44,144})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor_gen_heatlosses(each G=
        UA_amb)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={176,98})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=298.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={230,98})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor_con_heatlosses(each G=
        UA_amb) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-243,117})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_con(T=298.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-194,118})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor_eva_heatlosses(each G=
        UA_amb) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-292,-16})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_eva(T=298.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-244,-16})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor_abs_heatlosses(each G=
        UA_amb) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-168})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_abs(T=298.15)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={38,-168})));
  Modelica.Thermal.HeatTransfer.Components.Convection       convection1             [nEle]
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={210,-144})));
  Modelica.Blocks.Routing.Replicator replicatorabs(nout=nEle)
    annotation (Placement(transformation(extent={{102,-234},{122,-214}})));
  Modelica.Blocks.Routing.Replicator replicatorcon(nout=nEle)
    annotation (Placement(transformation(extent={{-260,160},{-240,180}})));
  Modelica.Blocks.Sources.RealExpression sumHeatLosses(y=fixedTemperature.port.Q_flow
         + fixedTemperature_con.port.Q_flow + fixedTemperature_eva.port.Q_flow +
        fixedTemperature_abs.port.Q_flow)
    annotation (Placement(transformation(extent={{-342,64},{-322,84}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow_radcon
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-236,70})));
  Modelica.Blocks.Sources.RealExpression Qrad_con
    "-0.95*Modelica.Constants.sigma*A_rad*((con.T)^4 - (298.15^4))"
    annotation (Placement(transformation(extent={{-288,60},{-268,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow_radeva
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-286,-82})));
  Modelica.Blocks.Sources.RealExpression Qrad_eva
    "-0.95*Modelica.Constants.sigma*A_rad*((eva.T)^4 - (298.15^4))"
    annotation (Placement(transformation(extent={{-340,-92},{-320,-72}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow_radabs
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-18,-26})));
  Modelica.Blocks.Sources.RealExpression Qrad_abs
    "-0.95*Modelica.Constants.sigma*A_rad*((abs.T)^4 - (298.15^4))"
    annotation (Placement(transformation(extent={{-74,-36},{-54,-16}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow_radgen
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,82})));
  Modelica.Blocks.Sources.RealExpression Qrad_gen
    "-0.95*Modelica.Constants.sigma*A_rad*((gen.T)^4 - (298.15^4))"
    annotation (Placement(transformation(extent={{-34,72},{-14,92}})));
  Static.Components.Pump pump_gentoabs(redeclare package Medium_l = Medium_sol,
      T_in_start=gen.T_start) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={88,44})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{158,12},{138,32}})));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    m_flow_start_pipe_con=0.03047 "Start value for mass flow rate";
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    m_flow_start_pipe_gen=0.03047 "Start value for mass flow rate";
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    m_flow_start_pipe_eva=0.28 "Start value for mass flow rate";
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    m_flow_start_pipe_abs=0.172 "Start value for mass flow rate";
  Modelica.Blocks.Routing.Replicator replicatoreva(nout=nEle)
    annotation (Placement(transformation(extent={{-140,-160},{-160,-140}})));
  Modelica.Blocks.Routing.Replicator replicatorgen(nout=nEle)
    annotation (Placement(transformation(extent={{260,204},{240,224}})));
  Modelica.Blocks.Sources.RealExpression Qgen_effective(y=hex_gen.Q2_flow + gen.Qb_flow)
    annotation (Placement(transformation(extent={{-14,156},{6,176}})));
  Modelica.Blocks.Sources.RealExpression Qin_sim_external(y=Qeva_effective.y +
        Qgen_effective.y)
    annotation (Placement(transformation(extent={{310,-108},{290,-88}})));
  Modelica.Blocks.Sources.RealExpression Qout_sim_external(y=Qabs_effective.y
         + Qcon_effective.y)
    annotation (Placement(transformation(extent={{310,-128},{290,-108}})));
  Modelica.Blocks.Sources.RealExpression Qbalance_sim_external(y=
        Qin_sim_external.y - Qout_sim_external.y)
    annotation (Placement(transformation(extent={{350,-108},{330,-88}})));
  Modelica.Blocks.Sources.RealExpression Qin_sim_internal(y=eva.Qb_flow + gen.Qb_flow
         + hex_gen.Q2_flow)
    annotation (Placement(transformation(extent={{310,-168},{290,-148}})));
  Modelica.Blocks.Sources.RealExpression Qout_sim_internal(y=hex_abs.Q1_flow -
        abs.Qb_flow - con.Qb_flow)
    annotation (Placement(transformation(extent={{310,-188},{290,-168}})));
  Modelica.Blocks.Sources.RealExpression Qbalance_sim_internal(y=
        Qin_sim_internal.y - Qout_sim_internal.y)
    annotation (Placement(transformation(extent={{350,-168},{330,-148}})));
  Modelica.Blocks.Sources.RealExpression Qheatlosses_rad(y=
        prescribedHeatFlow_radabs.port.Q_flow + prescribedHeatFlow_radgen.port.Q_flow
         + prescribedHeatFlow_radeva.port.Q_flow + prescribedHeatFlow_radcon.port.Q_flow)
    annotation (Placement(transformation(extent={{350,-128},{330,-108}})));
  Modelica.Blocks.Sources.RealExpression Qheatlosses_con(y=fixedTemperature_con.port.Q_flow
         + fixedTemperature.port.Q_flow + fixedTemperature_eva.port.Q_flow +
        fixedTemperature_abs.port.Q_flow)
    annotation (Placement(transformation(extent={{350,-188},{330,-168}})));
  Modelica.Blocks.Sources.RealExpression Qheatlosses(y=Qheatlosses_con.y +
        Qheatlosses_rad.y)
    annotation (Placement(transformation(extent={{386,-148},{366,-128}})));
  Modelica.Blocks.Sources.RealExpression Qabs_effective(y=thermalCollector_abs.port_b.Q_flow
         + hex_abs.Q1_flow)
    annotation (Placement(transformation(extent={{414,-72},{394,-52}})));
  Modelica.Blocks.Sources.RealExpression Qcon_effective(y=thermalCollector_con.port_b.Q_flow)
    annotation (Placement(transformation(extent={{380,-60},{360,-40}})));
  Modelica.Blocks.Sources.RealExpression Qeva_effective(y=-thermalCollector_eva.port_b.Q_flow)
    annotation (Placement(transformation(extent={{380,-80},{360,-60}})));
  Modelica.Blocks.Sources.RealExpression UAeva(y=max(0.1, ((port_eva_a.m_flow/
        m_eva)^0.8))*eva_UA/nEle)
    annotation (Placement(transformation(extent={{-68,-230},{-114,-212}})));
  Modelica.Blocks.Sources.RealExpression UAabs(y=max(0.1, ((port_abs_a.m_flow/
        m_abs)^0.8))*abs_UA/nEle)
    annotation (Placement(transformation(extent={{44,-232},{64,-212}})));
  Modelica.Blocks.Sources.RealExpression UAgen(y=max(0.1, ((port_gen_a.m_flow/
        m_gen)^0.8))*gen_UA/nEle)
    annotation (Placement(transformation(extent={{308,124},{288,144}})));
  Modelica.Blocks.Sources.RealExpression UAcon(y=max(0.1, ((port_con_a.m_flow/
        m_con)^0.8))*con_UA/nEle)
    annotation (Placement(transformation(extent={{-360,180},{-340,200}})));
  Static.Components.Compressor compressorEA
    "Compressor at low pressure: Evaporator to Absorber"
    annotation (Placement(transformation(extent={{-80,-68},{-60,-48}})));
equation

  connect(flashingWater.port_a, con.port_l) annotation (Line(points={{-202,29},{
          -202,76},{-166,76}}, color={0,127,255}));
  connect(flashingWater.port_l_b, eva.port_l_a) annotation (Line(points={{-206.8,
          11},{-206.8,-59},{-199,-59}}, color={0,127,255}));
  connect(eva.port_v_a, flashingWater.port_v_b) annotation (Line(points={{-190,-40.2},
          {-190,0},{-197,0},{-197,11}}, color={0,127,255}));
  connect(abs.port_v_a, flashingLiBr.port_v_b) annotation (Line(points={{93,-79},
          {155,-79},{155,-29}}, color={0,127,255}));
  connect(pump_abstogen.port_l_b, hex.port_a1)
    annotation (Line(points={{30,-93},{30,-26}}, color={0,127,255}));
  connect(pump_abstogen.port_l_a, abs.port_l_b) annotation (Line(points={{30,-111},
          {30,-118},{79,-118},{79,-91}}, color={0,127,255}));
  connect(pipe_abs.port_a, port_abs_a) annotation (Line(points={{186,-184},{206,
          -184},{206,-190},{230,-190}}, color={0,127,255}));
  connect(pipe_gen.port_a, port_gen_a)
    annotation (Line(points={{114,210},{168,210}}, color={0,127,255}));
  connect(pipe_con.port_a, port_con_a)
    annotation (Line(points={{-178,242},{-156,242},{-156,228},{-150,228},{-150,
          210}},                                     color={0,127,255}));
  connect(port_con_b, pipe_con.port_b)
    annotation (Line(points={{-230,210},{-204,210},{-204,242},{-198,242}},
                                                     color={0,127,255}));
  connect(port_eva_b, pipe_eva.port_b) annotation (Line(points={{-250,-190},{
          -226,-190},{-226,-186},{-222,-186}},
                                          color={0,127,255}));
  connect(pipe_eva.port_a, port_eva_a) annotation (Line(points={{-202,-186},{
          -186,-186},{-186,-190},{-170,-190}},
                                          color={0,127,255}));
  connect(pipe_abs.port_b, hex_abs.port_a1) annotation (Line(points={{166,-184},
          {152,-184},{152,-116},{172,-116},{172,-102}}, color={0,127,255}));
  connect(hex_abs.port_b1, port_abs_b) annotation (Line(points={{172,-82},{144,
          -82},{144,-190},{110,-190}}, color={0,127,255}));
  connect(flashingLiBr.port_l_b, hex_abs.port_a2) annotation (Line(points={{
          145.2,-29},{145.2,-42},{184,-42},{184,-82}}, color={0,127,255}));
  connect(hex_abs.port_b2, abs.port_l_a) annotation (Line(points={{184,-102},{
          184,-108},{202,-108},{202,-70},{134,-70},{134,-86},{93,-86},{93,-85}},
        color={0,127,255}));
  connect(hex_gen.port_a2, hex.port_b1) annotation (Line(points={{50,134},{50,
          40},{30,40},{30,-6}}, color={0,127,255}));
  connect(hex_gen.port_b2, gen.port_l_a) annotation (Line(points={{50,154},{50,
          168},{64,168},{64,85},{83,85}}, color={0,127,255}));
  connect(pipe_gen.port_b, hex_gen.port_a1) annotation (Line(points={{94,210},{
          88,210},{88,186},{46,186},{46,154},{38,154}}, color={0,127,255}));
  connect(hex_gen.port_b1, port_gen_b) annotation (Line(points={{38,134},{38,
          128},{22,128},{22,202},{50,202},{50,210}}, color={0,127,255}));
  connect(thermalConductor_con_heatlosses.port_b, fixedTemperature_con.port)
    annotation (Line(points={{-234,117},{-220,117},{-220,118},{-204,118}},
        color={191,0,0}));
  connect(thermalConductor_eva_heatlosses.port_b, fixedTemperature_eva.port)
    annotation (Line(points={{-282,-16},{-254,-16}}, color={191,0,0}));
  connect(thermalConductor_abs_heatlosses.port_b, fixedTemperature_abs.port)
    annotation (Line(points={{0,-168},{28,-168}}, color={191,0,0}));
  connect(hex.port_b2, flashingLiBr.port_a) annotation (Line(points={{42,-26},{42,
          -34},{100,-34},{100,0},{150,0},{150,-11}}, color={0,127,255}));
  connect(thermalCollector_abs.port_a, convection.solid) annotation (Line(
        points={{66,-148},{100,-148}},                     color={191,0,0}));
  connect(convection.fluid, heatCapacitor_abs.port) annotation (Line(points={{
          120,-148},{142,-148},{142,-150},{158,-150},{158,-140},{170,-140}},
        color={191,0,0}));
  connect(replicatorabs.y, convection.Gc) annotation (Line(points={{123,-224},{138,
          -224},{138,-120},{112,-120},{112,-138},{110,-138}}, color={0,0,127}));
  connect(replicatorabs.y, convection1.Gc) annotation (Line(points={{123,-224},{
          148,-224},{148,-222},{256,-222},{256,-134},{210,-134}}, color={0,0,127}));
  connect(heatCapacitor_abs.port, convection1.solid) annotation (Line(points={{
          170,-140},{170,-144},{200,-144}}, color={191,0,0}));
  connect(pipe_con.heatPorts, convection2.fluid) annotation (Line(points={{-188.1,
          246.4},{-188.1,260},{-248,260},{-248,188},{-196,188},{-196,170},{-182,
          170}},                                  color={127,0,0}));
  connect(convection2.solid, heatCapacitor_con.port) annotation (Line(points={{-162,
          170},{-122,170},{-122,180}},      color={191,0,0}));
  connect(replicatorcon.y, convection2.Gc) annotation (Line(points={{-239,170},{
          -224,170},{-224,150},{-172,150},{-172,160}}, color={0,0,127}));
  connect(heatCapacitor_con.port, convection3.fluid) annotation (Line(points={{-122,
          180},{-122,168},{-98,168}},       color={191,0,0}));
  connect(convection3.solid, thermalCollector_con.port_a)
    annotation (Line(points={{-78,168},{-56,168},{-56,150}}, color={191,0,0}));
  connect(replicatorcon.y, convection3.Gc) annotation (Line(points={{-239,170},
          {-224,170},{-224,150},{-88,150},{-88,158}},color={0,0,127}));
  connect(gen.heatPort, thermalConductor_gen_heatlosses.port_a)
    annotation (Line(points={{90,94},{124,94},{124,98},{166,98}},
                                                color={191,0,0}));
  connect(thermalCollector_gen.port_b, gen.heatPort)
    annotation (Line(points={{128,128},{128,94},{90,94}}, color={191,0,0}));
  connect(con.heatPort, thermalCollector_con.port_b) annotation (Line(points={{-166,86},
          {-260,86},{-260,136},{-80,136},{-80,130},{-56,130}},  color={191,0,0}));
  connect(thermalCollector_eva.port_b, eva.heatPort) annotation (Line(points={{-160,
          -98},{-160,-112},{-114,-112},{-114,-68},{-190,-68},{-190,-50}},
                                                                    color={191,
          0,0}));
  connect(thermalConductor_eva_heatlosses.port_a, eva.heatPort) annotation (
      Line(points={{-302,-16},{-326,-16},{-326,-50},{-190,-50}}, color={191,0,0}));
  connect(thermalConductor_abs_heatlosses.port_a, abs.heatPort) annotation (
      Line(points={{-20,-168},{-38,-168},{-38,-82},{84,-82}}, color={191,0,0}));
  connect(thermalCollector_abs.port_b, abs.heatPort) annotation (Line(points={{66,-128},
          {66,-82},{84,-82}},                              color={191,0,0}));
  connect(thermalConductor_con_heatlosses.port_a, con.heatPort) annotation (
      Line(points={{-252,117},{-260,117},{-260,86},{-166,86}}, color={191,0,0}));
  connect(fixedTemperature.port, thermalConductor_gen_heatlosses.port_b)
    annotation (Line(points={{220,98},{186,98}}, color={191,0,0}));
  connect(prescribedHeatFlow_radcon.port, con.heatPort) annotation (Line(points={{-226,70},
          {-204,70},{-204,86},{-166,86}},             color={191,0,0}));
  connect(Qrad_con.y, prescribedHeatFlow_radcon.Q_flow)
    annotation (Line(points={{-267,70},{-246,70}}, color={0,0,127}));
  connect(Qrad_eva.y, prescribedHeatFlow_radeva.Q_flow)
    annotation (Line(points={{-319,-82},{-296,-82}}, color={0,0,127}));
  connect(prescribedHeatFlow_radeva.port, eva.heatPort) annotation (Line(points={{-276,
          -82},{-262,-82},{-262,-50},{-190,-50}},       color={191,0,0}));
  connect(Qrad_abs.y, prescribedHeatFlow_radabs.Q_flow)
    annotation (Line(points={{-53,-26},{-28,-26}}, color={0,0,127}));
  connect(prescribedHeatFlow_radabs.port, abs.heatPort) annotation (Line(points={{-8,-26},
          {-8,-46},{84,-46},{84,-82}},          color={191,0,0}));
  connect(Qrad_gen.y, prescribedHeatFlow_radgen.Q_flow)
    annotation (Line(points={{-13,82},{10,82}}, color={0,0,127}));
  connect(prescribedHeatFlow_radgen.port, gen.heatPort)
    annotation (Line(points={{30,82},{90,82},{90,94}}, color={191,0,0}));
  connect(pump_abstogen.m_dot_in, m_flow_sol) annotation (Line(points={{20,-102},
          {2,-102},{2,-58},{214,-58},{214,-30},{260,-30}}, color={0,0,127}));
  connect(flashingWater_opening, flashingWater.opening)
    annotation (Line(points={{-298,20},{-212,20}}, color={0,0,127}));
  connect(const.y, flashingLiBr.opening) annotation (Line(points={{137,22},{128,
          22},{128,24},{122,24},{122,-20},{140,-20}}, color={0,0,127}));
  connect(hex.port_a2, pump_gentoabs.port_l_b) annotation (Line(points={{42,-6},
          {40,-6},{40,8},{86,8},{86,35},{88,35}}, color={0,127,255}));
  connect(pump_gentoabs.port_l_a, gen.port_l_b) annotation (Line(points={{88,53},
          {86,53},{86,66},{97,66},{97,85}}, color={0,127,255}));
  connect(pump_gentoabs.m_dot_in, flashingLiBr_opening) annotation (Line(points
        ={{98,44},{228,44},{228,50},{260,50}}, color={0,0,127}));
  connect(pipe_eva.heatPorts, convection4.fluid) annotation (Line(points={{-212.1,
          -181.6},{-212.1,-170},{-194,-170},{-194,-160},{-196,-160}}, color={127,
          0,0}));
  connect(convection5.solid, thermalCollector_eva.port_a) annotation (Line(
        points={{-194,-86},{-194,-78},{-160,-78}}, color={191,0,0}));
  connect(convection5.fluid, heatCapacitor_eva.port) annotation (Line(points={{-194,
          -106},{-196,-106},{-196,-114},{-226,-114},{-226,-88}}, color={191,0,0}));
  connect(heatCapacitor_eva.port, convection4.solid) annotation (Line(points={{-226,
          -88},{-226,-122},{-196,-122},{-196,-140}}, color={191,0,0}));
  connect(thermalCollector_gen.port_a, convection7.solid)
    annotation (Line(points={{128,148},{128,176},{138,176}}, color={191,0,0}));
  connect(convection7.fluid, heatCapacitor_gen.port)
    annotation (Line(points={{158,176},{168,176},{168,126}}, color={191,0,0}));
  connect(heatCapacitor_gen.port, convection6.solid) annotation (Line(points={{168,
          126},{170,126},{170,172},{196,172}}, color={191,0,0}));
  connect(convection6.fluid, pipe_gen.heatPorts) annotation (Line(points={{216,172},
          {234,172},{234,200},{103.9,200},{103.9,205.6}}, color={191,0,0}));
  connect(convection4.Gc, replicatoreva.y)
    annotation (Line(points={{-186,-150},{-161,-150}}, color={0,0,127}));
  connect(convection6.Gc, replicatorgen.y) annotation (Line(points={{206,182},{208,
          182},{208,214},{239,214}}, color={0,0,127}));
  connect(convection7.Gc, replicatorgen.y) annotation (Line(points={{148,186},{148,
          192},{218,192},{218,216},{239,216},{239,214}}, color={0,0,127}));
  connect(convection5.Gc, replicatoreva.y) annotation (Line(points={{-184,-96},{
          -178,-96},{-178,-150},{-161,-150}}, color={0,0,127}));
  connect(pipe_abs.heatPorts, convection1.fluid) annotation (Line(points={{
          175.9,-188.4},{175.9,-210},{200,-210},{200,-170},{226,-170},{226,-144},
          {220,-144}}, color={127,0,0}));
  connect(replicatoreva.u, UAeva.y) annotation (Line(points={{-138,-150},{-132,
          -150},{-132,-221},{-116.3,-221}}, color={0,0,127}));
  connect(replicatorgen.u, UAgen.y)
    annotation (Line(points={{262,214},{262,134},{287,134}}, color={0,0,127}));
  connect(UAabs.y, replicatorabs.u) annotation (Line(points={{65,-222},{65,-224},
          {100,-224}}, color={0,0,127}));
  connect(UAcon.y, replicatorcon.u) annotation (Line(points={{-339,190},{-324,
          190},{-324,192},{-312,192},{-312,170},{-262,170}}, color={0,0,127}));
  connect(eva.port_v, compressorEA.port_v_a) annotation (Line(points={{-180.8,
          -50},{-126,-50},{-126,-58},{-79,-58}}, color={0,127,255}));
  connect(compressorEA.port_v_b, abs.port_v) annotation (Line(points={{-61,-58},
          {-20,-58},{-20,-75},{75,-75}}, color={0,127,255}));
  connect(con.port_v, gen.port_v) annotation (Line(points={{-166,96},{-166,114},
          {90,114},{90,104}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,-200},
            {260,220}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-300,-200},{260,220}})));
end AHP_pump_hex_extended_compressorLowP;
