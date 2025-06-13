within Absolut.FluidBased.Static.Components.Validation;
model FlashingLiBr
  extends Modelica.Icons.Example;

  package Medium_l = Absolut.Media.LiBrH2O;
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT annotation (
     __Dymola_choicesAllMatching=true);

  parameter Modelica.Units.SI.Temperature T_start_Book[7]={91 + 273.15,90 +
      273.15,80 + 273.15,70 + 273.15,60 + 273.15,50 + 273.15,45 + 273.15}
    "Inflow temperature";
  parameter Modelica.Units.SI.Temperature T_end_Book[7]={49.8 + 273.15,49.7 +
      273.15,48.8 + 273.15,47.9 + 273.15,47.1 + 273.15,46.3 + 273.15,45 +
      273.15} "Outlet temperature";
  parameter Real h_end_Book[7](each unit="J/g")={216.9, 214.9, 195.4, 175.9, 156.5, 137.3, 127.7} "Outflow specific enthalpy";
  parameter Real XLiBr_Book[7] = {0.6178, 0.6174, 0.6133, 0.6094, 0.6054, 0.6016, 0.6} "Fraction of LiBr";
  parameter Real Q_Book[7] = {0.0288, 0.0281, 0.0217, 0.0154, 0.009, 0.0026, 0} "Fraction of vapor";

  Modelica.Blocks.Sources.RealExpression OpeningSignal(y=1)
    annotation (Placement(transformation(extent={{-78,-44},{-38,-24}})));

  Absolut.FluidBased.Static.Components.FlashingLiBr flashingLiBr(
    redeclare package Medium_l = Medium_l,
    redeclare package Medium_v = Medium_v,
    dp_nominal(displayUnit="Pa") = 9000,
    m_flow_nominal=1)
    annotation (Placement(transformation(extent={{2,-44},{22,-24}})));
  Modelica.Fluid.Sources.MassFlowSource_T source(
    redeclare package Medium = Medium_l,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=1,
    X={0.4,0.6},
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-8,12})));
  Modelica.Fluid.Sources.FixedBoundary sink_v(
    redeclare package Medium = Medium_v,
    p(displayUnit="kPa") = 1000,
    nPorts=1) annotation (Placement(transformation(extent={{62,-74},{42,-54}})));
  Modelica.Fluid.Sources.FixedBoundary sink_l(
    redeclare package Medium = Medium_l,
    p(displayUnit="kPa") = 1000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-38,-74},{-18,-54}})));

  Modelica.Blocks.Sources.CombiTimeTable ReferenceData(table=[0.0,T_start_Book[
        1],T_end_Book[1],h_end_Book[1],Q_Book[1]; 60,T_start_Book[1],T_end_Book[
        1],h_end_Book[1],Q_Book[1]; 60,T_start_Book[2],T_end_Book[2],h_end_Book[
        2],Q_Book[2]; 120,T_start_Book[2],T_end_Book[2],h_end_Book[2],Q_Book[2];
        120,T_start_Book[3],T_end_Book[3],h_end_Book[3],Q_Book[3]; 180,
        T_start_Book[3],T_end_Book[3],h_end_Book[3],Q_Book[3]; 180,T_start_Book[
        4],T_end_Book[4],h_end_Book[4],Q_Book[4]; 240,T_start_Book[4],
        T_end_Book[4],h_end_Book[4],Q_Book[4]; 240,T_start_Book[5],T_end_Book[5],
        h_end_Book[5],Q_Book[5]; 300,T_start_Book[5],T_end_Book[5],h_end_Book[5],
        Q_Book[5]; 300,T_start_Book[6],T_end_Book[6],h_end_Book[6],Q_Book[6];
        360,T_start_Book[6],T_end_Book[6],h_end_Book[6],Q_Book[6]; 360,
        T_start_Book[7],T_end_Book[7],h_end_Book[7],Q_Book[7]; 420,T_start_Book[
        7],T_end_Book[7],h_end_Book[7],Q_Book[7]],
                        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-78,26},{-58,46}})));

   Modelica.Blocks.Math.Gain T_out_ref(k=1, y(unit="K"))
    annotation (Placement(transformation(extent={{-32,40},{-14,58}})));
   Modelica.Blocks.Math.Gain h_out_ref(k=1000, y(unit="J/kg"))
    annotation (Placement(transformation(extent={{-32,74},{-14,92}})));
equation
  connect(source.ports[1], flashingLiBr.port_a)
    annotation (Line(points={{2,12},{12,12},{12,-25}}, color={0,127,255}));
  connect(sink_l.ports[1], flashingLiBr.port_l_b) annotation (Line(points={{-18,
          -64},{7.2,-64},{7.2,-43}}, color={0,127,255}));
  connect(flashingLiBr.port_v_b, sink_v.ports[1])
    annotation (Line(points={{17,-43},{17,-64},{42,-64}}, color={0,127,255}));
  connect(OpeningSignal.y, flashingLiBr.opening)
    annotation (Line(points={{-36,-34},{2,-34}}, color={0,0,127}));
  connect(ReferenceData.y[1], source.T_in) annotation (Line(points={{-57,36},{-38,
          36},{-38,8},{-20,8}}, color={0,0,127}));
  connect(ReferenceData.y[2], T_out_ref.u) annotation (Line(points={{-57,36},{-38,
          36},{-38,49},{-33.8,49}}, color={0,0,127}));
  connect(ReferenceData.y[3], h_out_ref.u) annotation (Line(points={{-57,36},{-50,
          36},{-50,83},{-33.8,83}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model validation of trhottling valve for water-LiBr based on example 4.8 on throttling Aqueous Lithium Bromide of [1]. </p>
<p>Pressure at the valve are fixed to 10 kPa (entrance) and 1 kPa (exit). The solution mass fraction is equal to 0.6, and the inlet temperature range from the saturation temperature down to sufficient subcooling to ensure that the outlet state is still subcooled. </p>
<p>A total of seven data points are defined. With help of a combitimetable, the data point evaluated is changed every 60 seconds. </p>
<p><br><b>References:</b></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
    experiment(
      StopTime=420,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Resources\Static\Components\Validation\FlashingLiBr.mos"
        "Simulate and plot"));
end FlashingLiBr;
