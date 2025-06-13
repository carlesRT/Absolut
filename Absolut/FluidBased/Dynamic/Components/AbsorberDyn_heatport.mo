within Absolut.FluidBased.Dynamic.Components;
model AbsorberDyn_heatport "Absorber with heat Transfer"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2pT;
    replaceable package Medium_l = Absolut.Media.LiBrH2O;

 parameter Boolean use_vaporization = false  "Add vaporization eq. (dh * der(m_v)) to correct energy balance equation and improve consistency." annotation(Dialog(tab="Advanced"));
 parameter Boolean m_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));
 parameter Boolean mXLiBr_state = false "use LiBr mass as a state" annotation(Dialog(tab="Advanced"));
 parameter Boolean U_state = false "use U as a state" annotation(Dialog(tab="Advanced"));
 parameter Boolean p_state = false "use p as a state" annotation(Dialog(tab="Advanced"));

 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start = Medium_l.saturationPressure_TX(T_start,X_LiBr_start)
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start= Medium_l.temperature_Xp(1 -
      X_LiBr_start, p_start) "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.MassFraction X_LiBr_start = 0.458
    "Water content in solution" annotation ( Dialog(tab="Initialization"));

  parameter Modelica.Units.SI.MassFraction X_v_start[Medium_v.nX] = {1}
  "Initial X of vapor medium"
    annotation (Dialog(tab="Initialization", enable=Medium_l.nXi > 0));
  parameter Modelica.Units.SI.MassFraction X_l_start[Medium_l.nX] = {1 - X_LiBr_start, X_LiBr_start}
  "Initial X of liquid medium"
    annotation (Dialog(tab="Initialization", enable=Medium_l.nXi > 0));

      // Tank geometry
  parameter Modelica.Units.SI.Height height = 0.1 "Height of vessel";
  parameter Modelica.Units.SI.Area crossArea = 0.5 "Area of vessel";
  final parameter Modelica.Units.SI.Volume V = height*crossArea "Volume of vessel";

  parameter Modelica.Units.SI.Volume V_l_start(min=0, max=V) = 0.5*V
  "Initial volume of the liquid medium"
    annotation(Dialog(tab = "Initialization"));

  Modelica.Units.SI.Volume V_l(min=0, max=V, start=V_l_start) "Liquid volume of the vessel";
  Modelica.Units.SI.Volume V_v(min=0, max=V, start=V-V_l_start) "Vapor volume of the vessel";
  Modelica.Units.SI.Height level "Level of liquid in the vessel";

  Modelica.Units.SI.Mass m( stateSelect = if m_state then StateSelect.always else StateSelect.prefer, start = V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start)) + (V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))) "Mass in the vessel";
  Modelica.Units.SI.Mass m_l "Liquid mass of the vessel";
  Modelica.Units.SI.Mass m_v "Vapor mass in the vessel";
  Modelica.Units.SI.MassFlowRate mb_flow;

   Modelica.Units.SI.Mass[Medium_l.nXi] mXLiBr(each stateSelect= if mXLiBr_state then StateSelect.always else StateSelect.prefer, start= {V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start))*X_LiBr_start});
   Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXLiBr_flow_l;
   Modelica.Units.SI.Mass mH2O;

  Modelica.Units.SI.InternalEnergy U(stateSelect = if U_state then StateSelect.always else StateSelect.prefer, start=V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start))*Medium_l.specificInternalEnergy(Medium_l.setState_pTX(p_start, T_start, X_l_start)) +(V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))*Medium_v.specificInternalEnergy(Medium_v.setState_pTX(p_start, T_start, X_v_start)))
    "Internal energy";

  Modelica.Units.SI.HeatFlowRate Qb_flow
    "Heat flow across boundaries or energy source/sink";

      Modelica.Units.SI.InternalEnergy vap "Vapoeization";

        Modelica.Units.SI.Work Wv
    "Work on vapour";

   Modelica.Units.SI.SpecificEnthalpy TdS
    "T dS";

  Medium_v.BaseProperties medium_v(
    p(start=p_start),
    T(start=T_start),
    Xi(start=X_v_start[1:Medium_v.nXi]),
    h(start=Medium_v.specificEnthalpy(Medium_v.setState_pTX(p_start, T_start, X_v_start))))
    "Vapor medium";
  Medium_l.BaseProperties medium_l(
    p(start=p_start, stateSelect = StateSelect.prefer),
    T(start=T_start, stateSelect = StateSelect.prefer),
    Xi(start=X_l_start[1:Medium_l.nXi], each stateSelect = StateSelect.prefer),
    h(start=Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_start, T_start, X_l_start))))
    "Liquid medium";

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
  Modelica.Units.SI.MassFraction X_LiBr(min=0.1, start=X_LiBr_start);
  Modelica.Units.SI.AbsolutePressure p(stateSelect = if p_state then StateSelect.always else StateSelect.prefer, start=p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W") "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Modelica.Units.SI.Temperature T_6
    "Solution temperature of entering solution 6";
  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001) = 1800 "in W/K";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
  "Heat port"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  assert(V_l <= V, "Volume of liquid reaches the volume of the vessel");
  assert(V_l >= 0, "Volume of liquid reaches must be >=0");

  TdS = T*Medium_l.specificEntropy(Medium_l.setState_pTX(p,T,medium_l.Xi));
  der(Wv) =  p*der(V_v);

  // Total quantities
  V_l = crossArea*level;
  V = V_l + V_v;
  //m = m_l + m_v;
  m = mXLiBr*{1} + mH2O;
  m_l = V_l*medium_l.d;
  m_v = V_v*medium_v.d;
  mXLiBr = m_l*({1}-medium_l.Xi);
  mH2O =  m_l*{1}*(medium_l.Xi) + m_v;
  U = m_l*medium_l.u + m_v*medium_v.u;

  medium_l.p = p;
  medium_v.p = p;
  medium_l.T = T;
  medium_v.T = T;

  Qb_flow = heatPort.Q_flow;
  heatPort.T = T;

  der(vap) =   (Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1})) - Medium_l.specificEnthalpy(Medium_l.setState_pTX(p,T,medium_l.Xi)))*der(m_v);

  //der(U) = Hb_flow + Qb_flow;
  der(m_l)*medium_l.u + m_l*der(medium_l.u) + der(m_v)*medium_v.u + m_v*der(medium_v.u)= if use_vaporization then  Hb_flow + Qb_flow - der(vap) else Hb_flow + Qb_flow;

  der(m) = mb_flow;
  der(mXLiBr) = mXLiBr_flow_l;

  mb_flow = port_v.m_flow + port_l_a.m_flow + port_v_a.m_flow + port_l_b.m_flow;
  mXLiBr_flow_l = port_l_a.m_flow*({1}-actualStream(port_l_a.Xi_outflow)) + port_l_b.m_flow*({1}-actualStream(port_l_b.Xi_outflow));

  // Mass balance
  X_H2O = 1 - X_LiBr;
  medium_l.Xi = {X_H2O};

  //T = Medium_l.temperature_Xp(X_H2O,p);
  0 =Modelica.Media.Water.WaterIF97_ph.specificGibbsEnergy(
    Modelica.Media.Water.WaterIF97_ph.setState_pTX(
    p=p,
    T=T,
    X={1})) - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,
    X_H2O,
    p);

  T_6 = Medium_l.temperature_hXp(inStream(port_l_a.h_outflow), inStream(port_l_a.Xi_outflow)*{1},p);
  //inStream(port_l_a.h_outflow) = Medium_l.specificEnthalpy_SSC_TXp(T_6,inStream(port_l_a.Xi_outflow)*{1},p);

  // Port pressures,
  port_v.p = p;
  port_v_a.p = p;
  port_l_b.p = p;
  port_l_a.p = p;

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

  port_v.Xi_outflow = medium_v.Xi;
  port_v_a.Xi_outflow = medium_v.Xi;
  port_l_a.Xi_outflow = {X_H2O};
  port_l_b.Xi_outflow = {X_H2O};

  Hb_flow = port_l_b.m_flow*actualStream(port_l_b.h_outflow) + port_v_a.m_flow*actualStream(port_v_a.h_outflow) + port_v.m_flow*actualStream(port_v.h_outflow) + port_l_a.m_flow*actualStream(port_l_a.h_outflow);

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
end AbsorberDyn_heatport;
