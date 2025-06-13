within Absolut.FluidBased.Dynamic.Components;
model CondenserDyn_internalHEX "Condenser with heat Transfer"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph;
    replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph;
    replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);

 parameter Boolean m_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));
 parameter Boolean U_state = false "use U as a state" annotation(Dialog(tab="Advanced"));
 parameter Boolean p_state = false "use p as a state" annotation(Dialog(tab="Advanced"));

 // Start  values...
  parameter Modelica.Units.SI.AbsolutePressure p_start = Medium_l.saturationPressure(T_start)
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=
      Medium_l.saturationTemperature(p_start)
    "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));

//PORTS
  Modelica.Fluid.Interfaces.FluidPort_a port_v(redeclare package Medium = Medium_v)
    "Fluid port. Water vapor"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_l(redeclare package Medium = Medium_l)
    "Fluid port. Liquid water"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));

    // Main variables

  Modelica.Units.SI.AbsolutePressure p(stateSelect = if p_state then StateSelect.always else StateSelect.prefer,  start=p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T(start=T_start)
    "Liquid-vapor equilibrium temperature in the vessel";
  //Modelica.Units.SI.Temperature T_7 "Entering vapor temperature";

  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001) = 1200;

  Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W") "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

      // Tank geometry
  parameter Modelica.Units.SI.Height height = 0.1 "Height of vessel";
  parameter Modelica.Units.SI.Area crossArea = 0.5 "Area of vessel";
  final parameter Modelica.Units.SI.Volume V = height*crossArea "Volume of vessel";

  parameter Modelica.Units.SI.Volume V_l_start(min=0, max=V) = 0.5*V
  "Initial volume of the liquid medium"
    annotation(Dialog(tab = "Initialization"));

  Modelica.Units.SI.Volume V_l(min=0, max=V, start= V_l_start) "Liquid volume of the vessel";
  Modelica.Units.SI.Volume V_v(min=0, max=V, start= V-V_l_start) "Vapor volume of the vessel";
  Modelica.Units.SI.Height level "Level of liquid in the vessel";

  Modelica.Units.SI.Mass m(stateSelect = if m_state then StateSelect.always else StateSelect.prefer, start = V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start)) + (V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))) "Mass in the vessel";
  Modelica.Units.SI.Mass m_l "Liquid mass of the vessel";
  Modelica.Units.SI.Mass m_v "Vapor mass in the vessel";
  Modelica.Units.SI.MassFlowRate mb_flow;

  Modelica.Units.SI.InternalEnergy U(stateSelect = if U_state then StateSelect.always else StateSelect.prefer, start=V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start))*Medium_l.specificInternalEnergy(Medium_l.setState_pTX(p_start, T_start, X_l_start)) +(V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))*Medium_v.specificInternalEnergy(Medium_v.setState_pTX(p_start, T_start, X_v_start)))
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
    Xi(start=X_l_start[1:Medium_l.nXi], each stateSelect = StateSelect.prefer),
    h(start=Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_start, T_start, X_l_start))))
    "Liquid medium";

// , stateSelect = StateSelect.prefer
// , stateSelect = StateSelect.prefer

   // Initialization
  parameter Modelica.Units.SI.MassFraction X_v_start[Medium_v.nX] = Medium_v.X_default
  "Initial X of vapor medium"
    annotation (Dialog(tab="Initialization", enable=Medium_l.nXi > 0));
  parameter Modelica.Units.SI.MassFraction X_l_start[Medium_l.nX] = Medium_l.X_default
  "Initial X of liquid medium"
    annotation (Dialog(tab="Initialization", enable=Medium_l.nXi > 0));

  Modelica.Fluid.Interfaces.FluidPort_b port_b_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{-100,20},{-80,40}}), iconTransformation(extent={{60,-100},
            {80,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{-100,-40},{-80,-20}}),iconTransformation(extent={{80,-80},
            {100,-60}})));

  Modelica.Units.SI.Temperature T_15( start=323.15);
  Modelica.Units.SI.Temperature T_16( start=333.15)
    "Temperature of entering and leaving external fluid";
  extends Absolut.FluidBased.Static.BaseClasses.MTD;


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
  port_v.m_flow + port_l.m_flow = mb_flow;

  der(m) = mb_flow;

  //der(U) = Hb_flow + Qb_flow;
  der(m_l)*medium_l.u + m_l*der(medium_l.u) + der(m_v)*medium_v.u + m_v*der(medium_v.u)= Hb_flow + Qb_flow;

  // Liquid-vapor equilibrium pressure
  //p = Medium_l.saturationPressure(T);
  T = Medium_l.saturationTemperature(p);

  // Port pressures
  port_v.p = p;
  port_l.p = p;

  // Energy definitions...
  port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1}));
  port_l.h_outflow = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p,T,{1}));

  Hb_flow = port_v.m_flow*actualStream(port_v.h_outflow) + port_l.m_flow*actualStream(port_l.h_outflow);

  port_v.Xi_outflow = medium_v.Xi;
  port_l.Xi_outflow = medium_l.Xi;

  // force outlet temperature...
  port_b_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_16,
    {1}));
  T_15 = Medium_ext.temperature(Medium_ext.setState_phX(port_a_ext.p, inStream(port_a_ext.h_outflow), {1}));
  port_a_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_15,
    {1}));

    //No pressure drop trough HX.
  port_a_ext.p = port_b_ext.p;
  port_a_ext.m_flow + port_b_ext.m_flow = 0;


  dT1 = T - T_15;
  dT2 = T - T_16;
  Qb_flow = -UA*dT_used;
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
          textString="con")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model of a simple <b>evaporator (or condenser)</b> with two states where water is the evaporating or condensing medium. The model assumes two-phase equilibrium inside the component, i.e. the vapor (liquid) that exits the evaporator (condenser) is at saturated state. The flow properties are computed from the upstream quantities, pressures are equal in all nodes. Heat transfer through a thermal port is possible, it equals zero if the port remains unconnected. Ideal heat transfer is assumed per default; the thermal port temperature is equal to the medium temperature.</p>
</html>", revisions=""),
    experiment(
      StartTime=20916000,
      StopTime=31536000,
      Interval=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end CondenserDyn_internalHEX;
