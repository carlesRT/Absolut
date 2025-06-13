within Absolut.FluidBased.Static.Components.Validation;
model PumpLiBr
  extends Modelica.Icons.Example;

//Reference data
  parameter Modelica.Units.SI.Pressure p_in = 676 "Pressure at the inlet";
  parameter Modelica.Units.SI.Pressure p_out = 7406 "Pressure at the outlet";
  parameter Modelica.Units.SI.Temperature T_in = 273.15+32.72 "Inlet temperature";
  parameter Modelica.Units.SI.MassFraction XLiBr_in = 0.5648 "Concentration at the inlet";
  parameter Modelica.Units.SI.MassFlowRate m_dot = 0.05 "Mass flow rate";
  parameter Modelica.Units.SI.Power P= 0.205 "Pump power. To be compared with W_p";


  Pump            pump(redeclare package Medium_l = Medium, T_in_start=T_in)
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,10})));
  Modelica.Fluid.Sources.FixedBoundary sink_abs(
    redeclare package Medium = Medium,
    T=T_in,
    X={1 - XLiBr_in,XLiBr_in},
    nPorts=1,
    p(displayUnit= "Pa") = 676)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Fluid.Sources.FixedBoundary sink_gen(
    redeclare package Medium = Medium,
    T=T_in,
    X={1 - XLiBr_in,XLiBr_in},
    nPorts=1,
    p(displayUnit="Pa") = 7406)
    annotation (Placement(transformation(extent={{40,40},{20,60}})));

  replaceable package Medium = Absolut.Media.LiBrH2O  constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);

  Modelica.Blocks.Sources.Constant prescribed_m_dot(k=m_dot)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(sink_abs.ports[1], pump.port_l_a) annotation (Line(points={{-20,-30},{
          -1.16573e-15,-30},{-1.16573e-15,1}}, color={0,127,255}));
  connect(pump.port_l_b, sink_gen.ports[1])
    annotation (Line(points={{0,19},{0,50},{20,50}}, color={0,127,255}));
  connect(prescribed_m_dot.y, pump.m_dot_in)
    annotation (Line(points={{-39,10},{-10,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model validation of pump model for water-LiBr based on data of table 6.1 [1]. </p>
<p><br><br><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
    __Dymola_Commands(file="Resources\Static\Components\Validation\PumpLiBr.mos" "Plot"));
end PumpLiBr;
