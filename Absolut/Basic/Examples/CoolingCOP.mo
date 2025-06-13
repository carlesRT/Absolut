within Absolut.Basic.Examples;
model CoolingCOP
  "Functions are used to replicate Table 2.2 of the book \"Absorption Chillers and Heat Pums\""

  extends Modelica.Icons.Example;

  //
  Real EER_single = Absolut.Basic.Functions.EER_SingleEffectAHP_TeTh(    273.15 + 9.4, 273.15 + 108) "York single effect";
  Real EER_Carnotsingle = Absolut.Basic.Functions.EER_CarnotSingleEffectAHP_TeThTc(    273.15 + 9.1,  273.15 + 108,  273.15 + 34) "York single effect block-based";


  //
  Modelica.Blocks.Sources.Constant Th(k=108 + 273.15)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.Constant Tc(k=34 + 273.15)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant Te(k=9.4 + 273.15)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Blocks.CarnotSingleEffectAHP CarnotSingleEffectAHP
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Real EER_double = Absolut.Basic.Functions.EER_DoubleEffectAHP_TeTh(    273.15 + 9.1,  273.15 + 153.5) "York double effect";
  Real EER_triple = Absolut.Basic.Functions.EER_TripleEffectAHP_TeTh(273.15 + 9.1,  273.15 + 200) "Triple-effect";
  Real EER_half = Absolut.Basic.Functions.EER_HalfEffectAHP_TeTh(273.15 + 9,  273.15 + 80) "Battelle half-effect";

  Modelica.Blocks.Sources.Constant Q(k=1000) "Driving heat in W"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Blocks.ZeroOrderSingleEffectAHP ZeroOrderSingleEffectAHP
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Blocks.ZeroOrderSingleEffectAHP_ext ZeroOrderSingleEffectAHP_w_ext(
    UAe=133,
    UAc=335,
    UAh=200,
    dTh=5) annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
equation
  connect(CarnotSingleEffectAHP.Thi, Th.y) annotation (Line(points={{-18,38},{
          -46,38},{-46,70},{-79,70}},
                                  color={255,0,0}));
  connect(CarnotSingleEffectAHP.Tci, Tc.y)
    annotation (Line(points={{-18,30},{-79,30}}, color={0,0,127}));
  connect(CarnotSingleEffectAHP.Tei, Te.y) annotation (Line(points={{-18,22},{
          -44,22},{-44,-10},{-79,-10}},
                                    color={85,255,255}));
  connect(CarnotSingleEffectAHP.Qh, Q.y)
    annotation (Line(points={{-16,40},{-16,90},{-19,90}}, color={0,0,127}));
  connect(ZeroOrderSingleEffectAHP.Thi, Th.y) annotation (Line(points={{-18,-22},
          {-64,-22},{-64,70},{-79,70}}, color={255,0,0}));
  connect(ZeroOrderSingleEffectAHP.Tci, Tc.y) annotation (Line(points={{-18,-30},
          {-70,-30},{-70,30},{-79,30}}, color={0,0,127}));
  connect(ZeroOrderSingleEffectAHP.Qh, Q.y) annotation (Line(points={{-16,-20},
          {-16,4},{26,4},{26,90},{-19,90}}, color={0,0,127}));
  connect(ZeroOrderSingleEffectAHP_w_ext.Th, Th.y) annotation (Line(points={{
          -18,-62},{-64,-62},{-64,70},{-79,70}}, color={255,0,0}));
  connect(ZeroOrderSingleEffectAHP_w_ext.Tc, Tc.y) annotation (Line(points={{
          -18,-70},{-70,-70},{-70,30},{-79,30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10,
      Interval=1,
      Tolerance=1e-07),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">The implemented zero-order models are used to calculate a cooling COP and are compared to those of the following real machines, as shown in Table 2.2 [1]. The reference values are,</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">York single effect, steam-fired YIA-ST-1A1. COP = 0.736</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">York double effect, steam-fired YPC-ST-14G. COP = 1.23</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Batelle half-effect. COP = 0.35</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Batelle Type II. COP = 0.41</span></li>
</ul>
<p><br>A block-based model is additionally included for the single-effect case. </p>
<p><br><b>References:</b></p>
<p>[1] Keith E. Herold, Reinhard Radermacher, Sanford A. Klein. Absorption chillers and heat pumps. ISBN 978-1-4987-1435-8.</p>
</html>"),
    __Dymola_Commands(
      file="Resources/Basic/COP.mos" "Plot COP", file="Resources/Basic/COPandTemperatures.mos" "Plot COP and Temperatures"));
end CoolingCOP;
