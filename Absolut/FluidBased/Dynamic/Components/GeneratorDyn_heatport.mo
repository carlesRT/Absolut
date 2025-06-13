within Absolut.FluidBased.Dynamic.Components;
model GeneratorDyn_heatport "Generator with heat Transfer"

    replaceable package Medium_v = Modelica.Media.Water.WaterIF97_R2ph;
    replaceable package Medium_l = Absolut.Media.LiBrH2O;

parameter Boolean use_vaporization = false "Add vaporization eq. (dh * der(m_v)) to correct energy balance equation and improve consistency." annotation(Dialog(tab="Advanced"));
parameter Boolean m_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));
parameter Boolean mXLiBr_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));
parameter Boolean U_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));
parameter Boolean p_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));
parameter Boolean T_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));
parameter Boolean XLiBr_state = false "use mass as a state" annotation(Dialog(tab="Advanced"));

 // Start values...
  parameter Modelica.Units.SI.AbsolutePressure p_start= Medium_l.saturationPressure_TX(T_start,1-X_LiBr_start)
    "Initial liquid-vapor equilibrium pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=Medium_l.temperature_Xp(1 -
      X_LiBr_start, p_start) "Initial liquid-vapor equilibrium temperature"
    annotation (Dialog(tab="Initialization"));

//PORTS
  Modelica.Fluid.Interfaces.FluidPort_b port_v(redeclare package Medium =                       Medium_v)
    "Fluid port. Water vapor"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_l_b(redeclare package Medium = Medium_l)
    "Fluid port" annotation (Placement(transformation(extent={{60,-100},{80,-80}}),
        iconTransformation(extent={{60,-100},{80,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_l_a(redeclare package Medium = Medium_l)
    "Fluid port" annotation (Placement(transformation(extent={{-80,-100},{-60,-80}}),
        iconTransformation(extent={{-80,-100},{-60,-80}})));
    // Main variables

  Modelica.Units.SI.AbsolutePressure p(stateSelect = if p_state then StateSelect.always else StateSelect.prefer, start = p_start)
    "Liquid-vapor equilibrium pressure in the vessel";
  Modelica.Units.SI.Temperature T1and2(start = Medium_l.temperature_Xp(1 - X_LiBr_start,p_start));
  Modelica.Units.SI.Temperature T(stateSelect= if T_state then StateSelect.always else StateSelect.prefer, start = T_start)
    "Liquid-vapor equilibrium temperature in the vessel";

  parameter Modelica.Units.SI.MassFraction X_LiBr_start=0.6    annotation(Dialog(tab = "Initialization"));
  Modelica.Units.SI.MassFraction X_H2O(start=1 - X_LiBr_start);
  Modelica.Units.SI.MassFraction X_LiBr(min=0.15, stateSelect= if XLiBr_state then StateSelect.always else StateSelect.prefer, start=X_LiBr_start);
  //Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXi_flow_l_a;
  //Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXi_flow_l_b;
    Modelica.Blocks.Interfaces.RealOutput Hb_flow( unit="W")
    "Heat flow across boundaries or energy source/sink"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  parameter Modelica.Units.SI.ThermalConductance UA(min=0.0001)
    "UA value of HX in W/K";

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

  Modelica.Units.SI.Mass m(stateSelect = if m_state then StateSelect.always else StateSelect.prefer, start = V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start)) + (V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))) "Mass in the vessel";
  Modelica.Units.SI.Mass m_l "Liquid mass of the vessel";
  Modelica.Units.SI.Mass m_v  "Vapor mass in the vessel";
  Modelica.Units.SI.MassFlowRate mb_flow;

   Modelica.Units.SI.Mass[Medium_l.nXi] mXLiBr(each stateSelect = if mXLiBr_state then StateSelect.always else StateSelect.prefer, start= {V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start))*X_LiBr_start});
   Modelica.Units.SI.Mass mH2O(stateSelect = StateSelect.prefer);
   Modelica.Units.SI.MassFlowRate[Medium_l.nXi] mXLiBr_flow_l;
  // Modelica.Units.SI.Mass[Medium_v.nXi] mXi_v;
  // Modelica.Units.SI.MassFlowRate[Medium_v.nXi] mbXi_flow_v;

  Modelica.Units.SI.InternalEnergy U(stateSelect = if U_state then StateSelect.always else StateSelect.prefer, start=V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start))*Medium_l.specificInternalEnergy(Medium_l.setState_pTX(p_start, T_start, X_l_start)) +(V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))*Medium_v.specificInternalEnergy(Medium_v.setState_pTX(p_start, T_start, X_v_start)))
    "Internal energy";
  Modelica.Units.SI.InternalEnergy Ul(stateSelect = StateSelect.prefer, start=V_l_start*Medium_l.density(Medium_l.setState_pTX(p_start, T_start, X_l_start))*Medium_l.specificInternalEnergy(Medium_l.setState_pTX(p_start, T_start, X_l_start)))
    "Internal energy";
   Modelica.Units.SI.InternalEnergy Uv(stateSelect = StateSelect.prefer, start=(V-V_l_start)*Medium_v.density(Medium_v.setState_pTX(p_start, T_start, X_v_start))*Medium_v.specificInternalEnergy(Medium_v.setState_pTX(p_start, T_start, X_v_start)))
    "Internal energy";

  Modelica.Units.SI.Work Wv
    "Work on vapour";

   Modelica.Units.SI.SpecificEnthalpy TdS
    "Work on vapour";
    Modelica.Units.SI.InternalEnergy vap "Vapoeization";

  Modelica.Units.SI.HeatFlowRate Qb_flow
    "Heat flow across boundaries or energy source/sink";

  Medium_v.BaseProperties medium_v(
    p( start=p_start),
    T( start=T_start),
    Xi(start=X_v_start[1:Medium_v.nXi]),
    h(start=Medium_v.specificEnthalpy(Medium_v.setState_pTX(p_start, T_start, X_v_start))))
    "Vapor medium";
  Medium_l.BaseProperties medium_l(
    p(start=p_start),
    T(stateSelect = StateSelect.prefer,start=T_start),
    Xi(each stateSelect = StateSelect.prefer, start=X_l_start[1:Medium_l.nXi]),
    h( start=Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_start, T_start, X_l_start))))
    "Liquid medium";

   // Initialization
  parameter Modelica.Units.SI.MassFraction X_v_start[Medium_v.nX] = {1}
  "Initial X of vapor medium"
    annotation (Dialog(tab="Initialization", enable=Medium_l.nXi > 0));
  parameter Modelica.Units.SI.MassFraction X_l_start[Medium_l.nX] = {1 - X_LiBr_start,X_LiBr_start}
  "Initial X of liquid medium"
    annotation (Dialog(tab="Initialization", enable=Medium_l.nXi > 0));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
  "Heat port"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation

  TdS = T*Medium_l.specificEntropy(Medium_l.setState_pTX(p,T,medium_l.Xi));
  der(Wv) =  p*der(V_v);

  // Common balances
  V_l = crossArea*level;
  V = V_l + V_v;
  m = m_l + m_v;
  //m = mXLiBr*{1} + mH2O;
  m_l = V_l*medium_l.d;
  m_v = V_v*medium_v.d;
  mXLiBr = m_l*({1}-medium_l.Xi);
  mH2O =  m_l*{1}*(medium_l.Xi) + m_v;
   // mXi_v = m_v*medium_v.Xi;
  U = m_l*medium_l.u + m_v*medium_v.u;
  //U = m_l*(medium_l.h +  p/medium_l.d) + m_v*medium_v.u;

  //Ul = m_l*medium_l.h +  m_l*p/medium_l.d;
  Ul = m_l*medium_l.u;
  Uv = m_v*medium_v.u;

  medium_l.p = p;
  medium_v.p = p;
  medium_l.T = T;
  medium_v.T = T;

  Qb_flow = heatPort.Q_flow;
  heatPort.T = T;

  //der(U) = Hb_flow + Qb_flow;
  der(vap) =   (Medium_v.specificEnthalpy(Medium_v.setState_pTX(p,T,{1})) - Medium_l.specificEnthalpy(Medium_l.setState_pTX(p,T,medium_l.Xi)))*der(m_v);

  //der(U) = if use_vaporization then Hb_flow + Qb_flow - der(vap) else  Hb_flow + Qb_flow;
  der(m_l)*medium_l.u + m_l*der(medium_l.u) + der(m_v)*medium_v.u + m_v*der(medium_v.u)= if use_vaporization then  Hb_flow + Qb_flow - der(vap) else Hb_flow + Qb_flow;

  der(m) = mb_flow;
  der(mXLiBr) = mXLiBr_flow_l;
  //der(mXi_v) = mbXi_flow_v;

  // Mass balance
  X_H2O = 1 - X_LiBr;
  medium_l.Xi = {X_H2O};

  port_v.m_flow + port_l_b.m_flow + port_l_a.m_flow = mb_flow;

 // mbXi_flow_v = port_v.m_flow*actualStream(port_v.Xi_outflow);
 // mbXi_flow_l = port_l_b.m_flow*actualStream(port_l_b.Xi_outflow) + port_l_a.m_flow*actualStream(port_l_a.Xi_outflow);
 //   mbXi_flow_v = port_v.m_flow*actualStream(port_v.Xi_outflow);
  mXLiBr_flow_l = port_l_b.m_flow*({1}-actualStream(port_l_b.Xi_outflow)) + port_l_a.m_flow*({1}-actualStream(port_l_a.Xi_outflow));

  // Liquid-vapor equilibrium pressure
  //T = Medium_l.temperature_Xp(X_H2O,p);
  0 = Modelica.Media.Water.WaterIF97_ph.specificGibbsEnergy(Modelica.Media.Water.WaterIF97_ph.setState_pTX(    p=p,    T=T,    X={1}))
  - Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
    T,    X_H2O,    p);

  T1and2 = Medium_l.temperature_Xp(inStream(port_l_a.Xi_outflow)*{1},p);

  // Port pressures
  port_v.p = p;
  port_l_b.p = p;
  port_l_a.p = p;

  // Energy definitions...
  port_v.h_outflow = medium_v.h;
  port_l_b.h_outflow = Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    {X_H2O}));
  port_l_a.h_outflow =  Medium_l.specificEnthalpy(Medium_l.setState_pTX(
    p,
    T,
    inStream(port_l_a.Xi_outflow)));

  //port_l_a.Xi_outflow = {X_H2O};
  //port_l_b.Xi_outflow = {X_H2O};

  Hb_flow = port_l_b.m_flow*actualStream(port_l_b.h_outflow) + port_v.m_flow*actualStream(port_v.h_outflow) + port_l_a.m_flow*actualStream(port_l_a.h_outflow);

  port_v.Xi_outflow = medium_v.Xi;
  port_l_a.Xi_outflow = medium_l.Xi;
  port_l_b.Xi_outflow = medium_l.Xi;

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
end GeneratorDyn_heatport;
