within Absolut.Basic.Blocks;
model EER_DoubleEffectAHP
  "Cooling efficiency EER of a zero order model of a double effect Absorption heat pump"

  Modelica.Blocks.Interfaces.RealInput Te( unit="K") "Low temperature level" annotation (Placement(transformation(
          extent={{-100,-100},{-60,-60}}),
                                         iconTransformation(extent={{-100,-100},
            {-60,-60}})));
  Modelica.Blocks.Interfaces.RealOutput EER "Cooling COP" annotation (Placement(transformation(
          extent={{80,-10},{100,10}}), iconTransformation(extent={{80,-10},{100,
            10}})));
  Modelica.Blocks.Interfaces.RealInput Th( unit="K") "High temperature level" annotation (Placement(transformation(
          extent={{-100,60},{-60,100}}), iconTransformation(extent={{-100,60},{-60,
            100}})));
equation
  EER = Absolut.Basic.Functions.EER_DoubleEffectAHP_TeTh(Te, Th);

  annotation (Icon(graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255})}));
end EER_DoubleEffectAHP;
