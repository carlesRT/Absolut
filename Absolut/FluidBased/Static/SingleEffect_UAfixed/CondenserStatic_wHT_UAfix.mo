within Absolut.FluidBased.Static.SingleEffect_UAfixed;
model CondenserStatic_wHT_UAfix "Condenser with heat Transfer"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph;
    replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph;
    replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1ph
    annotation (__Dymola_choicesAllMatching=true);
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

  Modelica.Units.SI.AbsolutePressure p(start=p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T(start=T_start)
    "Liquid-vapor equilibrium temperature in the vessel";
  Modelica.Units.SI.Temperature T_7 "Dummy value. (Entering vapor temperature...)";
  Modelica.Units.SI.Temperature T_15( start=323.15) "Temperature of entering external fluid";
  Modelica.Units.SI.Temperature T_16( start=333.15) "Temperature of leaving external fluid";
  extends Absolut.FluidBased.Static.BaseClasses.MTD;
  Modelica.Units.SI.SpecificEnthalpy h_out;
  Modelica.Units.SI.SpecificEnthalpy h_in;
  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001) = 1200;

  Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W") "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{-100,20},{-80,40}}), iconTransformation(extent={{60,-100},
            {80,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_ext(redeclare package Medium =
        Medium_ext) "Fluid port. External flow" annotation (Placement(
        transformation(extent={{-100,-40},{-80,-20}}),iconTransformation(extent={{80,-80},
            {100,-60}})));

   Real balance = (port_l.m_flow * (port_l.h_outflow) + port_v.m_flow * inStream(port_v.h_outflow))
 + (port_b_ext.m_flow * (port_b_ext.h_outflow) + port_a_ext.m_flow * inStream(port_a_ext.h_outflow));

//Entropy
  Modelica.Units.SI.SpecificEntropy s_in;
  Modelica.Units.SI.SpecificEntropy s_out;
  Modelica.Units.SI.EntropyFlowRate Delta_s;

equation

  // Mass balance
  port_v.m_flow + port_l.m_flow = 0;

  // Liquid-vapor equilibrium pressure
  //p = Medium_l.saturationPressure(T);
  T = Medium_l.saturationTemperature(p);
  //T_7 = Medium_l.temperature(Medium_l.setState_phX(p,inStream(port_v.h_outflow),{1}));
  T_7 = 400;
  // Port pressures
  port_v.p = p;
  port_l.p = p;

  //No pressure drop trough HX.
  port_a_ext.p = port_b_ext.p;
  port_a_ext.m_flow + port_b_ext.m_flow = 0;

  // Energy definitions...
  port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1}));
  port_l.h_outflow = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p,T,{1}));
  h_in = actualStream(port_v.h_outflow);
  h_out = actualStream(port_l.h_outflow);

  // force outlet temperature...
  port_b_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_16,
    {1}));
  port_a_ext.h_outflow = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX(
    port_a_ext.p,
    T_15,
    {1}));

  Hb_flow = port_v.m_flow*actualStream(port_v.h_outflow) + port_l.m_flow*actualStream(port_l.h_outflow);

  T_15 = Medium_ext.temperature(Medium_ext.setState_phX(port_a_ext.p, inStream(port_a_ext.h_outflow), {1}));
  //inStream(port_a_ext.h_outflow) = Medium_ext.specificEnthalpy(Medium_ext.setState_pTX( port_a_ext.p,    T_15,    {1}));

  dT1 = T - T_15;
  dT2 = T - T_16;

  Hb_flow = UA*dT_used;
  Hb_flow = port_a_ext.m_flow * (port_b_ext.h_outflow - inStream(port_a_ext.h_outflow));

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
<p>Model of a simple <b>evaporator (or condenser)</b> with two states where water is the evaporating or condensing medium. The model assumes two-phase equilibrium inside the component, i.e. the vapor (liquid) that exits the evaporator (condenser) is at saturated state. The flow properties are computed from the upstream quantities, pressures are equal in all nodes. Heat transfer through a thermal port is possible, it equals zero if the port remains unconnected. Ideal heat transfer is assumed per default; the thermal port temperature is equal to the medium temperature.</p>
</html>", revisions=""),
    experiment(
      StartTime=20916000,
      StopTime=31536000,
      Interval=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end CondenserStatic_wHT_UAfix;
