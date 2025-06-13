within Absolut.FluidBased.Static.SingleEffect_UAfixed;
model EvaporatorStatic_wHT_UAfix "Evaporator with heat Transfer"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2pT;
    replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1pT;
    replaceable package Medium_ext = Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);

 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start= Medium_l.saturationPressure(T_start)
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=
      Medium_l.saturationTemperature(p_start)
    "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));

  extends Absolut.FluidBased.Static.BaseClasses.MTD;


//PORTS
  Modelica.Fluid.Interfaces.FluidPort_a port_l_a(redeclare package Medium = Medium_l)
    "Fluid port. Water vapor" annotation (Placement(transformation(extent={{-100,-100},{-80,-80}}),
        iconTransformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_v(redeclare package Medium = Medium_v) "Fluid port"
    annotation (Placement(transformation(extent={{82,-10},{102,10}}),   iconTransformation(extent={{82,-10},
            {102,10}})));

    // Main variables

  Modelica.Units.SI.AbsolutePressure p( start = p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T( start = T_start)
    "Liquid-vapor equilibrium temperature in the vessel";
  Modelica.Units.SI.Temperature T_17(start=283.15);
  Modelica.Units.SI.Temperature T_18(start=280.15)
    "Inflow and outflow temperature of external fluid";
  parameter Modelica.Units.SI.ThermalConductance UA( min=0.0001)
    "UA value of HX in W/K";

  Modelica.Units.SI.SpecificEnthalpy h_out;
  Modelica.Units.SI.SpecificEnthalpy h_l_in;
  Modelica.Units.SI.SpecificEnthalpy h_v_in;
  Modelica.Units.SI.SpecificEnthalpy h_in "For checking purposes...";
  Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W") "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_v_a(redeclare package Medium = Medium_v)
    "Fluid port. Water vapor" annotation (Placement(transformation(extent={{-10,88},{10,108}}),
        iconTransformation(extent={{-10,88},{10,108}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{40,-100},{60,-80}}),  iconTransformation(extent={{40,-100},
            {60,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{0,-100},{20,-80}}),  iconTransformation(extent={{0,-100},
            {20,-80}})));

//Entropy
  Modelica.Units.SI.SpecificEntropy s_in_v;
  Modelica.Units.SI.SpecificEntropy s_in_l;
  Modelica.Units.SI.SpecificEntropy s_out;
  Modelica.Units.SI.EntropyFlowRate Delta_s;

equation

  // Mass balance
  port_l_a.m_flow + port_v_a.m_flow +port_v.m_flow  = 0;

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

  h_l_in =actualStream(port_l_a.h_outflow);
  h_v_in =actualStream(port_v_a.h_outflow);
  h_out = actualStream(port_v.h_outflow);
  (port_l_a.m_flow + port_v_a.m_flow)*h_in = port_l_a.m_flow*h_l_in + port_v_a.m_flow*h_v_in;

  Hb_flow =   (port_l_a.m_flow*actualStream(port_l_a.h_outflow) + port_v_a.m_flow*actualStream(port_v_a.h_outflow)) + port_v.m_flow *actualStream(port_v.h_outflow);

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
  -Hb_flow = UA * dT_used;
  Hb_flow = port_a_ext.m_flow * (port_b_ext.h_outflow - inStream(port_a_ext.h_outflow));

// Entropy
s_in_v = Medium_v.specificEntropy(Medium_v.setState_phX(port_v_a.p, h_v_in,{1}));
s_in_l = Medium_l.specificEntropy(Medium_l.setState_phX(port_l_a.p, h_l_in, {1}));
s_out = Medium_v.specificEntropy(Medium_v.setState_phX(port_v.p, h_out, {1}));
Delta_s = port_v.m_flow*s_out +  port_l_a.m_flow*s_in_l + port_v_a.m_flow*s_in_v;

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
end EvaporatorStatic_wHT_UAfix;
