within Absolut.FluidBased.Static.SingleEffect_intern;
model GeneratorStatic

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2pT;
    replaceable package Medium_l = Absolut.Media.LiBrH2O;

// Start values
  parameter Modelica.Units.SI.AbsolutePressure p_start= Medium_l.saturationPressure_TX(T_start,1 - X_LiBr_start)
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=Medium_l.temperature_Gen_Xp(1
       - X_LiBr_start, p_start) "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.MassFraction X_LiBr_start=0.6  "LiBr concentration at start"
    annotation (Dialog(tab="Initialization"));

// PORTS
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
  Modelica.Blocks.Interfaces.RealOutput p(start=p_start, unit="Pa")
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T1and2 "Temperature of the entering flow trhough port_l_a";
  Modelica.Units.SI.Temperature T(start=T_start)
    "Liquid-vapor equilibrium temperature in the vessel";
  Modelica.Units.SI.Temperature T_aux(start = Modelica.Media.Water.WaterIF97_ph.saturationTemperature(p_start))= Modelica.Media.Water.WaterIF97_ph.saturationTemperature(p)
    "Auxiliary temperature, for review/plotting purposes";

  Modelica.Units.SI.SpecificEnthalpy h_v_out;
  Modelica.Units.SI.SpecificEnthalpy h_l_out;
  Modelica.Units.SI.SpecificEnthalpy h_in;

  Modelica.Units.SI.MassFraction X_H2O(start=1-X_LiBr_start);
  Modelica.Blocks.Interfaces.RealOutput X_LiBr(unit="1", min = 0, max = 1, start=X_LiBr_start);
  Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXi_flow_l_a;
  Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXi_flow_l_b;
  Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W") "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

// Entropy
  Modelica.Units.SI.SpecificEntropy s_in "Specific entropy of entering mass at port_l_a";
  Modelica.Units.SI.SpecificEntropy s_out_v "Specific entropy of leaving mass at port_v";
  Modelica.Units.SI.SpecificEntropy s_out_l "Specific entropy of leaving mass at port_l_b";
  Modelica.Units.SI.EntropyFlowRate Delta_s "Entropy flow in J/(K.s): In - Out";

  parameter Boolean use_X_LiBr_in = false "Use prescribed input to set X_LiBr";
  parameter Boolean use_p_in = false "Use prescribed input to set pressure";

  Modelica.Blocks.Interfaces.RealInput X_LiBr_in if use_X_LiBr_in
                                                                 "X_LiBr content in vessel"
    annotation (Placement(transformation(extent={{120,70},{80,110}})));
  Modelica.Blocks.Interfaces.RealInput p_in(unit="Pa")  if use_p_in "Pressure of vessel"
    annotation (Placement(transformation(extent={{120,30},{80,70}})));
equation
  // Mass balance
  connect(X_LiBr,X_LiBr_in);
  connect(p, p_in);

  X_H2O = 1 - X_LiBr;
  port_v.m_flow + port_l_b.m_flow + port_l_a.m_flow = 0;

  mXi_flow_l_a = port_l_a.m_flow * inStream(port_l_a.Xi_outflow);
  mXi_flow_l_b = port_l_b.m_flow*{X_H2O};
  port_v.m_flow*{1} + mXi_flow_l_a + mXi_flow_l_b = zeros(Medium_l.nXi);

  T = Medium_l.temperature_Xp(X_H2O,p);
  T1and2 = Medium_l.temperature_Xp(inStream(port_l_a.Xi_outflow)*{1},p);

  // Pressures at ports
  port_v.p = p;
  port_l_b.p = p;
  port_l_a.p = p;

  // Energy eq...
  port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T1and2,{1}));
  port_l_b.h_outflow = Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    {X_H2O}));

  port_l_a.h_outflow =  Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    inStream(port_l_a.Xi_outflow)));

  h_v_out = actualStream(port_v.h_outflow);
  h_in = actualStream(port_l_a.h_outflow);
  h_l_out = actualStream(port_l_b.h_outflow);

  port_l_a.Xi_outflow = {X_H2O};
  port_l_b.Xi_outflow = {X_H2O};

Hb_flow = port_l_b.m_flow*actualStream(port_l_b.h_outflow) + port_v.m_flow*actualStream(port_v.h_outflow) + port_l_a.m_flow*actualStream(port_l_a.h_outflow);

// Entropy
s_in = Medium_l.specificEntropy(Medium_l.setState_phX(port_l_a.p, h_in,inStream(port_l_a.Xi_outflow)));
s_out_v = Medium_v.specificEntropy(Medium_v.setState_phX(port_v.p, h_v_out, {1}));
s_out_l = Medium_l.specificEntropy(Medium_l.setState_phX(port_l_b.p, h_l_out, {1-X_LiBr, X_LiBr}));
Delta_s = port_v.m_flow*s_out_v +  port_l_b.m_flow*s_out_l + port_l_a.m_flow*s_in;

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
    Documentation(info="<html>
</html>", revisions=""));
end GeneratorStatic;
