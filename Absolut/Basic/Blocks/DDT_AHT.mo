within Absolut.Basic.Blocks;
model DDT_AHT "Single effect Absorption heat pump"

  Modelica.Blocks.Interfaces.RealInput Tc( unit="K") "Low temperature level. Condenser" annotation (Placement(transformation(
          extent={{-100,-100},{-60,-60}}),
                                         iconTransformation(extent={{-100,-100},
            {-60,-60}})));
  Modelica.Blocks.Interfaces.RealOutput DDT "Characteristic temperature difference" annotation (Placement(transformation(
          extent={{80,-10},{100,10}}), iconTransformation(extent={{80,-10},{100,
            10}})));
  Modelica.Blocks.Interfaces.RealInput Te( unit="K") "Evaporator temperature. Similar to generator temperature" annotation (Placement(transformation(
          extent={{-100,60},{-60,100}}), iconTransformation(extent={{-100,-20},{
            -60,20}})));
  Modelica.Blocks.Interfaces.RealInput Tg(  unit="K") "Generator temperature. Similar to evaporator temperature" annotation (Placement(transformation(
          extent={{-100,20},{-60,60}}),  iconTransformation(extent={{-100,20},{-60,60}})));
  Modelica.Blocks.Interfaces.RealInput Ta(  unit="K") "High temperature. Absorber" annotation (Placement(transformation(
          extent={{-100,-30},{-60,10}}), iconTransformation(extent={{-100,-30},{-60,10}})));

parameter Real B = 1.15 "Duehring parameter. For LiBr-water systems, B tipically has a value between 1.1 and 1.2";

equation
  DDT = Absolut.Basic.Functions.DDT(
    Te,
    Tc,
    Ta,
    Tg,
    B);

  annotation (Icon(graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255})}));
end DDT_AHT;
