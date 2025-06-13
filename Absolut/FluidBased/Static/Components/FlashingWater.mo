within Absolut.FluidBased.Static.Components;
model FlashingWater
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium_l) "Fluid port"
    annotation (Placement(transformation(extent={{-10,80},{10,100}}), iconTransformation(extent={{-10,80},
            {10,100}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_v_b(redeclare package Medium =
        Medium_v) "Fluid port. Vapor"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}}), iconTransformation(extent={{40,-100},
            {60,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_l_b(redeclare package Medium =
        Medium_l) "Fluid port. Liquid"
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}}),
                                                                       iconTransformation(extent={{-58,
            -100},{-38,-80}})));
  replaceable package Medium_l = Modelica.Media.Water.WaterIF97_R1ph "liquid"
    annotation (__Dymola_choicesAllMatching=true);
  replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph "vapor"
    annotation (__Dymola_choicesAllMatching=true);

  parameter Modelica.Units.SI.AbsolutePressure dp_nominal
    "Nominal pressure drop at full opening"
    annotation (Dialog(group="Nominal operating point"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flowrate at full opening";
  final parameter Modelica.Fluid.Types.HydraulicConductance k = m_flow_nominal/dp_nominal
    "Hydraulic conductance at full opening";

  parameter Boolean use_opening = true
                                      "true, to use opening input signal";
  Modelica.Blocks.Interfaces.RealInput opening if use_opening
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput Q "Quality defined as ratio vapour/liquid"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  Modelica.Units.SI.Temperature T_water_sat=Medium_v.saturationTemperature(
      port_l_b.p) "Corresponds to saturation temperature";
  Modelica.Units.SI.Pressure dp;

// Internal
  parameter Modelica.Units.SI.Temperature T_out_start=273.15 + 50;
  Modelica.Blocks.Interfaces.RealOutput T_out(unit="K", start= T_out_start)
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Modelica.Blocks.Interfaces.RealOutput opening_out
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Modelica.Blocks.Math.Gain opening_intern(k=1)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

     Real balance = port_a.m_flow * inStream(port_a.h_outflow) +
 port_v_b.m_flow * (port_v_b.h_outflow) + port_l_b.m_flow * (port_l_b.h_outflow);


  parameter Real Q_intern_start = 0.1;
  Modelica.Units.SI.SpecificEnthalpy h_out;
  Modelica.Units.SI.SpecificEnthalpy h_out_l;
  Modelica.Units.SI.SpecificEnthalpy h_out_v;
  Real Q_intern(max=1, start= Q_intern_start);


//Entropy
  Modelica.Units.SI.SpecificEntropy s_in;
  Modelica.Units.SI.SpecificEntropy s_out_v;
  Modelica.Units.SI.SpecificEntropy s_out_l;
  Modelica.Units.SI.EntropyFlowRate Delta_s "Entropy flow: In - Out";


equation

port_a.p - port_l_b.p = dp;
port_l_b.m_flow + port_v_b.m_flow + port_a.m_flow = 0;

port_a.m_flow = opening_intern.y*k*dp;


port_a.h_outflow = inStream(port_l_b.h_outflow); // change for dummy?
// Isenthalpic state transformation (no storage and no loss of energy)
h_out = inStream(port_a.h_outflow);

h_out = h_out_l*(1-Q_intern) + Q_intern*h_out_v;
h_out_l = Medium_l.specificEnthalpy(Medium_l.setState_pTX(port_l_b.p,T_out,{1}));
h_out_v = Medium_v.specificEnthalpy(Medium_v.setState_pTX(port_v_b.p,T_water_sat,{1}));


// "if" that leads to Non-linear system of equations.
if Q_intern <= 0 then
      h_out = Medium_l.specificEnthalpy(Medium_l.setState_pTX(port_l_b.p,T_out,{1}));
      Q = 0;
      port_v_b.m_flow = 0;
else
      T_out = T_water_sat;
      Q = Q_intern;
      port_v_b.m_flow + Q*port_a.m_flow = 0;
end if;

port_l_b.h_outflow = h_out_l;
port_v_b.h_outflow = h_out_v;

// Entropy
s_in = Medium_l.specificEntropy(Medium_l.setState_phX(port_a.p, inStream(port_a.h_outflow),{1}));
s_out_v = Medium_v.specificEntropy(Medium_v.setState_phX(port_v_b.p, h_out_v, {1}));
s_out_l = Medium_l.specificEntropy(Medium_l.setState_phX(port_l_b.p, h_out_l, {1}));
Delta_s = port_v_b.m_flow*s_out_v +  port_l_b.m_flow*s_out_l + port_a.m_flow*s_in;



  connect(opening, opening_intern.u) annotation (Line(points={{-100,0},{-2,0}},
                     color={0,0,127}));
  connect(opening_intern.y, opening_out) annotation (Line(points={{21,0},{60,0},
          {60,-40},{90,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Polygon(
          points={{-100,100},{0,0},{100,100},{0,100},{-100,100}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1), Polygon(
          points={{0,0},{-100,-100},{0,-100},{100,-100},{0,0}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Valve model which main relationship is given by, <span style=\"font-family: Courier New;\">mass flow rate = valve opening * k * dp </span>with hydraulic conductance <span style=\"font-family: Courier New;\">k&nbsp;=&nbsp;m_flow_nominal/dp_nominal</span></p>
<p>The input signal for the opening valve can be deactivated by setting <span style=\"font-family: Courier New;\">use_opening=false</span>. If deactivated an underterminated model is obtained. The model will then calculate the necessary &quot;opening&quot; given the boundary conditions dp (i.e. pressure at inlet and outlet) and mass flow rate.</p>
</html>"));
end FlashingWater;
