within Absolut.FluidBased.Static.Components;
model PumpW

    replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph;

 // Start values...

//PORTS
  Modelica.Fluid.Interfaces.FluidPort_a port_l_a(redeclare package Medium =
        Medium_l) "Fluid port." annotation (Placement(transformation(extent={{-10,
            -100},{10,-80}}), iconTransformation(extent={{-10,-100},{10,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_l_b(redeclare package Medium =
        Medium_l) "Fluid port. " annotation (Placement(transformation(extent={{-10,
            80},{10,100}}), iconTransformation(extent={{-10,80},{10,100}})));

    // Main variables

  Modelica.Units.SI.EnergyFlowRate W_p
    "Pump work to the fluid based on pressure difference";
  Modelica.Units.SI.EnergyFlowRate W_el "Pump work to the fluid";
  Modelica.Units.SI.SpecificEnthalpy dh "Contribution of Work";
  Modelica.Units.SI.SpecificVolume v_low_p
    "Specific volume at low pressure level";
  Modelica.Units.SI.Density rho_low "Density at low pressure level";
  parameter Real etha = 0.75 "Pump efficiency";

  Modelica.Units.SI.Temperature T "Inflow temperature";
  Modelica.Units.SI.Temperature T_out "Outflow temperature";
  parameter Boolean use_m_dot_in= true "true to use mass flow rate input signal";
  Modelica.Blocks.Interfaces.RealInput m_dot_in( unit="kg/s") if use_m_dot_in
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Units.SI.SpecificEnthalpy h_in "Check inflow enthalpy";

  Modelica.Blocks.Math.Gain m_dot_internal(k=1)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

    Real balance = port_l_a.m_flow*inStream(port_l_a.h_outflow) + port_l_b.m_flow * port_l_b.h_outflow + W_dh;
  Modelica.Units.SI.EnergyFlowRate W_dh=dh*port_l_a.m_flow
    "Power into fluid based on dh";

equation
  // Mass balance
  port_l_a.m_flow + port_l_b.m_flow = 0;
  port_l_a.m_flow = m_dot_internal.y;

  T_out = Medium_l.temperature_ph(port_l_b.p,port_l_b.h_outflow);
  T = Medium_l.temperature_ph(port_l_a.p,inStream(port_l_a.h_outflow));
  v_low_p = 1/Medium_l.density(Medium_l.setState_pTX(port_l_a.p,T,inStream(port_l_a.Xi_outflow)));
  rho_low = Medium_l.density(Medium_l.setState_pTX(port_l_a.p,T,inStream(port_l_a.Xi_outflow)));
  // Energy definitions...
  W_p = (port_l_b.p - port_l_a.p)*v_low_p*port_l_a.m_flow;
  W_el = W_p/etha;
  port_l_b.Xi_outflow = inStream(port_l_a.Xi_outflow);
  port_l_a.Xi_outflow = inStream(port_l_b.Xi_outflow);
  h_in = inStream(port_l_a.h_outflow);
  dh = if noEvent(port_l_a.m_flow > 0) then W_p/port_l_a.m_flow else 0;
  port_l_b.h_outflow = inStream(port_l_a.h_outflow) + dh;

  port_l_a.h_outflow = inStream(port_l_b.h_outflow);

  connect(m_dot_in, m_dot_internal.u)
    annotation (Line(points={{-100,0},{-22,0}}, color={0,0,127}));
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-60,-100},{-60,-60},{-60,20},{-60,100},{60,100},{60,60},{60,-56},
              {60,-100},{-60,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
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
          textString="pump")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>The pump model calculates the necessary work to rise the pressure of an specific mass flow rate </p>
<p><span style=\"font-family: Courier New;\">W&nbsp;=&nbsp;pressure rise * specific volume * mass flow rate / pump efficiency</span></p>
<p>The work is added to the fluid as enthalpy increase.</p>
<p>Specific volume is calculated using conditions at the inlet.</p>
<p>The main input signal use to set the mass flow rate can be deactivated to obtain an undeterminated model by setting <span style=\"font-family: Courier New;\">use_m_dot_in=false</span>. In this case, the mass flow rate is assumed to be set in another part of the model.</p>
</html>", revisions=""));
end PumpW;
