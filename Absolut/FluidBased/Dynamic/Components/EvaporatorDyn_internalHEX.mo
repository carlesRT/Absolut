within Absolut.FluidBased.Dynamic.Components;
model EvaporatorDyn_internalHEX "Evaporator with heat Transfer"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph;
    replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph;
        replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph annotation (__Dymola_choicesAllMatching=true);

 parameter Boolean m_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));
 parameter Boolean U_state = false "use U as a state" annotation(Dialog(tab="Advanced"));
 parameter Boolean p_state = false "use p as a state" annotation(Dialog(tab="Advanced"));

 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start= Medium_l.saturationPressure(T_start)
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=
      Medium_l.saturationTemperature(p_start)
    "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));

//PORTS
  Modelica.Fluid.Interfaces.FluidPort_a port_l_a(redeclare package Medium = Medium_l)
    "Fluid port. Water vapor" annotation (Placement(transformation(extent={{-100,-100},{-80,-80}}),
        iconTransformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_v(redeclare package Medium = Medium_v) "Fluid port"
    annotation (Placement(transformation(extent={{82,-10},{102,10}}),   iconTransformation(extent={{82,-10},
            {102,10}})));

    // Main variables

  Modelica.Units.SI.AbsolutePressure p(stateSelect = if p_state then StateSelect.always else StateSelect.prefer,  start = p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T(start = T_start)
    "Liquid-vapor equilibrium temperature in the vessel";
  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001)
    "UA value of HX in W/K";

   Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W") "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_v_a(redeclare package Medium = Medium_v)
    "Fluid port. Water vapor" annotation (Placement(transformation(extent={{-10,88},{10,108}}),
        iconTransformation(extent={{-10,88},{10,108}})));

      // Tank geometry
  parameter Modelica.Units.SI.Height height = 0.1 "Height of vessel";
  parameter Modelica.Units.SI.Area crossArea = 0.5 "Area of vessel";
  final parameter Modelica.Units.SI.Volume V = height*crossArea "Volume of vessel";

  parameter Modelica.Units.SI.Volume V_l_start(min=0, max=V) = 0.5*V
  "Initial volume of the liquid medium"
    annotation(Dialog(tab = "Initialization"));

  Modelica.Units.SI.Volume V_l(min=0, max=V, start=V_l_start) "Liquid volume of the vessel";
  Modelica.Units.SI.Volume V_v(min=0, max=V, start=V-V_l_start) "Vapor volume of the vessel";
  Modelica.Units.SI.Height level "Level of liquid in the vessel";

  Modelica.Units.SI.Mass m(stateSelect = if m_state then StateSelect.always else StateSelect.prefer, start = V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start)) + (V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))) "Mass in the vessel";
  Modelica.Units.SI.Mass m_l "Liquid mass of the vessel";
  Modelica.Units.SI.Mass m_v "Vapor mass in the vessel";
  Modelica.Units.SI.MassFlowRate mb_flow;

  Modelica.Units.SI.InternalEnergy U(stateSelect = if U_state then StateSelect.always else StateSelect.prefer,start=V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start))*Medium_l.specificInternalEnergy(Medium_l.setState_pTX(p_start, T_start, X_l_start)) +(V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))*Medium_v.specificInternalEnergy(Medium_v.setState_pTX(p_start, T_start, X_v_start)))
    "Internal energy";

  Modelica.Units.SI.HeatFlowRate Qb_flow
    "Heat flow across boundaries or energy source/sink";

  Medium_v.BaseProperties medium_v(
    p(start=p_start),
    T(start=T_start),
    Xi(start=X_v_start[1:Medium_v.nXi]),
    h(start=Medium_v.specificEnthalpy(Medium_v.setState_pTX(p_start, T_start, X_v_start))))
    "Vapor medium";
  Medium_l.BaseProperties medium_l(
    p(start=p_start),
    T(start=T_start),
    Xi(start=X_l_start[1:Medium_l.nXi]),
    h(start=Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_start, T_start, X_l_start))))
    "Liquid medium";

   // Initialization
  parameter Modelica.Units.SI.MassFraction X_v_start[Medium_v.nX] = Medium_v.X_default
  "Initial X of vapor medium"
    annotation (Dialog(tab="Initialization", enable=Medium_l.nXi > 0));
  parameter Modelica.Units.SI.MassFraction X_l_start[Medium_l.nX] = Medium_l.X_default
  "Initial X of liquid medium"
    annotation (Dialog(tab="Initialization", enable=Medium_l.nXi > 0));

  Modelica.Fluid.Interfaces.FluidPort_b port_b_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{0,-100},{20,-80}}),  iconTransformation(extent={{0,-100},
            {20,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{40,-100},{60,-80}}),  iconTransformation(extent={{40,-100},
            {60,-80}})));

  extends Absolut.FluidBased.Static.BaseClasses.MTD;
  Modelica.Units.SI.Temperature T_17(start=283.15);
  Modelica.Units.SI.Temperature T_18(start=280.15)
    "Inflow and outflow temperature of external fluid";
equation

  medium_l.p = p;
  medium_v.p = p;
  medium_l.T = T;
  medium_v.T = T;

  // Total quantities
  V_l = crossArea*level;
  V = V_l + V_v;
  m = m_l + m_v;
  m_l = V_l*medium_l.d;
  m_v = V_v*medium_v.d;
  U = m_l*medium_l.u + m_v*medium_v.u;

  // Mass balance
  port_l_a.m_flow + port_v_a.m_flow + port_v.m_flow  = mb_flow;

  der(m) = mb_flow;

  der(U) = Hb_flow + Qb_flow;
  //der(m_l)*medium_l.u + m_l*der(medium_l.u) + der(m_v)*medium_v.u + m_v*der(medium_v.u)= Hb_flow + Qb_flow;

  // Liquid-vapor equilibrium pressure
  //p = Medium_l.saturationPressure(T);
  T = Medium_l.saturationTemperature(p);
  // Port pressures
  port_l_a.p = p;
  port_v_a.p = p;
  port_v.p = p;

  // Energy definitions...
  port_l_a.h_outflow = Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    {1}));
  port_v_a.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(
    p,
    T,
    {1}));
  port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1}));

  Hb_flow =   (port_l_a.m_flow*actualStream(port_l_a.h_outflow) + port_v_a.m_flow*actualStream(port_v_a.h_outflow)) + port_v.m_flow *actualStream(port_v.h_outflow);

  port_v.Xi_outflow = medium_v.Xi;
  port_v_a.Xi_outflow = medium_v.Xi;
  port_l_a.Xi_outflow = medium_l.Xi;

  // Aditional for HX
  port_b_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_18,
    {1}));
  port_a_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_17,
    {1}));

  //No pressure drop trough HX.
  port_a_ext.p = port_b_ext.p;
  port_a_ext.m_flow + port_b_ext.m_flow = 0;

  T_17 = Medium_ext.temperature(Medium_ext.setState_phX(port_a_ext.p, inStream(port_a_ext.h_outflow), {1}));

  dT1 = T_17 - T;
  dT2 = T_18 - T;
  Qb_flow = UA * dT_used;
  Qb_flow = -port_a_ext.m_flow * (port_b_ext.h_outflow - inStream(port_a_ext.h_outflow));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-60,-100},{-100,-60},{-100,60},{-60,100},{60,100},{100,60},{100,-60},{60,-100},{-60,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,-20},{100,-20},{100,-60},{60,-100},{-60,-100},{-100,-60},{-100,-20}},
          lineColor={28,108,200},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-20},{100,-60}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          textString="static"),
        Text(
          extent={{-100,60},{100,20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          textString="evap")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html></html>"));
end EvaporatorDyn_internalHEX;
