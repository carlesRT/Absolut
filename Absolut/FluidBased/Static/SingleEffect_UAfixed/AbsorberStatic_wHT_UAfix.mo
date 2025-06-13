within Absolut.FluidBased.Static.SingleEffect_UAfixed;
model AbsorberStatic_wHT_UAfix "Absorber with heat Transfer"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2pT;
    replaceable package Medium_l = Absolut.Media.LiBrH2O;
    replaceable package Medium_ext = Modelica.Media.Water.WaterIF97_R1pT
    annotation (__Dymola_choicesAllMatching=true);

 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start = Medium_l.saturationPressure_TX(T_start,1 - X_LiBr_start)
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
Modelica.Fluid.Interfaces.FluidPort_a port_v_a(redeclare package Medium =
        Medium_v) "Fluid port" annotation (Placement(transformation(extent={{80,
            20},{100,40}}), iconTransformation(extent={{80,20},{100,40}})));

  Modelica.Units.SI.Temperature T(start=T_start)
    "Liquid-vapor equilibrium temperature in the vessel";

  Modelica.Units.SI.MassFraction X_H2O(start=1 - X_LiBr_start)
    "Water content in solution";

// Internal ...
   Modelica.Blocks.Interfaces.RealOutput X_LiBr( unit="1", min = 0, max = 1, start=X_LiBr_start);

    Modelica.Blocks.Interfaces.RealOutput p(unit="Pa", start=p_start)
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

 Modelica.Units.SI.Temperature T_13(start=318.15) "Inflow temperaure of external fluid";
 Modelica.Units.SI.Temperature T_14(start=323.15)
    "Leaving temperaure of external fluid";
 Modelica.Units.SI.Temperature T_6
    "Solution temperature of entering solution 6";
 Modelica.Units.SI.Temperature T_aux(start = Modelica.Media.Water.WaterIF97_ph.saturationTemperature(p_start))= Modelica.Media.Water.WaterIF97_ph.saturationTemperature(p)
    "Auxiliary temperature, for plotting purposes. Saturation temperature at start pressure p_start";


  extends Absolut.FluidBased.Static.BaseClasses.MTD;

  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001) = 1800  "in W/K";

 Real balance = (port_l_b.m_flow * (port_l_b.h_outflow) + port_l_a.m_flow * inStream(port_l_a.h_outflow))
 + (port_v.m_flow * inStream(port_v.h_outflow) + port_v_a.m_flow * inStream(port_v_a.h_outflow))
 + (port_b_ext.m_flow * (port_b_ext.h_outflow) + port_a_ext.m_flow * inStream(port_a_ext.h_outflow));

 Real balance_mass = port_l_b.m_flow + port_l_a.m_flow + port_v.m_flow  + port_v_a.m_flow + port_b_ext.m_flow + port_a_ext.m_flow;

 Modelica.Units.SI.MassFlowRate m2=port_v.m_flow + port_v_a.m_flow;

//Entropy
  Modelica.Units.SI.SpecificEntropy s_in_v;
  Modelica.Units.SI.SpecificEntropy s_in_l;
  Modelica.Units.SI.SpecificEntropy s_out_v;
  Modelica.Units.SI.SpecificEntropy s_out_l;
  Modelica.Units.SI.EntropyFlowRate Delta_s;

  parameter Boolean use_X_LiBr_in = false;
  parameter Boolean use_p_in = false;

  Modelica.Blocks.Interfaces.RealInput X_LiBr_in if use_X_LiBr_in "X_LiBr content in solution"
    annotation (Placement(transformation(extent={{20,70},{60,110}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-80})));
  Modelica.Blocks.Interfaces.RealInput p_in if use_p_in "Pressure of vessel"
    annotation (Placement(transformation(extent={{68,70},{108,110}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,-80})));
equation
  connect(p, p_in);
  connect(X_LiBr, X_LiBr_in);

  // Mass balance
  X_H2O = 1 - X_LiBr;

  //T = Medium_l.temperature_Xp(X_H2O,p);
  0 = Modelica.Media.Water.WaterIF97_ph.specificGibbsEnergy(Modelica.Media.Water.WaterIF97_ph.setState_pTX(p=p, T=T, X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(T,X_H2O,p);

  T_6 = Medium_l.temperature_hXp(inStream(port_l_a.h_outflow), inStream(port_l_a.Xi_outflow)*{1},p);
  //0 = inStream(port_l_a.h_outflow) - Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(T=T_6, X_H2O=inStream(port_l_a.Xi_outflow)*{1}, p=p);

  // Port pressures,
  port_v.p = p;
  port_l_b.p = p;
  port_l_a.p = p;
  port_v_a.p = p;

  //No pressure drop trough HX.
  port_a_ext.p = port_b_ext.p;
  port_a_ext.m_flow + port_b_ext.m_flow = 0;

  // Energy definitions...
  port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1}));
  port_v_a.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1}));
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

  Hb_flow = port_l_b.m_flow*actualStream(port_l_b.h_outflow) + port_v_a.m_flow*actualStream(port_v_a.h_outflow) + port_v.m_flow*actualStream(port_v.h_outflow) + port_l_a.m_flow*actualStream(port_l_a.h_outflow);

  T_13 = Medium_ext.temperature(Medium_ext.setState_phX(port_a_ext.p, inStream(port_a_ext.h_outflow), {1}));
  dT1 = T_6 - T_14;
  dT2 = T - T_13;

  Hb_flow = UA*dT_used;
  Hb_flow = port_a_ext.m_flow * (port_b_ext.h_outflow - inStream(port_a_ext.h_outflow));

// Entropy
s_in_v  = Medium_v.specificEntropy(Medium_v.setState_phX(port_v_a.p, inStream(port_v_a.h_outflow),  {1}));
s_in_l  = Medium_l.specificEntropy(Medium_l.setState_phX(port_l_a.p, inStream(port_l_a.h_outflow),  inStream(port_l_a.Xi_outflow)));
s_out_v = Medium_v.specificEntropy(Medium_v.setState_phX(port_v.p, port_v.h_outflow, {1}));
s_out_l = Medium_l.specificEntropy(Medium_l.setState_phX(port_l_b.p, port_l_b.h_outflow, {1-X_LiBr, X_LiBr}));
Delta_s = port_v.m_flow*s_out_v +  port_l_b.m_flow*s_out_l + port_l_a.m_flow*s_in_l + port_v_a.m_flow*s_in_v;

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
end AbsorberStatic_wHT_UAfix;
