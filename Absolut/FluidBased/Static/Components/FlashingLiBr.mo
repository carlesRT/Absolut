within Absolut.FluidBased.Static.Components;
model FlashingLiBr
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
  replaceable package Medium_l = Absolut.Media.LiBrH2O     "liquid"
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
  Modelica.Blocks.Interfaces.RealInput opening if use_opening annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput Q "Quality defined as ratio vapour/liquid"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  Modelica.Units.SI.Temperature T_crist "Check cristalitzation temeperature";
  Boolean crist "true if cristalitzation occurs";
  Modelica.Units.SI.Temperature T_out_intern(start=T_out_start) "..";
  Modelica.Units.SI.Pressure dp "start";
  parameter Modelica.Units.SI.MassFraction X_LiBr_start = 0.6;
  parameter Modelica.Units.SI.Temperature T_out_start= 273.15 + 50     annotation(Dialog(tab = "Initialization"));
  parameter Modelica.Units.SI.Pressure p_out_start= 57000     annotation(Dialog(tab = "Initialization"));
  Modelica.Units.SI.MassFraction X_LiBr_out(start=X_LiBr_start);
  Modelica.Units.SI.MassFraction X_LiBr_in(start=X_LiBr_start);
  Modelica.Units.SI.MassFraction X_LiBr_out_intern(start=X_LiBr_start);

  Modelica.Units.SI.Temperature T_out_intern_auxiliar;

// Internal
  Modelica.Blocks.Interfaces.RealOutput T_out(unit="K", start=T_out_start)
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Modelica.Blocks.Interfaces.RealOutput opening_out
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Modelica.Blocks.Math.Gain opening_intern(k=1, u(start=1))
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));


 Real balance = port_a.m_flow * inStream(port_a.h_outflow) +
 port_v_b.m_flow * (port_v_b.h_outflow) + port_l_b.m_flow * (port_l_b.h_outflow);

parameter Real Q_intern_start = 0.05     annotation(Dialog(tab = "Initialization"));


  Modelica.Units.SI.SpecificEnthalpy h_out;
  Modelica.Units.SI.SpecificEnthalpy h_in;
  Modelica.Units.SI.SpecificEnthalpy h_out_l( start = h_out_l_start);
  //Modelica.Units.SI.SpecificEnthalpy h_out_l;
  parameter Modelica.Units.SI.SpecificEnthalpy h_out_l_start = Medium_l.specificEnthalpy_SSC_TXp(T_out_start, 1-X_LiBr_start, p_out_start)     annotation(Dialog(tab = "Initialization"));


  Modelica.Units.SI.SpecificEnthalpy h_out_v;
  Real Q_intern(min=0,max=1, start=Q_intern_start);


  //Entropy
  Modelica.Units.SI.SpecificEntropy s_in;
  Modelica.Units.SI.SpecificEntropy s_out_v;
  Modelica.Units.SI.SpecificEntropy s_out_l;
  Modelica.Units.SI.EntropyFlowRate Delta_s "Entropy flow: In - Out";


equation
T_crist = Medium_l.crystallizationtemperature_X(1 - X_LiBr_out);
crist =  if T_out < T_crist then true else false;

port_a.p - port_l_b.p = dp;
port_l_b.m_flow + port_v_b.m_flow + port_a.m_flow = 0;
port_a.m_flow = opening_intern.u*k*dp;

port_a.Xi_outflow  = inStream(port_l_b.Xi_outflow); // change for dummy?
X_LiBr_in = 1 - scalar(inStream(port_a.Xi_outflow));
port_l_b.Xi_outflow = {1-X_LiBr_out};

// Isenthalpic state transformation (no storage and no loss of energy)
port_a.h_outflow = inStream(port_l_b.h_outflow); // change for dummy?
h_in = inStream(port_a.h_outflow);
h_out = inStream(port_a.h_outflow);

h_out = h_out_l*(1-Q_intern) + Q_intern*h_out_v;

h_out_l = Medium_l.specificEnthalpy_SSC_TXp(T_out_intern, 1-X_LiBr_out_intern, port_l_b.p);
h_out_v = Medium_v.specificEnthalpy(Medium_v.setState_pTX(port_l_b.p, T_out_intern, {1}));

port_v_b.h_outflow = h_out_v; //Either intern is used (Q>0) or not at all (Q=0)

//port_l_b.h_outflow = Buildings.Utilities.Math.Functions.regStep(Q_intern,h_out_l,h_out, 0.00001);
port_l_b.h_outflow = Medium_l.specificEnthalpy_SSC_TXp(T_out, 1-X_LiBr_out, port_l_b.p);

// Option A use of temperautre_Xp or option B, directly write eq. and let Dymola move parts.
//T_out_intern = Medium_l.temperature_Xp(1 - X_LiBr_out_intern, port_l_b.p);
Modelica.Media.Water.WaterIF97_ph.specificGibbsEnergy(Modelica.Media.Water.WaterIF97_ph.setState_pTX(p=port_l_b.p, T=T_out_intern, X={1})) = Medium_l.chemicalPotential_w_TXp(T_out_intern,1-X_LiBr_out_intern,port_l_b.p);

Q_intern = max(0,min(1,(X_LiBr_out_intern - X_LiBr_in)/X_LiBr_out_intern));

// Medium_l.temperature_hXp(h_out,1-X_LiBr_out,port_l_b.p)
h_out = Medium_l.specificEnthalpy_SSC_TXp(T_out_intern_auxiliar,1-X_LiBr_out,port_l_b.p);

//port_v_b.m_flow = Buildings.Utilities.Math.Functions.regStep(Q_intern,-Q*port_a.m_flow,0, 0.00001);
port_v_b.m_flow = -Q*port_a.m_flow;

if Q_intern <= 0 then
      Q = 0;
      X_LiBr_out = X_LiBr_in;
      h_out = Medium_l.specificEnthalpy_SSC_TXp(T_out,1-X_LiBr_out,port_l_b.p);
else
      Q = Q_intern;
      T_out = T_out_intern;
      X_LiBr_out = X_LiBr_out_intern;
end if;

// ENTROPY
s_in = Medium_l.specificEntropy(Medium_l.setState_phX(port_a.p, inStream(port_a.h_outflow),{1-X_LiBr_in, X_LiBr_in}));
s_out_v = Medium_v.specificEntropy(Medium_v.setState_pTX(port_l_b.p, T_out, {1}));
s_out_l = Medium_l.specificEntropy(Medium_l.setState_pTX(port_l_b.p, T_out, {1-X_LiBr_out, X_LiBr_out}));
Delta_s = port_v_b.m_flow*s_out_v +  port_l_b.m_flow*s_out_l + port_a.m_flow*s_in;






  connect(opening_intern.y,opening_out)  annotation (Line(points={{21,0},{60,0},
          {60,-40},{90,-40}}, color={0,0,127}));
  connect(opening,opening_intern. u) annotation (Line(points={{-100,0},{-2,0}},
                          color={0,0,127}));
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
</html>"),
    experiment(
      StopTime=100,
      Interval=0.1,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"));
end FlashingLiBr;
