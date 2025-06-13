within Absolut.FluidBased.Static.DoubleEffect;
model LowGeneratorStatic_serie
  "Generator model for serie double effect with high pressure desorber first"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph;
    replaceable package Medium_l = Absolut.Media.LiBrH2O;

 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start= Medium_l.saturationPressure_TX(T_start,1 - X_LiBr_start)
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=Medium_l.temperature_Xp(1 -
      X_LiBr_start, p_start) "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));

//PORTS
  Modelica.Fluid.Interfaces.FluidPort_b port_v(redeclare package Medium = Medium_v)
    "Fluid port. Water vapor"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}}),iconTransformation(extent={{-100,20},
            {-80,40}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_l_b(redeclare package Medium = Medium_l)
    "Fluid port" annotation (Placement(transformation(extent={{60,-100},{80,-80}}),
        iconTransformation(extent={{60,-100},{80,-80}})));
    // Main variables

  Modelica.Units.SI.AbsolutePressure p( start=p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T( start = T_start)
    "Liquid-vapor equilibrium temperature in the vessel";

  extends Absolut.FluidBased.Static.BaseClasses.MTD(usedT_log=false);

  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001)
    "UA value of HX in W/K";

  Modelica.Units.SI.SpecificEnthalpy h_v_out;
  Modelica.Units.SI.SpecificEnthalpy h_l_out;

  parameter Modelica.Units.SI.MassFraction X_LiBr_start=0.6;
  Modelica.Units.SI.MassFraction X_H2O(start=1 - X_LiBr_start);
  Modelica.Units.SI.MassFraction X_LiBr(start=X_LiBr_start);
  Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXi_flow_l;
  Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXi_flow_l_b;

  Modelica.Fluid.Interfaces.FluidPort_a port_l_high(redeclare package Medium =
        Medium_l) "Fluid port" annotation (Placement(transformation(extent={{20,
            80},{40,100}}), iconTransformation(extent={{40,80},{60,100}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_v_high(redeclare package Medium =
        Medium_v) "Fluid port" annotation (Placement(transformation(extent={{80,
            80},{100,100}}), iconTransformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Interfaces.RealOutput Hb_flow(unit="W")
    "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Interfaces.RealInput T_c(unit="K") "Temperature"
    annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  Modelica.Blocks.Interfaces.RealInput Hb_flow_in(unit="W")
    "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{100,-50},{80,-30}})));
equation
  // Mass balance
  X_H2O = 1 - X_LiBr;
  port_v.m_flow + port_l_b.m_flow + port_l_high.m_flow + port_v_high.m_flow = 0;

  mXi_flow_l = port_l_high.m_flow * inStream(port_l_high.Xi_outflow);
  mXi_flow_l_b = port_l_b.m_flow*{X_H2O};
  port_v.m_flow*{1} + port_v_high.m_flow*{1} + mXi_flow_l + mXi_flow_l_b = zeros(Medium_l.nXi);

  // Liquid-vapor equilibrium pressure
  //T = Medium_l.temperature_Xp(X_H2O,p);
  0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(p, T, X={1})) - Medium_l.chemicalPotential_w_TXp(T,X_H2O,p);
  //0 = Medium_v.specificGibbsEnergy(Medium_v.setState_pTX(p, T1and2, X={1})) - Medium_l.chemicalPotential_w_TXp(T1and2,X_H2O,p);
  // Port pressures
  port_v.p = p;
  port_l_b.p = p;
  port_l_high.p = p;
  port_v_high.p = p;

  // Energy definitions...
  port_v.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p, T, {1}));
  port_v_high.h_outflow = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p, T, {1}));
  port_l_b.h_outflow = Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    {X_H2O}));
  port_l_high.h_outflow =  Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    inStream(port_l_high.Xi_outflow)));

  h_v_out = actualStream(port_v.h_outflow);
  h_l_out = actualStream(port_l_b.h_outflow);

  port_l_high.Xi_outflow = {X_H2O};
  port_l_b.Xi_outflow = {X_H2O};

  Hb_flow = port_l_b.m_flow*actualStream(port_l_b.h_outflow) + port_v.m_flow*actualStream(port_v.h_outflow) + port_l_high.m_flow*actualStream(port_l_high.h_outflow) + port_v_high.m_flow*actualStream(port_v_high.h_outflow);


  dT1 = T_c - T;
  dT2 = T_c - T;
  -Hb_flow = UA*dT_used;
  Hb_flow_in = Hb_flow;

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
<p>Model of a simple <b>evaporator (or condenser)</b> with two states where water is the evaporating or condensing medium. The model assumes two-phase equilibrium inside the component, i.e. the vapor (liquid) that exits the evaporator (condenser) is at saturated state. The flow properties are computed from the upstream quantities, pressures are equal in all nodes. Heat transfer through a thermal port is possible, it equals zero if the port remains unconnected. Ideal heat transfer is assumed per default; the thermal port temperature is equal to the medium temperature.</p>
</html>", revisions=""));
end LowGeneratorStatic_serie;
