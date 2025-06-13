within Absolut.Basic.Blocks;
model ZeroOrderSingleEffectAHP
  "Zero order single effect absorption heat pump"

  Modelica.Units.SI.Temperature Tei "Low temperature level";
  Modelica.Blocks.Interfaces.RealInput Thi( unit="K") "High temperature level" annotation (Placement(transformation(
          extent={{-100,60},{-60,100}}), iconTransformation(extent={{-100,60},{-60,
            100}})));
  Modelica.Blocks.Interfaces.RealInput Tci( unit="K") "Intermediate temperature level"
  annotation (Placement(transformation(
          extent={{-100,-20},{-60,20}}), iconTransformation(extent={{-100,-20},{
            -60,20}})));

  Modelica.Blocks.Interfaces.RealOutput COP "Heating COP" annotation (Placement(
        transformation(extent={{80,-60},{100,-40}}), iconTransformation(extent={
            {80,-10},{100,10}})));
  Modelica.Blocks.Interfaces.RealOutput EER "Cooling COP" annotation (Placement(transformation(
          extent={{80,40},{100,60}}),  iconTransformation(extent={{80,40},{100,60}})));

  Modelica.Units.SI.HeatFlowRate Qc "Overall heat flow rate at condenser and absorber";
  Modelica.Units.SI.HeatFlowRate Qe "Heat flow rate at evaporator";
  Modelica.Blocks.Interfaces.RealInput Qh( unit="W") "Heat flow rate at generator"
  annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,100}),               iconTransformation(extent={{-20,-20},{20,
            20}},
        rotation=-90,
        origin={-60,100})));

equation

  Qc = Qh + Qe;

  //EER := Tei/Thi;
  //COP := 2*Tc/Th;
  Qe / Qh = (Tei/Thi)*((Thi-Tci)/(Tci-Tei));
  (Thi-Tci) = (Tci-Tei);

  COP = Qc / Qh;
  EER = Qe / Qh;

  annotation (Icon(graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255})}));
end ZeroOrderSingleEffectAHP;
