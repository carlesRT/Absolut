within Absolut.Basic.Blocks;
model EER_CarnotSingleEffectAHP
  "Cooling efficiency EER of a Carnot-based single effect absorption heat pump"

  Modelica.Blocks.Interfaces.RealInput Te( unit="K") "Low temperature level" annotation (Placement(transformation(
          extent={{-100,-100},{-60,-60}}),
                                         iconTransformation(extent={{-100,-100},
            {-60,-60}})));
  Modelica.Blocks.Interfaces.RealOutput EER "Cooling COP" annotation (Placement(transformation(
          extent={{80,40},{100,60}}),  iconTransformation(extent={{80,40},{100,
            60}})));
  Modelica.Blocks.Interfaces.RealInput Tc( unit="K") "Intermediate temperature level" annotation (Placement(transformation(
          extent={{-100,-20},{-60,20}}), iconTransformation(extent={{-100,-20},
            {-60,20}})));
  Modelica.Blocks.Interfaces.RealInput Th( unit="K") "High temperature level" annotation (Placement(transformation(
          extent={{-100,60},{-60,100}}), iconTransformation(extent={{-100,60},{
            -60,100}})));
  Modelica.Blocks.Interfaces.RealOutput COP "Heating COP" annotation (Placement(
        transformation(extent={{80,-60},{100,-40}}), iconTransformation(extent=
            {{80,-10},{100,10}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

protected
  Modelica.Blocks.Sources.RealExpression EER_internal(y=EER) annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  EER = Absolut.Basic.Functions.EER_CarnotSingleEffectAHP_TeThTc(Te, Th, Tc);

  connect(add.y, COP) annotation (Line(points={{41,0},{60,0},{60,-50},{90,-50}},
        color={0,0,127}));


  connect(const.y, add.u2) annotation (Line(points={{-19,-20},{0,-20},{0,-6},{
          18,-6}}, color={0,0,127}));
  connect(EER_internal.y, add.u1) annotation (Line(points={{-19,30},{-2,30},{-2,6},{18,6}}, color={0,0,127}));
  annotation (Icon(graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255})}));
end EER_CarnotSingleEffectAHP;
