within Absolut.Basic.Blocks;
model Tfiring "Minimum firing temperature"

  Modelica.Blocks.Interfaces.RealInput Te( unit="K") "Low temperature level" annotation (Placement(transformation(
          extent={{-100,-100},{-60,-60}}),
                                         iconTransformation(extent={{-100,-100},
            {-60,-60}})));
  Modelica.Blocks.Interfaces.RealOutput Th(unit "K") "Minimum high temperature level" annotation (Placement(transformation(
          extent={{80,-10},{100,10}}), iconTransformation(extent={{80,-10},{100,
            10}})));
  Modelica.Blocks.Interfaces.RealInput Tc(unit="K") "Intermediate temperature level" annotation (Placement(transformation(
          extent={{-100,60},{-60,100}}), iconTransformation(extent={{-100,-20},{
            -60,20}})));
  Modelica.Blocks.Interfaces.RealInput dT( unit="K") "Heat transfer temperature difference" annotation (Placement(transformation(
          extent={{-100,60},{-60,100}}), iconTransformation(extent={{-100,60},{-60,
            100}})));
equation
  Th = Absolut.Basic.Functions.Tfiring_TeTcdT(Te, Th, dT);

  annotation (Icon(graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255})}), Documentation(info="<html>
<p>See Absolut.Basic.Functions.Tfiring_TeTcdT.</p>
</html>"));
end Tfiring;
