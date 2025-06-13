within Absolut.FluidBased.Static.TypeII;
model GeneratorStatic_wHT_UAfix_TypeII "Generator with heat Transfer"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph;
    replaceable package Medium_l = Absolut.Media.LiBrH2O;
    replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start=8000
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=Medium_l.temperature_Xp(1 -
      X_LiBr_start, p_start) "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));

//PORTS
  Modelica.Fluid.Interfaces.FluidPort_b port_v(redeclare package Medium = Medium_v)
    "Fluid port. Water vapor"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_l_b(redeclare package Medium = Medium_l)
    "Fluid port" annotation (Placement(transformation(extent={{60,-100},{80,-80}}),
        iconTransformation(extent={{60,-100},{80,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_l_a(redeclare package Medium = Medium_l)
    "Fluid port" annotation (Placement(transformation(extent={{-80,-100},{-60,-80}}),
        iconTransformation(extent={{-80,-100},{-60,-80}})));
    // Main variables

  Modelica.Units.SI.AbsolutePressure p( start = p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T1and2;
  Modelica.Units.SI.Temperature T( start = T_start)
    "Liquid-vapor equilibrium temperature in the vessel";

  Modelica.Units.SI.SpecificEnthalpy h_v_out;
  Modelica.Units.SI.SpecificEnthalpy h_l_out;
  Modelica.Units.SI.SpecificEnthalpy h_in;

  parameter Modelica.Units.SI.MassFraction X_LiBr_start=0.6;
  Modelica.Units.SI.MassFraction X_H2O;
  Modelica.Units.SI.MassFraction X_LiBr(start=X_LiBr_start);
  Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXi_flow_l_a;
  Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXi_flow_l_b;
    Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W")
    "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{80,80},{100,100}}),  iconTransformation(extent={{80,60},
            {100,80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{80,40},{100,60}}),    iconTransformation(extent={{60,80},
            {80,100}})));

  extends Absolut.FluidBased.Static.BaseClasses.MTD;
  Modelica.Units.SI.Temperature T_13(start=237.15 + 130);
  Modelica.Units.SI.Temperature T_14(start=363.15)
    "External fluid temperatures. Entering (11) and leaving (12)";
  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001)
    "UA value of HX in W/K";

   Real balance = (port_l_b.m_flow * (port_l_b.h_outflow) + port_l_a.m_flow * inStream(port_l_a.h_outflow))
 + port_v.m_flow * (port_v.h_outflow)
 + (port_b_ext.m_flow * (port_b_ext.h_outflow) + port_a_ext.m_flow * inStream(port_a_ext.h_outflow));

  Modelica.Fluid.Interfaces.FluidPort_a port_v_a(redeclare package Medium =
        Medium_v) "Fluid port" annotation (Placement(transformation(extent={{-100,
            -60},{-80,-40}}), iconTransformation(extent={{-110,-22},{-90,-2}})));
equation
  // Mass balance
  X_H2O = 1 - X_LiBr;
  port_v.m_flow + port_l_b.m_flow + port_l_a.m_flow + port_v_a.m_flow = 0;

  mXi_flow_l_a = port_l_a.m_flow * inStream(port_l_a.Xi_outflow);
  mXi_flow_l_b = port_l_b.m_flow*{X_H2O};
  port_v.m_flow*{1} +  port_v_a.m_flow*{1} +  mXi_flow_l_a + mXi_flow_l_b = zeros(Medium_l.nXi);

  // Liquid-vapor equilibrium pressure
  //T = Medium_l.temperature_Xp(X_H2O,p);
  0 = Modelica.Media.Water.WaterIF97_ph.specificGibbsEnergy(Modelica.Media.Water.WaterIF97_ph.setState_pTX(p=p, T=T, X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(T,X_H2O,p);

  T1and2 = Medium_l.temperature_Xp(inStream(port_l_a.Xi_outflow)*{1},p);

  // Port pressures
  port_v.p = p;
  port_l_b.p = p;
  port_l_a.p = p;
  port_v_a.p = p;

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
    T1and2,
    inStream(port_l_a.Xi_outflow)));
  port_v_a.h_outflow =  Medium_v.specificEnthalpy(Medium_v.setState_pTX(
    p,
    T1and2,
    inStream(port_v_a.Xi_outflow)));
  port_b_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_14,
    {1}));
  port_a_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_13,
    {1}));

  h_v_out = actualStream(port_v.h_outflow);
  h_in = actualStream(port_l_a.h_outflow);
  h_l_out = actualStream(port_l_b.h_outflow);

  port_l_a.Xi_outflow = {X_H2O};
  port_l_b.Xi_outflow = {X_H2O};

  Hb_flow = port_l_b.m_flow*actualStream(port_l_b.h_outflow) + port_v.m_flow*actualStream(port_v.h_outflow) + port_l_a.m_flow*actualStream(port_l_a.h_outflow)
  + port_v_a.m_flow*actualStream(port_v_a.h_outflow);

  T_13 = Medium_ext.temperature(Medium_ext.setState_phX(port_a_ext.p, inStream(port_a_ext.h_outflow), {1}));


  dT1 = T_13 - T;
  dT2 = T_14 - T1and2;
  -Hb_flow = UA*dT_used;
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
          textString="gen")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html></html>"));
end GeneratorStatic_wHT_UAfix_TypeII;
