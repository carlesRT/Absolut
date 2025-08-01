within Absolut.FluidBased.Static.Resorption;
model AbsorberStatic_wHT_UAfix_Resorption_ext
  "Absorber with heat Transfer. Includes an adiabatic section (points 4, 19 and 20) and a cooled section."

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2pT;
    replaceable package Medium_l = Absolut.Media.LiBrH2O;
    replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1pT
    annotation (__Dymola_choicesAllMatching=true);

 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=Medium_l.temperature_Xp(1 -
      X_LiBr_start, p_start) "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.MassFraction X_LiBr_start
    "Water content in solution" annotation (Dialog(tab="Initialization"));

//PORTS
Modelica.Fluid.Interfaces.FluidPort_a port_v(redeclare package Medium = Medium_v)
    "Fluid port. Water vapor"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}}),iconTransformation(extent={{-100,60},
            {-80,80}})));
Modelica.Fluid.Interfaces.FluidPort_b port_l_b(redeclare package Medium = Medium_l)
    "Fluid port" annotation (Placement(transformation(extent={{-60,-100},{-40,-80}}),
        iconTransformation(extent={{-60,-100},{-40,-80}})));
Modelica.Fluid.Interfaces.FluidPort_a port_l_a(redeclare package Medium = Medium_l)
    "Fluid port" annotation (Placement(transformation(extent={{80,-40},{100,-20}}),
        iconTransformation(extent={{80,-40},{100,-20}})));

// Main variables

  Modelica.Units.SI.Temperature T(start=T_start)
    "Liquid-vapor equilibrium temperature in the vessel";

  Modelica.Units.SI.MassFraction X_H2O(start=1 - X_LiBr_start)
    "Water content in solution";

// Internal ...
  Modelica.Units.SI.AbsolutePressure p(start=p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W") "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{80,-100},{100,-80}}), iconTransformation(extent={{-100,
            -60},{-80,-40}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{20,-100},{40,-80}}), iconTransformation(extent={{-100,
            -80},{-80,-60}})));

  Modelica.Units.SI.Temperature T_19;
  Modelica.Units.SI.Temperature T_13;
  Modelica.Units.SI.Temperature T_14(start=273.15 + 50)
    "Inflow and leaving temperaure of external fluid";
  Modelica.Units.SI.Temperature T_6
    "Solution temperature of entering solution 6";

  extends Absolut.FluidBased.Static.BaseClasses.MTD;
  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001) = 1800 "in W/K";

 Real balance = (port_l_b.m_flow * (port_l_b.h_outflow) + port_l_a.m_flow * inStream(port_l_a.h_outflow))
 + (port_v.m_flow * inStream(port_v.h_outflow))
 + (port_b_ext.m_flow * (port_b_ext.h_outflow) + port_a_ext.m_flow * inStream(port_a_ext.h_outflow));

 Real balance_mass = port_l_b.m_flow + port_l_a.m_flow + port_v.m_flow + port_b_ext.m_flow + port_a_ext.m_flow;

  Modelica.Units.SI.MassFlowRate m20;
  Modelica.Units.SI.MassFlowRate m19;
  Modelica.Units.SI.MassFraction X_LiBr20(start=X_LiBr_start - 0.01);
  Modelica.Units.SI.MassFraction X_LiBr(start=X_LiBr_start);
  Modelica.Units.SI.MassFraction X_LiBr_l_a;
  Modelica.Units.SI.SpecificEnthalpy h20;
  Modelica.Units.SI.SpecificEnthalpy h19;
  Modelica.Units.SI.SpecificEnthalpy h_l_a;

equation
  // Adiabatic sections
  m20 = m19 + port_l_a.m_flow;
  m20*X_LiBr20 = port_l_a.m_flow*(1 - inStream(port_l_a.Xi_outflow)*{1});
  m20 * h20 = port_l_a.m_flow*inStream(port_l_a.h_outflow) + m19*h19;
  h_l_a = inStream(port_l_a.h_outflow);
  X_LiBr_l_a = 1 - inStream(port_l_a.Xi_outflow)*{1};

  port_l_b.m_flow + port_l_a.m_flow + port_v.m_flow = 0;

  // h19 and h20 are suppose to be known?
 // "As the outlet state is assumed saturated, the pressure (which is assumed to be known) and the mass fraction
 //  are sufficient to define the state, and the enthalpy and temperature can be determined
 //  from these two."
 h19 = inStream(port_v.h_outflow);
 T_19 = Medium_v.temperature_ph(p,inStream(port_v.h_outflow));
 h20 = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p,Medium_l.temperature_Xp(1-X_LiBr20,p),{1-X_LiBr20}));

  // Mass balance
  X_H2O = 1 - X_LiBr;
 // port_l_a.m_flow + port_l_b.m_flow + port_v.m_flow  = 0;

  T = Medium_l.temperature_Xp(1-X_LiBr,p);
  T_6 = Medium_l.temperature_hXp(h20, 1 - X_LiBr20,p);

  // Port pressures,
  port_v.p = p;
  port_l_b.p = p;
  port_l_a.p = p;

  //No pressure drop trough HX.
  port_a_ext.p = port_b_ext.p;
  port_a_ext.m_flow + port_b_ext.m_flow = 0;

  // Energy definitions...
  port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1}));
  port_l_b.h_outflow = Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    {X_H2O}));

  port_l_a.h_outflow =  Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    inStream(port_l_a.Xi_outflow)));

  port_b_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_14,
    {1}));
  port_a_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_13,
    {1}));

  port_l_a.Xi_outflow = {X_H2O};
  port_l_b.Xi_outflow = {X_H2O};

  Hb_flow = port_l_b.m_flow*actualStream(port_l_b.h_outflow) + (port_v.m_flow - m19)*h19 + m20*h20;

  T_13 = Medium_ext.temperature(Medium_ext.setState_phX(port_a_ext.p, inStream(port_a_ext.h_outflow), {1}));
  dT1 = T_6 - T_14;
  dT2 = T - T_13;


  Hb_flow = UA*dT_used;
  Hb_flow = port_a_ext.m_flow * (port_b_ext.h_outflow - inStream(port_a_ext.h_outflow));

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
          textString="abs")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model of a simple <b>evaporator (or condenser)</b> with two states where water is the evaporating or condensing medium. The model assumes two-phase equilibrium inside the component, i.e. the vapor (liquid) that exits the evaporator (condenser) is at saturated state. The flow properties are computed from the upstream quantities, pressures are equal in all nodes. Heat transfer through a thermal port is possible, it equals zero if the port remains unconnected. Ideal heat transfer is assumed per default; the thermal port temperature is equal to the medium temperature.</p>
</html>", revisions=""));
end AbsorberStatic_wHT_UAfix_Resorption_ext;
