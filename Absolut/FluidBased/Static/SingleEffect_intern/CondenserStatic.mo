within Absolut.FluidBased.Static.SingleEffect_intern;
model CondenserStatic

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2pT;
    replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1pT;

 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start=8000
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

  Modelica.Units.SI.AbsolutePressure p( start= p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T( start=T_start)
    "Liquid-vapor equilibrium temperature in the vessel";
  Modelica.Units.SI.Temperature T_in "Entering temperature port_v";

  Modelica.Units.SI.SpecificEnthalpy h_out;
  Modelica.Units.SI.SpecificEnthalpy h_in;

  Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W")
    "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Interfaces.RealOutput T_c(unit="K")= T "Condenser temperature"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));

//Entropy
  Modelica.Units.SI.SpecificEntropy s_in;
  Modelica.Units.SI.SpecificEntropy s_out;
  Modelica.Units.SI.EntropyFlowRate Delta_s "Entropy flow in J/(K.s): In - Out";

equation
// Mass balance
  port_v.m_flow + port_l.m_flow = 0;

// Liquid-vapor equilibrium pressure
//p = Medium_l.saturationPressure(T);
  T = Medium_l.saturationTemperature(p);

// Pressure at ports
  port_v.p = p;
  port_l.p = p;

// Energy definitions...
  port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1}));
  port_l.h_outflow = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p,T,{1}));
  h_in = actualStream(port_v.h_outflow);
  h_out = actualStream(port_l.h_outflow);

  Hb_flow = port_v.m_flow*actualStream(port_v.h_outflow) + port_l.m_flow*actualStream(port_l.h_outflow);

  T_in = Medium_v.temperature_ph(p,inStream(port_v.h_outflow));

// Entropy
s_in = Medium_v.specificEntropy(Medium_v.setState_phX(port_v.p, h_in,{1}));
s_out = Medium_l.specificEntropy(Medium_l.setState_phX(port_l.p, h_out,{1}));
Delta_s = port_l.m_flow*s_out + port_v.m_flow*s_in;

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
</html>", revisions=""));
end CondenserStatic;
